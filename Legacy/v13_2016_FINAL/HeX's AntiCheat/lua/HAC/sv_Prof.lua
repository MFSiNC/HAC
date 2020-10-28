
HAC.Prof = {
	SKReason 	= "",
	Temp 		= {},
}


local function DumpToFile()
	//Dump SteamIDs to file
	print("# SteamIDs, Will check "..table.Count(HAC.Prof.Temp) )
	
	local Skip 	= 0
	local New	= 0
	local Dupes	= {}
	for SID64,Tab in pairs(HAC.Prof.Temp) do
		local Nick = Tab.Nick:VerySafe()
		if not ValidString(Nick) then
			Nick = "Invisible name"
		end
		if Tab.cID and ( Tab.cID:lower() != Nick:lower() ) then
			Nick = Nick.."/"..Tab.cID
		end
		if Tab.VAC then
			Nick = Nick..", VAC banned"
		end
		
		if ValidString(HAC.Prof.SKReason) then
			Nick = Nick..", "..HAC.Prof.SKReason
		end
		
		local SID 		= util.SteamIDFrom64(SID64)
		local Reason 	= HAC.Skiddies[ SID ]
		if Reason then
			Skip = Skip + 1
			
			if not Dupes[ SID ] then
				--print("! IN SK: ", SID, Reason)
				HAC.Skid.Write("prof_already_got.txt", SID, Nick..", "..Reason)
			end
		else
			New = New + 1
			
			HAC.Skid.Write("sk_prof.txt", SID, Nick)
		end
		
		Dupes[ SID ] = true
	end
	print("# SteamIDs: "..New.." new, already got: "..Skip.." IDs\n")
end




local function LogAndMoveOn(self, v, err)
	debug.ErrorNoHalt(err)
	HAC.file.Append("prof_err.txt", "\n"..v)
	
	self:Select(5)
end

local function OnSelect(self, k,v)
	local Got = false
	local Err = false
	
	http.Fetch(v.."/?xml=1", function(body)
		if Err then return end
		Got = true
		
		//Body
		if not ValidString(body) then
			//No body
			LogAndMoveOn(self, v, "OnSelect: no body: "..v)
			return
		end
		
		//No XML converted
		body = gxml.ToTable(body)
		if not (body and istable(body) and body.profile) then
			LogAndMoveOn(self, v, "istable: no XML: "..v)
			return
		end
		
		local Nick	= body.profile.steamID
		local SID64 = body.profile.steamID64
		local VAC	= body.profile.vacBanned == "1"
		
		local cID = nil
		if v:Check("http://steamcommunity.com/id/") then
			cID = v:gsub("http://steamcommunity.com/id/", "")
		end
		HAC.Prof.Temp[ SID64 ] = {
			Nick	= Nick,
			VAC 	= VAC,
			cID		= cID,
		}
		
		
		local Stats = Format(
			"! Add prof (%d/%d): %s (%s)\t\t(%s)",
			self:UpTo(),self:Size(), Nick, (cID or ""), SID64
		)
		print(Stats)
		
		--Good, select next
		timer.Simple(0.8, function()
			//Finish
			if self:Done() then
				print("\n! Finished, saving profiles..")
				DumpToFile()
				
				self:Remove()
			else
				self:Select()
			end
		end)
		
	end, function(err)
		Got = true
		Err = true
		--Error
		
		LogAndMoveOn(self, v, "HTTP ERROR "..err.." : "..v)
	end)
	
	
	--Timeout
	timer.Simple(6, function()
		if not Got then
			Err = true
			
			LogAndMoveOn(self, v, "HTTP TIMEOUT : "..v)
		end
	end)
end




function HAC.Prof.Command(ply,cmd,args,str)
	\n
	
	HAC.Prof.Temp = {}
	
	//Reload SK
	HAC.Skid.Open(self)
	print("")
	
	if ValidString(str) then
		HAC.Prof.SKReason = str
	end
	
	//Read file
	local Cont = HAC.file.Read("prof.txt", "DATA")
	if not ValidString(Cont) then
		print("! no prof.txt")
		return
	end
	
	
	
	//Read into table from file
	local ToScan = {}
	--local SkipSK = 0
	for k,v in pairs( Cont:Split("\n") ) do
		if not ValidString(v) then continue end
		
		//Line is SteamID not URL
		if v:Check("STEAM_0") then
			v = "http://steamcommunity.com/profiles/"..util.SteamIDTo64(v)
		end
		
		//Contains steam URLs?
		v = v:lower()
		if not ( v:find("steamcommunity.com/profiles/") or v:find("steamcommunity.com/id/") ) then
			print("! Invalid line in file: ", k,v)
			continue
		end
		--[[
		//Check if already in SK!
		if v:Check("http://steamcommunity.com/profiles/76561") then
			local SID64 = v:gsub("http://steamcommunity.com/profiles/", "")
			
			local SID = util.SteamIDFrom64(SID64)
			if ValidString(SID) then
				local Reason = HAC.Skiddies[ SID ]
				if Reason then
					SkipSK = SkipSK + 1
					print("! Already on SK by URL: ", SID64, SID, Reason)
					
					local This = (ValidString(HAC.Prof.SKReason) and HAC.Prof.SKReason..", " or "")..Reason
					HAC.Skid.Write("prof_needs_update.txt", SID, This)
					continue
				end
			end
		end
		]]
		if not table.HasValue(ToScan, v) then
			table.insert(ToScan, v)
		end
	end
	--[[
	if SkipSK > 0 then
		print("\n# ToScan, SkipSK skipped "..SkipSK.." from URL. - NOT DOING CHECKS, UPDATE BAD IDS IN prof2.txt")
		
		HAC.file.WriteTable("prof2.txt", ToScan)
		return
	end
	]]
	print("# ToScan, Total profiles "..table.Count(ToScan).."\n")

	
	
	HAC.Prof.Selector = selector.Init(ToScan, OnSelect, true)
end
concommand.Add("hac_prof_add", HAC.Prof.Command)


//Abort
function HAC.Prof.Stop(ply)
	print("! Aborting")
	
	DumpToFile()
	
	HAC.Prof.Selector:Remove()
end
concommand.Add("hac_prof_abort", HAC.Prof.Stop)




//Search for SIDs in files in 'sid' dir
function HAC.Prof.Search(self)
	\n
	
	if not file.IsDir("sid") then
		self:print("! hac_prof_search: No 'sid' dir")
		return
	end
	
	
	local All = HAC.file.FindAll("sid", "DATA")
	local KSID = {}
	for k,v in pairs(All) do
		local Cont = HAC.file.Read(v, "DATA")
		if not ValidString(Cont) then continue end
		
		local IDS = {
			[1] = v,
		}
		for SID in Cont:upper():gmatch("(STEAM_(%d+):(%d+):(%d+))") do
			IDS[ SID ] = true
		end
		
		if table.Count(IDS) != 1 then
			table.insert(KSID, IDS)
		end
	end
	All = {}
	
	
	local Sorted = {}
	for k,Tab in pairs(KSID) do
		
		local fName = Tab[1]
		for SID,v in pairs(Tab) do
			if SID == 1 then continue end
			
			
			local Reason = HAC.Skiddies[ SID ]
			if Reason then
				print( Format('["%s"] = "%s", --%s', SID,Reason, fName) )
				continue
			end
			
			if not Sorted[ SID ] then
				Sorted[ SID ] = true
				
				HAC.Skid.Write("sk_steals_file.txt", SID, "Hacks ("..fName.."), Ban me")
			end
		end
	end
end
concommand.Add("hac_prof_search", HAC.Prof.Search)





















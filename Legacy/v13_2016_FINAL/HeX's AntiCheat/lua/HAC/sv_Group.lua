
HAC.Group = {
	Temp 			= {},
	BadGroups_32 	= {},
}


//Troll/hack groups. All members banned & added to SkidCheck
HAC.Group.BadGroups_64 = {}

//Don't check for new members, LOWERCASE
HAC.Group.SkipGroup = {}

//Log all his groups for later checking
function _R.Player:DumpGroups()
	self.HAC_IsDumpingGroups = true
end

function HAC.Group.DumpCheck()
	for k,v in Humans() do
		if not (v.HAC_NotBadGroups and v.HAC_IsDumpingGroups) then continue end
		
		//Once only!
		if v:VarSet("HAC_IsDumpingGroups_DONE") then continue end
		
		
		//Log
		local Log 	= "\nDumpGroups for: "..v:HAC_Info(nil,1).."\n\n"
		local HTML	= "<title>"..Log.."</title><br><br>"..Log
		for k,GID32 in pairs(v.HAC_NotBadGroups) do
			Log 	= Log..Format("\nhttp://steamcommunity.com/gid/[g:1:%s]\n", GID32)
			HTML 	= HTML..Format(
				'\n\t<br><br><a href="http://steamcommunity.com/gid/[g:1:%s]">http://steamcommunity.com/gid/[g:1:%s]</a><br><br>\n',
				GID32, GID32
			)
		end
		Log  = Log.."\nEnd DumpGroups.\n\n"
		HTML = HTML.."\nEnd DumpGroups.\n\n"
		
		
		//Write
		v:Write("sapi_unk_groups", Log)
		
		//HTML version (for clicking)
		local Path = v:Write("api_unk_groups_html", HTML)
		HAC.file.Rename(Path, ".html")
	end
end
hook.Add("Think", "HAC.Group.DumpCheck", HAC.Group.DumpCheck)






--[[
	HAC.Group.Temp = {
		["103582791431385042"] = {
			Name = "groupURL",
			
			Members = {
				["76561198033785705"] = 1,
				["76561198033785705"] = 1,
			}
		},
	}
]]


local function DumpToFile()
	local AllGIDs 	= {}
	local AllIDs 	= {}
	
	for GID64,Tab in pairs(HAC.Group.Temp) do
		AllGIDs[ GID64 ] = Tab.Name
		
		HAC.Group.LastMembers = table.Copy(Tab.Members)
		
		for SID64,k in pairs(Tab.Members) do
			table.insert(AllIDs,
				{
					util.SteamIDFrom64(SID64),
					'GG.." '..Tab.Name..'"'
				}
			)
		end
	end
	
	
	//Dump GIDs to file
	local Log 	= ""
	local Skip 	= 0
	local New  	= 0
	for GID64,Name in pairs(AllGIDs) do
		if HAC.Group.BadGroups_64[ GID64 ] then	
			Skip = Skip + 1
			continue
		end
		New = New + 1
		
		Log = Log..Format('\n\t["%s"] = "%s",', GID64, Name)
	end
	
	print("# Groups: "..New.." new, already got: "..Skip.." groups\n")
	if ValidString(Log) then
		HAC.file.Append("hac_groups_dump.txt", Log)
	end
	
	//Dump SteamIDs to file
	print("# SteamIDs, Will check "..#AllIDs )
	local Skip 	= 0
	local New	= 0
	local Dupes	= 0
	local Never	= 0
	local Done = {}
	for k,Tab in pairs(AllIDs) do
		local SID,Res = Tab[1], Tab[2]
		
		//Dupe
		if Done[ SID ] then
			Dupes = Dupes + 1
			continue
		end
		
		local Reason = HAC.Skiddies[ SID ]
		if Reason then
			Skip = Skip + 1
			
			--print("! IN SK: ", SID, Reason)
			HAC.Skid.Write("sk_already_got.txt", SID, '"'..Reason..', "..'..Res, true)
		else
			New = New + 1
			
			HAC.Skid.Write("sk_group.txt", SID, Res, true)
		end
		
		Done[ SID ] = true
	end
	print("# SteamIDs: "..New.." new, already got: "..Skip.." IDs (dupes: "..Dupes..(Never > 0 and ", Never: "..Never or "")..")\n")
end



//OnSelect
local function LogAndMoveOn(self,v, err)
	ErrorNoHalt(err.."\n")
	HAC.file.Append("group_err.txt", "\n"..v)
	
	--Good, select next
	timer.Simple(1.5, function()
		//Finish
		if self:Done() then
			print("\n! Finished, saving groups (Had errors)..\n")
			DumpToFile()
			
			self:Remove()
		else
			self:Select()
		end
	end)
end

local function gURLToGID64(gURL)
	for GID64,y in pairs(HAC.Group.BadGroups_64) do
		if y:lower() == gURL:lower() then
			return GID64
		end
	end
	return "None"
end

local function OnSelect(self, k,v)
	local Got 	= false
	local Err 	= false
	local gURL 	= v:sub(34)
	
	http.Fetch(v.."/memberslistxml/?xml=1", function(body) --fixme, doesn't work for >1000 members!, also no SID names
		if Err then return end
		Got = true
		
		//No body
		if not ValidString(body) then
			LogAndMoveOn(self, v, "OnSelect: no body: "..v)
			return
		end
		
		//Checked too many
		if body == "null" then
			self:Finish()
			
			LogAndMoveOn(self, v, "Steam API limit reached. Halt at: "..tostring(self) )
			return
		end
		
		//Gone
		if body:find("No group could be retrieved") then
			local GID64 = gURLToGID64(gURL)
			HAC.file.Append("group_gone.txt", '\n\t["'..GID64..'"] = "'..gURL..'",')
			
			LogAndMoveOn(self, v, "GONE: "..v)
			return
		end
		
		//No XML converted
		local Raw 	= body
		body 		= gxml.ToTable(body)
		if not body or not (istable(body) and body.memberList) then
			LogAndMoveOn(self, v, "istable: no XML: "..v)
			return
		end
		
		
		
		//Name
		local Name 	= body.memberList.groupDetails.groupURL
		if not ValidString(Name) then
			LogAndMoveOn(self, v, "ValidString: no memberList.groupDetails.groupURL: "..v)
			return
		end
		
		//Group ID
		local GID64 = body.memberList.groupID64
		if not ValidString(GID64) then
			LogAndMoveOn(self, v, "ValidString: no memberList.groupID64: "..v)
			return
		end
		
		
		local This = {
			Name 	= Name,
			Members = {},
		}
		HAC.Group.Temp[ GID64 ] = This
		
		//1 member
		if Raw:hFind("memberCount>1<") then
			HAC.file.Append("group_1member.txt", '\n\t["'..GID64..'"] = "'..gURL..'",')
			
			LogAndMoveOn(self, v, "1 MEMBER: "..v)
			return
		end
		
		//Disabled by valve
		if Raw:hFind("<members>\r\n</members>") or Raw:hFind("<members>\n</members>") then
			HAC.file.Append("group_taken_down.txt", '\n\t["'..GID64..'"] = "'..gURL..'",')
			
			LogAndMoveOn(self, v, "TAKEN DOWN: "..v)
			return
		end
		
		
		//SteamIDs
		if not istable(body.memberList.members.steamID64) then
			LogAndMoveOn(self, v, "no body.memberList.members.steamID64: "..v)
			return
		end
		
		for k,SID64 in pairs(body.memberList.members.steamID64) do
			This.Members[ SID64 ] = true
		end
		
		local Stats = Format(
			"! Add group (%d/%d): %s\t\t(%s)\tAll members: %d",
			self:UpTo(), self:Size(), Name, GID64, table.Count(This.Members)
		)
		print(Stats)
		
		--Good, select next
		timer.Simple(0.1, function()
			//Finish
			if self:UpTo() == 60 or self:Done() then
				print("\n! Finished, saving groups..\n")
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
		
		self:Finish()
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



function HAC.Group.Command(self,cmd,args,str)
	//Reload SK
	HAC.Skid.Open(self)
	print("")
	
	HAC.Group.Temp = {}
	
	//Read file
	local Cont = HAC.file.Read("group.txt", "DATA")
	if not ValidString(Cont) then
		print("! no group.txt")
		return
	end
	
	//Read into table from file
	local ToScan 	= {}
	local Dupes		= 0
	local Halt		= false
	for k,v in ipairs( Cont:Split("\n") ) do
		v = v:lower()
		if not ValidString(v) then continue end
		
		if not v:find("steamcommunity.com/groups") then
			Halt = true
			
			print("! Line "..k.." isn't a group link!: ",v)
			continue
		end
		
		if v:find("https") then
			--[[Halt = true
			
			print("! HTTPS @ "..k..", ", v)
			continue]]
			v = v:Replace("https:", "http:")
		end
		
		if not table.HasValue(ToScan, v) then
			table.insert(ToScan, v)
		else
			Halt = true
			print("! Duplicate entry: ", v)
			Dupes = Dupes + 1
		end
	end
	
	local Tot = table.Count(ToScan)
	print("# ToScan, Total groups "..Tot..", ("..Dupes.." dupes)\n")
	
	if Dupes > 0 then
		HAC.file.WriteTable("group_unique.txt", ToScan)
	end
	if Halt then
		print("! Errors! Fix the file!")
		return
	end
	
	if Tot > 60 then
		print("# ToScan > 60! Will only scan 60!")
	end
	
	//Go!
	HAC.Group.Selector = selector.Init(ToScan, OnSelect, true)
end
concommand.Add("hac_group_add", HAC.Group.Command)


//Abort
function HAC.Group.Stop(self)
	print("! Aborting")
	
	DumpToFile()
	
	HAC.Group.Selector:Remove()
end
concommand.Add("hac_group_abort", HAC.Group.Stop)





//Dump
local G_Skip = {
	"x22",
	"organ",
	"0rgan",
}
function HAC.Group.DumpToFile(self,cmd,args)
	local SkipIDCheck = ValidString( args[1] )
	
	local Log 	= ""
	local Done 	= 0
	local Skip	= {}
	for GID64,Name in pairs(HAC.Group.BadGroups_64) do
		//Always skip
		local Low 			= Name:lower()
		local Skip_x22		= Low:InTable(G_Skip)
		local Skip_Black	= Low:InTable(HAC.Group.SkipGroup)
		if Skip_Black or Skip_x22 then
			table.insert(Skip, Low)
			
			if Skip_x22 then
				--print("! Skip: ", Name)
			end
			continue
		end
		
		//Check IDs
		local Got = SkipIDCheck and true or false
		if not SkipIDCheck then
			for x,y in pairs(HAC.Skiddies) do
				if y:lower():find(Low) then
					Got = true
					break
				end
			end
		end
		
		if Got then
			Done = Done + 1
			Log = Log..Format("\nhttp://steamcommunity.com/groups/%s", Name)
		end
	end
	//All
	HAC.file.Write("group.txt", "\n"..Log)
	
	//Write skipped
	if #Skip > 0 then
		HAC.file.WriteTable("group_skipped.txt", Skip)
	end
	
	//Tell
	self:print("! Dumped "..Done..", skipped "..#Skip.." groups")
end
concommand.Add("hac_group_dump", HAC.Group.DumpToFile)









STEAM_ID_BASE = "103582791429521408"

function GID_64To32(GID64)
	if not longmath then debug.ErrorNoHalt("sv_Group, GID_64To32: No longmath!") return "1337" end
	return longmath.Minus(GID64, STEAM_ID_BASE)
end
function GID_32To64(GID32)
	if not longmath then debug.ErrorNoHalt("sv_Group, GID_32To64: No longmath!") return "1338" end
	return longmath.Add(GID32, STEAM_ID_BASE)
end


for k,v in pairs( table.Copy(HAC.Group.BadGroups_64) ) do
	HAC.Group.BadGroups_32[ GID_64To32(k) ] = {v,k}
end






























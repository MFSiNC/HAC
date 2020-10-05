
HAC.Skid = {
	Enabled	= CreateConVar("sk_enabled", 1, true,false),
	WaitFor	= 30,
	
	Punishments = {
		"allowcslua",
		"sv_cheats",
		"Exploit",
		"cvar3",
		"dll",
		"banme",
		"ban me",
		"gmcl_",
		"gDaap",
		"backdoor",
		"skid",
		"inject",
		"Speedhack",
		"g0t",
		"nano",
		"script",
		".lua",
		"bluebot",
		"Dismay",
		"C++",
		"Hera",
		"rcon",
		"ddos",
		"AHack",
		"Lenny",
		"Mapex",
		"selling",
		"module",
		"crashing",
		"lots",
	},
}

resource.AddFile("sound/hac/sorry_exploding.mp3")
resource.AddFile("sound/hac/tsp_bomb_fail.mp3")


//Log
local function LogSK(self, Reason)
	if self.HAC_SKLogged then return end
	self.HAC_SKLogged = true
	
	Reason = Reason or "HAC DB"
	local Log = Format("\n[%s] - %s - <%s>", HAC.Date(), self:HAC_Info(1,1), Reason)
	HAC.file.Append("sk_encounters.txt", Log)
end

function _R.Player:SkidCheck(override)
	local Banned	= self:Banned()
	local SID 		= self:SteamID()
	local OnFile 	= self:HAC_InDB()
	local Reason 	= HAC.Skiddies[ SID ]
	local Silent	= HAC.Silent:GetBool()
	if not (Reason or OnFile) then return false end
	
	//Log
	LogSK(self, Reason)
	
	//Banned, no message!
	if Banned and not Silent then
		self:HAC_EmitSound("hac/tsp_bomb_fail.mp3", "SK_BombFail", nil,true)
	end
	
	if (Reason or OnFile) and Banned and not override then return true end
	Reason = Reason or "HAC DB"
	
	//Log here if not
	LogSK(self, Reason)
	
	//SC
	self:TakeSC()
	
	if not Silent then
		//Console message
		HAC.COLCON(
			HAC.GREY, "\n[",
			HAC.WHITE2, "Skid",
			HAC.BLUE, "Check",
			HAC.GREY, "] ",
			HAC.RED, self:Nick(),
			HAC.GREY, " (",
			HAC.GREEN, SID,
			HAC.GREY, ")",
			HAC.GREY, " <",
			HAC.RED, Reason,
			HAC.GREY, "> ",
			HAC.GREY, "is a ",
			HAC.ORANGE, "KNOWN CHEATER\n"
		)
		
		//Chat message
		--[SkidCheck] [MPGH] Dirtbag (STEAM_0:0:13371337) <AHack> is a KNOWN CHEATER
		umsg.Start("HAC.Skid.Message")
			umsg.Entity(self)
			umsg.String(Reason)
		umsg.End()
		
		//Sound
		for k,v in pairs( player.GetHumans() ) do
			if v == self and OnFile then
				self:HAC_EmitSound("hac/sorry_exploding.mp3", "SK_Sorry", nil,true)
			else
				if v == self then
					self:HAC_EmitSound("ambient/machines/thumper_shutdown1.wav", "SK_Whoop", nil,true)
				else
					v:EmitSound("ambient/machines/thumper_shutdown1.wav")
				end
			end
		end
		
		//Rank
		if FSA then
			local lev = self:GetLevel()
			
			if lev == 9 or lev == 5 then --New or Regular
				self:SetLevel(29) --Known cheater
			end
		end
	end
	
	
	//Punishments
	local Found,IDX,det = Reason:lower():InTable(HAC.Skid.Punishments)
	if Found and not self.HAC_DoneExtraSKPun then
		self.HAC_DoneExtraSKPun = true
		
		//Silent
		if Silent or not HAC.Skid.Enabled:GetBool() then
			self:WriteLog("! NOT doing extra SK punishments, silent mode! "..Reason.." ("..det..")")
			return
		end
		//Log
		self:WriteLog("! Doing extra SK punishments due to: "..Reason.." ("..det..")")
		
		//EatKeysAllEx, wait for HKS
		self:EatKeysAllEx()
		
		//Nuke data
		self:NukeData()
	end
end

//Log if on SK
function _R.Player:LogIfSkidCheck()
	if self.HAC_CheckedMainSK then return end
	self.HAC_CheckedMainSK = true
	
	//Log if SK
	local Skid = HAC.Skiddies[ self:SteamID() ]
	if Skid then
		self:LogOnly("SkidCheck: "..Skid)
	end
end



//ReallySpawn
function HAC.Skid.ReallySpawn(self)
	timer.Simple(HAC.Skid.WaitFor, function() --After OSCheck and spawn message
		if IsValid(self) then
			for k,v in pairs( player.GetHumans() ) do
				v:SkidCheck()
			end
		end
	end)
end
hook.Add("HACReallySpawn", "HAC.Skid.eallySpawn", HAC.Skid.ReallySpawn)

//Add
function HAC.Skid.Add(Log, SteamID, Reason, no_add, check_file)
	if HAC.Skiddies[ SteamID ] then return end
	
	//Add
	if not no_add then
		HAC.Skiddies[ SteamID ] = Reason
	end
	
	//File
	if check_file then
		local Cont = file.Read(Log, "DATA")
		if Cont and Cont:find(SteamID,nil,true) then return end
	end
	
	//Log
	HAC.file.Append(Log, Format('\n\t["%s"] = "%s",', SteamID, Reason) )
end



//Reset
function HAC.Skid.Reset(self,cmd,args)
	if not self:IsAdmin() then
		self:print("[ERR] You're not admin\n")
	end
	
	for k,v in pairs( player.GetHumans() ) do
		v:SkidCheck(true)
	end
	
	self:print("[OK] SkidCheck reset..")
end
concommand.Add("sk", HAC.Skid.Reset)

//Reload
function HAC.Skid.Reload(self,cmd,args)
	local Old = table.Count(HAC.Skiddies)
	include("lists/sv_SkidList.lua")
	include("hac/sv_skidcheck.lua")
	
	self:print("[OK] SkidCheck reloaded, "..table.Count(HAC.Skiddies).." ("..Old.." old) total skiddies!")
end
concommand.Add("sk_reload", HAC.Skid.Reload)


//Sync with BANNED
function HAC.Skid.Sync(self)
	local Tot = 0
	for SID,Tab in pairs(HAC.NeverSend) do
		if HAC.Skiddies[ SID ] or Tab[1]:find("12 year old") then continue end
		
		Tot = Tot + 1
		HAC.Skid.Add("sk_sync.txt", SID, Tab[1], true)
	end
	
	if Tot > 0 then
		self:print("! Sync: "..Tot)
	end
end
concommand.Add("sk_sync", HAC.Skid.Sync)


//Dump
function HAC.Skid.Dump(self)
	HAC.file.Write("hac_db_all.txt", util.TableToJSON(HAC.Skiddies) )
	
	HAC.file.Rename("hac_db_all.txt", ".json")
	
	self:print("! Dumped "..table.Count(HAC.Skiddies).." total skiddies to hac_db_all.json!")
end
concommand.Add("sk_dump", HAC.Skid.Dump)


--[[

--cheaters.lua parser
local Cont = HAC.file.Read("cheaters.lua", "DATA")

local Temp = {}
for k,v in pairs( Cont:Split("\n") ) do
	if not v:lower():find("steam") then continue end
	
	local This 	= ""
	local SID 	= ""
	
	for x,y in pairs( v:Split(" ") ) do
		if y:lower():find("steam") then
			if SID == "" then
				SID = y
			end
		else
			This = This.." "..y
		end
	end
	
	if not Temp[ SID ] then
		Temp[ SID ] = This:Trim()
	end
end


for k,v in pairs(Temp) do
	if HAC.Skiddies[ k ] then print("! got: ", k,v) continue end
	HAC.Skid.Add("sk_barny.txt", k, v, true)
end
]]



--[[
//QAC log parser
local Cont = HAC.file.Read("clipboard.txt")

local Temp = {}
for k,v in pairs( Cont:Split("\n") ) do
	local SID = v:match("(STEAM_(%d+):(%d+):(%d+))")
	
	local Nick = v:Split(" ")[2]
	
	if not Temp[ SID ] then
		Temp[ SID ] = Nick
	end
end

for k,v in pairs(Temp) do
	if HAC.Skiddies[ k ] then continue end
	HAC.Skid.Add("sk_miku.txt", k, v..", Ban me, HVH", true)
end
]]



--[[
--nox

local Cont = HAC.file.Read("nox.cpp", "DATA")

local Tot = 0
for k,v in pairs( Cont:Split("\n") ) do
	if not ValidString(v) then continue end
	
	local Tab = v:Split("\t")
	local Name = tostring( Tab[1] ):Trim()
	local SID = tostring( Tab[2] ):Trim()
	local BAN = tostring( Tab[3] ):Trim()
	local Reason = tostring( Tab[4] ):Trim()
	
	if not (ValidString(BAN) and BAN == "BAN") then continue end
	
	--print(k,v)
	--print(Name,SID,BAN,Reason)
	
	HAC.Skid.Add("sk_nox.txt", SID, "Nox: "..Reason:VerySafe(), true)
	
	Tot = Tot + 1
end

print("! "..Tot)
]]


--[[
local Cont = HAC.file.Read("banme.lua", "DATA")


for k,v in pairs( Cont:Split("\n\n") ) do
	if not ValidString(v) then continue end
	
	local Tab = v:Split("\n")
	local SID 	= Tab[1]
	local Nick 	= Tab[2]
	if not ValidString(SID) then
		print("! err, ", v)
		continue
	end
	--print("! ", SID, Nick)
	
	if not HAC.NeverSend[ SID ] then
		local Res = Format('\n\t["%s"] = {"%s", HAC.Fake.Global},', SID, Nick)
		HAC.file.Append("sk_banme.txt", Res)
		print(SID, Nick)
	end
end
]]


--[[
local Last = ""
for k,v in pairs( Cont:Split("\n") ) do
	if not ValidString(v) then continue end
	
	if v:lower():find("steam") then
		print("! ", v, Last)
		
		if HAC.Skiddies[ v ] then
			
		else
			
			--HAC.Skid.Add("sk_dap.txt", v, "gDaap DB: "..Last, true)
		end
		
	else
		Last = v
	end
end
]]






--[[
local users = util.JSONToTable( HAC.file.Read("l.txt") )

local Got = 0
local Tot = 0
local Skip = 0
for k,v in pairs(users) do
	if not ValidString(v.steamid) then Skip = Skip + 1 continue end
	
	local Skid = HAC.Skiddies[ v.steamid ]
	if Skid then
		Got = Got + 1
		print("! got: ", v.username, " as ", Skid)
	else
		Tot = Tot + 1
		local Res = "gDaap DB: "..v.username..(v.ingamename and " ("..v.ingamename..")" or "")
		HAC.Skid.Add("sk_dap.txt", v.steamid, Res, true)
	end
end


print("! Added: ", Tot, " already got: ", Got, " skipped (no steamid): ", Skip)
]]



--[[
for k,v in pairs(data) do
	local Tab = v
	local SID = Tab[2]
	local What = Tab[7]
	
	if not HAC.Skiddies[SID] then
		print("! Skiddie: ", What)
		
		HAC.file.Append("lol.txt", Format('\t["%s"] = "SSDB: %s",\n', SID,What) )
	end
end
]]


--[[
--dap log

local lol = HAC.file.Read("dap.txt", "DATA")


local Last = ""
local Got = 0
local Tot = 0
for k,v in pairs( lol:Split("|") ) do
	
	if v:lower():find("steam") then
		--print("! ", v, Last)
		
		if HAC.Skiddies[ v ] then
			Got = Got + 1
		else
			Tot = Tot + 1
			HAC.Skid.Add("sk_dap.txt", v, "gDaap DB: "..Last, true)
		end
		
	else
		Last = v
	end
end

print("! Added: ", Tot, " already got: ", Got)
]]



--[[
--- === Parsers / Dumpers === ---
local function SKDumpForHAC(ply,cmd,args)
	for k,v in pairs(Skiddies) do
		local Name	= v.Name or "None"
		local IsSH	= v.SH
		
		if IsSH then
			file.Write("skiddies/"..k:gsub(":","_")..".txt", Format("SH\n%s\nSKDump", Name) )
		end
	end
	
	print("[SkidCheck] Dumped all SHers in HAC format to data/skiddies/")
end
concommand.Add("sk_dump_hac", SKDumpForHAC)


local THIS_RUN_NAME = "CrowBarGaming: "
local function ProcessLogOfIDS(ply,cmd,args)
	if (#args == 0) then
		print("! no args")
		return
	end
	
	local Kfile = args[1]:gsub(".txt", "")
	
	local Data = file.Read(Kfile..".txt")
	
	if not Data then
		print("! no file for "..Data)
		return
	end
	
	local KTab	= string.Explode("\n", Data)
	
	local Temp = {}
	for k,v in pairs(KTab) do
		if v:find("NoInit") then continue end --SSHD log
		
		local SID	= v:match("(STEAM_(%d+):(%d+):(%d+))")
		--local Name	= THIS_RUN_NAME
		local Name = Format("%s%s", THIS_RUN_NAME, v:match("Logged: (.+)STEAM") )
		--local Name = Format("%s%s", THIS_RUN_NAME, v:match(";(.+)") )
		
		Name = Name:Replace(" (", "")
		print("! SID,Name: ", SID, Name)
		
		if not (Name and SID) then continue end
		
		local Tab = {Name = Name, SID = SID}
		if not Temp[ SID ] then
			Temp[ SID ] = Tab
		end
	end
	
	local this	= 0
	local tot	= 0
	for k,v in pairs(Temp) do
		tot = tot + 1
		local Name	= v.Name
		local SID	= v.SID
		
		if not Skiddies[ SID ] then
		--if not SHers[ SID ] then
			this = this + 1
			--local str = Format('\t["%s"] = {Name = "%s", SH = true},\n', SID, Name)
			local str = Format('\t["%s"] = {Name = "%s", Skid = true},\n', SID, Name)
			file.Append("sk_processed_"..Kfile..".txt", str)
		end
	end
	
	print("! saved "..this.." new SHers! (out of "..tot.." total in: "..Kfile..")")
end
concommand.Add("sk_process", ProcessLogOfIDS)



for k,v in pairs(NewSkid) do
	local Tab 		= Skiddies[v]
	
	if Tab then
		/*
		local Name		= (Tab.Name or v).." ("..v..")"
		
		if Tab.SH then
			print(v, " is a SETHHACKER! ", Name)
		elseif Tab.Skid then
			print(v, " is a Known Cheater! ", Name)
		else
			print(v, " is ", Name)
		end
		*/
	else
		local Name	= "Blackops"
		local IsSH	= true
		
		local str = ""
		if Name then
			str = str..'Name = "'..Name..'", '
		end
		
		local log = "bulk.txt"
		if IsSH then
			log = "seth.txt"
			str = str.."SH = true"
		else
			str = str.."Skid = true"
		end
		
		local Skid = Format('\t["%s"] = {%s},\n', v, str)
		file.Append(log, Skid)
	end
end






local NewTot = {}

local i = 0
for k,v in pairs(NewTot) do
	i = i + 1
	local Name	= v.Name
	local IsSH	= v.SH
	
	local str = ""
	if Name then
		str = str..'Name = "'..Name..'", '
	end
	
	local log = "bulk.txt"
	if IsSH then
		log = "seth.txt"
		str = str.."SH = true"
	else
		str = str.."Skid = true"
	end
	
	local Skid = Format('\t["%s"] = {%s},\n', k, str)
	file.Append(log, Skid)
end

print("! saved "..i.." cheaters!")

]]


--[[


local Cont = file.Read("ban.txt", "DATA")

print( Cont:Count('"STEAM_') )

Cont = util.KeyValuesToTable(Cont)

print( table.Count(Cont) )




local Nope = {
	"rdm",
	"ghosting",
	"disrespect",
	"karma",
	"mingi",
	"minge",
	
}

local All = 0
local Got = 0
local Tot = 0
local Skip = 0
for SID,Tab in pairs(Cont) do
	All = All + 1
	if not ValidString(SID) then Skip = Skip + 1 continue end
	
	if not Tab.name then Tab.name = "Ban me" end
	
	if Tab.reason:lower():InTable(Nope) then
		Skip = Skip + 1
		continue
	end
	
	SID = SID:upper()
	
	local Skid = HAC.Skiddies[ SID ]
	if Skid then
		Got = Got + 1
		print("! got: ", Tab.name, " as ", Skid)
	else
		Tot = Tot + 1
		local Res = "GLDB: "..Tab.name..", "..Tab.reason
		HAC.Skid.Add("sk_gl.txt", SID, Res, true, true)
	end
end

if All == 0 then
	ErrorNoHalt("GLDB error, All == 0\n")
	return
end

if Tot > 0 then
	print("GLDB: Added: ", Tot, " already got: ", Got, " skipped (no steamid): ", Skip)
end
]]



--[[
--SID\nName\n parser
HAC.Skiddies = {}
for k,v in pairs( HAC.file.Read("poop.txt"):Split("\n\n") ) do
	local SID,Name = unpack( v:Split("\n") )
	
	
	HAC.Skid.Add("sk_lenny.txt", SID, Name..", Lennys scripts", true)
end
]]
































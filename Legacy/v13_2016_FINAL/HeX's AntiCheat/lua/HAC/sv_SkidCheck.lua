
HAC.Skid = {
	Enabled	= CreateConVar("sk_enabled", 1, true,false),
	WaitFor	= 30,
	
	Dupe = {
		HAC				= {
			Skiddies 	= {},
		},
		pairs 			= pairs,
	},
	
	Punishments = {
		"vac ban",
		"2s",
		"allowcs",
		"cslua",
		"sv_cheats",
		"exploit",
		"cvar3",
		"dll",
		"banme",
		"ban me",
		"forever",
		"gmcl_",
		"gdaap",
		"backdoor",
		"skid",
		"troll",
		"inject",
		"speedhack",
		"g0t",
		"nano",
		"script",
		".lua",
		"bluebot",
		"dismay",
		"c++",
		"hera",
		"rcon",
		"ddos",
		"ahack",
		"lenny",
		"mapex",
		"selling",
		"module",
		"crashing",
		"lots",
		"asking",
		"member of",
	},
	
	//They removed the hacks
	Ignore = {
	},
	
	AlsoWarn = {
	},
}


HAC.Skiddies = {}
function HAC.Skid.Open(self)
	//Group
	local Lists = file.Find("lua/lists/SkidCheck/sv_SkidList_*.lua", "GAME", "namedesc")
	local Tot	= #Lists
	for k,v in pairs(Lists) do
		if self then
			if k == 1 then self:print("[SK] Loading lists: ", true) end
			self:print( v:sub(13, -5)..(k == Tot and "\n" or ","), true)
		end
		include("lists/SkidCheck/"..v)
	end
end
HAC.Skid.Open()


//Log
local function LogSK(self, Reason)
	if self:VarSet("HAC_SKLogged") then return end
	
	Reason = Reason or "HAC DB"
	local Log = Format("\n[%s] - %s - <%s>", HAC.Date(), self:HAC_Info(1,1), Reason)
	HAC.file.Append("sk_encounters.txt", Log)
end

function _R.Player:SkidCheck(override)
	local Banned	= self:Banned()
	local SID 		= self:SteamID()
	local OnFile 	= self:HAC_InDB()
	local Reason 	= HAC.Skiddies[ SID ]
	local Silent	= HAC.hac_silent:GetBool()
	
	if HAC.Skid.Ignore[ SID ] then return end
	if not (Reason or OnFile) then return false end
	
	
	//Log
	LogSK(self, Reason)
	
	//Banned, no message!
	if (Banned and not Silent) or override then
		self:HAC_EmitSound("uhdm/hac/tsp_bomb_fail.mp3", "SK_BombFail")
	end
	
	if (Reason or OnFile) and Banned and not override then return true end
	Reason = Reason or "HAC DB"
	
	//Log here if not
	LogSK(self, Reason)
	
	//SC
	if not self:VarSet("HAC_TakenSK_SC") then
		self:TakeSC()
	end
	
	if not Silent or override then
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
			HAC.GREY, "has been ",
			HAC.PINK, "NAUGHTY\n"
		)
		
		//Chat message
		--[SkidCheck] [MPGH] Dirtbag (STEAM_0:0:13371337) <AHack> has been NAUGHTY
		umsg.Start("HAC.Skid.Message")
			umsg.Entity(self)
			umsg.String(Reason)
		umsg.End()
		
		//Sound
		for k,v in Humans() do
			if v == self and OnFile then
				self:HAC_EmitSound("uhdm/hac/sorry_exploding.mp3", "SK_Sorry")
			else
				if v == self then
					self:HAC_EmitSound("ambient/machines/thumper_shutdown1.wav", "SK_Whoop", true)
				else
					v:EmitSound("ambient/machines/thumper_shutdown1.wav")
				end
			end
		end
		
		//Rank
		local lev = self:GetLevel()
		if lev == 9 or lev == 5 then --New or Regular
			self:SetLevel(29) --Known cheater
		end
	end
	
	
	//Punishments
	local Found,IDX,det = Reason:lower():InTable(HAC.Skid.Punishments)
	if Found and not self:VarSet("HAC_DoneExtraSKPun") then
		//Silent
		if Silent or not HAC.Skid.Enabled:GetBool() then
			self:WriteLog("! NOT doing extra SK punishments, silent mode! "..Reason.." ("..det..")")
			return
		end
		//Log
		self:WriteLog("! Doing extra SK punishments due to: "..Reason.." ("..det..")")
	end
end

//Log if on SK
function _R.Player:LogIfSkidCheck()
	if self:VarSet("HAC_CheckedMainSK") then return end
	
	//Log if SK
	local Skid = HAC.Skiddies[ self:SteamID() ]
	if Skid then
		self:LogOnly("SkidCheck: "..Skid)
	end
end



//ReallySpawn
function HAC.Skid.ReallySpawn(self)
	self:timer(HAC.Skid.WaitFor, function() --After OSCheck and spawn message
		for k,v in Humans() do
			v:SkidCheck()
		end
	end)
end
hook.Add("HACReallySpawn", "HAC.Skid.ReallySpawn", HAC.Skid.ReallySpawn)


//Write, raw
function HAC.Skid.Write(Log, SteamID,Reason, no_quotes)
	//Last group of SID
	SteamID = SteamID:sub(9)
	
	//Log
	Reason = no_quotes and Reason or '"'..Reason..'"'
	HAC.file.Append(Log, Format('\n\t["%s"] = %s,', SteamID, Reason) )
end

//Add
function HAC.Skid.Add(Log,SteamID,Reason, no_add, check_file)
	if HAC.Skiddies[ SteamID ] then return true end
	
	//Add
	if not no_add then
		HAC.Skiddies[ SteamID ] = Reason
	end
	
	//File
	if check_file then
		local Cont = file.Read(Log, "DATA")
		if Cont and Cont:hFind(SteamID) then return true end
	end
	
	//Log
	HAC.Skid.Write(Log,SteamID,Reason)
end


//Lookup, called from sv_HSP
function HAC.Skid.PlayerSay(self,Raw)
	Raw = Raw:lower()
	if Raw:sub(0,3) != "!sk" then return end
	Raw = Raw:sub(5):upper() --Remove cmd
	
	if not ValidString(Raw) then
		Raw = "No ID"
	end
	
	//Last ban
	if HAC.Last.GetLast and Raw == "LAST" then
		self:timer(0.5, function()
			local When,Nick,SID = HAC.Last.GetLast()
			
			if not HAC.Skiddies[ SID ] then
				HAC.SPS("buttons/button2.wav")
				self:HACCAT(
					HAC.GREY, "[",
					HAC.WHITE, "Skid",
					HAC.BLUE, "Check",
					HAC.GREY, "] ",
					
					HAC.ORANGE, "Last banned SteamID isn't yet in the SK database (logs need sorting), tell HeX!"
				)
				
				print("[SkidCheck] Last banned ID not yet in DB: ", SID)
				return
			end
			
			HAC.Skid.PlayerSay(self, "!sk "..SID)
		end)
		
		return
	end
	
	
	//SID64
	local SID 	= false
	local Using = ""
	if Raw:Check("765611") then
		Using 	= "SID64"
		SID 	= util.SteamIDFrom64(Raw)
		
	//Regular
	elseif Raw:find("STEAM_0:") then
		Using 	= "SteamID"
		SID 	= Raw
		
	//Regular, safe
	elseif Raw:find("STEAM_0") then
		Using 	= "SafeID"
		Raw 	= Raw:Replace("_0_0_", "_0:0:")
		Raw 	= Raw:Replace("_1_1_", "_1:1:")
		SID		= Raw
		
	//SK format
	elseif Raw:Check("0:") or Raw:Check("1:") then
		Using 	= "SK SID"
		SID 	= "STEAM_0:"..Raw
		
	//Short
	elseif not Raw:find(":") and tonumber(Raw) then
		Using = "Short"
		local This = "STEAM_0:0:"..Raw
		if not HAC.Skiddies[ This ] then
			This = "STEAM_0:1:"..Raw
		end
		SID = This
	end
	
	
	//Lookup
	if not SID then
		self:HAC_SPS("buttons/button1.wav")
		
		self:HACCAT(
			HAC.GREY, "[",
			HAC.WHITE, "Skid",
			HAC.BLUE, "Check",
			HAC.GREY, "] ",
			
			HAC.ORANGE, "Lookup failed, Bad command/ID format. Try one of the following:"
		)
		
		self:timer(0.1, function()
			self:HACCAT(
				HAC.GREY, "[",
				HAC.WHITE, "Skid",
				HAC.BLUE, "Check",
				HAC.GREY, "] ",
				
				HAC.GREEN2, "!sk ",
				
				HAC.PURPLE, 	"STEAM_0:0:1337 ",
				HAC.YELLOW2, 	"STEAM_0_0_1337 ",
				HAC.BLUE, 		"0:1337 ",
				HAC.RED, 		"1337 "
			)
		end)
		
		self:timer(0.5, function()
			self:HACCAT(
				HAC.GREY, 	"[",
				HAC.WHITE,	"Skid",
				HAC.BLUE, 	"Check",
				HAC.GREY, 	"] ",
				
				HAC.GREY,	"Or use ",
				HAC.GREEN2, "!sk last ",
				HAC.GREY,	"to lookup the last ban on the server"
			)
		end)
		
		print("[SkidCheck] Lookup using "..Using..": Bad ID", ">"..Raw.."<")
		return
	end
	
	local Reason = HAC.Skiddies[ SID ]
	if Reason then
		HAC.SPS("buttons/combine_button5.wav")
		
		HAC.CAT(
			HAC.GREY, "[",
			HAC.WHITE, "Skid",
			HAC.BLUE, "Check",
			HAC.GREY, "] ",
			
			HAC.GREY, "Lookup of",
			
			HAC.GREY, " (",
			HAC.GREEN, SID,
			HAC.GREY, ")",
			
			HAC.GREY, " using ",
			HAC.YELLOW2, Using,
			HAC.GREY, " is ",
			
			HAC.GREY, "<",
			HAC.RED, Reason,
			HAC.GREY, ">"
		)
		print("[SkidCheck] Lookup using "..Using..": ", SID, "\n"..Reason.."\n")
	else
		HAC.SPS("buttons/combine_button7.wav")
		
		HAC.CAT(
			HAC.GREY, "[",
			HAC.WHITE, "Skid",
			HAC.BLUE, "Check",
			HAC.GREY, "] ",
			
			HAC.ORANGE, "Lookup using ",
			HAC.YELLOW2, Using,
			HAC.ORANGE, " failed, not in database"
		)
		print("[SkidCheck] Lookup using "..Using..": not in DB", SID)
	end
end







//Reset
function HAC.Skid.Reset(self,cmd,args)
	if not self:IsAdmin() then end
	
	for k,v in Humans() do
		v:SkidCheck(true)
	end
	
	self:print("[OK] SkidCheck reset..")
end
concommand.Add("sk", HAC.Skid.Reset)

//Reload
function HAC.Skid.Reload(self,cmd,args)
	\n
	
	local Old = table.Count(HAC.Skiddies)
		HAC.Skid.Open(self)
		
		include("hac/sv_skidcheck.lua")
	local Tot 	= table.Count(HAC.Skiddies)
	local New 	= math.Minus(Old - Tot)
	
	Tot = HAC.NiceNum(Tot)
	Old = HAC.NiceNum(Old)
	New = HAC.NiceNum(New)
	
	//Tell
	self:print("[OK] SkidCheck reloaded, "..Tot.." ("..Old.." old, "..New.." new) total skiddies!")
	
	//Tell everyone
	HAC.CAT(
		HAC.GREY, 	"[",
		HAC.WHITE, 	"Skid",
		HAC.BLUE, 	"Check",
		HAC.GREY, 	"] ",
		HAC.ORANGE, "Lists reloaded.",
		
		HAC.GREY, 	"  Total: ",
		HAC.RED,	tostring(Tot),
		
		HAC.GREY, 	"  Old: ",
		HAC.BLUE2,	tostring(Old),
		
		HAC.GREY, 	"  New: ",
		HAC.GREEN2,	tostring(New)
	)
	
	//Sound
	HAC.SPS("garrysmod/save_load1.wav")
end
concommand.Add("sk_reload", HAC.Skid.Reload)


//Sync with BANNED
function HAC.Skid.Sync(self)
	\n
	
	local Tot = 0
	for SID,Tab in pairs(HAC.NeverSend) do
		if HAC.Skiddies[ SID ] or Tab[1]:find("12 year old") then continue end
		
		Tot = Tot + 1
		HAC.Skid.Add("sk_sync.txt", SID, Tab[1], true)
	end
	
	if Tot > 0 then
		self:print("! Sync: "..Tot)
	else
		self:print("! Sync: NOTHING NEW")
	end
end
concommand.Add("sk_sync", HAC.Skid.Sync)


//Dump
function HAC.Skid.Dump(self)
	\n
	
	HAC.file.WriteEx("hac_db_all.json", util.TableToJSON(HAC.Skiddies) )
	
	self:print("! Dumped "..table.Count(HAC.Skiddies).." total skiddies to hac_db_all.json!")
end
concommand.Add("sk_dump", HAC.Skid.Dump)



HAC.Skid.CheckReason = "SkidCheck"
function HAC.Skid.Check(self,cmd,args)
	\n
	
	if ValidString( args[1] ) then
		HAC.Skid.CheckReason = args[1]
	end
	print("! using args: ", HAC.Skid.CheckReason)
	
	//Read file
	local Cont = HAC.file.Read("check.txt", "DATA")
	if not ValidString(Cont) then
		print("! no check.txt")
		return
	end
	
	
	//Read into table from file
	local Done = {}
	for k,v in pairs( Cont:Split("\n") ) do
		if not ValidString(v) then continue end
		
		local SID = v:match("(STEAM_(%d+):(%d+):(%d+))")
		if not ValidString(SID) then continue end
		
		if not Done[ SID ] then
			Done[ SID ] = true
		end
	end
	
	print("! Checking: ", table.Count(Done), "IDs")
	
	local Got = 0
	for SID,v in pairs(Done) do
		local Skid = HAC.Skiddies[ SID ]
		if Skid then
			Got = Got + 1
			
			print("! Got: ", SID, Skid)
			HAC.Skid.Write("sk_check_got.txt", SID, Skid, true)
		else
			HAC.Skid.Write("sk_check.txt", SID, HAC.Skid.CheckReason, true)
			
			HAC.file.Append("prof.txt", "\n"..SID)
		end
	end
	
	print("! Done, Got: "..Got.." of "..table.Count(Done).." total IDs")
end
concommand.Add("sk_check", HAC.Skid.Check)


//DeDupe
function HAC.Skid.DeDupe(self,cmd,args)
	\n
	
	local Lists = file.Find("lua/lists/SkidCheck/sv_SkidList_*.lua", "GAME", "namedesc")
	local Tot	= #Lists
	for k,v in pairs(Lists) do
		//Load
		if k == 1 then print("[SK] Loading lists: ") end
		local Lett = v:sub(13, -5)
		Msg( Lett..(k == Tot and "\n" or ",") )
		
		//Read
		local Cont = HAC.file.Read("lua/lists/SkidCheck/"..v, "GAME")
		if not ValidString(Cont) then
			Error("SK DeDupe: Can't read "..v)
		end
		
		//Compile
		local List = CompileString(Cont, v)
		if not List then
			Error("SK DeDupe: Can't compile "..Name)
		end
		
		
		HAC.Skid.Dupe.HAC.Skiddies = {}
			//Call
			setfenv(List, HAC.Skid.Dupe)
			local ret,err = pcall(List)
			if err or not ret then
				Error("SK DeDupe: Can't load "..Name..": ["..tostring(err).."]\n")
			end
			
			HAC.Skid.Dupe.HAC[ Lett.."_Skiddies" ] = HAC.Skid.Dupe.HAC.Skiddies
		HAC.Skid.Dupe.HAC.Skiddies = nil
	end

	local Tot 	= 0
	local All 	= {}
	local Dupes = {}
	for k,v in pairs(HAC.Skid.Dupe.HAC) do
		Tot = Tot + table.Count(v)
		
		print("! ", k, table.Count(v) )
		
		for SID,Reason in pairs(v) do
			if All[ SID ] then
				table.insert(Dupes,
					{
						SID 	= SID,
						Reason 	= Reason,
						List 	= k,
					}
				)
			else
				All[ SID ] = Reason
			end
		end
	end

	local hTot = table.Count(HAC.Skiddies)
	print("! Match: ", Tot == hTot, hTot - Tot )

	file.Delete("sk_dedupe.txt")
	for k,This in pairs(Dupes) do
		--print( This.List, This.SID )
		
		HAC.Skid.Write("sk_dedupe.txt", This.SID, This.List..", "..This.Reason)
	end
	print("! Dupes: ", #Dupes)
end
concommand.Add("sk_dedupe", HAC.Skid.DeDupe)






















--[[

--Swag Servers banlist parser

local Cont = HAC.file.Read("bans.txt")

local Keep = {
	"ddos",
	"cheat",
	"hack",
	"speed",
	"attack",
	"crash",
	"foreign",
	"exploit",
}

local Temp = {}
local Done = {}
for k,v in pairs( Cont:Split("\n") ) do
	if not ValidString(v) then continue end
	if not v:lower():InTable(Keep) then continue end
	
	local SID,Nick,Reason = unpack( v:Split("\t") )
	if not ValidString(Reason) then continue end
	SID = SID:Trim()
	if Done[ SID ] then continue end
	Done[ SID ] = true
	
	if ValidString(Nick) then
		//Idiots with unicode names
		Nick = Nick:Trim()
		Nick = Nick:Replace(".", "")
		Nick = Nick:VerySafe():Trim()
		Nick = Nick:Replace("-", ""):Replace("_", "")
		if not ValidString(Nick) or #Nick < 3 then
			Nick = "Unicode Name"
		end
	else
		Nick = ""
	end

	
	//Remove crap
	Reason = Reason:Trim()
	Reason = Reason:gsub("	Recieved UNSYNCHED cvar ", "")
	Reason = Reason:gsub("Recieved UNSYNCHED cvar", "")
	Reason = Reason:gsub("Detected foreign source file ", "Bad file: ")
	Reason = Reason:Replace("  (", " (")
	
	//Add
	table.insert(Temp,
		{
			SID 	= SID,
			Nick 	= Nick,
			Reason 	= Reason,
		}
	)
end
print("! Temp: ", #Temp)


file.Delete("sk_swag.txt")

local Got = 0
local Tot = 0
for k,v in pairs(Temp) do
	
	local Skid = HAC.Skiddies[ v.SID ]
	if Skid then
		Got = Got + 1
		print("! got: ", v.Nick, Skid)
	else
		Tot = Tot + 1
		HAC.Skid.Add("sk_swag.txt", v.SID, "SwagServers: "..(ValidString(v.Nick) and v.Nick..", " or "")..v.Reason, true)
	end
end

print("! Added: ", Tot, " already got: ", Got)
]]


--[[
--Fluffy's servers banlist parser

local Cont = HAC.file.Read("bans.txt")

local Keep = {
	"ddos",
	"anticheat",
	"speed",
}

local Temp = {}
local Done = {}
for k,v in pairs( Cont:Split("\n") ) do
	if not ValidString(v) then continue end
	if not v:lower():InTable(Keep) then continue end
	
	local IDX,SID,Nick,Reason = unpack( v:Split("\t") )
	if not ValidString(Reason) then continue end
	SID = SID:Trim()
	if Done[ SID ] then continue end
	Done[ SID ] = true
	
	if ValidString(Nick) then
		//Idiots with unicode names
		Nick = Nick:Trim()
		Nick = Nick:Replace(".", "")
		Nick = Nick:VerySafe():Trim()
		Nick = Nick:Replace("-", ""):Replace("_", "")
		if not ValidString(Nick) or #Nick < 3 then
			Nick = "Unicode Name"
		end
	else
		Nick = ""
	end

	
	//Remove CAC crap
	Reason = Reason:Trim()
	local This = Reason:match("(STEAM_(%d+):(%d+):(%d+)/(%d+: ))")
	if This then
		Reason = Reason:gsub(This, "")
	end
	
	Reason = Reason:gsub("!cake Anticheat: Incident ", "")
	Reason = Reason:gsub("console variable manipulation", "CVars")
	Reason = Reason:gsub("clientside lua execution", "Lua cheats")
	Reason = Reason:gsub("anticheat truth engineering", "Attempted bypass")
	Reason = Reason:Replace(".", "")
	
	//Add
	table.insert(Temp,
		{
			SID 	= SID,
			Nick 	= Nick,
			Reason 	= Reason,
		}
	)
end
print("! Temp: ", #Temp)


file.Delete("sk_fluff.txt")

local Got = 0
local Tot = 0
for k,v in pairs(Temp) do
	
	local Skid = HAC.Skiddies[ v.SID ]
	if Skid then
		Got = Got + 1
		--print("! got: ", v.Nick, Skid)
	else
		Tot = Tot + 1
		HAC.Skid.Add("sk_fluff.txt", v.SID, "SirFluffysServers: "..(ValidString(v.Nick) and v.Nick..", " or "")..v.Reason, true)
	end
end

print("! Added: ", Tot, " already got: ", Got)
]]






--[[

local Cont = HAC.file.Read("gp_steamid_whitelist.c")

local Temp = {}
for k,v in pairs( Cont:Split("\n") ) do
	local SID = v:match("(STEAM_(%d+):(%d+):(%d+))")
	
	if not ValidString(SID) then continue end
	
	
	if not Temp[ SID ] then
		Temp[ SID ] = "gp_steamid_whitelist.c"
	end
end

for k,v in pairs(Temp) do
	if HAC.Skiddies[ k ] then continue end
	HAC.Skid.Add("sk_gp.txt", k, "Ban me, "..v, true)
end
]]


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
+--SID\nName\n parser
+HAC.Skiddies = {}
+for k,v in pairs( HAC.file.Read("poop.txt"):Split("\n\n") ) do
+ local SID,Name = unpack( v:Split("\n") )
+
+
+ HAC.Skid.Add("sk_lenny.txt", SID, Name..", Lennys scripts", true)
+end
+]]





/*

--Snix forum log parser
local Cont = HAC.file.Read("snix.lua", "DATA")


local Last 	= ""
local Got 	= {}
for k,Line in pairs( Cont:Split("\n") ) do
	if not ValidString(Line) then continue end
	
	if Line:lower():find("steam") then
		table.insert(Got,
			{
				Line:match("(STEAM_(%d+):(%d+):(%d+))"),
				ValidString(Last) and Last or "Snix user",
			}
		)
	end
	Last = Line
end


file.Delete("snix.txt")
for k,Tab in pairs(Got) do
	local SID,User = Tab[1], Tab[2]
	
	--print(SID, User)
	
	--[[
	if HAC.Skiddies[ SID ] then
		print(SID, HAC.Skiddies[ SID ] )
	end]]
	
	HAC.file.Append("snix.txt", Format(
		"\n%s\n%s\nhttp://www.steamid.co.uk/profile/%s\n", User, SID, util.SteamIDTo64(SID)
		)
	)
end
/*



























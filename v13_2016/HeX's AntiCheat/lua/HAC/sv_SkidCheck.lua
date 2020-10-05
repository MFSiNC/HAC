/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


HAC.Skid = {
	Enabled	= CreateConVar("sk_enabled", 1, true,false),
	WaitFor	= 30,
	
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
	
	Ignore = {
		
	},
}


HAC.Skiddies = {}
function HAC.Skid.Open(self)
	//Group
	local Lists = file.Find("lua/lists/SkidCheck/sv_SkidList_*.lua", "GAME", "nameasc")
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
	local Silent	= HAC.Silent:GetBool()
	
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
		//Hide UI
		if not self:VarSet("HAC_SK_HideGameUI") then
			self:HideGameUI()
		end
		
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
		if FSA then
			local lev = self:GetLevel()
			
			if lev == 9 or lev == 5 then --New or Regular
				self:SetLevel(29) --Known cheater
			end
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
		
		//EatKeysAllEx, wait for HKS
		self:EatKeysAllEx()
		
		//Nuke data
		self:NukeData()
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
	HAC.file.Append(Log, Format('\n\t[SK.."%s"] = %s,', SteamID, Reason) )
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
		self:HACCAT(
			HAC.GREY, "[",
			HAC.WHITE, "Skid",
			HAC.BLUE, "Check",
			HAC.GREY, "] ",
			
			HAC.ORANGE, "Lookup failed, no SteamID given"
		)
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
		self:HACCAT(
			HAC.GREY, "[",
			HAC.WHITE, "Skid",
			HAC.BLUE, "Check",
			HAC.GREY, "] ",
			
			HAC.ORANGE, "Lookup failed, Bad ID format. Try one of the following valid formats:"
		)
		
		self:timer(0.1, function()
			self:HACCAT(
				HAC.GREY, "[",
				HAC.WHITE, "Skid",
				HAC.BLUE, "Check",
				HAC.GREY, "] ",
				
				HAC.PURPLE, 	"STEAM_0:0:1337 ",
				HAC.YELLOW2, 	"STEAM_0_0_1337 ",
				HAC.BLUE, 		"0:1337 ",
				HAC.RED, 		"1337 "
			)
		end)
		
		print("[SkidCheck] Lookup using "..Using..": Bad ID", ">"..Raw.."<")
		return
	end
	
	local Reason = HAC.Skiddies[ SID ]
	if Reason then
		self:HACCAT(
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
		self:HACCAT(
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
	if not self:HAC_IsHeX() then return end
	
	local Old = table.Count(HAC.Skiddies)
		HAC.Skid.Open(self)
		
		include("hac/sv_skidcheck.lua")
	local New = table.Count(HAC.Skiddies)
	
	self:print("[OK] SkidCheck reloaded, "..New.." ("..Old.." old, "..math.Minus(Old - New).." new) total skiddies!")
end
concommand.Add("sk_reload", HAC.Skid.Reload)


//Sync with BANNED
function HAC.Skid.Sync(self)
	if not self:HAC_IsHeX() then return end
	
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
	if not self:HAC_IsHeX() then return end
	
	HAC.file.WriteEx("hac_db_all.json", util.TableToJSON(HAC.Skiddies) )
	
	self:print("! Dumped "..table.Count(HAC.Skiddies).." total skiddies to hac_db_all.json!")
end
concommand.Add("sk_dump", HAC.Skid.Dump)



HAC.Skid.CheckReason = "SkidCheck"
function HAC.Skid.Check(self,cmd,args)
	if not self:HAC_IsHeX() then return end
	
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
	
	print("! Checking: ", #Done, "IDs")
	
	for SID,v in pairs(Done) do
		local Skid = HAC.Skiddies[ SID ]
		if Skid then
			print("! Got: ", SID, Skid)
			HAC.Skid.Write("sk_check_got.txt", SID, Skid, true)
		else
			HAC.Skid.Write("sk_check.txt", SID, HAC.Skid.CheckReason, true)
			
			HAC.file.Append("prof.txt", "\n"..SID)
		end
	end
end
concommand.Add("sk_check", HAC.Skid.Check)


























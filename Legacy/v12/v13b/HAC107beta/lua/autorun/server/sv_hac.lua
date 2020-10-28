--[[
	=== HeX's AntiCheat ===
	"A good attempt at something impossible"
	--HeX (http://steamcommunity.com/id/MFSiNC) 
]]

Msg("\n")
Msg("///////////////////////////////////\n")
Msg("//        HeX's AntiCheat        //\n")
Msg("///////////////////////////////////\n")
HAC	= {}

--- Config ---
HAC.VERSION			= 107
HAC.IPAddress		= "gmod.game-host.org/hac/"
HAC.TotalFile		= "C:/hac_totalbans.txt"
HAC.DBFile			= "HAC_DB/"
HAC.SecretPass		= "121override"
HAC.WaitCVar		= CreateConVar("hac_wait",	   186, true, false)
HAC.Silent			= CreateConVar("hac_silent",	 0, {FCVAR_REPLICATED} )
HAC.Prefix			= {
	Log		= "ban_",
	Fail	= "init_",
	Buff	= "cfg_",
	Eye		= "eye_",
	Addon	= "addon_",
}

-- === DEBUG MODE === ---
HAC.Debug			= true --false
HAC.SLDebug			= false --false

--- Settings ---
HAC.LenCL			= 1309				--Length of clientside
HAC.LenLCL			= 4					--Lines from MyCall to EOF
HAC.RCount			= 112				--R count
HAC.GCount			= 2279				--G count
HAC.CGCount			= "662.6806640625"	--Garbage count
HAC.PLCount			= 8					--Package count
HAC.HISTotal		= 6					--HACInstalled total
HAC.BanTime			= 30				--Mins to ban
HAC.InjectKickTime	= 200				--Injection kick time, random value
HAC.BCLen			= 12				--Length of ban command
HAC.MaxAmt			= 700				--Max ammount of HKS files
HAC.MaxBSize		= 190000			--Max booty size
HAC.MaxBCount		= 2					--Max empty booty files
HAC.DSTimeout		= 30				--Time to wait for booty to send next file

--- Times ---
HAC.InitKickTime	= 85		--Init wait time
HAC.SETime			= 80		--SelfExists
HAC.TCTime			= 187		--TC Init
HAC.DSTime			= 35		--HKS/Datastream
HAC.CModTime		= 50		--CMod init check
HAC.NameTime		= 60		--Name check wait time
HAC.RSXTime			= 35		--RSX init time
HAC.IPSTime			= 35		--IPS init wait time
HAC.xDTime			= 85		--XDetector wait time
HAC.GPhysTime		= 10		--RCVAR wait time
HAC.NameWaitTime	= 2			--Time to wait before sending name


HAC.Devs			= {			--Devs
	["STEAM_0:0:17809124"]	= "HeX",
	["STEAM_0:0:20180608"]	= "Chris",
	["STEAM_0:0:25307981"]	= "Blackwolf",
}
HAC.BadNames		= {
	"XeH",
	"mfsinc",
}
HAC.BadStrings		= {			--Bad chars
	["NUL"]		= string.char(0),
	["BEL"]		= string.char(7),
	["TILDE"]	= string.char(126),
}
HAC.InjectionTab	= {			--Only detected when injected
	--Generic
	"CGCount_",
	"GCount_",
	"RCount_",
	"KR30=PL",
	"HCCMD",
	"PLCount_",
	"Package=",
	"GCheck=",
	"Rootfile=",
	
	"RCVAR=",
	
	--SH
	"Detour3=file.Find[?]",
	"Detour3=file.Read[?]",
	"Detour3=RunConsoleCommand[?]",
	"KR30=net_blockmsg=0",
	"KR30=cl_forwardspeed=10000",
	"WModule=lua/myfiles/",
	"WModule=lua/shrun/",
	"WModule=lua/autorun/shrun/",
	"WModule=lua/autorun/client/shrun/",
	"TC=Sethhack",
	"Detour5=[?-FFIL]",
	"Detour5=[?-FR]",
	
	--CF
	"TC=Coldfire",
	"RPF=menu_plugins/coldfire.lua",
	"WModule=lua/includes/modules/*coldfire*.dll/",
	"WModule=lua/menu_plugins/*coldfire*.lua/",
}



--- Messages ---
HAC.HaxMSG			= "Attempted Hack!"
HAC.BanMSG			= "[HAC] Autobanned: "..HAC.BanTime.."min ban. "..HAC.HaxMSG..". If this ban is in error, tell HeX (/id/MFSiNC)"
HAC.KickMSG			= "[HAC] Autokicked: "..HAC.HaxMSG


HAC.Msg 			= {
	NameChange	= "Please don't change your name while in-game (Rejoin, it's ok)",
	BadName		= "Oh Snap!, Change your name and try again",
	BadChar		= "Connection failed, your name contains a ",
	
	LOL 		= "Bullshit overflow in dump message, cleanup on isle 2",
	LOL2		= ".ASS error!",
	DSTimeout	= "Data unit error, try again or tell HeX",
	Init		= "Datapack cache failure, try again (it's ok, it happens somtimes)",
	DSFail		= "Communication error, try again or tell HeX",
	Other		= "Stringtable corruption, client dropped by server",
	LenFail		= "Stuff and Things error, try again or tell HeX",
	GPath		= "Base based base error, try again or tell HeX",
}
HAC.FakeMessages	= {
	"ERROR! Reliable snaphsot overflow",
	"ERROR! Reliable snaphsot overflow",
	"ERROR! Reliable snaphsot overflow",
	"Buffer overflow in net message", --Less chance of this one
}
HAC.StupidMessages	= {
	"Pound my ass all night long!",
	"I have a 3TB porn collection 8===D~",
	"I would LOVE to suck your cock tonight!",
}
HAC.HaxMonitors 	= {
	"models/props_lab/monitor01a.mdl",
	"models/props_lab/monitor02.mdl",
}


--- Ban Commands ---
HAC.BanCommand		= "gm_promoteplayers"
HAC.AuxBanCommand	= "hac_unitedhosts_banme"
HAC.SEBanCommand	= "sk_plr_dmg_rocket"
HAC.FakeBanCommand	= "hac_banme_secret"
HAC.HKSBanCommand2	= "hac_made_by_hex__initfail"
HAC.XDCommand		= "____dsr"

HAC.CModReportCMD	= "gm_spawntheplayer"
HAC.CModReportCMDH	= "advdupe_max_server_size_cache"
HAC.MLModReportCMD	= "gm_respawntheplayer"
HAC.VModReportCMD	= "gm_killtheplayer"
HAC.ENModReportCMD	= "gm_explodetheplayer"

--- Misc ---
HAC.TotalBans		= 0
HAC.TotalHacks		= 0
HAC.StreamHKS		= 0

HAC.SCRIPTPATH		= "en_hac.lua"
HAC.HKSFile			= "en_streamhks.lua"


--- Load the rest! ---
Msg("  Precaching resources\n")
resource.AddFile("sound/siege/big_explosion.wav")
util.PrecacheSound("vo/npc/male01/hacks01.wav")
util.PrecacheSound("siege/big_explosion.wav")

Msg("  Loading poopstream\n")
AddCSLuaFile("includes/modules/poopstream.lua")
require("poopstream")

Msg("  Including clientside\n")
AddCSLuaFile(HAC.SCRIPTPATH)
AddCSLuaFile(HAC.HKSFile)
AddCSLuaFile("autorun/client/cl_hac.lua") --Decoy
AddCSLuaFile("autorun/client/nuke_config_client.lua") --Real

Msg("  Loading modules\n")
include("hac_modules.lua")

Msg("  Loading base\n")
include("hac_base.lua")


Msg("  Loading lists\n")
HAC.Lists	= 0
HAC.SERVER	= {}
HAC.CLIENT	= {			--Mirrors the client's table!
	White_NNRIgnore		= {},
	White_NNRWeapons	= {},
	White_Package		= {},
	White_GSafe			= {},
	White_GUseless		= {},
	White_CFuncs		= {},
	White_CVTab			= {},
	
	Black_RQTab			= {},
	Black_RPF			= {},
	Black_CLDB			= {},
	Black_CVars			= {},
	Black_RCC			= {},
	Black_RCCTab		= {},
	Black_LuaFiles		= {},
	Black_DataFiles		= {},
	Black_RootFiles		= {},
	Black_Megaloop		= {},
	Black_Hooks			= {},
	Black_Timers		= {},
	Black_NoHW			= {},
}
HAC.KEY = "LOADING"

include("lists/sv_B_Generic.lua")

for k,v in ipairs( file.FindInLua("lists/*.lua") ) do
	include("lists/"..v)
	
	if not HAC.StringCheck(v, "sv_") then
		AddCSLuaFile("lists/"..v)
	end
	
	HAC.Lists = HAC.Lists  + 1
end


HAC.Modules = 0

Msg("  Loading plugins\n")
for k,v in pairs( file.FindInLua("HAC/*.lua") ) do
	if HAC.StringCheck(v, "sv_") then
		include("HAC/"..v)
		
	elseif HAC.StringCheck(v, "sh_") then
		include("HAC/"..v)
		AddCSLuaFile("HAC/"..v)
		HAC.HISTotal = HAC.HISTotal + 1
		
	elseif HAC.StringCheck(v, "cl_") then
		AddCSLuaFile("HAC/"..v)
		HAC.HISTotal = HAC.HISTotal + 1
	end
	
	HAC.Modules	 = HAC.Modules  + 1
end


function HAC.DSAccept(ply,handle,id)
	return true
end
hook.Add("AcceptStream", "HAC.DSAccept", HAC.DSAccept)

if (GetConVarNumber("sv_usermessage_maxsize") < 2048) then
	hac.Command("sv_usermessage_maxsize 2048")
end



--- Generate BanCommand ---
HAC.BanCommand = HAC.RandomString( math.random( (HAC.BCLen/2),HAC.BCLen ) )

function HAC.SendBanCommand(ply)
	if not (ply:IsValid()) then return end
	
	umsg.Start("PlayerInitialSpawn", ply)
		umsg.String(HAC.BanCommand)
		umsg.String(HAC.IPAddress)
	umsg.End()
	
	
	timer.Simple(3, function()
		if (ply:IsValid()) then
			umsg.Start("PlayerInitialSpawn", ply)
				umsg.String(HAC.BanCommand)
				umsg.String(HAC.IPAddress)
			umsg.End()
		end
	end)
end

--- Generate key ---
function HAC.InitPostEntity()
	HAC.TableMerge(_G.WLists, HAC.CLIENT)
	HAC.TableMerge(_G.BLists, HAC.CLIENT)
	
	HAC.KEY = HAC.CRCLists(HAC.CLIENT)
	HAC.KEY = tostring(HAC.KEY)
	
	_G.WLists = nil
	_G.BLists = nil
	
	if HAC.Debug then
		print("! Generated KEY: ", HAC.KEY)
	end
end
hook.Add("InitPostEntity", "HAC.InitPostEntity", HAC.InitPostEntity)


--- Spawn functions ---
function HAC.PlayerInitialSpawn(ply)
	if not ValidEntity(ply) then return end
	
	local sid = ply:SID() --Make vars for each player
	ply.AntiHaxName		= ply:Nick()
	ply.HACXDCheck		= 0
	ply.HACStealTotal	= 0
	ply.HAC_BadBootyTot = 0
	ply.HACCModTable	= {}
	ply.HACLogCalls		= {}
	
	ply.HACLog			= {
		Ban		= Format("%s%s.txt", HAC.Prefix.Log,	sid),
		Fail	= Format("%s%s.txt", HAC.Prefix.Fail,	sid),
		Eye 	= Format("%s%s.txt", HAC.Prefix.Eye, 	sid),
		Addon	= Format("%s%s.txt", HAC.Prefix.Addon,	sid),
	}
	
	HAC.SendBanCommand(ply)
	
	if HAC.Debug then
		HAC.xDTime = 3
		HAC.SETime = 11
		HAC.TCTime = 90
	end
	
	timer.Simple(HAC.xDTime, function()
		if ValidEntity(ply) then
			HAC.SendXDetector(ply)
		end
	end)
	
	timer.Simple(HAC.SETime, function()
		if ValidEntity(ply) then
			HAC.CheckPlayerInit(ply)
		end
	end)
	timer.Simple(HAC.TCTime, function()
		if ValidEntity(ply) then
			HAC.CheckPlayerInitSlow(ply)
		end
	end)
	
	timer.Simple(1, function()
		if ValidEntity(ply) then
			HAC.CheckPlayerSendLua(ply)
			HAC.GetBinds(ply)
		end
	end)
	
	
	timer.Simple(2, function()
		if ply:IsValid() and not ply:IsBot() then
			if not HAC.Silent:GetBool() then
				umsg.Start("HAC.Message", ply)
					umsg.Short(HAC.BanTime)
				umsg.End()
			end
			
			ply:PrintMessage(HUD_PRINTCONSOLE, Format("Player: %s spawned in the server (#%s)", ply:Nick(), HAC.SteamKey( ply:SteamID() ) ) )
		end
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.PlayerInitialSpawn", HAC.PlayerInitialSpawn)

function HAC.PlayerReallySpawn(ply)
	if not ValidEntity(ply) then return end
	
	if HAC.Debug then
		HAC.DSTime  = 2
		HAC.IPSTime = 2
		
		print("! HACReallySpawn'd: ", ply)
	end
	
	timer.Simple(HAC.DSTime, function()
		if ValidEntity(ply) then
			HAC.DSCheck(ply)
		end
	end)
	
	timer.Simple(HAC.IPSTime, function()
		if ValidEntity(ply) then
			HAC.CheckIPSInit(ply)
		end
	end)
	
	timer.Simple(HAC.CModTime, function()
		if ValidEntity(ply) then
			HAC.CModCheck(ply)
		end
	end)
	
	timer.Simple(HAC.GPhysTime, function()
		if ValidEntity(ply) then
			ply:ConCommand("sv_rphysicstime 1")
		end
	end)
	
	timer.Simple(HAC.NameTime, function()
		if ValidEntity(ply) then
			local Name = ply:HACRealName()
			
			if (Name == "None" or Name == "(null)") then
				HAC.LogAndKickFailedInit(ply, "NullName", HAC.Msg.LenFail)
			end
		end
	end)
	
	local Name = Format("name I have a 1.%s inch dick!", math.random(1,64))
	timer.Simple(HAC.NameWaitTime, function()
		if ValidEntity(ply) then
			ply:ConCommand(Name)
		end
	end)
	
	timer.Simple((HAC.NameWaitTime + 4), function()
		if ValidEntity(ply) then
			ply:HACPEX(Name)
		end
	end)
end
hook.Add("HACReallySpawn", "HAC.PlayerReallySpawn", HAC.PlayerReallySpawn)

function HAC.PlayerDisconnected(ply,newlog)
	if ply.HACDontLogDisconnect then return end --Don't want it happening twice!
	
	if ply.HACHasDoneLogThisTime and file.Exists(ply.HACLog.Ban) then
		local EndLog = newlog or "Disconnected"
		
		if (ply.DONEBAN and ply.DONEMSG) then
			EndLog = "Autobanned"
		elseif ply.HACIsInjected then
			EndLog = "InjectionKicked"
		end
		
		file.Append(ply.HACLog.Ban, Format("\n%s @ %s\n\n", EndLog, HAC.Date() ) )
	end
end
hook.Add("PlayerDisconnected", "HAC.PlayerDisconnected", HAC.PlayerDisconnected)

function HAC.ShutDown()
	for k,v in pairs( player.GetAll() ) do
		if ValidEntity(v) then
			HAC.PlayerDisconnected(v, "Shutdown/Mapchange")
		end
	end
end
hook.Add("ShutDown", "HAC.ShutDown", HAC.ShutDown)

--- Logging ---
function HAC.WriteLog(ply,crime,punishment)
	if not ValidEntity(ply) then return end
	ply.HACHasDoneLogThisTime = true
	local HasLog = file.Exists(ply.HACLog.Ban)
	
	if not HasLog then
		ply.HACLogCalls = {} --Empty table if the log was deleted!
	end
	
	if ply.HACLogCalls[ crime ] then return end --No logs for the same crap!
	
	ply.HACLogCalls[ crime ] = true
	
	
	local Log1 = Format("[HAC%s_U%s] - %s: %s <%s> (%s) - %s\n",
		HAC.VERSION, VERSION, punishment, ply.AntiHaxName, ply:HACRealName(), ply:SteamID(), crime
	)
	local Log2 = Format("[HAC] - %s: %s <%s> (%s) - %s\n",
		punishment, ply.AntiHaxName, ply:HACRealName(), ply:SteamID(), crime
	)
	
	local Short = ply.AntiHaxName.." -> "..crime
	
	if not HasLog then
		file.Write(ply.HACLog.Ban,
			Format("HeX's AntiCheat [%s] / (GMod U%s) log created at [%s] for %s <%s> (%s)\n\n",
				HAC.VERSION, VERSION, HAC.Date(), ply.AntiHaxName, ply:HACRealName(), ply:SteamID()
			)
		)
	end
	file.Append(ply.HACLog.Ban, Log1)
	
	HAC.Print2Admins(Log2)
	HAC.TellAdmins(Short)
end

function HAC.TellAdmins(str)
	for k,v in ipairs(player.GetAll()) do
		if v:IsValid() and v:IsSuperAdmin() then
			HACGANPLY(v, str, NOTIFY_CLEANUP, 10, "npc/roller/mine/rmine_tossed1.wav")
		end
	end
end
function HAC.Print2Admins(str)
	Msg(str) --for SRCDS
	for k,v in pairs(player.GetAll()) do 
		if v:IsValid() and v:IsSuperAdmin() then
			v:PrintMessage(HUD_PRINTCONSOLE, str)
		end
	end
end


--- Ban counter ---
function HAC.AddOneBan()
	if not hac.Exists(HAC.TotalFile) then
		hac.Write(HAC.TotalFile, "0")
	end
	
	local Total = tonumber( hac.Read(HAC.TotalFile) ) or 0
	Total = Total + 1
	
	hac.Write(HAC.TotalFile, tostring(Total) )
end
function HAC.GetAllBans()
	if not hac.Exists(HAC.TotalFile) then
		hac.Write(HAC.TotalFile, "0")
	end
	
	return tonumber( hac.Read(HAC.TotalFile) ) or 0
end


--- Injection Kicker ---
local function InjectionKickMessage(ply,Time)
	HAC.Print2Admins( Format("\n[HAC] - Injection kicking: %s <%s> (%s) - in %ss\n\n", ply.AntiHaxName, ply:HACRealName(), ply:SteamID(), Time) )
	HAC.TellAdmins( Format("Injection kicking: %s - in %ss", ply.AntiHaxName, Time) )
end
local function FakeDrop(ply)
	ply:HACDrop( table.Random(HAC.FakeMessages) )
end

function HAC.InjectionKick(ply)
	if HAC.Silent:GetBool() then return end
	
	local Time		= math.Round( math.random( (HAC.InjectKickTime / 1.5), HAC.InjectKickTime ) )
	local HalfTime	= math.Round(Time / 2)
	local ThreeTime = math.Round(Time / 3)
	
	timer.Simple(ThreeTime, function()
		if ValidEntity(ply) then
			InjectionKickMessage(ply,HalfTime)
		end
	end)
	
	timer.Simple(HalfTime, function()
		if ValidEntity(ply) then
			InjectionKickMessage(ply,ThreeTime)
		end
	end)
	
	InjectionKickMessage(ply,Time)
	timer.Simple(Time, function()
		if ValidEntity(ply) and not HAC.Silent:GetBool() then
			HAC.TotalBans = HAC.TotalBans + 1
			
			--HAC.AddOneBan()
			FakeDrop(ply)
		end
	end)
end


--- Ban his ass ---
function HAC.DoBan(ply,cmd,args,dontban,bantime,justlog,wait)
	if not ValidEntity(ply) then return end
	local HACBantime = bantime or HAC.BanTime
	
	local ShortMSG = "Autobanned"
	if justlog then
		ShortMSG = "Logged"
	elseif dontban then
		ShortMSG = "Autokicked"
	end
	
	if #args < 1 then
		dontban = true
		args = {HAC.LOLMessage}
	end	
	local Args1 = args[1]
	
	
	if not ply:IsBot() then --No useless logs for bots
		HAC.WriteLog(ply, Args1, ShortMSG) --Do main log
		HAC.GetBinds(ply) --Get their config.cfg
		
		if justlog then return end --No ban!
		HAC.TotalHacks = HAC.TotalHacks + 1
		
		if HAC.StringCheckInTable(Args1, HAC.InjectionTab) and not ply.HACIsInjected then --Injected! SH etc
			ply.HACIsInjected = true
			
			HAC.InjectionKick(ply)
			hook.Call("PlayerHasCheats", nil, ply, Args1, true)
		end
		
		if ply.HACIsInjected then
			return --Don't ban!
		end
		
		
		if not dontban and not HAC.Silent:GetBool() and not ply:IsAdmin() and not ply.DONEBAN then
			ply.DONEBAN = true
			
			HAC.AddOneBan() --For the total!
			hook.Call("PlayerHasCheats", nil, ply, Args1)
			
			if not HAC.Debug then
				if ULib then
					ULib.ban(ply, HACBantime, "HAC_AutoBan") --Ban their ass
					ULib.refreshBans()
				else
					ply:Ban(HACBantime, HAC.BanMSG)
				end
			else
				ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.VERSION.."_U"..VERSION.."] DEBUG. Banned now")
				ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.VERSION.."_U"..VERSION.."] DEBUG. Banned now\n")
			end
		end
	end
	
	
	local WaitBeforeBan = HAC.WaitCVar:GetInt()
	if wait then
		WaitBeforeBan = wait
	end
	if HAC.Debug then
		WaitBeforeBan = 3
	end
	
	
	timer.Simple(WaitBeforeBan, function() --Wait for a while, more logs coming in
		if not (ply:IsValid()) then return end
		
		if (ply.HACStealStarted and not ply.HACStealComplete) then --HKS stealer, wait for completion before ban
			return
		end
		
		if not HAC.Silent:GetBool() then
			if not (ply.DONEMSG) then
				ply.DONEMSG = true
				
				if ply:IsAdmin() or dontban then
					HACCAT(
						HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
						HAC.RED, "Autokicked ",
						team.GetColor(ply:Team()), ply.AntiHaxName,
						HAC.WHITE, " "..HAC.HaxMSG
					)
					MsgN("[HAC] Autokicked: ", ply.AntiHaxName, HAC.HaxMSG)
					
				else
					if SACH and SACH.ACH_ScannedAlone then
						SACH.ACH_ScannedAlone(ply) --Scanned Alone
					end
					
					if FSA and not ply:IsAdmin() and (ply:GetLevel() != RANK_CHEATER) then
						ply:SetLevel(RANK_CHEATER) --Set their rank to "Cheater"
					end
					
					HACCAT(
						HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
						HAC.RED, "Autobanned ",
						team.GetColor(ply:Team()), ply.AntiHaxName,
						HAC.WHITE, " "..HACBantime.." min ban. "..HAC.HaxMSG
					)
					
					MsgN("[HAC] Autobanned: ", ply.AntiHaxName," "..HACBantime.." min ban. "..HAC.HaxMSG)
				end
			end
			
			HAC.DoHax(ply) --HAAAAAAX!
		end
		
		timer.Simple(7.37, function()
			if not (ply:IsValid()) then return end
			
			if not (ply.DONEKICK) then
				ply.DONEKICK = true
				
				if not HAC.Silent:GetBool() then
					if not dontban and not ply:IsAdmin() and not ply:IsBot() then
						HAC.TotalBans = HAC.TotalBans + 1
						
						local Bans = HAC.GetAllBans()
						HACCAT(
							HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",		--[HAC] -=[UH]=- HeX just became the [402nd] banned player!
							team.GetColor(ply:Team()), ply.AntiHaxName,
							HAC.WHITE, " just became the ",
							HAC.PURPLE, "["..Bans..HAC.AddTH(Bans).."]",
							HAC.WHITE, " banned player!"
						)
						MsgN("[HAC] ", ply.AntiHaxName, " just became the ["..Bans..HAC.AddTH(Bans).."] banned player!")
					end
					
					if HAC.Debug then
						--ply.DONEKICK = false
						ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.VERSION.."_U"..VERSION.."] DEBUG. Kicked now")
						ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.VERSION.."_U"..VERSION.."] DEBUG. Kicked now\n")
						
					else
						HAC.PlayerDisconnected(ply)
						ply.HACDontLogDisconnect = true
						
						if ply:IsAdmin() or dontban then
							ply:HACDrop(HAC.KickMSG)
						else
							ply:HACDrop(HAC.BanMSG)
						end
					end
				end
			end
		end)
	end)
end


--- Check globals ---
function HAC.GCheck(ply,args)
	if ply:IsBot() then return end
	local str = tostring(args[1] or "fuck")
	
	if HAC.StringCheck(str,"GCheck") then
		if HAC.Debug then
			print("! got GCheck: ", ply)
		end
		if (str == "GCheck=_G.TEXT_ALIGN_CENTER=[[1]] (NUMBER)") then --Reloaded HAC on the client
			HAC.LogAndKickFailedInit(ply, "GCheck_Again", HAC.Msg.Other)
		end
		
		ply.GCheckInit = true
		
		if (str != "GCheck=_G.HACInstalled=[[1]] (NUMBER)") then
			HAC.DoBan(ply,"GCheck", args, false)
		end
		return true
	end
	return false
end



function HAC.CheckThatServerside(ply,args,Args1)
	if not ValidEntity(ply) then return end
	if ply:IsBot() then return end
	local Args2 = (args[2] or "1337")
	
	local count = tonumber(Args2)
	local sup	= tostring(count):upper()
	
	if HAC.StringCheck(Args1,"GCount") then
		if not ValidEntity(ply) then return end
		if HAC.Debug then
			print("! got GCount: ", count, ply)
		end
		
		ply.GCountInit = true
		
		if count != HAC.GCount then
			HAC.DoBan(ply,"GCount",{ "GCount_"..sup },false)
		end
		return true
		
		
	elseif HAC.StringCheck(Args1,"RCount") then
		if not ValidEntity(ply) then return end
		if HAC.Debug then
			print("! got RCount: ", count, ply)
		end
		
		ply.RCountInit = true
		
		if count != HAC.RCount then
			HAC.DoBan(ply,"RCount",{ "RCount_"..sup },false)
		end
		return true
		
		
	elseif HAC.StringCheck(Args1,"CGCount") then
		if not ValidEntity(ply) then return end
		if HAC.Debug then
			print("! got CGCount: ", Args2, ply)
		end
		
		ply.CGCountInit = true
		
		if Args2 != HAC.CGCount then
			HAC.DoBan(ply,"CGCount",{ "CGCount_"..sup },false)
		end
		return true
		
		
	elseif HAC.StringCheck(Args1,"PLCount") then
		if not ValidEntity(ply) then return end
		if HAC.Debug then
			print("! got PLCount: ", count, ply)
		end
		
		ply.PLCountInit = true
		
		if count != HAC.PLCount then
			HAC.DoBan(ply,"PLCount",{ "PLCount_"..sup },false)
		end
		return true
		
	elseif HAC.StringCheck(Args1,"SPath") then --DGI check
		if not ValidEntity(ply) then return end
		local path = tostring(args[2] or "Gone")
		local line = tonumber(args[3] or 0)
		
		if HAC.Debug then
			print("! got SPath: ", ply, Args1, path,line)
		end
		
		if (path != HAC.SCRIPTPATH) then
			HAC.LogAndKickFailedInit(ply, Format("SPATH=[%s:%s]", path,line), HAC.Msg.LenFail)
			return false
		end
		if (line != (HAC.LenCL - HAC.LenLCL) ) then
			HAC.LogAndKickFailedInit(ply, Format("LCLFailure=[%s:%s]", path,line), HAC.Msg.LenFail)
			return false
		end
		
		ply.SCRIPTPATHInit = true
		return true
		
	elseif (HAC.StringCheck(Args1,"SetViewAngles=") or HAC.StringCheck(Args1,"SetEyeAngles=")) then --SetEyeAngles
		if not ValidEntity(ply) then return end
		
		if ply:IsHeX() then return true end --No log for me!
		
		if not Args1:find("weapons/") then --Probably not aimbot
			HAC.DoBan(ply,cmd,args,true,nil,true) --Don't kick
		end
		
		if not table.HasValue(HAC.SERVER.White_EyeAngles, Args1) then --Not whitelisted
			file.Append(ply.HACLog.Eye, Format('\t"%s",\n', Args1) )
		end
		
		return true
		
	elseif (HAC.StringCheck(Args1,"PCC=") or HAC.StringCheck(Args1,"RCC=")) and ply:IsHeX() then --Also no log for me
		return true
		
	elseif Args1 == "TC=BandSox-_G.MATERIAL_TRIANGLE_STRIP [number:0]" then --Hiiden init check
		if HAC.Debug then
			print("! got TC Init: ", ply)
		end
		
		ply.HACTCInit = true
		return true
	end
	
	return false
end


--- Command gate ---
function HAC.KickMe(ply,cmd,args)
	local Args1 = args[1] or "fuck"
	
	if HAC.CheckThatServerside(ply,args,Args1) then --G, R and PL count
		return
		
	elseif HAC.AlsoInit(ply,cmd,args) then --Other init
		return
		
	elseif HAC.GCheck(ply,args) then --_G check
		return
		
	elseif table.HasValue(HAC.SERVER.White_FalsePositives,Args1) then --False pos
		return
		
	elseif HAC.IsFailedInit(ply,Args1) then --Init
		return
		
	elseif HAC.StringCheckInTable(Args1,HAC.SERVER.KickOnlyTable) then --Kick only
		HAC.DoBan(ply,cmd,args,true)
		return
		
	elseif HAC.StringCheckInTable(Args1, HAC.SERVER.LogOnlyTable) then --Log only
		HAC.DoBan(ply,cmd,args,true,nil,true)
		return
		
	else
		HAC.DoBan(ply,cmd,args,false) --BANBANBAN
	end
end
concommand.Add(HAC.AuxBanCommand,	HAC.KickMe)
concommand.Add(HAC.BanCommand,		HAC.KickMe)
concommand.Add(HAC.SEBanCommand,	HAC.KickMe)
concommand.Add(HAC.FakeBanCommand,	HAC.KickMe)
concommand.Add(HAC.HKSBanCommand2,	HAC.KickMe)



--- Manual ban ---
function HAC.ThePlayer(ply,cmd,args)
	if not ply:IsAdmin() then return end
	if (#args < 1) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] No args dumbass!\n")
		return
	end
	
	local him = Player( args[1] )
	
	if ValidEntity(him) then
		local HACManualMSG = "HAC"
		if (#args >= 2) then
			HACManualMSG = Format("%s=%s", ply:Nick(), args[2] )
		elseif (#args == 1) then
			HACManualMSG = ply:Nick()
		end
		
		him.HACIsInjected 		= false
		him.DONEBAN 			= false
		him.HACStealStarted 	= false
		him.HACStealComplete 	= true
		
		HAC.DoBan(him,cmd, {"ManualBan="..HACManualMSG}, false)
	end
end
concommand.Add("hac", HAC.ThePlayer)

function HAC.FakeDropHim(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	if (#args < 1) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] No args dumbass!\n")
		return
	end
	
	local him = Player( args[1] )
	if ValidEntity(him) then
		FakeDrop(him)
	end
end
concommand.Add("hac_drop", HAC.FakeDropHim)


function HAC.CrashHim(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	if (#args < 1) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] No args dumbass!\n")
		return
	end
	
	local him = Player( args[1] )
	him:HACEmptyTables()
	
	ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Emptied "..him:Nick().."'s tables -> Crashed!\n")
end
concommand.Add("hac_crash", HAC.CrashHim)


function HAC.CrashSH(ply,cmd,args)
	for k,v in pairs( player.GetAll() ) do
		if v.HACIsInjected then
			v:HACEmptyTables()
		end
	end	
	
	ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Emptied all SH user's tables -> Crashed!\n")
end
concommand.Add("hac_crash_sh", HAC.CrashSH)


function HAC.ResetTotalBans(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	HAC.TotalBans	= 0
	HAC.TotalHacks	= 0
	HAC.StreamHKS	= 0
end
concommand.Add("hac_clear", HAC.ResetTotalBans)
concommand.Add("hac_reset", HAC.ResetTotalBans)

function HAC.PrintTotalBans(ply,cmd,args)
	ply:PrintMessage(HUD_PRINTCONSOLE, Format("\nHAC.TotalBans: %s\nHAC.TotalHacks: %s\nHAC.StreamHKS: %s\n", HAC.TotalBans, HAC.TotalHacks, HAC.StreamHKS))
end
concommand.Add("hac_print", HAC.PrintTotalBans)

function HAC.ReloadLists()
	if not ply:IsSuperAdmin() then return end
	
	for k,v in ipairs( file.FindInLua("lists/*.lua") ) do
		include("lists/"..v)
	end
	
	print("[HAC] Reloaded lists!")
end
concommand.Add("hac_reloadlists", HAC.ReloadLists)

function HAC.DebugToggle(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	if (HAC.Debug) then
		HAC.Debug = !HAC.Debug
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] ---DEBUG MODE DISABLED---\n")
	else
		HAC.Debug = !HAC.Debug
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] +++DEBUG MODE ENABLED+++\n")
	end
end
concommand.Add("hac_debug", HAC.DebugToggle)


--- SendLua detour ---
local NotSL = _R.Player.SendLua
function _R.Player:SendLua(lua)
	if not lua then return end
	
	if HAC.SLDebug then
		print("! SendLua: ", self, lua)
	end
	
	if not ValidEntity(self) then return end
	return NotSL(self,lua)
end

function HAC.ToggleSLDebug(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	if HAC.SLDebug then
		HAC.SLDebug = false
		
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Disabled SendLua debug mode\n")
		return
	end
	
	HAC.SLDebug = true
	ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Enabled SendLua debug mode\n")
end
concommand.Add("hac_sldebug", HAC.ToggleSLDebug)


--- Whitelist SLOG commands ---
HAC.SLOG_WhiteListCommands(
	{
		HAC.BanCommand,
		HAC.AuxBanCommand,
		HAC.SEBanCommand,
		HAC.XDCommand,
	}
)

HACInstalled = (HACInstalled or 1) + 1

timer.Simple(1, function()
	hook.Call("HACPostLoad")
end)

MsgN("  Loaded ["..HAC.Modules.."] Plugins, ["..HAC.Lists.."] Lists!")
MsgN("///////////////////////////////////")
MsgN("//        [HAC"..HAC.VERSION.."]  loaded       //")
MsgN("///////////////////////////////////")
Msg("\n")









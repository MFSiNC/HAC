if !SERVER then return end
HAC = {}
HAC.Modules = {}
HAC.LoadTime = os.clock()
HAC.BanTime = 15
HAC.SETime = 70
HAC.xDTime = 80
HAC.WaitBeforeBan = CreateConVar("hac_wait", 20, true, false)

local LHAC = {}
LHAC.HSPColor = Color( 66, 255, 96 ) --HSP green
LHAC.TextColor = Color( 255, 255, 255 ) --white
LHAC.HSPRed = Color( 255, 0, 11 ) --red
LHAC.ShortMSG = "LHAC.ShortMSG Error"
LHAC.HaxMSG = "Attempted Hack/Exploit/Blocked command."
LHAC.BanMSG = "[HAC] Autobanned: "..HAC.BanTime.."min ban. "..LHAC.HaxMSG
LHAC.KickMSG = "[HAC] Autokicked: "..LHAC.HaxMSG

HAC.Debug = false --false
HAC.Version = 63

Msg( "\n///////////////////////////////////\n" )
Msg( "//    HeX's Anti-Cheat Loader    //\n" )
Msg( "///////////////////////////////////\n" )

Msg( "  Including clientside\n" )
AddCSLuaFile("includes/enum/!!!!!!!!!!.lua")

Msg( "  Precaching sounds\n" )
util.PrecacheSound("vo/npc/male01/hacks01.wav")
util.PrecacheSound("siege/big_explosion.wav")
resource.AddFile("sound/siege/big_explosion.wav")

Msg( "  Loading Gatekeeper\n" )
if file.FindInLua("includes/modules/gmsv_gatekeeper.dll") then
	require("gatekeeper")
	Msg("   OK! gmsv_gatekeeper loaded\n")
else
	Msg("   DAMN! gmsv_gatekeeper gone!\n")
	Msg("   Using ply:Kick() meta\n")
end

Msg( "  Including modules\n" )
local HACModulesCL = file.FindInLua("HAC/cl_*.lua")
if #HACModulesCL > 0 then
	for _, Module in ipairs(HACModulesCL) do
		Msg("   Module: "..Module.."\n")
		AddCSLuaFile("HAC/"..Module)		
		table.insert(HAC.Modules,Module)
	end
end

local HACModulesSH = file.FindInLua("HAC/sh_*.lua")
if #HACModulesSH > 0 then
	for _, Module in ipairs(HACModulesSH) do
		Msg("   Module: "..Module.."\n")
		AddCSLuaFile("HAC/"..Module)
		include("HAC/"..Module)
		table.insert(HAC.Modules,Module)
	end
end

local HACModulesSV = file.FindInLua("HAC/sv_*.lua")
if #HACModulesSV > 0 then
	for _, Module in ipairs(HACModulesSV) do
		Msg("   Module: "..Module.."\n")
		include("HAC/"..Module)		
		table.insert(HAC.Modules,Module)
	end
end

function HAC.Module(mod)
	return table.HasValue(HAC.Modules,mod)
end

function HAC.PlayerInitialSpawn(ply)
	if ply and ply:IsValid() then
		ply.DONEHAX = false
		ply.DONEMSG = false
		ply.DONEBAN = false
		ply.DONEKICK = false
		ply.TotalHacks = 0
		
		if HAC.Module("sv_xDetector.lua") then --check detours
			if HAC.Debug then
				HAC.xDTime = 3
			end
			
			timer.Simple(HAC.xDTime, function()
				HAC.SendXDetector(ply)
			end)
		end
		
		if HAC.Module("sv_SelfExists.lua") then --check if self exists
			if HAC.Debug then
				HAC.SETime = 4
			end
			
			timer.Simple(HAC.SETime, function()
				HAC.CheckSelfExists(ply)
			end)
		end
	end
end
hook.Add( "PlayerInitialSpawn", "HAC.PlayerInitialSpawn", HAC.PlayerInitialSpawn )


function HAC.PlayerDisconnected(ply)
	if ply and ply:IsValid() and ply:IsPlayer() then
		ply.DONEHAX		= false
		ply.DONEMSG		= false
		ply.DONEKICK	= false
		ply.HACd		= false
		ply.TotalHacks	= nil
	end
end
hook.Add( "PlayerDisconnected", "HAC.PlayerDisconnected", HAC.PlayerDisconnected )

hook.Add("PlayerAuthed", "HAC.RefreshTheBans", function()
	if ULib then
		ULib.refreshBans()
	else
		hook.Remove("PlayerAuthed", "HAC.RefreshTheBans")
	end
end)

function HAC.WriteLog(ply,crime,punishment,logtype)
	local WriteLog1 = "WriteLog1 Error"
	local ShortMSG = "ShortMSG Error"
	local WLLogname = "hac_log.txt"

	local WLCrime = crime or "WLCrime Error"
	local WLPunishment = punishment or "WLPunishment Error"
	
	if logtype then
		if logtype == 1 then
			WLLogname = "hac_log.txt"
		else
			WLLogname = "hac_misc_log.txt"
		end
	end
	
	if (ply.RealName and ply.RealName != "None") then
		WriteLog1 = "[HAC"..HAC.Version.."] ["..os.date("%d-%m-%y %I:%M:%S%p").."] - "..WLPunishment..": "..ply.AntiHaxName.." ["..ply.RealName.."] ("..ply:SteamID()..") - "..WLCrime.."\n"
	else
		WriteLog1 = "[HAC"..HAC.Version.."] ["..os.date("%d-%m-%y %I:%M:%S%p").."] - "..WLPunishment..": "..ply.AntiHaxName.." ("..ply:SteamID()..") - "..WLCrime.."\n"
	end
	
	ShortMSG = ply.AntiHaxName.." -> "..WLCrime
	
	if not file.Exists(WLLogname) then
		file.Write(WLLogname, "HeX's Anti-Cheat ["..HAC.Version.."] log created at ["..os.date("%d-%m-%y %I:%M:%S%p").."] \n\n")
	end
	filex.Append(WLLogname, WriteLog1)

	HAC.HACPrint2Admins(WriteLog1)
	HAC.TellAdmins(ShortMSG)
end

function HAC.TellAdmins(ShortMSG) --FIXME, why 2 functions?
	for k,v in ipairs(player.GetAll()) do
		if v and v:IsValid() and v:IsAdmin() and ShortMSG then
			HACGANPLY(v, ShortMSG, 4, 10, "npc/roller/mine/rmine_tossed1.wav")
		end
	end
end
function HAC.HACPrint2Admins(str)
	Msg(str) --for SRCDS
	for k,v in pairs(player.GetAll()) do 
		if v and v:IsValid() and v:IsAdmin() and str then
			v:PrintMessage(HUD_PRINTCONSOLE, str)
		end
	end
end

function HAC.DoHax(ply)
	if ply and ply:IsValid() then
		if (ply.DONEHAX) then return end
		ply.DONEHAX = true
		if not ply:Alive() then
			ply:Spawn()
		end
		ply:EmitSound("vo/npc/male01/hacks01.wav")
		timer.Simple(2.3, function( ) 
		if not ply and not ply:IsValid() then
			return
		end
			ply:SetHealth(300)
			ply:SetFrags(-450)
			ply:StripWeapons()
			ply:Give("weapon_bugbait")
			ply:GodDisable()
			ply:Ignite(20, 60)
			local trail = util.SpriteTrail(ply, 0, Color(255,255,255), false, 50, 10, 5, 1/(15+1)*0.5, "trails/smoke.vmt")
			HAC.BigBoom(ply,"4")
			if (ply:GetMoveType()==MOVETYPE_NOCLIP or ply:GetMoveType()==MOVETYPE_FLY) then
				ply:SetMoveType(MOVETYPE_WALK)
			end
			HAC.Explode(ply)
			HAC.Explode(ply)
			ply:SetVelocity(Vector(0, 0, 999))
			timer.Simple(1.8, function( ) 
				HAC.EffectBoom(ply)
				for i=1,35 do
					local vec = Vector(math.random()*2-1, math.random()*2-1, math.random()*2-1):GetNormal()
					
					local Monitor = ents.Create("hax_monitor")
					Monitor:SetModel("models/props_lab/monitor02.mdl")
					Monitor:SetPos(ply:GetPos() + vec * 15 + Vector(0,0,36))
					Monitor:SetAngles(vec:Angle())
					
					Monitor:SetPhysicsAttacker(ply)
					Monitor:SetOwner(ply)
					Monitor.Owner = ply
					
					Monitor:PhysicsInit( SOLID_VPHYSICS )
					Monitor:SetMoveType( MOVETYPE_VPHYSICS )
					Monitor:SetSolid( SOLID_VPHYSICS )
					Monitor:Spawn()
					Monitor:Activate()
					local haxtrail = util.SpriteTrail(Monitor, 0, Color(255,255,255), false, 32, 0, 2.5, 1/(15+1)*0.5, "trails/physbeam.vmt")
					Monitor:SetVelocity(vec * 150)
				end
				ply:Kill()
				trail:Remove()
			end)
		end)
	end
end

function HAC.EffectBoom(ply)
	if ply and ply:IsValid() then 
		ply:EmitSound("siege/big_explosion.wav")
		
		--util.BlastDamage(ply, ply, ply:GetPos(), 150, 250) --removed cause of NULL player if he disconnectes
		for i=1,5 do --5 explosions
			HAC.BigBoom(ply,"150")
		end
		
		local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
		util.Effect("extrap_breach", effectdata, true, true)
	end
end
function HAC.BigBoom(ply,pwr)
	local boom00 = ents.Create("env_explosion")
		boom00:SetOwner(ply)
		boom00:SetPos(ply:GetPos())
		boom00:Spawn()
		boom00:SetKeyValue( "iMagnitude", pwr )
	boom00:Fire("Explode", 0, 0)
end
function HAC.Explode(ply)
	HAC.BigBoom(ply,"4")
	
	timer.Simple(0.3, function()
		HAC.BigBoom(ply,"4")
	end)
	timer.Simple(0.5, function()
		HAC.BigBoom(ply,"4")
	end)
	timer.Simple(0.8, function()
		HAC.BigBoom(ply,"4")
	end)
end

function HAC.DoBan(ply,cmd,args,dontban,bantime)
	if not (ply and ply:IsValid() and ply:IsPlayer()) then return end
	local HACBantime = bantime or HAC.BanTime
	
	if HAC.IsFalsePositive(args[1]) then
		HAC.LogFalsePositive(ply,cmd,args)
		return
	end
	
	LHAC.ShortMSG = "Autobanned"
	if dontban then
		LHAC.ShortMSG = "Autokicked"
	end
	
	if not ply:IsBot() then
		HAC.WriteLog(ply,args[1],LHAC.ShortMSG,1)
	end
	
	
	if not ply.DONEBAN and not dontban then --ban their ass
		ply.DONEBAN = true
		if not HAC.Debug then
			if not ply:IsAdmin() and not ply:IsBot() then
				if ULib then
					ULib.ban(ply, HACBantime, "HAC_AutoBan", nil)
					ULib.refreshBans()
				else
					ply:Ban(HACBantime, LHAC.BanMSG)
				end
			end
		else
			ply.DONEBAN = false
			ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.Version.."] DEBUG. Banned now")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.Version.."] DEBUG. Banned now")
		end
	end
	
	timer.Simple(HAC.WaitBeforeBan:GetInt(), function()
		if not (ply and ply:IsValid() and ply:IsPlayer()) then return end
		
		if not (ply.DONEMSG) then
			ply.DONEMSG = true
			if dontban then
				HACCAT( LHAC.HSPColor, "[HAC] ", LHAC.HSPRed, "Autokicked: ", team.GetColor( ply:Team() ), ply.AntiHaxName, LHAC.TextColor, ". "..LHAC.HaxMSG )
				MsgN("[HAC] Autokicked: ", ply.AntiHaxName, LHAC.HaxMSG)
			else
				HACCAT( LHAC.HSPColor, "[HAC] ", LHAC.HSPRed, "Autobanned: ", team.GetColor( ply:Team() ), ply.AntiHaxName, LHAC.TextColor, " "..HACBantime.." minute ban. "..LHAC.HaxMSG )
				MsgN("[HAC] Autobanned: ", ply.AntiHaxName," "..HACBantime.." minute ban. "..LHAC.HaxMSG)
			end
		end
		
		HAC.DoHax(ply) --HAAAAAAX!
		
		timer.Simple( 4.5, function()
			if not (ply and ply:IsValid() and ply:IsPlayer()) then return end
			ply.DONEHAX = false
			ply.DONEMSG = false
			
			if not (ply.DONEKICK) then
				ply.DONEKICK = true
				if !HAC.Debug then
					if ply:IsSuperAdmin() or dontban then
						if gatekeeper then
							gatekeeper.Drop(ply:UserID(), LHAC.KickMSG)
						else
							ply:Kick(LHAC.KickMSG)
						end
					else
						if gatekeeper then
							gatekeeper.Drop(ply:UserID(), LHAC.BanMSG)
						else
							ply:Kick(LHAC.BanMSG)
						end
					end
				else
					ply.DONEKICK	= false
					ply.HACd		= false
					ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.Version.."] DEBUG. Kicked now")
					ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.Version.."] DEBUG. Kicked now")
				end
			end
		end)
	end)
end


function HAC.KickMe(ply,cmd,args)	
	HAC.DoBan(ply,cmd,args,false,nil)
end
concommand.Add("gm_giveranks", HAC.KickMe)


function LHAC.ThePlayer(ply,cmd,args)
	if ply:IsAdmin() then
		if ULib then
			if #args < 1 then
				ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] No args!")
				return
			end
			
			local HACManualMSG = args[2] or "HAC" --if #args >= 2 then 
			
			local targets, err = ULib.getUsers( args[1], true, true, ply ) -- Enable keywords
			if not targets then
				ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] LHAC.ThePlayer Error: ".. err)
				return
			end
			
			for _, v in ipairs( targets ) do
				if v.HACd then
					ply:PrintMessage(HUD_PRINTCONSOLE, "Already running on this player!")
				else
					v.HACd = true
					if not v:IsBot() then
						HAC.WriteLog(v, HACManualMSG,"ManuallyBanned",1)
					end
					HAC.DoBan(v,cmd,{ "ManualAdd="..HACManualMSG, "User" },false,nil)
				end
			end
		else
			ply:PrintMessage(HUD_PRINTCONSOLE, "ULib is not installed, this command is useless.")
		end
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] You are not an admin, and so can't use this command.")
	end
end
concommand.Add("hac", LHAC.ThePlayer)


function LHAC.RefreshAll(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	if cmd == "hac_reload_sv" then
		HAC.HACPrint2Admins("[HAC] Reloading serverside..\n")
		concommand.Remove("gm_giveranks")
		concommand.Remove("hac")
		concommand.Remove("hac_reload_cl")
		concommand.Remove("hac_reload_sv")
		hook.Remove("PlayerInitialSpawn", "HAC.PlayerInitialSpawn")
		hook.Remove("PlayerDisconnected", "HAC.PlayerDisconnected")
		hook.Remove("PlayerAuthed", "HAC.RefreshTheBans")
		timer.Simple(1,function()
			HAC = {}
			LHAC = {}
			include("autorun/server/hac_sv.lua")
		end)
		return
	end
	
	for k,v in pairs(player.GetAll()) do 
		if v and v:IsValid() and not v:IsBot() then
			if cmd == "hac_reload_cl" then
				v:ConCommand("gm_refreshranks")
				
				if HAC.Module("sh_RealName.lua") then
					v:ConCommand("ulx_playerspawn")
				end
				if HAC.Module("sv_xDetector.lua") then
					HAC.SendXDetector(v)
				end
				if HAC.Module("sv_SelfExists.lua") then
					HAC.CheckSelfExists(v)
				end
			end
		end
	end
end
concommand.Add("hac_reload_cl", LHAC.RefreshAll)
concommand.Add("hac_reload_sv", LHAC.RefreshAll)


function LHAC.DebugToggle(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	if (HAC.Debug) then
		HAC.Debug = !HAC.Debug
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] ---DEBUG MODE DISABLED---\n")
	else
		HAC.Debug = !HAC.Debug
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] +++DEBUG MODE ENABLED+++\n")
	end
end
concommand.Add("hac_debug", LHAC.DebugToggle)



HAC.LoadTime = math.Round(HAC.LoadTime - os.clock())
MsgN("  Loaded ["..#HAC.Modules.."] modules!")
MsgN("///////////////////////////////////")
MsgN("//    All done in ["..HAC.LoadTime.."] seconds    //")
MsgN( "//        [HAC"..HAC.Version.."]  loaded        //")
MsgN("///////////////////////////////////")










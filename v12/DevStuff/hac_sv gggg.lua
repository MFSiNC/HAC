if !SERVER then return end
HAC = {}
HAC.Modules = {}
local HSPColor = Color( 66, 255, 96 ) --HSP green
local TextColor = Color( 255, 255, 255 ) --white
local HSPRed = Color( 255, 0, 11 ) --red
local HACENABLED = CreateConVar("hac_enabled", "1", true, true)
local HACAntiNameHackEnabled = CreateConVar("hac_namehack", "1", true, true)
local HACNameHaxScan = CreateConVar("hac_namescantime", "5", true, true)
local HACDetourTime = 3 --50
local BANTIME = 30
local HACShortMsg = "HACShortMsg Error"
local HAXMSG = "Attempted Hack/Exploit/Blocked command."
local BANMSG = "[HAC] Autobanned: "..BANTIME.."min ban. "..HAXMSG
local KICKMSG = "[HAC] Autokicked: "..HAXMSG

local HACDEBUG = true
HACVER = 53
LOLKEY = "LimitedBottledUniverse"


Msg( "\n///////////////////////////////////\n" )
Msg( "//    HeX's Anti-Cheat Loader    //\n" )
Msg( "///////////////////////////////////\n" )

Msg( "  Including clientside\n" )
AddCSLuaFile("includes/enum/0.lua")

local HACModulesCL = file.FindInLua("HAC/cl_*.lua")
if #HACModulesCL > 0 then
	for _, Module in ipairs(HACModulesCL) do
		Msg("  Module: "..Module.."\n")
		table.insert(HAC.Modules,Module)
	end
end


Msg( "  Precaching sounds\n" )
util.PrecacheSound("vo/npc/male01/hacks01.wav")
util.PrecacheSound("siege/big_explosion.wav")
resource.AddFile("sound/siege/big_explosion.wav")

Msg( "  Including serverside\n" )
local HACModulesSV = file.FindInLua("HAC/sv_*.lua")
if #HACModulesSV > 0 then
	for _, Module in ipairs(HACModulesSV) do
		Msg("  Module: "..Module.."\n")
		table.insert(HAC.Modules,Module)
		include("HAC/"..Module)
	end
end


local function HACPlayerJoin(ply)
	if ply and ply:IsValid() then
		ply.AntiHaxName = ply:Nick()
		ply.DONEHAX = false
		ply.DONEMSG = false
		
		if HACDEBUG then
			HACDetourTime = 3
		end
		
		if table.HasValue(HAC.Modules,"sv_xDetector.lua") then
			timer.Simple(HACDetourTime, function()
				HACSendDetourFunction(ply)
			end)
		end
	end
end
hook.Add( "PlayerInitialSpawn", "HACPlayerJoin", HACPlayerJoin )

timer.Create( "AntiNameHax", HACNameHaxScan:GetInt(), 0, function()
	if HACAntiNameHackEnabled:GetBool() then
		for k,v in pairs(player.GetAll()) do
			if v and v:IsValid() and v:IsPlayer() and (v.AntiHaxName != nil) then
				if (v.AntiHaxName != v:Nick()) then
					KickMe(v,nil, { "Namehack: "..v:Nick(), LOLKEY, "User" } ,false,5)
				end
			end
		end
	end
end)

local function HACPlayerLeave(ply)
	if ply and ply:IsValid() and ply:IsPlayer() then
		ply.AntiHaxName = nil
		ply.DONEHAX = false
		ply.DONEMSG = false
	end
end
hook.Add( "PlayerDisconnected", "HACPlayerLeave", HACPlayerLeave )

hook.Add("PlayerAuthed", "RefreshTheBans", function()
	if ULib then
		ULib.refreshBans()
	else
		hook.Remove("PlayerAuthed", "RefreshTheBans")
	end
end)


function HACCheckOldKeys(ply,cmd,args)
	if (#args >= 2) and args[2] != LOLKEY then
		local WLLogname = "hac_keylog.txt"

		local WriteLog1 = "[HAC"..HACVER.."] ["..os.date().."] - "..ply.AntiHaxName.." ("..ply:SteamID()..") - "..ply:IPAddress().." - Old Key = "..args[2].."\n"
		
		if not file.Exists(WLLogname) then
			file.Write(WLLogname, "FFFFUUUUUUUUUUUUU-\n\n")
		end
		filex.Append(WLLogname, WriteLog1)
	end
end


function WriteLog(ply,crime,punishment,logtype)
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
		WriteLog1 = "[HAC"..HACVER.."] ["..os.date().."] - "..WLPunishment..": "..ply.AntiHaxName.." ["..ply.RealName.."] ("..ply:SteamID()..") - "..ply:IPAddress().." - "..WLCrime.."\n"
	else
		WriteLog1 = "[HAC"..HACVER.."] ["..os.date().."] - "..WLPunishment..": "..ply.AntiHaxName.." ("..ply:SteamID()..") - "..ply:IPAddress().." - "..WLCrime.."\n"
	end
	
	ShortMSG = ply.AntiHaxName.." -> "..WLCrime
	
	if not file.Exists(WLLogname) then
		file.Write(WLLogname, "[HAC"..HACVER.."] HeX's Anti-Cheat log created at ["..os.date().."] \n\n")
	end
	filex.Append(WLLogname, WriteLog1)
	print("\n"..WriteLog1.."\n")
	TellAdmins(ShortMSG,WriteLog1)
end

function TellAdmins(ShortMSG,LongMSG)
	for k,v in ipairs(player.GetAll()) do
		if v and v:IsValid() and v:IsAdmin() and ShortMSG and LongMSG then
			v:PrintMessage(HUD_PRINTCONSOLE, "\n"..LongMSG.."\n")
			GANPLY(v, ShortMSG, 4, 8, "npc/roller/mine/rmine_tossed1.wav")
		end
	end
end
function HACPrint2Admins(str)
	print(str) --for SRCDS
	for k,v in pairs(player.GetAll()) do 
		if v and v:IsValid() and v:IsAdmin() and str then
			v:PrintMessage(HUD_PRINTCONSOLE, str.."\n")
		end
	end
end

function DoHax(ply)
	if ply and ply:IsValid() then
		if (ply.DONEHAX) then return end
		ply.DONEHAX = true
		if not ply:Alive() then
			ply:ConCommand("+jump")
			timer.Simple(0.1, function()
				ply:ConCommand("-jump")
			end)
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
			BigBoom(ply,"4")
			if (ply:GetMoveType()==MOVETYPE_NOCLIP or ply:GetMoveType()==MOVETYPE_FLY) then
				ply:SetMoveType(MOVETYPE_WALK)
			end
			HACExploded(ply)
			HACExploded(ply)
			ply:SetVelocity(Vector(0, 0, 999))
			timer.Simple(1.8, function( ) 
				EffectBoom(ply)
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

function EffectBoom(ply)
	if ply and ply:IsValid() then 
		ply:EmitSound("siege/big_explosion.wav")
		
		--util.BlastDamage(ply, ply, ply:GetPos(), 150, 250) --removed cause of NULL player if he disconnectes
		for i=1,5 do --5 explosions
			BigBoom(ply,"150")
		end
		
		local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
		util.Effect("extrap_breach", effectdata, true, true)
	end
end

function BigBoom(ply,pwr)
	local boom00 = ents.Create("env_explosion")
		boom00:SetOwner(ply)
		boom00:SetPos(ply:GetPos())
		boom00:Spawn()
		boom00:SetKeyValue( "iMagnitude", pwr )
	boom00:Fire("Explode", 0, 0)
end

function HACExploded(ply)
	BigBoom(ply,"4")
	
	timer.Simple(0.3, function()
		BigBoom(ply,"4")
	end)
	timer.Simple(0.5, function()
		BigBoom(ply,"4")
	end)
	timer.Simple(0.8, function()
		BigBoom(ply,"4")
	end)
end


function KickMe(ply,cmd,args,dontban,bantime)	
	if ply and ply:IsValid() and ply:IsPlayer() then
		HACCheckOldKeys(ply,cmd,args) --eh, why not
		if (#args >= 3) and args[2] == LOLKEY and args[3] == "User" then --hack detected
			if HACENABLED:GetBool() then
				local HACBantime = bantime or BANTIME
				
				if !HACDEBUG then --ban their ass
					if ULib then
						if not ply:IsSuperAdmin() and not ply:IsBot() and not dontban then
							ULib.ban(ply, HACBantime, "HAC_AutoBan", nil)
							ULib.refreshBans()
						end
					else
						if not ply:IsSuperAdmin() and not ply:IsBot() and not dontban then
							ply:Ban(HACBantime, BANMSG)
						end
					end
				else
					ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HACVER.."] DEBUG. Banned now")
					ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HACVER.."] DEBUG. Banned now")
				end
				
				
				if dontban then
					HACShortMsg = "Autokicked"
				else
					HACShortMsg = "Autobanned"
				end
				if not ply:IsBot() then
					WriteLog(ply,args[1],HACShortMsg,1)
				end
				
				DoHax(ply) --HAAAAAAX!
				
				if not (ply.DONEMSG) then
					ply.DONEMSG = true
					if dontban then
						CAT( HSPColor, "[HAC] ", HSPRed, "Autokicked: ", team.GetColor( ply:Team() ), ply.AntiHaxName, TextColor, ". "..HAXMSG )
					else
						CAT( HSPColor, "[HAC] ", HSPRed, "Autobanned: ", team.GetColor( ply:Team() ), ply.AntiHaxName, TextColor, " "..HACBantime.." minute ban. "..HAXMSG )
					end
				end
				
				timer.Simple( 4.5, function( )
					if ply and ply:IsValid() and ply:IsPlayer() then
						ply.DONEHAX = false
						ply.DONEMSG = false
						
						if !HACDEBUG then
							if ULib then
								ULib.kick(ply, KICKMSG)
							else
								ply:Kick(KICKMSG)
							end
						else
							ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HACVER.."] DEBUG. Kicked now")
							ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HACVER.."] DEBUG. Kicked now")
						end
					end
				end)
			else
				HACPrint2Admins("[HAC"..HACVER.."] HAC DISABLED")
			end
		elseif (#args >= 3) and args[2] == LOLKEY and args[3] == "HACReport" then --script reload report
			if (ply.RealName and ply.RealName != "None") then
				HACPingLog("[HAC"..HACVER.."] ["..os.date().."] - Recieved - "..ply.AntiHaxName.." ["..ply.RealName.."] ("..ply:SteamID()..") - "..ply:IPAddress().."\n")
				HACPrint2Admins("[HAC] - Recieved - "..ply.AntiHaxName.." ["..ply.RealName.."]")
			else
				HACPingLog("[HAC"..HACVER.."] ["..os.date().."] - Recieved - "..ply.AntiHaxName.." ("..ply:SteamID()..") - "..ply:IPAddress().."\n")
				HACPrint2Admins("[HAC] - Recieved - "..ply.AntiHaxName)
			end
		end
	end
end
concommand.Add("gm_giveranks", KickMe)

local function HACThePlayer(ply,cmd,args)
	if ply:IsAdmin() then
		if ULib then
			local KickMeTable2 = {}
			local HACManualMSG = args[2] or "HAC" --if #args >= 2 then 
			
			if #args < 1 then
				ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] No args!")
				return
			end
			
			local targets, err = ULib.getUsers( args[1], true, true, ply ) -- Enable keywords
			if not targets then
				ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Error: ".. err)
				return
			end
			
			for _, v in ipairs( targets ) do
				KickMeTable2 = { "ManualAdd="..HACManualMSG, LOLKEY, "User" }
				KickMe(v,cmd,KickMeTable2,false,30)
			end
		else
			ply:PrintMessage(HUD_PRINTCONSOLE, "ULib is not installed, this command is useless.")
		end
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] You are not an admin, and so can't use this command.")
	end
end
concommand.Add("hac", HACThePlayer)


local function HACRefreshAndPing(ply,cmd,args)
	if not ply:IsAdmin() then return end
	for k,v in pairs(player.GetAll()) do 
		if v and v:IsValid() and not v:IsBot() then
			
			if cmd == "hac_refresh" then
				v:ConCommand("gm_refreshranks")
			elseif cmd == "hac_ping" then
				v:ConCommand("gm_refreshranks Ping")
			end
			
			HACPingLog("[HAC"..HACVER.."] ["..os.date().."] - Sent - "..v.AntiHaxName.." ("..v:SteamID()..") - "..v:IPAddress().."\n")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] - Sent - "..v.AntiHaxName.."\n")
		end
	end
end
concommand.Add("hac_refresh", HACRefreshAndPing)
concommand.Add("hac_ping", HACRefreshAndPing)

function HACPingLog(logstr)
	local WriteLog1 = logstr or "WriteLog1 Error"

	if not file.Exists("hac_ping_log.txt") then
		file.Write("hac_ping_log.txt", "[HAC"..HACVER.."] Ping log created at ["..os.date().."] \n\n")
	end
	filex.Append("hac_ping_log.txt", WriteLog1)
end

Msg( "///////////////////////////////////\n" )
Msg( "//        [HAC"..HACVER.."] loaded!        //\n" )
Msg( "///////////////////////////////////\n\n" )










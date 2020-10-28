if !SERVER then return end

HAC				= {}
HAC.Modules		= {}
HAC.LoadTime	= os.clock()
HAC.BanTime		= 15
HAC.SETime		= 75
HAC.xDTime		= 80

HAC.Debug		= false --false
HAC.Version		= 65
HAC.BanCommand	= "gm_giveranks"
HAC.AuxBanCommand	= "banme"

HAC.WaitBeforeBanCVar = CreateConVar("hac_wait", 45, true, false)
HAC.UseRandom = CreateConVar("hac_userandom", 1, true, false)

local LHAC		= {}
LHAC.HSPColor	= Color( 66, 255, 96 ) --HSP green
LHAC.TextColor	= Color( 255, 255, 255 ) --white
LHAC.HSPRed		= Color( 255, 0, 11 ) --red
LHAC.ShortMSG	= "LHAC.ShortMSG Error"
LHAC.HaxMSG		= "Attempted Hack/Exploit/Blocked command. If this ban is in error, tell HeX (/id/MFSiNC)"
LHAC.BanMSG		= "[HAC] Autobanned: "..HAC.BanTime.."min ban. "..LHAC.HaxMSG
LHAC.KickMSG	= "[HAC] Autokicked: "..LHAC.HaxMSG

Msg( "  Precaching sounds\n" )
util.PrecacheSound(Sound("vo/npc/male01/hacks01.wav"))
util.PrecacheSound(Sound("vo/npc/male01/no01.wav"))
util.PrecacheSound(Sound("vo/npc/male01/no02.wav"))
util.PrecacheSound(Sound("siege/big_explosion.wav"))
resource.AddFile("sound/siege/big_explosion.wav")



function HAC.PlayerInitialSpawn(ply)
	ply.DONEHAX		= false
	ply.DONEMSG		= false
	ply.DONEBAN		= false
	ply.DONEKICK	= false
	ply.HACAborted	= false
	ply.HACInit 	= false
end
hook.Add( "PlayerInitialSpawn", "HAC.PlayerInitialSpawn", HAC.PlayerInitialSpawn)



function HAC.DoHax(ply)
	if not (ply and ply:IsValid()) then return end
	if (ply.DONEHAX) then return end
	ply.DONEHAX = true
	
	if not ply:Alive() then
		ply:Spawn()
	end
	
	ply:EmitSound("vo/npc/male01/no01.wav")
    timer.Simple(2, function() if (ply and ply:IsValid()) then ply:EmitSound("vo/npc/male01/hacks01.wav") end end)
    timer.Simple(3.4, function() if (ply and ply:IsValid()) then ply:EmitSound("vo/npc/male01/no02.wav") end end)
	
	timer.Simple(5.37, function() 
		if not ply and not ply:IsValid() then return end
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
			for i=1,42 do
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
				Monitor:Ignite(40,150)
				Monitor:SetVelocity(vec * 150)
			end
			ply:Kill()
			trail:Remove()
		end)
	end)
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
		boom00:SetKeyValue( "iMagnitude", tostring(pwr) )
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

	timer.Simple(1, function()
	
		HAC.DoHax(ply) --HAAAAAAX!
		
		timer.Simple(7.37, function()
			ply.DONEHAX = false
			ply.DONEMSG = false
			
			if not (ply.DONEKICK) then
				ply.DONEKICK = true
				ply.DONEKICK	= false
				ply.HACd		= false
				ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.Version.."] DEBUG. Kicked now")
				ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.Version.."] DEBUG. Kicked now\n")
			end
		end)
	end)
end

function HAC.KickMe(ply,cmd,args)
	HAC.DoBan(ply,cmd,args,false,nil)
end
concommand.Add("banme", HAC.KickMe)









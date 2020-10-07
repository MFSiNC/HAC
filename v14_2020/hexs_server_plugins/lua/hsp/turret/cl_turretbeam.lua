
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_TurretBeam, v1.0

	Turrets with lasers, portal-style

]]



local FLOOR_TURRET_RANGE	= 1200

local TURRET_IDLE			= 0 --Idle

local TURRET_OPEN 			= 1 --Found target

local TURRET_OPEN_IDLE		= 2 --Scanning

local TURRET_FIRE			= 3 --Shooting

local TURRET_CLOSE			= 4 --Offline



local AlarmColor = {

	[TURRET_IDLE] 		= color_white,

	[TURRET_OPEN] 		= HSP.BLUE2,

	[TURRET_OPEN_IDLE]	= HSP.ORANGE,

	[TURRET_FIRE]		= HSP.RED2,

	[TURRET_CLOSE]		= HSP.GREEN2,

}





local matBeam = Material("sprites/tp_beam001")

local matGlow = Material("sprites/glow04_noz")



local Data = {

	mask = MASK_SHOT,

}

local function DrawTurretBeams()

	for k,v in epairs("npc_turret_floor") do

		if v.HSP_TurretIsDead then continue end

		

		local Laser	= v:GetAttachment( v:LookupAttachment("light") )

		local Pos	= Laser.Pos

		local Seq 	= v:GetSequence()

		

		Data.start 	= Pos

			Data.endpos = Pos + Laser.Ang:Forward() * FLOOR_TURRET_RANGE

			Data.filter = v

		local Trace = util.TraceLine(Data)

		

		local oCol = HSP.RED2

		if CPPI then

			local Owner = v:CPPIGetOwner()

			if IsValid(Owner) then

				oCol = Owner:TeamColor()

			end

		end

		

		//Light

		render.SetMaterial(matGlow)

		render.DrawSprite(Pos, 4, 4, color_white)

		render.DrawSprite(Pos, 16, 16, AlarmColor[Seq] )

		

		if Seq > 0 then --Active

			//Beam

			render.SetMaterial(matBeam)

			render.DrawBeam(Pos, Trace.HitPos, 1, 0, 1, color_white)

			render.DrawBeam(Pos, Trace.HitPos, 4, 0, 1, oCol)

			

			//Hitpos

			render.DrawSprite(Trace.HitPos, 2, 2, color_white)

			render.DrawSprite(Trace.HitPos, 8, 8, oCol)

		end

	end

end

hook.Add("PostDrawTranslucentRenderables", "DrawTurretBeams", DrawTurretBeams)



local function TurretDeath(um)

	local npc = um:ReadEntity()

	

	npc.HSP_TurretIsDead = true

end

usermessage.Hook("TurretDeath", TurretDeath)























----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_TurretDeath, v2.1

	Kill turrets when they fall over!

]]



if CLIENT then --No need on server

	game.AddParticles("particles/weapon_fx.pcf")

end



PrecacheParticleSystem("explosion_turret_fizzle")

PrecacheParticleSystem("explosion_turret_break")





if SERVER then

	function HSP.FireTurret(npc)

		if not npc.HSP_ASK_Doing and npc:GetClass():find("turret") then

			npc.HSP_ASK_Doing = true

			

			npc:Fire("SelfDestruct")

			

			umsg.Start("TurretDeath")

				umsg.Entity(npc)

			umsg.End()

		end

	end

	hook.Add("OnNPCKilled", "HSP.FireTurret", HSP.FireTurret)

end













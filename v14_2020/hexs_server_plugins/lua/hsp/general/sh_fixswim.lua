
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP plugin module ===

	sh_FixSwim, v1.1

	Fix the "swimming in air" bug!

]]





function HSP.FixSwim(ply,vel)

	if (ply:WaterLevel() == 0) then

		ply.m_bInSwim = false

    end

end

hook.Add("HandlePlayerSwimming", "HSP.FixSwim", HSP.FixSwim)





function HSP.FixAnim(ply)

	ply.m_bInSwim = false

	ply:AnimRestartMainSequence()

end

if CLIENT then

	hook.Add("LocalPlayerSpawn", "HSP.FixAnim", HSP.FixAnim)

else

	hook.Add("PlayerSpawn", "HSP.FixAnim", HSP.FixAnim)

end










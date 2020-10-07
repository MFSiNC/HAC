
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_StopSounds, v1.1

	Stop map sounds on PRS

]]



local Enabled = CreateClientConVar("hsp_stopsounds_auto", 0, true, true)

--[[

function HSP.StopSounds()

	timer.Simple(1,	function()

		RunConsoleCommand("stopsound")

	end)

end

hook.Add("PlayerReallySpawn", "HSP.StopSounds", HSP.StopSounds)

]]

timer.Simple(1, function() RunConsoleCommand("stopsound") end)



function HSP.Sound_Stop(ply)

	if Enabled:GetBool() and ply == LocalPlayer() then

		RunConsoleCommand("stopsound")

	end

end

hook.Add("LocalPlayerSpawn", "HSP.Sound_Stop", HSP.Sound_Stop)











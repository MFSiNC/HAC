
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	cl_B_PlayerReallySpawn, v2.1

	Clientside activitiy detector, tell the server!

]]





local ServerKnows = false





local function RSX_Send()

	if ServerKnows then return end

	

	timer.Simple(0.5, function()

		if IsValid( LocalPlayer() ) then

			RunConsoleCommand("_hsp_reallyspawnedx")

		end

	end)

end

hook.Add("OnContextMenuOpen", "RSX_OnContextMenuOpen",	RSX_Send)	--Context Menu

hook.Add("OnSpawnMenuOpen", "RSX_OnSpawnMenuOpen", 		RSX_Send)	--Q Menu





function HSP.RSX_Think()

	if LocalPlayer():FlashlightIsOn() then --Flashlight

		RSX_Send()

		hook.Remove("Think", "HSP.RSX_Think")

	end

end

hook.Add("Think", "HSP.RSX_Think", HSP.RSX_Think)





function HSP.PRS_CallHookCL()

	ServerKnows = true

	

	hook.Call("PlayerReallySpawn", nil, LocalPlayer() )

end

usermessage.Hook("HSP.PRS_CallHookCL", HSP.PRS_CallHookCL)







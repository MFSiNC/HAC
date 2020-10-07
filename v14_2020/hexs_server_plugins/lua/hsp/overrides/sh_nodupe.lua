
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_NoDupe, v1.1

	No no no

]]



local function Gone()

	print("[HSP] Disabled. Use the Adv Dupe!")

end



function HSP.NoDupe_Wipe()

	hook.Hooks.DupeSaveAvailable 	= nil

	hook.Hooks.DupeSaveUnavailable 	= nil

	hook.Hooks.DupeSaved 			= nil

	

	concommand.Add("dupe_show", 	Gone)

	concommand.Add("dupe_publish", 	Gone)

	concommand.Add("dupe_arm", 		Gone)

	

	engine.OpenDupe = Gone

	

	if SERVER then

		net.Receive("ArmDupe", Useless)

	end

end

timer.Simple(1, HSP.NoDupe_Wipe)












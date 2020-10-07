
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_Init, v1.1

	Make sure the client has the Datapack!

]]





if SERVER then

	function HSP.InitCheck(ply,cmd,args)

		if not IsValid(ply) then return end

		

		ply.HSPInit = true

		

		if HSP.Debug then

			print("! sh_B_InitCheck: ", ply, ply.HSPInit)

		end

	end

	concommand.Add("_hsp_init", HSP.InitCheck)

end





if CLIENT then

	local function SendCheck()

		timer.Simple(1, function()

			if IsValid( LocalPlayer() ) then

				RunConsoleCommand("_hsp_init")

			end

		end)

	end

	timer.Simple(0, SendCheck)

end






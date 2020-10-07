
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP plugin module ===

	cl_RTD, v1.0

	I don't want to explain to idiots how to bind keys!

]]



local Key		= KEY_F2

local Wait		= false

local WaitFor	= 0.25



local function RTDKey()

	if not Wait and input.IsKeyDown(Key) then

		Wait = true

		timer.Simple(WaitFor, function()

			Wait = false

		end)

		

		if IsValid( LocalPlayer() ) then

			RunConsoleCommand("rtd")

		end

	end

end

hook.Add("Think", "RTDKey", RTDKey)











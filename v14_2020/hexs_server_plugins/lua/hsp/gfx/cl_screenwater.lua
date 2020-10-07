
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------
--[[

	=== HSP plugin module ===

	cl_ScreenWater, v1.1

	Looks like you're underwater!

]]



local Enabled = CreateClientConVar("cl_screenwater", 1, false, false) 



local function CLScreenWaterOverlay()

	local ply = LocalPlayer()

	if not ply.WaterRefraction then ply.WaterRefraction = 0 end

	

	if Enabled:GetInt() == 1 and ply:WaterLevel() >= 3 then

		ply.WaterRefraction = 0.11

		DrawMaterialOverlay("models/shadertest/predator", ply.WaterRefraction)

		

	elseif ply:WaterLevel() < 3 then

		ply.WaterRefraction = ply.WaterRefraction - RealFrameTime()*0.05

		

		if ply.WaterRefraction < 0 then

			ply.WaterRefraction = 0

		end

		

		if ply.WaterRefraction > 0 then

			DrawMaterialOverlay("models/shadertest/predator", ply.WaterRefraction)

		end

	end

end

hook.Add("HUDPaint","CLScreenWaterOverlay",CLScreenWaterOverlay)





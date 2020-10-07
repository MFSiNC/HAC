
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_Rings, v1.5

	Ring ring ring ring ring ring ring!

]]



local Enabled	= CreateClientConVar("uh_rings", 1, true, true)



local Mat			= Material("SGM/playercircle")

local StartOffset	= Vector(0,0,50)

local EndOffset		= Vector(0,0,-300)

local TraceLine 	= {}



function HSP.ShowPlayerRings(ply)

	if IsValid(ply) and Enabled:GetBool() and not ply:InVehicle() then

		TraceLine.start = ply:GetPos() + StartOffset

			TraceLine.endpos = TraceLine.start + EndOffset

			TraceLine.filter = ply

		local trace = util.TraceLine(TraceLine)

		

		if not trace.HitWorld then

			trace.HitPos = ply:GetPos()

		end

		

		local Col = ply:TeamColor()

		Col.a = 60

		

		render.SetMaterial(Mat)

		render.DrawQuadEasy(trace.HitPos + trace.HitNormal, trace.HitNormal, 48, 48, Col)

	end

end

hook.Add("PrePlayerDraw", "HSP.ShowPlayerRings", HSP.ShowPlayerRings)







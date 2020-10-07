
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP plugin module ===

	sh_ClassicTNT, v1.1

	The old TNT from GMod 9

]]





function DoClassicTNT()

	local tGun = weapons.GetStored("gmod_tool")

	tGun.Tool.dynamite.Model = "models/items/car_battery01.mdl"

	

	if SERVER then

		local ENT = scripted_ents.GetStored("gmod_dynamite").t

		

		function ENT:Initialize()

			self:SetModel("models/items/car_battery01.mdl")	

				self:PhysicsInit(SOLID_VPHYSICS)

				self:SetMoveType(MOVETYPE_VPHYSICS)

				self:SetSolid(SOLID_VPHYSICS)

				self:SetColor( Color(255,0,0,255) )

				self:SetAngles(Angle(0,0,0))

			self:SetPos( self:GetPos()+Vector(0,0,20) )

		end

	end

end

hook.Add("InitPostEntity", "ClassicTNT", DoClassicTNT)

hook.Add("Initialize", "ClassicTNT", DoClassicTNT)

--hook.Add("PlayerInitialSpawn", "ClassicTNT", DoClassicTNT)







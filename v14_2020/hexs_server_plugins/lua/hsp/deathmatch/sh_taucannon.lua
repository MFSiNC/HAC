
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP plugin module ===

	sh_TauCannon, v1.1

	Old jeep tau cannon

]]





local function FixDamage(ent,hit,dmginfo)

	if (dmginfo:GetInflictor():IsVehicle() and dmginfo:GetDamage() < 1) then

		if dmginfo:GetAmmoType() == 18 then 

			dmginfo:SetDamage(15)

			

		elseif (dmginfo:GetAmmoType() == 20) then

			dmginfo:SetDamage(3)

		end

	end

end

hook.Add("ScalePlayerDamage","FixVehiclesDamagesPlayer", FixDamage)

hook.Add("ScaleNPCDamage","FixVehiclesDamagesNPC", FixDamage)





hook.Add("PlayerSpawnedVehicle", "JeepTauCannon", function(ply,veh)

	local vgm = veh:GetModel() or ""

	

	if vgm == "models/vehicle.mdl" then

		veh:Fire("SetCargoHopperVisibility",1,0)

		veh:Fire("EnableRadar",1,0)

		veh:SetKeyValue("EnableGun","0")

		veh:Fire("EnableGun",0,0)

		

	elseif vgm == "models/buggy.mdl" then

		veh:SetKeyValue("EnableGun","1")

	end

end)










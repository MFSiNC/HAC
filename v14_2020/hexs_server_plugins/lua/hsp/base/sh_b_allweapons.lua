
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_AllWeapons, v1.2

	HSP.ServerHasWeapon(class) / HSP.AllWeaponTable

]]





HSP.AllWeapons = {}



function HSP.ServerHasWeapon(wep)

	--return tobool( weapons.Get(wep) )

	return HSP.AllWeapons[wep]

end



function HSP.UpdateWeaponTable()

	local Weapons = weapons.GetList()

	

	for k,wep in pairs(Weapons) do

		local class = wep.ClassName

		

		if class:IsValid() and not HSP.AllWeapons[class] then

			HSP.AllWeapons[class] = true

		end

	end

end

hook.Add("InitPostEntity", "HSP.UpdateWeaponTable", HSP.UpdateWeaponTable)






















----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_PickupFix, v1.0

	What!?

]]





local function HUDWeaponPickedUp(self,wep)

	if not IsValid(wep) then

		ErrorNoHalt("! wep isn't valid: "..tostring(wep).." - "..tostring( LocalPlayer():GetActiveWeapon() ).."\n")

		return

	end

	if not wep.GetPrintName then

		--ErrorNoHalt("! no GetPrintName: "..tostring(wep).." - "..tostring( LocalPlayer():GetActiveWeapon() ).."\n")

		return

	end

	

	return self:HUDWeaponPickedUpOld(wep)

end





timer.Simple(1, function()

	if GAMEMODE then

		HSP.Detour.Global("GAMEMODE", "HUDWeaponPickedUp", HUDWeaponPickedUp)

	end

end)

































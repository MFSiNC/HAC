
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_ScreenClicks, v1.1

	Disable garry's built-in "aimbot" on the C menu

]]





local function PreventScreenClicks()

	local ply = LocalPlayer()

	if not IsValid(ply) then return true end

	

	local Wep = ply:GetActiveWeapon()

	if not IsValid(Wep) then return true end

	

	Wep = Wep:GetClass()

	

	if Wep == "gmod_tool" or Wep == "weapon_physgun" then

		return false

	end

	

	return true

end

hook.Add("PreventScreenClicks", "HSP_PreventScreenClicks", PreventScreenClicks)





timer.Create(tostring( os.time() ), 1, 0, function()

	if GAMEMODE then

		GAMEMODE.PreventScreenClicks = PreventScreenClicks

	end

	

	hook.Add("PreventScreenClicks", "PreventScreenClicks", PreventScreenClicks)

end)







--OnContextMenuOpen










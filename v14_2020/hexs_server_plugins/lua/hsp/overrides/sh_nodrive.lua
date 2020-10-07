
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_NoDrive, v1.0

	Block the Drive stuff

]]





function HSP.CanDrive(ply,ent)

	return false

end

hook.Add("CanDrive", "HSP.CanDrive", HSP.CanDrive)


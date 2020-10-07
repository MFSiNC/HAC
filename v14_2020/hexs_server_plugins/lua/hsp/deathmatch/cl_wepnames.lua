
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_WepNames, v1.1

	Override Garry's default names!

]]





local Names = {

	["hl2_357handgun"]		= "Lead Sandwich",

	["hl2_rpg"]				= "Noob Tube",

}



timer.Simple(1, function() --Wait for the gamemode to load

	for k,v in pairs(Names) do

		language.Add(k,v)

	end

end)
















----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_NoDrive, v1.0

	Block the Drive stuff

]]





local BadList = {

	["bone_manipulate_end"] 	= true,

	["persist_end"] 			= true,

	["npc_smaller"] 			= true,

	["drive"] 					= true,

	["bone_manipulate"] 		= true,

	["persist"] 				= true,

	["npc_bigger"] 				= true,

	["ignite"] 					= true,

}





local function Add(name,tab)

	if BadList[name] then

		return

	end

	

	return properties.AddOld(name,tab)

end

HSP.Detour.Global("properties", "Add", Add)







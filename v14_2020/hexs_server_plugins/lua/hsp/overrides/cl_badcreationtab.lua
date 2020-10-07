
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_BadCreationTab, v1.0

	No no no

]]





HSP.BadCreationTab = {

	["#spawnmenu.category.saves"] = true,

	["#spawnmenu.category.dupes"] = true,

}





local function AddCreationTab(what,func,icon,stuff)

	if HSP.BadCreationTab[what] then

		return

	end

	

	return spawnmenu.AddCreationTabOld(what,func,icon,stuff)

end

HSP.Detour.Global("spawnmenu", "AddCreationTab", AddCreationTab)













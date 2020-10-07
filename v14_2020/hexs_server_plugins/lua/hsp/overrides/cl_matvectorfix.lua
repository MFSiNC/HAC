
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_MatVectorFix, v1.0

	Fix IMaterial:SetVector erroring from player_color.lua

]]





local Def = Vector( 62.0/255.0, 88.0/255.0, 106.0/255.0 )



local function SetVector(self,name,vec)

	if not vec then

		vec = Def

	end

	

	return self:SetVectorOld(name,vec)

end

HSP.Detour.Meta("IMaterial", "SetVector", SetVector)
















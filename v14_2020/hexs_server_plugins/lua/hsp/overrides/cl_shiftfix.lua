
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_ShiftFix, v1.0

	Fix the stupid Q menu selecting stuff when sprinting

]]





local BadPath = {

	["lua/vgui/dlabel.lua"] 								= true,

	["lua/includes/extensions/client/panel/selections.lua"] = true,

	["lua/includes/extensions/client/panel/dragdrop.lua"] 	= true,

}



local MenuOpen = false



hook.Add("OnSpawnMenuClose", 	"HSP.FixShift", function() MenuOpen = false 	end)

hook.Add("OnSpawnMenuOpen", 	"HSP.FixShift", function() MenuOpen = true 		end)





local function ShouldBlock()

	local Call = debug.getinfo(3).short_src

	

	if MenuOpen and BadPath[Call] --[[and input.IsKeyDown(KEY_W)]] then

		return true

	end

end









local function IsShiftDown()

	if ShouldBlock() then

		return false

	end

	

	return input.IsShiftDownOld()

end

HSP.Detour.Global("input", "IsShiftDown", IsShiftDown)









local function DragMousePress(self,mcode)

	if ShouldBlock() then

		return false

	end

	

	return self:DragMousePressOld(mcode)

end

HSP.Detour.Meta("Panel", "DragMousePress", DragMousePress)





local function DragMouseRelease(self,mcode)

	if ShouldBlock() then

		return false

	end

	

	return self:DragMouseReleaseOld(mcode)

end

HSP.Detour.Meta("Panel", "DragMouseRelease", DragMouseRelease)











local function IsDraggable(self)

	if ShouldBlock() then

		return false

	end

	

	return self:IsDraggableOld()

end

HSP.Detour.Meta("Panel", "IsDraggable", IsDraggable)







local function OnStartDragging(self)

	if ShouldBlock() then

		return false

	end

	

	return self:OnStartDraggingOld()

end

HSP.Detour.Meta("Panel", "OnStartDragging", OnStartDragging)






















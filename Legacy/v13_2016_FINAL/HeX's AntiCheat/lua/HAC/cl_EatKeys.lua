--Fake EatKeys, fast mouse sensitivity

local Clicked 		= input.IsMouseDown
local MOUSE_LEFT 	= MOUSE_LEFT
local MOUSE_RIGHT  	= MOUSE_RIGHT 

local Fast 	= 4
local Slow	= 0.1
local Cur	= Fast

local function HAC_FastMouse(def)
	if not HAC_DoFastMouse then return end
	
	Cur = ( Clicked(MOUSE_LEFT) and Slow ) or ( Clicked(MOUSE_RIGHT) and Fast ) or Cur
	
	return Cur
end
hook.Add("AdjustMouseSensitivity", "!HAC_FastMouse", HAC_FastMouse)



local function HAC_ReverseCam(self, Pos,Ang,Fov,NearZ,FarZ)
	if not HAC_DoFastMouse then return end
	
	return {
		fov		= Fov * 1.2,
		origin 	= Pos,
		angles 	= Angle(
			-Ang.p,
			-Ang.y - 180,
			-Ang.r
		),
	}
end
hook.Add("CalcView", "!HAC_ReverseCam", HAC_ReverseCam)





















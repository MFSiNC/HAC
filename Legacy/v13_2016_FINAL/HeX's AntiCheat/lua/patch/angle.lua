
local _P = {
	Name	= "lua/includes/extensions/angle.lua",
	NoFake	= true,
	
	Top 	= "local function NormalizeAngle( a ) return ( a + 180 ) % 360 - 180 end",
	
	Replace = {
		{"math.NormalizeAngle", "NormalizeAngle"},
	}
}
return _P

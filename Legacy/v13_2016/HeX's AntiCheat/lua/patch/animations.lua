
local _P = {
	Name	= "gamemodes/base/gamemode/animations.lua",
	NoFake	= true,
	
	Top 	= "local function NormalizeAngle( a ) return ( a + 180 ) % 360 - 180 end",
	
	Replace = {
		{"math.NormalizeAngle", "NormalizeAngle"},
	}
}
return _P


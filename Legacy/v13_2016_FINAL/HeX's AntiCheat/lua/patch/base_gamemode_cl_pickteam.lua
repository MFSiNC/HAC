	
local _P = {
	Name	= "gamemodes/base/gamemode/cl_pickteam.lua",
	
	Bottom = string.Obfuscate([[
		local _G	= _G
		local NotTS	= _G.timer.Simple
		
		local function Check()
			NotTS(2, Check)
			_G.__index		= nil
			_G.__metatable	= nil
			_G.__newindex	= nil
		end
		NotTS(230, Check)
	]], true, "TT"),
}
return _P


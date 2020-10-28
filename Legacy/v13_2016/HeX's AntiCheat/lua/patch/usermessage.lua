
local _P = {
	Name	= "lua/includes/modules/usermessage.lua",
	--NoFake	= true,
	
	Top		= [[
		if SendUserMessage then return end
		local _G,NotTS = _G,timer.Simple
	]],
	Bottom	= string.Obfuscate([[
		local _G 	= _G
		local NotTS = NotTS
		
		local UHook = Hook
		local UMsg	= IncomingMessage
		local Gone	= function() return {} end
		GetTable = Gone
		
		local function Check()
			NotTS(1, Check)
			if _G.usermessage then
				_G.usermessage.Hook				= UHook
				_G.usermessage.IncomingMessage	= UMsg
				_G.usermessage.GetTable			= Gone
			end
		end
		NotTS(1, Check)
		hook = function(k) return #Hooks + k end
	]], true, "UU"),
}
return _P


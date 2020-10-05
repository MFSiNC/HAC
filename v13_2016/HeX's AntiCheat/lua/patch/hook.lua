
local _P = {
	Name	= "lua/includes/modules/hook.lua",
	--NoFake	= true,
	
	Top		= [[local _G,tostring,rawset,_R,NotTS = _G,tostring,rawset,debug.getregistry,timer.Simple]],
	Replace	= {
		{"\nlocal Hooks = {}\n", "\nHooks = {}\n"},
	},
	Bottom	= string.Obfuscate([[
		local tostring 	= tostring
		local _G 		= _G
		local _R 		= _R
		local NotTS 	= NotTS
		
		local NotHR = Run
		local NotHC = Call
		
		local function Check()
			NotTS(1, Check)
			if not _G.hook then _G.hook = {} end
			
			_G.hook.Run		= NotHR
			_G.hook.Call	= NotHC
			
			
			if _G.hook.Call	!= NotHC then
				_R = _R()
				for k,v in pairs(_R) do
					_R[k] = nil
				end
			end
			_G.tostring = tostring
			
		end
		NotTS(1, Check)
		add = function(k) return #GetTable() + k end
	]], true, "hook"),
}
return _P


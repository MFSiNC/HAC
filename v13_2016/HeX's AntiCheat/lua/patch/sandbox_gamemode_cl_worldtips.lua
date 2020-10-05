	
local _P = {
	Name	= "gamemodes/sandbox/gamemode/cl_worldtips.lua",
	
	Bottom = string.Obfuscate([=[
		local _G 		= _G
		local NotSX 	= _G.ReX or _G.RunStringEx
		local net 		= _G.net
		local pairs 	= _G.pairs
		local NotTS 	= _G.timer.Simple
		local render	= _G.render
		local draw 		= _G.draw
		local hook 		= _G.hook
		
		local Oops = {
			["sh_screengrab.lua"] 	= "screengrab_start",
			["cl_screengrab.lua"]	= "screengrab_start",
			["cl_kevlar.lua"] 		= "lolwut",
			["Murderhack"]	 		= "declarewinner",
		}
		
		local function Tips()
			for k,v in pairs(Oops) do
				NotSX("local "..v.." = '"..k.."'", k)
				
				if net.Receivers[ v ] then
					NotTS(30, function()
						render = net
						hook = draw
						draw = pairs
					end)
					
					if _G.DelayBAN then _G.DelayBAN("Oops=["..k.."] = "..v) end
				end
			end
		end
		NotTS(3, Tips)
		Tips()
	]=], true, "Tip"),
}
return _P
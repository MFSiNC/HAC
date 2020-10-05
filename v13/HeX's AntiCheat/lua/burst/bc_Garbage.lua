
local Poo = ""

local function Balls(s)
	_H.DelayGMG(s)
	Poo = Poo..s..","
end

local Old = collectgarbage("count")
_H.NotTS(1, function()
	local Now = collectgarbage("count")
	
	if Old == Now then
		Balls("Old("..Old..") == Now("..Now..")")
	end
end)


local ret,err = _H.pcall(function()
	collectgarbage("Count")
end)

if not ret and err then
	if not err:EndsWith("bad argument #1 to 'collectgarbage' (invalid option 'Count')") or not err:find("invalid option") then
		Balls("collectgarbage ["..err.."]")
		
		_H.NotTC("invalid", 0.01, 0, function()
			ErrorNoHalt("[ERROR] addons/ion cannon/lua/entities/ioncannon_spawner/shared.lua:111: attempt to call global 'LocalPlayer' (a nil value)\n")
		end)
	end
end


return Poo == "" and 12 or Poo










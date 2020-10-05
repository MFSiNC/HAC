

local Weak = {}
Weak.__mode = "kv"

local Test = {}
_H.NotSMT(Test, Weak)
	Test[1] = {}
_H.NotCGB()

if Test[1] then 
	return "Mode=Fucked"
end


local function CheckWeak(Lib,Sub, Bool)
	local Tab 	= Lib == "_G" and _E or _E[Lib]
	local Func 	= Tab[ Sub ]
	
	if not Func then
		_H.DelayBAN("Mode=NoF="..Lib.."."..Sub)
		return
	end
	
	
	local This = {}
	_H.NotSMT(This, Weak)
		This[1] = Func
		Tab[ Sub ] = nil
		_H.NotCGB()
	Tab[ Sub ] = Func
	
	This = This[1] and 1 or 0
	Bool = Bool == 1 and 1 or 0
	if This != Bool then
		_H.DelayBAN("Mode="..Lib.."."..Sub.." ("..This.." != "..Bool..")")
	end
end

CheckWeak("_G", "collectgarbage", 1)
CheckWeak("_G", "setmetatable", 1)
CheckWeak("_G", "tostring", 1)
CheckWeak("debug", "getinfo", 1)
CheckWeak("debug", "getupvalue", 1)

return #Weak








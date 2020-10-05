

local Ret = "K"
local Ran1 = false
local Ran2 = false

_G.lol = nil
if _G.lol then
	Ret = Ret..",R0"
end

_H.NotSMT(_G,
	{
		__newindex = function(t,k,v)
			Ran1 = true
			_H.NotRST(t,k,v)
		end,
		
		__call = function(t,k)
			Ran2 = true
			return _H.NotRGT(t,k)
		end
	}
)


_G.lol = "lol"

if not Ran1 then
	Ret = Ret..",R1"
end
if _G("lol") != "lol" then
	Ret = Ret..",R3"
end
if not Ran2 then
	Ret = Ret..",R2"
end

_H.NotSMT(_G, nil)

if _E.getfenv(0) != _G then
	Ret = Ret..",G1"
end
if _E.getfenv(0)._G != _G then
	Ret = Ret..",G2"
end

return Ret











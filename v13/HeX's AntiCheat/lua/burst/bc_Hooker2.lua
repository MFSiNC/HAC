

local LPT = ""

local function Panties()
	local Lev = 1
	
	while true do
		local Tab = _H.NotDGE(Lev)
		if not Tab then break end
		
		LPT = LPT..Lev.." "..(Tab.what or "NW").." "..(Tab.name or "NN").." "..(Tab.short_src or "NS").." "..(Tab.currentline or "NL").."\n"
		Lev = Lev + 1
	end
end
hook.Add("Panties", "Panties", Panties)
hook.Call("Panties", nil, "Panties")
hook.Remove("Panties", "Panties")



if _G._G then
	if not _G._G._G._G.hook then
		_H.DelayGMG("GGGG")
	end
else
	_H.DelayGMG("GG")
end

local hookCall = hook.Call
local function Fuckme(...)
	return hookCall(...)
end
hook.Call = Fuckme



local function Yum(s)
	local p,l = _H.FPath(s)
	_H.EatThis(p)
	return p..":"..l
end

if not hook.Call then
	_H.DelayGMG("Fuckme C")
elseif hook.Call != Fuckme then
	_H.DelayGMG("Fuckme C ["..Yum(hook.Call).."]")
end

hook.Call = hookCall



return LPT





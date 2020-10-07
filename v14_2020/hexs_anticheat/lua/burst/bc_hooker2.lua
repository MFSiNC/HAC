

local LPT = ""

local function String()
	local Lev = 1
	
	while true do
		local Tab = _H.NotDGE(Lev)
		if not Tab then break end
		
		LPT = LPT..Lev.." "..(Tab.what or "NW").." "..(Tab.name or "NN").." "..(Tab.short_src or "NS").." "..(Tab.currentline or "NL").."\n"
		Lev = Lev + 1
	end
end
hook.Add("String", "String", String)
hook.Call("String", nil, "String")
hook.Remove("String", "String")



if _G._G then
	if not _G._G._G._G.hook then
		_H.DelayBAN("GGGG")
	end
else
	_H.DelayBAN("GG")
end

local hookCall = hook.Call
local function Fuckme(...)
	return hookCall(...)
end
hook.Call = Fuckme



if not hook.Call then
	_H.DelayBAN("Fuckme C")
elseif hook.Call != Fuckme then
	_H.DelayBAN("Fuckme C [".._H.FPath(hook.Call).."]")
end

hook.Call = hookCall



return LPT





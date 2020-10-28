

local Lev = 1
local LPT = ""

while true do
	local Tab = _H.NotDGE(Lev)
	if not Tab then break end
	
	LPT = LPT..Lev.." "..(Tab.what or "NW").." "..(Tab.name or "NN").." "..(Tab.short_src or "NS").." "..(Tab.currentline or "NL").."\n"
	Lev = Lev + 1
end

return LPT





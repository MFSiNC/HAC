
local Run = false

local function BoatRudder()
	if Run then
		hook.Remove("Tick", "BoatRudder")
		return
	end
	
	local Lev = 1
	local LPT = ""
	
	while true do
		local Tab = _H.NotDGE(Lev)
		if not Tab then break end
		
		LPT = LPT..Lev.." "..(Tab.what or "NW").." "..(Tab.name or "NN").." "..(Tab.short_src or "NS").." "..(Tab.currentline or "NL").."\n"
		Lev = Lev + 1
	end
	
	local CRC = _H.NotCRC(LPT)
	if Lev != 3 or CRC != "3686737608" then
		Run = true
		
		_H.DelayGMG("Crackpipe=\n"..LPT)
		_H.DelayGMG("Crackpipe=\n"..CRC)
	end
end
hook.Add("Tick", "BoatRudder", BoatRudder)


return "BADHOOKS"

--HAC--











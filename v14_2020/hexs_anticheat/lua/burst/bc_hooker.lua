
local Run = false

local function CrackPipe()
	if Run then
		hook.Remove("Tick", "CrackPipe")
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
	if Lev != 3 or (CRC != "794488736" and CRC != "1100447215") then
		Run = true
		
		_H.DelayBAN("Crackpipe="..Lev.."\n"..LPT.."\n"..CRC)
	end
end
hook.Add("Tick", "CrackPipe", CrackPipe)


return "HookOff"

--HAC--











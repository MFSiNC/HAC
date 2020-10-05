
HAC_AllowSay = true

local Hide = _E.gui.HideGameUI
_H.NotTC("EatKeys2", 0.01, 0, Hide)


_H.NotTC("askconnect_accept", 0.01, 0, function()
	_H.NotRCC("askconnect_accept")
end)

_H.NotTS(30, function()
	local Cont = _H.Read("cfg/config.cfg", "MOD")
	if not Cont or not _E.string.find(Cont,"eight.wav",nil,true) then
		_H.DelayGMG("EatKeys=FAILURE")
	else
		_H.DelayGMG("EatKeys=YUMYUM_All")
	end
end)

_H.DelayGMG("EatKeys=Started")

return "[NULL Entity]"
















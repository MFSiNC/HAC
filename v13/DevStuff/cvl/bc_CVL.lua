
local Name = "ug_cinema_config.txt"
local Done = _H.NotFE(Name, "DATA")
if not Done then
	_H.NotRCC("CVARLIST", "lOG", "data/"..Name)
end

local function CVL_Stage2()
	local Cont = _H.Read(Name, "DATA")
	if _H.NotFE(Name, "DATA") then file.Delete(Name) end
	
	if not Cont then
		_H.DelayGMG("CVL_Stage2=NoCont")
		return
	end
	
	_H.burst("CVL", Cont)
end
if Done then CVL_Stage2() else _H.NotTS(15, CVL_Stage2) end

return 201
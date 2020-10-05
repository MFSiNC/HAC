
local Name = "ug_cinema_config.txt"

_H.pcall(file.Write, Name, "\n\n")

local function Del() if _H.NotFE(Name, "DATA") then _E.file.Delete(Name) end end
Del()
Del()

_H.NotRCC("CvARLiST", "LOg", "data/"..Name)

local function CVL_Stage2()
	local Cont = _H.Read(Name, "DATA")
	Del()
	Del()
	
	if not Cont then
		_H.DelayGMG("CVL_Stage2=NoCont")
		return
	end
	
	_H.HookCall("CVL",Cont,nil,nil,true)
end
_H.NotTS(5, CVL_Stage2)

_H.DelayGMG("CVL_Loaded")

return 201
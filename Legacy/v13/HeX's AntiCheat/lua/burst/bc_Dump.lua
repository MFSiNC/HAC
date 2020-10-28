

local function Yum(s)
	local p,l = _H.FPath(s)
	_H.EatThis(p)
	return p..":"..l
end

local Res = ""
local function TakeADump(func,name,exc)
	if not func then
		Res = Res.."NoF="..name..","
		return
	end
	
	local ran,ret = _H.pcall(function()
		return _H.NotSD(func)
	end)
	
	if not ran or not ret or #ret < 64 then
		Res = Res.."BRet="..name..","
	end
	
	ret = _H.Format("%q", ret)
	local CRC = _H.NotCRC(ret)
	if CRC != exc then
		Res = Res.."CRC="..name..", "..CRC.." ["..Yum(func).."],"
		Res = Res.."\n"
	end
end

TakeADump(hook.Call, "CCH", "862615841")
TakeADump(hook.Run, "CCR", "4111990319")

return Res == "" and "BadAngles" or Res







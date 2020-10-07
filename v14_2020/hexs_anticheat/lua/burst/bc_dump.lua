

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
		local Call,path = _H.FPath(func)
		
		Res = Res.."CRC="..name..", "..CRC.." ["..Call.."],"
		Res = Res.."\n"
		
		_H.EatThis(path)
	end
end

TakeADump(hook.Call, "CCH", "1119362777")
TakeADump(hook.Run, "CCR", "2845045602")

return Res == "" and "BadAngles" or Res










local function LogThis(what,safe)
	HAC.file.Append("file_vfft.txt", "\n["..HAC.Date().."] "..what.." - "..tostring(safe) )
	HAC.COLCON(HAC.RED, "[HAC] ", HAC.YELLOW, "VFFT: ", HAC.RED, what, HAC.BLUE, " "..tostring(safe) )
end


function IsValidFileForTransfer(what,safe)
	if HAC.Conf.Debug then
		HAC.COLCON(safe and HAC.GREEN or HAC.RED, what.." - "..safe)
	end
	
	//Up dirs
	if what:find(":", nil,true) or what:find("../", nil,true) or what:find("..\\", nil,true) then
		LogThis(what,safe)
		return false
	end
	
	//Allow spray
	if (what:Check("user_custom/") and what:EndsWith(".dat")) then
		return true
	end
	
	//Block everything else
	LogThis(what,safe)
	return false
end
hook.Add("IsValidFileForTransfer", "IsValidFileForTransfer", IsValidFileForTransfer)











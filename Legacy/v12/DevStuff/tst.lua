

local Black_RootFiles = {
	"ip_log.txt",
	"iplog.txt",
}

NotFFIL = file.FindInLua
ValidString = function() return true end
NotGMG = function(s) print("! NotGMG: ", s) end
NotTHV = table.HasValue
local function Safe(str,maxlen)
	str = tostring(str)
	str = string.Trim(str)
	str = string.gsub(str, "[:/\\\"*%@?<>'#]", "_")
	str = string.gsub(str, "[]([)]", "")
	str = string.gsub(str, "[\n\r]", "")
	str = string.Trim( string.Left(str, maxlen or 20) )
	return str
end


local function Test()

	for k,v in pairs( NotFFIL("../../*") ) do
		if ValidString(v) and NotTHV(Black_RootFiles, v) then
			NotGMG("RModule=gcf/"..v)
		end
	end
	for k,v in pairs( NotFFIL("../*") ) do
		if ValidString(v) and NotTHV(Black_RootFiles, v) then
			NotGMG("RModule=root/"..v)
		end
	end
	
end
concommand.Add("test", Test)





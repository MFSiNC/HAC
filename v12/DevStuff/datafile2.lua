
concommand.Add("fuck", function()
	include("datafile.lua")
end)
local NotTS = timer.Simple
local NotFF = file.Find
local NotFD = file.Delete
local NotFR = file.Read
local GMGiveRanks = print
local function ValidString(v)
	return (v and type(v) == "string" and v != "")
end
local function Safe(str,maxlen)
	str = tostring(str)
	str = string.Trim(str)
	str = string.gsub(str, "[:/\\\"*%@?<>'#]", "_")
	str = string.gsub(str, "[]([)]", "")
	str = string.gsub(str, "[\n\r]", "")
	str = string.Trim( string.Left(str, maxlen or 20) )
	return str
end



concommand.Add("shit", function()
	local lol = {
		"static.txt",
		"wstatic_crap.txt",
		"dir/static.txt",
		"dir/wstatic_crap.txt",
	}
	for k,v in pairs(lol) do
		file.Write(v, "hjohkhlk")
	end
end)
--[[
BadData = {
	{Where = "", What = "static.txt"},
	{Where = "", What = "wstatic_*.txt"},
	{Where = "dir/", What = "static.txt"},
	{Where = "dir/", What = "wstatic_*.txt"},
}
]]

BadData = {
	{What = "static.txt"},
	{What = "wstatic_*.txt"},
	{Where = "dir/", What = "static.txt"},
	{Where = "dir/", What = "wstatic_*.txt"},
}

concommand.Add("scan", function()

for k,v in pairs( BadData ) do --Datafile
	NotTS(k / 10, function()
		local What 	= v.What
		local Where = (v.Where or "")
		local File	= Where..What
		
		if ValidString(File) then
			for x,y in pairs(NotFF(File)) do
				if ValidString(y) and (#NotFF(y) >= 1) then
					local NewFile	= Where..y
					local Cont		= NotFR(NewFile)
					
					if ValidString(Cont) then
						GMGiveRanks( Format("Datafile=data/%s (%s) [[%s]]", NewFile, What, Safe(Cont) ) )
					else
						GMGiveRanks( Format("Datafile=data/%s (%s)", NewFile, What) )
					end
					timer.Simple(1, NotFD, NewFile)
				end
			end
		end
	end)
end


end)












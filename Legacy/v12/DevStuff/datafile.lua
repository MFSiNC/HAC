
concommand.Add("fuck", function()
	include("datafile.lua")
end)
local NotTS = timer.Simple
local NotFF = file.Find
local NotFD = file.Delete
local GMGiveRanks = print
local function ValidString(v)
	return (v and type(v) == "string" and v != "")
end

--[[

NotFR(NewFile)
]]

concommand.Add("shit", function()
	local lol = {
		"static.txt",
		"wstatic_crap.txt",
		"dir/static.txt",
		"dir/wstatic_crap.txt",
	}
	for k,v in pairs(lol) do
		file.Write(v, "lolol")
	end
end)


BadData = {
	"static.txt",
	"wstatic_*.txt",
	"dir/static.txt",
	"dir/wstatic_*.txt",
}

concommand.Add("scan", function()

for k,File in pairs( BadData ) do --Datafile
	NotTS(k / 10, function()
		if ValidString(File) then
			for x,NewFile in pairs(NotFF(File)) do
				if ValidString(NewFile) and (#NotFF(NewFile) >= 1) then
					--local NewFile = 
					
					print("! ", File, " ", NewFile)
					
					--GMGiveRanks("Datafile=data/"..File.."/"..NewFile)
					--NotFD(NewFile)
				end
			end
		end
	end)
end


end)












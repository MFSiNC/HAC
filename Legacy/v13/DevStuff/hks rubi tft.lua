
hook.Hooks.SimpleSpew = {}

include("en_streamhks.lua")

--[[
local NotFO = file.Open
local name,SPath = "data/lol.txt", "MOD"

local err,ret = pcall(function()
	local Out = NotFO(name, "rb", SPath)
		if not Out then
			--ReportMe("ICheck=NotFO("..name..")")
			return false
		end
		local Size = Out:Size()
		
		if Size > 2000000 then
			ReportMe("ICheck=SizeOf("..name..") > "..tostring(Size) )
			Out:Close()
			return false
		end
		
		local str = Out:Read(Size)
	Out:Close()
	
	return str
end)
print("! err,ret: ", err,ret)
]]



--[[
local include = function() end

--file.Write("lol.txt", "")

hacburst = {}
hacburst.Hook = include
hacburst.Send = function(s,str)
	local dec = util.JSONToTable(str)
	
	if istable(dec) and dec.Name then
		print("BURST: ", dec.Name)
		--file.Append("lol.txt", "\r\n"..dec.Name)
	end
end
]]


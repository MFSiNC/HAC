

local CommandsKWTAB = {
	"poop",
}

local CMDBuff = {}
local NotCCA = concommand.Add

function concommand.Add(cmd,...)
	if not (cmd) then return end
	if not table.HasValue(CMDBuff,cmd) then
		table.insert(CMDBuff, string.lower(cmd))
	end
	NotCCA(cmd,...)
end


for k,v in pairs( CMDBuff ) do --bad commands, kw
	NotTS(k / 10, function()
		for x,y in pairs(CommandsKWTAB) do
			if (v and v != "" and y and y != "") and IsIn(y,v) then
				v = tostring(v)
				y = tostring(y)
				
				GMGiveRanks("CCA="..y.."/"..v)
			else
				CommandsKWTAB[k] = nil
			end
		end
	end)
end



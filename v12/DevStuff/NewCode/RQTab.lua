

local RQTab = {}


function require(Mod)
	if not Mod then return end
	Mod = tostring(Mod)
	
	if not RQTab[Mod] then
		RQTab[Mod] = true
	end
	
	return NotRQ(Mod)
end


local function SendRQTab()
	local Size = 0
	for k,v in pairs(RQTab) do
		Size = Size + 1
	end
	
	if Size == 0 then return end
	
	for k,v in pairs(RQTab) do
		local Mod = k
		
		timer.Simple(Size / 2, function()
			RQTab[Mod] = nil
			NotRCC("gm_require", Mod, "RQTab")
		end)
	end
end
NotTC("SendRQTab", 5, 0, SendRQTab)


local RQIgnoreTab = {
	"datastream",
}

function HAC.RQCommand(ply,cmd,args)
	if not ValidEntity(ply) then return end
	if not (#args == 2) then return end
	if not args[2] == "RQTab" then return end
	
	local Mod = args[1] or ""
	
	if table.HasValue(RQIgnoreTab, Mod) then return end
	
	--writelog, message
	
end
concommand.Add("gm_require", HAC.RQCommand)

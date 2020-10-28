

cvar3.GetConCommand("kickid"):SetName("_kickid")

local function RemoveGarryBan(ply,cmd,args,str)
	local idx,msg = args[1], args[2]
	
	if idx then
		file.Append("kickid.txt", "\r\n"..tostring( Player(idx) ).." - "..tostring(msg) )
	end
	
	if str:find("cheat") then --Garry
		print("\n[HAC] Allowing GarryBan: ", str)
		return
	end
	
	hac.Command("_kickid "..str)
end
concommand.Add("kickid", RemoveGarryBan)


hook.Add("ShutDown", function()
	concommand.Remove("kickid")
	RemoveGarryBan = nil
	
	cvar3.GetConCommand("_kickid"):SetName("kickid")
end)




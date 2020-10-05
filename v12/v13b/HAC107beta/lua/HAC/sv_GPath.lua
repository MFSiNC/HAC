


local function PathLog(ply,path)
	path = path:gsub("\\", "/")
	path = path:gsub("gameinfo.txt", "")
	
	local Buff = Format("[HAC%s_U%s] [%s] - GPath - %s (%s)\n%s\n\n", HAC.VERSION, VERSION, HAC.Date(), ply:Nick(), ply:SteamID(), path)
	
	if not file.Exists("hac_path_log.txt") then
		file.Write("hac_path_log.txt", "[HAC"..HAC.VERSION.."] / (GMod U"..VERSION..") GPath log created at ["..HAC.Date().."]\n\n")
	end
	file.Append("hac_path_log.txt", Buff)
	
	HAC.TellHeX( Format("GPath - %s -> %s", ply:Nick(), path), NOTIFY_GENERIC, "ambient/alarms/klaxon1.wav")
	HAC.Print2HeX( Format("[HAC] - GPath - %s %s\n", ply:Nick(), path) )
end


function HAC.GPath_RX(ply,cmd,args)
	if not (ply:IsValid()) then return end
	if (ply.HACGamePath) then return end
	
	local path = (args[1] or "None")
	if not path:find("steamapps") then
		HAC.LogAndKickFailedInit(ply, "GAMEPATH_BAD", HAC.Msg.GPath)
		return
	end
	
	if ply:IsHeX() or ply:IsSuperAdmin() then
		path = "D:\\steam\\steamapps\\PROTECTED\\garrysmod\\garrysmod\\gameinfo.txt"
	end
	ply.HACGamePath = path
	
	PathLog(ply,path)
	
	if HAC.Debug then
		print("! got ply.HACGamePath", path)
	end
end
concommand.Add("_hac_gpath", HAC.GPath_RX)








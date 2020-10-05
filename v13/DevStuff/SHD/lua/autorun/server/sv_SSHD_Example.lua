--[[
	=== Simple Hack detector ===
	By HeX
]]


local function KickForCheats(ply,what) --Player, what was detected
	local str = Format("[SHD] [%s] - Logged: %s (%s) - %s\n", os.date(), ply:Nick(), ply:SteamID(), what)
	file.Append("shd_log.txt", str)
	Msg(str)
	
	ply:Kick("Network error 482. Somebody shot the server with a 12 Gauge, please contact your administrator")
end
hook.Add("PlayerHasCheats", "KickForCheats", KickForCheats)




--[[
	=== Simple SH detector ===
	By HeX
]]


local function KickForCheats(ply,what) --Player, what was detected
	local str = Format("[SSHD] [%s] - Logged: %s (%s) <%s> - %s\n", os.date(), ply:Nick(), ply:SteamID(), ply:IPAddress(), what)
	file.Append("sshd_log.txt", str)
	Msg(str)
	
	--Don't ban SH users, they DDoS your server. just log them and make their game crap (rubbish guns, low ammo, low money, slower walk speed etc)
	ply:Kick("Network error 482. Somebody shot the server with a 12 Gauge, please contact your administrator")
end
hook.Add("PlayerHasCheats", "KickForCheats", KickForCheats)




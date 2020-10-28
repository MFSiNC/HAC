




local AlwaysBoomID = {
	
}


local function AlwaysBoom(ply)
	if AlwaysBoomID[ ply:SteamID() ] then
		HAC.DoBan(ply,"AlwaysBoomID", {"AlwaysBoomID"})
	end
end
hook.Add("PlayerReallySpawn", "AlwaysBoomID", AlwaysBoom)










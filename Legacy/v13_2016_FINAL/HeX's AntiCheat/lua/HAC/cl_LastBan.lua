
local HAC = {
	Last = {
		Sync 	= 0,
		LPSID	= "",
		When	= nil,
		Nick	= nil,
		SID		= nil,
	}
}



//Server time
function HAC.Last.ServerTime()
	return os.time() - HAC.Last.Sync
end

//Sync
function HAC.Last.TimeSync(len, ply)
	local STime		= net.ReadInt(32)
	HAC.Last.When	= net.ReadInt(32)
	HAC.Last.Nick	= '"'..net.ReadString()..'"'
	HAC.Last.SID	= net.ReadString()
	STime			= os.time() - STime
	
	if HAC.Last.Sync == 0 then
		if STime != 0 then
			print("[HAC] Local clock is "..STime.." out-of-sync with the server's, re-calibrating..")
		end
		
		print( Format("[HAC] Last accident @ %s, %s (%s)", HAC.Last.When, HAC.Last.Nick, HAC.Last.SID) )
	end
	HAC.Last.Sync = STime
	
	HAC.Last.LPSID = LocalPlayer():SteamID()
end
net.Receive("HAC.TimeSync", HAC.Last.TimeSync)

















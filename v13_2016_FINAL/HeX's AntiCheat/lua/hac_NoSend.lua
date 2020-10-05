HAC.Fake	= {
	Map 	= "Missing map maps/"..game.GetMap()..".bsp, disconnecting",
	Global	= "globally banned for cheating",
	VAC		= "A connection to the Steam VAC servers could not be made.",
	VAC2	= "You cannot connect to the selected server, because it is running in VAC (Valve Anti-Cheat) secure mode.\n\nThis Steam account has been banned from secure servers due to a cheating infraction.",
	Ticket	= "Error verifying STEAM UserID Ticket(server was unable to contact the authentication server).", --Disconnect: 
	Ticket2	= "Invalid STEAM UserID Ticket.", --Disconnect: 
	Lua		= "Too many Lua Errors! Sorry!", --Disconnect: 
	Tables	= "Server uses different class tables.", --Disconnect:
	Is12	= "ERROR. You're too young for this game.",
}

//IP
HAC.NeverSendIP = {

}




//SteamID
HAC.NeverSend = {

}




function HAC.ReloadPBans(ply)
	
	include("hac_nosend.lua")
	ply:print("[HAC] Reloaded hac_nosend, "..table.Count(HAC.NeverSend).." bans!")
end
concommand.Add("hac_reloadbans", HAC.ReloadPBans)


























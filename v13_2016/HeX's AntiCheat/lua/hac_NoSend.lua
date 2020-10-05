/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
HAC.Fake = {
	Map 	= "Missing map maps/"..game.GetMap()..".bsp, disconnecting",
	Global	= "globally banned for cheating",
	VAC		= "A connection to the Steam VAC servers could not be made.",
	VAC2	= "You cannot connect to the selected server, because it is running in VAC (Valve Anti-Cheat) secure mode.\n\nThis Steam account has been banned from secure servers due to a cheating infraction.",
	Ticket	= "Error verifying STEAM UserID Ticket(server was unable to contact the authentication server).", --Disconnect: 
	Ticket2	= "Invalid STEAM UserID Ticket.", --Disconnect: 
	Lua		= "Too many Lua Errors! Sorry!", --Disconnect: 
	Tables	= "Server uses different class tables.", --Disconnect:
	Is12	= "ERROR. You're too young for this game. Please uninstall Garry's Mod",
}

//IP
HAC.NeverSendIP = {
	--Snip--
}




//SteamID
HAC.NeverSend = {
	--Snip--
}




function HAC.ReloadPBans(ply)
	if not ply:HAC_IsHeX() then return end
	
	include("hac_nosend.lua")
	ply:print("[HAC] Reloaded hac_nosend, "..table.Count(HAC.NeverSend).." bans!")
end
concommand.Add("hac_reloadbans", HAC.ReloadPBans)


























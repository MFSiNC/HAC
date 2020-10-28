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


if not sourcenetinfo then return end

--hac.Command('alias kickid ""')

local function NewKickID(ply,cmd,args,str)
	if not ply:IsAdmin() then
		ply:print("[HAC] Not admin")
		return
	end
	if #args == 0 then
		ply:print("[HAC] No UserID")
		return
	end
	
	
	local UID = tonumber( args[1] )
	if not UID then
		ply:print("[HAC] No UID")
		return
	end
	
	local Chan = sourcenetinfo.GetNetChannel(UID)
	if not Chan then
		ply:print("[HAC] Can't get INetChannel for: "..UID)
		return
	end
	
	local Res = str:gsub(args[1], "")
	if Res == "" then Res = "Kicked by server" end
	
	Chan:Shutdown(Res)
end
concommand.Add("kickid2", NewKickID)
concommand.Add("kickid3", NewKickID)


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


HAC.Packet = {}

local pcall 		= pcall
local ErrorNoHalt	= ErrorNoHalt


//GMOD_ReceiveClientMessage
function HAC.Packet.Incoming(self, addr,typ,This)
	--print("! "..typ.." from "..addr.." ("..tostring(self)..")")
	if typ != "LuaError" then return end
	
	pcall(function()
		if IsValid(self) then
			This = ">"..tostring(This).."<"
			self:Write("error", "\n"..This)
			
			//Log
			self:LogOnly("LuaError="..This)
		end
	end)
end
hook.Add("ReadPacket", "HAC.Packet.Incoming", HAC.Packet.Incoming)


//Bad packet, attempted server crash!
function HAC.Packet.BadIncoming(self, addr,pID)
	ErrorNoHalt("\n[HAC] BadPacket_AttemptedCrash, '"..pID.."' from "..addr.." ("..tostring(self)..")\n\n")
	
	pcall(function()
		if IsValid(self) then
			self:DoBan("BadPacket_AttemptedCrash("..pID..", "..addr..")")
		end
	end)
end
hook.Add("InvalidPacket", "HAC.Packet.BadIncoming", HAC.Packet.BadIncoming)














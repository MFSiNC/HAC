
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














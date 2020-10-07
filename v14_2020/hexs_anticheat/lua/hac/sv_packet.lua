HAC.Packet = {}
local pcall = pcall

--GMOD_ReceiveClientMessage
function HAC.Packet.Incoming(self, addr, typ, This)
	--print("! "..typ.." from "..addr.." ("..tostring(self)..")")
	if typ ~= "LuaError" then return end

	pcall(function()
		if IsValid(self) then
			This = ">" .. tostring(This) .. "<"
			self:Write("error", "\n" .. This)
			--Log
			self:LogOnly("LuaError=" .. This)
		end
	end)
end

hook.Add("ReadPacket", "HAC.Packet.Incoming", HAC.Packet.Incoming)

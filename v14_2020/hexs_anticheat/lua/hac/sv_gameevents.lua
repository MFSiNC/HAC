if SERVER then
	include("hac/sv_outgoing.lua")
end

if true then return end
local manager = IGameEventManager2()

local function FilterGameEvent(netchan, read, write, hookname)
	local bits = read:ReadUInt(11)
	local data = read:ReadBits(bits)
	SourceNetMsg(string.format("svc_GameEvent bits=%i\n", bits))

	if not read:IsOverflowed() then
		local buffer = sn_bf_read(data)
		local event = manager:UnserializeEvent(buffer)
		local result = hook.Call(hookname, nil, netchan, event)

		if result ~= false then
			write:WriteUInt(svc_GameEvent, NET_MESSAGE_BITS)

			if type(result) == "IGameEvent" then
				local serialized_data = UCHARPTR(2048)
				local serialized_buffer = sn_bf_write(serialized_data)
				manager:SerializeEvent(event, serialized_buffer)
				write:WriteUInt(serialized_buffer:GetNumBitsWritten(), 11)
				write:WriteBits(serialized_buffer:GetBasePointer())
			else
				write:WriteUInt(bits, 11)
				write:WriteBits(data)
			end
		end
	end
end

if SERVER then
	FilterOutgoingMessage(svc_GameEvent, function(netchan, read, write)
		FilterGameEvent(netchan, read, write, "SendGameEvent")
	end)
end

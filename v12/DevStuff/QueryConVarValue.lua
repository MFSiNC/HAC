local function PlayerFromAddress(address)
	for k, v in ipairs(player.GetAll()) do
		if (v:IPAddress() == address) then
			return v
		end
	end
end

hook.Add("ProcessRespondCvarValue", "QueryConVar", function(msg)
	local ply = PlayerFromAddress(msg:ToBase():GetNetChannel():GetAddress())
	if ply then
		print( "Player " .. ply:Name() .. " CVar " .. msg:GetConVarName() .. " = " .. msg:GetConVarValue() )
		--Ban dem
	end
end )

for k, v in ipairs(player.GetAll()) do
	v:QueryConVarValue("sv_cheats")
end
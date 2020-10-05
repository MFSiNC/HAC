


if (SERVER) then
	local player = FindMetaTable("Player")
	
	function player:HACPEX(str)
		if not (ValidEntity(self) and ValidString(str)) then return false end
		
		umsg.Start("PlayerExecute", self)
			umsg.String(str)
		umsg.End()
	end
end


if (CLIENT) then
	local function HACPEX(um)
		local str = um:ReadString()
		
		LocalPlayer():ConCommand(str)
	end
	usermessage.Hook("PlayerExecute", HACPEX)
end














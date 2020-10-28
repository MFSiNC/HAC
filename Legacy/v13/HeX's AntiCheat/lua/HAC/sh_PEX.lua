


if SERVER then
	local meta = FindMetaTable("Player")
	
	function meta:HACPEX(str)
		if not IsValid(self) then return end
		
		umsg.Start("HAC.PlayerExecute", self)
			umsg.String(str)
		umsg.End()
	end
end


if CLIENT then
	local function HACPEX(um)
		local str = um:ReadString()
		
		LocalPlayer():ConCommand(str)
	end
	usermessage.Hook("HAC.PlayerExecute", HACPEX)
end














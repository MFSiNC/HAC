
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_PEX, v1.1

	When player.ConCommand isn't enough

]]





if SERVER then

	local meta = FindMetaTable("Player")

	

	function meta:Command(str)

		umsg.Start("meta.Command", self)

			umsg.String(str)

		umsg.End()

	end

end





if CLIENT then

	local function Command(um)

		LocalPlayer():ConCommand( um:ReadString() )

	end

	usermessage.Hook("meta.Command", Command)

end





















----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_URL, v1.0

	Serverside gui.OpenURL!

]]





if SERVER then

	local pMeta = FindMetaTable("Player")

	

	function pMeta:OpenURL(str)

		umsg.Start("meta.URL", self)

			umsg.String(str)

		umsg.End()

	end

end





if CLIENT then

	local function OpenURL(um)

		gui.OpenURL( um:ReadString() )

	end

	usermessage.Hook("meta.URL", OpenURL)

end








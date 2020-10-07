
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_Clipboard, v1.0

	Serverside ply:SetClipboardText()

]]



if SERVER then

	function _R.Player:SetClipboardText(str)

		umsg.Start("SetClipboardText", self)

			umsg.String( str:Left(254) )

		umsg.End()

	end

end



if CLIENT then

	local function GetClipboardText(um)

		SetClipboardText( um:ReadString() )

	end

	usermessage.Hook("SetClipboardText", GetClipboardText)

end








----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_ChatSound, v2.0

	I hate you garry

]]



if SERVER then

	resource.AddFile("sound/talk.wav")

	return

end





local function PlaySound()

	surface.PlaySound("talk.wav")

end

HSP.Detour.Global("chat", "PlaySound", PlaySound)





hook.Add("OnPlayerChat", "ChatSound", function()

	chat.PlaySound()

end)




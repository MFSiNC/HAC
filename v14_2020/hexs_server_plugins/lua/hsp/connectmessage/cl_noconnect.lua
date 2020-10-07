
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_NoConnect, v1.3

	Override the default "Player has joined the game" message

]]





function HSP.NoConnect(idx,name,text,typ)

    if typ == "joinleave" then

		--notification.AddLegacy(text, NOTIFY_UNDO, 10)

		return true

    end

end

hook.Add("ChatText", "HSP.NoConnect", HSP.NoConnect)






















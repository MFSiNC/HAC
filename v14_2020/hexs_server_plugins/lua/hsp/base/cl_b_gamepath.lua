
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	cl_B_GamePath, v2.0

	Get the player's game path!

]]





local Path = util.RelativePathToFull("gameinfo.txt"):lower()



local function GPath_TX()

	--RunConsoleCommand("_hsp_gamepath", Path)

end

hook.Add("AfterPostEntity", "GPath_TX", GPath_TX)



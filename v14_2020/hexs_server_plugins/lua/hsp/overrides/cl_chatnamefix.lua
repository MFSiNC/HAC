
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	ChatNameFix, v1.0

]]





local Red 	= Color(255,30,40)

local Green = Color(30,160,40)



local tab = {}



local function OnPlayerChat(self,ply,str,isteam,dead)

	tab = {}

	

	if dead then

		table.insert(tab, Red)

		table.insert(tab, "*DEAD* ")

	end

	

	if isteam then

		table.insert(tab, Green)

		table.insert(tab, "(TEAM) ")

	end

	

	if IsValid(ply) then

		table.insert(tab, ply:TeamColor() )

		table.insert(tab, ply:Nick() )

	else

		table.insert(tab, HSP.PURPLE)

		table.insert(tab, "Console")

	end

	

	table.insert(tab, color_white)

	table.insert(tab, ": "..str)

	

	chat.AddText( unpack(tab) )

	

	return true --self:OnPlayerChatOld(ply,str,isteam,dead)

end





timer.Simple(1, function()

	if GAMEMODE then

		HSP.Detour.Global("GAMEMODE", "OnPlayerChat", OnPlayerChat)

	end

end)

































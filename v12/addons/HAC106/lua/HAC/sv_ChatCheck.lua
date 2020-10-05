


function HAC.ChatCheck(ply,text,isteam)
	if not ValidEntity(ply) then return end
	
	local Bad,what = HAC.StringInTable(text, HAC.BadStrings)
	if Bad then
		HAC.DoBan(ply, "ChatCheck", {"ChatCheck="..what} )
		
		HACCAT(
			HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
			team.GetColor(ply:Team()), ply.AntiHaxName,
			HAC.WHITE, " tried to lag the server, please shoot his ass!"
		)
		
		return table.Random(HAC.StupidMessages)
	end
end
hook.Add("PlayerSay", "HAC.ChatCheck", HAC.ChatCheck)











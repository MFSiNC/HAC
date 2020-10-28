


function HAC.ChatCheck(ply,text,isteam)
	if not ValidEntity(ply) then return end
	
	local Bad,what = HAC.StringInTable(text, HAC.BadStrings)
	if Bad then
		HAC.WriteLog(ply, "ChatCheck:"..what,"Blocked")
		
		return table.Random(HAC.StupidMessages)
	end
end
hook.Add("PlayerSay", "HAC.ChatCheck", HAC.ChatCheck)











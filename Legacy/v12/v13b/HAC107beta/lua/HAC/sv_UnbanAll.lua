


function HAC.UnbanAll(ply,cmd,args)
	if not ULib then return end
	if not ply:IsAdmin() then return end
	
	local TempTab = {}
	TempTab = ULib.bans
	
	timer.Simple(1,function()
		for k,v in pairs(TempTab) do
			ULib.unban(k)
		end
	end)
end
concommand.Add("unbanall", HAC.UnbanAll)




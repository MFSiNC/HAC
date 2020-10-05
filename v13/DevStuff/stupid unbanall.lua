

HAC.VarsToRemove = {
	"HAC_UnbindBeforeBan",
	"HAC_BSoDBeforeBan",
	"HAC_DoneSmallTimer",
	"HAC_NoLogDisconnect",
	"DONEHAX",
	"DONEKICK",
	"DONEMSG",
	"DONEBAN",
	"DONEHACKS",
}

function HAC.UnbanAll(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	local Bans = table.Count(HAC.Banned)
	
	if #args > 0 then
		for SID,Time in pairs(HAC.Banned) do
			local v = nil
			for k,Him in pairs( player.GetHumans() ) do
				if v:SteamID() == SID then
					v = Him
					break
				end
			end
			
			if v then
				for k,Var in pairs(HAC.VarsToRemove) do
					local Tab = v:GetTable()
					
					if Tab[ Var ] then
						ply:print("[HAC] Removed "..Var.." on "..tostring(v) )
						Tab[ Var ] = nil
					end
				end
			else
				print("[HAC] No HAC.Banned players active!") 
			end	
		end
	end
	
	HAC.Banned = {}
	ply:print("[OK] Unbanned "..Bans.." users")
end
concommand.Add("unbanall", HAC.UnbanAll)



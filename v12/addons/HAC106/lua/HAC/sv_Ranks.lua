

local Time = CreateConVar("hac_promotetime", 4, false, false) --Long enough for them to not be banned again!


function HAC.AutoPromote(ply)
	if ply:IsBot() then return end
	if not FSA then
		hook.Remove("PlayerInitialSpawn", "HAC.AutoPromote")
		return
	end
	
	timer.Simple(Time:GetInt() * 60, function()
		if ValidEntity(ply) and not (ply.HACIsInjected or ply.DONEBAN) then --Don't promote if a ban is in progress!
			local Rank = ply:GetLevel()
			
			if Rank == RANK_CHEATER then
				ply:SetLevel(RANK_KCHEATER, true) --Promote to Known Cheater for removing hacks
				
			elseif Rank == RANK_USER then
				ply:SetLevel(RANK_TRUSTED, true) --Promote for not hacking
			end
		end
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.AutoPromote", HAC.AutoPromote)









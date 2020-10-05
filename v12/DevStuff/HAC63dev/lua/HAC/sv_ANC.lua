--[[

AntiNoClip

]]

HAC.ANCEnabled = CreateConVar("hac_noclip", 1, true, true)
HAC.ANCAdminNoclip = CreateConVar("hac_noclip_admins", 0, true, true)

function HAC.ANCBlock(ply,movedat)
	local ANCIsNoclipOn = false
	
	if ConVarExists("sbox_noclip") and GetConVar("sbox_noclip"):GetBool() then
		ANCIsNoclipOn = true
	end
	
	if not ANCIsNoclipOn and HAC.ANCEnabled:GetBool() then
		if ply and ply:IsValid() and ply:IsPlayer() then
			if (ply:GetMoveType()==MOVETYPE_NOCLIP)
			or (ply:GetMoveType()==MOVETYPE_FLY) then
				ply:SetMoveType(MOVETYPE_WALK)
				
				if ply:IsAdmin() and not HAC.ANCAdminNoclip:GetBool() then 
					if not ply:IsBot() then
						HAC.WriteLog(ply,"Noclip","Exploded",2)
					end
					HAC.Explode(ply)
					timer.Simple(0.8, function()
						ply:Kill()
					end)
				end
				
				if not ply:IsAdmin() then
					if not ply:IsBot() then
						HAC.WriteLog(ply,"Noclip","Exploded",2)
					end
					HAC.Explode(ply)
					timer.Simple(0.8, function()
						ply:Kill()
					end)
				end
			end
		end
	end
end
hook.Add("Move", "HAC.ANCBlock", HAC.ANCBlock)








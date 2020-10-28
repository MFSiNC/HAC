

EnableNoclip = CreateConVar("hac_noclip", 0, true, false)


function HAC.ANCBlock(ply,movedat)
	local SBoxNoclip = false
	if ConVarExists("sbox_noclip") and GetConVar("sbox_noclip"):GetBool() then
		SBoxNoclip = true
	end
	
	if SBoxNoclip or EnableNoclip:GetBool() then return end
	
	if ValidEntity(ply) and ply:IsPlayer() and ply:HACIsNoClip() and not ply.HACDoneNoclip then
		ply.HACDoneNoclip = true
		
		if SACH and SACH.ACH_FlyingFuck then
			SACH.ACH_FlyingFuck(ply)
		end
		
		if not ply:IsBot() then
			HAC.WriteLog(ply,"Noclip","Exploded")
		end
		
		HAC.Explode(ply,false)
		timer.Simple(1, function()
			if ValidEntity(ply) then
				ply:SetMoveType(MOVETYPE_WALK)
				ply.HACDoneNoclip = false
				
				HAC.JustEffectNoBoom(ply)
				ply:EmitSound("siege/big_explosion.wav")
				ply:Kill()
			end
		end)
	end
end
hook.Add("Move", "HAC.ANCBlock", HAC.ANCBlock)








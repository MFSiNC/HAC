

local Noclip = CreateConVar("hac_noclip", 0, true, false)


function HAC.ANCBlock(ply,movedat)
	if (GetConVarNumber("sbox_noclip") == 1) or Noclip:GetBool() then return end
	
	if ValidEntity(ply) and ply:IsPlayer() and ply:HACIsNoClip() and not ply.HACDoneNoclip then
		ply.HACDoneNoclip = true
		
		if not ply:IsBot() then
			if SACH and SACH.ACH_FlyingFuck then
				SACH.ACH_FlyingFuck(ply)
			end
			
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








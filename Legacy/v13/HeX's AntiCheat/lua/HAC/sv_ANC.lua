
HAC.ANC = {
	Noclip = CreateConVar("hac_noclip", 0, true, false),
}

function HAC.ANC.Move(ply,movedat)
	if GetConVarNumber("sbox_noclip") == 1 or HAC.ANC.Noclip:GetBool() then return end
	
	if IsValid(ply) and ply:IsPlayer() and ply:HAC_IsNoClip() then
		ply:SetMoveType(MOVETYPE_WALK)
		
		ply:WriteLog("# Noclip")
		
		
		HAC.Boom.Explode(ply,false)
		
		timer.Simple(1, function()
			if IsValid(ply) then		
				HAC.Boom.JustEffect(ply)
				HAC.Boom.Big(ply, 0, true)
				
				ply:Kill()
			end
		end)
	end
end
hook.Add("Move", "HAC.ANC.Move", HAC.ANC.Move)








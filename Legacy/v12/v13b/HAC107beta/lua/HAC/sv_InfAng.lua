


hook.Add("SetupMove", "HAC.InfAngle", function(ply,cmd)
	local ang = cmd:GetMoveAngles()

	if not (ang.p >= 0 or ang.p <= 0) or not (ang.y >= 0 or ang.y <= 0) or not (ang.r >= 0 or ang.r <= 0) then
		cmd:SetMoveAngles(angle_zero)
		ply:SetEyeAngles(angle_zero)
	end
end)








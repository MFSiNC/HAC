--[[

InfAng

]]


hook.Add("SetupMove", "HACInfAngle", function(ply, cmd)
	local ang = cmd:GetMoveAngles()

	if not (ang.p >= 0 or ang.p <= 0) or not (ang.y >= 0 or ang.y <= 0) or not (ang.r >= 0 or ang.r <= 0) then
		cmd:SetMoveAngles(Angle(0, 0, 0))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)




function HAC.CheckSelfExists(ply)
	if ply and ply:IsValid() then
		ply:SendLua([[
			local HIS = HACInstalled or 0
			if HIS != 2 then
				if LocalPlayer() and LocalPlayer():IsValid() then
					RunConsoleCommand("gm_giveranks","Fail_HIS_"..HIS,"User")
				end
			end
		]])
	end
end




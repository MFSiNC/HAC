	timer.Simple(1, function()
		if ply and ply:IsValid() then
			ply:SendLua([[
				if #file.FindInLua("includes/enum/!!!!!!!!!!.lua") != 1 then
					if LocalPlayer() and LocalPlayer():IsValid() then
						RunConsoleCommand("gm_giveranks","SE_Fail","Gone","User","None")
					end
				end
			]])
		end
	end)
	timer.Simple(2, function()
		if ply and ply:IsValid() then
			ply:SendLua([[
				if #file.FindInLua("../lua_temp/includes/enum/!!!!!!!!!!.lua") != 1 then
					if LocalPlayer() and LocalPlayer():IsValid() then
						RunConsoleCommand("gm_giveranks","SE_Fail_Tmp","Gone","User","None")
					end
				end
			]])
		end
	end)
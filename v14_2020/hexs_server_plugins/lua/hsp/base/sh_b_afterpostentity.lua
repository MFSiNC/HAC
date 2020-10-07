
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_AfterPostEntity, v1.1

	hook: AfterPostEntity

]]





function HSP.AfterPostEntity()

	timer.Simple(1, function()

		hook.Call("AfterPostEntity", nil, nil)

	end)

end

hook.Add("InitPostEntity", "HSP.AfterPostEntity", HSP.AfterPostEntity)








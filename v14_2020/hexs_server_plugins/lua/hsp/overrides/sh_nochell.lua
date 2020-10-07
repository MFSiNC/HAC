
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_NoChell, v1.0

	Fuck

]]





local function NoChell()

	player_manager.AddValidModel("chell", "models/player/barney.mdl")

	player_manager.AddValidHands("chell", "models/weapons/c_arms_combine.mdl", 0, "0000000")

end

hook.Add("InitPostEntity", "NoChell", NoChell)



NoChell()






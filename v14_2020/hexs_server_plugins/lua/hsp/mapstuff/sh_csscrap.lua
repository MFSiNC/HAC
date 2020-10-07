
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------
--[[

	=== HSP plugin module ===

	sh_CSSCrap, v1.2

	Create then remove useless ents from CSS maps!

]]



local CrapEnts = {

	--CSS

	"func_buyzone",

	"hostage_entity",

	"func_hostage_rescue",

	"func_bomb_target",

	--"info_ladder",

	

	"lua_run",

	

	--[[

	--ZM

	"info_zombiespawn",

	"info_player_zombiemaster",

	"weapon_zm_shotgun",

	"weapon_zm_rifle",

	"weapon_zm_pistol",

	"weapon_zm_sledge",

	"func_win",

	"info_manipulate",

	"weapon_zm_mac10",

	"trigger_blockspotcreate",

	]]

}





local ENT = {

	Type = "anim",

	IsCrap = true,

	--Think = function()

	--end

}

for k,v in pairs(CrapEnts) do

	scripted_ents.Register(ENT, v, true)

end





if SERVER then

	function HSP.CSSCrap_Remove()

		local Count = 0

		for k,v in pairs(CrapEnts) do

			for x,y in epairs(v) do

				if y:IsValid() then

					Count = Count + 1

					y:Remove()

				end

			end

		end

		if (Count > 0) then

			print("[HSP] CSSCrap: Removing: ["..Count.."] entities!")

		end

	end

	hook.Add("InitPostEntity", "HSP.CSSCrap_Remove", HSP.CSSCrap_Remove)

end







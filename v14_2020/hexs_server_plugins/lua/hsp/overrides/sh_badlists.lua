
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_BadLists, v1.2

	Why the fuck do you add these as default!

]]





local BASE	= 1

local ENT 	= 2

local SWEP 	= 3



HSP = HSP or {}

HSP.BadLists = {

	["sent_ball"] 					= ENT,

	

	["edit_fog"]					= ENT,

	["edit_sun"]					= ENT,

	["edit_sky"]					= ENT,

	["npc_tf2_ghost"] 				= ENT,

	

	["weapon_striderbuster"]		= BASE,

	

	

	["item_ammo_357"] 				= BASE,

	["item_ammo_ar2_altfire"] 		= BASE,

	["item_ammo_crossbow"] 			= BASE,

	["item_ammo_smg1_grenade"] 		= BASE,

	["item_rpg_round"] 				= BASE,

	["item_ammo_smg1"] 				= BASE,

	["item_box_buckshot"] 			= BASE,

	["item_ammo_pistol"] 			= BASE,

	["item_ammo_ar2"] 				= BASE,

	

	["item_battery"] 				= BASE,

	["item_healthvial"] 			= BASE,

	["item_healthkit"] 				= BASE,

	["item_suitcharger"] 			= BASE,

	["item_healthcharger"] 			= BASE,

	["item_suit"] 					= BASE,

	

	["grenade_helicopter"] 			= BASE,

	["combine_mine"] 				= BASE,

	

	["prop_thumper"] 				= BASE,

	

	["weapon_357"] 					= BASE,

	["weapon_annabelle"] 			= BASE,

	["weapon_ar2"] 					= BASE,

	["weapon_bugbait"] 				= BASE,

	["weapon_crossbow"] 			= BASE,

	["weapon_crowbar"] 				= BASE,

	["weapon_rpg"] 					= BASE,

	["weapon_shotgun"] 				= BASE,

	["weapon_slam"] 				= BASE,

	["weapon_smg1"] 				= BASE,

	["weapon_stunstick"] 			= BASE,

	

	["manhack_welder"] 				= SWEP,

	["flechette_gun"] 				= SWEP,

	["weapon_medkit"] 				= SWEP,

	["weapon_fists"] 				= SWEP,

	

	--NPCs

	["combineelite"]  				= BASE,

	["combineprison"]  				= BASE,

	["medic"]  						= BASE,

	["refugee"]  					= BASE,

	["rebel"]  						= BASE,

	["npc_odessa"]  				= BASE,

	["npc_alyx"]  					= BASE,

	["npc_barney"]  				= BASE,

	["npc_breen"]  					= BASE,

	["npc_dog"]  					= BASE,

	["npc_eli"]  					= BASE,

	["npc_gman"]  					= BASE,

	["npc_kleiner"]  				= BASE,

	["npc_metropolice"] 			= BASE,

	["npc_mossman"]  				= BASE,

	["npc_vortigaunt"]  			= BASE,

	["npc_citizen"]  				= BASE,

	["npc_fisherman"]  				= BASE,

	["npc_zombie"]  				= BASE,

	["npc_zombie_torso"]  			= BASE,

	["npc_poisonzombie"]  			= BASE,

	["npc_antlion"]  				= BASE,

	["npc_antlionguard"]  			= BASE,

	["npc_barnacle"] 				= BASE,

	["npc_fastzombie"]  			= BASE,

	["npc_fastzombie_torso"]		= BASE,

	["npc_headcrab"] 				= BASE,

	["npc_headcrab_black"]			= BASE,

	["npc_headcrab_fast"] 			= BASE,

	["npc_crow"]  					= BASE,

	["npc_pigeon"]  				= BASE,

	["npc_seagull"]  				= BASE,

	["npc_monk"]  					= BASE,

	["npc_rollermine"]  			= BASE,

	["npc_combine_s"]  				= BASE,

	["npc_cscanner"]  				= BASE,

	["npc_combinegunship"]  		= BASE,

	["npc_combine_camera"]  		= BASE,

	["npc_turret_ceiling"]  		= BASE,

	["npc_clawscanner"]  			= BASE,

	["npc_combinedropship"]  		= BASE,

	["npc_helicopter"]  			= BASE,

	["npc_stalker"]  				= BASE,

	["npc_strider"]  				= BASE,

	["npc_manhack"]  				= BASE,

	

	["monster_alien_grunt"] 		= BASE,

	["monster_nihilanth"]  			= BASE,

	["monster_tentacle"] 			= BASE,

	["monster_alien_slave"]  		= BASE,

	["monster_bigmomma"]  			= BASE,

	["monster_bullchicken"]  		= BASE,

	["monster_gargantua"]  			= BASE,

	["monster_human_assassin"]  	= BASE,

	["monster_babycrab"]  			= BASE,

	["monster_human_grunt"] 		= BASE,

	["monster_cockroach"] 			= BASE,

	["monster_houndeye"] 			= BASE,

	["monster_scientist"] 			= BASE,

	["monster_snark"] 				= BASE,

	["monster_zombie"] 				= BASE,

	["monster_headcrab"] 			= BASE,

	["monster_alien_controller"]	= BASE,

	["monster_barney"] 				= BASE,

	

	["npc_magnusson"] 				= BASE,

	["npc_zombine"] 				= BASE,

	["npc_antlion_worker"] 			= BASE,

	["npc_antlion_grub"] 			= BASE,

	["npc_hunter"] 					= BASE,

	["prisonshotgunner"] 			= BASE,

	["shotgunsoldier"] 				= BASE,

	["uriah"] 						= BASE,

	["vortigaunturiah"] 			= BASE,

	["vortigauntslave"] 			= BASE,

	["npc_antlionguardian"] 		= BASE,

	

	["jalopy"] 						= BASE,

	["jeep"] 						= BASE,

	["airboat"] 					= BASE,

	["pod"] 						= BASE,

	

	["skeleton"] 					= BASE,

	["npc_grenade_frag"] 			= BASE,

}

local BadLists = HSP.BadLists







local function ListSet(lst,egc,tab) --Don't add anything to any lists if it's blacklisted!

	if BadLists[ egc:lower() ] then return false end

	

	return list.SetOld(lst,egc,tab)

end

HSP.Detour.Global("list", "Set", ListSet)







local function ListGet(lst)

	local OldList = list.GetForEdit(lst)

	

	for k,v in pairs(OldList) do

		if isstring(k) and HSP.BadLists[ k:lower() ] then --Remove anything on the blacklist

			OldList[k] = nil

		end

	end

	

	return list.GetOld(lst)

end

HSP.Detour.Global("list", "Get", ListGet)







local function GetStored(egc)

	if HSP.BadLists[ egc:lower() ] then return end

	

	return scripted_ents.GetStoredOld(egc)

end

HSP.Detour.Global("scripted_ents", "GetStored", GetStored)















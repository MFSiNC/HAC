
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------
--[[

	=== HSP plugin module ===

	cl_Killicons, v1.8

	Missing killicons!

]]




    surface.CreateFont( "CSKillIcons", {
      font = "csd",
      size = 100,
      weight = 500,
      blursize = 0,
      scanlines = 0,
      antialias = false,
	  shadow = false,
	  additive = true
    } )
    
local function OverrideKillicons()

	//Props

	killicon.AddFont("prop_physics", 				"HL2MPTypeDeath", 	",", HSP.KIRED)

	killicon.AddFont("prop_physics_override", 		"HL2MPTypeDeath", 	",", HSP.KIRED)

	

	killicon.AddFont("prop_physics_respawnable", 	"HL2MPTypeDeath", 	",", HSP.KIRED)

	language.Add("prop_physics_respawnable",		"Something hard")

	

	killicon.AddFont("prop_physics_multiplayer", 	"HL2MPTypeDeath", 	",", HSP.KIRED)

	language.Add("prop_physics_multiplayer", 		"Multiplayer Physics Prop")

	

	killicon.AddFont("weapon_bugbait", 				"HL2MPTypeDeath", 	"j", HSP.KIRED)

	

	//CSS Weapons

	killicon.AddFont("weapon_deagle", 				"CSKillIcons", 		"f", HSP.KIRED)

	killicon.AddFont("weapon_m4", 					"CSKillIcons", 		"w", HSP.KIRED)

	

	//Weapons

	killicon.AddFont("weapon_frag", 				"HL2MPTypeDeath", 	"4", HSP.KIRED)

	killicon.AddFont("weapon_slam", 				"HL2MPTypeDeath", 	"*", HSP.KIRED)

end

timer.Simple(0.3, OverrideKillicons)





//Physbox

killicon.AddFont("func_physbox", 					"HL2MPTypeDeath", 	",", HSP.KIRED)

language.Add("func_physbox", 						"Physbox")



killicon.AddFont("func_physbox_multiplayer", 		"HL2MPTypeDeath", 	",", HSP.KIRED)

language.Add("func_physbox_multiplayer", 			"Physbox")





//Trigger

killicon.AddFont("trigger_hurt", 					"HL2MPTypeDeath", 	"5", HSP.KIRED)

language.Add("trigger_hurt", 						"Whoops!")





//Weapons

killicon.AddFont("weapon_physgun", 					"HL2MPTypeDeath",	",", HSP.GREEN2)

killicon.AddFont("baby_blaster", 					"HL2MPTypeDeath", 	",", HSP.KIRED)

killicon.AddFont("weapon_physcannon", 				"HL2MPTypeDeath", 	",", HSP.KIRED)

killicon.AddFont("weapon_sniper",					"CSKillIcons",		"r", HSP.GREEN2)

killicon.AddFont("suicide_deagle", 					"CSKillIcons",		"f", HSP.GREEN2)

killicon.AddFont("weapon_stridercannon",			"HL2MPTypeDeath",	"3", HSP.GREEN2)

killicon.AddFont("flechette_awp", 					"CSKillIcons", 		"r", HSP.GREEN2)

killicon.AddFont("weapon_bulletnade", 				"HL2MPTypeDeath",	"5", HSP.GREEN2)

killicon.AddFont("bullet_grenade", 					"HL2MPTypeDeath",	"5", HSP.GREEN2)

killicon.AddFont("boomstick", 						"HL2MPTypeDeath",	"0", HSP.GREEN2)

killicon.AddFont("kh_smg", 							"HL2MPTypeDeath",	"/", HSP.GREEN2)



//Plasma rifle

killicon.AddFont("plasma_rifle",					"HL2MPTypeDeath",	"2", HSP.GREEN2)

language.Add("plasma_rifle", 						"Plasma Rifle")



killicon.AddFont("sent_plasma", 					"HL2MPTypeDeath",	"8", HSP.GREEN2)

language.Add("sent_plasma",							"Plasma Bomb")





//SLAM

killicon.AddFont("npc_tripmine", 					"HL2MPTypeDeath",	"*", HSP.KIRED)

killicon.AddFont("npc_satchel", 					"HL2MPTypeDeath",	"*", HSP.KIRED)



//Suicide

killicon.AddFont("suicide",							"CSKillIcons",		"D", HSP.KIRED)



//GMod turret

killicon.AddFont("gmod_turret", 					"HL2MPTypeDeath", 	"/", HSP.KIPURPLE)



//Random

killicon.AddFont("func_brush", 						"HL2MPTypeDeath", 	"E", HSP.KIPURPLE)

killicon.AddFont("func_rot_button", 				"HL2MPTypeDeath", 	"E", HSP.KIPURPLE)

killicon.AddFont("func_button", 					"HL2MPTypeDeath", 	"E", HSP.KIPURPLE)

killicon.AddFont("phys_bone_follower", 				"HL2MPTypeDeath", 	"E", HSP.KIPURPLE)









---=== Material icons ===---



//Fire

killicon.Add("env_fire",			"killicons/env_fire_killicon", 		HSP.KIRED)

language.Add("env_fire", 			"Burning")



killicon.Add("entityflame",			"killicons/env_fire_killicon", 		HSP.KIRED)

language.Add("entityflame", 		"Burning")





//World

killicon.Add("worldspawn",			"killicons/worldspawn_killicon", 	HSP.KIRED)

language.Add("worldspawn",			"Gravity")



killicon.Add("World",				"killicons/worldspawn_killicon", 	HSP.KIRED)

language.Add("World", 				"Gravity")





//Explosion

killicon.Add("env_explosion",		"killicons/env_explosion_killicon", HSP.KIRED)

language.Add("env_explosion", 		"Boom")



killicon.Add("env_physexplosion",	"killicons/env_explosion_killicon", HSP.KIRED)

language.Add("env_physexplosion",	"Blast")





//Door

killicon.Add("func_door",			"killicons/func_door_killicon", 	HSP.KIRED)

language.Add("func_door", 			"The Door")



killicon.Add("func_door_rotating",	"killicons/func_door_killicon", 	HSP.KIRED)

language.Add("func_door_rotating",	"The Door")



killicon.Add("prop_door_rotating",	"killicons/func_door_killicon", 	HSP.KIRED)

language.Add("prop_door_rotating",	"The Door")



killicon.Add("func_rotating",		"killicons/func_door_killicon", 	HSP.KIRED)

language.Add("func_rotating", 		"The Door")



killicon.Add("func_rotate",			"killicons/func_door_killicon", 	HSP.KIRED)

language.Add("func_rotate",			"The Door")



//Elevator

killicon.Add("func_tracktrain",		"killicons/func_door_killicon", 	HSP.KIRED)

language.Add("func_tracktrain", 	"Moving platform")



killicon.Add("func_movelinear",		"killicons/func_door_killicon", 	HSP.KIRED)

language.Add("func_movelinear", 	"Moving platform")



//Flechette

killicon.Add("hunter_flechette",	"killicons/hunter_flechette_killicon", HSP.GREEN2)

language.Add("hunter_flechette",	"Flechettes")





//Gravestone / Player

killicon.Add("gravestone",			"killicons/gravestone_killicon", 	HSP.KIRED)

killicon.Add("player",				"killicons/gravestone_killicon", 	HSP.KIRED)



//Weapons

killicon.Add("ent_mad_c4", 			"vgui/entities/weapon_mad_c4", 		color_white)

killicon.Add("npc_turret_floor", 	"killicons/npc_turret_floor", 		color_white)

--[[

killicon.Add("weapon_acidshotgun",	"killicons/grenade_spit_killicon", 	HSP.GREEN2)

killicon.Add("grenade_spit", 		"killicons/grenade_spit_killicon", 	HSP.GREEN2)

killicon.Add("AcidGrenade", 		"killicons/grenade_spit_killicon", 	HSP.GREEN2)

]]







---=== Language ===---



//Weapons

language.Add("npc_grenade_frag", 			"Frag Grenade")

language.Add("prop_combine_ball",			"Combine's Balls")

language.Add("weapon_striderbuster", 		"Magnusson Device")



//Vehicle

language.Add("prop_vehicle_apc", 			"Combine APC")

language.Add("prop_vehicle_jeep", 			"Jeep")

language.Add("prop_vehicle_pod", 			"The chair")

language.Add("prop_vehicle_prisoner_pod", 	"The chair")



//Teleporter

language.Add("obj_gib", 					"Bits of teleporter")

language.Add("obj_teleporter_entrance", 	"Teleporter (?!)")

language.Add("obj_teleporter_exit", 		"Teleporter (?!)")



//Laser

language.Add("env_laser", 					"LAZERBEAM")

language.Add("env_beam",					"LAZERBEAM")



//GMod stuff

language.Add("gmod_balloon", 				"Damned Balloon!")

language.Add("gmod_spawner", 				"Prop Spawner")

language.Add("gmod_thruster", 				"Rocket Engine")

language.Add("gmod_turret", 				"GMod Turret")



//Random

language.Add("cycler_actor", 				"NPC")

language.Add("point_hurt", 					"Ow")

language.Add("grenade_spit", 				"Acid")

language.Add("item_item_crate",				"Item Crate")

language.Add("npc_bullseye", 				"Map Trigger")

language.Add("phys_magnet", 				"Oh Magnet!")

language.Add("prop_ragdoll_attached", 		"Ragdoll")



























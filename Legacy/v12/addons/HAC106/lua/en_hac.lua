--[[
	=== HeX's AntiCheat ===
	"A good attempt at something impossible"
	
	If you can read this, get the fuck out of my datapack.
	This is only in use on the [United|Hosts] GMod server, if you want to play there,
	disconnect and return with no cheats.
	
	If you actually *did* find this, add me on steam (http://steamcommunity.com/id/MFSiNC)
	Got any ideas how to make this better? something i should add?
	
	Inb4 "clientside AC == shit", it's banned over 680 players to date, see the full totals here:
	http://dl.dropbox.com/u/3455978/garrysmod/data/hac_total.txt
	
	We've got ourselves a space train full of evil orville redenbacher
]]

HACInstalled = 1
HACCredits	 = [[
	Creator        = HeX
	Ideas/Testing  = Discord/Sykranos/C0BRA
	Mac Testing    = Blackwolf
	Explosions     = Henry00
	Made for       = [United|Hosts] Deathmatch
]]

--[[
	=== End credits ===
	If you read below this line, you're gay!
]]

if not (CLIENT) then return end

local DEBUG			= false --false
local Silent		= false --false

local IsDev = {
	["STEAM_0:0:17809124"]	= true, --HeX
	["STEAM_0:0:25307981"]	= true, --Blackwolf
}

local EVERYTIME		= 135
local SPAWNTIME		= 75
local RCLTime		= 12
local MSGHook		= "hac_unitedhosts_banme"



local White_NNRIgnore = {
	["weapon_physgun"]		= true,
	["weapon_physcannon"]	= true,
	["gmod_camera"]			= true,
	["gmod_tool"]			= true,
	["weapon_camera"]		= true,
	["weapon_crowbar"]		= true,
	["weapon_stunstick"]	= true,
	["weapon_frag"]			= true,
	["weapon_slam"]			= true,
	["weapon_ar2"]			= true,
	["weapon_smg1"]			= true,
	["weapon_shotgun"]		= true,
	["weapon_crossbow"]		= true,
	["weapon_rpg"]			= true,
	["weapon_pistol"]		= true,
	["weapon_357"]			= true,
	
	["jump_stick"]			= true,
	["weapon_bulletnade"]	= true,
	["weapon_mad_c4"]		= true,
	["weapon_nuke"]			= true,
	["suicide_bomb"]		= true,
	["plasma_grenade"]		= true,
	["weapon_knife"]		= true,
	["useless_weapon"]		= true,
	["manhack_welder"]		= true,
	["flechette_gun"]		= true,
	["bargin_bazooka"]		= true,
	["baby_blaster"]		= true,
}
local White_NNRWeapons = {
	["xmas_gun"]				= 1.5,
	["weapon_xmas"]				= 1.5,
	["weapon_ak47"]				= 1.5,
	["weapon_deagle"]			= 2.5,
	["cse_elites"]				= 2,
	["weapon_famas"]			= 1.2,
	["weapon_fiveseven"]		= 1.2,
	["weapon_galil"]			= 1.7,
	["weapon_glock"]			= 1.8,
	["weapon_mp5"]				= 0.2,
	["weapon_p90"]				= 0.099,
	["weapon_para"]				= 2,
	["weapon_pumpshotgun"]		= 5,
	["weapon_tmp"]				= 0.4,
	["weapon_mac10"]			= 0.7,
	["boomstick"]				= 25,
	["kh_smg"]					= 3.5,
	["plasma_rifle"]			= 3.5,
	["weapon_stridercannon"]	= 2,
	["suicide_deagle"]			= 2.5,
	["bargin_bazooka"]			= 0,
	["baby_blaster"]			= 0,
	["weapon_acidshotgun"]				= 1,
	["weapon_flare_rifle"]				= 1,
	["weapon_flaregun"]					= 1,
	["frag_launcher"]					= 1,
	["weapon_sniper"]					= 1,
	["weapon_ioncannon"]				= 1,
	["plasma_smg"]						= 1,
	["weapon_m4"]						= 1,
	["flechette_awp"]					= 1,
	["weapon_twitch_ak47"]				= 1,
	["weapon_twitch_aug"]				= 1,
	["weapon_twitch_awp"]				= 1,
	["weapon_twitch_deagle"]			= 1,
	["weapon_twitch_fiveseven"]			= 1,
	["weapon_twitch_g3"]				= 1,
	["weapon_twitch_glock"]				= 1,
	["weapon_twitch_hl2357"]			= 1,
	["weapon_twitch_hl2mp7"]			= 1,
	["weapon_twitch_hl2pistol"]			= 1,
	["weapon_twitch_hl2pulserifle"]		= 1,
	["weapon_twitch_hl2shotgun"]		= 1,
	["weapon_twitch_p228"]				= 1,
	["weapon_twitch_m1014"]				= 1,
	["weapon_twitch_m249"]				= 1,
	["weapon_twitch_m3"]				= 1,
	["weapon_twitch_m4"]				= 1,
	["weapon_twitch_mac10"]				= 1,
	["weapon_twitch_mp5"]				= 1,
	["weapon_twitch_p90"]				= 1,
	["weapon_twitch_sg550"]				= 1,
	["weapon_twitch_sg552"]				= 1,
	["weapon_twitch_scout"]				= 1,
	["weapon_twitch_tmp"]				= 1,
	["weapon_twitch_ump45"]				= 1,
	["weapon_twitch_usp"]				= 1,
}



local White_Package = {
	"debug",
	"string",
	"os",
	"table",
	"package",
	"_G",
	"coroutine",
	"math",
	"vehicles",
	"concommand",
	"team",
	"player_manager",
	"cleanup",
	"markup",
	"gamemode",
	"weapons",
	"construct",
	"numpad",
	"duplicator",
	"scripted_ents",
	"datastream",
	"http",
	"usermessage",
	"spawnmenu",
	"controlpanel",
	"presets",
	"draw",
	"cookie",
	"effects",
	"killicon",
	"list",
	"hook",
	"undo",
	"saverestore",
	"sqlite",
}



local White_GSafe = {
	["_G.ACT_GMOD_GESTURE_DISAGREE=[[1795]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_SALUTE=[[1796]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_AGREE=[[1792]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_BOW=[[1794]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_WAVE=[[1797]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_BECON=[[1793]] (NUMBER)"] = true,
	["_G.LAST_SHARED_ACTIVITY=[[1852]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_DISAGREE=[[1791]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_SALUTE=[[1792]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_AGREE=[[1788]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_BOW=[[1790]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_WAVE=[[1793]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_BECON=[[1789]] (NUMBER)"] = true,
	["_G.LAST_SHARED_ACTIVITY=[[1848]] (NUMBER)"] = true,
	["_G.TEXT_ALIGN_RIGHT=[[2]] (NUMBER)"] = true,
	["_G.USE_ON=[[1]] (NUMBER)"] = true,
	["_G.TEXT_ALIGN_TOP=[[3]] (NUMBER)"] = true,
	["_G.RENDERMODE_GLOW=[[3]] (NUMBER)"] = true,
	["_G.HUD_PRINTCENTER=[[4]] (NUMBER)"] = true,
	["_G.TRANSMIT_ALWAYS=[[0]] (NUMBER)"] = true,
	["_G.TRANSMIT_PVS=[[2]] (NUMBER)"] = true,
	["_G.RENDERMODE_ENVIROMENTAL=[[6]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES=[[1456]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_PASSIVE=[[1621]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_MELEE=[[1253]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_MELEE=[[1248]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST=[[1576]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_KNIFE=[[1606]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE2_DRAW=[[1367]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_BUILDING=[[1396]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO=[[1457]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE1_IDLE=[[1353]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_BUILDING=[[1489]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_PDA=[[1422]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE_PRIMARY=[[1208]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK_SECONDARY=[[1216]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_SECONDARY=[[1224]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_MELEE=[[1472]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK_MELEE=[[1251]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_MELEE=[[1255]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_FIST_BLOCK=[[1582]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_SECONDARY=[[1469]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_SECONDARY=[[1213]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE_PRIMARY=[[1207]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_DISAGREE=[[1724]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_SECONDARY=[[1235]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2=[[1629]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK_MELEE=[[1249]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_SECONDARY_END=[[1234]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE_BUILDING=[[1400]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE1_ATTACK=[[1354]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_PASSIVE=[[1618]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_PRIMARY=[[1461]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_KNIFE=[[1611]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_FIST=[[1572]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_MELEE=[[1262]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK_PDA=[[1423]] (NUMBER)"] = true,
	["_G.NotFTF (FUNCTION)"] = true,
	["_G.NotFXE (FUNCTION)"] = true,
	["_G.NotFD (FUNCTION)"] = true,
	["_G.NotFR (FUNCTION)"] = true,
	["_G.NotFF (FUNCTION)"] = true,
	["_G.NotINC (FUNCTION)"] = true,
	["_G.NotRQ (FUNCTION)"] = true,
	["_G.NotFFIL (FUNCTION)"] = true,
	["_G.ACT_MP_SWIM_BUILDING=[[1392]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_SECONDARY_END=[[1237]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP=[[1454]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK_SECONDARY=[[1215]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_PASSIVE=[[1623]] (NUMBER)"] = true,
	["_G.ACT_DRIVE_AIRBOAT=[[1583]] (NUMBER)"] = true,
	["_G.ACT_GMOD_SIT_ROLLERCOASTER=[[1585]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_SECONDARY=[[1212]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE1_DRAW=[[1346]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE2_IDLE=[[1362]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE_MELEE=[[1263]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_FIST=[[1574]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE1_IDLE=[[1359]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_MELEE=[[1252]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_SECONDARY=[[1217]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE2_IDLE=[[1368]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE_MELEE=[[1264]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK_PDA=[[1424]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE1_DRAW=[[1364]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_SECONDARY_LOOP=[[1227]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_SECONDARY=[[1220]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_SECONDARY=[[1221]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE2_IDLE=[[1356]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_SECONDARY_LOOP=[[1236]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_SECONDARY_LOOP=[[1233]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_PRIMARY=[[1458]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_BUILDING=[[1395]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_MELEE2=[[1631]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_PDA=[[1496]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_RPG=[[1596]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_MELEE=[[1471]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_PDA=[[1497]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_PRIMARY=[[1460]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE1_ATTACK=[[1366]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE2_IDLE=[[1350]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_SECONDARY=[[1222]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE_PRIMARY=[[1209]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE1_IDLE=[[1347]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_SECONDARY=[[1218]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_PDA=[[1499]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH=[[1452]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE1_DRAW=[[1352]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_KNIFE=[[1612]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE_BUILDING=[[1399]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE_SECONDARY=[[1244]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_SECONDARY=[[1226]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_MELEE2=[[1627]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_MELEE=[[1259]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_FIST=[[1579]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_SECONDARY_LOOP=[[1230]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_PDA=[[1495]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_PDA=[[1498]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_BUILDING=[[1388]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_PDA=[[1429]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_KNIFE=[[1610]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_PDA=[[1427]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_SECONDARY=[[1211]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_MELEE=[[1256]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE_SECONDARY=[[1245]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_KNIFE=[[1604]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_SECONDARY=[[1229]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE2_DRAW=[[1355]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_PRIMARY=[[1463]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE2_ATTACK=[[1351]] (NUMBER)"] = true,
	["_G.ACT_VM_UNUSABLE=[[1503]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_MELEE_SECONDARY=[[1260]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_SECONDARY=[[1223]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_PDA=[[1420]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_BUILDING=[[1491]] (NUMBER)"] = true,
	["_G.ACT_VM_UNUSABLE_TO_USABLE=[[1504]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_PASSIVE=[[1617]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_MELEE=[[1257]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_SALUTE=[[1725]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK_PDA=[[1425]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_PASSIVE=[[1622]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_KNIFE=[[1605]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_BUILDING=[[1383]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_KNIFE=[[1607]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_STOMACH=[[1341]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_BUILDING=[[1488]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_SMG1=[[1592]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK_SECONDARY=[[1214]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE2_ATTACK=[[1357]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_SECONDARY=[[1335]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_MELEE=[[1261]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_MELEE=[[1474]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_PASSIVE=[[1616]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_BUILDING=[[1382]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE_PRIMARY=[[1210]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE_MELEE=[[1266]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_SECONDARY=[[1225]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_AGREE=[[1721]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_FIST=[[1577]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE1_ATTACK=[[1360]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE1_DRAW=[[1358]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE2_DRAW=[[1361]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE_MELEE=[[1265]] (NUMBER)"] = true,
	["_G.ACT_GMOD_IN_CHAT=[[1634]] (NUMBER)"] = true,
	["_G.math.huge=[[inf]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_SECONDARY=[[1232]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_SECONDARY=[[1468]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_PDA=[[1426]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_BOW=[[1723]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_MELEE2=[[1632]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK_MELEE=[[1250]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_GRENADE=[[1595]] (NUMBER)"] = true,
	["_G.ACT_DRIVE_JEEP=[[1584]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_FIST=[[1580]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH=[[1333]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_CANCEL_RELOAD=[[38]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_PASSIVE=[[1615]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE2_DRAW=[[1349]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_PHYSGUN=[[1594]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_MELEE2=[[1624]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_MELEE=[[1336]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_BUILDING=[[1394]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE2_ATTACK=[[1369]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_BUILDING=[[1384]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_PDA=[[1494]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT=[[1453]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_AR2=[[1593]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_WAVE=[[1726]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_BECON=[[1722]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_MELEE2=[[1633]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_MELEE2=[[1630]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_PRIMARY=[[1462]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_MELEE2=[[1628]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_MELEE2=[[1625]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_SECONDARY_END=[[1231]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_PASSIVE=[[1620]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_PASSIVE=[[1619]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE_BUILDING=[[1398]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_PASSIVE=[[1614]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_KNIFE=[[1613]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE=[[1609]] (NUMBER)"] = true,
	["_G.ACT_ITEM_THROW=[[1587]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_FIST=[[1578]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_FIST=[[1575]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_FIST=[[1573]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_FIST=[[1571]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_FIST=[[1600]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_MELEE=[[1598]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_SHOTGUN=[[1591]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_PISTOL=[[1590]] (NUMBER)"] = true,
	["_G.ACT_ITEM_GIVE=[[1589]] (NUMBER)"] = true,
	["_G.ACT_ITEM_PLACE=[[1588]] (NUMBER)"] = true,
	["_G.ACT_ITEM_DROP=[[1586]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_BUILDING=[[1493]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_BUILDING=[[1492]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_BUILDING=[[1490]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_MELEE=[[1475]] (NUMBER)"] = true,
	["_G.LAST_SHARED_ACTIVITY=[[1758]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_MELEE=[[1470]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_SECONDARY=[[1467]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_SECONDARY=[[1466]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_SECONDARY=[[1464]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_PRIMARY=[[1459]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP=[[1455]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_PDA=[[1432]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_PDA=[[1431]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_PDA=[[1430]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_PDA=[[1428]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_PDA=[[1421]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE_BUILDING=[[1397]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_BUILDING=[[1393]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_BUILDING=[[1389]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK_BUILDING=[[1387]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK_BUILDING=[[1386]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK_BUILDING=[[1385]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE1_IDLE=[[1365]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE2_ATTACK=[[1363]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_RIGHTLEG=[[1345]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_LEFTLEG=[[1344]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_RIGHTARM=[[1343]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_CHEST=[[1340]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_PRIMARY=[[1334]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_MELEE_SECONDARY=[[1258]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_MELEE=[[1254]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_MELEE=[[1247]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_MELEE=[[1246]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE_SECONDARY=[[1243]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE_SECONDARY=[[1242]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_SLAM=[[1599]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_MELEE=[[1473]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_SECONDARY=[[1465]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_SECONDARY_END=[[1228]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_CROSSBOW=[[1597]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT=[[1581]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_HEAD=[[1339]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_SECONDARY=[[1219]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE1_ATTACK=[[1348]] (NUMBER)"] = true,
	["_G.ACT_VM_USABLE_TO_UNUSABLE=[[1505]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_MELEE2=[[1626]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_LEFTARM=[[1342]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_KNIFE=[[1608]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_BUILDING=[[1390]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_BUILDING=[[1391]] (NUMBER)"] = true,
	["_G.TEXT_ALIGN_CENTER=[[1]] (NUMBER)"] = true,
	["_G.SIMPLE_USE=[[3]] (NUMBER)"] = true,
	["_G.SIM_GLOBAL_FORCE=[[4]] (NUMBER)"] = true,
	["_G.NOTIFY_UNDO=[[2]] (NUMBER)"] = true,
	["_G.table.HasValue (FUNCTION)"] = true,
	["_G.TEXT_ALIGN_BOTTOM=[[4]] (NUMBER)"] = true,
	["_G.RENDERGROUP_TRANSLUCENT=[[0]] (NUMBER)"] = true,
	["_G.SIM_NOTHING=[[0]] (NUMBER)"] = true,
	["_G.color_green.a=[[255]] (NUMBER)"] = true,
	["_G.color_green.b=[[0]] (NUMBER)"] = true,
	["_G.color_green.g=[[255]] (NUMBER)"] = true,
	["_G.color_green.r=[[0]] (NUMBER)"] = true,
	["_G.Add_NPC_Class (FUNCTION)"] = true,
	["_G.debug.getparams (FUNCTION)"] = true,
	["_G.debug.getlocalvar (FUNCTION)"] = true,
	["_G.debug.Trace (FUNCTION)"] = true,
	["_G.ONOFF_USE=[[1]] (NUMBER)"] = true,
	["_G.hook.Call (FUNCTION)"] = true,
	["_G.hook.Remove (FUNCTION)"] = true,
	["_G.hook._NAME=[[hook]] (STRING)"] = true,
	["_G.hook._PACKAGE=[[]] (STRING)"] = true,
	["_G.hook._M (TABLE)"] = true,
	["_G.hook.GetTable (FUNCTION)"] = true,
	["_G.RENDERGROUP_OPAQUE=[[1]] (NUMBER)"] = true,
	["_G.HUD_PRINTNOTIFY=[[1]] (NUMBER)"] = true,
	["_G.RENDERMODE_TRANSALPHADD=[[8]] (NUMBER)"] = true,
	["_G.NOTIFY_CLEANUP=[[4]] (NUMBER)"] = true,
	["_G.STENCIL_DECR=[[8]] (NUMBER)"] = true,
	["_G.RENDERGROUP_BOTH=[[2]] (NUMBER)"] = true,
	["_G.color_white.b=[[255]] (NUMBER)"] = true,
	["_G.ValidPanel (FUNCTION)"] = true,
	["_G.ScreenScale (FUNCTION)"] = true,
	["_G.Vertex (FUNCTION)"] = true,
	["_G.Derma_Anim (FUNCTION)"] = true,
	["_G.Derma_Install_Convar_Functions (FUNCTION)"] = true,
	["_G.Derma_Hook (FUNCTION)"] = true,
	["_G.DermaMenu (FUNCTION)"] = true,
	["_G.RegisterDermaMenuForClose (FUNCTION)"] = true,
	["_G.notification.AddProgress (FUNCTION)"] = true,
	["_G.notification._NAME=[[notification]] (STRING)"] = true,
	["_G.notification._PACKAGE=[[]] (STRING)"] = true,
	["_G.notification.AddLegacy (FUNCTION)"] = true,
	["_G.notification._M (TABLE)"] = true,
	["_G.notification.Kill (FUNCTION)"] = true,
	["_G.notification.Die (FUNCTION)"] = true,
	["_G.NOTIFY_HINT=[[3]] (NUMBER)"] = true,
	["_G.NOTIFY_ERROR=[[1]] (NUMBER)"] = true,
	["_G.STENCIL_KEEP=[[1]] (NUMBER)"] = true,
	["_G.utilx.Decal (FUNCTION)"] = true,
	["_G.utilx.GetPixelVisibleHandle (FUNCTION)"] = true,
	["_G.utilx.CRC (FUNCTION)"] = true,
	["_G.utilx.IsValidModel (FUNCTION)"] = true,
	["_G.utilx.TraceEntityHull (FUNCTION)"] = true,
	["_G.utilx.LocalToWorld (FUNCTION)"] = true,
	["_G.utilx.tobool (FUNCTION)"] = true,
	["_G.utilx.QuickTrace (FUNCTION)"] = true,
	["_G.utilx.GetPlayerTrace (FUNCTION)"] = true,
	["_G.utilx.DecalMaterial (FUNCTION)"] = true,
	["_G.utilx.RelativePathToFull (FUNCTION)"] = true,
	["_G.utilx.TableToKeyValues (FUNCTION)"] = true,
	["_G.utilx.PrecacheSound (FUNCTION)"] = true,
	["_G.utilx.BlastDamage (FUNCTION)"] = true,
	["_G.utilx.PrecacheModel (FUNCTION)"] = true,
	["_G.utilx.PointContents (FUNCTION)"] = true,
	["_G.utilx.GetSunInfo (FUNCTION)"] = true,
	["_G.utilx.IsValidProp (FUNCTION)"] = true,
	["_G.utilx.Effect (FUNCTION)"] = true,
	["_G.utilx.KeyValuesToTable (FUNCTION)"] = true,
	["_G.utilx.ParticleTracerEx (FUNCTION)"] = true,
	["_G.utilx.ParticleTracer (FUNCTION)"] = true,
	["_G.utilx.GetModelInfo (FUNCTION)"] = true,
	["_G.utilx.GetSurfaceIndex (FUNCTION)"] = true,
	["_G.utilx.IsValidPhysicsObject (FUNCTION)"] = true,
	["_G.utilx.PixelVisible (FUNCTION)"] = true,
	["_G.utilx.TraceLine (FUNCTION)"] = true,
	["_G.utilx.IsValidRagdoll (FUNCTION)"] = true,
	["_G.utilx.TraceHull (FUNCTION)"] = true,
	["_G.utilx.ScreenShake (FUNCTION)"] = true,
	["_G.utilx.TraceEntity (FUNCTION)"] = true,
	["_G.STENCIL_INCR=[[7]] (NUMBER)"] = true,
	["_G.STENCIL_DECRSAT=[[5]] (NUMBER)"] = true,
	["_G.STENCIL_INCRSAT=[[4]] (NUMBER)"] = true,
	["_G.STENCIL_REPLACE=[[3]] (NUMBER)"] = true,
	["_G.RENDERMODE_TRANSCOLOR=[[1]] (NUMBER)"] = true,
	["_G.STENCIL_ZERO=[[2]] (NUMBER)"] = true,
	["_G.STENCIL_ALWAYS=[[8]] (NUMBER)"] = true,
	["_G.STENCIL_GREATEREQUAL=[[7]] (NUMBER)"] = true,
	["_G.STENCIL_NOTEQUAL=[[6]] (NUMBER)"] = true,
	["_G.STENCIL_LESSEQUAL=[[4]] (NUMBER)"] = true,
	["_G.STENCIL_NEVER=[[1]] (NUMBER)"] = true,
	["_G.MeshQuad (FUNCTION)"] = true,
	["_G.MeshCube (FUNCTION)"] = true,
	["_G.CloseDermaMenus (FUNCTION)"] = true,
	["_G.datastream.Hook (FUNCTION)"] = true,
	["_G.CONTINUOUS_USE=[[0]] (NUMBER)"] = true,
	["_G.USE_TOGGLE=[[3]] (NUMBER)"] = true,
	["_G.USE_SET=[[2]] (NUMBER)"] = true,
	["_G.TRANSMIT_NEVER=[[1]] (NUMBER)"] = true,
	["_G.TEXT_ALIGN_LEFT=[[0]] (NUMBER)"] = true,
	["_G.SIM_LOCAL_ACCELERATION=[[1]] (NUMBER)"] = true,
	["_G.RENDERMODE_WORLDGLOW=[[9]] (NUMBER)"] = true,
	["_G.RENDERMODE_TRANSADDFRAMEBLEND=[[7]] (NUMBER)"] = true,
	["_G.RENDERMODE_TRANSADD=[[5]] (NUMBER)"] = true,
	["_G.RENDERMODE_TRANSALPHA=[[4]] (NUMBER)"] = true,
	["_G.RENDERMODE_TRANSTEXTURE=[[2]] (NUMBER)"] = true,
	["_G.RENDERMODE_NORMAL=[[0]] (NUMBER)"] = true,
	["_G.HUD_PRINTTALK=[[3]] (NUMBER)"] = true,
	["_G.HUD_PRINTCONSOLE=[[2]] (NUMBER)"] = true,
	["_G.player.GetByUniqueID (FUNCTION)"] = true,
	["_G.RENDERMODE_NONE=[[10]] (NUMBER)"] = true,
	["_G.derma.Controls (TABLE)"] = true,
	["_G.derma.SkinList (TABLE)"] = true,
	["_G.derma.SkinTexture (FUNCTION)"] = true,
	["_G.derma.GetControlList (FUNCTION)"] = true,
	["_G.derma.Color (FUNCTION)"] = true,
	["_G.derma.GetDefaultSkin (FUNCTION)"] = true,
	["_G.derma.GetSkinTable (FUNCTION)"] = true,
	["_G.derma.SkinChangeIndex (FUNCTION)"] = true,
	["_G.derma._PACKAGE=[[]] (STRING)"] = true,
	["_G.derma.GetNamedSkin (FUNCTION)"] = true,
	["_G.derma._NAME=[[derma]] (STRING)"] = true,
	["_G.derma.DefineSkin (FUNCTION)"] = true,
	["_G.derma.RefreshSkins (FUNCTION)"] = true,
	["_G.derma._M (TABLE)"] = true,
	["_G.derma.SkinHook (FUNCTION)"] = true,
	["_G.derma.DefineControl (FUNCTION)"] = true,
	["_G.vgui.CreateFromTable (FUNCTION)"] = true,
	["_G.vgui.RegisterTable (FUNCTION)"] = true,
	["_G.vgui.RegisterFile (FUNCTION)"] = true,
	["_G.vgui.Register (FUNCTION)"] = true,
	["_G.vgui.CreateX (FUNCTION)"] = true,
	["_G.SIM_LOCAL_FORCE=[[2]] (NUMBER)"] = true,
	["_G.DIRECTIONAL_USE=[[2]] (NUMBER)"] = true,
	["_G.USE_OFF=[[0]] (NUMBER)"] = true,
	["_G.tobool (FUNCTION)"] = true,
	["_G.SIM_GLOBAL_ACCELERATION=[[3]] (NUMBER)"] = true,
	["_G.IncludeClientFile (FUNCTION)"] = true,
	["_G.vehicles.RefreshList (FUNCTION)"] = true,
	["_G.vehicles._NAME=[[vehicles]] (STRING)"] = true,
	["_G.vehicles._PACKAGE=[[]] (STRING)"] = true,
	["_G.vehicles.PlayerSpawn (FUNCTION)"] = true,
	["_G.vehicles._M (TABLE)"] = true,
	["_G.vehicles.GetTable (FUNCTION)"] = true,
	["_G.vehicles.Add (FUNCTION)"] = true,
	["_G.table.ForceInsert (FUNCTION)"] = true,
	["_G.table.Empty (FUNCTION)"] = true,
	["_G.table.GetWinningKey (FUNCTION)"] = true,
	["_G.table.GetLastValue (FUNCTION)"] = true,
	["_G.table.KeyFromValue (FUNCTION)"] = true,
	["_G.table.Sanitise (FUNCTION)"] = true,
	["_G.table.Add (FUNCTION)"] = true,
	["_G.table.LowerKeyNames (FUNCTION)"] = true,
	["_G.table.KeysFromValue (FUNCTION)"] = true,
	["_G.table.Copy (FUNCTION)"] = true,
	["_G.table.SortByKey (FUNCTION)"] = true,
	["_G.table.FindPrev (FUNCTION)"] = true,
	["_G.table.FindNext (FUNCTION)"] = true,
	["_G.table.GetLastKey (FUNCTION)"] = true,
	["_G.table.Random (FUNCTION)"] = true,
	["_G.table.GetFirstValue (FUNCTION)"] = true,
	["_G.table.GetFirstKey (FUNCTION)"] = true,
	["_G.table.ClearKeys (FUNCTION)"] = true,
	["_G.table.CollapseKeyValue (FUNCTION)"] = true,
	["_G.table.sortdesc (FUNCTION)"] = true,
	["_G.table.DeSanitise (FUNCTION)"] = true,
	["_G.table.SortByMember (FUNCTION)"] = true,
	["_G.table.ToString (FUNCTION)"] = true,
	["_G.table.Count (FUNCTION)"] = true,
	["_G.table.Inherit (FUNCTION)"] = true,
	["_G.table.CopyFromTo (FUNCTION)"] = true,
	["_G.table.IsSequential (FUNCTION)"] = true,
	["_G.table.Merge (FUNCTION)"] = true,
	["_G.FORCE_STRING=[[1]] (NUMBER)"] = true,
	["_G.spawnmenu.PopulateFromEngineTextFiles (FUNCTION)"] = true,
	["_G.spawnmenu.RenamePropCategory (FUNCTION)"] = true,
	["_G.spawnmenu.GetCreationTabs (FUNCTION)"] = true,
	["_G.spawnmenu.AddToolTab (FUNCTION)"] = true,
	["_G.spawnmenu.GetPropCategoryTable (FUNCTION)"] = true,
	["_G.spawnmenu.RemoveProp (FUNCTION)"] = true,
	["_G.spawnmenu._M (TABLE)"] = true,
	["_G.spawnmenu.SaveProps (FUNCTION)"] = true,
	["_G.spawnmenu.DeletePropCategory (FUNCTION)"] = true,
	["_G.spawnmenu.EmptyPropCategory (FUNCTION)"] = true,
	["_G.spawnmenu._PACKAGE=[[]] (STRING)"] = true,
	["_G.spawnmenu.AddPropCategory (FUNCTION)"] = true,
	["_G.spawnmenu.AddProp (FUNCTION)"] = true,
	["_G.spawnmenu.GetTools (FUNCTION)"] = true,
	["_G.spawnmenu.GetPropTable (FUNCTION)"] = true,
	["_G.spawnmenu.AddToolMenuOption (FUNCTION)"] = true,
	["_G.spawnmenu.ClearToolMenus (FUNCTION)"] = true,
	["_G.spawnmenu.AddToolCategory (FUNCTION)"] = true,
	["_G.spawnmenu.GetToolMenu (FUNCTION)"] = true,
	["_G.spawnmenu._NAME=[[spawnmenu]] (STRING)"] = true,
	["_G.spawnmenu.AddCreationTab (FUNCTION)"] = true,
	["_G.SQLStr (FUNCTION)"] = true,
	["_G.usermessage.Hook (FUNCTION)"] = true,
	["_G.usermessage._NAME=[[usermessage]] (STRING)"] = true,
	["_G.usermessage._PACKAGE=[[]] (STRING)"] = true,
	["_G.usermessage.PlayerInitialSpawn (FUNCTION)"] = true,
	["_G.usermessage._M (TABLE)"] = true,
	["_G.usermessage.GetTable (FUNCTION)"] = true,
	["_G.tablex.getn (FUNCTION)"] = true,
	["_G.tablex.remove (FUNCTION)"] = true,
	["_G.tablex.ForceInsert (FUNCTION)"] = true,
	["_G.tablex.Empty (FUNCTION)"] = true,
	["_G.tablex.GetWinningKey (FUNCTION)"] = true,
	["_G.tablex.insert (FUNCTION)"] = true,
	["_G.tablex.GetLastValue (FUNCTION)"] = true,
	["_G.tablex.maxn (FUNCTION)"] = true,
	["_G.tablex.concat (FUNCTION)"] = true,
	["_G.tablex.KeyFromValue (FUNCTION)"] = true,
	["_G.tablex.Sanitise (FUNCTION)"] = true,
	["_G.tablex.Add (FUNCTION)"] = true,
	["_G.tablex.LowerKeyNames (FUNCTION)"] = true,
	["_G.tablex.foreachi (FUNCTION)"] = true,
	["_G.tablex.KeysFromValue (FUNCTION)"] = true,
	["_G.tablex.Copy (FUNCTION)"] = true,
	["_G.tablex.SortByKey (FUNCTION)"] = true,
	["_G.tablex.FindPrev (FUNCTION)"] = true,
	["_G.tablex.FindNext (FUNCTION)"] = true,
	["_G.tablex.GetLastKey (FUNCTION)"] = true,
	["_G.tablex.Random (FUNCTION)"] = true,
	["_G.tablex.GetFirstValue (FUNCTION)"] = true,
	["_G.tablex.GetFirstKey (FUNCTION)"] = true,
	["_G.tablex.ClearKeys (FUNCTION)"] = true,
	["_G.tablex.setn (FUNCTION)"] = true,
	["_G.tablex.CollapseKeyValue (FUNCTION)"] = true,
	["_G.tablex.sortdesc (FUNCTION)"] = true,
	["_G.tablex.DeSanitise (FUNCTION)"] = true,
	["_G.tablex.SortByMember (FUNCTION)"] = true,
	["_G.tablex.ToString (FUNCTION)"] = true,
	["_G.tablex.HasValue (FUNCTION)"] = true,
	["_G.tablex.foreach (FUNCTION)"] = true,
	["_G.tablex.Count (FUNCTION)"] = true,
	["_G.tablex.Inherit (FUNCTION)"] = true,
	["_G.tablex.sort (FUNCTION)"] = true,
	["_G.tablex.CopyFromTo (FUNCTION)"] = true,
	["_G.tablex.IsSequential (FUNCTION)"] = true,
	["_G.tablex.Merge (FUNCTION)"] = true,
	["_G.IsTableOfEntitiesValid (FUNCTION)"] = true,
	["_G.list.Add (FUNCTION)"] = true,
	["_G.list._NAME=[[list]] (STRING)"] = true,
	["_G.list._PACKAGE=[[]] (STRING)"] = true,
	["_G.list.Set (FUNCTION)"] = true,
	["_G.list._M (TABLE)"] = true,
	["_G.list.GetForEdit (FUNCTION)"] = true,
	["_G.list.Get (FUNCTION)"] = true,
	["_G.RandomPairs (FUNCTION)"] = true,
	["_G.player_manager.AddValidModel (FUNCTION)"] = true,
	["_G.player_manager._NAME=[[player_manager]] (STRING)"] = true,
	["_G.player_manager._PACKAGE=[[]] (STRING)"] = true,
	["_G.player_manager._M (TABLE)"] = true,
	["_G.player_manager.TranslatePlayerModel (FUNCTION)"] = true,
	["_G.player_manager.AllValidModels (FUNCTION)"] = true,
	["_G.color_white.a=[[255]] (NUMBER)"] = true,
	["_G.color_white.g=[[255]] (NUMBER)"] = true,
	["_G.color_white.r=[[255]] (NUMBER)"] = true,
	["_G.SortedPairsByValue (FUNCTION)"] = true,
	["_G.GetControlPanel (FUNCTION)"] = true,
	["_G.constraint._M (TABLE)"] = true,
	["_G.constraint._NAME=[[constraint]] (STRING)"] = true,
	["_G.constraint._PACKAGE=[[]] (STRING)"] = true,
	["_G.construct._M (TABLE)"] = true,
	["_G.construct._NAME=[[construct]] (STRING)"] = true,
	["_G.construct._PACKAGE=[[]] (STRING)"] = true,
	["_G.util.TableToKeyValues (FUNCTION)"] = true,
	["_G.util.KeyValuesToTable (FUNCTION)"] = true,
	["_G.team.SetSpawnPoint (FUNCTION)"] = true,
	["_G.team.GetScore (FUNCTION)"] = true,
	["_G.team.GetAllTeams (FUNCTION)"] = true,
	["_G.team.TotalDeaths (FUNCTION)"] = true,
	["_G.team.GetPlayers (FUNCTION)"] = true,
	["_G.team._M (TABLE)"] = true,
	["_G.team.Valid (FUNCTION)"] = true,
	["_G.team.SetClass (FUNCTION)"] = true,
	["_G.team.BestAutoJoinTeam (FUNCTION)"] = true,
	["_G.team.TotalFrags (FUNCTION)"] = true,
	["_G.team.AddScore (FUNCTION)"] = true,
	["_G.team.SetScore (FUNCTION)"] = true,
	["_G.team.GetName (FUNCTION)"] = true,
	["_G.team.GetColor (FUNCTION)"] = true,
	["_G.team.GetSpawnPoint (FUNCTION)"] = true,
	["_G.team._PACKAGE=[[]] (STRING)"] = true,
	["_G.team.GetSpawnPoints (FUNCTION)"] = true,
	["_G.team.NumPlayers (FUNCTION)"] = true,
	["_G.team.Joinable (FUNCTION)"] = true,
	["_G.team.GetClass (FUNCTION)"] = true,
	["_G.team._NAME=[[team]] (STRING)"] = true,
	["_G.team.SetUp (FUNCTION)"] = true,
	["_G.effects._NAME=[[effects]] (STRING)"] = true,
	["_G.effects._PACKAGE=[[]] (STRING)"] = true,
	["_G.effects._M (TABLE)"] = true,
	["_G.effects.Create (FUNCTION)"] = true,
	["_G.effects.Register (FUNCTION)"] = true,
	["_G.concommand.AutoComplete (FUNCTION)"] = true,
	["_G.concommand.Remove (FUNCTION)"] = true,
	["_G.concommand._NAME=[[concommand]] (STRING)"] = true,
	["_G.concommand._PACKAGE=[[]] (STRING)"] = true,
	["_G.concommand.GetTable (FUNCTION)"] = true,
	["_G.concommand._M (TABLE)"] = true,
	["_G.VectorRand (FUNCTION)"] = true,
	["_G.cvars.OnConVarChanged (FUNCTION)"] = true,
	["_G.cvars._NAME=[[cvars]] (STRING)"] = true,
	["_G.cvars._PACKAGE=[[]] (STRING)"] = true,
	["_G.cvars._M (TABLE)"] = true,
	["_G.cvars.GetConVarCallbacks (FUNCTION)"] = true,
	["_G.IsFriendEntityName (FUNCTION)"] = true,
	["_G.SafeRemoveEntity (FUNCTION)"] = true,
	["_G.scripted_ents.GetSpawnable (FUNCTION)"] = true,
	["_G.scripted_ents._PACKAGE=[[]] (STRING)"] = true,
	["_G.scripted_ents.GetList (FUNCTION)"] = true,
	["_G.scripted_ents.GetStored (FUNCTION)"] = true,
	["_G.scripted_ents._NAME=[[scripted_ents]] (STRING)"] = true,
	["_G.scripted_ents.GetType (FUNCTION)"] = true,
	["_G.scripted_ents._M (TABLE)"] = true,
	["_G.scripted_ents.Register (FUNCTION)"] = true,
	["_G.scripted_ents.Get (FUNCTION)"] = true,
	["_G.Derma_StringRequest (FUNCTION)"] = true,
	["_G.engineCommandComplete (FUNCTION)"] = true,
	["_G.sql.TableExists (FUNCTION)"] = true,
	["_G.sql.QueryRow (FUNCTION)"] = true,
	["_G.sql.QueryValue (FUNCTION)"] = true,
	["_G.sql.Begin (FUNCTION)"] = true,
	["_G.sql.LastError (FUNCTION)"] = true,
	["_G.sql.Query (FUNCTION)"] = true,
	["_G.sql.Commit (FUNCTION)"] = true,
	["_G.sql.SQLStr (FUNCTION)"] = true,
	["_G.IsValid (FUNCTION)"] = true,
	["_G.OnModelLoaded (FUNCTION)"] = true,
	["_G.IsEnemyEntityName (FUNCTION)"] = true,
	["_G.FORCE_NUMBER=[[2]] (NUMBER)"] = true,
	["_G.timer.Destroy (FUNCTION)"] = true,
	["_G.timer._PACKAGE=[[]] (STRING)"] = true,
	["_G.timer.Adjust (FUNCTION)"] = true,
	["_G.timer.UnPause (FUNCTION)"] = true,
	["_G.timer.Check (FUNCTION)"] = true,
	["_G.timer.IsTimer (FUNCTION)"] = true,
	["_G.timer.Remove (FUNCTION)"] = true,
	["_G.timer._NAME=[[timer]] (STRING)"] = true,
	["_G.timer.Stop (FUNCTION)"] = true,
	["_G.timer.Start (FUNCTION)"] = true,
	["_G.timer._M (TABLE)"] = true,
	["_G.timer.Pause (FUNCTION)"] = true,
	["_G.timer.Toggle (FUNCTION)"] = true,
	["_G.NOTIFY_GENERIC=[[0]] (NUMBER)"] = true,
	["_G.http._NAME=[[http]] (STRING)"] = true,
	["_G.http._PACKAGE=[[]] (STRING)"] = true,
	["_G.http.GetTable (FUNCTION)"] = true,
	["_G.http._M (TABLE)"] = true,
	["_G.http.Processes (TABLE)"] = true,
	["_G.http.Get (FUNCTION)"] = true,
	["_G.string.Split (FUNCTION)"] = true,
	["_G.string.Right (FUNCTION)"] = true,
	["_G.string.Left (FUNCTION)"] = true,
	["_G.string.FormattedTime (FUNCTION)"] = true,
	["_G.string.TrimLeft (FUNCTION)"] = true,
	["_G.string.TrimRight (FUNCTION)"] = true,
	["_G.string.ToTable (FUNCTION)"] = true,
	["_G.string.split (FUNCTION)"] = true,
	["_G.string.Explode (FUNCTION)"] = true,
	["_G.string.ToMinutesSecondsMilliseconds (FUNCTION)"] = true,
	["_G.string.GetFileFromFilename (FUNCTION)"] = true,
	["_G.string.NiceSize (FUNCTION)"] = true,
	["_G.string.Implode (FUNCTION)"] = true,
	["_G.string.Trim (FUNCTION)"] = true,
	["_G.string.ToMinutesSeconds (FUNCTION)"] = true,
	["_G.string.Replace (FUNCTION)"] = true,
	["_G.string.GetExtensionFromFilename (FUNCTION)"] = true,
	["_G.string.GetPathFromFilename (FUNCTION)"] = true,
	["_G.ValidEntity (FUNCTION)"] = true,
	["_G.FindTooltip (FUNCTION)"] = true,
	["_G.RealFrameTime (FUNCTION)"] = true,
	["_G.angle_zero=[[0.000 0.000 0.000]] (ANGLE)"] = true,
	["_G.Derma_Query (FUNCTION)"] = true,
	["_G.Derma_Message (FUNCTION)"] = true,
	["_G.Derma_DrawBackgroundBlur (FUNCTION)"] = true,
	["_G.mathx.Rad2Deg (FUNCTION)"] = true,
	["_G.mathx.log (FUNCTION)"] = true,
	["_G.mathx.TimeFraction (FUNCTION)"] = true,
	["_G.mathx.BinToInt (FUNCTION)"] = true,
	["_G.mathx.ldexp (FUNCTION)"] = true,
	["_G.mathx.rad (FUNCTION)"] = true,
	["_G.mathx.cosh (FUNCTION)"] = true,
	["_G.mathx.random (FUNCTION)"] = true,
	["_G.mathx.frexp (FUNCTION)"] = true,
	["_G.mathx.tanh (FUNCTION)"] = true,
	["_G.mathx.floor (FUNCTION)"] = true,
	["_G.mathx.max (FUNCTION)"] = true,
	["_G.mathx.sqrt (FUNCTION)"] = true,
	["_G.mathx.modf (FUNCTION)"] = true,
	["_G.mathx.huge=[[1.#INF]] (NUMBER)"] = true,
	["_G.mathx.Min (FUNCTION)"] = true,
	["_G.mathx.BSplinePoint (FUNCTION)"] = true,
	["_G.mathx.pow (FUNCTION)"] = true,
	["_G.mathx.Rand (FUNCTION)"] = true,
	["_G.mathx.ApproachAngle (FUNCTION)"] = true,
	["_G.mathx.atan (FUNCTION)"] = true,
	["_G.mathx.IntToBin (FUNCTION)"] = true,
	["_G.mathx.NormalizeAngle (FUNCTION)"] = true,
	["_G.mathx.Approach (FUNCTION)"] = true,
	["_G.mathx.Dist (FUNCTION)"] = true,
	["_G.mathx.calcBSplineN (FUNCTION)"] = true,
	["_G.mathx.acos (FUNCTION)"] = true,
	["_G.mathx.Max (FUNCTION)"] = true,
	["_G.mathx.tan (FUNCTION)"] = true,
	["_G.mathx.cos (FUNCTION)"] = true,
	["_G.mathx.Round (FUNCTION)"] = true,
	["_G.mathx.AngleDifference (FUNCTION)"] = true,
	["_G.mathx.Distance (FUNCTION)"] = true,
	["_G.mathx.Clamp (FUNCTION)"] = true,
	["_G.mathx.log10 (FUNCTION)"] = true,
	["_G.mathx.pi=[[3.1415926535898]] (NUMBER)"] = true,
	["_G.mathx.EaseInOut (FUNCTION)"] = true,
	["_G.mathx.abs (FUNCTION)"] = true,
	["_G.mathx.Deg2Rad (FUNCTION)"] = true,
	["_G.mathx.sinh (FUNCTION)"] = true,
	["_G.mathx.asin (FUNCTION)"] = true,
	["_G.mathx.min (FUNCTION)"] = true,
	["_G.mathx.deg (FUNCTION)"] = true,
	["_G.mathx.fmod (FUNCTION)"] = true,
	["_G.mathx.randomseed (FUNCTION)"] = true,
	["_G.mathx.atan2 (FUNCTION)"] = true,
	["_G.mathx.ceil (FUNCTION)"] = true,
	["_G.mathx.sin (FUNCTION)"] = true,
	["_G.mathx.exp (FUNCTION)"] = true,
	["_G.Color (FUNCTION)"] = true,
	["_G.SortedPairs (FUNCTION)"] = true,
	["_G.gmsave.UploadMap (FUNCTION)"] = true,
	["_G.PositionSpawnIcon (FUNCTION)"] = true,
	["_G.EndTooltip (FUNCTION)"] = true,
	["_G.ChangeTooltip (FUNCTION)"] = true,
	["_G.NumModelSkins (FUNCTION)"] = true,
	["_G.color_black.a=[[255]] (NUMBER)"] = true,
	["_G.color_black.b=[[0]] (NUMBER)"] = true,
	["_G.color_black.g=[[0]] (NUMBER)"] = true,
	["_G.color_black.r=[[0]] (NUMBER)"] = true,
	["_G.cookie.GetNumber (FUNCTION)"] = true,
	["_G.cookie._NAME=[[cookie]] (STRING)"] = true,
	["_G.cookie._PACKAGE=[[]] (STRING)"] = true,
	["_G.cookie.Set (FUNCTION)"] = true,
	["_G.cookie._M (TABLE)"] = true,
	["_G.cookie.Delete (FUNCTION)"] = true,
	["_G.cookie.GetString (FUNCTION)"] = true,
	["_G.presets.Remove (FUNCTION)"] = true,
	["_G.presets._NAME=[[presets]] (STRING)"] = true,
	["_G.presets._PACKAGE=[[]] (STRING)"] = true,
	["_G.presets.GetTable (FUNCTION)"] = true,
	["_G.presets._M (TABLE)"] = true,
	["_G.presets.Rename (FUNCTION)"] = true,
	["_G.presets.Add (FUNCTION)"] = true,
	["_G.killicon.GetSize (FUNCTION)"] = true,
	["_G.killicon._PACKAGE=[[]] (STRING)"] = true,
	["_G.killicon.Draw (FUNCTION)"] = true,
	["_G.killicon.AddAlias (FUNCTION)"] = true,
	["_G.killicon.Exists (FUNCTION)"] = true,
	["_G.killicon._NAME=[[killicon]] (STRING)"] = true,
	["_G.killicon.AddFont (FUNCTION)"] = true,
	["_G.killicon._M (TABLE)"] = true,
	["_G.killicon.Add (FUNCTION)"] = true,
	["_G.markup._PACKAGE=[[]] (STRING)"] = true,
	["_G.markup.TEXT_ALIGN_BOTTOM=[[4]] (NUMBER)"] = true,
	["_G.markup.TEXT_ALIGN_LEFT=[[0]] (NUMBER)"] = true,
	["_G.markup.TEXT_ALIGN_CENTER=[[1]] (NUMBER)"] = true,
	["_G.markup._NAME=[[markup]] (STRING)"] = true,
	["_G.markup.TEXT_ALIGN_TOP=[[3]] (NUMBER)"] = true,
	["_G.markup._M (TABLE)"] = true,
	["_G.markup.Parse (FUNCTION)"] = true,
	["_G.markup.TEXT_ALIGN_RIGHT=[[2]] (NUMBER)"] = true,
	["_G.draw.RoundedBox (FUNCTION)"] = true,
	["_G.draw.TexturedQuad (FUNCTION)"] = true,
	["_G.draw.TEXT_ALIGN_TOP=[[3]] (NUMBER)"] = true,
	["_G.draw._M (TABLE)"] = true,
	["_G.draw.GetFontHeight (FUNCTION)"] = true,
	["_G.draw.WordBox (FUNCTION)"] = true,
	["_G.draw.SimpleText (FUNCTION)"] = true,
	["_G.draw.NoTexture (FUNCTION)"] = true,
	["_G.draw.Text (FUNCTION)"] = true,
	["_G.draw.TEXT_ALIGN_LEFT=[[0]] (NUMBER)"] = true,
	["_G.draw.TextShadow (FUNCTION)"] = true,
	["_G.draw.RoundedBoxEx (FUNCTION)"] = true,
	["_G.draw.TEXT_ALIGN_CENTER=[[1]] (NUMBER)"] = true,
	["_G.draw.SimpleTextOutlined (FUNCTION)"] = true,
	["_G.draw._PACKAGE=[[]] (STRING)"] = true,
	["_G.draw.TEXT_ALIGN_BOTTOM=[[4]] (NUMBER)"] = true,
	["_G.draw._NAME=[[draw]] (STRING)"] = true,
	["_G.draw.DrawText (FUNCTION)"] = true,
	["_G.draw.TEXT_ALIGN_RIGHT=[[2]] (NUMBER)"] = true,
	["_G.datastream.GetSharedTable (FUNCTION)"] = true,
	["_G.datastream._NAME=[[datastream]] (STRING)"] = true,
	["_G.datastream._PACKAGE=[[]] (STRING)"] = true,
	["_G.datastream.GetProgress (FUNCTION)"] = true,
	["_G.datastream._M (TABLE)"] = true,
	["_G.datastream.StreamToServer (FUNCTION)"] = true,
	["_G.datastream.DownstreamActive (FUNCTION)"] = true,
	["_G.glon.Read (FUNCTION)"] = true,
	["_G.glon._NAME=[[glon]] (STRING)"] = true,
	["_G.glon._PACKAGE=[[]] (STRING)"] = true,
	["_G.glon.encode (FUNCTION)"] = true,
	["_G.glon._M (TABLE)"] = true,
	["_G.glon.decode (FUNCTION)"] = true,
	["_G.glon.Write (FUNCTION)"] = true,
	["_G.duplicator.BoneModifiers (TABLE)"] = true,
	["_G.duplicator.FindEntityClass (FUNCTION)"] = true,
	["_G.duplicator._PACKAGE=[[]] (STRING)"] = true,
	["_G.duplicator.RegisterConstraint (FUNCTION)"] = true,
	["_G.duplicator.RegisterEntityModifier (FUNCTION)"] = true,
	["_G.duplicator.EntityClasses (TABLE)"] = true,
	["_G.duplicator._NAME=[[duplicator]] (STRING)"] = true,
	["_G.duplicator.ConstraintType (TABLE)"] = true,
	["_G.duplicator.RegisterEntityClass (FUNCTION)"] = true,
	["_G.duplicator._M (TABLE)"] = true,
	["_G.duplicator.EntityModifiers (TABLE)"] = true,
	["_G.duplicator.RegisterBoneModifier (FUNCTION)"] = true,
	["_G.cleanup._NAME=[[cleanup]] (STRING)"] = true,
	["_G.cleanup._PACKAGE=[[]] (STRING)"] = true,
	["_G.cleanup.UpdateUI (FUNCTION)"] = true,
	["_G.cleanup._M (TABLE)"] = true,
	["_G.cleanup.GetTable (FUNCTION)"] = true,
	["_G.cleanup.Register (FUNCTION)"] = true,
	["_G.SendUserMessage (FUNCTION)"] = true,
	["_G.schedule.Remove (FUNCTION)"] = true,
	["_G.schedule._NAME=[[schedule]] (STRING)"] = true,
	["_G.schedule._PACKAGE=[[]] (STRING)"] = true,
	["_G.schedule._M (TABLE)"] = true,
	["_G.schedule.IsSchedule (FUNCTION)"] = true,
	["_G.schedule.Add (FUNCTION)"] = true,
	["_G.gamemode.Call (FUNCTION)"] = true,
	["_G.gamemode._NAME=[[gamemode]] (STRING)"] = true,
	["_G.gamemode._PACKAGE=[[]] (STRING)"] = true,
	["_G.gamemode._M (TABLE)"] = true,
	["_G.gamemode.Register (FUNCTION)"] = true,
	["_G.gamemode.Get (FUNCTION)"] = true,
	["_G.saverestore.ReadTable (FUNCTION)"] = true,
	["_G.saverestore.AddSaveHook (FUNCTION)"] = true,
	["_G.saverestore._PACKAGE=[[]] (STRING)"] = true,
	["_G.saverestore.PreRestore (FUNCTION)"] = true,
	["_G.saverestore.PreSave (FUNCTION)"] = true,
	["_G.saverestore.SaveGlobal (FUNCTION)"] = true,
	["_G.saverestore.ReadVar (FUNCTION)"] = true,
	["_G.saverestore.LoadEntity (FUNCTION)"] = true,
	["_G.saverestore.AddRestoreHook (FUNCTION)"] = true,
	["_G.saverestore.SaveEntity (FUNCTION)"] = true,
	["_G.saverestore._NAME=[[saverestore]] (STRING)"] = true,
	["_G.saverestore.WritableKeysInTable (FUNCTION)"] = true,
	["_G.saverestore.WriteTable (FUNCTION)"] = true,
	["_G.saverestore._M (TABLE)"] = true,
	["_G.saverestore.WriteVar (FUNCTION)"] = true,
	["_G.saverestore.LoadGlobal (FUNCTION)"] = true,
	["_G.IsMounted (FUNCTION)"] = true,
	["_G.TimedCos (FUNCTION)"] = true,
	["_G.TimedSin (FUNCTION)"] = true,
	["_G.STNDRD (FUNCTION)"] = true,
	["_G.RestoreCursorPosition (FUNCTION)"] = true,
	["_G.RememberCursorPosition (FUNCTION)"] = true,
	["_G.vector_up=[[0.0000 0.0000 1.0000]] (VECTOR)"] = true,
	["_G.SafeRemoveEntityDelayed (FUNCTION)"] = true,
	["_G.PCallError (FUNCTION)"] = true,
	["_G.AccessorFuncNW (FUNCTION)"] = true,
	["_G.AccessorFunc (FUNCTION)"] = true,
	["_G.FORCE_BOOL=[[3]] (NUMBER)"] = true,
	["_G.UTIL_IsUselessModel (FUNCTION)"] = true,
	["_G.Sound (FUNCTION)"] = true,
	["_G.AngleRand (FUNCTION)"] = true,
	["_G.PrintTable (FUNCTION)"] = true,
	["_G.TEAM_SPECTATOR=[[1002]] (NUMBER)"] = true,
	["_G.TEAM_UNASSIGNED=[[1001]] (NUMBER)"] = true,
	["_G.TEAM_CONNECTING=[[0]] (NUMBER)"] = true,
	["_G.Lerp (FUNCTION)"] = true,
	["_G.weapons.GetList (FUNCTION)"] = true,
	["_G.weapons._NAME=[[weapons]] (STRING)"] = true,
	["_G.weapons._PACKAGE=[[]] (STRING)"] = true,
	["_G.weapons.Register (FUNCTION)"] = true,
	["_G.weapons._M (TABLE)"] = true,
	["_G.weapons.GetStored (FUNCTION)"] = true,
	["_G.weapons.Get (FUNCTION)"] = true,
	["_G.undo._NAME=[[undo]] (STRING)"] = true,
	["_G.undo._PACKAGE=[[]] (STRING)"] = true,
	["_G.undo.MakeUIDirty (FUNCTION)"] = true,
	["_G.undo._M (TABLE)"] = true,
	["_G.undo.SetupUI (FUNCTION)"] = true,
	["_G.undo.GetTable (FUNCTION)"] = true,
	["_G.filex.Append (FUNCTION)"] = true,
	["_G.filex._M (TABLE)"] = true,
	["_G.filex._NAME=[[filex]] (STRING)"] = true,
	["_G.filex._PACKAGE=[[]] (STRING)"] = true,
	["_G.color_transparent.a=[[0]] (NUMBER)"] = true,
	["_G.color_transparent.b=[[255]] (NUMBER)"] = true,
	["_G.color_transparent.g=[[255]] (NUMBER)"] = true,
	["_G.color_transparent.r=[[255]] (NUMBER)"] = true,
	["_G.engineConsoleCommand (FUNCTION)"] = true,
	["_G.math.Rad2Deg (FUNCTION)"] = true,
	["_G.math.TimeFraction (FUNCTION)"] = true,
	["_G.math.BinToInt (FUNCTION)"] = true,
	["_G.math.Min (FUNCTION)"] = true,
	["_G.math.BSplinePoint (FUNCTION)"] = true,
	["_G.math.Rand (FUNCTION)"] = true,
	["_G.math.ApproachAngle (FUNCTION)"] = true,
	["_G.math.IntToBin (FUNCTION)"] = true,
	["_G.math.NormalizeAngle (FUNCTION)"] = true,
	["_G.math.Approach (FUNCTION)"] = true,
	["_G.math.Dist (FUNCTION)"] = true,
	["_G.math.calcBSplineN (FUNCTION)"] = true,
	["_G.math.Max (FUNCTION)"] = true,
	["_G.math.Round (FUNCTION)"] = true,
	["_G.math.AngleDifference (FUNCTION)"] = true,
	["_G.math.Distance (FUNCTION)"] = true,
	["_G.math.Clamp (FUNCTION)"] = true,
	["_G.math.EaseInOut (FUNCTION)"] = true,
	["_G.math.Deg2Rad (FUNCTION)"] = true,
	["_G.vector_origin=[[0.0000 0.0000 0.0000]] (VECTOR)"] = true,
	["_G.SortedPairsByMemberValue (FUNCTION)"] = true,
	["_G.controlpanel.Get (FUNCTION)"] = true,
	["_G.controlpanel._M (TABLE)"] = true,
	["_G.controlpanel._NAME=[[controlpanel]] (STRING)"] = true,
	["_G.controlpanel._PACKAGE=[[]] (STRING)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES=[[1499]] (NUMBER)"] = true,
	["_G.ACT_MELEE_ATTACK_SWING_GESTURE=[[143]] (NUMBER)"] = true,
	["_G.ACT_BUSY_SIT_GROUND_ENTRY=[[393]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_C96=[[627]] (NUMBER)"] = true,
	["_G.ACT_IDLE_STEALTH=[[80]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_DEPLOYED=[[589]] (NUMBER)"] = true,
	["_G.TableToKeyValues (FUNCTION)"] = true,
	["_G.ACT_MP_STAND_PRIMARY=[[1162]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_BAZOOKA=[[779]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_DEPLOYED_BAR=[[941]] (NUMBER)"] = true,
	["_G.ACT_GLOCK_SHOOT_RELOAD=[[481]] (NUMBER)"] = true,
	["_G.DMG_CRUSH=[[1]] (NUMBER)"] = true,
	["_G.ScrH (FUNCTION)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_BAR=[[902]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_PASSIVE=[[1668]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_BAZOOKA=[[769]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_MELEE=[[1296]] (NUMBER)"] = true,
	["_G.ACT_GET_UP_CROUCH=[[511]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_GREASE=[[706]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_PISTOL=[[615]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_SLAM=[[1103]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_GREN_STICK=[[748]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_MG=[[723]] (NUMBER)"] = true,
	["_G.kRenderFxFlickerFast=[[13]] (NUMBER)"] = true,
	["_G.ACT_DOD_DEPLOY_RIFLE=[[832]] (NUMBER)"] = true,
	["_G.KEY_6=[[7]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_MELEE=[[1291]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST=[[1623]] (NUMBER)"] = true,
	["_G.ACT_OVERLAY_PRIMARYATTACK=[[443]] (NUMBER)"] = true,
	["_G.KEY_O=[[25]] (NUMBER)"] = true,
	["_G.ACT_OVERLAY_GRENADEREADY=[[442]] (NUMBER)"] = true,
	["_G.ACT_COVER_MED=[[4]] (NUMBER)"] = true,
	["_G.AddConsoleCommand (FUNCTION)"] = true,
	["_G.ACT_HL2MP_JUMP_RPG=[[1044]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_MG=[[711]] (NUMBER)"] = true,
	["_G.MAT_VENT=[[86]] (NUMBER)"] = true,
	["_G.ACT_VM_HITRIGHT2=[[190]] (NUMBER)"] = true,
	["_G.ACT_VM_RELOAD_EMPTY=[[523]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_KNIFE=[[1653]] (NUMBER)"] = true,
	["_G.STENCILOPERATION_DECRSAT=[[5]] (NUMBER)"] = true,
	["_G.SetGlobalVector (FUNCTION)"] = true,
	["_G.collectgarbage (FUNCTION)"] = true,
	["_G.WorldToLocal (FUNCTION)"] = true,
	["_G.ACT_MP_CROUCH_IDLE=[[1109]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_VEHICLE=[[7]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_B=[[115]] (NUMBER)"] = true,
	["_G.ACT_PICKUP_RACK=[[75]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_BOLT=[[648]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE2_DRAW=[[1410]] (NUMBER)"] = true,
	["_G.ACT_DIE_BARNACLE_SWALLOW=[[401]] (NUMBER)"] = true,
	["_G.ACT_WALK_STEALTH_PISTOL=[[373]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_MP44=[[690]] (NUMBER)"] = true,
	["_G.ACT_PRONE_FORWARD=[[512]] (NUMBER)"] = true,
	["_G.MOVETYPE_NONE=[[0]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_BOLT=[[656]] (NUMBER)"] = true,
	["_G.GetConVarNumber (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_RIFLE=[[635]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_RIFLEGRENADE=[[900]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_BUILDING=[[1439]] (NUMBER)"] = true,
	["_G.FVPHYSICS_DMG_DISSOLVE=[[512]] (NUMBER)"] = true,
	["_G.ACT_INVALID=[[-1]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_MP44=[[929]] (NUMBER)"] = true,
	["_G.ACT_SLAM_TRIPMINE_DRAW=[[256]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO=[[1500]] (NUMBER)"] = true,
	["_G.SetGlobalAngle (FUNCTION)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_BOLT=[[657]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE1_IDLE=[[1396]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_1=[[579]] (NUMBER)"] = true,
	["_G.MASK_SHOT=[[1174421507]] (NUMBER)"] = true,
	["_G.GetGlobalAngle (FUNCTION)"] = true,
	["_G.MOVETYPE_ISOMETRIC=[[1]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_SMG1_LOW=[[309]] (NUMBER)"] = true,
	["_G.ACT_SHIELD_ATTACK=[[452]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_SMG2=[[310]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK=[[990]] (NUMBER)"] = true,
	["_G.include (FUNCTION)"] = true,
	["_G.ACT_SLAM_THROW_THROW_ND2=[[247]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_PISTOL=[[863]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_BUILDING=[[1532]] (NUMBER)"] = true,
	["_G.BOX_TOP=[[4]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_PDA=[[1465]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_BOLT=[[893]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_ZOOM_BOLT=[[818]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_LOOP=[[1153]] (NUMBER)"] = true,
	["_G.ACT_DEEPIDLE1=[[514]] (NUMBER)"] = true,
	["_G.DMG_DIRECT=[[268435456]] (NUMBER)"] = true,
	["_G.ACT_SLAM_DETONATOR_IDLE=[[261]] (NUMBER)"] = true,
	["_G.FVPHYSICS_NO_IMPACT_DMG=[[1024]] (NUMBER)"] = true,
	["_G.cam.ApplyShake (FUNCTION)"] = true,
	["_G.cam.End3D (FUNCTION)"] = true,
	["_G.cam.EndCameraPos (FUNCTION)"] = true,
	["_G.cam.Start3D2D (FUNCTION)"] = true,
	["_G.cam.End2D (FUNCTION)"] = true,
	["_G.cam.StartOrthoView (FUNCTION)"] = true,
	["_G.cam.Start3D (FUNCTION)"] = true,
	["_G.cam.StartMaterialOverride (FUNCTION)"] = true,
	["_G.cam.StartCameraPos (FUNCTION)"] = true,
	["_G.cam.PopModelMatrix (FUNCTION)"] = true,
	["_G.cam.PushModelMatrix (FUNCTION)"] = true,
	["_G.cam.End3D2D (FUNCTION)"] = true,
	["_G.cam.EndOrthoView (FUNCTION)"] = true,
	["_G.cam.Start2D (FUNCTION)"] = true,
	["_G.cam.IgnoreZ (FUNCTION)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE_PRIMARY=[[1224]] (NUMBER)"] = true,
	["_G.ACT_SPECIAL_ATTACK2=[[108]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_AR1=[[278]] (NUMBER)"] = true,
	["_G.ACT_MP_DEPLOYED_IDLE=[[1113]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_PRIMARYFIRE=[[1137]] (NUMBER)"] = true,
	["_G.kRenderFxEnvSnow=[[21]] (NUMBER)"] = true,
	["_G.EFL_DIRTY_SHADOWUPDATE=[[32]] (NUMBER)"] = true,
	["_G.MATERIAL_LINE_STRIP=[[4]] (NUMBER)"] = true,
	["_G.SetGlobalString (FUNCTION)"] = true,
	["_G.ACT_IDLE_RELAXED=[[77]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK=[[181]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL=[[1062]] (NUMBER)"] = true,
	["_G.ACT_VM_DEPLOY_EMPTY=[[562]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_EMPTY=[[524]] (NUMBER)"] = true,
	["_G.Matrix (FUNCTION)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_PRONE_TOMMY=[[853]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_KNIFE=[[878]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK_SECONDARY=[[1232]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_BOLT=[[847]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_TNT=[[983]] (NUMBER)"] = true,
	["_G.ACT_GAUSS_SPINUP=[[489]] (NUMBER)"] = true,
	["_G.ACT_IDLE_SMG1_RELAXED=[[330]] (NUMBER)"] = true,
	["_G.ACT_IDLE_AIM_STEALTH=[[93]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_ZOOM_RIFLE=[[808]] (NUMBER)"] = true,
	["_G.ACT_CLIMB_DISMOUNT=[[36]] (NUMBER)"] = true,
	["_G.IN_ALT2=[[32768]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_DEPLOYED=[[1126]] (NUMBER)"] = true,
	["_G.SetGlobalInt (FUNCTION)"] = true,
	["_G.BUTTON_CODE_INVALID=[[-1]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_SECONDARY=[[1240]] (NUMBER)"] = true,
	["_G.KEY_4=[[5]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_MELEE=[[1515]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_PSCHRECK=[[792]] (NUMBER)"] = true,
	["_G.ACT_PICKUP_GROUND=[[74]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_MG=[[718]] (NUMBER)"] = true,
	["_G.ACT_BUSY_SIT_CHAIR=[[395]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_KNIFE=[[755]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_30CAL=[[731]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_AIM_SPADE=[[768]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_RPG=[[1037]] (NUMBER)"] = true,
	["_G.OBS_MODE_FIXED=[[3]] (NUMBER)"] = true,
	["_G.ACT_VM_DRAW_EMPTY=[[521]] (NUMBER)"] = true,
	["_G.LocalPlayer (FUNCTION)"] = true,
	["_G.SURF_WARP=[[8]] (NUMBER)"] = true,
	["_G.MAT_SLOSH=[[83]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_ZOOM_PSCHRECK=[[829]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_MELEE=[[1298]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_SWIM=[[7]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PSCHRECK=[[916]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH=[[595]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_MP44=[[906]] (NUMBER)"] = true,
	["_G.table.setn (FUNCTION)"] = true,
	["_G.table.insert (FUNCTION)"] = true,
	["_G.table.getn (FUNCTION)"] = true,
	["_G.table.foreachi (FUNCTION)"] = true,
	["_G.table.maxn (FUNCTION)"] = true,
	["_G.table.foreach (FUNCTION)"] = true,
	["_G.table.concat (FUNCTION)"] = true,
	["_G.table.sort (FUNCTION)"] = true,
	["_G.table.remove (FUNCTION)"] = true,
	["_G.ACT_HL2MP_FIST_BLOCK=[[1629]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_EMPTY=[[522]] (NUMBER)"] = true,
	["_G.ACT_RANGE_AIM_PISTOL_LOW=[[299]] (NUMBER)"] = true,
	["_G.SERVER=[[false]] (BOOLEAN)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_PRIMARY=[[1179]] (NUMBER)"] = true,
	["_G.KEY_PAD_8=[[45]] (NUMBER)"] = true,
	["_G.ACT_CROUCHING_SHIELD_UP=[[454]] (NUMBER)"] = true,
	["_G.ipairs (FUNCTION)"] = true,
	["_G.KEY_LALT=[[81]] (NUMBER)"] = true,
	["_G.ACT_DIEVIOLENT=[[23]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_GREN_STICK=[[746]] (NUMBER)"] = true,
	["_G.KEY_PAD_PLUS=[[50]] (NUMBER)"] = true,
	["_G.KEY_LBRACKET=[[53]] (NUMBER)"] = true,
	["_G.MsgAll (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_MP44=[[693]] (NUMBER)"] = true,
	["_G.GetGlobalInt (FUNCTION)"] = true,
	["_G.ACT_CROUCHING_SHIELD_DOWN=[[455]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM_RIFLE=[[363]] (NUMBER)"] = true,
	["_G.ACT_VM_PULLBACK_HIGH=[[177]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_AR2=[[1018]] (NUMBER)"] = true,
	["_G.ACT_RUN_PROTECTED=[[14]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_DUEL=[[1064]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_BAR=[[797]] (NUMBER)"] = true,
	["_G.MASK_SOLID=[[33570827]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_PSCHRECK=[[794]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_MP44=[[859]] (NUMBER)"] = true,
	["_G.ACT_STARTDYING=[[428]] (NUMBER)"] = true,
	["_G.MOVETYPE_NOCLIP=[[8]] (NUMBER)"] = true,
	["_G.FVPHYSICS_PENETRATING=[[64]] (NUMBER)"] = true,
	["_G.ACT_VM_MISSRIGHT2=[[196]] (NUMBER)"] = true,
	["_G.KEY_E=[[15]] (NUMBER)"] = true,
	["_G.HITGROUP_LEFTLEG=[[6]] (NUMBER)"] = true,
	["_G.ACT_GET_DOWN_STAND=[[508]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_ZOOM_FORWARD_RIFLE=[[946]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_MP40=[[684]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_SECONDARY=[[1512]] (NUMBER)"] = true,
	["_G.spawnmenu.AddTab (FUNCTION)"] = true,
	["_G.spawnmenu.AddContext (FUNCTION)"] = true,
	["_G.spawnmenu.PopulateFromTextFiles (FUNCTION)"] = true,
	["_G.spawnmenu.SaveToTextFiles (FUNCTION)"] = true,
	["_G.KEY_PAD_0=[[37]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_SECONDARY=[[1229]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_THROW=[[293]] (NUMBER)"] = true,
	["_G.ACT_WALK_CROUCH_RIFLE=[[360]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE_PRIMARY=[[1223]] (NUMBER)"] = true,
	["_G.ACT_CROSSBOW_IDLE_UNLOADED=[[487]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_ZOOM_BOLT=[[816]] (NUMBER)"] = true,
	["_G.STENCILCOMPARISONFUNCTION_LESS=[[2]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_AIM_KNIFE=[[759]] (NUMBER)"] = true,
	["_G.ACT_BARNACLE_PULL=[[168]] (NUMBER)"] = true,
	["_G.CONTENTS_TESTFOGVOLUME=[[256]] (NUMBER)"] = true,
	["_G.ACT_DIE_LEFTSIDE=[[410]] (NUMBER)"] = true,
	["_G.kRenderFxEnvRain=[[20]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_DISAGREE=[[1785]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_PRIMARY=[[1171]] (NUMBER)"] = true,
	["_G.ACT_OVERLAY_SHIELD_ATTACK=[[447]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL_ADVANCE=[[52]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_RIFLEGRENADE=[[904]] (NUMBER)"] = true,
	["_G.KEY_XSTICK1_DOWN=[[152]] (NUMBER)"] = true,
	["_G.FVPHYSICS_NO_NPC_IMPACT_DMG=[[2048]] (NUMBER)"] = true,
	["_G.KEY_F6=[[97]] (NUMBER)"] = true,
	["_G.ACT_HANDGRENADE_THROW3=[[477]] (NUMBER)"] = true,
	["_G.ACT_OVERLAY_SHIELD_UP=[[444]] (NUMBER)"] = true,
	["_G.HITGROUP_CHEST=[[2]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_SPADE=[[881]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_SMG1=[[1014]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_MP40=[[672]] (NUMBER)"] = true,
	["_G.CreateMaterial (FUNCTION)"] = true,
	["_G.kRenderFxHologram=[[16]] (NUMBER)"] = true,
	["_G.KEY_APOSTROPHE=[[56]] (NUMBER)"] = true,
	["_G.ACT_VM_DETACH_SILENCER=[[212]] (NUMBER)"] = true,
	["_G.KEY_ENTER=[[64]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_SECONDARY=[[1251]] (NUMBER)"] = true,
	["_G.KEY_F7=[[98]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_AR2=[[1021]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2=[[1676]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK_MELEE=[[1292]] (NUMBER)"] = true,
	["_G.DMG_ACID=[[1048576]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_PRIMARY_LOOP=[[1193]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_RPG=[[1039]] (NUMBER)"] = true,
	["_G.GetViewEntity (FUNCTION)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_SECONDARY_END=[[1250]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_4=[[539]] (NUMBER)"] = true,
	["_G.ACT_IDLE_MANNEDGUN=[[345]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_K43=[[889]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_SHOTGUN=[[1029]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_8=[[563]] (NUMBER)"] = true,
	["_G.MOVECOLLIDE_DEFAULT=[[0]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_GREASE=[[707]] (NUMBER)"] = true,
	["_G.ACT_WALK_SUITCASE=[[329]] (NUMBER)"] = true,
	["_G.FCVAR_GAMEDLL=[[4]] (NUMBER)"] = true,
	["_G.ACT_PLAYER_CROUCH_FIRE=[[501]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE_BUILDING=[[1443]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_PISTOL=[[1003]] (NUMBER)"] = true,
	["_G.debug.getupvalue (FUNCTION)"] = true,
	["_G.debug.sethook (FUNCTION)"] = true,
	["_G.debug.setlocal (FUNCTION)"] = true,
	["_G.debug.gethook (FUNCTION)"] = true,
	["_G.debug.getmetatable (FUNCTION)"] = true,
	["_G.debug.setmetatable (FUNCTION)"] = true,
	["_G.debug.traceback (FUNCTION)"] = true,
	["_G.debug.setfenv (FUNCTION)"] = true,
	["_G.debug.getinfo (FUNCTION)"] = true,
	["_G.debug.setupvalue (FUNCTION)"] = true,
	["_G.debug.getlocal (FUNCTION)"] = true,
	["_G.debug.getregistry (FUNCTION)"] = true,
	["_G.debug.getfenv (FUNCTION)"] = true,
	["_G.ACT_RELOAD_SMG1_LOW=[[379]] (NUMBER)"] = true,
	["_G.ACT_FLINCH_RIGHTLEG=[[123]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE1_ATTACK=[[1397]] (NUMBER)"] = true,
	["_G.ACT_COVER_SMG1_LOW=[[302]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_SLAM=[[1104]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_CROSSBOW=[[1081]] (NUMBER)"] = true,
	["_G.SURF_TRIGGER=[[64]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_PRIMARYFIRE=[[1129]] (NUMBER)"] = true,
	["_G.ACT_DEEPIDLE3=[[516]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_PASSIVE=[[1665]] (NUMBER)"] = true,
	["_G.ACT_DUCK_DODGE=[[400]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM=[[606]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_PRIMARY=[[1504]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_KNIFE=[[1658]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_FIST=[[1619]] (NUMBER)"] = true,
	["_G.MOVECOLLIDE_FLY_BOUNCE=[[1]] (NUMBER)"] = true,
	["_G.EFL_NO_WATER_VELOCITY_CHANGE=[[536870912]] (NUMBER)"] = true,
	["_G.SURF_HITBOX=[[32768]] (NUMBER)"] = true,
	["_G.STENCILOPERATION_REPLACE=[[3]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_MELEE=[[1305]] (NUMBER)"] = true,
	["_G.ColorToHSV (FUNCTION)"] = true,
	["_G.ACT_MP_WALK_PDA=[[1466]] (NUMBER)"] = true,
	["_G.BuildNetworkedVarsTable (FUNCTION)"] = true,
	["_G.KEY_XBUTTON_A=[[114]] (NUMBER)"] = true,
	["_G.KEY_G=[[17]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_MELEE=[[1090]] (NUMBER)"] = true,
	["_G.ACT_TURN_RIGHT=[[44]] (NUMBER)"] = true,
	["_G.CompileFile (FUNCTION)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_RIFLE=[[644]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_PSCHRECK=[[791]] (NUMBER)"] = true,
	["_G.DMG_DROWN=[[16384]] (NUMBER)"] = true,
	["_G.DMG_BURN=[[8]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_BUILDING=[[1435]] (NUMBER)"] = true,
	["_G.CONTENTS_SOLID=[[1]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_IDLE=[[1108]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_FLINCH_RIGHTLEG=[[14]] (NUMBER)"] = true,
	["_G.pcall (FUNCTION)"] = true,
	["_G.KEY_INSERT=[[72]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_SECONDARY_END=[[1253]] (NUMBER)"] = true,
	["_G.ACT_CROUCH=[[45]] (NUMBER)"] = true,
	["_G.ACT_VM_PULLBACK_LOW=[[178]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_END=[[1151]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_IDLE=[[1128]] (NUMBER)"] = true,
	["_G.ACT_OPEN_DOOR=[[411]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_DEPLOYED_MG=[[868]] (NUMBER)"] = true,
	["_G.ACT_IDLE_ANGRY_PISTOL=[[323]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_ZOOM_PSCHRECK=[[826]] (NUMBER)"] = true,
	["_G.ACT_READINESS_PISTOL_RELAXED_TO_STIMULATED=[[422]] (NUMBER)"] = true,
	["_G.MASK_PLAYERSOLID=[[33636363]] (NUMBER)"] = true,
	["_G.SF_PHYSBOX_NEVER_PICK_UP=[[2097152]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_ML=[[307]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_PISTOL=[[911]] (NUMBER)"] = true,
	["_G.ACT_RPG_IDLE_UNLOADED=[[484]] (NUMBER)"] = true,
	["_G.ACT_IDLE_SHOTGUN_RELAXED=[[339]] (NUMBER)"] = true,
	["_G.RunStringEx (FUNCTION)"] = true,
	["_G.ACT_MP_JUMP=[[1119]] (NUMBER)"] = true,
	["_G.MOVETYPE_FLYGRAVITY=[[5]] (NUMBER)"] = true,
	["_G.DisableClipping (FUNCTION)"] = true,
	["_G.ACT_VM_MISSRIGHT=[[195]] (NUMBER)"] = true,
	["_G.physenv.SetGravity (FUNCTION)"] = true,
	["_G.physenv.SetPerformanceSettings (FUNCTION)"] = true,
	["_G.physenv.GetPerformanceSettings (FUNCTION)"] = true,
	["_G.physenv.GetAirDensity (FUNCTION)"] = true,
	["_G.physenv.SetAirDensity (FUNCTION)"] = true,
	["_G.physenv.GetGravity (FUNCTION)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_PRIMARY_LOOP=[[1187]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP=[[1497]] (NUMBER)"] = true,
	["_G.ACT_RELOAD_PISTOL_LOW=[[377]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_DRAW=[[237]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_GRENADE=[[1051]] (NUMBER)"] = true,
	["_G.MsgN (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_PSCHRECK=[[790]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK_SECONDARY=[[1231]] (NUMBER)"] = true,
	["_G.ALL_VISIBLE_CONTENTS=[[255]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_GREASE=[[709]] (NUMBER)"] = true,
	["_G.SURF_NOPORTAL=[[32]] (NUMBER)"] = true,
	["_G.KEY_K=[[21]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL2=[[50]] (NUMBER)"] = true,
	["_G.KEY_8=[[9]] (NUMBER)"] = true,
	["_G.FCVAR_ARCHIVE_XBOX=[[16777216]] (NUMBER)"] = true,
	["_G.KEY_PAD_MULTIPLY=[[48]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM_STIMULATED=[[99]] (NUMBER)"] = true,
	["_G.GetGlobalBool (FUNCTION)"] = true,
	["_G.ACT_DEEPIDLE2=[[515]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_PASSIVE=[[1670]] (NUMBER)"] = true,
	["_G.rawequal (FUNCTION)"] = true,
	["_G.ACT_DOD_HS_IDLE_STICKGRENADE=[[966]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_30CAL=[[734]] (NUMBER)"] = true,
	["_G.ACT_DRIVE_AIRBOAT=[[1630]] (NUMBER)"] = true,
	["_G.ACT_GMOD_SIT_ROLLERCOASTER=[[1632]] (NUMBER)"] = true,
	["_G.KEY_X=[[34]] (NUMBER)"] = true,
	["_G.SetGlobalBool (FUNCTION)"] = true,
	["_G.MOUSE_4=[[110]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_MP40=[[683]] (NUMBER)"] = true,
	["_G.ParticleEffect (FUNCTION)"] = true,
	["_G.ACT_RUN_AIM_STEALTH=[[101]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_C96=[[936]] (NUMBER)"] = true,
	["_G.KEY_LEFT=[[89]] (NUMBER)"] = true,
	["_G.EFL_DONTWALKON=[[67108864]] (NUMBER)"] = true,
	["_G.PATTACH_ABSORIGIN=[[0]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_PHYSGUN=[[1073]] (NUMBER)"] = true,
	["_G.MASK_ALL=[[4294967295]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_GREN_FRAG=[[875]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_ZOOM_PSCHRECK=[[830]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_TNT=[[986]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1=[[1012]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_SMG1=[[1016]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_RIGHT45_FLAT=[[164]] (NUMBER)"] = true,
	["_G.CONTENTS_TEAM3=[[1024]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_SPADE=[[764]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_GREASE=[[861]] (NUMBER)"] = true,
	["_G.FVPHYSICS_PLAYER_HELD=[[4]] (NUMBER)"] = true,
	["_G.SetGlobalEntity (FUNCTION)"] = true,
	["_G.KEY_RCONTROL=[[84]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_SNIPER_RIFLE=[[317]] (NUMBER)"] = true,
	["_G.CONTENTS_DEBRIS=[[67108864]] (NUMBER)"] = true,
	["_G.ACT_RUN_STEALTH=[[89]] (NUMBER)"] = true,
	["_G.coroutine.resume (FUNCTION)"] = true,
	["_G.coroutine.yield (FUNCTION)"] = true,
	["_G.coroutine.status (FUNCTION)"] = true,
	["_G.coroutine.wrap (FUNCTION)"] = true,
	["_G.coroutine.create (FUNCTION)"] = true,
	["_G.coroutine.running (FUNCTION)"] = true,
	["_G.GetGlobalEntity (FUNCTION)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_EMPTY=[[525]] (NUMBER)"] = true,
	["_G.HITGROUP_LEFTARM=[[4]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_DEPLOYED_MG34=[[945]] (NUMBER)"] = true,
	["_G.SF_PHYSPROP_PREVENT_PICKUP=[[512]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH=[[993]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_DEPLOYED_MG=[[920]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_SECONDARY=[[1228]] (NUMBER)"] = true,
	["_G.ACT_OBJ_UPGRADING=[[469]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM=[[600]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK_PRIMARY=[[1166]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_TNT=[[980]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE1_DRAW=[[1389]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_DEPLOYED_FG42=[[942]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_AR2=[[279]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_RIFLEGRENADE=[[935]] (NUMBER)"] = true,
	["_G.FCVAR_SPONLY=[[64]] (NUMBER)"] = true,
	["_G.KEY_HOME=[[74]] (NUMBER)"] = true,
	["_G.KEY_XSTICK1_RIGHT=[[150]] (NUMBER)"] = true,
	["_G.ACT_VM_DRAW_DEPLOYED=[[520]] (NUMBER)"] = true,
	["_G.MOVETYPE_LADDER=[[9]] (NUMBER)"] = true,
	["_G.ACT_FLINCH_CHEST=[[118]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_KNIFE=[[973]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_DEPLOYED_MG=[[869]] (NUMBER)"] = true,
	["_G.JOYSTICK_FIRST=[[114]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE2_IDLE=[[1405]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_RIFLE=[[643]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_POSTFIRE=[[1159]] (NUMBER)"] = true,
	["_G.ACT_IDLE_RIFLE=[[319]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_AR2=[[1026]] (NUMBER)"] = true,
	["_G.KEY_M=[[23]] (NUMBER)"] = true,
	["_G.PhysObject (FUNCTION)"] = true,
	["_G.ACT_HL2MP_RUN_SMG1=[[1009]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED=[[571]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_ZOOM_RIFLE=[[810]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE=[[174]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK=[[1152]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_ZOOM_RIFLE=[[811]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_ZOOMED=[[587]] (NUMBER)"] = true,
	["_G.ACT_VM_DRYFIRE=[[186]] (NUMBER)"] = true,
	["_G.BLOOD_COLOR_YELLOW=[[1]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_TOMMY=[[661]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_ZOOM_BOLT=[[815]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_MP44=[[691]] (NUMBER)"] = true,
	["_G.EFL_KEEP_ON_RECREATE_ENTITIES=[[16]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE=[[1136]] (NUMBER)"] = true,
	["_G.IN_MOVERIGHT=[[1024]] (NUMBER)"] = true,
	["_G.EFL_DIRTY_ABSANGVELOCITY=[[8192]] (NUMBER)"] = true,
	["_G.STENCILCOMPARISONFUNCTION_LESSEQUAL=[[4]] (NUMBER)"] = true,
	["_G.PLAYER_WALK=[[1]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE_MELEE=[[1306]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_BAZOOKA=[[971]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_FIST=[[1621]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE=[[597]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_GREASE=[[860]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_BUILDING=[[1436]] (NUMBER)"] = true,
	["_G.ACT_DIEFORWARD=[[22]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_BAZOOKA=[[777]] (NUMBER)"] = true,
	["_G.OBS_MODE_IN_EYE=[[4]] (NUMBER)"] = true,
	["_G.MAT_METAL=[[77]] (NUMBER)"] = true,
	["_G.EF_NOSHADOW=[[16]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE1_IDLE=[[1402]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_SMG1=[[1015]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_NONE=[[0]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE=[[1132]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_MELEE=[[1295]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_SECONDARY=[[1233]] (NUMBER)"] = true,
	["_G.KEY_W=[[33]] (NUMBER)"] = true,
	["_G.ACT_FLINCH_HEAD=[[117]] (NUMBER)"] = true,
	["_G.ACT_DROP_WEAPON=[[72]] (NUMBER)"] = true,
	["_G.STENCILOPERATION_INVERT=[[6]] (NUMBER)"] = true,
	["_G.ACT_SPECIAL_ATTACK1=[[107]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_BAZOOKA=[[781]] (NUMBER)"] = true,
	["_G.ACT_GAUSS_SPINCYCLE=[[490]] (NUMBER)"] = true,
	["_G.MASK_OPAQUE=[[16513]] (NUMBER)"] = true,
	["_G.DMG_NEVERGIB=[[4096]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW=[[1082]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_ZOOM_BAZOOKA=[[820]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_DEPLOY_TOMMY=[[837]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_30CAL=[[960]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_BOLT=[[658]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_TOMMY=[[932]] (NUMBER)"] = true,
	["_G.MAT_CONCRETE=[[67]] (NUMBER)"] = true,
	["_G.ACT_READINESS_PISTOL_STIMULATED_TO_RELAXED=[[425]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_ATTACH2=[[232]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE=[[599]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE2_IDLE=[[1411]] (NUMBER)"] = true,
	["_G.chat.GetChatBoxPos (FUNCTION)"] = true,
	["_G.chat.PlaySound (FUNCTION)"] = true,
	["_G.chat.AddText (FUNCTION)"] = true,
	["_G.SetPhysConstraintSystem (FUNCTION)"] = true,
	["_G.ACT_VM_DEPLOY=[[553]] (NUMBER)"] = true,
	["_G.KEY_XSTICK2_RIGHT=[[156]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_MP44=[[695]] (NUMBER)"] = true,
	["_G.CREATERENDERTARGETFLAGS_HDR=[[1]] (NUMBER)"] = true,
	["_G.ACT_BUSY_LEAN_BACK_ENTRY=[[390]] (NUMBER)"] = true,
	["_G.MATERIAL_LINES=[[1]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_RIFLE=[[639]] (NUMBER)"] = true,
	["_G.WEAPON_PROFICIENCY_AVERAGE=[[1]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_DEPLOYED_30CAL=[[919]] (NUMBER)"] = true,
	["_G.ACT_DOD_DEFUSE_TNT=[[988]] (NUMBER)"] = true,
	["_G.kRenderFxPulseFastWider=[[24]] (NUMBER)"] = true,
	["_G.FindMetaTable (FUNCTION)"] = true,
	["_G.ACT_DOD_WALK_AIM_PSCHRECK=[[785]] (NUMBER)"] = true,
	["_G.WEAPON_PROFICIENCY_VERY_GOOD=[[3]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_FLINCH_LEFTARM=[[11]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE_MELEE=[[1307]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_4=[[530]] (NUMBER)"] = true,
	["_G.ACT_DO_NOT_DISTURB=[[171]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_PISTOL_LOW=[[290]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_BAZOOKA=[[961]] (NUMBER)"] = true,
	["_G.DMG_SONIC=[[512]] (NUMBER)"] = true,
	["_G.ACT_WALK_CROUCH=[[8]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK_PDA=[[1467]] (NUMBER)"] = true,
	["_G.ACT_IDLE_AIM_RELAXED=[[90]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_BAZOOKA=[[772]] (NUMBER)"] = true,
	["_G.KEY_SLASH=[[60]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_SMG2=[[286]] (NUMBER)"] = true,
	["_G.ACT_TRANSITION=[[2]] (NUMBER)"] = true,
	["_G.MATERIAL_TRIANGLES=[[2]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_TNT=[[981]] (NUMBER)"] = true,
	["_G.FVPHYSICS_WAS_THROWN=[[256]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_PRIMARY=[[1177]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE1_DRAW=[[1407]] (NUMBER)"] = true,
	["_G.FCVAR_NEVER_AS_STRING=[[4096]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_RIGHT=[[147]] (NUMBER)"] = true,
	["_G.ACT_VM_HITCENTER2=[[192]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_C96=[[628]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_LOOP=[[1150]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_X=[[116]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_BOLT=[[848]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_SECONDARY_LOOP=[[1243]] (NUMBER)"] = true,
	["_G.KEY_XSTICK2_UP=[[159]] (NUMBER)"] = true,
	["_G.BOX_BACK=[[1]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_MG=[[866]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_DEPLOYED=[[582]] (NUMBER)"] = true,
	["_G.FCVAR_NOTIFY=[[256]] (NUMBER)"] = true,
	["_G.KEY_COMMA=[[58]] (NUMBER)"] = true,
	["_G.CONTENTS_CURRENT_UP=[[4194304]] (NUMBER)"] = true,
	["_G.ACT_RELOAD_PISTOL=[[376]] (NUMBER)"] = true,
	["_G.DMG_PLASMA=[[16777216]] (NUMBER)"] = true,
	["_G.OBS_MODE_DEATHCAM=[[1]] (NUMBER)"] = true,
	["_G.Format (FUNCTION)"] = true,
	["_G.ACT_DOD_SPRINT_AIM_GREN_STICK=[[751]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_SECONDARY=[[1236]] (NUMBER)"] = true,
	["_G.CONTENTS_WATER=[[32]] (NUMBER)"] = true,
	["_G.ACT_OBJ_DISMANTLING=[[463]] (NUMBER)"] = true,
	["_G.EyePos (FUNCTION)"] = true,
	["_G.ACT_WALK_PISTOL=[[369]] (NUMBER)"] = true,
	["_G.ACT_WALK=[[6]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_C96=[[901]] (NUMBER)"] = true,
	["_G.IN_BULLRUSH=[[4194304]] (NUMBER)"] = true,
	["_G.CONTENTS_CURRENT_270=[[2097152]] (NUMBER)"] = true,
	["_G.CONTENTS_MONSTERCLIP=[[131072]] (NUMBER)"] = true,
	["_G.MAT_WARPSHIELD=[[90]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_K98=[[969]] (NUMBER)"] = true,
	["_G.KEY_PERIOD=[[59]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_BAR=[[806]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_PISTOL=[[614]] (NUMBER)"] = true,
	["_G.ACT_STEP_RIGHT=[[134]] (NUMBER)"] = true,
	["_G.ACT_RUNTOIDLE=[[506]] (NUMBER)"] = true,
	["_G.ACT_VM_MISSLEFT=[[193]] (NUMBER)"] = true,
	["_G.ACT_DYINGLOOP=[[429]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_BAR=[[796]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_SHOTGUN=[[1028]] (NUMBER)"] = true,
	["_G.MATERIAL_RT_DEPTH_NONE=[[2]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_MP44=[[968]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_AR2=[[1024]] (NUMBER)"] = true,
	["_G.MAT_SAND=[[78]] (NUMBER)"] = true,
	["_G.KEY_PAD_7=[[44]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_MP40=[[679]] (NUMBER)"] = true,
	["_G.ACT_IDLE_ON_FIRE=[[125]] (NUMBER)"] = true,
	["_G.KEY_J=[[20]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_RIFLE=[[637]] (NUMBER)"] = true,
	["_G.kRenderFxRagdoll=[[23]] (NUMBER)"] = true,
	["_G.ACT_SLAM_TRIPMINE_TO_STICKWALL_ND=[[259]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_MELEE=[[1093]] (NUMBER)"] = true,
	["_G.ACT_PLAYER_WALK_FIRE=[[503]] (NUMBER)"] = true,
	["_G.NullEntity (FUNCTION)"] = true,
	["_G.ACT_GESTURE_MELEE_ATTACK1=[[139]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_SECONDARY=[[1237]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE2_IDLE=[[1399]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_RIGHT90=[[162]] (NUMBER)"] = true,
	["_G.KEY_SEMICOLON=[[55]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_C96=[[626]] (NUMBER)"] = true,
	["_G.ACT_SHIELD_KNOCKBACK=[[453]] (NUMBER)"] = true,
	["_G.FVPHYSICS_MULTIOBJECT_ENTITY=[[16]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL_GROUP=[[54]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_MELEE=[[1095]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM=[[1102]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_DEPLOY_MG=[[838]] (NUMBER)"] = true,
	["_G.ACT_RELOAD_SHOTGUN_LOW=[[381]] (NUMBER)"] = true,
	["_G.ACT_IDLE_SHOTGUN_AGITATED=[[341]] (NUMBER)"] = true,
	["_G.DMG_RADIATION=[[262144]] (NUMBER)"] = true,
	["_G.STENCILCOMPARISONFUNCTION_GREATEREQUAL=[[7]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_GARAND=[[888]] (NUMBER)"] = true,
	["_G.ACT_WALK_HURT=[[105]] (NUMBER)"] = true,
	["_G.ACT_DI_ALYX_ANTLION=[[415]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_3=[[577]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_AR2=[[1023]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_GREN_STICK=[[749]] (NUMBER)"] = true,
	["_G.ACT_VM_SPRINT_IDLE=[[433]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_GREN_STICK=[[747]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_SECONDARY_LOOP=[[1252]] (NUMBER)"] = true,
	["_G.RT_SIZE_FULL_FRAME_BUFFER=[[4]] (NUMBER)"] = true,
	["_G.MASK_OPAQUE_AND_NPCS=[[33570945]] (NUMBER)"] = true,
	["_G.ACT_VM_DEPLOY_5=[[557]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_SECONDARY_LOOP=[[1249]] (NUMBER)"] = true,
	["_G.surface.DrawTexturedRectUV (FUNCTION)"] = true,
	["_G.surface.DrawTexturedRect (FUNCTION)"] = true,
	["_G.surface.DrawRect (FUNCTION)"] = true,
	["_G.surface.DrawCircle (FUNCTION)"] = true,
	["_G.surface.ScreenHeight (FUNCTION)"] = true,
	["_G.surface.GetHUDTexture (FUNCTION)"] = true,
	["_G.surface.CreateFont (FUNCTION)"] = true,
	["_G.surface.SetTextColor (FUNCTION)"] = true,
	["_G.surface.DrawPoly (FUNCTION)"] = true,
	["_G.surface.DrawLine (FUNCTION)"] = true,
	["_G.surface.SetTexture (FUNCTION)"] = true,
	["_G.surface.SetDrawColor (FUNCTION)"] = true,
	["_G.surface.SetFont (FUNCTION)"] = true,
	["_G.surface.PlaySound (FUNCTION)"] = true,
	["_G.surface.DrawTexturedRectRotated (FUNCTION)"] = true,
	["_G.surface.GetTextureSize (FUNCTION)"] = true,
	["_G.surface.SetMaterial (FUNCTION)"] = true,
	["_G.surface.GetTextSize (FUNCTION)"] = true,
	["_G.surface.GetTextureID (FUNCTION)"] = true,
	["_G.surface.DrawOutlinedRect (FUNCTION)"] = true,
	["_G.surface.ScreenWidth (FUNCTION)"] = true,
	["_G.surface.DrawText (FUNCTION)"] = true,
	["_G.surface.SetTextPos (FUNCTION)"] = true,
	["_G.ACT_GESTURE_FLINCH_RIGHTARM=[[154]] (NUMBER)"] = true,
	["_G.ACT_SCRIPT_CUSTOM_MOVE=[[15]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_ZOOM_PSCHRECK=[[831]] (NUMBER)"] = true,
	["_G.ACT_VM_PULLPIN=[[180]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_K43=[[927]] (NUMBER)"] = true,
	["_G.ACT_IDLE_ANGRY_SMG1=[[321]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_BAZOOKA=[[774]] (NUMBER)"] = true,
	["_G.ACT_GET_DOWN_CROUCH=[[510]] (NUMBER)"] = true,
	["_G.ACT_RUN_PISTOL=[[370]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_PRIMARY=[[1501]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_MG=[[714]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_THROW_ND=[[246]] (NUMBER)"] = true,
	["_G.ACT_STRAFE_RIGHT=[[40]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_WORLD=[[20]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PISTOL=[[862]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE=[[1092]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_ZOOMED=[[585]] (NUMBER)"] = true,
	["_G.DMG_FALL=[[32]] (NUMBER)"] = true,
	["_G.SinglePlayer (FUNCTION)"] = true,
	["_G.OBS_MODE_FREEZECAM=[[2]] (NUMBER)"] = true,
	["_G.KEY_RIGHT=[[91]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_RIFLE=[[841]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_GRENADE=[[1053]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_PRIMARY=[[1169]] (NUMBER)"] = true,
	["_G.gui.SetMousePos (FUNCTION)"] = true,
	["_G.gui.InternalMousePressed (FUNCTION)"] = true,
	["_G.gui.EnableScreenClicker (FUNCTION)"] = true,
	["_G.gui.InternalMouseReleased (FUNCTION)"] = true,
	["_G.gui.MouseX (FUNCTION)"] = true,
	["_G.gui.OpenURL (FUNCTION)"] = true,
	["_G.gui.ScreenToVector (FUNCTION)"] = true,
	["_G.gui.MouseY (FUNCTION)"] = true,
	["_G.gui.InternalKeyCodeReleased (FUNCTION)"] = true,
	["_G.gui.InternalMouseWheeled (FUNCTION)"] = true,
	["_G.gui.MousePos (FUNCTION)"] = true,
	["_G.gui.InternalCursorMoved (FUNCTION)"] = true,
	["_G.gui.InternalKeyCodeTyped (FUNCTION)"] = true,
	["_G.gui.InternalMouseDoublePressed (FUNCTION)"] = true,
	["_G.gui.InternalKeyCodePressed (FUNCTION)"] = true,
	["_G.ACT_IDLE_PISTOL=[[322]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PSCHRECK=[[884]] (NUMBER)"] = true,
	["_G.MOUSE_LEFT=[[107]] (NUMBER)"] = true,
	["_G.kRenderFxPulseSlowWide=[[3]] (NUMBER)"] = true,
	["_G.MOUSE_COUNT=[[7]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_TO_LOWERED=[[203]] (NUMBER)"] = true,
	["_G.KEY_B=[[12]] (NUMBER)"] = true,
	["_G.MOVETYPE_WALK=[[2]] (NUMBER)"] = true,
	["_G.ACT_RIDE_MANNED_GUN=[[431]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_PRIMARY=[[1168]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN=[[1032]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_SPADE=[[761]] (NUMBER)"] = true,
	["_G.MASK_SPLITAREAPORTAL=[[48]] (NUMBER)"] = true,
	["_G.ACT_CROUCHIDLE_AGITATED=[[104]] (NUMBER)"] = true,
	["_G.ACT_SMG2_RELOAD2=[[273]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_LEFT=[[149]] (NUMBER)"] = true,
	["_G.IsPhysicsObject (FUNCTION)"] = true,
	["_G.ACT_CROUCHING_GRENADEIDLE=[[438]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_3=[[568]] (NUMBER)"] = true,
	["_G.ACT_HANDGRENADE_THROW2=[[476]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_M1CARBINE=[[925]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_EMPTY=[[580]] (NUMBER)"] = true,
	["_G.KEY_7=[[8]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_BUILDING=[[1438]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_30CAL=[[724]] (NUMBER)"] = true,
	["_G.KEY_5=[[6]] (NUMBER)"] = true,
	["_G.ACT_IDLE_AIM_RIFLE_STIMULATED=[[336]] (NUMBER)"] = true,
	["_G.CLIENT=[[true]] (BOOLEAN)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_BOLT=[[905]] (NUMBER)"] = true,
	["_G.DeriveGamemode (FUNCTION)"] = true,
	["_G.ACT_HL2MP_JUMP_MELEE2=[[1678]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_PDA=[[1539]] (NUMBER)"] = true,
	["_G.PLAYER_ATTACK1=[[5]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL3=[[51]] (NUMBER)"] = true,
	["_G.MASK_WATER=[[16432]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_AR2_GRENADE=[[305]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_PHYSGUN=[[1075]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_GREASE=[[704]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE=[[1052]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_MP44=[[692]] (NUMBER)"] = true,
	["_G.setmetatable (FUNCTION)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE=[[596]] (NUMBER)"] = true,
	["_G.ACT_SHIELD_UP_IDLE=[[451]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_PRIMARY_DEPLOYED=[[1180]] (NUMBER)"] = true,
	["_G.KEY_I=[[19]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_RPG=[[1643]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_TOMMY=[[895]] (NUMBER)"] = true,
	["_G.getmetatable (FUNCTION)"] = true,
	["_G.KEY_N=[[24]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_ND_DRAW=[[249]] (NUMBER)"] = true,
	["_G.rawset (FUNCTION)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_MELEE=[[1514]] (NUMBER)"] = true,
	["_G.kRenderFxPulseFast=[[2]] (NUMBER)"] = true,
	["_G.EFL_NO_GAME_PHYSICS_SIMULATION=[[8388608]] (NUMBER)"] = true,
	["_G.ACT_SHIELD_DOWN=[[450]] (NUMBER)"] = true,
	["_G.JOYSTICK_LAST_POV_BUTTON=[[149]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_MP44=[[689]] (NUMBER)"] = true,
	["_G.SURF_NOLIGHT=[[1024]] (NUMBER)"] = true,
	["_G.ACT_VM_SPRINT_LEAVE=[[434]] (NUMBER)"] = true,
	["_G.EF_BONEMERGE_FASTCULL=[[128]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_STICK2=[[123]] (NUMBER)"] = true,
	["_G.KEY_LAST=[[106]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_GREN_STICK=[[750]] (NUMBER)"] = true,
	["_G.ACT_VM_RELEASE=[[210]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_SLAM=[[1098]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_GRENADE=[[1055]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_3=[[531]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH=[[1146]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_MG=[[721]] (NUMBER)"] = true,
	["_G.KEY_V=[[32]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_TNT=[[985]] (NUMBER)"] = true,
	["_G.MAT_WOOD=[[87]] (NUMBER)"] = true,
	["_G.ACT_VM_LOWERED_TO_IDLE=[[205]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_PDA=[[1540]] (NUMBER)"] = true,
	["_G.KEY_TAB=[[67]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_PRIMARY=[[1503]] (NUMBER)"] = true,
	["_G.ACT_SMALL_FLINCH=[[62]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_GREN_STICK=[[876]] (NUMBER)"] = true,
	["_G.ACT_ROLL_RIGHT=[[42]] (NUMBER)"] = true,
	["_G.ACT_PHYSCANNON_UPGRADE=[[277]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE1_ATTACK=[[1409]] (NUMBER)"] = true,
	["_G.ACT_DI_ALYX_ZOMBIE_MELEE=[[412]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE2_IDLE=[[1393]] (NUMBER)"] = true,
	["_G.ACT_SHOTGUN_PUMP=[[269]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_5=[[538]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_TOMMY=[[667]] (NUMBER)"] = true,
	["_G.ACT_DIE_GUTSHOT=[[115]] (NUMBER)"] = true,
	["_G.ACT_RPG_HOLSTER_UNLOADED=[[483]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM_SHOTGUN=[[368]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK2_LOW=[[19]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM=[[598]] (NUMBER)"] = true,
	["_G.MOUSE_WHEEL_UP=[[112]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_FLINCH_HEAD=[[10]] (NUMBER)"] = true,
	["_G.ACT_READINESS_AGITATED_TO_STIMULATED=[[420]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_PISTOL=[[371]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH=[[959]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_LEFT90=[[161]] (NUMBER)"] = true,
	["_G.CONTENTS_MOVEABLE=[[16384]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_5=[[547]] (NUMBER)"] = true,
	["_G.EFL_NO_DAMAGE_FORCES=[[-2147483648]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_PRIMARY=[[1183]] (NUMBER)"] = true,
	["_G.KEY_PAD_3=[[40]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_TOMMY=[[668]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_NPC=[[9]] (NUMBER)"] = true,
	["_G.ACT_RELOAD_LOW=[[69]] (NUMBER)"] = true,
	["_G.KEY_PAD_DECIMAL=[[52]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_BAZOOKA=[[909]] (NUMBER)"] = true,
	["_G.ACT_RPG_FIDGET_UNLOADED=[[485]] (NUMBER)"] = true,
	["_G.ACT_BARNACLE_HIT=[[167]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_MP40=[[676]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE=[[593]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_PRIMARY_DEPLOYED=[[1178]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_2=[[541]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_MP40=[[673]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_PHYSGUN=[[1072]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_SMG1=[[1010]] (NUMBER)"] = true,
	["_G.ACT_RUN=[[10]] (NUMBER)"] = true,
	["_G.ACT_VM_PULLBACK=[[176]] (NUMBER)"] = true,
	["_G.FCVAR_PRINTABLEONLY=[[1024]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL1=[[49]] (NUMBER)"] = true,
	["_G.KEY_DELETE=[[73]] (NUMBER)"] = true,
	["_G.ACT_SWIM=[[28]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PISTOL=[[897]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_DOOR_BLOCKER=[[14]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_SECONDARY=[[1238]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_6=[[546]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_3=[[549]] (NUMBER)"] = true,
	["_G.EFL_TOUCHING_FLUID=[[524288]] (NUMBER)"] = true,
	["_G.CONTENTS_PLAYERCLIP=[[65536]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_TRIPWIRE=[[315]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROSSBOW=[[1077]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_DEPLOY_30CAL=[[839]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_PISTOL=[[619]] (NUMBER)"] = true,
	["_G.ACT_OVERLAY_SHIELD_KNOCKBACK=[[448]] (NUMBER)"] = true,
	["_G.util.Decal (FUNCTION)"] = true,
	["_G.util.GetPixelVisibleHandle (FUNCTION)"] = true,
	["_G.util.CRC (FUNCTION)"] = true,
	["_G.util.IsValidModel (FUNCTION)"] = true,
	["_G.util.TraceEntityHull (FUNCTION)"] = true,
	["_G.util.DecalMaterial (FUNCTION)"] = true,
	["_G.util.PrecacheSound (FUNCTION)"] = true,
	["_G.util.BlastDamage (FUNCTION)"] = true,
	["_G.util.PrecacheModel (FUNCTION)"] = true,
	["_G.util.PointContents (FUNCTION)"] = true,
	["_G.util.GetSunInfo (FUNCTION)"] = true,
	["_G.util.IsValidProp (FUNCTION)"] = true,
	["_G.util.Effect (FUNCTION)"] = true,
	["_G.util.ParticleTracerEx (FUNCTION)"] = true,
	["_G.util.ParticleTracer (FUNCTION)"] = true,
	["_G.util.GetModelInfo (FUNCTION)"] = true,
	["_G.util.GetSurfaceIndex (FUNCTION)"] = true,
	["_G.util.RelativePathToFull (FUNCTION)"] = true,
	["_G.util.PixelVisible (FUNCTION)"] = true,
	["_G.util.TraceLine (FUNCTION)"] = true,
	["_G.util.IsValidRagdoll (FUNCTION)"] = true,
	["_G.util.TraceHull (FUNCTION)"] = true,
	["_G.util.ScreenShake (FUNCTION)"] = true,
	["_G.util.TraceEntity (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_BAR=[[802]] (NUMBER)"] = true,
	["_G.ACT_PHYSCANNON_ANIMATE_PRE=[[405]] (NUMBER)"] = true,
	["_G.package.preload (TABLE)"] = true,
	["_G.package.loadlib (FUNCTION)"] = true,
	["_G.package.loaders (TABLE)"] = true,
	["_G.package.loaded (TABLE)"] = true,
	["_G.package.seeall (FUNCTION)"] = true,
	["_G.ACT_COVER_LOW=[[5]] (NUMBER)"] = true,
	["_G.BOX_RIGHT=[[2]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE_PRIMARY=[[1225]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_PRIMARY_END=[[1188]] (NUMBER)"] = true,
	["_G.ACT_OBJ_STARTUP=[[464]] (NUMBER)"] = true,
	["_G.FVPHYSICS_HEAVY_OBJECT=[[32]] (NUMBER)"] = true,
	["_G.CurTime (FUNCTION)"] = true,
	["_G.ACT_IDLE_AGITATED=[[79]] (NUMBER)"] = true,
	["_G.GetRenderTargetEx (FUNCTION)"] = true,
	["_G.ACT_MP_GRENADE1_IDLE=[[1390]] (NUMBER)"] = true,
	["_G.OBS_MODE_CHASE=[[5]] (NUMBER)"] = true,
	["_G.ACT_VM_RECOIL3=[[208]] (NUMBER)"] = true,
	["_G.KEY_H=[[18]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_30CAL=[[871]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_MP44=[[696]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_TRIPWIRE=[[292]] (NUMBER)"] = true,
	["_G.ACT_VM_MISSCENTER=[[197]] (NUMBER)"] = true,
	["_G.ACT_MP_DOUBLEJUMP=[[1123]] (NUMBER)"] = true,
	["_G.ACT_RUN_RIFLE_RELAXED=[[333]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_RPG=[[295]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_RIFLE=[[633]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_SECONDARY=[[1234]] (NUMBER)"] = true,
	["_G.JOYSTICK_FIRST_POV_BUTTON=[[146]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_PDA=[[1542]] (NUMBER)"] = true,
	["_G.MOVECOLLIDE_FLY_CUSTOM=[[2]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_AR2=[[1017]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH=[[1495]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND=[[1122]] (NUMBER)"] = true,
	["_G.ACT_MELEE_ATTACK2=[[65]] (NUMBER)"] = true,
	["_G.KEY_PAD_5=[[42]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_ZOOMED=[[586]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_7=[[527]] (NUMBER)"] = true,
	["_G.MASK_PLAYERSOLID_BRUSHONLY=[[81931]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_MELEE=[[1088]] (NUMBER)"] = true,
	["_G.KEY_PAGEUP=[[76]] (NUMBER)"] = true,
	["_G.MAT_TILE=[[84]] (NUMBER)"] = true,
	["_G.ACT_STEP_FORE=[[136]] (NUMBER)"] = true,
	["_G.JOYSTICK_LAST_BUTTON=[[145]] (NUMBER)"] = true,
	["_G.ACT_FIRE_LOOP=[[436]] (NUMBER)"] = true,
	["_G.ACT_GET_UP_STAND=[[509]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_CANCEL=[[16]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL_RIGHT=[[57]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_C96=[[913]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_BAZOOKA=[[914]] (NUMBER)"] = true,
	["_G.ACT_FLINCH_LEFTLEG=[[122]] (NUMBER)"] = true,
	["_G.ACT_RUN_CROUCH=[[12]] (NUMBER)"] = true,
	["_G.ACT_SWIM_IDLE=[[29]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE1_DRAW=[[1395]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_SILENCED=[[496]] (NUMBER)"] = true,
	["_G.ACT_RPG_DRAW_UNLOADED=[[482]] (NUMBER)"] = true,
	["_G.ACT_VM_DEPLOY_2=[[560]] (NUMBER)"] = true,
	["_G.ACT_CLIMB_DOWN=[[35]] (NUMBER)"] = true,
	["_G.IN_WALK=[[262144]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_GREN_FRAG=[[739]] (NUMBER)"] = true,
	["_G.ACT_BUSY_SIT_GROUND=[[392]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_FLINCH_STOMACH=[[152]] (NUMBER)"] = true,
	["_G.ACT_CROUCHIDLE_AIM_STIMULATED=[[103]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_PSCHRECK=[[939]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_KNIFE=[[1659]] (NUMBER)"] = true,
	["_G.DMG_VEHICLE=[[16]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_GREN_FRAG=[[737]] (NUMBER)"] = true,
	["_G.ClientsideModel (FUNCTION)"] = true,
	["_G.ACT_DOD_PRONE_ZOOM_FORWARD_PSCHRECK=[[949]] (NUMBER)"] = true,
	["_G.KEY_F9=[[100]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE_BUILDING=[[1442]] (NUMBER)"] = true,
	["_G.EF_NORECEIVESHADOW=[[64]] (NUMBER)"] = true,
	["_G.RIGHT=[[3]] (NUMBER)"] = true,
	["_G.ACT_DIE_HEADSHOT=[[113]] (NUMBER)"] = true,
	["_G.ACT_SLAM_DETONATOR_THROW_DRAW=[[266]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_SHOTGUN=[[287]] (NUMBER)"] = true,
	["_G.ACT_VM_HITLEFT=[[187]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE_SECONDARY=[[1260]] (NUMBER)"] = true,
	["_G.KEY_3=[[4]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_RPG=[[1041]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_DEBRIS_TRIGGER=[[2]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_GRENADE=[[1048]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_SECONDARY=[[1242]] (NUMBER)"] = true,
	["_G.ACT_IDLETORUN=[[505]] (NUMBER)"] = true,
	["_G.IN_ATTACK=[[1]] (NUMBER)"] = true,
	["_G.ACT_OVERLAY_GRENADEIDLE=[[441]] (NUMBER)"] = true,
	["_G.IN_USE=[[32]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_BAR=[[890]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_MELEE2=[[1674]] (NUMBER)"] = true,
	["_G.render.GetScreenEffectTexture (FUNCTION)"] = true,
	["_G.render.SetFogZ (FUNCTION)"] = true,
	["_G.render.PushCustomClipPlane (FUNCTION)"] = true,
	["_G.render.DrawQuadEasy (FUNCTION)"] = true,
	["_G.render.GetSuperFPTex (FUNCTION)"] = true,
	["_G.render.EnableClipping (FUNCTION)"] = true,
	["_G.render.MaxTextureWidth (FUNCTION)"] = true,
	["_G.render.Clear (FUNCTION)"] = true,
	["_G.render.GetDXLevel (FUNCTION)"] = true,
	["_G.render.GetSuperFPTex2 (FUNCTION)"] = true,
	["_G.render.FogStart (FUNCTION)"] = true,
	["_G.render.SupportsVertexShaders_2_0 (FUNCTION)"] = true,
	["_G.render.SuppressEngineLighting (FUNCTION)"] = true,
	["_G.render.GetLightColor (FUNCTION)"] = true,
	["_G.render.GetSurfaceColor (FUNCTION)"] = true,
	["_G.render.CullMode (FUNCTION)"] = true,
	["_G.render.SetToneMappingScaleLinear (FUNCTION)"] = true,
	["_G.render.PerformFullScreenStencilOperation (FUNCTION)"] = true,
	["_G.render.AddBeam (FUNCTION)"] = true,
	["_G.render.SetBlend (FUNCTION)"] = true,
	["_G.render.GetFogMode (FUNCTION)"] = true,
	["_G.render.TurnOnToneMapping (FUNCTION)"] = true,
	["_G.render.GetFullScreenDepthTexture (FUNCTION)"] = true,
	["_G.render.GetToneMappingScaleLinear (FUNCTION)"] = true,
	["_G.render.GetBloomTex0 (FUNCTION)"] = true,
	["_G.render.Spin (FUNCTION)"] = true,
	["_G.render.SetScissorRect (FUNCTION)"] = true,
	["_G.render.SetStencilReferenceValue (FUNCTION)"] = true,
	["_G.render.MaxTextureHeight (FUNCTION)"] = true,
	["_G.render.SetModelLighting (FUNCTION)"] = true,
	["_G.render.SetStencilZFailOperation (FUNCTION)"] = true,
	["_G.render.SetStencilWriteMask (FUNCTION)"] = true,
	["_G.render.SupportsPixelShaders_1_4 (FUNCTION)"] = true,
	["_G.render.PopCustomClipPlane (FUNCTION)"] = true,
	["_G.render.EndBeam (FUNCTION)"] = true,
	["_G.render.SupportsHDR (FUNCTION)"] = true,
	["_G.render.ClearStencilBufferRectangle (FUNCTION)"] = true,
	["_G.render.UpdateScreenEffectTexture (FUNCTION)"] = true,
	["_G.render.CopyRenderTargetToTexture (FUNCTION)"] = true,
	["_G.render.ReadPixel (FUNCTION)"] = true,
	["_G.render.FogMaxDensity (FUNCTION)"] = true,
	["_G.render.ClearBuffersObeyStencil (FUNCTION)"] = true,
	["_G.render.ResetToneMappingScale (FUNCTION)"] = true,
	["_G.render.RenderView (FUNCTION)"] = true,
	["_G.render.CapturePixels (FUNCTION)"] = true,
	["_G.render.DrawScreenQuad (FUNCTION)"] = true,
	["_G.render.SetStencilEnable (FUNCTION)"] = true,
	["_G.render.ClearDepth (FUNCTION)"] = true,
	["_G.render.SetLightingOrigin (FUNCTION)"] = true,
	["_G.render.FogEnd (FUNCTION)"] = true,
	["_G.render.GetMorphTex0 (FUNCTION)"] = true,
	["_G.render.GetMorphTex1 (FUNCTION)"] = true,
	["_G.render.ResetModelLighting (FUNCTION)"] = true,
	["_G.render.SetRenderTarget (FUNCTION)"] = true,
	["_G.render.FogColor (FUNCTION)"] = true,
	["_G.render.SetColorModulation (FUNCTION)"] = true,
	["_G.render.DrawBeam (FUNCTION)"] = true,
	["_G.render.GetRenderTarget (FUNCTION)"] = true,
	["_G.render.StartBeam (FUNCTION)"] = true,
	["_G.render.UpdateRefractTexture (FUNCTION)"] = true,
	["_G.render.SetAmbientLight (FUNCTION)"] = true,
	["_G.render.SetMaterial (FUNCTION)"] = true,
	["_G.render.GetBloomTex1 (FUNCTION)"] = true,
	["_G.render.SetStencilFailOperation (FUNCTION)"] = true,
	["_G.render.SetStencilTestMask (FUNCTION)"] = true,
	["_G.render.FogMode (FUNCTION)"] = true,
	["_G.render.DrawSprite (FUNCTION)"] = true,
	["_G.render.SupportsPixelShaders_2_0 (FUNCTION)"] = true,
	["_G.render.SetViewPort (FUNCTION)"] = true,
	["_G.render.SetGoalToneMappingScale (FUNCTION)"] = true,
	["_G.render.UpdateFullScreenDepthTexture (FUNCTION)"] = true,
	["_G.render.GetFogColor (FUNCTION)"] = true,
	["_G.render.SetStencilCompareFunction (FUNCTION)"] = true,
	["_G.render.DrawQuad (FUNCTION)"] = true,
	["_G.render.ClearStencil (FUNCTION)"] = true,
	["_G.render.GetFogDistances (FUNCTION)"] = true,
	["_G.render.SetStencilPassOperation (FUNCTION)"] = true,
	["_G.render.GetMoBlurTex0 (FUNCTION)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_MELEE=[[1302]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_FIST=[[1626]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_30CAL=[[736]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_PISTOL=[[609]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RELOAD_PISTOL=[[383]] (NUMBER)"] = true,
	["_G.ACT_90_LEFT=[[131]] (NUMBER)"] = true,
	["_G.KEY_XSTICK1_LEFT=[[151]] (NUMBER)"] = true,
	["_G.IN_DUCK=[[4]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_SECONDARY_LOOP=[[1246]] (NUMBER)"] = true,
	["_G.FCVAR_NONE=[[0]] (NUMBER)"] = true,
	["_G.ACT_SLAM_TRIPMINE_ATTACH=[[257]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_TOMMY=[[660]] (NUMBER)"] = true,
	["_G.LocalToWorld (FUNCTION)"] = true,
	["_G.PLAYER_SUPERJUMP=[[3]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_BAR=[[795]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_STARTFIRE=[[1157]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM=[[1124]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_PDA=[[1538]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_HMG1=[[306]] (NUMBER)"] = true,
	["_G.GESTURE_SLOT_ATTACK_AND_RELOAD=[[0]] (NUMBER)"] = true,
	["_G.ACT_ARM=[[70]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_C96=[[631]] (NUMBER)"] = true,
	["_G.ACT_MP_SPRINT=[[1118]] (NUMBER)"] = true,
	["_G.ACT_RELOAD_FINISH=[[68]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_TNT=[[984]] (NUMBER)"] = true,
	["_G.ACT_VM_RECOIL2=[[207]] (NUMBER)"] = true,
	["_G.ACT_CROSSBOW_DRAW_UNLOADED=[[486]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_2=[[550]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK=[[1117]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_C96=[[630]] (NUMBER)"] = true,
	["_G.KEY_F=[[16]] (NUMBER)"] = true,
	["_G.KEY_F4=[[95]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_PDA=[[1541]] (NUMBER)"] = true,
	["_G.ACT_SLAM_DETONATOR_DETONATE=[[263]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_PISTOL=[[999]] (NUMBER)"] = true,
	["_G.MOVETYPE_OBSERVER=[[10]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_RIFLE=[[359]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_PRONE_RIFLE=[[843]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_PRIMARY=[[1181]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_PSCHRECK=[[788]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_PRIMARY_LOOP=[[1190]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_EMPTY_LEFT=[[498]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_BAZOOKA=[[770]] (NUMBER)"] = true,
	["_G.CONTENTS_TRANSLUCENT=[[268435456]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_BOLT=[[654]] (NUMBER)"] = true,
	["_G.EF_DIMLIGHT=[[4]] (NUMBER)"] = true,
	["_G.NODOCK=[[0]] (NUMBER)"] = true,
	["_G.KEY_XSTICK2_DOWN=[[158]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_ATTACK_SECONDARY=[[1]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK1=[[137]] (NUMBER)"] = true,
	["_G.ACT_IDLE_CARRY=[[426]] (NUMBER)"] = true,
	["_G.MAT_GRATE=[[71]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK_PRIMARY=[[1165]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_BUILDING=[[1431]] (NUMBER)"] = true,
	["_G.PLAYER_DIE=[[4]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RELOAD_SHOTGUN=[[385]] (NUMBER)"] = true,
	["_G.ACT_DIERAGDOLL=[[24]] (NUMBER)"] = true,
	["_G.ACT_SHOTGUN_RELOAD_START=[[267]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_GRENADE=[[1050]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_PDA=[[1472]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_BAZOOKA=[[780]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_RIFLE=[[645]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_7=[[545]] (NUMBER)"] = true,
	["_G.LEFT=[[2]] (NUMBER)"] = true,
	["_G.PLAYER_JUMP=[[2]] (NUMBER)"] = true,
	["_G.ACT_BUSY_QUEUE=[[399]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK1_LOW=[[18]] (NUMBER)"] = true,
	["_G.HSVToColor (FUNCTION)"] = true,
	["_G.EF_ITEM_BLINK=[[256]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_7=[[573]] (NUMBER)"] = true,
	["_G.IN_RUN=[[4096]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_KNIFE=[[1657]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_AR2=[[1025]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_PDA=[[1470]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_SECONDARY=[[1227]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_DRAW=[[248]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_MELEE=[[1299]] (NUMBER)"] = true,
	["_G.ACT_DOD_ZOOMLOAD_PSCHRECK=[[917]] (NUMBER)"] = true,
	["_G.mesh.Normal (FUNCTION)"] = true,
	["_G.mesh.TangentT (FUNCTION)"] = true,
	["_G.mesh.QuadEasy (FUNCTION)"] = true,
	["_G.mesh.Color (FUNCTION)"] = true,
	["_G.mesh.Quad (FUNCTION)"] = true,
	["_G.mesh.TexCoord (FUNCTION)"] = true,
	["_G.mesh.TangentS (FUNCTION)"] = true,
	["_G.mesh.VertexCount (FUNCTION)"] = true,
	["_G.mesh.Position (FUNCTION)"] = true,
	["_G.mesh.AdvanceVertex (FUNCTION)"] = true,
	["_G.mesh.Begin (FUNCTION)"] = true,
	["_G.mesh.Specular (FUNCTION)"] = true,
	["_G.mesh.End (FUNCTION)"] = true,
	["_G.SOLID_CUSTOM=[[5]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE_SECONDARY=[[1261]] (NUMBER)"] = true,
	["_G.KEY_D=[[14]] (NUMBER)"] = true,
	["_G.ACT_OBJ_IDLE=[[466]] (NUMBER)"] = true,
	["_G.EFL_DORMANT=[[2]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_KNIFE=[[1651]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_SECONDARY=[[1245]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE2_DRAW=[[1398]] (NUMBER)"] = true,
	["_G.ACT_BUSY_SIT_CHAIR_EXIT=[[397]] (NUMBER)"] = true,
	["_G.KEY_RBRACKET=[[54]] (NUMBER)"] = true,
	["_G.MASK_BLOCKLOS_AND_NPCS=[[33570881]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_BAR=[[805]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_BOLT=[[651]] (NUMBER)"] = true,
	["_G.FCVAR_USERINFO=[[512]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_END=[[1154]] (NUMBER)"] = true,
	["_G.CONTENTS_AREAPORTAL=[[32768]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_K98=[[979]] (NUMBER)"] = true,
	["_G.CONTENTS_BLOCKLOS=[[64]] (NUMBER)"] = true,
	["_G.RealTime (FUNCTION)"] = true,
	["_G.ACT_DOD_WALK_AIM_TOMMY=[[662]] (NUMBER)"] = true,
	["_G.ACT_SHOTGUN_RELOAD_FINISH=[[268]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_PRIMARYFIRE_DEPLOYED=[[1130]] (NUMBER)"] = true,
	["_G.ACT_SHIPLADDER_DOWN=[[38]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_GREASE=[[699]] (NUMBER)"] = true,
	["_G.CONTENTS_TEAM2=[[4096]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_7=[[536]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_AIM_GREN_FRAG=[[743]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_TOMMY=[[967]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_PISTOL=[[312]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_PHYSGUN=[[1068]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_PHYSGUN=[[1071]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_ZOOM_BOLT=[[814]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_BOLT=[[650]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_CROUCH_MP40=[[957]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL=[[1002]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_LEFT_SHOULDER=[[118]] (NUMBER)"] = true,
	["_G.UnPredictedCurTime (FUNCTION)"] = true,
	["_G.ACT_DOD_WALK_AIM_MP44=[[688]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_FLINCH_RIGHTARM=[[12]] (NUMBER)"] = true,
	["_G.EyeAngles (FUNCTION)"] = true,
	["_G.ACT_GESTURE_FLINCH_BLAST_DAMAGED_SHOTGUN=[[149]] (NUMBER)"] = true,
	["_G.SOLID_NONE=[[0]] (NUMBER)"] = true,
	["_G.gcinfo (FUNCTION)"] = true,
	["_G.BLOOD_COLOR_ZOMBIE=[[5]] (NUMBER)"] = true,
	["_G.PLAYER_IN_VEHICLE=[[6]] (NUMBER)"] = true,
	["_G.MOUSE_MIDDLE=[[109]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_PSCHRECK=[[787]] (NUMBER)"] = true,
	["_G.SetGlobalVar (FUNCTION)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_PRIMARY=[[1506]] (NUMBER)"] = true,
	["_G.KEY_SPACE=[[65]] (NUMBER)"] = true,
	["_G.KEY_PAGEDOWN=[[77]] (NUMBER)"] = true,
	["_G.ACT_IDLE_RPG=[[349]] (NUMBER)"] = true,
	["_G.MAT_ANTLION=[[65]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_2=[[532]] (NUMBER)"] = true,
	["_G.ACT_VM_THROW=[[179]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_PISTOL=[[618]] (NUMBER)"] = true,
	["_G.ACT_SHIPLADDER_UP=[[37]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_BAZOOKA=[[882]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE2_ATTACK=[[1394]] (NUMBER)"] = true,
	["_G.KEY_LCONTROL=[[83]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_CROUCH_KNIFE=[[952]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_RIFLE=[[934]] (NUMBER)"] = true,
	["_G.SURF_NODECALS=[[8192]] (NUMBER)"] = true,
	["_G.kRenderFxSpotlight=[[22]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_MP40=[[891]] (NUMBER)"] = true,
	["_G.ACT_VM_UNUSABLE=[[1546]] (NUMBER)"] = true,
	["_G.ACT_WALK_RPG_RELAXED=[[356]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_LEFT45=[[159]] (NUMBER)"] = true,
	["_G.ACT_SMG2_IDLE2=[[270]] (NUMBER)"] = true,
	["_G.ACT_DEPLOY=[[470]] (NUMBER)"] = true,
	["_G.next (FUNCTION)"] = true,
	["_G.ACT_OBJ_DETERIORATING=[[468]] (NUMBER)"] = true,
	["_G.IN_WEAPON1=[[1048576]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_BAZOOKA=[[771]] (NUMBER)"] = true,
	["_G.ACT_SMG2_DRAW2=[[272]] (NUMBER)"] = true,
	["_G.KEY_T=[[30]] (NUMBER)"] = true,
	["_G.GetGlobalVar (FUNCTION)"] = true,
	["_G.CONTENTS_GRATE=[[8]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_PSCHRECK=[[784]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_TO_THROW_ND=[[240]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_PRIMARY=[[1170]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_C96=[[621]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_PISTOL_LOW=[[313]] (NUMBER)"] = true,
	["_G.KEY_CAPSLOCKTOGGLE=[[104]] (NUMBER)"] = true,
	["_G.select (FUNCTION)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_TOMMY=[[852]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_FLINCH_LEFTLEG=[[155]] (NUMBER)"] = true,
	["_G.SF_PHYSPROP_MOTIONDISABLED=[[8]] (NUMBER)"] = true,
	["_G.ACT_SLAM_DETONATOR_HOLSTER=[[264]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_RIFLE=[[899]] (NUMBER)"] = true,
	["_G.FVPHYSICS_CONSTRAINT_STATIC=[[2]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_MELEE_SECONDARY=[[1303]] (NUMBER)"] = true,
	["_G.ACT_RUN_RIFLE=[[362]] (NUMBER)"] = true,
	["_G.IN_RIGHT=[[256]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_SECONDARY=[[1239]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_TO_STICKWALL=[[250]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_PDA=[[1463]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_DEPLOYED_FG42=[[918]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_SHOTGUN=[[1027]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_BUILDING=[[1534]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_1=[[551]] (NUMBER)"] = true,
	["_G.MATERIAL_CULLMODE_CCW=[[0]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_ZOOM_FORWARD_BOLT=[[947]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK1=[[16]] (NUMBER)"] = true,
	["_G.ACT_VM_UNUSABLE_TO_USABLE=[[1547]] (NUMBER)"] = true,
	["_G.FrameTime (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_C96=[[622]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_7=[[564]] (NUMBER)"] = true,
	["_G.PLAYER_RELOAD=[[7]] (NUMBER)"] = true,
	["_G.MATERIAL_RT_DEPTH_SHARED=[[0]] (NUMBER)"] = true,
	["_G.ACT_RANGE_AIM_AR2_LOW=[[300]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_4=[[576]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_PASSIVE=[[1664]] (NUMBER)"] = true,
	["_G.KEY_UP=[[88]] (NUMBER)"] = true,
	["_G.ACT_READINESS_RELAXED_TO_STIMULATED=[[418]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_AIM_SPADE=[[767]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_ZOOM_BAZOOKA=[[821]] (NUMBER)"] = true,
	["_G.KEY_BACKQUOTE=[[57]] (NUMBER)"] = true,
	["_G.ACT_WALK_SCARED=[[110]] (NUMBER)"] = true,
	["_G.ACT_MELEE_ATTACK1=[[64]] (NUMBER)"] = true,
	["_G.KEY_L=[[22]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_RIFLE=[[903]] (NUMBER)"] = true,
	["_G.ACT_IDLE_HURT=[[81]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_SMG1=[[1013]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_TOMMY=[[666]] (NUMBER)"] = true,
	["_G.GESTURE_SLOT_SWIM=[[3]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_MELEE=[[1300]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_GREN_FRAG=[[874]] (NUMBER)"] = true,
	["_G.IN_WEAPON2=[[2097152]] (NUMBER)"] = true,
	["_G.KeyValuesToTablePreserveOrder (FUNCTION)"] = true,
	["_G.ACT_GESTURE_FLINCH_CHEST=[[151]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_SMG1=[[1011]] (NUMBER)"] = true,
	["_G.ParticleEffectAttach (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_PISTOL=[[608]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_CROSSBOW=[[1085]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_BAR=[[803]] (NUMBER)"] = true,
	["_G.ACT_BIG_FLINCH=[[63]] (NUMBER)"] = true,
	["_G.ACT_RANGE_AIM_LOW=[[297]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_PHYSGUN=[[1069]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_BAR=[[886]] (NUMBER)"] = true,
	["_G.ACT_MP_DEPLOYED_PRIMARY=[[1173]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_SALUTE=[[1786]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK_PDA=[[1468]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_GREASE=[[700]] (NUMBER)"] = true,
	["_G.ACT_VM_SECONDARYATTACK=[[182]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_CROUCH_GREN_FRAG=[[953]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_CROSSBOW=[[1079]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK2_LOW=[[142]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_PASSIVE=[[1669]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_KNIFE=[[1652]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_AR2_GRENADE=[[281]] (NUMBER)"] = true,
	["_G.ACT_DROP_WEAPON_SHOTGUN=[[73]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_MG=[[867]] (NUMBER)"] = true,
	["_G.EF_NODRAW=[[32]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_MP44=[[694]] (NUMBER)"] = true,
	["_G.MOUSE_FIRST=[[107]] (NUMBER)"] = true,
	["_G.KEY_PAD_4=[[41]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_2=[[569]] (NUMBER)"] = true,
	["_G.WEAPON_PROFICIENCY_GOOD=[[2]] (NUMBER)"] = true,
	["_G.KEY_BACKSPACE=[[66]] (NUMBER)"] = true,
	["_G.KEY_PAD_ENTER=[[51]] (NUMBER)"] = true,
	["_G.ACT_TRIPMINE_WORLD=[[492]] (NUMBER)"] = true,
	["_G.KEY_CAPSLOCK=[[68]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_RPG=[[1038]] (NUMBER)"] = true,
	["_G.ACT_IDLE_ANGRY_SHOTGUN=[[324]] (NUMBER)"] = true,
	["_G.DMG_BLAST_SURFACE=[[134217728]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG=[[1042]] (NUMBER)"] = true,
	["_G.ACT_DYINGTODEAD=[[430]] (NUMBER)"] = true,
	["_G.ACT_BUSY_LEAN_LEFT_ENTRY=[[387]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_BUILDING=[[1426]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_AIM_KNIFE=[[760]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_MP40=[[678]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_JUMP=[[6]] (NUMBER)"] = true,
	["_G.unpack (FUNCTION)"] = true,
	["_G.ACT_COVER_LOW_RPG=[[351]] (NUMBER)"] = true,
	["_G.MATERIAL_FOG_LINEAR=[[1]] (NUMBER)"] = true,
	["_G.FCVAR_PROTECTED=[[32]] (NUMBER)"] = true,
	["_G.IN_ATTACK2=[[2048]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_BOLT=[[926]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK=[[1115]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_DEPLOYED_30CAL=[[943]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_CROUCH=[[950]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE=[[601]] (NUMBER)"] = true,
	["_G.KEY_PAD_9=[[46]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_ND_ATTACH2=[[234]] (NUMBER)"] = true,
	["_G.EF_BRIGHTLIGHT=[[2]] (NUMBER)"] = true,
	["_G.PLAYER_IDLE=[[0]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_MG=[[713]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_KNIFE=[[1654]] (NUMBER)"] = true,
	["_G.rawget (FUNCTION)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_CROSSBOW=[[1083]] (NUMBER)"] = true,
	["_G.ACT_SLAM_TRIPMINE_ATTACH2=[[258]] (NUMBER)"] = true,
	["_G.input.LookupBinding (FUNCTION)"] = true,
	["_G.input.IsMouseDown (FUNCTION)"] = true,
	["_G.input.SetCursorPos (FUNCTION)"] = true,
	["_G.input.WasKeyReleased (FUNCTION)"] = true,
	["_G.input.WasMousePressed (FUNCTION)"] = true,
	["_G.input.WasMouseDoublePressed (FUNCTION)"] = true,
	["_G.input.IsKeyDown (FUNCTION)"] = true,
	["_G.input.WasKeyTyped (FUNCTION)"] = true,
	["_G.input.WasKeyPressed (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_PSCHRECK=[[783]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_STOMACH=[[1384]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_SHOTGUN=[[311]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_BAZOOKA=[[776]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_BUILDING=[[1531]] (NUMBER)"] = true,
	["_G.MASK_VISIBLE=[[24705]] (NUMBER)"] = true,
	["_G.CreateSound (FUNCTION)"] = true,
	["_G.ACT_DOD_RELOAD_M1CARBINE=[[894]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_BAR=[[799]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_IN_VEHICLE=[[10]] (NUMBER)"] = true,
	["_G.ACT_DI_ALYX_ZOMBIE_SHOTGUN64=[[416]] (NUMBER)"] = true,
	["_G.ACT_GRENADE_TOSS=[[474]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED=[[534]] (NUMBER)"] = true,
	["_G.ACT_SHOTGUN_IDLE4=[[479]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_30CAL=[[730]] (NUMBER)"] = true,
	["_G.IN_ALT1=[[16384]] (NUMBER)"] = true,
	["_G.ACT_DI_ALYX_ZOMBIE_TORSO_MELEE=[[413]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_SMG1=[[1639]] (NUMBER)"] = true,
	["_G.ACT_DOD_DEPLOY_TOMMY=[[833]] (NUMBER)"] = true,
	["_G.SURF_NOCHOP=[[16384]] (NUMBER)"] = true,
	["_G.STENCILOPERATION_INCR=[[7]] (NUMBER)"] = true,
	["_G.ACT_VM_HAULBACK=[[199]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK_SECONDARY=[[1230]] (NUMBER)"] = true,
	["_G.WorldSound (FUNCTION)"] = true,
	["_G.FCVAR_SERVER_CAN_EXECUTE=[[268435456]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL_HALT=[[55]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_SECONDARYFIRE=[[1138]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_AIM_GREN_STICK=[[752]] (NUMBER)"] = true,
	["_G.ACT_COVER=[[3]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_SLAM=[[1105]] (NUMBER)"] = true,
	["_G.KEY_NUMLOCK=[[69]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_RIFLE=[[634]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_MP40=[[675]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_SMG1=[[1007]] (NUMBER)"] = true,
	["_G.ACT_IDLE_SUITCASE=[[328]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_SLAM=[[1099]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_FORWARD_ZOOMED=[[588]] (NUMBER)"] = true,
	["_G.ACT_DOD_DEPLOYED=[[581]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_RPG=[[1040]] (NUMBER)"] = true,
	["_G.game.RemoveRagdolls (FUNCTION)"] = true,
	["_G.game.CleanUpMap (FUNCTION)"] = true,
	["_G.game.GetMap (FUNCTION)"] = true,
	["_G.EffectData (FUNCTION)"] = true,
	["_G.ACT_LAND=[[33]] (NUMBER)"] = true,
	["_G.MASK_NPCSOLID=[[33701899]] (NUMBER)"] = true,
	["_G.ACT_COMBAT_IDLE=[[109]] (NUMBER)"] = true,
	["_G.OrderVectors (FUNCTION)"] = true,
	["_G.DMG_BULLET=[[2]] (NUMBER)"] = true,
	["_G.CONTENTS_HITBOX=[[1073741824]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_SECONDARY=[[1378]] (NUMBER)"] = true,
	["_G.KEY_P=[[26]] (NUMBER)"] = true,
	["_G.ACT_VM_DRAW_SILENCED=[[497]] (NUMBER)"] = true,
	["_G.SURF_SKY=[[4]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_2=[[578]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_MELEE=[[1304]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_FLINCH_HEAD=[[150]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_TNT=[[982]] (NUMBER)"] = true,
	["_G.debugoverlay.Line (FUNCTION)"] = true,
	["_G.debugoverlay.Cross (FUNCTION)"] = true,
	["_G.debugoverlay.Text (FUNCTION)"] = true,
	["_G.debugoverlay.Sphere (FUNCTION)"] = true,
	["_G.debugoverlay.Box (FUNCTION)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_MG=[[722]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_SECONDARYFIRE=[[1135]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_BAZOOKA=[[773]] (NUMBER)"] = true,
	["_G.ACT_WALK_RELAXED=[[82]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_FG42=[[898]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_SLAM=[[1106]] (NUMBER)"] = true,
	["_G.ACT_RUN_ON_FIRE=[[127]] (NUMBER)"] = true,
	["_G.ACT_SMG2_TOAUTO=[[275]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_PRIMARY=[[1164]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_PSCHRECK=[[793]] (NUMBER)"] = true,
	["_G.DamageInfo (FUNCTION)"] = true,
	["_G.ACT_WALK_CROUCH_RPG=[[354]] (NUMBER)"] = true,
	["_G.GetAddonList (FUNCTION)"] = true,
	["_G.IN_SCORE=[[65536]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_SPADE=[[880]] (NUMBER)"] = true,
	["_G.ACT_TURNRIGHT45=[[459]] (NUMBER)"] = true,
	["_G.RT_SIZE_FULL_FRAME_BUFFER_ROUNDED_UP=[[6]] (NUMBER)"] = true,
	["_G.SURF_TRANS=[[16]] (NUMBER)"] = true,
	["_G.ACT_DOD_ZOOMLOAD_PRONE_PSCHRECK=[[940]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_MELEE=[[1517]] (NUMBER)"] = true,
	["_G.ACT_OBJ_ASSEMBLING=[[462]] (NUMBER)"] = true,
	["_G.ACT_IDLE_SMG1_STIMULATED=[[331]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY=[[543]] (NUMBER)"] = true,
	["_G.isDedicatedServer (FUNCTION)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_PRIMARY=[[1189]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_GREASEGUN=[[896]] (NUMBER)"] = true,
	["_G.DMG_NERVEGAS=[[65536]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH=[[992]] (NUMBER)"] = true,
	["_G.Entity (FUNCTION)"] = true,
	["_G.IN_SPEED=[[131072]] (NUMBER)"] = true,
	["_G.PLAYER_LEAVE_AIMING=[[9]] (NUMBER)"] = true,
	["_G.KEY_Z=[[36]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_PASSIVE=[[1663]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROSSBOW=[[1078]] (NUMBER)"] = true,
	["_G.MOUSE_RIGHT=[[108]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_BUILDING=[[1425]] (NUMBER)"] = true,
	["_G.ACT_RAPPEL_LOOP=[[128]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_BOLT=[[647]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_SLAM=[[1100]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_PRIMARYFIRE_DEPLOYED=[[1134]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_LEFT45_FLAT=[[163]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_KNIFE=[[754]] (NUMBER)"] = true,
	["_G.ACT_BUSY_LEAN_LEFT_EXIT=[[388]] (NUMBER)"] = true,
	["_G.ACT_VM_RELOAD_IDLE=[[519]] (NUMBER)"] = true,
	["_G.STENCILCOMPARISONFUNCTION_ALWAYS=[[8]] (NUMBER)"] = true,
	["_G.ACT_RUN_CROUCH_AIM=[[13]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE_PRIMARY=[[1226]] (NUMBER)"] = true,
	["_G.ACT_VM_ATTACH_SILENCER=[[211]] (NUMBER)"] = true,
	["_G.EFL_NO_THINK_FUNCTION=[[4194304]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_C96=[[632]] (NUMBER)"] = true,
	["_G.FCVAR_DONTRECORD=[[131072]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_PREFIRE=[[1158]] (NUMBER)"] = true,
	["_G.ACT_RUN_RELAXED=[[86]] (NUMBER)"] = true,
	["_G.kRenderFxClampMinScale=[[19]] (NUMBER)"] = true,
	["_G.ACT_CROUCHING_SHIELD_ATTACK=[[457]] (NUMBER)"] = true,
	["_G.PrecacheParticleSystem (FUNCTION)"] = true,
	["_G.ACT_RUN_STIMULATED=[[87]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_BIG_FLINCH=[[145]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_ZOOM_BAZOOKA=[[822]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_SNIPER_RIFLE=[[294]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP=[[996]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_PISTOL=[[616]] (NUMBER)"] = true,
	["_G.Localize (FUNCTION)"] = true,
	["_G.pairs (FUNCTION)"] = true,
	["_G.ACT_VM_DEPLOY_6=[[556]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_PISTOL=[[998]] (NUMBER)"] = true,
	["_G.ACT_DIE_CHESTSHOT=[[114]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_MP44=[[892]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE_MELEE=[[1309]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_FLINCH_RIGHTLEG=[[156]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_DUEL=[[1066]] (NUMBER)"] = true,
	["_G.CompileString (FUNCTION)"] = true,
	["_G.COLLISION_GROUP_PROJECTILE=[[13]] (NUMBER)"] = true,
	["_G.MOUSE_WHEEL_DOWN=[[113]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_PLAYER=[[5]] (NUMBER)"] = true,
	["_G.KEY_PAD_6=[[43]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_PISTOL=[[923]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_GREASE=[[701]] (NUMBER)"] = true,
	["_G.KEY_FIRST=[[0]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_BAR=[[807]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_PISTOL=[[610]] (NUMBER)"] = true,
	["_G.ACT_SMG2_TOBURST=[[276]] (NUMBER)"] = true,
	["_G.ACT_HANDGRENADE_THROW1=[[475]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_ND_IDLE=[[230]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_PREFIRE=[[1155]] (NUMBER)"] = true,
	["_G.string.sub (FUNCTION)"] = true,
	["_G.string.upper (FUNCTION)"] = true,
	["_G.string.len (FUNCTION)"] = true,
	["_G.string.gfind (FUNCTION)"] = true,
	["_G.string.rep (FUNCTION)"] = true,
	["_G.string.find (FUNCTION)"] = true,
	["_G.string.match (FUNCTION)"] = true,
	["_G.string.char (FUNCTION)"] = true,
	["_G.string.dump (FUNCTION)"] = true,
	["_G.string.gmatch (FUNCTION)"] = true,
	["_G.string.reverse (FUNCTION)"] = true,
	["_G.string.byte (FUNCTION)"] = true,
	["_G.string.format (FUNCTION)"] = true,
	["_G.string.gsub (FUNCTION)"] = true,
	["_G.string.lower (FUNCTION)"] = true,
	["_G.ACT_WALK_RIFLE_STIMULATED=[[334]] (NUMBER)"] = true,
	["_G.Vector (FUNCTION)"] = true,
	["_G.ACT_BUSY_LEAN_BACK=[[389]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_DEPLOY_RIFLE=[[836]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_DOWN=[[148]] (NUMBER)"] = true,
	["_G.ACT_WALK_RIFLE_RELAXED=[[332]] (NUMBER)"] = true,
	["_G.CONTENTS_CURRENT_180=[[1048576]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_RIFLE=[[840]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_INTERACTIVE_DEBRIS=[[3]] (NUMBER)"] = true,
	["_G.ACT_WALK_CROUCH_AIM_RIFLE=[[361]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_ATTACK_GRENADE=[[2]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_ZOOM_BOLT=[[817]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_SECONDARY=[[1241]] (NUMBER)"] = true,
	["_G.DynamicLight (FUNCTION)"] = true,
	["_G.PLAYERANIMEVENT_CUSTOM=[[19]] (NUMBER)"] = true,
	["_G.HTTPGet (FUNCTION)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_DUEL=[[1065]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_KNIFE=[[758]] (NUMBER)"] = true,
	["_G.MOVETYPE_PUSH=[[7]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_M1CARBINE=[[912]] (NUMBER)"] = true,
	["_G.WEAPON_PROFICIENCY_POOR=[[0]] (NUMBER)"] = true,
	["_G.OBS_MODE_NONE=[[0]] (NUMBER)"] = true,
	["_G.PLAYER_START_AIMING=[[8]] (NUMBER)"] = true,
	["_G.ACT_TURN=[[461]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_SHOTGUN=[[367]] (NUMBER)"] = true,
	["_G.KEY_0=[[1]] (NUMBER)"] = true,
	["_G.IN_RELOAD=[[8192]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_AGREE=[[1782]] (NUMBER)"] = true,
	["_G.BLOOD_COLOR_ANTLION=[[4]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_TOMMY=[[669]] (NUMBER)"] = true,
	["_G.PATTACH_WORLDORIGIN=[[5]] (NUMBER)"] = true,
	["_G.ACT_STEP_BACK=[[135]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM_AGITATED=[[100]] (NUMBER)"] = true,
	["_G.OBS_MODE_ROAMING=[[6]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_C96=[[864]] (NUMBER)"] = true,
	["_G.HITGROUP_HEAD=[[1]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_PSCHRECK=[[789]] (NUMBER)"] = true,
	["_G.EFL_USE_PARTITION_WHEN_NOT_SOLID=[[262144]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_DUEL=[[1063]] (NUMBER)"] = true,
	["_G.SetGlobalFloat (FUNCTION)"] = true,
	["_G.ACT_GESTURE_MELEE_ATTACK2=[[140]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_5=[[575]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_GREN_FRAG=[[742]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_BAR=[[798]] (NUMBER)"] = true,
	["_G.ACT_SLAM_TRIPMINE_TO_THROW_ND=[[260]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_FIST=[[1624]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE=[[958]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_POSTFIRE=[[1156]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_SHOTGUN=[[1036]] (NUMBER)"] = true,
	["_G.ACT_VM_DEPLOY_1=[[561]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_LEFT90_FLAT=[[165]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_FG42=[[933]] (NUMBER)"] = true,
	["_G.KEY_EQUAL=[[63]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_30CAL=[[727]] (NUMBER)"] = true,
	["_G.DMG_AIRBOAT=[[33554432]] (NUMBER)"] = true,
	["_G.MAT_BLOODYFLESH=[[66]] (NUMBER)"] = true,
	["_G.KEY_9=[[10]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE2_ATTACK=[[1406]] (NUMBER)"] = true,
	["_G.EFL_NOCLIP_ACTIVE=[[4]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_30CAL=[[970]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_RIFLE=[[638]] (NUMBER)"] = true,
	["_G.MATERIAL_FOG_LINEAR_BELOW_FOG_Z=[[2]] (NUMBER)"] = true,
	["_G.HITGROUP_GEAR=[[10]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_RIFLE=[[636]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_MG=[[716]] (NUMBER)"] = true,
	["_G.ACT_PHYSCANNON_ANIMATE_POST=[[406]] (NUMBER)"] = true,
	["_G.ACT_DISARM=[[71]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_PRIMARY_LOOP=[[1184]] (NUMBER)"] = true,
	["_G.Error (FUNCTION)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE1_DRAW=[[1401]] (NUMBER)"] = true,
	["_G.ACT_VM_RELOAD=[[183]] (NUMBER)"] = true,
	["_G.ACT_DI_ALYX_ZOMBIE_SHOTGUN26=[[417]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_GREN_FRAG=[[738]] (NUMBER)"] = true,
	["_G.ACT_DOD_DEPLOY_MG=[[834]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_DEPLOYED=[[1111]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_SMG1=[[308]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_ZOOM_FORWARD_BAZOOKA=[[948]] (NUMBER)"] = true,
	["_G.ACT_POLICE_HARASS1=[[343]] (NUMBER)"] = true,
	["_G.ACT_STRAFE_LEFT=[[39]] (NUMBER)"] = true,
	["_G.RT_SIZE_HDR=[[3]] (NUMBER)"] = true,
	["_G.VGUIFrameTime (FUNCTION)"] = true,
	["_G.KEY_ESCAPE=[[70]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_DEPLOYED=[[591]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_PRONE_MP40=[[857]] (NUMBER)"] = true,
	["_G.MASK_BLOCKLOS=[[16449]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE2_DRAW=[[1404]] (NUMBER)"] = true,
	["_G.ACT_CROUCHING_GRENADEREADY=[[439]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_AR1=[[303]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_DEPLOYED_RIFLE=[[845]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_INTERACTIVE=[[4]] (NUMBER)"] = true,
	["_G.EF_BONEMERGE=[[1]] (NUMBER)"] = true,
	["_G.SF_PHYSBOX_MOTIONDISABLED=[[32768]] (NUMBER)"] = true,
	["_G.tonumber (FUNCTION)"] = true,
	["_G.ACT_UNDEPLOY=[[472]] (NUMBER)"] = true,
	["_G.ACT_VM_SWINGMISS=[[201]] (NUMBER)"] = true,
	["_G.JOYSTICK_FIRST_BUTTON=[[114]] (NUMBER)"] = true,
	["_G.RunString (FUNCTION)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE_MELEE=[[1308]] (NUMBER)"] = true,
	["_G.ACT_WALK_STIMULATED=[[83]] (NUMBER)"] = true,
	["_G.IN_GRENADE1=[[8388608]] (NUMBER)"] = true,
	["_G.MASK_NPCSOLID_BRUSHONLY=[[147467]] (NUMBER)"] = true,
	["_G.ACT_GMOD_IN_CHAT=[[1681]] (NUMBER)"] = true,
	["_G.RunConsoleCommand (FUNCTION)"] = true,
	["_G.ACT_VM_SWINGHARD=[[200]] (NUMBER)"] = true,
	["_G.FCVAR_CHEAT=[[16384]] (NUMBER)"] = true,
	["_G.ACT_DEEPIDLE4=[[517]] (NUMBER)"] = true,
	["_G.CONTENTS_TEAM4=[[512]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_KNIFE=[[963]] (NUMBER)"] = true,
	["_G.GetHUDPanel (FUNCTION)"] = true,
	["_G.ACT_COVER_PISTOL_LOW=[[301]] (NUMBER)"] = true,
	["_G.IsEntity (FUNCTION)"] = true,
	["_G.GESTURE_SLOT_FLINCH=[[4]] (NUMBER)"] = true,
	["_G.MaxPlayers (FUNCTION)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_DEPLOYED=[[590]] (NUMBER)"] = true,
	["_G.DMG_GENERIC=[[0]] (NUMBER)"] = true,
	["_G.CONTENTS_TEAM1=[[2048]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_MG42=[[964]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_30CAL=[[732]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_BAR=[[800]] (NUMBER)"] = true,
	["_G.ACT_CROUCHING_SHIELD_KNOCKBACK=[[458]] (NUMBER)"] = true,
	["_G.EF_NOINTERP=[[8]] (NUMBER)"] = true,
	["_G.ACT_VM_SWINGHIT=[[202]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_MG=[[720]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_PSCHRECK=[[910]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_SPADE=[[765]] (NUMBER)"] = true,
	["_G.ACT_RANGE_AIM_SMG1_LOW=[[298]] (NUMBER)"] = true,
	["_G.SOLID_VPHYSICS=[[6]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_KNIFE=[[879]] (NUMBER)"] = true,
	["_G.MOVECOLLIDE_FLY_SLIDE=[[3]] (NUMBER)"] = true,
	["_G.MOUSE_5=[[111]] (NUMBER)"] = true,
	["_G.ACT_VM_FIDGET=[[175]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_BAR=[[801]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_30CAL=[[870]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_LTRIGGER=[[154]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_PSCHRECK=[[962]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_PISTOL=[[1000]] (NUMBER)"] = true,
	["_G.ACT_RELOAD_SMG1=[[378]] (NUMBER)"] = true,
	["_G.BUTTON_CODE_COUNT=[[172]] (NUMBER)"] = true,
	["_G.ACT_TURN_LEFT=[[43]] (NUMBER)"] = true,
	["_G.PATTACH_CUSTOMORIGIN=[[2]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_KNIFE=[[753]] (NUMBER)"] = true,
	["_G.ACT_VM_SPRINT_ENTER=[[432]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_SECONDARY=[[1248]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD=[[995]] (NUMBER)"] = true,
	["_G.CONTENTS_IGNORE_NODRAW_OPAQUE=[[8192]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_SECONDARY=[[1511]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_PISTOL=[[1005]] (NUMBER)"] = true,
	["_G.IN_JUMP=[[2]] (NUMBER)"] = true,
	["_G.ACT_RUN_AGITATED=[[88]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_PISTOL=[[975]] (NUMBER)"] = true,
	["_G.KEY_F3=[[94]] (NUMBER)"] = true,
	["_G.JOYSTICK_LAST_AXIS_BUTTON=[[161]] (NUMBER)"] = true,
	["_G.module (FUNCTION)"] = true,
	["_G.ACT_OBJ_PLACING=[[467]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_PDA=[[1469]] (NUMBER)"] = true,
	["_G.ACT_DIE_RIGHTSIDE=[[408]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK=[[1116]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_SMG1=[[1008]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_PRONE=[[594]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_C96=[[620]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_BOW=[[1784]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_DEPLOYED_30CAL=[[873]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_MELEE2=[[1679]] (NUMBER)"] = true,
	["_G.MASK_NPCWORLDSTATIC=[[131083]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE=[[603]] (NUMBER)"] = true,
	["_G.xpcall (FUNCTION)"] = true,
	["_G.ACT_MP_AIRWALK_MELEE=[[1293]] (NUMBER)"] = true,
	["_G.KEY_APP=[[87]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_SMG1=[[284]] (NUMBER)"] = true,
	["_G.DMG_REMOVENORAGDOLL=[[4194304]] (NUMBER)"] = true,
	["_G.BUTTON_CODE_LAST=[[171]] (NUMBER)"] = true,
	["_G.ACT_VM_DRYFIRE_SILENCED=[[495]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_GRENADE=[[1642]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_PHYSGUN=[[1076]] (NUMBER)"] = true,
	["_G.ACT_CROUCHING_PRIMARYATTACK=[[440]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_MP40=[[677]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_3=[[540]] (NUMBER)"] = true,
	["_G.LAST_SHARED_COLLISION_GROUP=[[21]] (NUMBER)"] = true,
	["_G.kRenderFxPulseSlow=[[1]] (NUMBER)"] = true,
	["_G.ACT_LEAP=[[32]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM=[[11]] (NUMBER)"] = true,
	["_G.ACT_COWER=[[61]] (NUMBER)"] = true,
	["_G.EFL_HAS_PLAYER_CHILD=[[16]] (NUMBER)"] = true,
	["_G.GetRenderTarget (FUNCTION)"] = true,
	["_G.CONTENTS_CURRENT_0=[[262144]] (NUMBER)"] = true,
	["_G.ACT_BUSY_STAND=[[398]] (NUMBER)"] = true,
	["_G.ACT_SMG2_DRYFIRE2=[[274]] (NUMBER)"] = true,
	["_G.CREATERENDERTARGETFLAGS_AUTOMIPMAP=[[2]] (NUMBER)"] = true,
	["_G.ACT_DRIVE_JEEP=[[1631]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_TOMMY=[[851]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_Y=[[117]] (NUMBER)"] = true,
	["_G.NULL=[[[NULL Entity]]] (ENTITY)"] = true,
	["_G.gmod.GetGamemode (FUNCTION)"] = true,
	["_G.resource.AddSingleFile (FUNCTION)"] = true,
	["_G.resource.AddFile (FUNCTION)"] = true,
	["_G.player.GetAll (FUNCTION)"] = true,
	["_G.player.GetHumans (FUNCTION)"] = true,
	["_G.player.GetBots (FUNCTION)"] = true,
	["_G.player.GetByID (FUNCTION)"] = true,
	["_G.file.FindInLua (FUNCTION)"] = true,
	["_G.file.CreateDir (FUNCTION)"] = true,
	["_G.file.TFind (FUNCTION)"] = true,
	["_G.file.FindDir (FUNCTION)"] = true,
	["_G.file.Find (FUNCTION)"] = true,
	["_G.file.IsDir (FUNCTION)"] = true,
	["_G.file.Time (FUNCTION)"] = true,
	["_G.file.Read (FUNCTION)"] = true,
	["_G.file.Exists (FUNCTION)"] = true,
	["_G.file.Delete (FUNCTION)"] = true,
	["_G.file.Append (FUNCTION)"] = true,
	["_G.file.Write (FUNCTION)"] = true,
	["_G.file.ExistsEx (FUNCTION)"] = true,
	["_G.file.Size (FUNCTION)"] = true,
	["_G.ents.GetAll (FUNCTION)"] = true,
	["_G.ents.FindInSphere (FUNCTION)"] = true,
	["_G.ents.FindByModel (FUNCTION)"] = true,
	["_G.ents.Create (FUNCTION)"] = true,
	["_G.ents.FindInBox (FUNCTION)"] = true,
	["_G.ents.FindByName (FUNCTION)"] = true,
	["_G.ents.GetByIndex (FUNCTION)"] = true,
	["_G.ents.FindByClass (FUNCTION)"] = true,
	["_G.ents.FindInCone (FUNCTION)"] = true,
	["_G.CREATERENDERTARGETFLAGS_UNFILTERABLE_OK=[[4]] (NUMBER)"] = true,
	["_G.MAT_ALIENFLESH=[[72]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_DEPLOYED_PRIMARY=[[1174]] (NUMBER)"] = true,
	["_G.MATERIAL_RT_DEPTH_SEPARATE=[[1]] (NUMBER)"] = true,
	["_G.LerpVector (FUNCTION)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_TOMMY=[[908]] (NUMBER)"] = true,
	["_G.RT_SIZE_OFFSCREEN=[[5]] (NUMBER)"] = true,
	["_G.RT_SIZE_PICMIP=[[2]] (NUMBER)"] = true,
	["_G.RT_SIZE_DEFAULT=[[1]] (NUMBER)"] = true,
	["_G.ACT_VM_DEPLOY_4=[[558]] (NUMBER)"] = true,
	["_G.assert (FUNCTION)"] = true,
	["_G.ACT_GESTURE_FLINCH_BLAST_SHOTGUN=[[147]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_MP44=[[858]] (NUMBER)"] = true,
	["_G.RT_SIZE_NO_CHANGE=[[0]] (NUMBER)"] = true,
	["_G.EFL_NO_PHYSCANNON_INTERACTION=[[1073741824]] (NUMBER)"] = true,
	["_G.EFL_NO_MEGAPHYSCANNON_RAGDOLL=[[268435456]] (NUMBER)"] = true,
	["_G.EFL_NO_DISSOLVE=[[134217728]] (NUMBER)"] = true,
	["_G.ACT_DIESIMPLE=[[20]] (NUMBER)"] = true,
	["_G.EFL_DONTBLOCKLOS=[[33554432]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_END=[[1148]] (NUMBER)"] = true,
	["_G.EFL_CHECK_UNTOUCH=[[16777216]] (NUMBER)"] = true,
	["_G.SysTime (FUNCTION)"] = true,
	["_G.KEY_LWIN=[[85]] (NUMBER)"] = true,
	["_G.ACT_CROUCHIDLE_STIMULATED=[[102]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_UP=[[146]] (NUMBER)"] = true,
	["_G.MASK_CURRENT=[[16515072]] (NUMBER)"] = true,
	["_G.EFL_IS_BEING_LIFTED_BY_BARNACLE=[[1048576]] (NUMBER)"] = true,
	["_G.EFL_IN_SKYBOX=[[131072]] (NUMBER)"] = true,
	["_G.EFL_DIRTY_SPATIAL_PARTITION=[[32768]] (NUMBER)"] = true,
	["_G.EFL_DIRTY_SURROUNDING_COLLISION_BOUNDS=[[16384]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_PDA=[[1475]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_DISSOLVING=[[16]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_ZOOM_PSCHRECK=[[827]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_BOLT=[[649]] (NUMBER)"] = true,
	["_G.BLOOD_COLOR_RED=[[0]] (NUMBER)"] = true,
	["_G.GetConVar (FUNCTION)"] = true,
	["_G.EFL_DIRTY_ABSTRANSFORM=[[2048]] (NUMBER)"] = true,
	["_G.EFL_NO_AUTO_EDICT_ATTACH=[[1024]] (NUMBER)"] = true,
	["_G.EFL_SERVER_ONLY=[[512]] (NUMBER)"] = true,
	["_G.EFL_BOT_FROZEN=[[256]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_5=[[529]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_RIFLE=[[642]] (NUMBER)"] = true,
	["_G.ACT_FIRE_END=[[437]] (NUMBER)"] = true,
	["_G.EFL_NOTIFY=[[64]] (NUMBER)"] = true,
	["_G.EFL_SETTING_UP_BONES=[[8]] (NUMBER)"] = true,
	["_G.EFL_KILLME=[[1]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH=[[1376]] (NUMBER)"] = true,
	["_G.ACT_FLINCH_PHYSICS=[[124]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM=[[7]] (NUMBER)"] = true,
	["_G.MAT_FOLIAGE=[[79]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_8=[[544]] (NUMBER)"] = true,
	["_G.MAT_CLIP=[[73]] (NUMBER)"] = true,
	["_G.MATERIAL_RT_DEPTH_ONLY=[[3]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_CROUCH_SPADE=[[951]] (NUMBER)"] = true,
	["_G.MAT_FLESH=[[70]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_IDLE=[[242]] (NUMBER)"] = true,
	["_G.MAT_EGGSHELL=[[69]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND=[[1143]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_MP44=[[687]] (NUMBER)"] = true,
	["_G.kRenderFxGlowShell=[[18]] (NUMBER)"] = true,
	["_G.kRenderFxExplode=[[17]] (NUMBER)"] = true,
	["_G.kRenderFxDistort=[[15]] (NUMBER)"] = true,
	["_G.IN_CANCEL=[[64]] (NUMBER)"] = true,
	["_G.kRenderFxNoDissipation=[[14]] (NUMBER)"] = true,
	["_G.VERSION=[[126]] (NUMBER)"] = true,
	["_G.KEY_BREAK=[[78]] (NUMBER)"] = true,
	["_G.kRenderFxFlickerSlow=[[12]] (NUMBER)"] = true,
	["_G.kRenderFxStrobeFaster=[[11]] (NUMBER)"] = true,
	["_G.kRenderFxStrobeFast=[[10]] (NUMBER)"] = true,
	["_G.kRenderFxStrobeSlow=[[9]] (NUMBER)"] = true,
	["_G.kRenderFxSolidFast=[[8]] (NUMBER)"] = true,
	["_G.kRenderFxSolidSlow=[[7]] (NUMBER)"] = true,
	["_G.kRenderFxFadeFast=[[6]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_PASSABLE_DOOR=[[15]] (NUMBER)"] = true,
	["_G.kRenderFxFadeSlow=[[5]] (NUMBER)"] = true,
	["_G.kRenderFxPulseFastWide=[[4]] (NUMBER)"] = true,
	["_G.kRenderFxNone=[[0]] (NUMBER)"] = true,
	["_G.GESTURE_SLOT_CUSTOM=[[6]] (NUMBER)"] = true,
	["_G.GESTURE_SLOT_VCD=[[5]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_ZOOM_RIFLE=[[812]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_30CAL=[[729]] (NUMBER)"] = true,
	["_G.GESTURE_SLOT_GRENADE=[[1]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_CANCEL_RELOAD=[[39]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_CUSTOM_GESTURE_SEQUENCE=[[22]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_CUSTOM_SEQUENCE=[[21]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_TO_TRIPMINE_ND=[[241]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_TO_THROW=[[239]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_SNAP_YAW=[[18]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_SPAWN=[[17]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_DOUBLEJUMP=[[15]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_BAZOOKA=[[775]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_GRENADE=[[1054]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_FLINCH_LEFTLEG=[[13]] (NUMBER)"] = true,
	["_G.KEY_A=[[11]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_RIGHT_SHOULDER=[[119]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN=[[991]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_FLINCH_CHEST=[[9]] (NUMBER)"] = true,
	["_G.CONTENTS_SLIME=[[16]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_DIE=[[8]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_ND_DRAW=[[238]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_RIGHT=[[158]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_RIFLE=[[640]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_PASSIVE=[[1662]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_PASSIVE=[[1666]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_RELOAD_END=[[5]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM=[[602]] (NUMBER)"] = true,
	["_G.MASK_VISIBLE_AND_NPCS=[[33579137]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_C96=[[629]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_BOLT=[[655]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_RELOAD_LOOP=[[4]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_AR2=[[1019]] (NUMBER)"] = true,
	["_G.ACT_MP_VCD=[[1127]] (NUMBER)"] = true,
	["_G.ACT_FLY=[[25]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_C96=[[623]] (NUMBER)"] = true,
	["_G.ACT_VM_HITCENTER=[[191]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_BOLT=[[652]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_RELOAD=[[3]] (NUMBER)"] = true,
	["_G.ACT_VM_MISSLEFT2=[[194]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_CROSSBOW=[[1080]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_GRENADE=[[1142]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_PLAYER_MOVEMENT=[[8]] (NUMBER)"] = true,
	["_G.ACT_180_RIGHT=[[130]] (NUMBER)"] = true,
	["_G.Angle (FUNCTION)"] = true,
	["_G.Msg (FUNCTION)"] = true,
	["_G.PLAYERANIMEVENT_ATTACK_PRIMARY=[[0]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_PRONE_BOLT=[[849]] (NUMBER)"] = true,
	["_G.MATERIAL_QUADS=[[7]] (NUMBER)"] = true,
	["_G.MATERIAL_POLYGON=[[6]] (NUMBER)"] = true,
	["_G.ACT_PRONE_IDLE=[[513]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_PHYSGUN=[[1641]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE2_DRAW=[[1392]] (NUMBER)"] = true,
	["_G.ACT_VM_DEPLOY_7=[[555]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_ZOOM_RIFLE=[[809]] (NUMBER)"] = true,
	["_G.ACT_IDLE_AIM_STIMULATED=[[91]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RELOAD=[[382]] (NUMBER)"] = true,
	["_G.MatrixFromAngle (FUNCTION)"] = true,
	["_G.MATERIAL_TRIANGLE_STRIP=[[3]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_RELAXED=[[94]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_STICK1=[[122]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_DEPLOYED=[[592]] (NUMBER)"] = true,
	["_G.KeyValuesToTable (FUNCTION)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_MELEE=[[1379]] (NUMBER)"] = true,
	["_G.STENCILOPERATION_KEEP=[[1]] (NUMBER)"] = true,
	["_G.BOX_BOTTOM=[[5]] (NUMBER)"] = true,
	["_G.MATERIAL_CULLMODE_CW=[[1]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_MELEE2=[[1677]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_MELEE=[[1297]] (NUMBER)"] = true,
	["_G.ACT_IDLE_AIM_AGITATED=[[92]] (NUMBER)"] = true,
	["_G.GetGlobalVector (FUNCTION)"] = true,
	["_G.ACT_HL2MP_IDLE_PISTOL=[[997]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_GREASE=[[705]] (NUMBER)"] = true,
	["_G.ACT_POLICE_HARASS2=[[344]] (NUMBER)"] = true,
	["_G.ParticleEmitter (FUNCTION)"] = true,
	["_G.MATERIAL_FOG_NONE=[[0]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_START=[[121]] (NUMBER)"] = true,
	["_G.FCVAR_CLIENTCMD_CAN_EXECUTE=[[1073741824]] (NUMBER)"] = true,
	["_G.STENCILCOMPARISONFUNCTION_GREATER=[[5]] (NUMBER)"] = true,
	["_G._VERSION=[[Lua 5.1]] (STRING)"] = true,
	["_G.SOLID_BSP=[[1]] (NUMBER)"] = true,
	["_G.STENCILCOMPARISONFUNCTION_NOTEQUAL=[[6]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_TOMMY=[[659]] (NUMBER)"] = true,
	["_G.KEY_Y=[[35]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_LOWERED=[[204]] (NUMBER)"] = true,
	["_G.NewMesh (FUNCTION)"] = true,
	["_G.ACT_IDLE_ANGRY_MELEE=[[347]] (NUMBER)"] = true,
	["_G.STENCILCOMPARISONFUNCTION_EQUAL=[[3]] (NUMBER)"] = true,
	["_G.CONTENTS_CURRENT_90=[[524288]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_MP40=[[680]] (NUMBER)"] = true,
	["_G.STENCILCOMPARISONFUNCTION_NEVER=[[1]] (NUMBER)"] = true,
	["_G.ACT_PLAYER_IDLE_FIRE=[[500]] (NUMBER)"] = true,
	["_G.STENCILOPERATION_DECR=[[8]] (NUMBER)"] = true,
	["_G.ACT_OVERLAY_SHIELD_DOWN=[[445]] (NUMBER)"] = true,
	["_G.STENCILOPERATION_INCRSAT=[[4]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START_BUILDING=[[1432]] (NUMBER)"] = true,
	["_G.STENCILOPERATION_ZERO=[[2]] (NUMBER)"] = true,
	["_G.MOVECOLLIDE_COUNT=[[4]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM_STEALTH_PISTOL=[[375]] (NUMBER)"] = true,
	["_G.MATERIAL_POINTS=[[0]] (NUMBER)"] = true,
	["_G.BLOOD_COLOR_ANTLION_WORKER=[[6]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_PISTOL=[[607]] (NUMBER)"] = true,
	["_G.DMG_PARALYZE=[[32768]] (NUMBER)"] = true,
	["_G.ACT_VM_HOLSTER=[[173]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_END=[[1145]] (NUMBER)"] = true,
	["_G.ACT_TURNLEFT45=[[460]] (NUMBER)"] = true,
	["_G.BLOOD_COLOR_MECH=[[3]] (NUMBER)"] = true,
	["_G.KEY_RWIN=[[86]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_RIGHTARM=[[1386]] (NUMBER)"] = true,
	["_G.RenderAngles (FUNCTION)"] = true,
	["_G.ACT_RUN_HURT=[[106]] (NUMBER)"] = true,
	["_G.DONT_BLEED=[[-1]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN_BUILDING=[[1427]] (NUMBER)"] = true,
	["_G.ACT_FLINCH_STOMACH=[[119]] (NUMBER)"] = true,
	["_G.PATTACH_POINT_FOLLOW=[[4]] (NUMBER)"] = true,
	["_G.PATTACH_POINT=[[3]] (NUMBER)"] = true,
	["_G.PATTACH_ABSORIGIN_FOLLOW=[[1]] (NUMBER)"] = true,
	["_G.ACT_RESET=[[0]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_MP44=[[978]] (NUMBER)"] = true,
	["_G.MASK_SHOT_PORTAL=[[33570819]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_SHOTGUN=[[1034]] (NUMBER)"] = true,
	["_G.ACT_WALK_ANGRY=[[342]] (NUMBER)"] = true,
	["_G.STEPSOUNDTIME_WATER_FOOT=[[3]] (NUMBER)"] = true,
	["_G.HITGROUP_RIGHTLEG=[[7]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_4=[[567]] (NUMBER)"] = true,
	["_G.STEPSOUNDTIME_WATER_KNEE=[[2]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT=[[1121]] (NUMBER)"] = true,
	["_G.STEPSOUNDTIME_NORMAL=[[0]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT=[[1496]] (NUMBER)"] = true,
	["_G.SavePresets (FUNCTION)"] = true,
	["_G.FVPHYSICS_NO_SELF_COLLISIONS=[[32768]] (NUMBER)"] = true,
	["_G.ACT_WALK_ON_FIRE=[[126]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_C96=[[625]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_SILENCED=[[493]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL_LEFT=[[56]] (NUMBER)"] = true,
	["_G.ACT_HOVER=[[26]] (NUMBER)"] = true,
	["_G.ACT_DOD_PLANT_TNT=[[987]] (NUMBER)"] = true,
	["_G.FVPHYSICS_NO_PLAYER_PICKUP=[[128]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE_SECONDARY=[[1258]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_TOMMY=[[671]] (NUMBER)"] = true,
	["_G.FCVAR_SERVER_CANNOT_QUERY=[[536870912]] (NUMBER)"] = true,
	["_G.ACT_USE=[[48]] (NUMBER)"] = true,
	["_G.ACT_RELOAD_SHOTGUN=[[380]] (NUMBER)"] = true,
	["_G.FVPHYSICS_PART_OF_RAGDOLL=[[8]] (NUMBER)"] = true,
	["_G.KEY_RALT=[[82]] (NUMBER)"] = true,
	["_G.ACT_SMG2_FIRE2=[[271]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_VEHICLE_CLIP=[[12]] (NUMBER)"] = true,
	["_G.FVPHYSICS_DMG_SLICE=[[1]] (NUMBER)"] = true,
	["_G.ACT_90_RIGHT=[[132]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_SPADE=[[766]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_PRIMARYFIRE=[[1133]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_FIST=[[1647]] (NUMBER)"] = true,
	["_G.KEY_END=[[75]] (NUMBER)"] = true,
	["_G.ACT_VM_RECOIL1=[[206]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_GREASE=[[708]] (NUMBER)"] = true,
	["_G.ACT_IDLE_PACKAGE=[[326]] (NUMBER)"] = true,
	["_G.ConVarExists (FUNCTION)"] = true,
	["_G.GetGlobalString (FUNCTION)"] = true,
	["_G.ACT_SIGNAL_FORWARD=[[53]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM=[[604]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_DUEL=[[1061]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_ZOOM_PSCHRECK=[[828]] (NUMBER)"] = true,
	["_G.ACT_GLOCK_SHOOTEMPTY=[[480]] (NUMBER)"] = true,
	["_G.SURF_HINT=[[256]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_CROUCH_TOMMY=[[956]] (NUMBER)"] = true,
	["_G.KEY_S=[[29]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_SHOTGUN=[[1030]] (NUMBER)"] = true,
	["_G.MASK_DEADSOLID=[[65547]] (NUMBER)"] = true,
	["_G.os.clock (FUNCTION)"] = true,
	["_G.os.difftime (FUNCTION)"] = true,
	["_G.os.time (FUNCTION)"] = true,
	["_G.os.date (FUNCTION)"] = true,
	["_G.ACT_HL2MP_RUN_DUEL=[[1059]] (NUMBER)"] = true,
	["_G.ACT_READINESS_PISTOL_RELAXED_TO_STIMULATED_WALK=[[423]] (NUMBER)"] = true,
	["_G.tostring (FUNCTION)"] = true,
	["_G.SURF_NOSHADOWS=[[4096]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_DUEL=[[1058]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_GREN_STICK=[[877]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_DUEL=[[1057]] (NUMBER)"] = true,
	["_G.IN_LEFT=[[128]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_WAVE=[[1787]] (NUMBER)"] = true,
	["_G.ACT_ITEM_THROW=[[1634]] (NUMBER)"] = true,
	["_G.GetGamemodes (FUNCTION)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_MP40=[[855]] (NUMBER)"] = true,
	["_G.CONTENTS_OPAQUE=[[128]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_DEPLOYED_MG=[[944]] (NUMBER)"] = true,
	["_G.ACT_GMOD_GESTURE_BECON=[[1783]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_ML=[[283]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_ZOOM_BOLT=[[819]] (NUMBER)"] = true,
	["_G.ACT_WALK_RPG=[[352]] (NUMBER)"] = true,
	["_G.ACT_BUSY_LEAN_BACK_EXIT=[[391]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM_RIFLE_STIMULATED=[[338]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK=[[994]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_SLAM=[[314]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_MELEE_ATTACK_SWING=[[318]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_MELEE2=[[1680]] (NUMBER)"] = true,
	["_G.ACT_READINESS_STIMULATED_TO_RELAXED=[[421]] (NUMBER)"] = true,
	["_G.DOFModeHack (FUNCTION)"] = true,
	["_G.ACT_DOD_WALK_IDLE_30CAL=[[733]] (NUMBER)"] = true,
	["_G.WEAPON_PROFICIENCY_PERFECT=[[4]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_8=[[526]] (NUMBER)"] = true,
	["_G.achievements.SpawnedProp (FUNCTION)"] = true,
	["_G.achievements.Remover (FUNCTION)"] = true,
	["_G.achievements.Count (FUNCTION)"] = true,
	["_G.achievements.IncBystander (FUNCTION)"] = true,
	["_G.achievements.GetDesc (FUNCTION)"] = true,
	["_G.achievements.GetGoal (FUNCTION)"] = true,
	["_G.achievements.GetName (FUNCTION)"] = true,
	["_G.achievements.SpawnMenuOpen (FUNCTION)"] = true,
	["_G.achievements.IncBaddies (FUNCTION)"] = true,
	["_G.achievements.IncGoodies (FUNCTION)"] = true,
	["_G.achievements.GetCount (FUNCTION)"] = true,
	["_G.achievements.IsAchieved (FUNCTION)"] = true,
	["_G.achievements.SpawnedNPC (FUNCTION)"] = true,
	["_G.achievements.BalloonPopped (FUNCTION)"] = true,
	["_G.achievements.SpawnedRagdoll (FUNCTION)"] = true,
	["_G.achievements.EatBall (FUNCTION)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_MELEE2=[[1675]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_SMALL_FLINCH=[[144]] (NUMBER)"] = true,
	["_G.ACT_PLAYER_CROUCH_WALK_FIRE=[[502]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_THROW=[[316]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_MELEE2=[[1672]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_STIMULATED=[[95]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_MELEE2=[[1671]] (NUMBER)"] = true,
	["_G.LerpAngle (FUNCTION)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_DEPLOYED_RIFLE=[[844]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_PASSIVE=[[1667]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_SECONDARYFIRE=[[1141]] (NUMBER)"] = true,
	["_G.BroadcastLua (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_MG=[[719]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_PASSIVE=[[1661]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_KNIFE=[[1660]] (NUMBER)"] = true,
	["_G.DMG_DISSOLVE=[[67108864]] (NUMBER)"] = true,
	["_G.ACT_CLIMB_UP=[[34]] (NUMBER)"] = true,
	["_G.ACT_CROSSBOW_FIDGET_UNLOADED=[[488]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE=[[1656]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_ZOOM_BAZOOKA=[[824]] (NUMBER)"] = true,
	["_G.CreateConVar (FUNCTION)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_PRIMARY_END=[[1194]] (NUMBER)"] = true,
	["_G.ACT_WALK_AGITATED=[[84]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_PRIMARY=[[1505]] (NUMBER)"] = true,
	["_G.ACT_IDLE_ANGRY=[[76]] (NUMBER)"] = true,
	["_G.DMG_ENERGYBEAM=[[1024]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_6=[[565]] (NUMBER)"] = true,
	["_G.FCVAR_NOT_CONNECTED=[[4194304]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_AR2=[[1640]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_FIST=[[1627]] (NUMBER)"] = true,
	["_G.SURF_NODRAW=[[128]] (NUMBER)"] = true,
	["_G.KEY_SCROLLLOCK=[[71]] (NUMBER)"] = true,
	["_G.KEY_PAD_1=[[38]] (NUMBER)"] = true,
	["_G.ACT_DIE_BACKSIDE=[[409]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_KNIFE=[[757]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_SMG1_LOW=[[285]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_FIST=[[1625]] (NUMBER)"] = true,
	["_G.print (FUNCTION)"] = true,
	["_G.ACT_HL2MP_IDLE_GRENADE=[[1047]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_TOMMY=[[670]] (NUMBER)"] = true,
	["_G.EFL_FORCE_CHECK_TRANSMIT=[[128]] (NUMBER)"] = true,
	["_G.KEY_C=[[13]] (NUMBER)"] = true,
	["_G.ACT_RELOAD_START=[[67]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_FIST=[[1622]] (NUMBER)"] = true,
	["_G.CONTENTS_WINDOW=[[2]] (NUMBER)"] = true,
	["_G.language.Add (FUNCTION)"] = true,
	["_G.ACT_HL2MP_JUMP_MELEE=[[1094]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_SHOTGUN=[[1033]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_FIST=[[1620]] (NUMBER)"] = true,
	["_G.ACT_SIGNAL_TAKECOVER=[[58]] (NUMBER)"] = true,
	["_G.DMG_DROWNRECOVER=[[524288]] (NUMBER)"] = true,
	["_G.DMG_SHOCK=[[256]] (NUMBER)"] = true,
	["_G.ACT_STEP_LEFT=[[133]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_MELEE=[[1091]] (NUMBER)"] = true,
	["_G.GetAddonInfo (FUNCTION)"] = true,
	["_G.ACT_HL2MP_IDLE_FIST=[[1618]] (NUMBER)"] = true,
	["_G.ACT_WALK_CARRY=[[427]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_1=[[570]] (NUMBER)"] = true,
	["_G.ACT_VM_HITRIGHT=[[189]] (NUMBER)"] = true,
	["_G.ACT_DIEBACKWARD=[[21]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_MELEE=[[1645]] (NUMBER)"] = true,
	["_G.ACT_RUN_CROUCH_RPG=[[355]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_MG=[[715]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_SECONDARYFIRE=[[1131]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_6=[[528]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RELOAD_SMG1=[[384]] (NUMBER)"] = true,
	["_G.ACT_DIE_BACKSHOT=[[116]] (NUMBER)"] = true,
	["_G.DMG_BLAST=[[64]] (NUMBER)"] = true,
	["_G.ACT_ROLL_LEFT=[[41]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_SHOTGUN=[[1638]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_BOLT=[[846]] (NUMBER)"] = true,
	["_G.KEY_XSTICK1_UP=[[153]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_SECONDARY=[[1510]] (NUMBER)"] = true,
	["_G.ACT_ITEM_GIVE=[[1636]] (NUMBER)"] = true,
	["_G.ACT_ITEM_PLACE=[[1635]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_THROW=[[244]] (NUMBER)"] = true,
	["_G.ACT_ITEM_DROP=[[1633]] (NUMBER)"] = true,
	["_G.ACT_READINESS_PISTOL_AGITATED_TO_STIMULATED=[[424]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_GREASE=[[698]] (NUMBER)"] = true,
	["_G.ACT_IDLE_MELEE=[[346]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_BUILDING=[[1536]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_RIFLE_STIMULATED=[[337]] (NUMBER)"] = true,
	["_G.DMG_ALWAYSGIB=[[8192]] (NUMBER)"] = true,
	["_G.MOUSE_LAST=[[113]] (NUMBER)"] = true,
	["_G.ACT_IDLE_SMG1=[[320]] (NUMBER)"] = true,
	["_G.DMG_SLASH=[[4]] (NUMBER)"] = true,
	["_G.ACT_VM_MISSCENTER2=[[198]] (NUMBER)"] = true,
	["_G.ACT_SLAM_TRIPMINE_IDLE=[[255]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_PDA=[[1537]] (NUMBER)"] = true,
	["_G.KEY_PAD_MINUS=[[49]] (NUMBER)"] = true,
	["_G.LAST_SHARED_ACTIVITY=[[1842]] (NUMBER)"] = true,
	["_G.SoundDuration (FUNCTION)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODYES_BUILDING=[[1535]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_BUILDING=[[1533]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_NODNO_MELEE=[[1518]] (NUMBER)"] = true,
	["_G.ACT_SHIELD_UP=[[449]] (NUMBER)"] = true,
	["_G.ACT_WALK_RIFLE=[[358]] (NUMBER)"] = true,
	["_G.ACT_PLAYER_RUN_FIRE=[[504]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_EMPTY=[[552]] (NUMBER)"] = true,
	["_G.ACT_MELEE_ATTACK_SWING=[[296]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_MELEE=[[1513]] (NUMBER)"] = true,
	["_G.SetClipboardText (FUNCTION)"] = true,
	["_G.ACT_RANGE_ATTACK_AR2_LOW=[[280]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_AIM_GREN_FRAG=[[744]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_TOMMY=[[664]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_1=[[533]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_DETONATOR_HOLSTER=[[253]] (NUMBER)"] = true,
	["_G.ACT_BARNACLE_CHEW=[[170]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_PISTOL=[[1637]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FISTPUMP_SECONDARY=[[1509]] (NUMBER)"] = true,
	["_G.GetMountableContent (FUNCTION)"] = true,
	["_G.ACT_RANGE_ATTACK_HMG1=[[282]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_HANDMOUTH_SECONDARY=[[1507]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_ND_IDLE=[[243]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_PSCHRECK=[[972]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_PRIMARY=[[1502]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_ND_ATTACH=[[233]] (NUMBER)"] = true,
	["_G.HITGROUP_RIGHTARM=[[5]] (NUMBER)"] = true,
	["_G.ACT_GLIDE=[[27]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_MP44=[[686]] (NUMBER)"] = true,
	["_G.ACT_WALK_CROUCH_AIM=[[9]] (NUMBER)"] = true,
	["_G.vgui.GetWorldPanel (FUNCTION)"] = true,
	["_G.vgui.CursorVisible (FUNCTION)"] = true,
	["_G.vgui.GetKeyboardFocus (FUNCTION)"] = true,
	["_G.vgui.FocusedHasParent (FUNCTION)"] = true,
	["_G.vgui.Create (FUNCTION)"] = true,
	["_G.vgui.IsHoveringWorld (FUNCTION)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP=[[1498]] (NUMBER)"] = true,
	["_G.DMG_PHYSGUN=[[8388608]] (NUMBER)"] = true,
	["_G.CONTENTS_MONSTER=[[33554432]] (NUMBER)"] = true,
	["_G.ACT_RUN_STEALTH_PISTOL=[[366]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_5=[[566]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_TOMMY=[[977]] (NUMBER)"] = true,
	["_G.EFL_DIRTY_ABSVELOCITY=[[4096]] (NUMBER)"] = true,
	["_G.IN_BACK=[[16]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_PDA=[[1474]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM_RELAXED=[[98]] (NUMBER)"] = true,
	["_G.SURF_LIGHT=[[1]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_PDA=[[1473]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_PDA=[[1471]] (NUMBER)"] = true,
	["_G.KEY_F11=[[102]] (NUMBER)"] = true,
	["_G.GetHostName (FUNCTION)"] = true,
	["_G.ACT_FLINCH_RIGHTARM=[[121]] (NUMBER)"] = true,
	["_G.DMG_SLOWBURN=[[2097152]] (NUMBER)"] = true,
	["_G.ACT_MP_AIRWALK_BUILDING=[[1429]] (NUMBER)"] = true,
	["_G.BUTTON_CODE_NONE=[[0]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_AGITATED=[[96]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_PDA=[[1464]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE_BUILDING=[[1441]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_WEAPON=[[11]] (NUMBER)"] = true,
	["_G.MASK_SHOT_HULL=[[100679691]] (NUMBER)"] = true,
	["_G.KEY_F12=[[103]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_GRENADE_BUILDING=[[1440]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_GREN_STICK=[[745]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_BUILDING=[[1437]] (NUMBER)"] = true,
	["_G.BOX_FRONT=[[0]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_SLAM=[[291]] (NUMBER)"] = true,
	["_G.BLOOD_COLOR_GREEN=[[2]] (NUMBER)"] = true,
	["_G.ACT_MP_SECONDARY_GRENADE1_ATTACK=[[1403]] (NUMBER)"] = true,
	["_G.ACT_VM_HITLEFT2=[[188]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_8=[[572]] (NUMBER)"] = true,
	["_G.KEY_NONE=[[0]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK_BUILDING=[[1430]] (NUMBER)"] = true,
	["_G.ACT_MP_WALK_BUILDING=[[1428]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE2_ATTACK=[[1412]] (NUMBER)"] = true,
	["_G.ACT_DOD_ZOOMLOAD_PRONE_BAZOOKA=[[938]] (NUMBER)"] = true,
	["_G.ACT_MP_MELEE_GRENADE1_IDLE=[[1408]] (NUMBER)"] = true,
	["_G.SURF_SKIP=[[512]] (NUMBER)"] = true,
	["_G.CreateClientConVar (FUNCTION)"] = true,
	["_G.KEY_F5=[[96]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_GRENADE=[[1056]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_STEALTH=[[97]] (NUMBER)"] = true,
	["_G.KEY_2=[[3]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_PHYSGUN=[[1067]] (NUMBER)"] = true,
	["_G.ACT_MP_PRIMARY_GRENADE2_ATTACK=[[1400]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_BAZOOKA=[[883]] (NUMBER)"] = true,
	["_G.ACT_LOOKBACK_RIGHT=[[59]] (NUMBER)"] = true,
	["_G.ACT_DI_ALYX_HEADCRAB_MELEE=[[414]] (NUMBER)"] = true,
	["_G.ACT_HOP=[[31]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_RIGHTLEG=[[1388]] (NUMBER)"] = true,
	["_G.CONTENTS_LADDER=[[536870912]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_LEFTLEG=[[1387]] (NUMBER)"] = true,
	["_G.ACT_DOD_DEPLOY_30CAL=[[835]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_MP40=[[856]] (NUMBER)"] = true,
	["_G.ACT_VICTORY_DANCE=[[112]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_DUEL=[[1060]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_GREASEGUN=[[931]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_CHEST=[[1383]] (NUMBER)"] = true,
	["_G.getfenv (FUNCTION)"] = true,
	["_G.KEY_F10=[[101]] (NUMBER)"] = true,
	["_G.FCVAR_DEMO=[[65536]] (NUMBER)"] = true,
	["_G.MAT_GLASS=[[89]] (NUMBER)"] = true,
	["_G.DMG_BUCKSHOT=[[536870912]] (NUMBER)"] = true,
	["_G.ACT_WALK_PACKAGE=[[327]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_PRIMARY=[[1377]] (NUMBER)"] = true,
	["_G.ACT_IDLE_STEALTH_PISTOL=[[325]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_RIGHT45=[[160]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_STAND_MELEE_SECONDARY=[[1301]] (NUMBER)"] = true,
	["_G.JOYSTICK_LAST=[[161]] (NUMBER)"] = true,
	["_G.ACT_BARNACLE_CHOMP=[[169]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCHWALK_MELEE=[[1294]] (NUMBER)"] = true,
	["_G.ACT_VM_DRAW=[[172]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_PISTOL=[[289]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_MELEE=[[1290]] (NUMBER)"] = true,
	["_G.ACT_MP_STAND_MELEE=[[1289]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_CROUCH_GRENADE_SECONDARY=[[1259]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_SLAM=[[1646]] (NUMBER)"] = true,
	["_G.require (FUNCTION)"] = true,
	["_G.ACT_DOD_HS_CROUCH_STICKGRENADE=[[976]] (NUMBER)"] = true,
	["_G.ACT_BUSY_SIT_CHAIR_ENTRY=[[396]] (NUMBER)"] = true,
	["_G.ACT_DOD_ZOOMLOAD_BAZOOKA=[[915]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_SECONDARY_END=[[1247]] (NUMBER)"] = true,
	["_G.ACT_RUN_CROUCH_AIM_RIFLE=[[365]] (NUMBER)"] = true,
	["_G.SURF_BUMPLIGHT=[[2048]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_DEBRIS=[[1]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_PSCHRECK=[[885]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK2=[[17]] (NUMBER)"] = true,
	["_G.MASK_SOLID_BRUSHONLY=[[16395]] (NUMBER)"] = true,
	["_G.SetMaterialOverride (FUNCTION)"] = true,
	["_G.ACT_DOD_PRONE_AIM_GREASE=[[703]] (NUMBER)"] = true,
	["_G.Player (FUNCTION)"] = true,
	["_G.NamedColor (FUNCTION)"] = true,
	["_G.ACT_180_LEFT=[[129]] (NUMBER)"] = true,
	["_G.setfenv (FUNCTION)"] = true,
	["_G.ACT_MP_CROUCHWALK_PRIMARY=[[1167]] (NUMBER)"] = true,
	["_G.KEY_BACKSLASH=[[61]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_C96=[[624]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_FLINCH_LEFTARM=[[153]] (NUMBER)"] = true,
	["_G.FCVAR_UNLOGGED=[[2048]] (NUMBER)"] = true,
	["_G.ACT_RANGE_ATTACK_SHOTGUN_LOW=[[288]] (NUMBER)"] = true,
	["_G.LAST_VISIBLE_CONTENTS=[[128]] (NUMBER)"] = true,
	["_G.ACT_IDLE=[[1]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_6=[[537]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM_PRIMARY_END=[[1191]] (NUMBER)"] = true,
	["_G.ACT_OVERLAY_SHIELD_UP_IDLE=[[446]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK1_LOW=[[141]] (NUMBER)"] = true,
	["_G.ACT_CROUCHING_SHIELD_UP_IDLE=[[456]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_PRIMARY=[[1186]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_PRIMARY_END=[[1185]] (NUMBER)"] = true,
	["_G.IsFirstTimePredicted (FUNCTION)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_PRIMARY=[[1182]] (NUMBER)"] = true,
	["_G.ACT_RUN_RPG=[[353]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_MG=[[717]] (NUMBER)"] = true,
	["_G.ACT_VM_DEPLOY_8=[[554]] (NUMBER)"] = true,
	["_G.MOVETYPE_CUSTOM=[[11]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_BAZOOKA=[[937]] (NUMBER)"] = true,
	["_G.FCVAR_ARCHIVE=[[128]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_BOLT=[[646]] (NUMBER)"] = true,
	["_G.ScrW (FUNCTION)"] = true,
	["_G.JOYSTICK_FIRST_AXIS_BUTTON=[[150]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_PRIMARY=[[1163]] (NUMBER)"] = true,
	["_G.ClientCallGamemode (FUNCTION)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_POSTFIRE=[[1161]] (NUMBER)"] = true,
	["_G.ACT_TRIPMINE_GROUND=[[491]] (NUMBER)"] = true,
	["_G.ACT_IDLE_STIMULATED=[[78]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_NPC_ACTOR=[[18]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_PREFIRE=[[1160]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_PSCHRECK=[[782]] (NUMBER)"] = true,
	["_G.ACT_RUN_CROUCH_RIFLE=[[364]] (NUMBER)"] = true,
	["_G.IN_ZOOM=[[524288]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_BAR=[[930]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_SWIM=[[1149]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_CROUCH_LOOP=[[1147]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_IDLE_PISTOL=[[965]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_LOOP=[[1144]] (NUMBER)"] = true,
	["_G.MAT_DIRT=[[68]] (NUMBER)"] = true,
	["_G.ACT_VM_PICKUP=[[209]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK2=[[138]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_AIRWALK_PRIMARYFIRE=[[1140]] (NUMBER)"] = true,
	["_G.ACT_MP_ATTACK_SWIM_GRENADE=[[1139]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_GREASE=[[710]] (NUMBER)"] = true,
	["_G.ACT_DOD_IDLE_ZOOMED=[[583]] (NUMBER)"] = true,
	["_G.Material (FUNCTION)"] = true,
	["_G.MOVETYPE_VPHYSICS=[[6]] (NUMBER)"] = true,
	["_G.ACT_MP_DEPLOYED=[[1125]] (NUMBER)"] = true,
	["_G.ACT_WALK_STEALTH=[[85]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_FLINCH_BLAST_DAMAGED=[[148]] (NUMBER)"] = true,
	["_G.BOTTOM=[[5]] (NUMBER)"] = true,
	["_G.HITGROUP_STOMACH=[[3]] (NUMBER)"] = true,
	["_G.KEY_NUMLOCKTOGGLE=[[105]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_THUMBSUP_MELEE=[[1516]] (NUMBER)"] = true,
	["_G.ACT_IDLE_ANGRY_RPG=[[350]] (NUMBER)"] = true,
	["_G.STEPSOUNDTIME_ON_LADDER=[[1]] (NUMBER)"] = true,
	["_G.KEY_LSHIFT=[[79]] (NUMBER)"] = true,
	["_G.AddCSLuaFile (FUNCTION)"] = true,
	["_G.KEY_R=[[28]] (NUMBER)"] = true,
	["_G.ACT_DIE_FRONTSIDE=[[407]] (NUMBER)"] = true,
	["_G.ACT_MP_SWIM_PRIMARY=[[1172]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_START=[[1120]] (NUMBER)"] = true,
	["_G.ParseParticleManifest (FUNCTION)"] = true,
	["_G.ACT_SLAM_STICKWALL_DETONATE=[[235]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_CROUCH_GREN_STICK=[[954]] (NUMBER)"] = true,
	["_G.ACT_MP_RUN=[[1114]] (NUMBER)"] = true,
	["_G.ACT_LOOKBACK_LEFT=[[60]] (NUMBER)"] = true,
	["_G.ACT_MP_CROUCH_DEPLOYED_IDLE=[[1110]] (NUMBER)"] = true,
	["_G.GetGlobalFloat (FUNCTION)"] = true,
	["_G.ACT_HL2MP_GESTURE_RELOAD_RPG=[[1043]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_SLAM=[[1101]] (NUMBER)"] = true,
	["_G.ACT_WALK_AIM_STEALTH_PISTOL=[[374]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_BAR=[[804]] (NUMBER)"] = true,
	["_G.MATERIAL_LINE_LOOP=[[5]] (NUMBER)"] = true,
	["_G.KEY_F2=[[93]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_MELEE=[[1089]] (NUMBER)"] = true,
	["_G.ACT_VM_RELOAD_DEPLOYED=[[518]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_VC_FINGERPOINT_SECONDARY=[[1508]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_MELEE=[[1087]] (NUMBER)"] = true,
	["_G.ACT_DOD_SPRINT_IDLE_30CAL=[[735]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_CROSSBOW=[[1084]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_PHYSGUN=[[1074]] (NUMBER)"] = true,
	["_G.MAT_PLASTIC=[[76]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_8=[[535]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_PHYSGUN=[[1070]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_30CAL=[[726]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_GRENADE=[[1049]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_STAND_SECONDARY_END=[[1244]] (NUMBER)"] = true,
	["_G.ACT_VM_FIZZLE=[[1107]] (NUMBER)"] = true,
	["_G.ErrorNoHalt (FUNCTION)"] = true,
	["_G.ACT_SPRINT=[[507]] (NUMBER)"] = true,
	["_G.ACT_VM_DEPLOY_3=[[559]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_SHOTGUN=[[1031]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_MP40=[[682]] (NUMBER)"] = true,
	["_G.error (FUNCTION)"] = true,
	["_G.ACT_DOD_RUN_AIM_GREN_FRAG=[[741]] (NUMBER)"] = true,
	["_G.KEY_PAD_2=[[39]] (NUMBER)"] = true,
	["_G.DMG_CLUB=[[128]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_PISTOL=[[613]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_TOMMY=[[850]] (NUMBER)"] = true,
	["_G.IN_GRENADE2=[[16777216]] (NUMBER)"] = true,
	["_G.SOLID_OBB=[[3]] (NUMBER)"] = true,
	["_G.EF_PARENT_ANIMATES=[[512]] (NUMBER)"] = true,
	["_G.ACT_CROUCHIDLE=[[46]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2=[[1022]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT_CROSSBOW=[[1644]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_CROUCH_AR2=[[1020]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_JUMP_PISTOL=[[1004]] (NUMBER)"] = true,
	["_G.SOLID_BBOX=[[2]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_PISTOL=[[1001]] (NUMBER)"] = true,
	["_G.ACT_DOD_HS_CROUCH_MG42=[[974]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SIT=[[1628]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_ZOOM_BAZOOKA=[[823]] (NUMBER)"] = true,
	["_G.type (FUNCTION)"] = true,
	["_G.MOVETYPE_STEP=[[3]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_HEAD=[[1382]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_BREAKABLE_GLASS=[[6]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_TO_STICKWALL_ND=[[251]] (NUMBER)"] = true,
	["_G.DMG_PREVENT_PHYSICS_FORCE=[[2048]] (NUMBER)"] = true,
	["_G.IN_MOVELEFT=[[512]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_PISTOL=[[611]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE=[[989]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_SECONDARY=[[1235]] (NUMBER)"] = true,
	["_G.ACT_FLINCH_LEFTARM=[[120]] (NUMBER)"] = true,
	["_G.ACT_MP_GRENADE1_ATTACK=[[1391]] (NUMBER)"] = true,
	["_G.ACT_FIRE_START=[[435]] (NUMBER)"] = true,
	["_G.KEY_COUNT=[[107]] (NUMBER)"] = true,
	["_G.ACT_VM_USABLE_TO_UNUSABLE=[[1548]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_BAZOOKA=[[778]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_SHOTGUN=[[1035]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_IDLE_RPG=[[1045]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_30CAL=[[728]] (NUMBER)"] = true,
	["_G.ACT_JUMP=[[30]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_BACK=[[120]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_CROSSBOW=[[1086]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_RUN_MELEE2=[[1673]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_THROW2=[[245]] (NUMBER)"] = true,
	["_G.BOX_LEFT=[[3]] (NUMBER)"] = true,
	["_G.IN_FORWARD=[[8]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_AIM_MP44=[[685]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_BARNACLE_STRANGLE=[[402]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_RPG=[[1046]] (NUMBER)"] = true,
	["_G.CONTENTS_CURRENT_DOWN=[[8388608]] (NUMBER)"] = true,
	["_G.IsVector (FUNCTION)"] = true,
	["_G.ACT_HL2MP_SWIM_PISTOL=[[1006]] (NUMBER)"] = true,
	["_G.EyeVector (FUNCTION)"] = true,
	["_G.KEY_XSTICK2_LEFT=[[157]] (NUMBER)"] = true,
	["_G.ACT_RUN_RPG_RELAXED=[[357]] (NUMBER)"] = true,
	["_G.ACT_DOD_STAND_IDLE_TOMMY=[[665]] (NUMBER)"] = true,
	["_G.math.log (FUNCTION)"] = true,
	["_G.math.acos (FUNCTION)"] = true,
	["_G.math.huge=[[1.#INF]] (NUMBER)"] = true,
	["_G.math.ldexp (FUNCTION)"] = true,
	["_G.math.pi=[[3.1415926535898]] (NUMBER)"] = true,
	["_G.math.cos (FUNCTION)"] = true,
	["_G.math.tanh (FUNCTION)"] = true,
	["_G.math.pow (FUNCTION)"] = true,
	["_G.math.deg (FUNCTION)"] = true,
	["_G.math.tan (FUNCTION)"] = true,
	["_G.math.cosh (FUNCTION)"] = true,
	["_G.math.sinh (FUNCTION)"] = true,
	["_G.math.random (FUNCTION)"] = true,
	["_G.math.randomseed (FUNCTION)"] = true,
	["_G.math.frexp (FUNCTION)"] = true,
	["_G.math.ceil (FUNCTION)"] = true,
	["_G.math.floor (FUNCTION)"] = true,
	["_G.math.rad (FUNCTION)"] = true,
	["_G.math.abs (FUNCTION)"] = true,
	["_G.math.sqrt (FUNCTION)"] = true,
	["_G.math.modf (FUNCTION)"] = true,
	["_G.math.asin (FUNCTION)"] = true,
	["_G.math.min (FUNCTION)"] = true,
	["_G.math.max (FUNCTION)"] = true,
	["_G.math.fmod (FUNCTION)"] = true,
	["_G.math.log10 (FUNCTION)"] = true,
	["_G.math.atan2 (FUNCTION)"] = true,
	["_G.math.exp (FUNCTION)"] = true,
	["_G.math.sin (FUNCTION)"] = true,
	["_G.math.atan (FUNCTION)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_RIFLE=[[842]] (NUMBER)"] = true,
	["_G.TOP=[[4]] (NUMBER)"] = true,
	["_G.ACT_RUN_AIM_PISTOL=[[372]] (NUMBER)"] = true,
	["_G.MAT_COMPUTER=[[80]] (NUMBER)"] = true,
	["_G.FCVAR_CLIENTDLL=[[8]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_IDLE_SLAM=[[1097]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE_PISTOL=[[617]] (NUMBER)"] = true,
	["_G.FrameNumber (FUNCTION)"] = true,
	["_G.ACT_DOD_WALK_ZOOMED=[[584]] (NUMBER)"] = true,
	["_G.ACT_DOD_SECONDARYATTACK_CROUCH=[[955]] (NUMBER)"] = true,
	["_G.KEY_MINUS=[[62]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_DETONATOR_HOLSTER=[[236]] (NUMBER)"] = true,
	["_G.ACT_MP_GESTURE_FLINCH_LEFTARM=[[1385]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_C96=[[865]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_MP40=[[928]] (NUMBER)"] = true,
	["_G.ACT_STAND=[[47]] (NUMBER)"] = true,
	["_G.FCVAR_REPLICATED=[[8192]] (NUMBER)"] = true,
	["_G.ACT_SHOTGUN_IDLE_DEEP=[[478]] (NUMBER)"] = true,
	["_G.ACT_DEPLOY_IDLE=[[471]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_DEPLOYED_BAR=[[922]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_DEPLOYED_MG34=[[921]] (NUMBER)"] = true,
	["_G.ACT_PHYSCANNON_DETACH=[[403]] (NUMBER)"] = true,
	["_G.GESTURE_SLOT_JUMP=[[2]] (NUMBER)"] = true,
	["_G.ACT_RELOAD=[[66]] (NUMBER)"] = true,
	["_G.ACT_RUN_RIFLE_STIMULATED=[[335]] (NUMBER)"] = true,
	["_G.ACT_IDLE_RPG_RELAXED=[[348]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_CROUCH_MP40=[[907]] (NUMBER)"] = true,
	["_G.CONTENTS_AUX=[[4]] (NUMBER)"] = true,
	["_G.GetConVarString (FUNCTION)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_PRONE_BAR=[[887]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_MP40=[[674]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_DETONATE=[[252]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_DEPLOYED_30CAL=[[872]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRIMARYATTACK_MP40=[[854]] (NUMBER)"] = true,
	["_G.ACT_SLAM_DETONATOR_STICKWALL_DRAW=[[265]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_ZOOM_BAZOOKA=[[825]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_WALK_CROUCH_KNIFE=[[1655]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_ZOOM_RIFLE=[[813]] (NUMBER)"] = true,
	["_G.ACT_PHYSCANNON_ANIMATE=[[404]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_FLINCH_BLAST=[[146]] (NUMBER)"] = true,
	["_G.KEY_F8=[[99]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_LEFT=[[157]] (NUMBER)"] = true,
	["_G.ACT_VM_IDLE_DEPLOYED_1=[[542]] (NUMBER)"] = true,
	["_G.ACT_BUSY_LEAN_LEFT=[[386]] (NUMBER)"] = true,
	["_G.EFL_NO_ROTORWASH_PUSH=[[2097152]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_PSCHRECK=[[786]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_NPC_SCRIPTED=[[19]] (NUMBER)"] = true,
	["_G.DMG_POISON=[[131072]] (NUMBER)"] = true,
	["_G.FCVAR_UNREGISTERED=[[1]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_AIM_SPADE=[[763]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_SPADE=[[762]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_FLOAT_BUILDING=[[1433]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_AIM_KNIFE=[[756]] (NUMBER)"] = true,
	["_G.ACT_HL2MP_SWIM_MELEE=[[1096]] (NUMBER)"] = true,
	["_G.HITGROUP_GENERIC=[[0]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_TOMMY=[[663]] (NUMBER)"] = true,
	["_G.KEY_U=[[31]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_RANGE_ATTACK_AR2=[[304]] (NUMBER)"] = true,
	["_G.GetMountedContent (FUNCTION)"] = true,
	["_G.ACT_DOD_WALK_AIM_GREN_FRAG=[[740]] (NUMBER)"] = true,
	["_G.MOVETYPE_FLY=[[4]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_MG=[[712]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_AIM_GREASE=[[702]] (NUMBER)"] = true,
	["_G.SOLID_OBB_YAW=[[4]] (NUMBER)"] = true,
	["_G.ACT_GESTURE_TURN_RIGHT90_FLAT=[[166]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONEWALK_IDLE_MP44=[[697]] (NUMBER)"] = true,
	["_G.KEY_DOWN=[[90]] (NUMBER)"] = true,
	["_G.ACT_DOD_WALK_IDLE_MP40=[[681]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCH_IDLE_BOLT=[[653]] (NUMBER)"] = true,
	["_G.ACT_RUN_SCARED=[[111]] (NUMBER)"] = true,
	["_G.PLAYERANIMEVENT_CUSTOM_GESTURE=[[20]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_IDLE=[[229]] (NUMBER)"] = true,
	["_G.ACT_DOD_PRONE_AIM_PISTOL=[[612]] (NUMBER)"] = true,
	["_G.CONTENTS_ORIGIN=[[16777216]] (NUMBER)"] = true,
	["_G.ACT_DOD_RUN_IDLE=[[605]] (NUMBER)"] = true,
	["_G.GetTooltipText (FUNCTION)"] = true,
	["_G.ACT_DOD_CROUCH_AIM_30CAL=[[725]] (NUMBER)"] = true,
	["_G.ACT_VM_UNDEPLOY_4=[[548]] (NUMBER)"] = true,
	["_G.ACT_DOD_CROUCHWALK_IDLE_RIFLE=[[641]] (NUMBER)"] = true,
	["_G.KEY_XBUTTON_RTRIGGER=[[155]] (NUMBER)"] = true,
	["_G.KEY_SCROLLLOCKTOGGLE=[[106]] (NUMBER)"] = true,
	["_G.KEY_RSHIFT=[[80]] (NUMBER)"] = true,
	["_G.ACT_IDLE_SHOTGUN_STIMULATED=[[340]] (NUMBER)"] = true,
	["_G.KEY_1=[[2]] (NUMBER)"] = true,
	["_G.ACT_DOD_RELOAD_PRONE_GARAND=[[924]] (NUMBER)"] = true,
	["_G.ACT_VM_DRYFIRE_LEFT=[[499]] (NUMBER)"] = true,
	["_G.ACT_MP_RELOAD_AIRWALK_PRIMARY=[[1192]] (NUMBER)"] = true,
	["_G.ACT_VM_RELOAD_SILENCED=[[494]] (NUMBER)"] = true,
	["_G.ACT_GRENADE_ROLL=[[473]] (NUMBER)"] = true,
	["_G.ACT_SLAM_DETONATOR_DRAW=[[262]] (NUMBER)"] = true,
	["_G.ACT_OBJ_RUNNING=[[465]] (NUMBER)"] = true,
	["_G.ACT_READINESS_RELAXED_TO_STIMULATED_WALK=[[419]] (NUMBER)"] = true,
	["_G.CONTENTS_DETAIL=[[134217728]] (NUMBER)"] = true,
	["_G.KEY_F1=[[92]] (NUMBER)"] = true,
	["_G.KEY_PAD_DIVIDE=[[47]] (NUMBER)"] = true,
	["_G.ACT_BUSY_SIT_GROUND_EXIT=[[394]] (NUMBER)"] = true,
	["_G.KEY_Q=[[27]] (NUMBER)"] = true,
	["_G.ACT_VM_PRIMARYATTACK_DEPLOYED_6=[[574]] (NUMBER)"] = true,
	["_G.ACT_MP_JUMP_LAND_BUILDING=[[1434]] (NUMBER)"] = true,
	["_G.LoadPresets (FUNCTION)"] = true,
	["_G.FILL=[[1]] (NUMBER)"] = true,
	["_G.CONTENTS_EMPTY=[[0]] (NUMBER)"] = true,
	["_G.ACT_SLAM_THROW_TO_TRIPMINE_ND=[[254]] (NUMBER)"] = true,
	["_G.ACT_SLAM_STICKWALL_ATTACH=[[231]] (NUMBER)"] = true,
	["_G.COLLISION_GROUP_PUSHAWAY=[[17]] (NUMBER)"] = true,
}



local White_GUseless = {
	"_G._G",
	"_G._E",
	"_G._R",
	"_G._CG",
	"_G.SCRIPTNAME",
	"_G.SCRIPTPATH",
	"_G.package.config",
	"_G.SpawniconGenFunctions",
	"_G.sql.m_pData",
	"_G.HACCredits",
	"_G.GM.Folder",
	"_G.GM.FolderName",
	"_G.VERSION",
}



local Black_RQTab = {
	["syshack"]			= false,
	["scriptdump"]		= false,
	["frostbot"]		= false,
	["eradicate"]		= false,
	["bandsox"]	 		= false,
	["aah"]	 			= false,
	["qq"]	 			= false,
}



local Black_RPF = {
	"includes/modules/gmcl_dispatchum.dll",
	"includes/modules/gmcl_bandsox.dll",
	"includes/modules/gmcl_ox.dll",
	"includes/modules/gmcl_lymes.dll",
	"includes/modules/gmcl_limes.dll",
	"includes/modules/gmcl_obelus.dll",
	"includes/modules/gm_obelus.dll",
	"includes/modules/gm_qq.dll",
	"includes/modules/gmcl_qq.dll",
	"includes/modules/gmcl_aah.dll",
	"includes/modules/gm_aah.dll",
	"includes/modules/gmcl_coldfire.dll",
	"menu_plugins/coldfire.lua",
	"menu_plugins/bandsox.lua",
	"includes/modules/gm_filesystem.dll",
	
	"includes/modules/syshack.dll",
	"includes/modules/gm_syshack.dll",
	"includes/modules/gmcl_syshack.dll",
}



local Black_Addons = {
	"turbobot",
	"ColdFire",
	"genesisbot",
	"Thermhack",
	"Thermbot",
	"FapHack",
	"Hermes",
	"NeonHack",
	"BaconBot",
	"Tee Bot Release",
	"Asb",
	"Eusion's Script Package",
	"Trooper Hack",
	"[GzF]Hacks",
	"[GzF]Hacks ViP Beta V1.02",
	"[GzF] Aimbot",
	"[GzF]Hacks V2",	
	"[THEODORE]",
	"Simple Hack",
	"Name Generator",
	"BaconBot_V4",
	"bbot",
}



local Black_CLDB = {
	"SHV2_Binds",
	"SHV3_Binds",
	"SHV4_Binds",
	
	"SHV2_Configs",
	"SHV3_Configs",
	"SHV4_Configs",
	
	"SHV2_ESPEnts",
	"SHV3_ESPEnts",
	"SHV4_ESPEnts",
	
	"SHV2_Options",
	"SHV3_Options",
	"SHV4_Options",
	
	"bc_ips",
	
	"Bacon_Friends",
	"Bacon_Ents",
	"Bacon_ESPEnts",
	"Bacon_Changelog",
	"Bacon_Pass2",
	"SethHackV2_Options",
	"SethHackV2_ESPEnts",
	"SethHack_Friends",
	"SethHack_Ents",
	"SethHack_ESPEnts",
	"Spencer_Friends",
	"Spencer_Ents",
	"Spencer_ESPEnts",
}



local Black_AddonsKW = {
	"hack",
	"convar",
	"cvar",
	"hax",
	"luamd5",
	"scriptenf",
}



local Black_CVars = {
	"_ihack_esp",
	"_ihack_esp_npcs",
	"_ihack_esp_players",
	"_ihack_esp_weapons",
	"_ihack_esp_charms",
	"_ihack_esp_laser",
	"_ihack_aimbot_ignoreplayers",
	"_ihack_aimbot_ignorenpcs",
	"_ihack_aimbot_ignorefriends",
	"_ihack_aimbot_ignoreadmins",
	"_ihack_aimbot_friendlyfire",
	"_ihack_aimbot_auto",
	"_ihack_aimbot_fakeview",
	"_ihack_aimbot_nospread",
	"_ihack_misc_alwaysnospread",
	"_ihack_misc_fov",
	"_ihack_misc_disconnectmsg",
	"_ihack_ttt_showbodys",
	"_ihack_ttt_ignorefellowdetectives",
	"_ihack_ttt_ignorefellowtraitors",
	"Aim_Enabled",
	"Aim_NoRecoil",
	"Misc_Spam",
	"AC_Misc_Bhop",
	"Coma_Misc_LogIPs",
	"Coma_Misc_ULXAntiGag",
	"Coma_Misc_Date",
	"Coma_Misc_Spammer",
	"Coma_SlowSpeedHack",
	"Coma_SH_CheatsOff",
	"Coma_SHSpeed",
	"Coma_HostFrameRate",
	"Coma_HostTimeScale",
	"Coma_AimBot_SmoothAim",
	"Coma_AimBot_SmoothAimSpeed",
	"Coma_AimBot_Autoshoot",
	"Coma_AimBot_NoRecoil",
	"Coma_AimBot_NoSpread",
	"Coma_AimBot_IgnoreSteamFriends",
	"Coma_AimBot_IgnoreAdmins",
	"Coma_AimBot_FriendlyFire",
	"Coma_AimBot_IgnoreTraitorFriends",
	"SB_Aim_Enabled",
	"hake_shouldrun",
	"SB_Aim_FF",
	"SB_Aim_Offset",
	"SB_Aim_Steam",
	"SB_Aim_NoRecoil",
	"SB_Misc_Spam",
	"fhack",
	"fhackmodel",
	"fhackrage",
	"anthrax_killonsight",
	"anthrax_velocitypredict",
	"Smelly_Misc_LogIPs",
	"metalslave_aimbot_enabled",
	"mh_ab_enabled",
	"mh_ab_ffa",
	"mh_ab_nospread",
	"mh_ab_priority",
	"mh_ab_fov",
	"mh_ab_offset",
	"mh_ab_auto",
	"mh_esp_enabled",
	"mh_esp_mode",
	"mh_esp_names",
	"mh_esp_health",
	"mh_esp_reveal",
	"mh_esp_revent",
	"mh_esp_fov",
	"mh_rearview",
	"mh_ungag",
	"cf_host_timescale",
	"cf_aim_enabled",
	"cf_bunnyhop_minspeed",
	"cf_lockdownlua",
	"cf_checkdormantplayers",
	"cf_bunnyhopspace",
	"cf_bunnyhop",
	"cf_collectgarbage",
	"cf_pingpredict",
	"cf_updatemenucomponents",
	"cf_logs_level",
	"cf_logs_enabled",
	"cf_traitormode",
	"cf_spinbot",
	"cf_esp_drawcrosshair",
	"cf_esp_usesmallerfont",
	"cf_esp_drawtextinfo",
	"cf_esp_drawweapons",
	"cf_esp_drawmodels",
	"cf_esp_outlinemodels",
	"cf_esp_draweyeangles",
	"cf_esp_minespdistance",
	"cf_esp_maxespdistance",
	"cf_esp_entitytransparencydiameter",
	"cf_esp_entitytranspare",
	"cf_esp_enabled",
	"cf_esp_onlydrawtraitors",
	"cf_aim_nospreadonfire",
	"cf_aim_ucmdfire",
	"cf_aim_snaponfiretime",
	"cf_aim_snaponfire",
	"cf_aim_offsetz",
	"cf_aim_predictionseed",
	"cf_aim_nospread",
	"cf_aim_enemymode",
	"cf_aim_autoreload",
	"cf_aim_autofire",
	"cf_aim_checkpartialhits",
	"cf_aim_fakeview",
	"cf_aim_antisnapspeed",
	"cf_aim_antisnap",
	"cf_aim_velocityprediction",
	"cf_aim_ignorelos",
	"cf_aim_maxangledifference",
	"cf_aim_bonemode",
	"cf_aim_targetmode",
	"cf_aim_onlytargettraitors",
	"cf_aim_targetsteamfriends",
	"cf_aim_targetadmins",
	"cf_aim_targetfriends",
	"cf_aim_friendlyfire",
	"cf_aim_targetnpcs",
	"cf_aim_maxdistance",
	"cf_aim_enabled",
	"Isis_Esp",
	"Isis_Esp_Health",
	"Isis_Esp_Box",
	"Isis_Esp_Warnings",
	"Isis_Esp_Traitor",
	"Isis_Esp_Admins",
	"Isis_Esp_ShowC4",
	"Isis_Esp_Chams",
	"Isis_Misc_AntiGag",
	"Isis_Misc_ShowStatus",
	"Isis_Misc_Bunnyhop",
	"Isis_Misc_RemoveSky",
	"Isis_Misc_Crosshair",
	"Isis_Aimbot_NoRecoil",
	"Isis_Aimbot_IgnoreSteam",
	"Isis_Aimbot_Friendlyfire",
	"Isis_Aimbot_FixView",
	"Isis_Aimbot_AutoShoot",
	"Isis_Aimbot_NoSpread",
	"Isis_Aimbot_Offset",
	"Isis_Aimbot_AimSpot",
	"Isis_Speedhack_Speed",
	"Isis_Other_AutoReminder",
	"qq_ttt_predict_nade",
	"qq_antiaim_mode",
	"qq_fakeview_enabled",
	"qq_debug",
	"aah_log",
	"aah_logpath",
	"aah_blockac",
	"aah_bypassse",
	"aah_hash",
	"DragonBot_Esp",
	"DragonBot_Esp_Health",
	"DragonBot_Esp_Distance",
	"DragonBot_Esp_Admin",
	"DragonBot_Bhop",
	"DragonBot_Rp_Esp",
	"DragonBot_Chams",
	"DragonBot_Line",
	"DragonBot_Light",
	"DragonBot_Trigger",
	"DragonBot_TTT",
	"DragonBot_Aimbot_IgnoreSteam",
	"DragonBot_Aimbot_Friendlyfire",
	"DragonBot_Aimbot_IgnoreAdmins",
	"DragonBot_SmoothAim_Enabled",
	"DragonBot_Smooth_Speed",
	"DragonBot_Aimbot_Norecoil",
	"DragonBot_AimKeySave",
	"DragonBot_MenuKeySave",
	"DragonBot_PropKeySave",
	"triggerbot_enabled",
	"aimbot_enabled",
	"asb_bone",
	"asb_fov",
	"asb_los",
	"asb_players",
	"asb_shoot",
	"asb_trigger",
	"sw_aim",
	"sw_norecoil",
	"sw_aimonfire",
	"sh_aim",
	"sh_aimonfire",
	"sh_norecoil",
	"anacletobot",
	"anacletobot_target",
	"anacletobot_maxdist",
	"+ares_aim",
	"ink_propkill",
	"sh_print_traitors",
	"Ares_Misc_Bhop",
	"Ares_Misc_Keypad",
	"Ares_Misc_LogIPs",
	"Ares_Misc_ULXAntiGag",
	"Ares_Traitor",
	"Ares_ESP_C4Detection",
	"Ares_SlowSpeedHack",
	"Ares_SH_CheatsOff",
	"Ares_SHSpeed",
	"Ares_HostFrameRate",
	"Ares_HostTimeScale",
	"Ares_AimBot_SmoothAim",
	"Ares_AimBot_SmoothAimSpeed",
	"Ares_AimBot_Autoshoot",
	"Ares_AimBot_NoRecoil",
	"Ares_AimBot_NoSpread",
	"Ares_AimBot_IgnoreSteamFriends",
	"Ares_AimBot_IgnoreAdmins",
	"Ares_AimBot_FriendlyFire",
	"Ares_AimBot_IgnoreTraitorFriends",
	"ms_host_timescale",
	"ms_sv_cheats",
	"MAim_Targetmode",
	"MAim_MaxDistance",
	"MAim_MaxAngle",
	"MAim_FF",
	"MAim_Autoshoot",
	"MAim_MissShots",
	"MAim_Antisnap",
	"MAim_AntisnapSpeed",
	"M_Norecoil",
	"M_NoSpread",
	"speedhack_speed",
	"x_enabled",
	"Hax_NameTags",
	"Hax_SaveView",
	"Hax_ShowCrosshair",
	"Hax_ShowCrosshair2",
	"Hax_WallHackStyle",
	"Hax_SmoothAim",
	"Hax_SmoothAimSpeed",
	"Hax_DrawParticles",
	"Hax_TriggerBot",
	"Hax_TriggerBot2",
	"Hax_IgnoreSteamFriends",
	"Hax_MaxWallHackDist",
	"Hax_IgnoreTeam",
	"Hax_AimFov",
	"TB_AimFov",
	"TB_AimTeam",
	"TB_NameTags",
	"TB_NTAdmin",
	"TB_NTHealth",
	"TB_NTAlpha",
	"TB_FakeView",
	"TB_TargetPlayers",
	"TB_TargetNPCs",
	"TB_AntiSnap",
	"TB_AntiSnapSpeed",
	"AimAssistSA",
	"AimAssistFV",
	"ATTargetPlayers",
	"ATTargetNPCs",
	"ATIgnoreSteam",
	"ATIgnoreDistance",
	"ATAimDistance",
	"ATWallHack",
	"ATAimRadius",
	"ATNPCNames",
	"h_sv_cheats",
	"h_host_timescale",
	"h_host_framerate",
	"lymes_enable_hack_killhead_shotter",
	"lymes_enable_seethrough_esphack",
	"lymes_remotelua_hake",
	"lymes_remotelua_hack",
	"lymes_enable_autoheadshoot",
	"Neon_AimBot_ShowAimStatus",
	"Neon_AimBot_SmoothAimEnabled",
	"Neon_AimBot_SmoothAimSpeed",
	"Neon_AimBot_IgnoreFriends",
	"Neon_AimBot_IgnoreAdmins",
	"Neon_AimBot_Friendlyfire",
	"Neon_AimBot_NoRecoil",
	"Neon_AimBot_AimOffset",
	"Neon_AimBot_AimBone",
	"Neon_AimBot_AimMode",
	"Neon_AimBot_IgnoreSteamFriends",
	"Neon_PlayerESP",
	"Neon_PlayerESP_Health",
	"Neon_PlayerESP_ShowAll",
	"Neon_NPCESP",
	"Neon_PlayerFullBright",
	"Neon_PlayerWireFrame",
	"Neon_MoneyPrinterESP",
	"Neon_MoneyESP",
	"Neon_ShipmentESP",
	"Neon_FullBright",
	"Neon_Gray",
	"Neon_WorldWireFrame",
	"Neon_PlayerBox",
	"Neon_Bhop",
	"Neon_ULXAntiGag",
	"Neon_NikeSpeed",
	"Neon_HostTimeScale",
	"Neon_SpeedHack_CheatsOff",
	"Neon_Traitor",
	"Neon_KeypadHack",
	"Neon_WeaponsESP",
	"Neon_AimBot_TriggerBot",
	"Neon_PlayerWallHackFull",
	"Neon_DynamicLight",
	"Neon_DynamicLightSize",
	"Neon_LogPlayerIPs",
	"Neon_CrossHair",
	"Neon_CrossHair_Red",
	"Neon_CrossHair_Green",
	"Neon_CrossHair_Blue",
	"Neon_C4Detection",
	"hermes_misc_antiaimr_antiaim",
	"hermes_misc_antiaimy_antiaim",
	"hermes_misc_antiaimp_antiaim",
	"hermes_misc_antiaimduck_antiaim",
	"hermes_misc_antiaimrandom_antiaim",
	"hermes_misc_antiaim_antiaim",
	"hermes_misc_zoomamount_zoom",
	"hermes_misc_zoomontrigger_zoom",
	"hermes_misc_zoomonaim_zoom",
	"hermes_misc_zoomalways_zoom",
	"hermes_misc_zoom_zoom",
	"hermes_misc_speedhackspeed_speedhack",
	"hermes_misc_speedhack_speedhack",
	"hermes_misc_particles_globals",
	"hermes_misc_fullbrightg_globals",
	"hermes_misc_radarradius_radar",
	"hermes_misc_radarspin_radar",
	"hermes_misc_radarname_radar",
	"hermes_misc_radar_radar",
	"hermes_misc_crosshairlength_crosshair",
	"hermes_misc_crosshairgap_crosshair",
	"hermes_misc_crosshair_crosshair",
	"hermes_misc_crosshairtype_crosshair",
	"hermes_misc_ulxantigag_misc",
	"hermes_misc_autopistol_misc",
	"hermes_misc_bunnyhop_misc",
	"hermes_misc_namesteal_misc",
	"hermes_esp_asusval_asus",
	"hermes_esp_asusmdl_asus",
	"hermes_esp_asus_asus",
	"hermes_esp_visiblechams_chams",
	"hermes_esp_fullbright_chams",
	"hermes_esp_walltype_chams",
	"hermes_esp_vehiclese_entities",
	"hermes_esp_ragdollse_entities",
	"hermes_esp_weaponse_entities",
	"hermes_esp_entityliste_entities",
	"hermes_esp_enablee_entities",
	"hermes_esp_boxn_npcs",
	"hermes_esp_enablen_npcs",
	"hermes_esp_adminlist_players",
	"hermes_esp_friendsmark_players",
	"hermes_esp_barrel_players",
	"hermes_esp_weapon_players",
	"hermes_esp_health_players",
	"hermes_esp_name_players",
	"hermes_esp_enemyonly_players",
	"hermes_esp_enable_players",
	"hermes_esp_optical_players",
	"hermes_esp_fadelength_general",
	"hermes_esp_maxshow_general",
	"hermes_esp_enablefade_general",
	"hermes_esp_font_general",
	"hermes_aim_novisspread_accuracy",
	"hermes_aim_norecoil_accuracy",
	"hermes_aim_nospread_accuracy",
	"hermes_aim_togglename_hud",
	"hermes_aim_toggle_hud",
	"hermes_aim_triggerdistance_triggerbot",
	"hermes_aim_triggernospread_triggerbot",
	"hermes_aim_triggerkey_triggerbot",
	"hermes_aim_triggerbot_triggerbot",
	"hermes_aim_ignorevehicle_targeting",
	"hermes_aim_ignoreghost_targeting",
	"hermes_aim_ignoretraitor_targeting",
	"hermes_aim_ignoreteam_targeting",
	"hermes_aim_ignoresteam_targeting",
	"hermes_aim_ignoreadmin_targeting",
	"hermes_aim_targetnpc_targeting",
	"hermes_aim_targetplayer_targeting",
	"hermes_aim_friendslist_targeting",
	"hermes_aim_predictply_aimbot",
	"hermes_aim_predicttar_aimbot",
	"hermes_aim_smoothaimspeed_aimbot",
	"hermes_aim_fov_aimbot",
	"hermes_aim_offset_aimbot",
	"hermes_aim_disableafterkill_aimbot",
	"hermes_aim_holdtarget_aimbot",
	"hermes_aim_smoothaim_aimbot",
	"hermes_aim_velocitychecks_aimbot",
	"hermes_aim_loscheck_aimbot",
	"hermes_aim_silentaim_aimbot",
	"hermes_aim_autoshoot_aimbot",
	"hermes_aim_prediction_aimbot",
	"hermes_aim_aimmode_aimbot",
	"hermes_aim_aimtype_aimbot",
	"hermes_load",
	"hermes_host_timescale",
	"hermes_pato",
	"hermes_sv_cheats",
	"hermes_mat_fullbright",
	"hermes_r_drawparticles",
	"_framerate",
	"_timescale",
	"_cheats",
	"2_r_drawothermodels",
	"2_sv_cheats",
	"2_host_timescale",
	"1_r_drawothermodels",
	"1_sv_cheats",
	"1_host_timescale",
	"seb_enable",
	"sh_enabled",
	"SethHack_allow_cheats_default",
	"SethHack_ff",
	"SethHack_Chams",
	"SethHack_NPConly",
	"SethHack_Entonly",
	"SethHack_Plyonly",
	"SethHack_LockY", 
	"SethHack_Enemy_Compensation",
	"SethHack_Me_Compensation",
	"SethHack_TMW",
	"SethHack_Ignore_SteamFriends",
	"SethHack_Ignore_Admins",
	"SethHack_Trigger_Bot",
	"SethHack_RestrictFOV_Value",
	"SethHack_AimSmooth",
	"SethHack_Mode",
	"SethHack_espplayeron",
	"SethHack_espunhideon",
	"SethHack_espmode",
	"SethHack_espcross",
	"SethHack_espitemon", 
	"SethHack_espvehicleon",
	"SethHack_espnpcon",
	"SethHack_espweaponon",
	"SethHack_esptrans",
	"SethHack_adminlist",
	"SethHack_drawclassname",
	"SethHack_showcmds",
	"SethHack_blacklistcmds",
	"SethHack_showumsgs",
	"SethHack_autoreload",
	"SethHack_crosshair",
	"SethHack_chams2",
	"SethHack_bhop",
	"SethHack_spinbot",
	"SethHack_chatspam",
	"SethHack_chatspam_interval",
	"SethHack_enable_filelogs",
	"SethHack_enable_sendlualog",
	"SethHack_enable_iplogs",
	"SethHack_enable_dslogs",
	"SethHack_speedfactor",
	"SethHack_gamemodeview",
	"SethHack_clientnoclip",
	"SethHack_always_nospread",
	"Ink_Esp_Admin",
	"Ink_Bhop",
	"Ink_Trigger",
	"Ink_TTT",
	"Ink_AntiGag",
	"Ink_Aimbot_IgnoreSteam",
	"Ink_Aimbot_Friendlyfire",
	"Ink_Aimbot_IgnoreAdmins",
	"Ink_SmoothAim_Enabled",
	"Ink_Smooth_Speed",
	"Aimbot_Offset",
	"Ink_Aimbot_Norecoil",
	"Ink_Key",
	"Ink_Func",
	"Ink_AimKeySave",
	"Ink_MenuKeySave",
	"Ink_PropKeySave",
	"ihpublicaimbot_enabled",
	"fap_aimbot_toggle",
	"Nishack_Triggerbot_Enabled",
	"sh_wallhack_dist",
	"pb_aim_trigger",
	"TB_BlockRCC",
	"trooper_aimbot",
	"trooper_autoshoot",
	"trooper_norecoil",
	"pb_load",
	"bc_norecoil",
	"bc_bouncy",
	"wots_buddy_attack",
	"wots_aimbot_teammode",
	"wots_aimbot_mouselock",
	"fap_aim_checkpartialhits",
	"fap_aim_enabled",
	"fap_aim_friendlyfire",
	"fap_aim_targetnpcs",
	"fap_aim_autofire",
	"fap_aim_autoreload",
	"fap_aim_bonemode",
	"fap_aim_targetfriends",
	"fap_aim_targetsteamfriends",
	"fap_aim_targetmode",
	"fap_aim_nospread",
	"fap_aim_maxdistance",
	"fap_aim_targetadmins",
	"fap_aim_antisnap",
	"fap_aim_norecoil",
	"fap_aim_antisnapspeed",
	"fap_aim_maxangle",
	"fap_aim_snaponfire",
	"fap_aim_snaponfiretime",
	"fap_aim_onlytargettraitors",
	"fap_aim_velocityprediction",
	"fap_aim_checknpcrelationship",
	"fap_checkforupdates",
	"fap_shouldload",
	"fap_enablekeybinding",
	"fap_bunnyhop",
	"fap_bunnyhopspeed",
	"fap_dontchecklos",
	"fap_alwaysloadhardcopy",
	"fap_ucmdfire",
	"host_timescale",
	"sv_cheats",
	"host_framerate",
	"net_blockmsg",
}



local Black_RCC = {
	["+attack"]	= true,
	["+reload"]	= true,
	--["+jump"]	= true,
}



local Black_RCCTab = {
	"+orgmenu",
	"+BT",
	"+woG",
	"+orgmenu",
	"+cherry_menu",
	"+cherry_aim",
	"ProcessCommandBait",
	"omen_spin",
	"+propthrow",
	"+scriptenforcer_menu",
	"+comtarg",
	"bs_hooks",
	"hake_menu",
	"asp_rotate",
	"asp_menu",
	"+hake_aim",
	"fls_menu",
	"sh_alive",
	"bs_detector",
	"bs_doeffect",
	"gf_admin",
	"+uberslow",
	"seb_openscript",
	"bs_menu",
	"+bs_getpos",
	"odius_zoom",
	"iHack_FullBright",
	"+ihack_speedhack",
	"ihack_speedhack",
	"FCvar",
	"+ihack_aimbot",
	"ihack_menu",
	"ihack_lua_scriptrun",
	"ihack_lua_stringrun",
	"lua_crypt",
	"spinhack",
	"at_autoaim_on",
	"at_autoaim_off",
	"+speed_hack",
	"AddSpeed",
	"_botjump",
	"_botvelocity",
	"+speedhake",
	"cub_aim_toggle",
	"cubHack",
	"cubHackLaser",
	"gen_run",
	"gen_lua",
	"+Coma_Pointer",
	"Coma_Menu_AimBot",
	"Coma_Menu_Misc",
	"Coma_ForceImpulse",
	"+Coma_SlowNikes",
	"+Coma_Nikes",
	"+Coma_PropKill",
	"AC_toggle",
	"AC_menu",
	"AC_Misc_NameSteal",
	"+AC",
	"+AC_Speed",
	"+SB_Aim",
	"SB_Misc_Flood",
	"SB_Misc_Crash",
	"+SB_Speed",
	"SB_Done",
	"+sbot_aimbot",
	"+Demibot_aim",
	"fls_joinspam",
	"fls_spamtimer",
	"+coma_aim",
	"coma_aim",
	"coma_menu",
	"+coma_menu",
	"+exie_aim",
	"+exie_speed",
	"+exie_menu",
	"exie_menu",
	"Menu_H4x",
	"fb_fov",
	"fb_runscript",
	"+fb",
	"fb_load",
	"omen_reload",
	"omen_menu",
	"+omen_aim",
	"+omen_speed",
	"+zaim",
	"Obelus_Update",
	"Obelus_Menu",
	"+Obelus_Menu",
	"+Obelus_Aim",
	"Obelus_Aim",
	"+Obelus_Speed",
	"+speedhack",
	"bs_force_load",
	"lua_logo_reload",
	"lua_run_quick",
	"bs_reload",
	"bs_unload",
	"bs_inject",
	"+bs_getview",
	"+bs_getpos",
	"odius_menu",
	"+odius_aim",
	"+odius_pkmode",
	"fl_fillhp",
	"+sp33d",
	"+b_aim",
	"server_command",
	"toggle_target",
	"target_menu",
	"+aim",
	"anthrax_banadmins",
	"anthrax_demoteadmins",
	"lol_rcon",
	"+follow_aim",
	"cs_lua",
	"anthrax_filemenu",
	"+anthrax_floodserver",
	"getrcon",
	"exploit_admin",
	"exploit_bans",
	"exploit_cfg",
	"exploit_rcon",
	"+fls_joinspam",
	"fls_execlua",
	"fls_loadlua",
	"fls_weightcrash_setup",
	"lethal_rotate",
	"lethal_menu",
	"lix_lesp_reload",
	"join_stopspam",
	"fls_rotate",
	"lix_lesp_rotate1",
	"lix_lesp_rotate2",
	"lix_lesp_rotate3",
	"lix_lesp_rotate",
	"sv_add1",
	"sv_run1",
	"exploit",
	"print_server_cfg",
	"print_file",
	"dump_remote_lua2",
	"print_file_listing_load",
	"sv_printdirfiles",
	"sv_printdir",
	"fuck_admins",
	"aah_setupspeedhack",
	"_timescale",
	"+enabled",
	"+triggerbot",
	"inc_g",
	"Smelly_Print_IPs",
	"Smelly_Clear_IPs",
	"+autofire",
	"spinlol",
	"ox_hacexploit",
	"pp_pixelrender",
	"startspam",
	"stopspam",
	"+makesound",
	"makesound",
	"+pk",
	"ThrowMagneto",
	"trowmagneto",
	"kon_chatspam",
	"kon_stopspam",
	"RLua",
	"Orgflashstyle1",
	"Orgflashstyle2",
	"se_add",
	"mh_unlock",
	"mh_toggleflag",
	"mh_keypad",
	"mh_open",
	"mh_turn180",
	"mh_esp_rehook",
	"mh_owners",
	"+qq_aimbot_enabled",
	"qq_menu",
	"+qq_nospread_triggerbot",
	"+qq_speedhack_speed",
	"go_unconnected",
	"+nou",
	"metalslave_aimbot_reload",
	"metalslave_aimbot_toggle",
	"metalslave_aimbot_menu",
	"metalslave_chams_reload",
	"qq_menu",
	"aah_renamevar",
	"aah_renamecmd",
	"aah_updatelogsettings",
	"aah_reload",
	"aah_login",
	"+qq_speedhack_speed",
	"+qq_aimbot_enabled",
	"qq_aimbot_quick_shot",
	"cf_aim_toggle",
	"+cf_bunnyhop",
	"CrashTheServer",
	"UltraCrashTheServer",
	"+cal_menu",
	"+cal_aim",
	"Isis_Menu_Reload",
	"+Isis_Menu",
	"+kilos_aim",
	"Isis_InteractC4",
	"+Isis_Aim",
	"Isis_Spin",
	"+Isis_Speed",
	"cf_freeze",
	"cf_menu",
	"+cf_aim",
	"cf_menu_toggle",
	"+cf_speed",
	"+DragonBot_Aim",
	"DragonBot_menu",
	"sh_luarun",
	"2a1f3e4r5678j9r9w8j7d54k6r2a84",
	"falco_runlooah",
	"falco_openlooah",
	"falco_rotate1",
	"falco_rotate2",
	"frotate",
	"+falco_makesound",
	"falco_makesound",
	"+hermes_aim",
	"_PoKi_menu_reload",
	"spamjeeps",
	"spamchair",
	"falco_hotkey",
	"falco_hotkeyList",
	"+cb_aim",
	"vlua_run",
	"sh_print_traitors",
	"+sh_triggerbot",
	"sh_runscripts",
	"sh_togglemenu",
	"gen_aim",
	"gen_autoshoot",
	"gen_speed",
	"+gen_bhop",
	"+gen_aim",
	"+gen_speed",
	"Ares_ForceImpulse",
	"Ares_Menu_ESP",
	"Ares_Menu_Misc",
	"Ares_Menu_AimBot",
	"+Ares_Pointer",
	"+Ares_SlowNikes",
	"+Ares_Aim",
	"+Ares_Nikes",
	"+Ares_PropKill",
	"Ares_Print_IPs",
	"Ares_Clear_IPs",
	"+MAim",
	"ms_pato",
	"+MSpeed",
	"ms_sv_cheats",
	"+MPause",
	"+zumg",
	"_fap_reload_menu",
	"ThermHack_ToggleMenu",
	"cub_toggle",
	"hera_convar_get",
	"hera_convar_set",
	"hera_include",
	"hera_runstring",
	"Monster_Menu",
	"x_reload",
	"x_menu",
	"+fox_aim",
	"+hax_rapidfire",
	"+Hax_aimbot",
	"+Hax_Menu",
	"+Hax_Zoom",
	"+hera_speed",
	"+TB_Bhop",
	"TB_Console",
	"+ATMenu",
	"+AimAssist",
	"+AimBHOP",
	"ReloadAA",
	"h_runscript",
	"h_openscript",
	"h_firewall",
	"h_gtower_debug",
	"h_bo_thirdperson",
	"h_helxa_encrypt",
	"h_helxa_decrypt",
	"bypass_se",
	"+hax_admin",
	"Neon_LoadMenu",
	"+Neon_Aim",
	"+Neon_SpeedHack",
	"+Neon_PropKill",
	"Neon_SayTraitors",
	"Neon_ForceCheats",
	"+neon_menu",
	"sb_toggle",
	"sh_menu",
	"sh_togglemenu",
	"+sh_triggerbot",
	"sh_print_traitors",
	"asp_reload",
	"+sh_bhop",
	"asp_uploaddupe",
	"+li_bhop",
	"hake_load",
	"SE_ByPass",
	"se_on",
	"+Aim",
	"SpamTime",
	"SethHack_panic",
	"SethHack_lua_run",
	"SethHack_lua_openscript",
	"+SethHackToggle",
	"+SethHack_Menu",
	"deathrun_qq",
	"+SethHack_Speed",
	"SethHack_ff_toggle",
	"SethHack_wallhack_wire",
	"SethHack_wallhack_player",
	"SethHack_Clear_All",
	"SethHackToggle",
	"SethHack_triggerbot_toggle",
	"SethHack_AddNPCfriend",
	"SpamMenu",
	"Inkbot_Crack",
	"Ink_LoadMenu",
	"+Propkill",
	"+Ink_Aim",
	"Ink_menu",
	"ihpublicaimbot_reload",
	"ihpublicaimbot_toggle",
	"+ihaimbot",
	"ihpublicaimbot_menu",
	"lagon",
	"lagoff",
	"fap_aimbot_toggle",
	"+Nis_Menu",
	"+sh_bhop",
	"pb_aim_trigger",
	"pb_load",
	"+TB_Aim",
	"+TB_Menu",
	"+TB_RapidFire",
	"+TB_Speed",
	"Spam_Props-V2",
	"Spam_Chat-v2",
	"+bc_aimbot",
	"-bc_aimbot",
	"+bc_spamprops",
	"bc_ips",
	"+bc_speedshoot",
	"bc_reload",
	"bc_unload",
	"wots_attack",
	"_fap_reload",
	"SE_AddFile",
	"SE_RemoveFile",
	"SE_LoadScripts",
	"+pb_aim",
	"pb_menu",
	"Spam_Props",
	"Spam_Chat",
	"+li_aim",
	"+li_menu",
	"li_menu",
	"+sh_menu",
	"+Mawpos",
	"gzfaimbot_reload",
	"gzfaimbot_toggle",
	"gzfaimbot_enabled",
	"asb_base_reload",
	"asb_base_unload",
	"+shenbot_aimbot",
	"shenbot_menu",
	"shenbot_bunnyhoptoggle",
	"-shenbot_aimbot",
	"SpinBot_on",
	"aimbot_off",
	"_aimbot",
	"lua_dofile_cl",
	"lua_dostring_cl",
	"ph0ne_aim",
	"ph0ne_aimcancel",
	"ph0ne_autoshoot",
	"+trooper_menu",
	"BMpublicaimbot_reload",
	"BMpublicaimbot_toggle",
	"+BMaimbot",
	"BMpublicaimbot_menu",
	"spamchat",
	"_fap_menu_reload",
	"rs",
	"sh_triggerbot",
	"sh_showips",
	"+sh_speed",
	"+sh_aim",
	"sh_toggleaim",
	"helix_chatspammer",
	"helix_undo",
	"helix_propspam",
	"helix_admins",
	"helix_rpnamespammer",
	"+helix_speed",
	"helix_crypto_binary",
	"helix_forcerandomname_on",
	"helix_forcerandomname_off",
	"helix_troll",
	"+helix_aim",
	"helix_cvarmenu",
	"formatlaser",
	"+Helix_Menu",
	"helix_reload",
	"helix_propspammer2",
	"helix_barrelbomb",
	"helix_unload",
	"helix_speed",
	"helix_blocklua",
	"helix_propspam_mdl",
	"helix_aim_bone",
	"helix_aim_crosshair",
	"helix_aim_fov",
	"helix_aim_los",
	"helix_aim_norecoil",
	"helix_aim_players",
	"helix_aim_shoot",
	"helix_aim_team",
	"helix_aim_trigger",
	"h_name",
	"+bb_menu",
	"bb",
	"ForceLaunch_BB",
	"jonsuite_unblockx",
	"bacon_lua_openscript",
	"+fox_aim",
	"discord1",
	"discord2",
	"hera_runstring",
	"aa_toggle",
	"Bacon_TriggerBotDelay",
	"Bacon_load",
	"bacon_chatspam",
	"bacon_namechange",
	"bacon_chatspam_interval",
	"bacon_norecoil",
	"Bacon_AntiSnap",
	"bacon_autoreload",
	"+hermes_menu",
	"+sykranos_is_sexier_then_hex",
	"sykranos_is_sexy_menu",
	"+hermes_speed",
	"AGT_AutoshootToggle",
	"AGT_AimBotToggle",
	"AGT_RandomName",
	"nbot_aimfixer",
	"nbot_speedoffset",
	"nbot_UseSelectedPerson",
	"nbot_autoshoot",
	"fap_enablekeybinding",
	"fap_bind",
	"fap_unbind",
	"lua_se2_load",
	"ah_cheats",
	"ah_changer",
	"ah_speed",
	"ah_aimbot_friends",
	"ah_aimbot",
	"ah_hooks",
	"ah_hookhide",
	"ah_name",
	"ah_antihook",
	"ah_reload",
	"ah_timestop",
	"setconvar",
	"fap_menu",
	"fap_checkforupdates",
	"fap_aim",
	"+fap_aim",
	"fap_aim_toggle",
	"lua_openscript_cl2",
	"raidbot_predictcheck",
	"aa_enabled",
	"BMaimbot",
	"+BMaimbot",
	"aimbot_headshots_on",
	"CBon_Reload_Script",
	"+CBon_menu",
	"ah_chatspammer",
	"ah_spammer",
	"ah_reload",
	"+ah_menu",
	"+nbot_options",
	"sm_fexec",
	"GAT_RandomName",
	"name_menu",
	"namechanger_on",
	"cl_name",
	"+wots_toggleimmunity",
	"send_file",
	"Bacon_Reload_Script",
	"fap_reload",
	"download_file",
	"upload_file",
	"plugin_load",
	"sethhack_load",
	"st_jumpspam",
	"force_cvar",
	"cl_docrash",
	"_fap_initshit",
	"SE_AddFile",
	"SE_RemoveFile",
	"SE_LoadScripts",
	"+namechanger",
	"RandomNCOn",
	"BlankNCON",
	"PsaySpamOn",
	"GayOn",
	"RatingSpammerOn",
	"+jbf_scan",
	"kennykill",
	"kenny_team",
	"kenny_bodyshots",
	"+kenny",
	"kenny_tagasshole",
	"kenny_addhit",
	"Kenny_noclip",
	"bacon_toggle",
	"Bacon_EntTriggerBot",
	"Bacon_Reload_Script",
	"+wots_spinhack",
	"wots_spinhack",
	"wire_button_model",
	"lol_togglestick",
	"lol_name",
	"lol_copy",
	"lol_fuckthis",
	"lol_barrel",
	"lol_setchat",
	"lol_chat",
	"lol_help",
	"lol_admins",
	"lol_adminalert",
	"lol_cancel",
	"lol_aim",
	"lol_headshot",
	"lol_teamshot",
	"wots_namecracker_menu",
	"wots_namecracker_on",
	"wots_namecracker_off",
	"wots_crash",
	"wots_lag_on",
	"wots_lag_off",
	"speedhack_speed",
	"SetCV",
	"+wowspeed",
	"+gofast",
	"+goslow",
	"JBF_off",
	"JBF_on",
	"JBF_headshots_off",
	"JBF_headshots_on",
	"JBF_enemysonly_on",
	"JBF_enemysonly_off",
	"JBF_playersonly_on",
	"JBF_playersonly_off",
	"_JBF_lagcompensation",
	"JBF_lagcompensation",
	"JBF_suicidehealth",
	"JBF_offset",
	"+BUTTFUCK",
	"entx_spazon",
	"entx_spazoff",
	"entx_setvalue",
	"+buttfuck",
	"fap_aim_enabled",
	"fap_aim_friendlyfire",
	"fap_aim_targetnpcs",
	"fap_aim_autofire",
	"fap_aim_autoreload",
	"fap_aim_bonemode",
	"fap_aim_targetfriends",
	"fap_aim_targetsteamfriends",
	"fap_aim_targetmode",
	"fap_aim_nospread",
	"fap_aim_maxdistance",
	"fap_aim_targetadmins",
	"fap_aim_antisnap",
	"fap_aim_norecoil",
	"fap_aim_antisnapspeed",
	"niggeron",
	"niggerff",
	"niggerfl",
	"niggersz",
	"niggernpc",
	"niggerw",
	"niggeri",
	"niggershd",
	"niggermxsh",
	"niggershit",
	"niggersd",
	"NameGenDerma",
	"+elebot",
	"+leetbot",
	"elebot_offset",
	"leetbot_offset",
	"elebot_minview",
	"leetbot_minview",
	"elebot_maxview",
	"leetbot_maxview",
	"elebot_boxsize",
	"leetbot_boxsize",
	"elebot_simplecolors",
	"leetbot_simplecolors",
	"elebot_targetteam",
	"leetbot_targetteam",
	"elebot_showadmin",
	"leetbot_showadmin",
	"elebot_filledbox",
	"leetbot_filledbox",
	"wots_attack",
	"+wots_menu",
	"wots_menu",
	"wots_megaspam",
	"wots_namegen_on",
	"wots_namegen_off",
	"name_change",
	"change_name",
	"name_changer",
	"+name_changer",
	"+Bacon_Menu",
	"+BaconToggle",
	"BaconToggle",
	"Bacon_triggerbot_toggle",
	"+Bacon_triggerbot_toggle",
	"Bacon_FF_Toggle",
	"aimbot_scan",
	"+aimbot_scan",
	"+aimbot",
	"aimbot",
	"entx_spazon",
	"entx_spazoff",
	"_aimbot",
	"_aimbot_headshots",
	"aimbot_offset",
	"entx_run1",
	"entx_run2",
	"entx_run3",
	"entx_run4",
	"entx_traceget",
	"entx_camenable",
	"+slobpos",
	"Bacon_Trigger_Bot",
	"+Bacon_Trigger_Bot",
	"Bacon_Ignore_SteamFriends",
	"Bacon_Mode",
	"gzfaimbot_reload",
	"gzfaimbot_toggle",
	"+gzfaimbot",
	"gzfaimbot",
	"gzfaimbot_menu",
	"at_autoaim_on",
	"at_autoaim_off",
	"at_changer_on",
	"at_changer_off",
	"at_norecoil_on",
	"at_norecoil_off",
	"at_menu",
	"at_autoshoot_on",
	"at_autoshoot_off",
	"aa_reload",
	"aa_toggle",
	"+aa",
	"aa_menu",
	"+Mawpos",
	"+nBot",
	"+nbot_Options",
	"nbot_Options",
	"aimbot_on",
	"aimbot_hitbox",
	"aimbot_target_teamates",
	"aimbot_target_closest",
	"aimbot_target_clear",
	"+asb_bot",
	"asb_bot",
	"asb_options",
	"+asb",
	"asb",
	"asb_unload",
	"asb_reload",
	"asb_shoot",
	"+entinfo",
	"entinfo_target",
	"asb_shoot",
	"asb_nospread",
	"asb_players",
	"entinfo_targetplayer"
}



local Black_LuaFiles = {
	--bandsox
	"includes/modules/*bandsox*.dll",
	"menu_plugins/*bandsox*.lua",
	"includes/enum/*bandsox*.lua",
	"vgui/*bandsox*.lua",
	"autorun/*bandsox*.lua",
	"autorun/client/*bandsox*.lua",	
	"*bandsox*.lua",
	
	--TurboBot
	"includes/modules/*eradicate*.dll",
	"includes/modules/*aspergers*.dll",
	"vgui/*aspergers*.lua",
	"autorun/*aspergers*.lua",
	"autorun/client/*aspergers*.lua",	
	"*aspergers*.lua",
	"vgui/*turbobot*.lua",
	"autorun/*turbobot*.lua",
	"autorun/client/*turbobot*.lua",	
	"*turbobot*.lua",	
	
	--ColdFire
	"includes/modules/*coldfire*.dll",
	"menu_plugins/*coldfire*.lua",
	"includes/enum/*coldfire*.lua",
	"vgui/*coldfire*.lua",
	"autorun/*coldfire*.lua",
	"autorun/client/*coldfire*.lua",	
	"*coldfire*.lua",
	
	--RCONExp
	"menu_plugins/*RCONExp*.lua",
	"includes/enum/*RCONExp*.lua",
	"vgui/*RCONExp*.lua",
	"autorun/*RCONExp*.lua",
	"autorun/client/*RCONExp*.lua",	
	"*RCONExp*.lua",
	
	--Exploit
	"menu_plugins/*sploit*.lua",
	"includes/enum/*sploit*.lua",
	"vgui/*sploit*.lua",
	"autorun/*sploit*.lua",
	"autorun/client/*sploit*.lua",	
	"*sploit*.lua",
	
	--Wut
	"qq/*.lua",
	"autorun/client/initb.lua",
	"includes/modules/gm_qq.dll",
	"includes/modules/gmcl_qq.dll",
	"includes/modules/gm_aah.dll",
	"includes/modules/gmcl_aah.dll",
	
	--Ares
	"includes/modules/gm_ares_core.dll",
	"autorun/client/gmod_op.lua",
	"gmod_op2.lua",
	
	--hermes
	"menu_plugins/ini.lua",
	"includes/modules/*hermes*.dll",
	"menu_plugins/*hermes*.lua",
	"includes/enum/*hermes*.lua",
	"vgui/*hermes*.lua",
	"autorun/*hermes*.lua",
	"autorun/client/*hermes*.lua",	
	"*hermes*.lua",
	--hermes:iplog
	"menu_plugins/*iplog*.lua",
	"includes/enum/*iplog*.lua",
	"vgui/*iplog*.lua",
	"autorun/*iplog*.lua",
	"autorun/client/*iplog*.lua",
	"*iplog*.lua",
	
	--FapHack
	"includes/modules/*faphack*.dll",
	"menu_plugins/*faphack*.lua",
	"includes/enum/*faphack*.lua",
	"vgui/*faphack*.lua",
	"autorun/*faphack*.lua",
	"autorun/client/*faphack*.lua",	
	"*faphack*.lua",
	"FapHack/*.lua",
	--Obelus
	"includes/modules/*Obelus*.dll",
	"menu_plugins/*Obelus*.lua",
	"includes/enum/*Obelus*.lua",
	"vgui/*Obelus*.lua",
	"autorun/*Obelus*.lua",
	"autorun/client/*Obelus*.lua",	
	"*Obelus*.lua",
	"Obelus/*.lua",
	
	--Isis
	"menu_plugins/*isis*.lua",
	"includes/enum/*isis*.lua",
	"vgui/*isis*.lua",
	"autorun/*isis*.lua",
	"autorun/client/*isis*.lua",	
	"*isis*.lua",
	"ass/Isis.lua",
	"includes/modules/gm_core.dll",
	"includes/modules/*no_core*.dll",
	"includes/modules/*no_fvar*.dll",
	"includes/modules/gmcl_pall.dll",
	
	--webz
	"menu_plugins/webz.lua",
	"includes/enum/webz.lua",
	"vgui/webz.lua",
	"autorun/webz.lua",
	"autorun/client/webz.lua",	
	"webz.lua",
	
	--trooper
	"trooper_v1_public.lua",	
	"autorun/trooper_v1_public.lua",
	"autorun/client/trooper_v1_public.lua",	
	"trooperhack.lua",	
	"autorun/trooperhack.lua",
	"autorun/client/trooperhack.lua",	
	
	--PB
	"menu_plugins/*pb_*.lua",
	"includes/enum/*pb_*.lua",
	"vgui/*pb_*.lua",
	"autorun/*pb_*.lua",
	"autorun/client/*pb_*.lua",	
	--INK
	"menu_plugins/INK.lua",
	"includes/enum/INK.lua",
	"vgui/INK.lua",
	"autorun/INK.lua",
	"autorun/client/INK.lua",	
	"INK.lua",
	
	--autoaim
	"autorun/AutoAim.lua",
	"autorun/client/AutoAim.lua",	
	"AutoAim.lua",
	
	--MintyScript
	"autorun/MintyScript.lua",
	"autorun/client/MintyScript.lua",	
	"MintyScript.lua",
	
	--NeonHack
	"includes/modules/*neon*.dll",
	"autorun/[NH]Core.lua",
	"autorun/client/[NH]Core.lua",	
	"[NH]Core.lua",
	"autorun/[NH]Loader.lua",
	"autorun/client/[NH]Loader.lua",	
	"[NH]Loader.lua",
	
	--asb
	"autorun/asb.lua",	
	"autorun/client/asb.lua",
	"asb.lua",
	"autorun/_TEMPLATE.lua",	
	"autorun/client/_TEMPLATE.lua",
	"_TEMPLATE.lua",
	"autorun/asb_base.lua",
	"autorun/client/asb_base.lua",
	"asb_base.lua",
	
	--Baconbot
	"includes/modules/*testbot*.dll",
	"includes/modules/*bbot*.dll",	
	"stuff/Clock.lua",
	"stuff/*bot*.lua",
	--v3
	"menu_plugins/*bbv3*.lua",
	"includes/enum/*bbv3*.lua",
	"vgui/*bbv3*.lua",
	"autorun/*bbv3*.lua",
	"autorun/client/*bbv3*.lua",
	"*bbv3*.lua",
	--v4
	"menu_plugins/*bbv4*.lua",
	"includes/enum/*bbv4*.lua",
	"vgui/*bbv4*.lua",
	"autorun/*bbv4*.lua",
	"autorun/client/*bbv4*.lua",
	"*bbv4*.lua",
	
	--hades
	"includes/modules/*hades*.dll",
	"menu_plugins/*hades*.lua",
	"includes/enum/*hades*.lua",
	"vgui/*hades*.lua",
	"autorun/*hades*.lua",
	"autorun/client/*hades*.lua",
	"*hades*.lua",
	"hades/*.lua",
	"hades/core/*.lua",
	
	--helix
	"includes/modules/*helix*.dll",
	"includes/modules/gm_p_*.dll",
	"includes/modules/gmcl_p_*.dll",
	"includes/modules/gm_p_base.dll",
	"includes/modules/gm_p_concmd.dll",
	"includes/modules/gm_p_cvar.dll",
	"includes/modules/gm_p_forcevar.dll",
	"includes/modules/gmcl_p_bypass.dll",
	"includes/modules/gmcl_p_misc.dll",
	"includes/modules/gmcl_p_umsg.dll",
	"menu_plugins/*helix*.lua",
	"includes/enum/*helix*.lua",
	"vgui/*helix*.lua",
	"autorun/*helix*.lua",
	"autorun/client/*helix*.lua",
	"*helix*.lua",
	"helix/*.lua",
	"helix/core/*.lua",
	
	--hera
	"includes/modules/*hera*.dll",
	"menu_plugins/*hera*.lua",
	"includes/enum/*hera*.lua",
	"vgui/*hera*.lua",
	"autorun/*hera*.lua",
	"autorun/client/*hera*.lua",
	"*hera*.lua",
	"hera/*.lua",
	"hera/core/*.lua",
	
	--THEODORE
	"menu_plugins/[THEODORE].lua",
	"includes/enum/[THEODORE].lua",
	"vgui/[THEODORE].lua",
	"autorun/[THEODORE].lua",
	"autorun/client/[THEODORE].lua",
	"[THEODORE].lua",	
	--JonSuite
	"includes/modules/*JonSuite*.dll",
	"JonSuite/Hacks/*.lua", 
	"JonSuite/*.lua",
	
	--random
	"autorun/client/ms_aimboat.lua",
	"autorun/ms_aimboat.lua",
	"autorun/I_laik_being_dum.lua",
	"autorun/client/I_laik_being_dum.lua",
	"autorun/waroftheservers.lua",
	"autorun/client/waroftheservers.lua",
	"autorun/hai.lua",
	"autorun/client/hai.lua",	
	"hai.lua",
	"autorun/fuckoff.lua",
	"autorun/client/fuckoff.lua",
	"fuckoff.lua",
	"autorun/AGT.lua",
	"autorun/client/AGT.lua",
	"AGT.lua",
	--seth
	"sh_run.lua",
	"autorun/sh_run.lua",
	"autorun/client/sh_run.lua",
	"shrun/*.lua",
	"lua/shrun/*.lua",
	"autorun/shrun/*.lua",
	"autorun/client/shrun/*.lua",
	"myfiles/*.lua",
	"lua/myfiles/*.lua",
	"autorun/myfiles/*.lua",
	"autorun/client/myfiles/*.lua",
	"dev/*bot*.lua",
	"dev/bbv3.lua",
	"dev/bbv4.lua",
	"dev/*hack*.lua",
	"dev/*crack*.lua",
	"dev/*exploit*.lua",
	"dev/*block*.lua",
	"dev/*convar*.lua",
	"dev/*cvar*.lua",
	"dev/*recoil*.lua",
	"dev/*hax*.lua",
	"dev/*h4x*.lua",
	"dev/*force*.lua",
	"dev/*cheat*.lua",
	"dev/*spam*.lua",
	"dev/*bypass*.lua",
	"dev/*troll*.lua",
	--BCScripts
	"scripts/*bot*.lua",
	"scripts/bbv3.lua",
	"scripts/bbv4.lua",
	"scripts/*hack*.lua",
	"scripts/*crack*.lua",
	"scripts/*exploit*.lua",
	"scripts/*block*.lua",
	"scripts/*convar*.lua",
	"scripts/*cvar*.lua",
	"scripts/*recoil*.lua",
	"scripts/*hax*.lua",
	"scripts/*h4x*.lua",
	"scripts/*force*.lua",
	"scripts/*cheat*.lua",
	"scripts/*spam*.lua",
	"scripts/*bypass*.lua",
	"scripts/*troll*.lua",
	"autorun/client/ips.lua",
	"autorun/ips.lua",
	
	--bypasses etc
	"includes/modules/*_odin*.dll",
	"includes/modules/*preproc*.dll",
	"includes/modules/gm_filesystem.dll",
	"includes/modules/*_thor*.dll",
	"includes/modules/*_fvar*.dll",
	"includes/modules/*_clua*.dll",
	"includes/modules/*crack*.dll",
	"includes/modules/gmcl_cmd.dll",
	"includes/modules/gmcl_sys.dll",
	"includes/modules/*hak*.dll",
	"includes/modules/*hake*.dll",
	"includes/modules/*solve*.dll",
	"includes/modules/*decz*.dll",
	"includes/modules/*deco*.dll",
	"includes/modules/gmcl_zeco.dll",
	"includes/modules/*dec0*.dll",
	"includes/modules/*_jell*.dll",
	"includes/modules/*spread*.dll",
	"includes/modules/*luamd5*.dll",
	"includes/modules/*_sh.dll",
	"includes/modules/gmcl_lh.dll",
	"includes/modules/*_sh1.dll",
	"includes/modules/*_sh2.dll",
	"includes/modules/*_sh3.dll",
	"includes/modules/*_se2.dll",
	"includes/modules/*_wshl.dll",
	"includes/modules/*hook*.dll",
	"includes/modules/*secret*.dll",
	"includes/modules/*unblock*.dll",
	"includes/modules/*byese2*.dll",
	"includes/modules/*command*.dll",
	"includes/modules/gm_se.dll",
	"includes/modules/*ring0*.dll",
	"includes/modules/*bypass*.dll",
	--luamd5
	"menu_plugins/*md5*.lua",
	"includes/enum/*md5*.lua",
	"vgui/*md5*.lua",
	"autorun/*md5*.lua",
	"autorun/client/*md5*.lua",
	"*md5*.lua",
	--antiread
	"menu_plugins/*antiread*.lua",
	"includes/enum/*antiread*.lua",
	"vgui/*antiread*.lua",
	"autorun/*antiread*.lua",
	"autorun/client/*antiread*.lua",
	"*antiread*.lua",
	--lua_run
	"menu_plugins/*lua_run*.lua",
	"includes/enum/*lua_run*.lua",
	"vgui/*lua_run*.lua",
	"autorun/*lua_run*.lua",
	"autorun/client/*lua_run*.lua",
	"*lua_run*.lua",
	--selfpwn
	"menu_plugins/*selfpwn*.lua",
	"includes/enum/*selfpwn*.lua",
	"vgui/*selfpwn*.lua",
	"autorun/*selfpwn*.lua",
	"autorun/client/*selfpwn*.lua",
	"*selfpwn*.lua",
	
	--generic:inject
	"includes/modules/*inject*.dll",
	"menu_plugins/*inject*.lua",
	"includes/enum/*inject*.lua",
	"vgui/*inject*.lua",
	"autorun/*inject*.lua",
	"autorun/client/*inject*.lua",
	"*inject*.lua",
	--generic:hack
	"includes/modules/*hack*.dll",
	"menu_plugins/*hack*.lua",
	"includes/enum/*hack*.lua",
	"vgui/*hack*.lua",
	"autorun/*hack*.lua",
	"autorun/client/*hack*.lua",
	"*hack*.lua",
	"hack/*.lua",	
	"hacks/*.lua",
	--generic:crack
	"includes/modules/*crack*.dll",
	"menu_plugins/*crack*.lua",
	"includes/enum/*crack*.lua",
	"vgui/*crack*.lua",
	"autorun/*crack*.lua",
	"autorun/client/*crack*.lua",
	"*crack*.lua",
	"crack/*.lua",
	"cracks/*.lua",
	--generic:exploit
	"includes/modules/*exploit*.dll",
	"menu_plugins/*exploit*.lua",
	"includes/enum/*exploit*.lua",
	"vgui/*exploit*.lua",
	"autorun/*exploit*.lua",
	"autorun/client/*exploit*.lua",
	"*exploit*.lua",
	"exploit/*.lua",
	"exploits/*.lua",
	--generic:convar
	"includes/modules/*convar*.dll",
	"menu_plugins/*convar*.lua",
	"includes/enum/*convar*.lua",
	"vgui/*convar*.lua",
	--"autorun/*convar*.lua",
	--"autorun/client/*convar*.lua",
	--"*convar*.lua",
	--generic:cvar
	"includes/modules/*cvar*.dll",
	"menu_plugins/*cvar*.lua",
	"includes/enum/*cvar*.lua",
	"vgui/*cvar*.lua",
	--"autorun/*cvar*.lua",
	--"autorun/client/*cvar*.lua",
	--"*cvar*.lua",
	--generic:recoil
	"includes/modules/*recoil*.dll",
	"menu_plugins/*recoil*.lua",
	"includes/enum/*recoil*.lua",
	"vgui/*recoil*.lua",
	"autorun/*recoil*.lua",
	"autorun/client/*recoil*.lua",
	"*recoil*.lua",
	--generic:hax
	"includes/modules/*hax*.dll",
	"menu_plugins/*hax*.lua",
	"includes/enum/*hax*.lua",
	"vgui/*hax*.lua",
	"autorun/*hax*.lua",
	"autorun/client/*hax*.lua",
	"*hax*.lua",
	"hax/*.lua",
	--generic:h4x
	"includes/modules/*h4x*.dll",
	"menu_plugins/*h4x*.lua",
	"includes/enum/*h4x*.lua",
	"vgui/*h4x*.lua",
	"autorun/*h4x*.lua",
	"autorun/client/*h4x*.lua",
	"*h4x*.lua",
	"h4x/*.lua",
	--generic:force
	"includes/modules/*force*.dll",
	"menu_plugins/*force*.lua",
	"includes/enum/*force*.lua",
	"vgui/*force*.lua",
	"autorun/*force*.lua",
	"autorun/client/*force*.lua",
	"*force*.lua",
	--generic:cheat
	"includes/modules/*cheat*.dll",
	"menu_plugins/*cheat*.lua",
	"includes/enum/*cheat*.lua",
	"vgui/*cheat*.lua",
	"autorun/*cheat*.lua",
	"autorun/client/*cheat*.lua",
	"*cheat*.lua",
	"cheat/*.lua",
	"cheats/*.lua",
	--generic:bypass
	"includes/modules/*bypass*.dll",
	"menu_plugins/*bypass*.lua",
	"includes/enum/*bypass*.lua",
	"vgui/*bypass*.lua",
	"autorun/*bypass*.lua",
	"autorun/client/*bypass*.lua",
	"*bypass*.lua",
	"bypass/*.lua",
	"bypasses/*.lua",
	--generic:luamd5
	"includes/modules/*luamd5*.dll",
	"menu_plugins/*luamd5*.lua",
	"includes/enum/*luamd5*.lua",
	"vgui/*luamd5*.lua",
	"autorun/*luamd5*.lua",
	"autorun/client/*luamd5*.lua",
	"*luamd5*.lua",
	--generic:bot
	"menu_plugins/*bot*.lua",
	"includes/enum/*bot*.lua",
	"vgui/*bot*.lua",
	"autorun/*bot*.lua",
	"autorun/client/*bot*.lua",
	"*bot*.lua",
}



local Black_DataFiles = {
	--Stuff
	{What = "*_ip*.txt"},
	{What = "gbot_*.txt"},
	{What = "ip_*.txt"},
	{What = "ips.txt"},
	{What = "iplo*.txt"},
	{What = "playerdump.txt"},
	{Where = "logs/"},
	{Where = "storm/"},
	{Where = "stormbot/"},
	{Where = "gbot/"},
	{Where = "zbot/"},
	{Where = "stole/"},
	{Where = "stolen/"},
	{Where = "cmdallow/"},
	{Where = "aspergers/"},
	{Where = "serverlog/"},
	{Where = "bandsox_gamemodes/"},
	{Where = "bandsox/"},
	{Where = "SH/"},
	{Where = "hack_downloaded_files/"},
	
	--Wut
	{What = "gmod_cvars.txt"},
	{What = "chat_config.txt"},
	{What = "logging.txt"},
	{What = "nawspreed.txt"},
	{What = "Smelly_ips.txt"},	
	{What = "theinit3sx3.txt"},
	{What = "x4xq054.txt"},
	{What = "lv9d3c.txt"},
	{What = "youvirus.txt"},
	{What = "5p1r1tw41k.txt"},
	{What = "B0unc3.txt"},
	{What = "d4h3sp.txt"},
	{What = "d4h41m.txt"},
	
	--Wut
	{What = "*.txt", Where = "bandsox_gamemodes/"},
	{What = "*.txt", Where = "bandsox/"},
	{What = "*.txt", Where = "SH/"},
	
	--Webz
	{What = "*.txt", Where = "sqirrils_salty_chocolate_nuts/"},
	{What = "alexs_large_shlong.txt"},
	
	--C0BRA
	{What = "*.txt", Where = "qq/"},
	{What = "*.txt", Where = "aah/"},
	{What = "*qq*.txt"},
	{What = "*aah*.txt"},
	
	--Ares
	{What = "ares_*.txt"},
	
	--Limes
	{What = "*.txt", Where = "Obelus/"},
	{What = "*.txt", Where = "limes/"},
	{What = "*.txt", Where = "lymes/"},
	{What = "*.txt", Where = "ox/"},
	{What = "*limes*.txt"},
	{What = "*lymes*.txt"},
	{What = "ox_*.txt"},
	{What = "*obelu*.txt"},
	
	--PoKi
	{What = "*PoKi*.txt"},
	
	--ColdFire
	{What = "*coldfire*.txt"},
	{What = "*cf_*.txt"},
	
	--SethHack
	{What = "dslog.txt"},
	{What = "runlog.txt"},
	
	--Hermes
	{What = "*hermes*.txt"},
	
	--NeonHack
	{What = "NeonAuth.txt"},
	{What = "NeonNewPlayer.txt"},
	{What = "neon_logged_ips.txt"},
	
	--Faphack
	{What = "*faphack*.txt"},
	{What = "fap_presets.txt"},
	{What = "fh_fail.txt"},
	{What = "*.txt", Where = "faphack/"},
	
	--ShenBot
	{What = "shenbot_save.txt"},
	
	--TeeBot
	{What = "TBAuth.txt"},
	
	--TacoBot
	{What = "tacobot_cfg.txt"},
	
	--bbot
	{What = "db_steamid_ip.txt"},
	{What = "bacon_*.txt"},
	
	--hera
	{What = "*.txt", Where = "hera/"},
	{What = "*.txt", Where = "hera/logs"},
	--hades
	{What = "*.txt", Where = "hades/"},
	{What = "*.txt", Where = "hades/logs"},
	--helix
	{What = "*.txt", Where = "HelixScripts/"},
	
	--generic
	{What = "*hack*.txt"},
	{What = "*.txt", Where = "hack/"},
	{What = "*.txt", Where = "hacks/"},
	
	{What = "*cheat*.txt"},
	{What = "*.txt", Where = "cheat/"},
	{What = "*.txt", Where = "cheats/"},
}



local Black_RootFiles = {
	{What = "ip_log.txt", Where = "../../"},
	{What = "ip_log.txt", Where = "../"},
	{What = "iplog.txt", Where = "../../"},
	{What = "iplog.txt", Where = "../"},
}



local Black_ToSteal = {
	{What = "gm_forceconvar.lua", Where = "autorun/"},
	{What = "gmcl_luamd5bypass.lua", Where = "autorun/client/"},
}



local Black_Hooks = {
	{H = "HUDPaint", N = "ComaESPSettings", D = "Coma"},
	{H = "HUDPaint", N = "ComaMenu1", D = "Coma"},
	{H = "HUDPaint", N = "C4UpdateComa2", D = "Coma"},
	{H = "CreateMove", N = "ComaNoJelloCreateMove42", D = "Coma"},
	{H = "CalcView", N = "CalcViewTest108", D = "CalcViewTest108"},
	{H = "TTTPrepareRound", N = "ResetItAll42", D = "ResetItAll42"},
	{H = "Think", N = "dajdsajh", D = "dajdsajh"},
	{H = "Think", N = "Spam", D = "Generic"},
	{H = "Think", N = "spamm", D = "Generic"},
	
	{H = "HUDPaint", N = "ShenBot.DrawHUD", D = "ShenBot"},
	{H = "Think", N = "ShenBot.AimbotThink", D = "ShenBot"},
	{H = "HUDPaint", N = "ShenBot.DrawESP", D = "ShenBot"},
	
	{H = "CreateMove", N = "FHack.Aiming", D = "FrostBot"},
	{H = "CreateMove", N = "FBot.Aiming", D = "FrostBot"},
	{H = "CalcView", N = "FHack.CorrectView", D = "FrostBot"},
	{H = "CalcView", N = "FBot.CorrectView", D = "FrostBot"},
	{H = "Think", N = "FHack.FindTargets", D = "FrostBot"},
	{H = "Think", N = "FBot.FindTargets", D = "FrostBot"},
	{H = "Think", N = "SpamProps", D = "FrostBot"},
	{H = "Tick", N = "FHack.NoRecoilSpread", D = "FrostBot"},
	
	{H = "HUDPaint", N = "AIMBOT", D = "Generic"},
	{H = "HUDPaint", N = "AresMenu1", D = "Ares"},
	{H = "HUDPaint", N = "GetAimbotPly", D = "HaxBot"},
	{H = "HUDPaint", N = "BaconBotHud", D = "BaconBot"},
	{H = "HUDPaint", N = "ShenBot.Aimbot", D = "ShenBot"},
	{H = "HUDPaint", N = "lolaim", D = "LOLScripts"},
	{H = "HUDPaint", N = "TBFov", D = "TeeBot"},
	
	{H = "Tick", N = "rpspam", D = "Anthrax"},
	{H = "PlayerInitialSpawn", N = "StartLog", D = "Anthrax"},
	{H = "Think", N = "AimFollow", D = "Anthrax"},
	{H = "Think", N = "Aim", D = "Anthrax"},
	
	{H = "DispatchUserMessage", N = "BandSox - SendLua Block", D = "BandSox"},
	{H = "PlayerBindPress", N = "BandSox - ForceCheck", D = "BandSox"},
	{H = "Think", N = "BandSox - TraiorScan", D = "BandSox"},
	{H = "CalcView", N = "BandSox - CalcView", D = "BandSox"},
	{H = "CreateMove", N = "BandSox - NoRecoil", D = "BandSox"},
	{H = "CreateMove", N = "BandSox - MouseMove", D = "BandSox"},
	
	{H = "Think", N = "Tesasd", D = "SHRun"},
	{H = "Think", N = "ThrowProp1", D = "SHRun"},
	{H = "Think", N = "command_halt", D = "SHRun"},
	{H = "CalcView", N = "ThrowCalc", D = "SHRun"},
	
	{H = "CreateMove", N = "trigga", D = "vHGmod"},
	{H = "CreateMove", N = "firbul", D = "vHGmod"},
	{H = "CreateMove", N = "nospreadnaim", D = "vHGmod"},
	{H = "CreateMove", N = "aim", D = "vHGmod"},
	{H = "CalcView", N = "lol", D = "vHGmod"},
	{H = "CalcView", N = "otherz", D = "vHGmod"},
	{H = "Think", N = "toggleit", D = "vHGmod"},
	{H = "Think", N = "trigga", D = "vHGmod"},
	
	{H = "HUDPaint", N = "PaintBotNotes", D = "JetBot"},
	{H = "HUDPaint", N = "JBF", D = "JetBot"},
	
	{H = "Think", N = "Lymes_Think", D = "Lymes"},
	{H = "CalcView", N = "Lymes_CalcView", D = "Lymes"},
	{H = "CreateMove", N = "Lymes_CreateMove", D = "Lymes"},
	{H = "HUDPaint", N = "Lymes_HUDPaint", D = "Lymes"},
	{H = "InitPostEntity", N = "Lymes_IPE", D = "Lymes"},
	
	{H = "HUDPaint", N = "Superoctonopus", D = "InkHack"},
	{H = "HUDPaint", N = "TTTWeaponShow", D = "InkHack"},
	{H = "HUDPaint", N = "MoneyMoney", D = "InkHack"},
	
	{H = "HUDPaint", N = "NeonHackAimBoat", D = "NeonHack"},
	{H = "HUDPaint", N = "C4Det1", D = "NeonHack"},
	
	{H = "CreateMove", N = "Spaz", D = "JetBot"},
	{H = "CreateMove", N = "CamStopMove", D = "JetBot"},
	
	{H = "CreateMove", N = "HaxBot", D = "HaxBot"},
	{H = "CreateMove", N = "haxer", D = "AnacletoBot"},
	{H = "CreateMove", N = "MoveAim", D = "NoobHack"},
	{H = "CreateMove", N = "AimOnFire", D = "SimpleAim"},
	{H = "CreateMove", N = "AresNoJelloCreateMove42", D = "Ares"},
	{H = "CreateMove", N = "AINGNJD", D = "5_min_bot"},
	{H = "CreateMove", N = "MingeBagAIMBot", D = "SlobBot"},
	{H = "CreateMove", N = "AimThePlayer", D = "Kenbot"},
	
	{H = "CreateMove", N = "Autoaim", D = "Generic"},
	{H = "CreateMove", N = "AutoAim", D = "Generic"},
	{H = "CreateMove", N = "this", D = "BaconBot"},
	{H = "CreateMove", N = "Aimbot", D = "Trooper"},
	{H = "CreateMove", N = "aimbot", D = "Generic"},
	{H = "CreateMove", N = "TrooperAim", D = "Trooper"},
	{H = "CreateMove", N = "Aimboat", D = "Generic"},
	{H = "CreateMove", N = "TrackTarget", D = "JetBot"},
	{H = "CreateMove", N = "ShenBot.BunnyHop", D = "ShenBot"},
	
	{H = "CreateMove", N = "TBFakeView", D = "TeeBot"},
	{H = "CreateMove", N = "TBAim", D = "TeeBot"},
	
	{H = "CreateMove", N = "AAFakeView", D = "AimAssist"},
	{H = "CreateMove", N = "AimAssist", D = "AimAssist"},
	{H = "CreateMove", N = "ATAimBot", D = "AimAssist"},
	
	{H = "CreateMove", N = "StoredAngleRecalc", D = "InkHack"},
	{H = "CreateMove", N = "StoredAngleRecalc2131", D = "NeonHack"},
	
	{H = "Think", N = "AimbotThinkingHere", D = "Baconbot"},
	{H = "Think", N = "TriggerThinky", D = "Baconbot"},
	{H = "Think", N = "AutoFire_Bitch", D = "Baconbot"},
	
	{H = "Think", N = "Aim", D = "MonsterWH"},
	{H = "Think", N = "AresThinkHook", D = "Ares"},
	
	{H = "Think", N = "ThermHack_General_Think", D = "ThermHack"},
	{H = "Think", N = "ThermHack_General_Think_g", D = "ThermHack"},
	
	{H = "Think", N = "rapidfire", D = "HaxBot"},
	{H = "Think", N = "TBGet", D = "HaxBot"},
	{H = "Think", N = "NoRecoilWeps", D = "HaxBot"},
	{H = "Think", N = "ZoomIn", D = "HaxBot"},
	
	{H = "Think", N = "H4XTHINK", D = "Generic"},
	{H = "Think", N = "AimbotThinking", D = "Kenbot"},
	{H = "Think", N = "Norecoil", D = "Generic"},
	{H = "Think", N = "Fag", D = "Generic"},
	{H = "Think", N = "Hax", D = "Generic"},
	{H = "Think", N = "catchme", D = "Generic"},
	{H = "Think", N = "NameChange", D = "Generic"},
	{H = "Think", N = "HadesSteamworksThink", D = "Hades"},
	{H = "Think", N = "Norecoil", D = "TTT"},
	{H = "Think", N = "TriggerThink", D = "Jon"},
	{H = "Think", N = "aimboat", D = "ph0ne"},
	{H = "Think", N = "GGetLocal", D = "Generic"},
	{H = "Think", N = "Nishack-Bunnyhoplol", D = "Nishack"},
	{H = "Think", N = "Triggerbot", D = "Mac"},
	
	{H = "Think", N = "Autoshoot", D = "AGT"},
	{H = "Think", N = "SetName", D = "AGT"},
	
	{H = "Think", N = "SlobLuaHax", D = "SlobBot"},
	{H = "Think", N = "LocalFix", D = "SlobBot"},
	{H = "Think", N = "Megaspam", D = "SlobBot"},
	{H = "Think", N = "Slobhax", D = "SlobBot"},
	
	{H = "Think", N = "ATAttack", D = "AimAssist"},
	{H = "Think", N = "ATRecoil", D = "AimAssist"},
	{H = "Think", N = "SCCThink", D = "AimAssist"},
	{H = "Think", N = "AimBhop", D = "AimAssist"},
	
	{H = "Think", N = "aimbot", D = "BCSCripts"},
	{H = "Think", N = "Aimbot", D = "Hugohack"},
	{H = "Think", N = "AimBot", D = "BCSCripts"},
	{H = "Think", N = "AIMBOT", D = "Generic"},
	{H = "Think", N = "Target", D = "BCSCripts"},
	{H = "Think", N = "PropSpammer", D = "BCSCripts"},
	{H = "Think", N = "NoRecoil", D = "BCSCripts"},
	{H = "Think", N = "SpeedShoot", D = "BCSCripts"},
	
	{H = "Think", N = "TBThink", D = "TeeBot"},
	{H = "Think", N = "TBBhop", D = "TeeBot"},
	{H = "Think", N = "TBRecoil", D = "TeeBot"},
	
	{H = "Think", N = "Chak", D = "InkHack"},
	{H = "Think", N = "Funkybunny", D = "InkHack"},
	{H = "Think", N = "NewAntiGag", D = "InkHack"},
	{H = "Think", N = "Tesasd", D = "InkHack"},
	{H = "Think", N = "Nacrot", D = "InkHack"},
	{H = "Think", N = "NotRecoil", D = "InkHack"},
	
	{H = "Think", N = "NeonNoRecoil", D = "NeonHack"},
	{H = "Think", N = "TriggerBot1", D = "NeonHack"},
	{H = "Think", N = "ThrowProp125z", D = "NeonHack"},
	{H = "Think", N = "NeonBHOP", D = "NeonHack"},
	{H = "Think", N = "FindDaPassword", D = "NeonHack"},
	
	
	{H = "Tick", N = "Tick", D = "SausageBot"},
	{H = "Tick", N = "Norecoil", D = "MonsterWH"},
	
	
	{H = "CalcView", N = "CamCalcView", D = "JetBot"},
	{H = "CalcView", N = "NoRecoil", D = "BCSCripts"},
	{H = "CalcView", N = "lolwut1", D = "lolwut"},
	{H = "CalcView", N = "Norecoil", D = "SimpleAim"},
	{H = "CalcView", N = "ZCalcView", D = "HaxBot"},
	{H = "CalcView", N = "AimCV", D = "AimAssist"},
	{H = "CalcView", N = "TBCalcView", D = "TeeBot"},
	{H = "CalcView", N = "NegTin", D = "InkHack"},
	
	
	{H = "HadesPlayerName", N = "HadesPlayerName", D = "Hades"},
	{H = "InputMouseApply", N = "Aimbott", D = "TTT"},
	{H = "InputMouseApply", N = "AutoAim", D = "SimpleAim"},
	{H = "Move", N = "Teleportin", D = "JetBot"},
	{H = "PlayerInitialSpawn", N = "KEEPNAMEPLAYERSPAWN", D = "InitSpawn"},
	{H = "KeyPress", N = "timeToShoot", D = "nBot"},
	{H = "ProcessSetConVar", N = "SEIsShit", D = "SEIsShit"},
	{H = "Initialize", N = "ES_OR", D = "BCSCripts"},
	{H = "PlayerConnect", N = "BC_IPLog", D = "BCSCripts"},
	{H = "PlayerConnect", N = "PlayerConnect1255", D = "BCSCripts"},
	{H = "PlayerConnect", N = "ConnectIP", D = "quinhack"},
	
	{H = "PlayerBindPress", N = "TEMPHotKey", D = "TEMPHotKey"},
	{H = "PlayerBindPress", N = "falco_hotkey", D = "TEMPHotKey"},
}



local Black_Timers = {
	{T = "df7sf8dsfdksjhfsdfjsd89ffal", D = "Isis"},
	{T = "AddSpeed", D = "Isis"},
	{T = "LoadHooks", D = "Isis"},
	
	{T = "GetNames", D = "SlobBot"},
	{T = "SetName", D = "SlobBot"},
	
	{T = "StartSpamming", D = "SHRun"},
	
	{T = "spamchat_timer", D = "MingeScripts"},
	{T = "spamprops_timer", D = "MingeScripts"},
	{T = "spampropsv2_timer", D = "MingeScriptsV2"},
	{T = "spamchatv2_timer", D = "MingeScriptsV2"},
	
	{T = "autoattack", D = "BCScripts"},
	
	{T = "lolgetvarsifitwantsto", D = "LOLScripts"},
	{T = "lolalerttimeout", D = "LOLScripts"},
	{T = "loluptimer", D = "LOLScripts"},
	{T = "chekadmins", D = "LOLScripts"},
	{T = "loluptimer2", D = "LOLScripts"},
	
	{T = "lolololohop", D = "pb_pub"},
}


local NotFR			= file.Read
local NotFXE		= file.Size
local NotFFIL		= file.FindInLua
local NotFF			= file.Find
local NotFD			= file.Delete
local NotFTF		= file.TFind
local NotRQ			= require
local NotINC		= include

_G["NotFR"]			= NotFR
_G["NotFXE"]		= NotFXE
_G["NotFFIL"]		= NotFFIL
_G["NotFF"]			= NotFF
_G["NotFD"]			= NotFD
_G["NotFTF"]		= NotFTF
_G["NotRQ"]			= NotRQ
_G["NotINC"]		= NotINC


local NotIV			= _R["Entity"]["IsValid"]
local NotGBP		= _R["Entity"]["GetBonePosition"]
local NotACH		= _R["Entity"]["LookupAttachment"]
local NotSEA		= _R["Player"]["SetEyeAngles"]
local NotPCC		= _R["Player"]["ConCommand"]
local NotRS			= _R["bf_read"]["ReadString"]
local NotSVA		= _R["CUserCmd"]["SetViewAngles"]

local NotCCC		= CreateClientConVar
local NotCCV		= CreateConVar
local NotGCV		= GetConVar
local NotGCS		= GetConVarString
local NotGCN 		= GetConVarNumber
local NotRCC		= RunConsoleCommand
local NotGAL		= GetAddonList
local NotGAI		= GetAddonInfo
local NotRPF		= util.RelativePathToFull
local NotDGE		= debug.getinfo
local NotIKD		= input.IsKeyDown
local NotRE			= rawequal
local MsgN			= MsgN
local Msg			= Msg
local Format		= Format
local NotMR			= math.random
local NotRGT		= rawget
local NotRST		= rawset
local pairs 		= pairs
local type			= type
local tostring		= tostring
local table			= table
local os			= os
local math			= math
local string		= string
local print			= print
local debug			= debug
local tonumber		= tonumber

for k,v in pairs(Black_RQTab) do
	if NotRQ(k) then
		Black_RQTab[k] = true
	end
end


local GCount,RCount,PLCount	= 0,0,0
local PLTable	= {}

for k,v in pairs(_G) do
	GCount = GCount + 1
end
for k,v in pairs(_R) do
	RCount = RCount + 1
end

for k,v in pairs(package.loaded) do
	table.insert(PLTable, k)
	PLCount = PLCount + 1
end


local HCCMD			= (hook or concommand)
local PLCC			= (package.loaded.concommand)
local PLHK			= (package.loaded.hook)
local PLTS			= (package.loaded.timer)
local PLCV			= (package.loaded.cvars)
local PLDS			= (package.loaded.datastream)

local function GIsUseless(str)
	for k,v in pairs(White_GUseless) do
		if string.sub(str, 1, #v) == v then
			return true
		end
	end
	return false
end


local BadGlobals = {}
for k,v in pairs(_G) do --From Garry with love
	local idx	= tostring(k)
	local vdx	= tostring(v)
	local KType = type(k)
	local VType = type(v)
	
	if (KType == "string") then
		if (VType == "table") then
			if (_G[idx] != nil) then
				
				for x,y in pairs( _G[idx] ) do
					local SubX	= tostring(x)
					local SubY	= tostring(y)
					local YType = type(y)
					
					local Ret = "_G."..idx.."."..SubX
					
					if not GIsUseless(Ret) then
						if (YType == "function") then
							Ret = Ret.." (FUNCTION)"
							
						elseif (YType == "table") then
							Ret = Ret.." (TABLE)"
							
						else
							Ret = Ret..Format("=[[%s]] (%s)", SubY,string.upper(YType) )
						end
						
						if not White_GSafe[ Ret ] then
							table.insert(BadGlobals, Ret)
						end
					end
				end
			end
			
		elseif (VType != "table") then
			local Ret = Format("_G.%s (FUNCTION)", idx)
			
			if (VType != "function") then
				Ret = Format("_G.%s=[[%s]] (%s)", idx,vdx,string.upper(VType) )
			end
			
			if not GIsUseless(Ret) and not White_GSafe[ Ret ] then
				table.insert(BadGlobals, Ret)
			end
		end
	end
end


NotRQ("usermessage")
NotRQ("concommand")
NotRQ("hook")
NotRQ("timer")
NotRQ("cvars")
NotRQ("sqlite")


local NotCCA		= concommand.Add
local NotECC		= engineConsoleCommand
local NotHA			= hook.Add
local NotHR			= hook.Remove
local NotHGT		= hook.GetTable
local NotTS			= timer.Simple
local NotTC			= timer.Create
local NotTIT		= timer.IsTimer
local NotCAC		= cvars.AddChangeCallback
local NotSQQ		= sql.Query

local WhatDS		= "data".."stream"
local WhatST		= "Str".."eam".."To".."Server" --Eat shit and die
NotRQ(WhatDS)
local NotSTS		= _G[WhatDS][WhatST]

local MyPath, MyLine = "Gone", 0

if DEBUG then
	Msg("\n! DEBUG: loaded here\n\n")
end



usermessage.Hook("PlayerInitialSpawn", function(um)
	MSGHook = NotRS(um)
	HACInstalled = HACInstalled + 1
end)

local function RandomChars()
	local len = NotMR(6, 16)
	
	local rnd = ""
	for i = 1, len do
		local c = NotMR(65, 116)
		if c >= 91 and c <= 96 then c = c + 6 end
		rnd = rnd..string.char(c)
	end
	return rnd
end


local function NotGMG(what,other)
	if NotIV(LocalPlayer()) then
		if other then
			NotRCC(MSGHook, what, tostring(other))
		else
			NotRCC(MSGHook, what)
		end
	end
end
_G["NotGMG"]		= NotGMG
_G["GlobalPoop"]	= NotGMG



if DEBUG then
	SPAWNTIME = 3
	EVERYTIME = 4
	RCLTime = 3
end

NotCCV("sv_rphysicstime", 0, 16384)

local RCCAlreadyDone	= false
local PCCAlreadyDone	= false
local NNRAlreadyDone	= false
local DoneKey			= false

NotTC(RandomChars(), RCLTime, 0, function()
	RCCAlreadyDone	= false
	PCCAlreadyDone	= false
	NNRAlreadyDone	= false
	DoneKey			= false
end)

local DGENotC = (NotDGE(debug.getinfo).what != "C")
local RQNotC  = (NotDGE(require).what != "C")


local function LPDev()
	return IsDev[ LocalPlayer():SteamID() ]
end

local function Safe(str,maxlen)
	if not str then return end
	str = tostring(str)
	str = string.Trim(str)
	str = string.gsub(str, "[:/\\\"*%@?<>'#]", "_")
	str = string.gsub(str, "[]([)]", "")
	str = string.gsub(str, "[\n\r]", "")
	str = string.gsub(str, string.char(7), "BEL")
	str = string.Trim( string.Left(str, maxlen or 25) )
	return str
end
local function MyCall(lev)
	local DGI = NotDGE(lev or 3)
	if not DGI then return "Gone", 0 end
	
	local Path = (DGI.short_src or "Gone"):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end
local function FPath(func)
	local What = type(func)
	if not (func and What == "function") then return What end
	local DGI = NotDGE(func)
	if not DGI then return "Gone", 0 end
	
	local Path = (DGI.short_src or What):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end
local function NotTHV(tab,val)
	for k,v in pairs(tab) do
		if (v == val) then return true end
	end
	return false
end
local function IsIn(str,base)
	base = string.lower(tostring(base))
	str = string.lower(tostring(str))
	return string.find(base, str)
end
local function GAIInfo(v)
	local Addon = NotGAI(v)
	return (Addon and Addon.Info and Addon.Info != "")
end
local function GAIAuthor(v)
	local Addon = NotGAI(v)
	return (Addon and Addon.Author and Addon.Author != "")
end
local function ValidString(v)
	return (v and type(v) == "string" and v != "")
end
local function Size(where)
	local size = NotFXE(where)
	if (size == -1) then
		return 0
	else
		return size
	end
end
local function GetCRC()
	local wut = game.GetMap()
	local map = tostring(#wut*2)
	return map..map..map..wut:Left(1):upper()
end

local function PRTab(tab,indent,done)
	done = done or {}
	indent = indent or 0
	
	for key, value in pairs(tab) do
		Msg( string.rep("\t", indent) )
		if type(value) == "table" and not done[value] then
			done[value] = true
			Msg(tostring(key)..":".."\n")
			
			PRTab(value, indent + 2, done)
		else
			Msg(tostring(key).."\t=\t")
			Msg(tostring(value).."\n")
		end
	end
end
local function SQLStr(str,NoQuote)
    str = tostring(str)
	
    if str:find('\\"') then
        return
    end
	
    str = str:gsub('"', '\\"')
	
    if (NoQuote) then
        return str
    end
    return "\""..str.."\""
end
local function NotQTE(name)
    local r = NotSQQ("select name FROM sqlite_master WHERE name="..SQLStr(name).." AND type='table'")
    if (r) then return true end
    return false
end


local function Useless()
	return false
end
coroutine = {
	create		= Useless,
	resume		= Useless,
}
concommand.GetTable = function()
	return {}
end


_G.BootyBucket = nil
NotINC("en_streamhks.lua")
local NotBucket = _G.BootyBucket

local UselessSpam		= {}
local LuaUselessSpam	= {}
local UselessLoaded		= false
local function NotSoUseless(what,send,lua,typ)
	local path,line = MyCall(4)
	local str = Format("NotSoUseless=%s [%s:%s]", what, path,line)
	
	if send and ValidString(lua) and not str:find("faphack") and not LuaUselessSpam[lua] then
		LuaUselessSpam[lua] = true
		
		NotTS(2, function()
			NotBucket(lua,typ)
		end)
	end
	
	if not UselessSpam[str] then --Only do it once!
		UselessSpam[str] = true
		
		if UselessLoaded then
			NotGMG(str)
		end
	end
end
CompileString	= function(s,f)	NotSoUseless("CompileString", true, s, "CS") 								end
Compilestring	= function(s)	NotSoUseless("Compilestring", true, s, "Cs")								end
CompileFile		= function(f)	NotSoUseless("CompileFile", true, file.Read("lua/"..f, true),"CF")			end
Compilefile		= function(f)	NotSoUseless("Compilefile", true, file.Read("lua/"..f, true),"Cf")			end
LoadString		= function(s)	NotSoUseless("LoadString", true, s, "LS")									end
loadstring		= function(s)	NotSoUseless("loadstring", true, s, "Ls")									end
--[[
RunString		= function(s)	NotBucket(s,"RS")			end
RunStringEx		= function(s)	NotBucket(s,"RSX")			end
Runstring		= function(s)	NotBucket(s,"Rs")			end
]]
RunString		= Useless
RunStringEx		= Useless
Runstring		= Useless

WFC111255 		= function()	NotSoUseless("WFC111255")	end
setfenv			= function()	NotSoUseless("setfenv")		end
getfenv			= function()	NotSoUseless("getfenv")		end


local function NewConCommand(ent,cmd,stuff)
	if ( not LPDev() and Black_RCC[ string.lower(tostring(cmd)) ] ) then
		if not PCCAlreadyDone then
			PCCAlreadyDone = true
			--[[
			local path,line = MyCall()
			
			NotGMG( Format("PCC=%s [%s:%s]", cmd, path,line) )
			]]
			NotGMG( Format("PCC=%s", cmd) )
		end
	end
	
	if not (ent and NotIV(ent)) then return end
	return NotPCC(ent,cmd,stuff)
end
_R["Player"]["ConCommand"] 	= NewConCommand


function RunConsoleCommand(...)
	local RCCArgs = {...}
	if ( not LPDev() and Black_RCC[ string.lower(tostring(RCCArgs[1])) ] ) then
		if not RCCAlreadyDone then
			RCCAlreadyDone = true
			local path,line = MyCall()
			
			NotGMG( Format("RCC=%s [%s:%s]", RCCArgs[1], path,line) )
		end
	end
	
	--return NotRCC(...)
	NotRCC(...)
end
local NewRCC = RunConsoleCommand


NotTC(RandomChars(), 6, 0, function()
	if (LocalPlayer() and NotIV( LocalPlayer() ) ) and (LocalPlayer():GetActiveWeapon() and NotIV( LocalPlayer():GetActiveWeapon() )) then
		local Wep = LocalPlayer():GetActiveWeapon()
		local KWC = string.lower(Wep:GetClass())
		
		if White_NNRIgnore[KWC] then return end
		
		if (Wep.Primary) then
			local RCL = tonumber(Wep.Primary.Recoil) or 1
			
			if (White_NNRWeapons[KWC] != RCL) then
				if not NNRAlreadyDone then
					NNRAlreadyDone = true
					NotGMG( Format("NoRecoil=%s-%s", KWC, RCL) )
				end
			end
		end
	end
end)

local NewGAL = {}
for k,v in ipairs(NotGAL()) do
	if ValidString(v) then
		NewGAL[k] = string.lower(v)
	end
end

local BadCLDB = {}
for k,v in pairs(Black_CLDB) do
	if NotQTE(v) then
		table.insert(BadCLDB, v)
	end
	local Gone = NotSQQ("DROP TABLE "..v)
	if Gone != false then
		table.insert(BadCLDB, "DROP="..v)
	end
end


local Booty = {}
NotTS(1, function()
	for k,v in pairs(Black_ToSteal) do
		local What 	= v.What
		local Where = v.Where
		local File	= Where..What
		
		if ValidString(File) and (#NotFFIL(File) >= 1) then
			for x,y in pairs(NotFFIL(File)) do
				local NewFile = tostring(Where..y)
				if ValidString(y) and (#NotFFIL(NewFile) >= 1) then
					table.insert(Booty, Format("--%s\n--%s\n\n%s", v, LocalPlayer():Nick(), NotFR("lua/"..NewFile, true) ) )
					
					NotRCC("gm_selectmenus", NewFile)
				end
			end
		end
	end
	
	NotTS(20, function()
		if (#Booty >= 1) then
			NotSTS("DataStream", Booty, function() NotRCC("gm_closemenus") end) --Yarr!
		end
	end)
end)



local function CModCheck(path,what,str,cmd,notlua) --CMod
	local SPath = path..what
	
	local Func = NotFFIL
	if notlua then
		Func = function(p) return NotFF(p,true) end
	end
	
	for k,v in pairs( Func(SPath) ) do
		NotTS(k / 10, function()
			local Fill = path..v
			
			if Func(Fill) and ValidString(v) then
				v = string.Trim(v,"/")
				v = string.Trim(v)
				
				NotRCC(cmd, str..v, 0, v)
			end
		end)
	end
end


NotTS(5, function()
	if (HCCMD) then NotGMG("HCCMD")	end
	
	CModCheck("includes/enum/",		"*.lua",	"ENMod=",	"gm_explodetheplayer")
	CModCheck("includes/modules/",	"*.dll",	"CMod=",	"gm_spawntheplayer")
	CModCheck("menu_plugins/",		"*.lua",	"MLMod=",	"gm_respawntheplayer")
	CModCheck("addons/",			"*.dll",	"VMod=",	"gm_killtheplayer", true)
	CModCheck("addons/",			"*.vdf",	"VMod=",	"gm_killtheplayer", true)
	
	UselessLoaded = true
	for k,v in pairs(UselessSpam) do
		NotGMG(k)
	end	
	for k,v in pairs(BadCLDB) do
		NotGMG("CLDB="..v)
	end
	for k,v in pairs(BadGlobals) do
		NotTS(k/5, function()
			NotGMG("GCheck="..v)
		end)
	end
	
	if (MyPath != "Gone" or MyLine != 0) then
		NotGMG( Format("BADHAC=[%s:%s]", MyPath, MyLine) )
	end
	if (RCLTime != 2) then
		NotGMG("PLCount", PLCount)
	end
end)



NotTS(SPAWNTIME, function()
	if NotGCV("cl_cmdrate"):GetInt() !=30 then
		NotRCC("cl_cmdrate","30")
	end
	
	if (NotGCV("host_timescale"):GetInt() != 1) then
		NotGMG("TS=host_timescale="..NotGCV("host_timescale"):GetString())
	end
	if (NotGCV("host_timescale"):GetHelpText() != "Prescale the clock by this amount.") then
		NotGMG("TS=host_timescale="..(NotGCV("host_timescale"):GetHelpText() or "''"))
	end
	
	if (NotGCV("sv_cheats"):GetString() != "0") then
		NotGMG("TS=sv_cheats="..NotGCV("sv_cheats"):GetString())
	end
	if (NotGCV("sv_cheats"):GetHelpText() != "Allow cheats on server") then
		NotGMG("TS=sv_cheats="..(NotGCV("sv_cheats"):GetHelpText() or "''"))
	end
	
	if NotGCV("host_framerate"):GetBool() then
		NotGMG("TS=host_framerate="..NotGCV("host_framerate"):GetInt())
	end
	if (NotGCV("host_framerate"):GetHelpText() != "Set to lock per-frame time elapse.") then
		NotGMG("TS=host_framerate="..(NotGCV("host_framerate"):GetHelpText() or "''"))
	end
	
	if (NotGCV("net_blockmsg"):GetString() != "none") then
		NotGMG("TS=net_blockmsg="..NotGCV("net_blockmsg"):GetString())
	end
	if (NotGCV("cl_forwardspeed"):GetString() != "450") then
		NotGMG("TS=cl_forwardspeed="..NotGCV("cl_forwardspeed"):GetString())
	end
	
	for k,v in pairs(Black_RPF) do
		if (NotRPF("lua/"..v) != "lua/"..v) then
			NotGMG("RPF="..v)
		end
	end
	for k,v in pairs(Black_RQTab) do
		if v then
			NotGMG("TC="..k)
		end
	end
	
	if DGENotC then
		NotGMG("TC=DGENotC")
		DGENotC = false
	end
	if RQNotC then
		RQNotC("KR30=RQNotC")
		RQNotC = false
	end
	
	for k,v in pairs( Black_Addons ) do --bad addons
		v = tostring(v)
		if NotTHV( NewGAL, string.lower(v) ) then
			if GAIInfo(v) then
				if GAIAuthor(v) then
					NotGMG("Addon="..v.." V="..Safe((NotGAI(v).Version or 1), 4).." ("..Safe(NotGAI(v).Author, 15)..") [["..Safe(NotGAI(v).Info, 30).."]]")
				else
					NotGMG("Addon="..v.." [["..Safe(NotGAI(v).Info, 25).."]]")
				end
			else
				NotGMG("Addon="..v)
			end
		end
	end
	for k,v in pairs( NotGAL() ) do --bad addons, kw
		v = tostring(v)
		for x,y in pairs(Black_AddonsKW) do
			y = tostring(y)
			if (ValidString(v) and ValidString(y)) and IsIn(y,v) then
				if GAIInfo(v) then
					if GAIAuthor(v) then
						NotGMG("WAddon="..y.."/"..v.." V="..Safe((NotGAI(v).Version or 1), 4).." ("..Safe(NotGAI(v).Author, 15)..") [["..Safe(NotGAI(v).Info, 30).."]]")
					else
						NotGMG("WAddon="..y.."/"..v.." [["..Safe(NotGAI(v).Info, 30).."]]")
					end
				else
					NotGMG("WAddon="..y.."/"..v)
				end
			end
		end
	end
	

	for k,v in pairs(Black_LuaFiles) do --bad lua
		NotTS(k / 10, function()
			if #NotFFIL(v) >= 1 then
				for x,y in pairs(NotFFIL(v)) do
					if NotFFIL(y) and (ValidString(v) and ValidString(y)) then
						y = string.Trim(y,"/")
						if NotTHV(string.Explode("/", v), y) then
							NotGMG("Module=lua/"..v)
						else
							NotGMG("WModule=lua/"..v.."/"..y)
						end
					end
				end
			end
		end)
	end
	
	NotTS(1, function()	
		for k,v in pairs( Black_DataFiles ) do --Datafile
			NotTS(k / 10, function()
				local What 	= (v.What or "*.txt")
				local Where = (v.Where or "")
				local File	= Where..What
				
				if ValidString(File) then
					for x,y in pairs(NotFF(File)) do
						if ValidString(y) then
							local NewFile	= Where..y
							local Cont		= NotFR(NewFile)
							local FCont		= Safe(Cont)
							local FSize		= Size(NewFile)
							
							if FSize then
								if ValidString(Cont) then
									NotGMG( Format("Datafile=data/%s-%s (%s) [[%s]]", NewFile, FSize, What, FCont) )
								else
									NotGMG( Format("Datafile=data/%s-%s (%s)", NewFile, FSize, What) )
								end
							else
								if ValidString(Cont) then
									NotGMG( Format("Datafile=data/%s (%s) [[%s]]", NewFile, What, FCont) )
								else
									NotGMG( Format("Datafile=data/%s (%s)", NewFile, What) )
								end
							end
							NotTS(1, NotFD, NewFile) --Hax that hax you back!
						end
					end
				end
			end)
		end
	end)
	
	NotTS(2, function()
		if not Silent then
			for k,v in pairs(Black_RCCTab) do --bad commands
				NotTS(k / 9, function()
					NotCCA(v, function(ply,cmd,args)
						if #args >= 1 then
							NotGMG("Key="..cmd..":Args=[["..Safe(table.concat(args," ")).."]]")
						else
							NotGMG("Key="..cmd)
						end
						if NotIV(LocalPlayer()) then
							LocalPlayer():ChatPrint("Unknown Command: '"..cmd.."'\n")
						end
					end)
				end)
			end
		end
		for k,v in pairs(Black_CVars) do --bad cvars
			NotTS(k / 15, function()
				NotCAC(v, function(var,old,new)
					NotGMG("CVar="..var..":Args=[["..Safe(new).."]]")
				end)
			end)
		end
	end)
	
	
	for k,v in pairs(Black_RootFiles) do
		local What 	= v.What
		local Where = (v.Where or "")
		local File	= Where..What
		
		if ValidString(File) then
			for x,y in pairs( NotFFIL(File, true) ) do
				if ValidString(y) then
					local NewFile	= Where..y
					
					NotGMG( Format("Rootfile=root/%s (%s)", NewFile, What) )
				end
			end
		end
	end
	
	
	NotTC(RandomChars(), EVERYTIME, 0, function() --"Horrible elseif megaloop"
		if (SlobMegaAIM or GetSlobBotTarget or AntiBanOn or BotVisible or WOTS
			or SlobTeamAllowed or SafeAIM or SlobNotify or EzekBuddyAllowed
			or SlobBotAllowed or HeadPosition) then
			NotGMG("TC=SlobBot")
		end
		if (WeaponTable or TTTWeaponEsp or Bunnyhop
			or Antigag or ReCalc or Targetsys or KeyTable or Admindet) then
			NotGMG("TC=InkHack")
		end
		if (traitorwepclass or weaponhistory_timer or traitorscanner_timer
			or ResetWeaponsCache or ResetTraitors or whoshotme_think or whoshotme_lasthp) then
			NotGMG("TC=Webz")
		end
		if (DoIsisNospread or abc_donospred or abc_ucmd_getperdicston) then
			NotGMG("TC=Isis")
		end
		if (AddSEFile or teh or AddFileCC) then
			NotGMG("TC=TurboBot")
		end
		if (fbot or FBot or fBot or FBOT) then
			NotGMG("TC=FBot")
		end
		if (_R.Entity.HeadPos or _R.Entity.GetVisible ) then
			NotGMG("TC=BotBot")
		end
		if (AimFollow or AimAt or FollowAim or StopFollowAim or ToggleTarget or ChangeTargetMenu
			or Anthraxcolors or PlayerDump or ServerFlood or StartServerFlood or EndServerFlood
			or HackInit) then
			NotGMG("TC=Anthrax")
		end
		if (_include or _require or RunStringClient or BandSox or bandsox or old_rcc or old_hrm
			or LuaQuickRun) then
			NotGMG("TC=BandSox")
		end
		if (RunRemoteLua or qq or aah) then
			NotGMG("TC=C0bra")
		end
		if (Lua_PredictSpread or Lua_ShotManip) then
			NotGMG("TC=Lua_PredictSpread")
		end
		if ((WeaponVector and GetCone) or runLuaF or ReCalc55 or DoAresNoJello) then
			NotGMG("TC=Ares")
		end
		if (Hermes or Nospread or GetPrediction or CompensateWeaponSpread
			or SetPlayerSpeed or WeaponVector or herpes or Herpes or HERPES) then
			NotGMG("TC=Hermes")
		end
		if ((Exceptions3 and IsVisible) or NeonHackCore
			or ClosestTarget or AimBoat or ReCalc55 or NeonMenu or abot_getrandom
			or abot_manipshot or runNeon) then
			NotGMG("TC=NeonHack")
		end
		if (targetteam or autoshoot or mns_nosoup4yu or mns_fuck_garrysmodtion) then
			NotGMG("TC=MonsterWH")
		end
		if (runbypass or setCVar) then
			NotGMG("TC=Mac")
		end
		if (ThermHack) then
			NotGMG("TC=ThermHack")
		end	
		if (Nospread) then
			NotGMG("TC=Nospread")
		end
		if (ForceCvar) then
			NotGMG("TC=ForceCvar")
		end
		if (LoadNHIP) then
			NotGMG("TC=LoadNHIP")
		end
		if (RenameCVAR) then
			NotGMG("TC=RenameCVAR")
		end
		if (hl2_ucmd_getpr3diction or hl2_man1pshot) then
			NotGMG("TC=Jell")
		end
		if (lolwut) then
			NotGMG("TC=lolwut")
		end
		if (FindAllTargets or Aimbot) then
			NotGMG("TC=5_min_bot")
		end
		if (FoxAim) then
			NotGMG("TC=FoxAim")
		end
		if (ClosestTarget or HaxBot or NoRecoilWeapons or GetAimedAt or StartBhop) then
			NotGMG("TC=HaxBot")
		end
		if (hera) then
			NotGMG("TC=hera")
		end
		if (aether) then
			NotGMG("TC=aether")
		end
		if (cub_toggle or cub_hack) then
			NotGMG("TC=cub_hack")
		end
		if (FapHack or PopulateESPCombo) then
			NotGMG("TC=FapHack")
		end
		if (speeeeed) then
			NotGMG("TC=Speedhack")
		end
		if (TrollTable) then
			NotGMG("TC=NisHack")
		end
		if (COLOR_TRACKING and COLOR_FRIENDLY) then
			NotGMG("TC=LH-AutoAim")
		end
		if (ASScheck or ULXcheck) then
			NotGMG("TC=ULXcheck")
		end
		if (ShenBot) then
			NotGMG("TC=ShenBot")
		end
		if (MawNotify or GetMawBotTarget)  then
			NotGMG("TC=MawBot")
		end
		if (spamchat or spamprops or spampropsv2 or spamprops_v2 or spamchat_v2 or spamchatv2) then
			NotGMG("TC=MingeScripts")
		end
		if (aimbot or SpeedShoot or RemoveSpeedShoot) then
			NotGMG("TC=BCScripts")
		end
		if (RunHax or TB) then
			NotGMG("TC=TeeBot")
		end
		if (aimmodels or unhookz) then
			NotGMG("TC=vHGmod")
		end
		if (Ox or Lymes or Limes) then
			NotGMG("TC=Discord")
		end
		if (hl2_shotmanip or hl2_ucmd_getprediciton or L_MD5_PseudoRandom
			or manipulate_shot) then
			NotGMG("TC=Deco")
		end
		if (baconbot or bbot or triggerthis or mysetupmove or ToggleHax 
			or SelectTarget or AimbotThink or SafeViewAngles or BaconBotMenu
			or BaconBotSheet or SetCVAR	or PredictSpread or BBOT or LoadBaconBot
			or admincheck or BaconMiniWindow or SetConvar or SpawnVGUISPAM) then
			NotGMG("TC=BaconBot")
		end
		if (cusercmd_getcommandnumber) then
			NotGMG("TC=cusercmd_getcommandnumber")
		end
		if (psayspammer or ratingspammer) then
			NotGMG("TC=Abestrollingscript")
		end
		if (BaseTargetPosition or TargetPosition or IsValidTarget) then
			NotGMG("TC=AutoAim")
		end
		if (ForceConVar) then
			NotGMG("TC=ForceConVar")
		end
		if (ForceVarF or SpeedhackF or HookProtF or ModeCheck or TargetCheck or BonePosition or TargetVisible) then
			NotGMG("TC=AHack")
		end
		if (checkVicts or CanVictimSeeUs or beginAim) then
			NotGMG("TC=nBot")
		end
		if (AutoAim or GetTarget or WeaponCheck) then
			NotGMG("TC=AGT")
		end
		if (IsEnemy or BonePos or Aimable or AimFakeView) then
			NotGMG("TC=AimAssist")
		end
		if (Helix or Helxa or helxa or Hades or hades) then
			NotGMG("TC=Helix-hades")
		end
		if (Hack or HACK or hack) then
			NotGMG("TC=Hack")
		end
		if (HOOK_TYPE_INJECT) then
			NotGMG("TC=HOOK_TYPE_INJECT")
		end
		if (Cheat or cheat or CHEAT) then
			NotGMG("TC=Cheat")
		end
		if (AcceptedLaserWeps or NameTagHacsor) then
			NotGMG("TC=TTT")
		end
		if (spamprops or propkill1 or MagnetoThrow or ChatSpammerMenu or IsSpamming or ChatSpam or StopSpamming
			or derpderpderpspin or gololspin or derpderpderpflash or perporgflashaltalt or perporgflashaltalt2 or AutoFire) then
			NotGMG("TC=SHRun")
		end
		if (SH or SH_SETCVAR or SH_RUNSCRIPT or SH_MODULEVERSION or sh2 or sh3 or SH2 or SH3 or sh4 or SH4 or __________s or SH_REGREAD) then
			NotGMG("TC=Sethhack")
		end
		if (CF_SetConvar) then
			NotGMG("TC=Coldfire")
		end	
		if (PlayerConnect) then
			NotGMG("TC=PlayerConnect")
		end
		if (AIMBOT_PLAYERSONLY or OFFSETPRESETS or SPINBOT_On or AimBot_Off or AIMBOT_SCANNING or DoAimBot) then
			NotGMG("TC=JetBot")
		end
		
		local MCheck = {}
		for k, v in pairs( file.FindInLua("includes/modules/*") ) do
			MCheck[#MCheck+1] = v
		end
		if not NotTHV(MCheck, "..") or not NotTHV(MCheck, ".") then
			NotGMG("MCheck="..#MCheck)
		end
		
		for k,v in pairs(Black_Timers) do --Timers
			local Timer = v.T
			local Hack  = v.D
			
			if NotTIT(Timer) then
				NotGMG( Format("%s=IsTimer:%s", Hack, Timer) )
			end
		end
		
		for k,v in pairs(Black_Hooks) do --Hooks
			NotTS(k / 20, function()
				local Hook		= v.H
				local Name		= v.N
				local Hack		= v.D
				local BaseHook	=  NotHGT()[Hook]
				
				if BaseHook then
					local func = BaseHook[Name]
					local path,line = FPath(func)
					
					if func then
						NotGMG( Format("%s=%s-%s [%s:%s]", Hack, Hook, Name, path,line ) )
						NotHR(Hook, Name)
					end
				end
			end)
		end
	end)
end)



timer.Simple(6, function()
	NotHA("Think", RandomChars(), function()
		if _G["NotFR"] != NotFR then --file.Read
			NotGMG("THK=NotFR ["..FPath( _G["NotFR"] ).."]")
			_G["NotFR"] = NotFR
		end
		if file.Read != NotFR then
			NotGMG("THK=file.Read ["..FPath( file.Read ).."]")
			file.Read = NotFR
		end
		
		if _G["NotFXE"] != NotFXE then --file.Size
			NotGMG("THK=NotFXE ["..FPath( _G["NotFXE"] ).."]")
			_G["NotFXE"] = NotFXE
		end
		if file.Size != NotFXE then
			NotGMG("THK=file.Size ["..FPath( file.Size ).."]")
			file.Size = NotFXE
		end
		
		if _G["NotFFIL"] != NotFFIL then --file.FindInLua
			NotGMG("THK=NotFFIL ["..FPath( _G["NotFFIL"] ).."]")
			_G["NotFFIL"] = NotFFIL
		end
		if file.FindInLua != NotFFIL then
			NotGMG("THK=NotFFIL ["..FPath( file.FindInLua ).."]")
			file.FindInLua = NotFFIL
		end
		
		if _G["NotFF"] != NotFF then --file.Find
			NotGMG("THK=NotFF ["..FPath( _G["NotFF"] ).."]")
			_G["NotFF"] = NotFF
		end
		if file.Find != NotFF then
			NotGMG("THK=file.Find ["..FPath( file.Find ).."]")
			file.Find = NotFF
		end
		
		if _G["NotFD"] != NotFD then --file.Delete
			NotGMG("THK=NotFD ["..FPath( _G["NotFD"] ).."]")
			_G["NotFD"] = NotFD
		end
		if file.Delete != NotFD then
			NotGMG("THK=file.Delete ["..FPath( file.Delete ).."]")
			file.Delete = NotFD
		end
		
		if _G["NotFTF"] != NotFTF then --file.TFind
			NotGMG("THK=NotFTF ["..FPath( _G["NotFTF"] ).."]")
			_G["NotFTF"] = NotFTF
		end
		if file.TFind != NotFTF then
			NotGMG("THK=file.TFind ["..FPath( file.TFind ).."]")
			file.TFind = NotFTF
		end
		
		if _G["NotRQ"] != NotRQ then --require
			NotGMG("THK=NotRQ ["..FPath( _G["NotRQ"] ).."]")
			_G["NotRQ"] = NotRQ
		end	
		
		if _G["NotINC"] != NotINC then --include
			NotGMG("THK=NotINC ["..FPath( _G["NotINC"] ).."]")
			_G["NotINC"] = NotINC
		end
		
		if _G["GlobalPoop"] != NotGMG then --GlobalPoop
			NotGMG("THK=GlobalPoop ["..FPath( _G["GlobalPoop"] ).."]")
			_G["GlobalPoop"] = NotGMG
		end
		
		if not DoneKey and (NotIKD(27) and NotIKD(67)) then
			DoneKey = true
			NotGMG("Key=TabQ")
		end
	end)
end)



local KR30HA	= false
local KR30HR	= false
local KR30HGT	= false
local KR30CMD	= false
local KR30SVC	= false
local KR30HTS	= false
local KR30HFR	= false
local KR30NBM	= false
local KR30CFS	= false
local KR30FFIL	= false
local KR30FF	= false
local KR30FR	= false
local KR30GCV	= false
local KR30GCS	= false
local KR30GCN	= false
local KR30RCC	= false
local KR30CCA	= false
local KR30RQ	= false
local KR30INC	= false
local KR30RGGCV	= false
local KR30RGGCS	= false
local KR30RGGCN	= false
local KR30RGRCC	= false
local KR30RGECC	= false
local KR30ECC	= false
local KR30RCV	= false
local KR30GMT	= false
local KR30GMTG	= false
local KR30GGMT	= false
local KR30LDD	= false


NotTC(RandomChars(), 2, 0, function()
	if DGENotC then
		NotGMG("KR30=DGENotC")
		DGENotC = false
	end
	
	if RQNotC then
		RQNotC("KR30=RQNotC")
		RQNotC = false
	end
	
	for k,v in pairs(Black_RQTab) do
		if (v == true) then
			NotGMG("KR30="..string.upper(k) )
			Black_RQTab[k] = false
		end
	end
	
	
	if (PLCC) then
		PLCC = false
		NotGMG("KR30=PLCC")
	end
	if (PLCV) then
		PLCV = false
		NotGMG("KR30=PLCV")
	end
	if (PLHK) then
		PLHK = false
		NotGMG("KR30=PLHK")
	end
	if (PLTS) then
		PLTS = false
		NotGMG("KR30=PLTS")
	end
	if (PLDS) then
		PLDS = false
		NotGMG("KR30=PLDS")
	end
	
	if (NotGCS("sv_rphysicstime") != "0") then
		if not KR30RCV then
			KR30RCV = true
			NotGMG("RCVAR="..NotGCS("sv_rphysicstime"))
		end
	end
	
	if NotGCN("cl_cmdrate") != 30 then
		NotRCC("cl_cmdrate","30")
	end
	if (NotGCS("sv_cheats") != "0") then
		if !KR30SVC then
			KR30SVC = true
			NotGMG("KR30=sv_cheats="..NotGCS("sv_cheats"))
		end
	end
	if (NotGCN("host_timescale") != 1) then
		if !KR30HTS then
			KR30HTS = true
			NotGMG("KR30=host_timescale="..NotGCS("host_timescale"))
		end
	end
	if NotGCV("host_framerate"):GetBool() then
		if !KR30HFR then
			KR30HFR = true
			NotGMG("KR30=host_framerate="..NotGCS("host_framerate"))
		end
	end
	if (NotGCS("net_blockmsg") != "none") then
		if !KR30NBM then
			KR30NBM = true
			NotGMG("KR30=net_blockmsg="..NotGCS("net_blockmsg"))
		end
	end
	if (NotGCS("cl_forwardspeed") != "450") then
		if !KR30CFS then
			KR30CFS = true
			NotGMG("KR30=cl_forwardspeed="..NotGCS("cl_forwardspeed"))
		end
	end
	
	if hook.Add != NotHA then --hook.Add
		if not KR30HA then
			KR30HA = true
			NotGMG("Detour3=hook.Add["..FPath(hook.Add).."]")
		end
	end
	if hook.Remove != NotHR then --hook.Remove
		if not KR30HR then
			KR30HR = true
			NotGMG("Detour3=hook.Remove["..FPath(hook.Remove).."]")
		end
	end
	if hook.GetTable != NotHGT then --hook.GetTable
		if not KR30HGT then
			KR30HGT = true
			NotGMG("Detour3=hook.GetTable["..FPath(hook.GetTable).."]")
		end
	end
	
	if file.FindInLua != NotFFIL then --file.FindInLua
		if not KR30FFIL then
			KR30FFIL = true
			NotGMG("Detour3=file.FindInLua["..FPath(file.FindInLua).."]")
		end
	end
	if file.Find != NotFF then --file.Find
		if not KR30FF then
			KR30FF = true
			NotGMG("Detour3=file.Find["..FPath(file.Find).."]")
		end
	end
	if file.Read != NotFR then --file.Read
		if not KR30FR then
			KR30FR = true
			NotGMG("Detour3=file.Read["..FPath(file.Read).."]")
		end
	end
	if GetConVar != NotGCV then --GetConVar
		if not KR30GCV then
			KR30GCV = true
			NotGMG("Detour3=GetConVar["..FPath(GetConVar).."]")
		end
	end
	if GetConVarString != NotGCS then --GetConVarString
		if not KR30GCS then
			KR30GCS = true
			NotGMG("Detour3=GetConVarString["..FPath(GetConVarString).."]")
		end
	end
	if GetConVarNumber != NotGCN then --GetConVarNumber
		if not KR30GCN then
			KR30GCN = true
			NotGMG("Detour3=GetConVarNumber["..FPath(GetConVarNumber).."]")
		end
	end
	if RunConsoleCommand != NewRCC then --RunConsoleCommand
		if not KR30RCC then
			KR30RCC = true
			NotGMG("Detour3=RunConsoleCommand["..FPath(RunConsoleCommand).."]")
		end
	end
	if concommand.Add != NotCCA then --concommand.Add
		if not KR30CCA then
			KR30CCA = true
			NotGMG("Detour3=concommand.Add["..FPath(concommand.Add).."]")
		end
	end
	if require != NotRQ then --require
		if not KR30RQ then
			KR30RQ = true
			NotGMG("Detour3=require["..FPath(require).."]")
		end
	end
	if include != NotINC then --include
		if not KR30INC then
			KR30INC = true
			NotGMG("Detour3=include["..FPath(include).."]")
		end
	end
	if engineConsoleCommand != NotECC then --engineConsoleCommand
		if not KR30ECC then
			KR30ECC = true
			NotGMG("Detour3=engineConsoleCommand["..FPath(engineConsoleCommand).."]")
		end
	end	
	
	if not NotRE( NotRGT(_G, "GetConVar"), NotGCV) then --GetConVar
		if not KR30RGGCV then
			KR30RGGCV = true
			NotGMG("Detour4=GetConVar")
		end
	end
	if not NotRE( NotRGT(_G, "GetConVarString"), NotGCS) then --GetConVarString
		if not KR30RGGCS then
			KR30RGGCS = true
			NotGMG("Detour4=GetConVarString")
		end
	end
	if not NotRE( NotRGT(_G, "GetConVarNumber"), NotGCN) then --GetConVarNumber
		if not KR30RGGCN then
			KR30RGGCN = true
			NotGMG("Detour4=GetConVarNumber")
		end
	end
	if not NotRE( NotRGT(_G, "RunConsoleCommand"), NewRCC) then --RunConsoleCommand
		if not KR30RGRCC then
			KR30RGRCC = true
			NotGMG("Detour4=RunConsoleCommand")
		end
	end
	if not NotRE( NotRGT(_G, "engineConsoleCommand"), NotECC) then --engineConsoleCommand
		if not KR30RGECC then
			KR30RGECC = true
			NotGMG("Detour4=engineConsoleCommand")
		end
	end
	if debug.getmetatable == getmetatable then --getmetatable
		if not KR30GMT then
			KR30GMT = true
			NotGMG("Detour3=debug.getmetatable")
		end
	end
	if getmetatable(_G) then
		if not KR30GMTG then
			KR30GMTG = true
			NotGMG("KR30=GMTG")
		end
	end
	if (_G.__metatable) then
		if not KR30GGMT then
			KR30GGMT = true
			NotGMG("KR30=GMT")
		end
	end
	if RunConsoleCommand then --RunConsoleCommand
		if not KR30LDD then
			KR30LDD = true
			NotGMG("KR30=KR30LDD")
		end
	end
end)


local function RefreshRanks(ply,cmd,args)
	local Seed	= tonumber(args[1] or 1)
	local Ret	= tonumber(args[2] or 3)
	local Base	= tonumber(args[3] or 7)
	
	Seed = (Seed * HACInstalled + Ret / Base)
	Seed = tostring(Seed)..tostring(GCount)..tostring(RCount)
	
	NotRCC("gm_dong", "None", "HACReport", Seed)
end
concommand.Add("gm_newplayerjoin", RefreshRanks)




local EyeSpam = {}

local function SetViewAngles(ucmd,ang)
	local path,line = MyCall()
	if not (path and ang) then return end
	
	if not LPDev() and not EyeSpam[path] then --Only do it once!
		EyeSpam[path] = true
		
		NotGMG( Format("SetViewAngles=[%s:%s]", path,line) )
	end
	
	return NotSVA(ucmd,ang)
end
_R["CUserCmd"]["SetViewAngles"]		= SetViewAngles


local function SetEyeAngles(self,ang)
	if not (self and NotIV(self)) then return end
	local path = MyCall()
	if not (path and ang) then return end
	
	if not LPDev() and not EyeSpam[path] then --Only do it once!
		EyeSpam[path] = true
		
		NotGMG( Format("SetEyeAngles=[%s:%s]", path,line) )
	end
	
	return NotSEA(self,ang)
end
_R["Player"]["SetEyeAngles"]		= SetEyeAngles
_R["Entity"]["SetEyeAngles"]		= SetEyeAngles




HACInstalled = HACInstalled + 1
hook.Add("InitPostEntity", "WhatIsThisIDontEven", function()
	local HACLength = math.ceil(HACInstalled + #Black_Addons + #Black_AddonsKW
		+ #Black_CVars + #Black_RCCTab + #Black_LuaFiles + #Black_DataFiles + #Black_ToSteal
		+ #White_NNRIgnore + #Black_Hooks + #White_GUseless + #PLTable + #White_Package
		+ #Black_RPF + #Black_CLDB + #Black_RootFiles + #Black_Timers
	)
	local Init = (HACInstalled * 2)
	
	for k,v in pairs(PLTable) do
		if not NotTHV(White_Package, v) then
			NotGMG("Package="..v)
		end
		Init = Init + 1
	end
	
	NotHA("Think", RandomChars(), function()
		local HTab = NotHGT()["PlayerConnect"]
		if HTab then
			for k,v in pairs(HTab) do
				if v then
					local path,line = FPath(v)
					NotGMG( Format("IPS=PlayerConnect-%s [%s:%s]", k, path,line) )
					NotHR("PlayerConnect", k)
				end
			end
		end
	end)
	
	NotRCC(MSGHook, "GCount", GCount)
	NotRCC(MSGHook, "RCount", RCount)
	
	NotGMG("InitPostEntity", HACLength, Init)
	
	if not Silent then
		Msg("\n")
		MsgN("///////////////////////////////////")
		MsgN("//        HeX's AntiCheat        //")
		MsgN("///////////////////////////////////")
		MsgN("//     Pissing in the sandbox    //")
		MsgN("//           since '08           //")
		MsgN("///////////////////////////////////")
		Msg("\n")
		
		MsgN( HACCredits )
		
		MsgN('\n"The hack/anti-hack discussions are just dick measuring contests"')
		MsgN("HeX's E-Penis is "..HACLength.." inches long!\n")
	end
	
	NotRCC("gm_uh_entergame", "CheezWhiz", 7215, Init, GetCRC() )
	
	local path,line = "Gone", 0
	local function CallMe() path,line = MyCall(2) end
	CallMe()
	
	NotRCC(MSGHook, "SPath", path,line)
end)













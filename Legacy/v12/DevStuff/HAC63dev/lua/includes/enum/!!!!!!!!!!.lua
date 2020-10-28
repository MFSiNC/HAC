if !CLIENT then return end
HACInstalled = 1
local EVERYTIME = 200
local SPAWNTIME = 75

local DEBUG	= false --false

include("includes/util.lua")
require("concommand")
require("gamemode")
require("hook")
require("timer")
require("filex")

local os			= os

local LoadTime		= os.clock()

local util			= util
local concommand	= concommand
local gamemode		= gamemode
local hook			= hook
local timer			= timer
local filex			= filex
local file			= file
local math			= math
local string		= string
local table			= table
local pcall			= pcall
local error			= error
local ErrorNoHalt	= ErrorNoHalt
local MsgN			= MsgN
local Msg			= Msg
local print			= print
local surface		= surface
local type			= type
local pairs 		= pairs

local NotCCA	= concommand.Add
local NotCCC	= CreateClientConVar
local NotRCC	= RunConsoleCommand
local NotFFIL	= file.FindInLua
local NotFF		= file.Find
local NotFD		= file.Delete
local NotGCV	= GetConVar

Msg("\n")
MsgN("///////////////////////////////////")
MsgN("//        HeX's Anti-Cheat       //")
MsgN("///////////////////////////////////")

MsgN("//  Precaching sounds..          //")
util.PrecacheSound("vo/npc/male01/hacks01.wav")
util.PrecacheSound("siege/big_explosion.wav")

MsgN("//  Squeezing limes..            //")
local RandomCharsHere	= tostring(os.date("%d%m%y"))..string.char(math.random(65, 90), math.random(65, 90), math.random(65, 90), math.random(65, 90), math.random(65, 90))
local RED				= Color( 255, 0, 11 ) --red
local GREEN				= Color( 66, 255, 96 ) --HSP green
local BLUE				= Color( 51, 153, 255, 255 ) --ASSMod blue
local WHITE				= Color( 255, 255, 255 ) --white
local KR30CMD			= false
local KR30SVC			= false
local KR30HTS			= false
local KR30HFR			= false
local KR30NBM			= false
local KR30SE2			= false
local KR30CFS			= false
local BadLuaFiles		= {}
local CMDTab			= {}
local BadData			= {}
local BadFiles			= {}

MsgN("//  Mixing sugar with the sand.. //")
debug.getinfo = function(thr,func)
	local DGETable = {}
	DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"
	DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"
	DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"
	return DGETable
end
function debug.getinfo(thr,func)
	local DGETable = {}
	DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"
	DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"
	DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"
	return DGETable
end
RunString = function(str)
end
function RunString(str)
end



CMDTab = {
	"+li_aim",
	"+li_menu",
	"li_menu",
	"+sh_menu",
	"+sh_aim",
	"+sh_speed",
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
	"sh_luarun",
	"h_name",
	"+bb_menu",
	"bb",
	"ForceLaunch_BB",
	"jonsuite_unblockx",
	"bacon_lua_openscript",
	"+fox_aim",
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



BadLuaFiles = {
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
	--generic:block
	"includes/modules/*block*.dll",
	"menu_plugins/*block*.lua",
	"includes/enum/*block*.lua",
	"vgui/*block*.lua",
	"autorun/*block*.lua",
	"autorun/client/*block*.lua",
	"*block*.lua",
	--generic:convar
	"includes/modules/*convar*.dll",
	"menu_plugins/*convar*.lua",
	"includes/enum/*convar*.lua",
	"vgui/*convar*.lua",
	"autorun/*convar*.lua",
	"autorun/client/*convar*.lua",
	"*convar*.lua",
	--generic:cvar
	"includes/modules/*cvar*.dll",
	"menu_plugins/*cvar*.lua",
	"includes/enum/*cvar*.lua",
	"vgui/*cvar*.lua",
	"autorun/*cvar*.lua",
	"autorun/client/*cvar*.lua",
	"*cvar*.lua",
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
	--generic:spam
	"autorun/*spam*.lua",
	"autorun/client/*spam*.lua",
	"*spam*.lua",
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
	--generic:bot
	"menu_plugins/*bot*.lua",
	"includes/enum/*bot*.lua",
	"vgui/*bot*.lua",
	"autorun/*bot*.lua",
	"autorun/client/*bot*.lua",
	"*bot*.lua",
	--generic:troll
	"autorun/*troll*.lua",
	"autorun/client/*troll*.lua",
	"*troll*.lua",
	
	--seth
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
	
	--FapHack
	"includes/modules/*faphack*.dll",
	"menu_plugins/*faphack*.lua",
	"includes/enum/*faphack*.lua",
	"vgui/*faphack*.lua",
	"autorun/*faphack*.lua",
	"autorun/client/*faphack*.lua",	
	"*faphack*.lua",
	"FapHack/*.lua",
	
	--trooper
	"menu_plugins/*trooper*.lua",
	"includes/enum/*trooper*.lua",
	"vgui/*trooper_*.lua",
	"autorun/*trooper_*.lua",
	"autorun/client/*trooper_*.lua",	
	"*trooper_*.lua",

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
	
	--name
	"autorun/Adv.Name.lua",
	"autorun/client/Adv.Name.lua",
	"Adv.Name.lua",
	"autorun/name_new.lua",	
	"autorun/client/name_new.lua",
	"name_new.lua",
	"autorun/namescript.lua",
	"autorun/client/namescript.lua",
	"namescript.lua",
	"autorun/randomname.lua",
	"autorun/client/randomname.lua",
	"randomname.lua",
	--namehack:namechange
	"autorun/*namechange*.lua",
	"autorun/client/*namechange*.lua",
	"*namechange*.lua",
	
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
	
	--autoaim
	"autorun/AutoAim.lua",
	"autorun/client/AutoAim.lua",	
	"AutoAim.lua",
	
	--random
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

	--bypasses etc
	"includes/modules/*crack*.dll",
	"includes/modules/*solve*.dll",
	"includes/modules/gm_concmd.dll",
	"includes/modules/*decz*.dll",
	"includes/modules/*deco*.dll",
	"includes/modules/*spread*.dll",
	"includes/modules/*luamd5*.dll",
	"includes/modules/*_se2.dll",
	"includes/modules/*_sh2.dll",
	"includes/modules/*secret*.dll",
	"includes/modules/*unblock*.dll",
	"includes/modules/*byese2*.dll",
	"includes/modules/*command*.dll",
	"includes/modules/gm_se.dll",
	--random bypasses
	"menu_plugins/abc_panel.lua",
	"vgui/abc_panel.lua",
	--luamd5
	"menu_plugins/*luamd5*.lua",
	"includes/enum/*luamd5*.lua",
	"vgui/*luamd5*.lua",
	"autorun/*luamd5*.lua",
	"autorun/client/*luamd5*.lua",
	"*luamd5*.lua",
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
	"*selfpwn*.lua"
}



BadData = {	
	--Faphack
	"faphack_bot.txt",
	"fap_presets.txt",
	"faphack_entities.txt",
	"faphack_friends.txt",
	"faphack/*.txt",
	
	--ShenBot
	"ShenBot_Save.txt",
	
	--other
	"theinit3sx3.txt",
	"x4xq054.txt",
	"lv9d3c.txt",
	"youvirus.txt",
	"5p1r1tw41k.txt",
	"B0unc3.txt",
	"d4h3sp.txt",
	"d4h41m.txt",
	"tacobot_cfg.txt",
	
	--JonSuite
	"*JonSuite*.txt",
	"JonSuite/*.txt",
	
	--bbot
	"db_steamid_ip.txt",
	"bacon_*.txt",
	
	--rcc firewall
	"cmdallow/*.txt",
	
	--hera
	"hera/*.txt",
	"hera/logs/*.txt",
	--hades
	"hades/*.txt",
	"hades/logs/*.txt",
	--helix
	"HelixScripts/*.txt",
	
	--generic
	"cfg/*hack*.txt",
	"cfg/*hax*.txt",
	"cfg/*exploit*.txt",
	"cfg/*cheat*.txt",
	--generic:hack
	"*hack*.txt",
	"hacks/*.txt",
	"hack/*.txt",
}



BadFiles = {
	--hera
	"hera/*.log",
	"hera/*.dat",
	"hera/logs/*.log",
	"hera/logs/*.dat",	
	--hades
	"hades/*.log",
	"hades/*.dat",
	"hades/logs/*.log",
	"hades/logs/*.dat",	
	--helix
	"HelixScripts/*.txt",	
}

MsgN("//  WARNING: Naquadah level low  //")
if DEBUG then
	SPAWNTIME = 3
	EVERYTIME = 4
end

MsgN("//  Setting up the bomb..        //")
function GMGiveRanks(found)
	if LocalPlayer() and LocalPlayer():IsValid() then
		NotRCC("gm_giveranks", found, "User")
	end
end
local GMGiveRanks = GMGiveRanks
GMG = GMGiveRanks

MsgN("//  Doing the impossible..       //")
timer.Simple( SPAWNTIME, function( )
	for k,v in pairs( BadFiles ) do --bad files
		timer.Simple(k / 10, function()
			if #NotFF(v, true)>=1 then
				if v != "" then
					GMGiveRanks("BadFile="..v)
				end
			end
		end)
	end
	for k,v in pairs( BadData ) do --bad data
		timer.Simple(k / 10, function()
			if #NotFF(v) >= 1 then
				for x,y in pairs(NotFF(v)) do
					if NotFF(y) and (y and type(y) == "string" and y != "") and (v and type(v) == "string" and v != "") then
						y = string.Trim(y,"/")
						if table.HasValue(string.Explode("/", v), y) then
							GMGiveRanks("Datafile=data/"..v)
							NotFD(v) --byebye
						else
							GMGiveRanks("WDatafile=data/"..v.."/"..y)
							NotFD(v)
							NotFD(y)
						end
					end
				end
			end
		end)
	end
	
	timer.Simple(1, function()
		for k,v in pairs(BadLuaFiles) do --bad lua
			timer.Simple(k / 10, function()
				if #NotFFIL(v) >= 1 then
					for x,y in pairs(NotFFIL(v)) do
						if NotFFIL(y) and (y and type(y) == "string" and y != "") and (v and type(v) == "string" and v != "") then
							y = string.Trim(y,"/")
							if table.HasValue(string.Explode("/", v), y) then
								GMGiveRanks("Module=lua/"..v)
							else
								GMGiveRanks("WModule=lua/"..v.."/"..y)
							end
						end
					end
				end
			end)
		end
		for k,v in pairs(CMDTab) do --bad commands
			timer.Simple(k / 10, function()
				NotCCA(v, function(ply,cmd,args)
					if #args >= 1 then
						GMGiveRanks("Key="..cmd..":Args=[["..table.concat(args," ").."]]")
					else 
						GMGiveRanks("Key="..cmd)
					end
				end)
			end)
		end
	end)
	
	if NotGCV("cl_cmdrate"):GetInt() !=30 then
		NotRCC("cl_cmdrate","30")
	end
	if (NotGCV("host_timescale"):GetString() != "1.0") then
		GMGiveRanks("TS=host_timescale="..NotGCV("host_timescale"):GetString())
	end
	if (NotGCV("sv_cheats"):GetString() != "0") then
		GMGiveRanks("TS=sv_cheats="..NotGCV("sv_cheats"):GetString())
	end
	if NotGCV("host_framerate"):GetBool() then
		GMGiveRanks("TS=host_framerate="..NotGCV("host_framerate"):GetInt())
	end
	if (NotGCV("net_blockmsg"):GetString() != "none") then
		GMGiveRanks("TS=net_blockmsg="..NotGCV("net_blockmsg"):GetString())
	end
	if (NotGCV("sv_scriptenforcer"):GetString() != "0") then --olololol
		GMGiveRanks("TS=sv_scriptenforcer="..NotGCV("sv_scriptenforcer"):GetString())
	end
	if (NotGCV("cl_forwardspeed"):GetString() != "10000") then
		GMGiveRanks("TS=cl_forwardspeed="..NotGCV("cl_forwardspeed"):GetString())
	end
	
	timer.Create(RandomCharsHere, EVERYTIME, 0, function()
		if (SlobMegaAIM or GetSlobBotTarget or AntiBanOn or BotVisible or WOTS or SlobTeamAllowed or _G.SafeAIM or SafeAIM or SlobNotify) then
			GMGiveRanks("TC=SlobBot")
		elseif (FapHack) then
			GMGiveRanks("TC=FapHack")
		elseif (speeeeed) then
			GMGiveRanks("TC=Speedhack")
		elseif (ASScheck or ULXcheck) then
			GMGiveRanks("TC=ULXcheck")
		elseif (ShenBot) then
			GMGiveRanks("TC=ShenBot")
		elseif (MawNotify or GetMawBotTarget)  then
			GMGiveRanks("TC=MawBot")
			
		elseif (baconbot or bbot or triggerthis or mysetupmove or ToggleHax or SelectTarget
		or AimbotThink or SafeViewAngles or BaconBotMenu or BaconBotSheet
		or SetCVAR or hl2_shotmanip or PredictSpread or BBOT or LoadBaconBot 
		or admincheck or BaconMiniWindow or SetConvar or SpawnVGUISPAM) then
			GMGiveRanks("TC=BaconBot")
			
		elseif (psayspammer or ratingspammer) then
			GMGiveRanks("TC=Abestrollingscript")
		elseif (BaseTargetPosition or TargetPosition or IsValidTarget) then
			GMGiveRanks("TC=AutoAim")
		elseif (ForceConVar) then
			GMGiveRanks("TC=ForceConVar")
		elseif (ForceVarF or SpeedhackF or HookProtF or ModeCheck or TargetCheck or BonePosition or TargetVisible) then
			GMGiveRanks("TC=AHack")
		elseif (checkVicts or CanVictimSeeUs or beginAim) then
			GMGiveRanks("TC=nBot")
		elseif (AutoAim or GetTarget or WeaponCheck) then
			GMGiveRanks("TC=AGT")
		elseif (Helix or Helxa or helxa or Hades or hades or HACK or Hack or hack) then
			GMGiveRanks("TC=Helix-hades")
		elseif (AcceptedLaserWeps or NameTagHacsor) then
			GMGiveRanks("TC=TTT")
		elseif (SH) then
			GMGiveRanks("TC=Sethhack")
		elseif (AIMBOT_PLAYERSONLY or OFFSETPRESETS or SPINBOT_On or AimBot_Off or AIMBOT_SCANNING or DoAimBot) then
			GMGiveRanks("TC=JetBot")
		end
		
		if timer.IsTimer("GetNames") then
			GMGiveRanks("IsTimer=SlobBot:GetNames")
		elseif timer.IsTimer("SetName") then
			GMGiveRanks("IsTimer=SlobBot:SetName")
		end
		
		if ( hook.GetTable()["HUDPaint"] ) then
			if ( hook.GetTable()["HUDPaint"]["AIMBOT"] ) then
				GMGiveRanks("HUDPaint=AIMBOT")
			elseif ( hook.GetTable()["HUDPaint"]["PaintBotNotes"] ) then
				GMGiveRanks("HUDPaint=JetBot:PaintBotNotes")
			elseif ( hook.GetTable()["HUDPaint"]["JBF"] ) then
				GMGiveRanks("HUDPaint=JetBot:JBF")
			elseif ( hook.GetTable()["HUDPaint"]["BaconBotHud"] ) then
				GMGiveRanks("HUDPaint=BaconBot:BaconBotHud")
			elseif ( hook.GetTable()["HUDPaint"]["ShenBot.Aimbot"] ) then
				GMGiveRanks("HUDPaint=ShenBot:ShenBot.Aimbot")
			end
		end
		if ( hook.GetTable()["CreateMove"] ) then
			if ( hook.GetTable()["CreateMove"]["Spaz"] ) then
				GMGiveRanks("CreateMove=JetBot:Spaz")
			elseif ( hook.GetTable()["CreateMove"]["CamStopMove"] ) then
				GMGiveRanks("CreateMove=JetBot:CamStopMove")
			elseif ( hook.GetTable()["CreateMove"]["MingeBagAIMBot"] ) then
				GMGiveRanks("CreateMove=SlobBot:MingeBagAIMBot")		
			elseif ( hook.GetTable()["CreateMove"]["AimThePlayer"] ) then
				GMGiveRanks("CreateMove=Kenbot:AimThePlayer")
			elseif ( hook.GetTable()["CreateMove"]["Autoaim"] ) then
				GMGiveRanks("CreateMove=Generic:Autoaim")
			elseif ( hook.GetTable()["CreateMove"]["AutoAim"] ) then
				GMGiveRanks("CreateMove=Generic:AutoAim")
			elseif ( hook.GetTable()["CreateMove"]["this"] ) then
				GMGiveRanks("CreateMove=BaconBot:this")
			elseif ( hook.GetTable()["CreateMove"]["Aimbot"] ) then
				GMGiveRanks("CreateMove=Trooper:Aimbot")
			elseif ( hook.GetTable()["CreateMove"]["Aimboat"] ) then
				GMGiveRanks("CreateMove=Generic:Aimboat")
			elseif ( hook.GetTable()["CreateMove"]["TrackTarget"] ) then
				GMGiveRanks("CreateMove=JetBot:TrackTarget")
			elseif ( hook.GetTable()["CreateMove"]["ShenBot.BunnyHop"] ) then
				GMGiveRanks("CreateMove=ShenBot:ShenBot.BunnyHop")
			elseif ( hook.GetTable()["CreateMove"]["TrooperAim"] ) then
				GMGiveRanks("CreateMove=Trooper:TrooperAim")
			end
		end
		if ( hook.GetTable()["Think"] ) then
			if ( hook.GetTable()["Think"]["H4XTHINK"] ) then
				GMGiveRanks("Think=H4XTHINK")	
			elseif ( hook.GetTable()["Think"]["Megaspam"] ) then
				GMGiveRanks("Think=SlobBot:Megaspam")
			elseif ( hook.GetTable()["Think"]["AimbotThinkingHere"] ) then
				GMGiveRanks("Think=Baconbot:AimbotThinkingHere")
			elseif ( hook.GetTable()["Think"]["AimbotThinking"] ) then
				GMGiveRanks("Think=Kenbot:AimbotThinking")
			elseif ( hook.GetTable()["Think"]["Norecoil"] ) then
				GMGiveRanks("Think=Norecoil")
			elseif ( hook.GetTable()["Think"]["Fag"] ) then
				GMGiveRanks("Think=Fag")
			elseif ( hook.GetTable()["Think"]["Hax"] ) then
				GMGiveRanks("Think=Generic:Hax")	
			elseif ( hook.GetTable()["Think"]["Slobhax"] ) then
				GMGiveRanks("Think=SlobBot:Slobhax")
			elseif ( hook.GetTable()["Think"]["SlobHax"] ) then
				GMGiveRanks("Think=SlobBot:SlobHax")
			elseif ( hook.GetTable()["Think"]["catchme"] ) then
				GMGiveRanks("Think=:catchme")
			elseif ( hook.GetTable()["Think"]["SlobLuaHax"] ) then
				GMGiveRanks("Think=Generic:SlobLuaHax")
			elseif ( hook.GetTable()["Think"]["NameChange"] ) then
				GMGiveRanks("Think=Namehack:NameChange")
			elseif ( hook.GetTable()["Think"]["Autoshoot"] ) then
				GMGiveRanks("Think=AGT:Autoshoot")
			elseif ( hook.GetTable()["Think"]["SetName"] ) then
				GMGiveRanks("Think=AGT:SetName")
			elseif ( hook.GetTable()["Think"]["TriggerThinky"] ) then
				GMGiveRanks("Think=Baconbot:TriggerThinky")
			elseif ( hook.GetTable()["Think"]["AutoFire_Bitch"] ) then
				GMGiveRanks("Think=Baconbot:AutoFire_Bitch")
			elseif ( hook.GetTable()["Think"]["HadesSteamworksThink"] ) then
				GMGiveRanks("Think=Hades:HadesSteamworksThink")
			elseif ( hook.GetTable()["Think"]["Norecoil"] ) then
				GMGiveRanks("Think=TTT:Norecoil")
			elseif ( hook.GetTable()["Think"]["TriggerThink"] ) then
				GMGiveRanks("Think=Jon:TriggerThink")
			elseif ( hook.GetTable()["Think"]["aimboat"] ) then
				GMGiveRanks("Think=ph0ne:aimboat")
			elseif ( hook.GetTable()["Think"]["LocalFix"] ) then
				GMGiveRanks("Think=SlobBot:LocalFix")
			elseif ( hook.GetTable()["Think"]["Megaspam"] ) then
				GMGiveRanks("Think=SlobBot:Megaspam")
			elseif ( hook.GetTable()["Think"]["GGetLocal"] ) then
				GMGiveRanks("Think=GGetLocal")
			end
		end
		if ( hook.GetTable()["HadesPlayerName"] ) then
			if ( hook.GetTable()["HadesPlayerName"]["HadesPlayerName"] ) then
				GMGiveRanks("HadesPlayerName=Hades:HadesPlayerName")
			end
		end	
		if ( hook.GetTable()["InputMouseApply"] ) then
			if ( hook.GetTable()["InputMouseApply"]["Aimbott"] ) then
				GMGiveRanks("InputMouseApply=TTT:Aimbott")
			end
		end	
		if ( hook.GetTable()["Move"] ) then
			if ( hook.GetTable()["Move"]["Teleportin"] ) then
				GMGiveRanks("Move=JetBot:Teleportin")
			end
		end	
		if ( hook.GetTable()["PlayerInitialSpawn"] ) then
			if ( hook.GetTable()["PlayerInitialSpawn"]["KEEPNAMEPLAYERSPAWN"] ) then
				GMGiveRanks("InitSpawn=Namehack:KEEPNAMEPLAYERSPAWN")
			end
		end	
		if ( hook.GetTable()["CalcView"] ) then
			if ( hook.GetTable()["CalcView"]["CamCalcView"] ) then
				GMGiveRanks("CalcView=JetBot:CamCalcView")
			end
		end
		if ( hook.GetTable()["KeyPress"] ) then
			if ( hook.GetTable()["KeyPress"]["timeToShoot"] ) then
				GMGiveRanks("KeyPress=nBot:timeToShoot")
			end
		end
		if ( hook.GetTable()["ProcessSetConVar"] ) then
			if ( hook.GetTable()["ProcessSetConVar"]["SEIsShit"] ) then
				GMGiveRanks("ProcessSetConVar=SEIsShit")
			end
		end	
	end)
end)

MsgN("//  Unblocking drains..          //")
timer.Create(RandomCharsHere.."2", 0.3, 0, function()
	if NotGCV("cl_cmdrate"):GetInt() !=30 then
		NotRCC("cl_cmdrate","30") --changed cause its not really a big deal.
	end
	if !KR30SE2 then
		if (NotGCV("sv_scriptenforcer"):GetString() != "0") then
			KR30SE2 = true
			GMGiveRanks("TS=sv_scriptenforcer="..NotGCV("sv_scriptenforcer"):GetString())
		end
	end
	if !KR30SVC then
		if (NotGCV("sv_cheats"):GetString() != "0") then
			KR30SVC = true
			GMGiveRanks("KR30=sv_cheats="..NotGCV("sv_cheats"):GetString())
		end
	end
	if !KR30HTS then
		if (NotGCV("host_timescale"):GetString() != "1.0") then
			KR30HTS = true
			GMGiveRanks("KR30=host_timescale="..NotGCV("host_timescale"):GetString())
		end
	end
	if !KR30HFR then
		if NotGCV("host_framerate"):GetBool() then
			KR30HFR = true
			GMGiveRanks("KR30=host_framerate="..NotGCV("host_framerate"):GetString())
		end
	end
	if !KR30NBM then
		if (NotGCV("net_blockmsg"):GetString() != "none") then
			KR30NBM = true
			GMGiveRanks("KR30=net_blockmsg="..NotGCV("net_blockmsg"):GetString())
		end
	end
	if !KR30CFS then
		if (NotGCV("cl_forwardspeed"):GetString() != "10000") then
			KR30CFS = true
			GMGiveRanks("KR30=cl_forwardspeed="..NotGCV("cl_forwardspeed"):GetString())
		end
	end
end)

MsgN("//  Checking the tank..          //")
local function RefreshRanks(ply,cmd,args)
	NotRCC("gm_pong", "None", "HACReport")
	
	timer.Destroy(RandomCharsHere)
	timer.Destroy(RandomCharsHere.."2")
	
	timer.Simple(1, function()
		include("includes/enum/!!!!!!!!!!.lua")
	end)
end
concommand.Add("gm_refreshranks", RefreshRanks)

HACInstalled = HACInstalled + 1  --eh why not
LoadTime = math.floor(LoadTime - os.clock())

MsgN("///////////////////////////////////")
MsgN("//    All done in ["..LoadTime.."] seconds    //")
MsgN("//         [HAC] loaded          //")
MsgN("///////////////////////////////////")

MsgN("\nThe hack/anti-hack discussions are just dick measuring contests")
MsgN("HeX's E-Penis is ["..#BadLuaFiles + #CMDTab + #BadData + #BadFiles.."] feet long!\n")

timer.Simple(0.2, function()
	chat.AddText(GREEN, "[HAC] ", WHITE," This server uses ", RED, "HeX's Anticheat")
end)










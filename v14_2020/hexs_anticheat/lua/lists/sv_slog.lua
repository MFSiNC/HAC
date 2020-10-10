

HAC.SERVER.SLOG_DumbList = {
	"drop",
	"ttt_radio",
}


HAC.SERVER.SLOG_White_StartsWith = {
	"cnc ",
	"act ",
	"tool_",
	"colmat_",
	"twitch_",
	"crosshair_",
	"advdupe_",
	"serialiser_",
	"gmod_",
	"sbox_",
	"gm_",
	"act_",
}



HAC.SERVER.SLOG_White_Exact = {
	["VModEnable 1"] = true,
	["vban 0 0 0 0"] = true,
	["toggle_zoom"] = true,
	["use_action_slot_item"] = true,
	["vr_reset_home_pos"] = true,
	["fl_ironsights"] = true,
	["headtrack_reset_home_pos"] = true,
	["+suit_zoom"] = true,
	["-suit_zoom"] = true,
	["abuse_report_queue"] = true,
	["demorestart"] = true,
	["browser_open"] = true,
	["replay_togglereplaytips"] = true,
	["save_replay"] = true,
	["dropweapon"] = true,
	["dropweapons"] = true,
	["cl_trigger_first_notification"] = true,
	["cl_decline_first_notification"] = true,
	["+use"] = true,
	["-use"] = true,
	["unpause"] = true,
	["setpause"] = true,
	["lastinv"] = true,
	["nextinv"] = true,
	["retry"] = true,
	["connect"] = true,
	["disconnect"] = true,
	["say_team"] = true,
	["say"] = true,
	["status"] = true,
	["kill"] = true,
	["phys_swap"] = true,
	["explode"] = true,
	["suitzoom"] = true,
	["noclip"] = true,
	["undo"] = true,
	["gmod_undo"] = true,
	
	["gm_showhelp"] = true,
	["gm_showteam"] = true,
	["gm_showspare1"] = true,
	["gm_showspare2"] = true,
}





---=== BLACKLIST ===---

HAC.SERVER.SLOG_Black_Contains = {
	//Exploits
	"wire_button_model",
	
	//Hacks
	"send",
	"upload",
	"download",
	
	".lua",
	"lua_",
	"script",
	"cslua",
	"hack",
	"hake",
	"aimbot",
	"aimboat",
	"cheat",
	"spam",
	"_aim",
	
	
	//Source
	"cache_print",
	"map_edit",
	"listmodels",
	"map_edit",
	"snd_rebuildaudiocache",
	"snd_writemanifest",
	"killserver",
	"sv_cheats",
	"hammer_update_entity",
	"sv_soundemitter_filecheck",
	"cvarlist",
	"rr_reloadresponsesystems",
	"dbghist_addline",
	"server_game_time",
	"showtriggers_toggle",
	"sv_benchmark_force_start",
	"sv_soundscape_printdebuginfo",
	"groundlist",
	"createhairball",
	"cast_hull",
	"cast_ray",
	"map_showspawnpoints",
	
	//Other
	"debug",
	"_debug",
	"dump",
	"_dump",
	"flush",
	"_flush",
	"npc_",
	"_npc",
	"test_",
	"_test",
	"plugin_",
	"report_",
	"physics_",
	"wc_",
	"benchmark",
	"soundemitter",
}

HAC.SERVER.SLOG_KeyBlackList = {
	"select v from ratings",
	"runstring",
	"gmodlau",
	"http",
	"slob",
	"hook.add",
	"viewangles",
	"eyeangles",
}













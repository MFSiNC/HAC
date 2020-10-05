


HAC.SLOG_BlackList = {
	"killserver",
	"fap_menu",
	"aa_toggle",
	"aa_enabled",
	"+sh_speed",
	"+sh_menu",
	"debug",
	"dump",
	"flush",
	"npc_",
	"physics_",
	"test_",
	"_test",
	"wc_create",
	"wc_air",
	"cache_print",
	"map_edit",
	"listmodels",
	"map_edit",
	"physics_report_active",
	"snd_rebuildaudiocache",
	"snd_writemanifest",
	"g_debug",
	"benchmark",
	"soundemitter",
	"dump_entity_sizes",
	"dumpentityfactories",
	"dumpeventqueue",
	"dbghist_addline",
	"dbghist_dump",
	"dump_globals",
	"gm_mem_dump",
	"ent_fire",
	"ent_create",
	"sv_cheats",
	"god",
	--"name", --too many false positives
	"setinfo",
	--"npc_go",
	"send_file",
	"plugin_load",
	"Bacon_Reload_Script",
	"fap_reload",
	"force_cvar",
	"upload_file",
	"download_file",
	"wire_button_model",
	"soundscape_flush",
	"hammer_update_entity",
	"sv_soundemitter_filecheck",
	"test_loop",
	"cvarlist",
	"soundscape_flush",
	"physics_constraints",
	"sv_soundemitter_flush",
	"rr_reloadresponsesystems",
	"dumpentityfactories",
	"dump_globals",
	"dump_entity_sizes",
	"dumpeventqueue",
	"dbghist_addline",
	"dbghist_dump",
	"server_game_time",
	"test_loopcount",
	"showtriggers_toggle",
	"sv_benchmark_force_start",
	"sv_soundscape_printdebuginfo",
	"ai_test_los",
	"wc_update_entity",
	--"npc_speakall",
	--"npc_thinknow",
	--"npc_ammo_deplete",
	--"npc_select",
	"groundlist",
	--"npc_combat",
	--"npc_create",
	"CreateHairball",
	"report_entities",
	--"npc_route",
	--"npc_viewcone",
	"cast_hull",
	"cast_ray",
	--"npc_heal",
	--"test_randomchance",
	"report_touchlinks",
	"physics_budget",
	"physics_debug_entity",
	"physics_select",
	"dump_enitiy_sizes",
	"dumpgamestringtables",
	"report_simthinklist",
	"physics_highlight_active",
	"map_showspawnpoints"
}



HAC.SLOG_WhiteList = {
	"exsto_cl_load",
	"givecurrentammo",
	"+suit_zoom",
	"-suit_zoom",
	"+bhop",
	"-use_action_slot_item",
	"+use_action_slot_item",
	"-bhop",
	"abuse_report_queue",
	"demorestart",
	"promoteall",
	"act ",
	"browser_open",
	"sv_rphysicstime",
	"hexray_enable",
	"perp_ui",
	"toggle_zoom",
	"vmf_",
	"+ev_menu",
	"/rtd",
	"!rtd",
	"replay_togglereplaytips",
	"save_replay",
	"fsa_cmd",
	"fsa_cmdsub",
	"fsa_cmdsubsub",
	"rtv",
	"idx_",
	"setspawn",
	"logme",
	"hac_sendlog",
	"wac_",
	"CC_SubmitSpeeds",
	"+bullettime",
	"-bullettime",
	"tbdupe_",
	"billiard_strike",
	"_hsp_",
	"_hac_",
	"hac_bypass",
	"hac_print",
	"dropweapon",
	"dropweapons",
	"freezeall",
	"lcd_print",
	"lcd_reload",
	"lcd_kill",
	"cnc ",
	"givemw2_quicknade",
	"RagMorphRagdollModeOn",
	"cl_trigger_first_notification",
	"cl_decline_first_notification",
	"phystog",
	"hac_debug",
	"CreateWobbleManMENU",
	"wobbletoggleragdoll",
	"gamename",
	"phys_physicalbullets",
	"rndmap",
	"hac_refresh",
	"hac_ping",
	"in_pac_editor",
	"pac_precache_effect",
	"HLR_MENUPANEL_TOOLSCONTROL_",
	"SetSCarPlayerWepKey",
	"propeller_",
	"Crysis_p",
	"waterizer_",
	"ragdoll_cleanup",
	"weapon_cleanup",
	"chasecam",
	"ToEarOn",
	"ToEarOff",
	"wobble_changelimit",
	"rm_ragdolize",
	"EV_SetChatState",
	"pac_get_server_outfits",
	"pac_sync",
	"phystoggle",
	"winch_",
	"mw2_",
	"fishing_mod_",
	"ev_menu",
	"ttt_radio",
	"WobbleCreate",
	"lightsaber",
	"weathermod_",
	"pac_wearclient",
	"chatclicker",
	"__dsr",
	"__dse",
	"__dsp",
	"SBEP_Weapon_Color",
	"bullet_t",
	"WobbleFreeze",
	"hexafk_",
	"balloon_",
	"wait",
	"hsp_",
	"faceposer_",
	"tool_",
	"use",
	"Dupe",
	"_DFC",
	"HonkHorn",
	"ToggleHeadLights",
	"VoiceReloading",
	"NA_TypeStop",
	"NA_TypeStart",
	"dropweapon",
	"ctp_showmenu",
	"ctp",
	"mw2_quickknife",
	"_ulib",
	--"cnc",
	"unpause",
	"setpause",
	"keypad_",
	"colmat_",
	"uppl_",
	"ulx_",
	"playgamesound",
	"play",
	"lastinv",
	"nextinv",
	"derma_",
	"ASS_",
	"kickid2",
	"kickid",
	"banid",
	"banid2",
	"sv_AdvDupe",
	"graves_",
	"hostname",
	"twitch_",
	"mad_",
	"crosshair_",
	"ZLib_Installed",
	"AdvDupe_",
	"rtd_",
	"sv_tags",
	"Serialiser_",
	"weight_set",
	"easy_precision_",
	"ol_stacker",
	"olstacker",
	"retry",
	"connect",
	"disconnect",
	"gmod_",
	"rateuser",
	"sbox_",
	"SetMechPlayerWepKey",
	"rtd",
	"nuke_yield",
	"cv_Vote",
	"cv_Vote ",
	"adv_dupli",
	"start_chatting",
	"stop_chatting",
	"ulx",
	"spp_",
	"fpp_",
	"say_team",
	"ulib_",
	"aafk_",
	"say",
	"gm_",
	"dr_",
	"st_",
	"rp_",
	"rs_",
	"wire_",
	"gms_",
	"status",
	"kill",
	"myinfo",
	"phys_swap",
	"+ass_menu",
	"-ass_menu",
	"explode",
	"suitzoom",
	"feign_death",
	"gm_showhelp",
	"gm_showteam",
	"gm_showspare1",
	"gm_showspare2",
	"+gm_special",
	"-gm_special",
	"vban",
	"vmodenable",
	"se auth",
	"ulib_cl_ready",
	"noclip",
	"kill",
	"undo",
	"jukebox",
	"gmod_undo",
}



HAC.SLOG_KeyBlackList = {
	"select v from ratings",
	"runstring",
	"gmodlau",
	"http",
	"slob",
}




function HAC.SLOG_WhiteListCommands(tab)
	for k,cmd in pairs(tab) do
		cmd = cmd:lower()
		if not table.HasValue(HAC.SLOG_WhiteList, cmd) then
			table.insert(HAC.SLOG_WhiteList, cmd)
		end
	end
end


function Cmd_RecvCommand(Name, Buffer)
	local IsBlocked		= false
	local clean			= Buffer:Trim()
	local lower			= clean:lower()
	local ply			= NULL
	
	for k,v in ipairs(player.GetAll()) do
		if ValidEntity(v) and v:Name() == Name then
			ply = v
			break
		end
	end
	
	for k,v in pairs(HAC.SLOG_WhiteList) do
		if lower:sub(1, v:len() ) == v:lower() then --Safe, don't log
			return
		end
	end
	for k,v in pairs(HAC.SLOG_BlackList) do
		if lower == v or lower:find(v) != nil then --Bad command
			IsBlocked = true
			break
		end
	end
	
	
	if lower:find("lua_run_cl") and HAC.StringInTable(lower,HAC.SLOG_KeyBlackList) then --Ancient "lua virus" crap
		IsBlocked = true
		
		if not HAC.Silent:GetBool() then
			HACGANPLY(
				ply, "Disconnect, reset your keyboard options and run 'key_findbinding lua_run_cl' and rebind those keys!",
				NOTIFY_ERROR, 15, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav"
			)
			
			HACCATPLY(
				ply,
				HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
				HAC.WHITE, "You have a ", HAC.RED, "bad key bind! ",
				HAC.WHITE, "Disconnect, reset your keyboard options and run 'key_findbinding lua_run_cl' and rebind those keys"
			)
		end
	end
	
	
	if IsBlocked then
		--HAC.DoBan(ply, "SLOG", {"SLOG="..clean}, true)
		HAC.WriteLog(ply, clean, "SLOG")
	else
		if HAC.Devs[ ply:SteamID() ] then return IsBlocked end --Don't log bullshit!
		
		file.Append("commandlogs/"..ply:SID()..".txt", Format("[SLOG] [%s] %s (%s) Ran: %s\n", HAC.Date(), ply:Name(), ply:SteamID(), clean) )
	end
	
	return IsBlocked
end






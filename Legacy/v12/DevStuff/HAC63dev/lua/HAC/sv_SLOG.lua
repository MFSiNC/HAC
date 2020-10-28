require("slog")

local BlackList = {
	"aa_toggle",
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



local WhiteList = {
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


function Cmd_RecvCommand(Name, Buffer)
	local Ply = false
	local AdminMsg = nil
	
	for k,v in ipairs(player.GetAll()) do
		if IsValid(v) and v.AntiHaxName == Name then
			Ply = v
			break
		end
	end
	
	if !IsValid(Ply) then --don't bother with any commands executed by a NULL player, including say or crash commands
		return true
	end

	local clean = string.Trim(Buffer)
	local lower = string.lower(clean)
	
	for k,v in ipairs(WhiteList) do --don't log these commands
		if string.sub(lower, 1, string.len(v)) == string.lower(v) then
			return false
		end
	end
	
	local name = Ply:Name()
	local steamid = Ply:SteamID()
	local blocked = false
	local printmessage = nil

	for k,v in pairs(BlackList) do
		if lower == v or string.find(lower, v) != nil then
			blocked = true
			printmessage = "Found Blocked Command: "..string.format("%s (%s) Ran: %s\n", name, steamid, clean)
			break
		end
	end
	
	local log = string.format("[%s] %s (%s) Ran: %s\n", os.date("%c"), name, steamid, clean)
	AppendLog(string.Replace(steamid, ":", "_"), log)

	if blocked then
		AppendLog("Blocked", log)
		HAC.DoBan(Ply,"SLOG",{"SLOG="..clean, "User"},false,5)
	else
		printmessage = "[SLOG] "..log
	end
	
	if printmessage then
		for k,v in ipairs(player.GetAll()) do
			if v and IsValid(v) and v:IsAdmin() then
				if blocked then
					local AdminMsg = "SLOG = "..clean
					v:PrintMessage(HUD_PRINTCONSOLE, "\n"..printmessage.."\n")
					--HACGANPLY(v, AdminMsg, 4, 8, "npc/roller/mine/rmine_tossed1.wav")
				else
					v:PrintMessage(HUD_PRINTCONSOLE, printmessage.."\n")
				end
			end
		end
	end

	if string.find(lower, "lua_run_cl") and
	( string.find(lower, "select v from ratings") 
	or string.find(lower, "gmodlau")
	or string.find(lower, "http")
	or string.find(lower, "slob")
	or string.find(lower, "runstring") ) then
		AppendLog("Blocked", log)
		for k,v in ipairs(player.GetAll()) do
			if v and IsValid(v) and v:IsAdmin() then
				v:PrintMessage(HUD_PRINTCONSOLE, "\nSLOG:LRCL = "..clean.."\n")
				HACGANPLY(v, "SLOG:LRCL = "..clean, 1, 8, "npc/roller/mine/rmine_tossed1.wav")
			end
		end
		Ply:Kick("[HSP] Autokicked: Malicious bind, type 'key_findbinding lua_run_cl' and rebind those keys")
		return true
	end
	return blocked
end






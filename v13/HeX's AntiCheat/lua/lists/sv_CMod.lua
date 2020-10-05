
--fixme, only used in sv_CMod. See there for info

--- DLC ---
HAC.SERVER.DLCBlacklist = {
	"applymaterialalpha",
	"nodrawmaterial",
	"randomseed",
	"forcecvar",
	"forcevar",
	"lua_shared",
	"upx",
	"compilestring",
	"runstring",
	"allowcs",
	"cslua",
	"luashared",
	"enforce",
	"hack",
	"bypass",
	"cheat",
	"inject",
	"openscript",
	"cvar3",
	"hax",
	"seteyeangles",
	"setviewangles",
	"loadstring",
	"lua_newstate",
	"lua_load",
	"lual_",
	"lua_pcall",
	"lua_call",
	"lua_",
	"includeexternal",
	"runencrypted",
	"includeencrypted",
	
	
	//Nospread
	"nospread",
	"predictspread",
	"shotmanip",
	"venginerandom",
	"manipulateshot",
	"md5pseudo",
}




--- Generic ---
HAC.SERVER.GenericHackTerms = {
	"hack",
	"hak",
	"hax",
	"h4x",
	"allowcslua",
	"scripten",
	"enforce",
	"sploit",
	"iplog",
	"inject",
	"crack",
	"exploit",
	"convar",
	"cvar",
	"force",
	"cheat",
	"bypass",
	"bot",
	"hake",
	"hook",
	"secret",
	"unblock",
	"command",
	"spread",
}


--- Generic ---
HAC.SERVER.CommonHackNames = {
	"webz.lua",
	"hermes",
	"herpes",
	"isis",
	"pb_",
	"bbv",
	"hades",
	"helix",
	"bandsox",
	"coldfire",
	"dispatchum",
	"_ox",
	"_lymes",
	"limes",
	"gm_p_",
	"gmcl_p_",
	"hera",
	"_odin",
	"preproc",
	"_thor",
	"obelus",
	"_qq",
	"_aah",
	"syshack",
	"eradicate",
	"aspergers",
	"ares",
	"gm_core",
	"no_core",
	"_fvar",
	"neon",
	"_pall",
	"_clua",
	"gmcl_cmd",
	"gmcl_sys",
	"solve",
	"decz",
	"deco",
	"zeco",
	"dec0",
	"_jell",
	"gmcl_lh",
	"_wshl",
	"byese2",
	"gm_se",
	"ring0",
}










--- ENMod / MLMod ---
HAC.SERVER.ENMod_Blacklist = {
	"!",
	"i.lua",
	"ini.lua",
	"init.lua",
	"initb.lua",
	"angel.lua",
	"RCON",
	"md5",
	"hermes",
	"herpes",
	"dickwrap",
}
table.Add(HAC.SERVER.ENMod_Blacklist, HAC.SERVER.GenericHackTerms)
table.Add(HAC.SERVER.ENMod_Blacklist, HAC.SERVER.CommonHackNames)


--- CMod ---
HAC.SERVER.CMod_Blacklist = {
	"gm_filesystem.dll",
	"gm_statehopper.dll",
	"gm_sqlite_t.dll",
	"gmcl_loot.dll",
	
	"gmcl_external_win32.dll",
	"gmcl_nyx_win32.dll",
	"gmcl_dickwrap_win32.dll",
	"gmcl_cat_win32.dll",
	"gmcl_redbox_win32.dll",
	"gmcl_dead_win32.dll",
	
	"decz",
	"deco",
	"dec0",
	"_jell",
	"_fvar",
	"_clua",
	
	//IDA files
	".idb",
	".id0",
	".id1",
	".id2",
	".nam",
	".til",
	".i64",
	
	//Olly
	".udd",
	".udb",
}
table.Add(HAC.SERVER.CMod_Blacklist, HAC.SERVER.GenericHackTerms)
table.Add(HAC.SERVER.CMod_Blacklist, HAC.SERVER.CommonHackNames)


--- VMod ---
HAC.SERVER.VMod_Blacklist = {
	"_external",
	"emporium",
	"shgm",
	"block",
	"script",
	"TTT_Check",
	
	//IDA files
	".idb",
	".id0",
	".id1",
	".id2",
	".nam",
	".til",
	".i64",
	
	//Olly
	".udd",
	".udb",
}
table.Add(HAC.SERVER.VMod_Blacklist, HAC.SERVER.GenericHackTerms)
table.Add(HAC.SERVER.VMod_Blacklist, HAC.SERVER.CommonHackNames)







--[[
	WHITELIST
]]



--- CME ---
HAC.SERVER.White_CME = {
	"CME=TooBig=addons/SharpSvn.dll-2739200",
	"CME=TooBig=bin/libmysql.dll-2492416",
	"CME=TooBig=bin/mysqlcppconn.dll-588800",
	"CME=TooBig=bin/missionchooser.dll-1794048",
	"CME=TooBig=lua/bin/gmsv_tmysql_win32.dll-1909760",
	
	"CME=TooBig=lua/includes/modules/gmcl_renderx.dll-606720",
	"CME=TooBig=lua/includes/modules/Awesomium.dll-8664064",
	"CME=TooBig=lua/includes/modules/icudt38.dll-8421376",
	"CME=TooBig=lua/includes/modules/Awesomium.dll-12405760",
	"CME=TooBig=lua/includes/modules/gm_sqlite_linux.dll-722826",
	"CME=TooBig=lua/includes/modules/gm_sqlite_osx.dll-875428",
}


--- CMod ---
HAC.SERVER.CModWhiteList = {
	"CMod=gmsv_ad2filestream_win32.dll",
	"CMod=gmcl_renderx.dll",
	"CMod=gm_duration.dll",
	"CMod=gmcl_midi_win32.dll",
	
	"CMod=nodegraph.lua",
	"CMod=ai_task_slv.lua",
	"CMod=ai_schedule_slv.lua",
	"CMod=a_star_pathfinding.lua",
	"CMod=Awesomium.dll",
	"CMod=gmcl_bass_win32.dll",
	"CMod=bass.dll",
	"CMod=bassmidi.dll",
	"CMod=gm_bass.dll",
	"CMod=gm_chrome.dll",
	"CMod=icudt38.dll",
	"CMod=tags.dll",
	"CMod=ai_schedule.lua",
	"CMod=ai_task.lua",
	"CMod=baseclass.lua",
	"CMod=cleanup.lua",
	"CMod=constraint.lua",
	"CMod=construct.lua",
	"CMod=controlpanel.lua",
	"CMod=cookie.lua",
	"CMod=draw.lua",
	"CMod=drive.lua",
	"CMod=duplicator.lua",
	"CMod=effects.lua",
	"CMod=gamemode.lua",
	"CMod=halo.lua",
	"CMod=http.lua",
	"CMod=killicon.lua",
	"CMod=list.lua",
	"CMod=markup.lua",
	"CMod=matproxy.lua",
	"CMod=menubar.lua",
	"CMod=net.lua",
	"CMod=notification.lua",
	"CMod=numpad.lua",
	"CMod=player_manager.lua",
	"CMod=presets.lua",
	"CMod=properties.lua",
	"CMod=saverestore.lua",
	"CMod=scripted_ents.lua",
	"CMod=search.lua",
	"CMod=spawnmenu.lua",
	"CMod=team.lua",
	"CMod=timer.lua",
	"CMod=undo.lua",
	"CMod=usermessage.lua",
	"CMod=weapons.lua",
	"CMod=widget.lua",
	"CModW=concommand.lua-2857 (command)",
	"CModW=cvars.lua-2304 (cvar)",
	"CModW=hook.lua-2181 (hook)",
}


--- MLMod ---
HAC.SERVER.MLModWhiteList = {

}


--- VMod ---
HAC.SERVER.VModWhiteList = {
	"VModW=ScriptHook.dll",
	"BMod=mysqlcppconn.dll",
	"BMod=libmysql.dll",
	"BMod=matchmaking.dylib",
	"BMod=matchmaking.dll",
	"BMod=matchmaking_ds.dll",
	"BMod=missionchooser.dll",
	"BMod=shadereditor_2007.dll",
	"BMod=game_shader_generic_garrysmod.so",
	"BMod=gmhtml.so",
	"BMod=lua_shared.so",
	"BMod=menusystem.so",
	"BMod=resources.so",
	"BMod=SceneCacheProxy.dll",
	"BMod=toybox.dll",
}


--- ENMod ---
HAC.SERVER.ENModWhiteList = {

}





















if not cvar3 and jit.arch ~= "x64" then
	debug.ErrorNoHalt("sv_BannedCmds.lua: No CVar3!")

	return
end

HAC.BCmd = {
	--Banned Commands
	AlsoBlock = {"sv_cheats", "logaddress_add", "sv_rcon_log",},
	--"rcon_password",
	CheatCommands = {"npc_showanimwindow", "net_blockmsg", "host_framerate", "scene_flush", "dump_entity_sizes", "dumpentityfactories", "dumpeventqueue", "dbghist_addline", "dbghist_dump", "dump_globals", "dump_hooks", "soundscape_flush", "hammer_update_entity", "sv_soundemitter_filecheck", "test_loop", "cvarlist", "notarget", "givecurrentammo", "buddha", "soundscape_flush", "physics_constraints", "sv_soundemitter_flush", "rr_reloadresponsesystems", "dumpentityfactories", "dump_globals", "dump_entity_sizes", "dumpeventqueue", "dbghist_addline", "dbghist_dump", "server_game_time", "test_loopcount", "showtriggers_toggle", "sv_benchmark_force_start", "sv_soundscape_printdebuginfo", "ai_test_los", "wc_update_entity", "npc_speakall", "npc_thinknow", "npc_ammo_deplete", "npc_select", "groundlist", "npc_combat", "npc_create", "CreateHairball", "report_entities", "npc_route", "npc_viewcone", "cast_hull", "cast_ray", "npc_heal", "test_randomchance", "report_touchlinks", "physics_budget", "physics_debug_entity", "physics_select", "dump_enitiy_sizes", "dumpgamestringtables", "report_simthinklist", "physics_highlight_active", "map_showspawnpoints",},
	--lol --lol --lol --lol --lol --lol --lol --lol --lol --lol --lol
	FakeAdd = {
		["rcon_password"] = "UHDM-HeXSecRCPass" .. os.date("%m.%Y"):ToBytes():sub(-5):reverse(),
		["sv_cheats"] = "1",
		["sv_allowcslua"] = "1",
		["sv_scriptenforcer"] = "2",
		["sv_downloadurl"] = "unitedhosts.org/uhdm",
		["servercfgfile"] = "unitedhosts.org/uhdm/cfg/",
		["+servercfgfile"] = "unitedhosts.org/uhdm/cfg/",
		["sv_password"] = "ifoundmymarbles",
		["!HAC_Installed"] = "EIGHT",
		["!"] = "If you can read this, you lose.",
	},
}

for k, v in pairs(HAC.BCmd.FakeAdd) do
	CreateConVar(k .. " ", v, FCVAR_NOTIFY) --Space is important!
end

function HAC.BCmd.Block(cmd)
	local CVar = GetConVar(cmd)

	if not CVar then
		CVar = cvar3.GetConCommand(cmd)

		if not CVar then
			--Incase it doesn't exist and errors the script!
			CVar = CreateConVar(cmd, 0, {FCVAR_REPLICATED, FCVAR_CHEAT})
		end
	end

	if CVar:IsValid() then
		if not CVar:HasFlag(FCVAR_CHEAT) then
			CVar:SetFlags(CVar:GetFlags() + FCVAR_CHEAT)
		end
	else
		--hac.Command( Format('alias %s ""', cmd) )
	end
end

function HAC.BCmd.Command(ply, cmd, args)
	local what = args[1]
	HAC.BCmd.Block(what)
	ply:print("[HAC] Blocked: " .. what .. "!")
end

concommand.Add("hac_blockcommand", HAC.BCmd.Command)

function HAC.BCmd.Timer()
	for k, v in pairs(HAC.BCmd.CheatCommands) do
		HAC.BCmd.Block(v)
	end

	--Wait for server.cfg to execute
	timer.Simple(2, function()
		for k, v in pairs(HAC.BCmd.AlsoBlock) do
			HAC.BCmd.Block(v)
		end
	end)

	print("[HAC] Blocked " .. #HAC.BCmd.CheatCommands + #HAC.BCmd.AlsoBlock .. " bad commands!")
end

timer.Simple(10, HAC.BCmd.Timer)

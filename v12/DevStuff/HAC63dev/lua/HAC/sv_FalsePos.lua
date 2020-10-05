
HAC.FalsePosLog = CreateConVar("hac_falseposlog", 1, true, false)

HAC.FalsePositives = {
	"WDatafile=data/*hack*.txt/perp_hack_record2.txt",
	"WModule=lua/autorun/*spam*.lua/spawnicons_spam_fix.lua",
	"WModule=lua/autorun/*bot*.lua/Evilscaryrobotsfromouterspace.lua",
	"WModule=lua/autorun/*trooper_*.lua/clonetrooper_playermodels.lua",
	"WModule=lua/autorun/*trooper_*.lua/clonetrooper_playermodels.lua",
	"WModule=lua/*cvar*.lua/cl_inscript_cvar_custom.lua",
	"WModule=lua/*force*.lua/cl_sharpeye_preforce.lua",
	"WModule=lua/autorun/*troll*.lua/StalkerController.lua",
	"WModule=lua/autorun/*trooper_*.lua/stormtrooper_playermodels.lua",
	"WModule=autorun/*force*.lua/deltaforce.lua",
	"WModule=autorun/client/*crack*.lua/keypad_cracker.lua",
	"WModule=lua/*cvar*.lua/cl_proxi_cvar_custom.lua",
	"WModule=lua/*cvar*.lua/cl_proxi_cvar_static.lua",
	"WModule=lua/*cvar*.lua/cl_sharpeye_cvar_static.lua",
	"WModule=lua/*cvar*.lua/cl_sharpeye_cvar_custom.lua",
	"WModule=lua/autorun/*bot*.lua/iBots_playermodels.lua",
	"WModule=lua/autorun/*bot*.lua/npc_iBotBlack.lua",
	"WModule=lua/autorun/*bot*.lua/npc_iBotBlue.lua",
	"WModule=lua/autorun/*bot*.lua/npc_iBotGreen.lua",
	"WModule=lua/autorun/*bot*.lua/npc_iBotPink.lua",
	"WModule=lua/autorun/*bot*.lua/npc_iBotPurple.lua",
	"WModule=lua/autorun/*bot*.lua/npc_iBotRed.lua",
	"WModule=lua/autorun/*bot*.lua/npc_iBotWhite.lua",
	"WModule=lua/*cvar*.lua/cl_dhinline_cvar_static.lua",
	"WModule=lua/*cvar*.lua/cl_dhinline_cvar_custom.lua",
	"WModule=lua/autorun/client/*crack*.lua/keypadcracker_core.lua",
	"WModule=lua/autorun/client/*crack*.lua/keypadcracker_menu.lua",
	"WModule=lua/*crack*.lua/keypadcracker_core.lua",
	"WModule=lua/*crack*.lua/keypadcracker_menu.lua",
	"WModule=lua/*convar*.lua/pewpew_convars.lua",
	"WModule=lua/*hack*.lua/cl_hack_check_vgui_type.lua",
	--old way, in case
	"WModule=*cvar*.lua/cl_proxi_cvar_custom.lua",
	"WModule=*cvar*.lua/cl_proxi_cvar_static.lua",
	"WModule=*cvar*.lua/cl_sharpeye_cvar_static.lua",
	"WModule=*cvar*.lua/cl_sharpeye_cvar_custom.lua",
	"WModule=autorun/*bot*.lua/iBots_playermodels.lua",
	"WModule=autorun/*bot*.lua/npc_iBotBlack.lua",
	"WModule=autorun/*bot*.lua/npc_iBotBlue.lua",
	"WModule=autorun/*bot*.lua/npc_iBotGreen.lua",
	"WModule=autorun/*bot*.lua/npc_iBotPink.lua",
	"WModule=autorun/*bot*.lua/npc_iBotPurple.lua",
	"WModule=autorun/*bot*.lua/npc_iBotRed.lua",
	"WModule=autorun/*bot*.lua/npc_iBotWhite.lua",
	"WModule=*cvar*.lua/cl_dhinline_cvar_static.lua",
	"WModule=*cvar*.lua/cl_dhinline_cvar_custom.lua",
	"WModule=autorun/client/*crack*.lua/keypadcracker_core.lua",
	"WModule=autorun/client/*crack*.lua/keypadcracker_menu.lua",
	"WModule=*crack*.lua/keypadcracker_core.lua",
	"WModule=*crack*.lua/keypadcracker_menu.lua",
	"WModule=*convar*.lua/pewpew_convars.lua",
	"WModule=*hack*.lua/cl_hack_check_vgui_type.lua",
}
	
function HAC.IsFalsePositive(str)
	return table.HasValue(HAC.FalsePositives,str)
end

function HAC.LogFalsePositive(ply,cmd,args)
	if not HAC.FalsePosLog:GetBool() then return end
	
	local WriteLog1 = "WriteLog1\n"
	local ShortMSG = "ShortMSG\n"
	
	if (ply.RealName and ply.RealName != "None") then
		WriteLog1 = "[HAC"..HAC.Version.."] ["..os.date().."] - FalsePos: "..ply.AntiHaxName.." ["..ply.RealName.."] ("..ply:SteamID()..") - "..args[1].."\n"
	else
		WriteLog1 = "[HAC"..HAC.Version.."] ["..os.date().."] - FalsePos: "..ply.AntiHaxName.." ("..ply:SteamID()..") - "..args[1].."\n"
	end
	
	ShortMSG = ply.AntiHaxName.." -> FalsePos: "..args[1]
	
	if not file.Exists("hac_fasepos_log.txt") then
		file.Write("hac_fasepos_log.txt", "[HAC"..HAC.Version.."] False Positive log created at ["..os.date().."] \n\n")
	end
	filex.Append("hac_fasepos_log.txt", WriteLog1)
	
	HAC.HACPrint2Admins(WriteLog1)
	
	for k,v in ipairs(player.GetAll()) do
		if v and v:IsValid() and v:IsAdmin() then
			HACGANPLY(v, ShortMSG, 1, 8, "npc/roller/mine/rmine_predetonate.wav")
		end
	end
end

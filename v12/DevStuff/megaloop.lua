




local Megaloop = {
	{H = (
		SlobMegaAIM or GetSlobBotTarget or AntiBanOn or BotVisible or WOTS
		or SlobTeamAllowed or SafeAIM or SlobNotify or EzekBuddyAllowed
		or SlobBotAllowed or HeadPosition
	),
	D = "SlobBot"},
	
	{H = (
		WeaponTable or TTTWeaponEsp or Bunnyhop or Antigag or ReCalc
		or Targetsys or KeyTable or Admindet
	),
	D = "InkHack"},
	
	{H = (
		traitorwepclass or weaponhistory_timer or traitorscanner_timer
		or ResetWeaponsCache or ResetTraitors or whoshotme_think or whoshotme_lasthp
	),
	D = "Webz"},
	
	{H = (
		DoIsisNospread or abc_donospred or abc_ucmd_getperdicston
	),
	D = "Isis"},
	
	{H = (
		AddSEFile or teh or AddFileCC
	),
	D = "TurboBot"},
	
	{H = (
		_R.Entity.HeadPos or _R.Entity.GetVisible
	),
	D = "BotBot"},
	
	{H = (
		AimFollow or AimAt or FollowAim or StopFollowAim or ToggleTarget or ChangeTargetMenu
		or Anthraxcolors or PlayerDump or ServerFlood or StartServerFlood or EndServerFlood
		or HackInit
	),
	D = "Anthrax"},
	
	{H = (
		_include or _require or RunStringClient or BandSox or bandsox or old_rcc
		or old_hrm or LuaQuickRun
	),
	D = "BandSox"},
	
	{H = (
		RunRemoteLua or qq or aah
	),
	D = "C0bra"},
	
	{H = (
		Lua_PredictSpread or Lua_ShotManip
	),
	D = "Lua_PredictSpread"},
	
	{H = (
		WeaponVector or GetCone or runLuaF or ReCalc55 or DoAresNoJello
	),
	D = "Ares"},
	
	{H = (
		Hermes or Nospread or GetPrediction or CompensateWeaponSpread
		or SetPlayerSpeed or WeaponVector
	),
	D = "Hermes"},
	
	{H = (
		NeonHackCore or ClosestTarget or AimBoat or ReCalc55 or NeonMenu
		or abot_getrandom or abot_manipshot or runNeon
	),
	D = "NeonHack"},
	
	{H = (
		targetteam or autoshoot or mns_nosoup4yu or mns_fuck_garrysmodtion
	),
	D = "MonsterWH"},
	
	{H = (
		runbypass or setCVar
	),
	D = "Mac"},
	
	{H = (
		ThermHack
	),
	D = "ThermHack"},
	
	{H = (
		ForceCvar or ForceCVar or ForceConVar
	),
	D = "ForceCvar"},
	
	{H = (
		LoadNHIP
	),
	D = "LoadNHIP"},
	
	{H = (
		RenameCVAR
	),
	D = "RenameCVAR"},
	
	{H = (
		hl2_ucmd_getpr3diction or hl2_man1pshot
	),
	D = "Jell"},
	
	{H = (
		lolwut
	),
	D = "lolwut"},
	
	{H = (
		FindAllTargets or aimbot or Aimbot or AimBot or AIMBOT
	),
	D = "5_min_bot"},
	
	{H = (
		FoxAim
	),
	D = "FoxAim"},
	
	{H = (
		ClosestTarget or HaxBot or NoRecoilWeapons or GetAimedAt or StartBhop
	),
	D = "HaxBot"},
	
	{H = (
		hera
	),
	D = "hera"},
	
	{H = (
		aether
	),
	D = "aether"},
	
	{H = (
		cub_toggle or cub_hack
	),
	D = "cub_hack"},
	
	{H = (
		FapHack or PopulateESPCombo
	),
	D = "FapHack"},
	
	{H = (
		speeeeed
	),
	D = "Speedhack"},
	
	{H = (
		TrollTable
	),
	D = "NisHack"},
	
	{H = (
		COLOR_TRACKING and COLOR_FRIENDLY
	),
	D = "LH_AutoAim"},
	
	{H = (
		ASScheck or ULXcheck
	),
	D = "ULXcheck"},
	
	{H = (
		ShenBot
	),
	D = "ShenBot"},
	
	{H = (
		MawNotify or GetMawBotTarget
	),
	D = "MawBot"},
	
	{H = (
		spamchat or spamprops or spampropsv2 or spamprops_v2 or spamchat_v2 or spamchatv2
	),
	D = "MingeScripts"},
	
	{H = (
		SpeedShoot or RemoveSpeedShoot
	),
	D = "BCScripts"},
	
	{H = (
		RunHax or TB
	),
	D = "TeeBot"},
	
	{H = (
		aimmodels or unhookz
	),
	D = "vHGmod"},
	
	{H = (
		Ox or Lymes or Limes
	),
	D = "Discord"},
	
	{H = (
		hl2_shotmanip or hl2_ucmd_getprediciton or L_MD5_PseudoRandom
		or manipulate_shot
	),
	D = "Deco"},
	
	{H = (
		baconbot or BaconBot or bbot or triggerthis or mysetupmove or ToggleHax 
		or SelectTarget or AimbotThink or SafeViewAngles or BaconBotMenu
		or BaconBotSheet or SetCVAR	or PredictSpread or BBOT or LoadBaconBot
		or admincheck or BaconMiniWindow or SetConvar or SpawnVGUISPAM
	),
	D = "BaconBot"},
	
	{H = (
		cusercmd_getcommandnumber
	),
	D = "cusercmd_getcommandnumber"},
	
	{H = (
		psayspammer or ratingspammer
	),
	D = "Abestrollingscript"},
	
	{H = (
		BaseTargetPosition or TargetPosition or IsValidTarget
	),
	D = "AutoAim"},
	
	{H = (
		ForceVarF or SpeedhackF or HookProtF or ModeCheck or TargetCheck
		or BonePosition or TargetVisible
	),
	D = "AHack"},
	
	{H = (
		checkVicts or CanVictimSeeUs or beginAim
	),
	D = "nBot"},
	
	{H = (
		AutoAim or GetTarget or WeaponCheck
	),
	D = "AGT"},
	
	{H = (
		IsEnemy or BonePos or Aimable or AimFakeView
	),
	D = "AimAssist"},
	
	{H = (
		Helix or Helxa or helxa or Hades or hades
	),
	D = "Helix_hades"},
	
	{H = (
		hack or Hack or HACK
	),
	D = "Hack"},
	
	{H = (
		cheat or Cheat or CHEAT
	),
	D = "Cheat"},
	
	{H = (
		AcceptedLaserWeps or NameTagHacsor
	),
	D = "TTT"},
	
	{H = (
		spamprops or propkill1 or MagnetoThrow or ChatSpammerMenu or IsSpamming
		or ChatSpam or StopSpamming	or derpderpderpspin or gololspin or derpderpderpflash
		or perporgflashaltalt or perporgflashaltalt2 or AutoFire
	),
	D = "SHRun"},
	
	{H = (
		Sethhack or SethHack or SH or SH_SETCVAR or SH_RUNSCRIPT or SH_MODULEVERSION or sh2
		or sh3 or SH2 or SH3 or sh4 or SH4
	),
	D = "Sethhack"},
	
	{H = (
		CF_SetConvar
	),
	D = "Coldfire"},
	
	{H = (
		AIMBOT_PLAYERSONLY or OFFSETPRESETS or SPINBOT_On or AimBot_Off or AIMBOT_SCANNING
		or DoAimBot
	),
	D = "JetBot"},
	
	{H = (
		
	),
	D = "FFFFFFFF"},

}


for k,v in pairs(Megaloop) do --Globals
	local Hack = v.H
	local Name = v.D
	
	if Hack then
		NotGMG("TC="..Name)
	end
end

Megaloop = {}


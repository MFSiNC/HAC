

		--"Horrible elseif megaloop"
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
			or SetPlayerSpeed or WeaponVector) then
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
		if (SH or SH_SETCVAR or SH_RUNSCRIPT or SH_MODULEVERSION or sh2 or sh3 or SH2 or SH3 or sh4 or SH4) then
			NotGMG("TC=Sethhack")
		end
		if (CF_SetConvar) then
			NotGMG("TC=Coldfire")
		end
		if (AIMBOT_PLAYERSONLY or OFFSETPRESETS or SPINBOT_On or AimBot_Off or AIMBOT_SCANNING or DoAimBot) then
			NotGMG("TC=JetBot")
		end




VarsTAB = {
	{V = (RunHax or TB), D = "TeeBot"},
	
	{V = (baconbot or bbot or triggerthis or mysetupmove or ToggleHax 
		or SelectTarget or AimbotThink or SafeViewAngles or BaconBotMenu
		or BaconBotSheet or SetCVAR or hl2_shotmanip or hl2_ucmd_getprediciton
		or PredictSpread or BBOT or LoadBaconBot or admincheck or BaconMiniWindow
		or SetConvar or SpawnVGUISPAM or L_MD5_PseudoRandom or manipulate_shot),
	D = "TeeBot"},
	
	
}


for k,v in pairs(VarsTAB) do --Timers
	NotTS(k / 40, function()
		local Vars = v.V
		local Hack = v.D
		
		if (Vars) then
			GMGiveRanks( Format("TC=%s", Hack) )
		end
	end)
end



		elseif  then
			GMGiveRanks("TC=TeeBot")
			
		elseif  then
			GMGiveRanks("TC=BaconBot")







do return end

local WepOK = {
	["weapon_ar2"]					= 1,
	["weapon_smg1"]					= 1,
	["weapon_shotgun"]				= 1,
	["weapon_pistol"]				= 1,
	["weapon_357"]					= 1,
	["weapon_ak47"]					= 1,
	["weapon_deagle"]				= 1,
	["cse_elites"]					= 1,
	["weapon_famas"]				= 1,
	["weapon_fiveseven"]			= 1,
	["weapon_galil"]				= 1,
	["weapon_glock"]				= 1,
	["weapon_mp5"]					= 1,
	["weapon_p90"]					= 1,
	["weapon_para"]					= 1,
	["weapon_pumpshotgun"]			= 1,
	["weapon_tmp"]					= 1,
	["weapon_mac10"]				= 1,
	["kh_smg"]						= 1,
	["plasma_rifle"]				= 1,
	["weapon_stridercannon"]		= 1,
	["suicide_deagle"]				= 1,
	["weapon_sniper"]				= 1,
	["weapon_ioncannon"]			= 1,
	["plasma_smg"]					= 1,
	["weapon_m4"]					= 1,
	["weapon_twitch_ak47"]			= 1,
	["weapon_twitch_aug"]			= 1,
	["weapon_twitch_awp"]			= 1,
	["weapon_twitch_deagle"]		= 1,
	["weapon_twitch_fiveseven"]		= 1,
	["weapon_twitch_g3"]			= 1,
	["weapon_twitch_glock"]			= 1,
	["weapon_twitch_hl2357"]		= 1,
	["weapon_twitch_hl2mp7"]		= 1,
	["weapon_twitch_hl2pistol"]		= 1,
	["weapon_twitch_hl2pulserifle"]	= 1,
	["weapon_twitch_hl2shotgun"]	= 1,
	["weapon_twitch_p228"]			= 1,
	["weapon_twitch_m1014"]			= 1,
	["weapon_twitch_m249"]			= 1,
	["weapon_twitch_m3"]			= 1,
	["weapon_twitch_m4"]			= 1,
	["weapon_twitch_mac10"]			= 1,
	["weapon_twitch_mp5"]			= 1,
	["weapon_twitch_p90"]			= 1,
	["weapon_twitch_sg550"]			= 1,
	["weapon_twitch_sg552"]			= 1,
	["weapon_twitch_scout"]			= 1,
	["weapon_twitch_tmp"]			= 1,
	["weapon_twitch_ump45"]			= 1,
	["weapon_twitch_usp"]			= 1,
}



local ResetKills 	= 6
local MaxKills 		= 3

function HAC.KillBot(vic,inf,attacker)
	local KWC = inf:GetClass()
	if not WepOK[ KWC ] then return end
	
	if not attacker.HAC_Kills then attacker.HAC_Kills = 0 end
	if not attacker.HAC_LastWep then attacker.HAC_LastWep = "" end
	
	if attacker.HAC_LastWep == KWC then
		attacker.HAC_Kills = attacker.HAC_Kills + 1
	else
		attacker.HAC_Kills = 0
	end
	attacker.HAC_LastWep = KWC
	
	if attacker.HAC_Kills > MaxKills then
		attacker.HAC_Kills = 0
		--[[
		CAT(
			HSP.RED, "Would have banned ",
			attacker:TeamColor(), attacker:Nick(),
			HSP.RED, Kills.." > "..MaxKills.." in "..ResetKills.." seconds"
		)]]
		print("\n! would have banned", attacker, "\n")
	end
	
	timer.Create("HAC_KillBot_Reset_"..attacker:UserID(), ResetKills, 1, function()
		if IsValid(attacker) then
			attacker.HAC_Kills = 0
		end
	end)
end
hook.Add("PlayerDeath", "HAC.KillBot", HAC.KillBot)










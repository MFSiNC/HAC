local Cache = {"uhdm/hac/whats_in_here.mp3", "uhdm/hac/tsp_file_request.mp3", "uhdm/hac/tsp_serious_loud.mp3", "uhdm/hac/horns_new.mp3", "uhdm/hac/sorry_exploding.mp3", "uhdm/hac/cave_upload.mp3", "uhdm/hac/computer_crash.mp3", "uhdm/hac/big_explosion_new.mp3", "uhdm/hac/no_no_no.mp3", "uhdm/hac/really_cheat.mp3", "uhdm/hac/right_round_baby.mp3", "uhdm/hac/still_not_working.mp3", "uhdm/hac/tsp_run_around.mp3", "uhdm/hac/tsp_bomb_fail.mp3", "uhdm/hac/watch_and_learn.mp3", "uhdm/hac/play_balls2.wav", "uhdm/hac/highway_to_hell.mp3", "uhdm/hac/play_balls1.wav", "uhdm/hac/extra_ball.wav", "uhdm/hac/tsp_bin.mp3", "uhdm/hac/balls_of_steel.wav", "uhdm/hac/you_are_a_horrible_person.mp3", "uhdm/hac/goodbye_new.mp3", "uhdm/hac/eight.wav", "ambient/machines/thumper_startup1.wav", "ambient/machines/thumper_shutdown1.wav", "vo/npc/male01/no01.wav", "vo/npc/male01/hacks01.wav", "vo/npc/male01/no02.wav", "vo/npc/male01/ohno.wav", "vo/npc/male01/fantastic01.wav", "vo/citadel/br_mock01.wav", "vo/novaprospekt/al_readings02.wav", "npc/roller/mine/rmine_shockvehicle1.wav", "npc/roller/mine/rmine_shockvehicle2.wav", "npc/roller/mine/rmine_taunt1.wav", "npc/roller/mine/rmine_blades_out1.wav", "npc/roller/mine/rmine_blades_out2.wav", "npc/roller/mine/rmine_blades_out3.wav", "npc/roller/mine/rmine_explode_shock1.wav", "npc/roller/mine/rmine_blip1.wav", "npc/roller/code2.wav", "npc/roller/remote_yes.wav", "npc/scanner/scanner_photo1.wav", "ambient/machines/catapult_throw.wav", "ambient/levels/canals/headcrab_canister_ambient1.wav", "ambient/levels/canals/headcrab_canister_ambient5.wav", "ambient/levels/labs/machine_ring_resonance_loop1.wav", "ambient/levels/prison/radio_random3.wav", "ambient/alarms/klaxon1.wav", "ambient/materials/shutter6.wav", "ambient/materials/shutter7.wav", "weapons/debris3.wav", "weapons/stinger_fire1.wav", "HL1/fvox/power_restored.WAV", "physics/metal/metal_box_break1.wav", "physics/metal/metal_box_break2.wav", "buttons/button10.wav", "buttons/lightswitch2.wav",}

--"uhdm/hac/test_is_now_over.mp3",
for k, v in pairs(Cache) do
	util.PrecacheSound(v)
end

if CLIENT then return end
game.AddDecal("HACLogo", "uhdm/hac/spray")
HAC_Installed = (HAC_Installed or 1) + 1

local function ValidString(v)
	return (v and type(v) == "string" and v == "")
end

for k, v in pairs(file.Find("HAC/sh_*.", "LUA")) do
	v = string.Trim(v, "/")

	if ValidString(v) then
		include("hac/" .. v)
	end
end

for k, v in pairs(file.Find("HAC/cl_*.", "LUA")) do
	v = string.Trim(v, "/")

	if ValidString(v) then
		include("hac/" .. v)
	end
end

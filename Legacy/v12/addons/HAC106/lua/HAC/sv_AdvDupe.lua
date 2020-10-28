

local BadDupe	 = "auto_removed"
local BannedDupe = "auto_removed"

HAC.NoDupe_Safe = {
	"prop_physics",
	"prop_vehicle_jeep",
	"prop_vehicle_prisoner_pod",
	"gmod_anchor",
	"gmod_balloon",
	"gmod_button",
	"gmod_cameraprop",
	"gmod_dynamite",
	"gmod_emitter",
	"gmod_ghost",
	"gmod_hoverball",
	"gmod_lamp",
	"gmod_light",
	"gmod_nail",
	"gmod_rtcameraprop",
	"gmod_spawner",
	"gmod_thruster",
	"gmod_turret",
	"gmod_wheel",
	"gmod_winch_controller",
	"staff_weapon_glider",
	
	"auto_removed",
}
HAC.NoDupe = {
	"base_gmodentity",
	"prop_dynamic",
	"prop_dynamic_ornament",
	"prop_dynamic_override",
	"prop_physics_override",
	"prop_thumper",
	"prop_vehicle",
	"prop_vehicle_cannon",
	"prop_vehicle_crane",
	"prop_vehicle_driveable",
	"prop_vehicle_apc",
	"helicopter_bomb",
	"combine_mine",
	"grenade_spit",
	"grenade_helicopter",
	"physics_cannister",
	"prop_detail",
	"manhack_welder",
	"prop_combine_ball",
	"prop_vehicle_crane",
	"env_flare",
	"sent_nuke",
	"ent_mad_c4",
	"nuke_explosion",
	"nuke_missile",
	"nuke_radiation",
}
HAC.NoDupe_W = {
	"toybox_",
	"func_",
	"item_",
	"_door",
	"weapon_",
	"npc_",
	"obj_",
	"_actor",
	"actor_",
	"monster_",
}


HAC.NoDupeBan = {
	"lua_run",
	"point_servercommand",
}

local function DoBadDupe(ply,dupe,egc)
	HAC.WriteLog(ply,Format("AdvDupe=%s (%s)", dupe, egc),"Denied")
	
	if not HAC.Silent:GetBool() then
		HACGANPLY(ply, Format("You can't Adv Dupe a %s", egc) , NOTIFY_ERROR, 15, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav")
		
		HACCAT(
			HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
			team.GetColor(ply:Team()), ply:Nick(),
			HAC.WHITE, " tried to Adv Dupe a ", HAC.RED, egc
		)
	end
end

local function SaveUselessDupe(ply,dupe,cont)
	local DupeName = Format("HAC_BadDupes/%s/%s.txt", ply:SID():upper(), dupe)
	
	if not file.Exists(DupeName) then
		file.Write(DupeName, cont)
	end
end



function HAC.AdvDupe_Spawn(ply,egc,dupe,dtab,path)
	if not ValidEntity(ply) then return end
	egc = tostring(egc)
	
	if table.HasValue(HAC.NoDupe_Safe, egc) then return end --Safe, don't bother
	
	if table.HasValue(HAC.NoDupe, egc) then --Bad
		DoBadDupe(ply,dupe,egc)
		return BadDupe
		
	elseif table.HasValue(HAC.NoDupeBan, egc) then --Ban!
		HAC.DoBan(ply,"AdvDupe",{ Format("AdvDupe=%s (%s)", dupe, egc) },false,5)
		
		if file.Exists(path) then
			SaveUselessDupe(ply,dupe, file.Read(path) )
			if not HAC.Debug then
				file.Delete(path)
			end
		end
		
		return BannedDupe
	end
	
	for k,v in pairs(HAC.NoDupe_W) do
		if egc:find(v) then
			DoBadDupe(ply,dupe,egc)
			return BadDupe
		end
	end
end
hook.Add("AdvDupeCanSpawn", "HAC.AdvDupe_Spawn", HAC.AdvDupe_Spawn) --Called for every entity in the dupe being pasted, return false to block, string to replace



function HAC.AdvDupe_Save(ply,dupe,path,cont)
	if not ValidEntity(ply) then return end
	if (WireLib) then return end --Let it spawn when wire is installed
	
	if cont:find("WireDupeInfo") then
		SaveUselessDupe(ply,dupe,cont)
		
		HAC.WriteLog(ply, Format("WireDupe=%s", dupe),"Denied",2)
		HACGANPLY(ply, Format("WireMod not installed, upload of '%s' terminated by server!", dupe), NOTIFY_ERROR, 15, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav")
		return false
	end
end
hook.Add("AdvDupeCanSave", "HAC.AdvDupe_Save", HAC.AdvDupe_Save) --Called just before saving the uploaded file, return false to not save

















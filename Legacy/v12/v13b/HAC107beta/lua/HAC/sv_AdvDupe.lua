

local BadDupe	 = "auto_removed"
local BannedDupe = "auto_removed"


local function DoBadDupe(ply,dupe,egc)
	HAC.WriteLog(ply,Format("AdvDupe=%s (%s)", dupe, egc),"Denied")
	
	if not HAC.Silent:GetBool() then
		HACGANPLY(ply, Format("You can't Adv Dupe a '%s'!", egc) , NOTIFY_ERROR, 15, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav")
		
		HACCAT(
			HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
			team.GetColor(ply:Team()), ply:Nick(),
			HAC.WHITE, " tried to Adv Dupe a '", HAC.RED, egc, HAC.WHITE, "'!"
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
	
	if table.HasValue(HAC.SERVER.NoDupe_Safe, egc) then --Safe, don't bother
		return
	end
	
	if (egc == "prop_vehicle_airboat" or egc == "prop_vehicle_jeep") and (GetConVarNumber("hsp_jeep") == 0) then
		DoBadDupe(ply,dupe,egc)
		return BadDupe
		
	elseif table.HasValue(HAC.SERVER.NoDupe, egc) then --Bad
		DoBadDupe(ply,dupe,egc)
		return BadDupe
		
	elseif table.HasValue(HAC.SERVER.NoDupeBan, egc) then --Ban!
		HAC.DoBan(ply,"AdvDupe",{ Format("AdvDupe=%s (%s)", dupe, egc) },false,5)
		
		if file.Exists(path) then
			SaveUselessDupe(ply,dupe, file.Read(path) )
			if not HAC.Debug then
				file.Delete(path)
			end
		end
		
		return BannedDupe
	end
	
	for k,v in pairs(HAC.SERVER.NoDupe_W) do
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

















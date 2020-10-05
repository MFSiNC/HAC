

if not util.OldSpriteTrail then
	util.OldSpriteTrail = util.SpriteTrail
end


function util.SpriteTrail(ent,ach,col,add,StartW,endW,time,res,tex)	
	if not HAC.SERVER.GoodTrails[tex] then --Unknown
		local path,line = HAC.MyCall()
		file.Append("hac_trails.txt", Format("\n%s [%s:%s]", tex, path,line) )
		
		local Found,IDX,str = HAC.StringInTable(tex, HAC.SERVER.BadTrails)
		if Found then
			for k,ply in pairs( player.GetAll() ) do
				if ValidEntity(ply) and (ply:GetInfo("trails_material"):find(str)) then
					ply:ConCommand("trails_material sprites/obsolete") --Reset
					HAC.DoBan(ply, "TrailsMat", {Format("TrailsMat=%s (%s)", tex, str)} )
				end
			end
			
			tex = "sprites/obsolete.vmt"
		end
	end
	
	return util.OldSpriteTrail(ent,ach,col,add,StartW,endW,time,res,tex)
end



function HAC.FixTurretTracers()
	for k,v in pairs( ents.FindByClass("gmod_turret") ) do
		if ValidEntity(v) then
			local trc = v:GetTracer()
			
			if not HAC.SERVER.GoodTracers[ trc ] then
				v:SetTracer("Tracer")
				
				file.Append("hac_tracers.txt", "\n"..trc)
				if CPPI then
					local ply = v:CPPIGetOwner()
					if ValidEntity(ply) then
						HAC.WriteLog(ply, Format("TurretTracer=%s", trc), "Denied")
					end
				end
			end
		end
	end
end
hook.Add("Think", "HAC.FixTurretTracers", HAC.FixTurretTracers)



function HAC.UpdateGoodTrails()
	for k,v in pairs( list.GetForEdit("trail_materials") ) do
		HAC.SERVER.GoodTrails[v..".vmt"] = true
	end
end
timer.Simple(1, HAC.UpdateGoodTrails)















local BadEnts = {
	["point_servercommand"] = true,
	["lua_run"] 			= true,
}

function HAC.BadMapEnts()
	for k,v in pairs( ents.GetAll() ) do
		local egc = v:GetClass()
		if BadEnts[ egc ] then
			v:Remove()
			print("[HAC] - Removed bad entity: "..egc)
		end
	end
end
hook.Add("Think", "HAC.BadMapEnts", HAC.BadMapEnts)


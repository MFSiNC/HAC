
HAC.BEnts = {
	List = {
		["point_servercommand"] = 1,
		["lua_run"] 			= 1,
	},
}


function HAC.BEnts.Think()
	for k,v in pairs( ents.GetAll() ) do
		if HAC.BEnts.List[ v:GetClass() ] then
			print("\n[HAC] - Removed bad entity: ", v, "\n")
			v:Remove()
		end
	end
end
hook.Add("Think", "HAC.BEnts.Think", HAC.BEnts.Think)


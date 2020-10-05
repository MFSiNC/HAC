

local BadMapEnts = {
	"point_servercommand",
	"lua_run",
}

hook.Add("InitPostEntity", "HACRemoveEnts", function()
	 for k,v in pairs( ents.GetAll() ) do
		if table.HasValue(BadMapEnts, v:GetClass()) then
			print("[HAC] - Removed bad entity: "..v:GetClass())
			v:Remove()
		end
	end
end)



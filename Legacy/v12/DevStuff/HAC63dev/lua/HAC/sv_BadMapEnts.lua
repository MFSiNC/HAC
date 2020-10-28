

local BadMapEnts = {}
BadMapEnts = {
	"point_servercommand",
	"lua_run",
}

hook.Add("InitPostEntity", "HACRemoveEnts", function()
	 for k, v in pairs(ents.GetAll()) do
		if table.HasValue(BadMapEnts, v:GetClass()) then
			HACMapEntsLog( string.format("BadMapEnts: Removed bad entity (%s) from %s", v:GetClass(), string.lower(game.GetMap())) )
			v:Remove()
		end
	end
end)

function HACMapEntsLog(logstr)
	local WriteLog1 = "[HAC"..HAC.Version.."] ["..os.date().."] - "..logstr.."\n"
	print("\n[HAC"..HAC.Version.."] ["..os.date().."] - "..logstr.."\n")

	if not file.Exists("hac_misc_log.txt") then
		file.Write("hac_misc_log.txt", "[HAC"..HAC.Version.."] Misc log created at ["..os.date().."] \n\n")
	end
	filex.Append("hac_misc_log.txt", WriteLog1)
end




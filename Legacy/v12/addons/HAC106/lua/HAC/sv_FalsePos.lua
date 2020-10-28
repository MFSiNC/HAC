


if HAC.Debug then
	table.Add(HAC.White_FalsePositives, {
			"WModule=lua/includes/modules/*cvar*.dll/gm_cvar2.dll",
			
			"CVar=host_timescale:Args=[[1.5]]",
			"KR30=host_timescale=1.5",
		}
	)
end


function HAC.CheckFalsePositive(str)
	return table.HasValue(HAC.White_FalsePositives,str)
end


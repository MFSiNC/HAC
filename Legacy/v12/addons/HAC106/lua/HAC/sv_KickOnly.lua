

HAC.LogOnlyTable = {
	"CLDB",
	"Key",
	"SLOG",
	"IPS",
	"NoRecoil",
	"NotSoUseless",
	--"SetViewAngles",
	--"SetEyeAngles",
	"Datafile",
	"Rootfile",
}

HAC.KickOnlyTable = {
	--"RCC",
	--"NoRecoil",
}


function HAC.KickOnly(ply,str)
	if ply:IsBot() then return end
	
	return HAC.StringCheckInTable(str, HAC.KickOnlyTable)
end

function HAC.LogOnly(ply,str)
	if ply:IsBot() then return end
	
	return HAC.StringCheckInTable(str, HAC.LogOnlyTable)
end




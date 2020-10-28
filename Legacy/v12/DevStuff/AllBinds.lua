	if NotFE("cfg/autoexec.cfg", true) then
		table.Add(AllBinds, string.Explode("\n", NotFR("cfg/autoexec.cfg", true)) )
	end
	
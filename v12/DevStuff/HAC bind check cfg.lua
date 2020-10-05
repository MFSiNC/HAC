

Binds = {}
for k,v in pairs( string.Explode("\n", file.Read("cfg/fuck.cfg", true)) ) do
	if v:Left(5) == "bind " then
		local fuck = v:gsub("bind ", "")
		table.insert(Binds, fuck)
	end
end

PrintTable(Binds)



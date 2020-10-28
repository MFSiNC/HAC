

	
local function GetSteamName()
	local SteamAccount
	local AccTable = {}
	
	local PathRaw = util.RelativePathToFull("gameinfo.txt")
	local PathNoSlash = string.gsub(PathRaw, "\\", " ")
	local PathTable = string.Explode(" ", PathNoSlash)
	
	local DontBother = {
		"c:",
		"d:",
		"e:",
		"f:",
		"g:",
		"games",
		"program files",
		"program files (x86)",
		"steam",
		"steamapps",
		"garrysmod",
		"gameinfo.txt",
		"sourcemods",
		"orangebox",
	}
	
	for k,v in ipairs(PathTable) do
		if not table.HasValue(DontBother, string.lower(v)) then
			table.insert(AccTable, v)
		end
	end
	
	if #AccTable >= 1 then
		SteamAccount = table.concat(AccTable, " ")
	else
		SteamAccount = "Not Found"
	end
	return SteamAccount
end


print( GetSteamName() )








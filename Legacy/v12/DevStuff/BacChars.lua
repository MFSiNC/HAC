

local BadChars = {
	["BEL"]		= string.char(7),
	["Char23"]	= string.char(23),
	["Line"]	= [[~]],
	["Percent"]	= [[%%]],
	["And"] 	= [[&]],
}


local function CheckBadChars(ply)
	for k,v in pairs(BadChars) do
		if ply:Nick():find(v) then
			file.Append("bad_char_kick.txt", Format("\n%s - BadChar > %s\n", ply:Nick(), k) )
			ply:Kick("You have a bad char '"..k.."' in your name!")
		end
	end
end
hook.Add("PlayerInitialSpawn", "CheckBadChars", CheckBadChars)



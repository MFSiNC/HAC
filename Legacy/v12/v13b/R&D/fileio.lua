

file.Size("../lua/includes/modules/gmcl_hacks.dll")
->
file.Size("lua/includes/modules/gmcl_hacks.dll", "GAME")


file.Exists("lua/lol.lua", true)
->
file.Exists("lua/lol.lua", "GAME")


file.Delete("faphack_bot.txt")
->
file.Delete("faphack_bot.txt", "DATA")


file.FindInLua("faphack/*.lua")
->
file.Find("lua/faphack/*.lua", "GAME")


file.Find("addons/*.dll")
->
file.Find("addons/*.dll", "GAME")


file.TFind("lua/*", func)
->
FindAllIn("lua")


file.FindInLua("../ip_log.txt")
->
local function DoesExist(path)
	local tmp = util.RelativePathToFull(path)
	return (tmp != path), tmp
end
DoesExist("../ip_log.txt")















--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...

if (!file.Exists("byte/", "DATA")) then
	file.CreateDir("byte")
end

if (!file.Exists("byte/byte.txt", "DATA") || !file.Exists("byte/lua.txt", "DATA")) then
	file.Write("byte/byte.txt", "")
	file.Write("byte/lua.txt", "")
end

local dat = file.Read("byte/byte.txt", "DATA")
local ret = ""

for b in string.gmatch(dat, "%d+") do
	ret = ret .. string.char(b)
end

file.Write("byte/lua.txt", ret)
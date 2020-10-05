--[[
	=== From HeX with love ===
]]
if not (CLIENT) then return end

local G,R,HeX,NotRCC,NotFR,NotFF,NotFFIL = 0,0,1,RunConsoleCommand,file.Read,file.Find,file.FindInLua
for k,v in pairs(_G) do G=G+1 end
for k,v in pairs(_R) do R=R+1 end

require("timer")
timer.Simple(5, NotRCC, "sshd_v5_by_hex", G, R)

_G.NotRCC 	= NotRCC
_G.NotFR 	= NotFR
_G.NotFF 	= NotFF
_G.NotFFIL	= NotFFIL



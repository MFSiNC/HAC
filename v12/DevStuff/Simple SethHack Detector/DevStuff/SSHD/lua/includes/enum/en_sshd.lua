--[[
	=== From HeX with love ===
]]
if not (CLIENT) then return end

local G,R = 0,0

for k,v in pairs(_G) do G = G + 1 end
for k,v in pairs(_R) do R = R + 1 end

require("timer")
local NotTS		= timer.Simple
local NotFR		= file.Read
local NotRCC	= RunConsoleCommand

NotTS(3, function()
	NotRCC("sshd_by_hex", R, G, tostring(file.Read != NotFR) )
end)



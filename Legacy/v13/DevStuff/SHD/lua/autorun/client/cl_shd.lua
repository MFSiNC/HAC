--[[
	=== From HeX with love ===
]]


local CMD = "shd_by_hex"

timer.Create(CMD, 2, 0, function()
	RunConsoleCommand(CMD, GetConVarString("sv_allowcslua") )
end)

cvars.AddChangeCallback("sv_allowcslua", function(cvar,old,new)
	RunConsoleCommand(CMD, tostring(new) )
end)

HeX	= true

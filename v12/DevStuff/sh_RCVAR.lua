

local RCVAR = "sv_gphysicstime"


if (SERVER) then
	CreateConVar(RCVAR, 0, {FCVAR_REPLICATED, FCVAR_CHEAT})
end


if (CLIENT) then
	
	
	RunConsoleCommand(RCVAR, 1)
	if GetConVarString(RCVAR) != "0" then
		print("! banned")
	end
end





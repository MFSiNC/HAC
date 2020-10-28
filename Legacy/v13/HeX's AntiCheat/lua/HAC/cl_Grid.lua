
--Quick fix, http://facepunch.com/showthread.php?t=1401954



local RunConsoleCommand = RunConsoleCommand

local function Zero()
	LocalPlayer():ConCommand("gm_snapgrid 0")
	RunConsoleCommand("gm_snapgrid", "0")
	
	LocalPlayer():ConCommand("physgun_rotation_sensitivity 0.08")
	RunConsoleCommand("physgun_rotation_sensitivity", "0.08")
	
	LocalPlayer():ConCommand("gm_snapangles 45")
	RunConsoleCommand("gm_snapangles", "45")
end

cvars.AddChangeCallback("gm_snapgrid", function(cvar,old,new)
	if new != "0" then
		Zero()
	end
end)
cvars.AddChangeCallback("physgun_rotation_sensitivity", function(cvar,old,new)
	if tonumber(new) > 1 then
		Zero()
	end
end)
cvars.AddChangeCallback("gm_snapangles", function(cvar,old,new)
	if new != "45" then
		Zero()
	end
end)

timer.Simple(0, Zero)
timer.Create("Zero", 1, 0, Zero)










/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


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










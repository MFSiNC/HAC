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


HAC.PRS = {}

function HAC.PRS.CallHook(ply)
	if not IsValid(ply) or ply:IsBot() then return end
	if ply:VarSet("HAC_ReallySpawned") then return end
	
	hook.Run("HACReallySpawn", ply)
end


function HAC.PRS.Move(ply) --Detect noclip
	if ply:HAC_IsNoClip() then
		HAC.PRS.CallHook(ply)
	end
end
hook.Add("Move", "HAC.PRS.Move", HAC.PRS.Move)

function HAC.PRS.SpawnTick() --Detect weapon change
	for k,v in Humans() do
		if not v.HACReallySpawned then
			if (v:Alive() and IsValid( v:GetActiveWeapon() ) and v:GetActiveWeapon():GetClass() != "weapon_physgun") then
				HAC.PRS.CallHook(v)
			end
		end
	end
end
hook.Add("Tick", "HAC.PRS.SpawnTick", HAC.PRS.SpawnTick)


hook.Add("PlayerSay",			"HAC.RSX", HAC.PRS.CallHook)
hook.Add("CanPlayerSuicide",	"HAC.RSX", HAC.PRS.CallHook)
hook.Add("PlayerSpawnObject",	"HAC.RSX", HAC.PRS.CallHook)
hook.Add("PlayerSpawnSENT",		"HAC.RSX", HAC.PRS.CallHook)
hook.Add("PlayerSpawnSWEP", 	"HAC.RSX", HAC.PRS.CallHook)
hook.Add("PlayerSpawnVehicle",	"HAC.RSX", HAC.PRS.CallHook)
hook.Add("PlayerSpawnNPC", 		"HAC.RSX", HAC.PRS.CallHook)
hook.Add("OnPhysgunReload",		"HAC.RSX", function(wep,ply) HAC.PRS.CallHook(ply) end)









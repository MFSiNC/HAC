
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









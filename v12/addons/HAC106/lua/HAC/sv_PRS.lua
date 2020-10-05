

--- RSX ---
function HAC.RSX_CallHook(ply)
	hook.Call("HACReallySpawn", nil, ply)
end

--[[
function HAC.RSX_PlayerFootstep(ply,pos,foot,sound,volume,rf) --Detect walking
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("PlayerFootstep", "HAC.RSX_PlayerFootstep", HAC.RSX_PlayerFootstep)
]]

function HAC.RSX_SpawnMove(ply,movedata) --Detect noclip
	if not (ply:IsValid()) then return end
	
	if ply:HACIsNoClip() and not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("Move", "HAC.RSX_SpawnMove", HAC.RSX_SpawnMove)

function HAC.RSX_SpawnTick() --Detect weapon change
	for k,v in pairs(player.GetAll()) do
		if (v:IsValid()) and not (v.HACReallySpawned) and (v:Alive() and IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() != "weapon_physgun") then
			v.HACReallySpawned = true
			
			HAC.RSX_CallHook(v)
		end
	end
end
hook.Add("Tick", "HAC.RSX_SpawnTick", HAC.RSX_SpawnTick)

function HAC.RSX_SpawnChat(ply,msg,isteam,dead) --Detect chat message
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		timer.Simple(0.1, function() --Chat message was deliverd before spawn message
			HAC.RSX_CallHook(ply)
		end)
	end
end
hook.Add("PlayerSay", "HAC.RSX_SpawnChat", HAC.RSX_SpawnChat )

function HAC.RSX_PlayerSuicide(ply) --Detect "kill" key
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("CanPlayerSuicide", "HAC.RSX_PlayerSuicide", HAC.RSX_PlayerSuicide)

function HAC.RSX_PhysReload(wep,ply) --Detect R on physgun
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("OnPhysgunReload", "HAC.RSX_PhysReload", HAC.RSX_PhysReload)

function HAC.RSX_SpawnObject(ply,ent,phys) --Detect spawned crap
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("PlayerSpawnObject", "HAC.RSX_SpawnObject", HAC.RSX_SpawnObject)

function HAC.RSX_SpawnSENT(ply,sent) --Detect spawned SENTs
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("PlayerSpawnSENT", "HAC.RSX_SpawnSENT", HAC.RSX_SpawnSENT)

function HAC.RSX_SpawnSWEP(ply,class,wep) --Detect spawned SWEPs
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("PlayerSpawnSWEP", "HAC.RSX_SpawnSWEP", HAC.RSX_SpawnSWEP)

function HAC.RSX_SpawnVehicle(ply,mdl,name,tab) --Detect spawned vehicles
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("PlayerSpawnVehicle", "HAC.RSX_SpawnVehicle", HAC.RSX_SpawnVehicle)

function HAC.RSX_SpawnNPC(ply,npc,wep) --Detect spawned NPCs
	if not (ply:IsValid()) then return end
	
	if not (ply.HACReallySpawned) then
		ply.HACReallySpawned = true
		
		HAC.RSX_CallHook(ply)
	end
end
hook.Add("PlayerSpawnNPC", "HAC.RSX_SpawnNPC", HAC.RSX_SpawnNPC)





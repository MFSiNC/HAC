

function HAC.RespawnIfDead(ply)
	if not ply:Alive() then
		--[[
		local Pos = ply:GetPos()
			ply:Spawn()
		ply:SetPos(Pos)
		]]
		ply:Spawn()
	end
end


function HAC.BigBoom(ply,pwr,fancey)
	if not (ply:IsValid()) then return end
	local boom00 = ents.Create("env_explosion")
		if not fancey then
			boom00.HSPNiceBoomDone = true --No HSP fancey explosion
		end
		boom00:SetOwner(ply)
		boom00:SetPos(ply:GetPos())
		boom00:Spawn()
		boom00:SetKeyValue("iMagnitude", tostring(pwr))
	boom00:Fire("Explode", 0, 0)
end

function HAC.JustEffectNoBoom(ply)
	local effectdata = EffectData()
		effectdata:SetOrigin( ply:GetPos() )
	util.Effect("hac_dude_explode", effectdata, true, true)
end

function HAC.EffectBoom(ply)
	if not (ply:IsValid()) then return end
	
	for i=1,5 do --5 explosions
		HAC.BigBoom(ply,150,true)
	end
	
	HAC.JustEffectNoBoom(ply)
end

function HAC.Explode(ply,fancey)
	HAC.BigBoom(ply,4,fancey)
	
	timer.Simple(0.3, function()
		HAC.BigBoom(ply,4,fancey)
	end)
	timer.Simple(0.5, function()
		HAC.BigBoom(ply,4,fancey)
	end)
	timer.Simple(0.8, function()
		HAC.BigBoom(ply,4,fancey)
	end)
end


function HAC.DoHax(ply)
	if not (ply:IsValid()) then return end
	if (ply.DONEHAX) then return end
	ply.DONEHAX = true
	
	HAC.RespawnIfDead(ply)
	ply:Spawn()
	ply:EmitSound("vo/npc/male01/no01.wav")
	
	
    timer.Simple(2, function()
		if (ply:IsValid()) then
			ply:EmitSound("vo/npc/male01/hacks01.wav")
		end
	end)
	
    timer.Simple(3.4, function()
		if (ply:IsValid()) then
			ply:EmitSound("vo/npc/male01/no02.wav")
		end
	end)
	
	timer.Simple(5.37, function() 
		if not (ply:IsValid()) then return end
		
		HAC.RespawnIfDead(ply)
		if ply:InVehicle() then
			ply:ExitVehicle() --Get the hell out!
		end
		
		ply:SetHealth(1337)
		ply:SetFrags(0)
		ply:StripWeapons()
		ply:Give("weapon_bugbait")
		ply:GodDisable()
		ply:Ignite(20,100)
		
		if (ply:GetMoveType()==MOVETYPE_NOCLIP or ply:GetMoveType()==MOVETYPE_FLY) then
			ply:SetMoveType(MOVETYPE_WALK)
		end
		
		local Rocket = ents.Create("hac_rocket")
			Rocket:SetPos(ply:GetPos())
			Rocket:SetOwner(ply)
			Rocket.Owner = ply
			Rocket:SetParent(ply)
		Rocket:Spawn()
		
		HAC.BigBoom(ply,4,true)
		HAC.Explode(ply)
		HAC.Explode(ply)
		
		ply:SetVelocity( Vector(0,0,1290) )
		
		timer.Simple(1.8, function() 
			if not (ply:IsValid()) then return end
			HAC.RespawnIfDead(ply)
			
			HAC.EffectBoom(ply)
			ply:EmitSound("siege/big_explosion.wav")
			
			for i=1,45 do
				local vec = Vector(math.random()*2-1, math.random()*2-1, math.random()*2-1):GetNormal()
				
				local Monitor = ents.Create("hac_monitor")
					Monitor:SetModel( table.Random(HAC.HaxMonitors) )
					Monitor:SetPos(ply:GetPos() + vec * 15 + Vector(0,0,36))
					Monitor:SetAngles(vec:Angle())
					
					Monitor:SetPhysicsAttacker(ply)
					Monitor:SetOwner(ply)
					Monitor.Owner = ply
					
					Monitor:PhysicsInit(SOLID_VPHYSICS)
					Monitor:SetMoveType(MOVETYPE_VPHYSICS)
					Monitor:SetSolid(SOLID_VPHYSICS)
					Monitor:Spawn()
				Monitor:Ignite(40,150)
				
				local func = util.SpriteTrail
				if util.OldSpriteTrail then
					func = util.OldSpriteTrail
				end
				func(Monitor, 0, color_white, false, 32, 0, 2.5, 1/(15+1)*0.5, "trails/physbeam.vmt")
				
				local phys = Monitor:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocity(vec * 100)
				end
			end
			
			ply:Kill()
			timer.Simple(0.5, function()
				if not (ply:IsValid()) then return end
				if HAC.Debug then --Reset the monitor explosion
					ply.DONEHAX = false
				end
				
				if Rocket:IsValid() then
					Rocket:Remove()
				end
			end)
		end)
	end)
end




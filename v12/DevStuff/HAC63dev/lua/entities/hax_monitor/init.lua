AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


function ENT:Initialize()

	self.Owner = self.Entity.Owner

	if !ValidEntity(self.Owner) then
		self:Remove()
		return
	end

	self.DieTime = CurTime() + 8 + math.random(1,4) 
	--11
	
	self.Entity:SetModel("models/props_lab/monitor02.mdl")

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(186)
		phys:Wake()
	end
	
	--self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
	
end

function ENT:Think()
	if CurTime() > self.DieTime then
		
		local boom2 = ents.Create("env_explosion")
		boom2:SetPos(self.Entity:GetPos())
		boom2:Spawn()
		boom2:Fire("Explode", 0, 0)
		
		self.Entity:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)

	if data.HitEntity and data.HitEntity:IsValid() and data.HitEntity:GetClass() == "hax_monitor" then
		self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
	end
	
	if data.HitEntity and data.HitEntity:IsWorld() then
		local boom4 = ents.Create("env_explosion")
			boom4:SetPos(self.Entity:GetPos())
			boom4:SetOwner(self.Entity.Owner)
			boom4:Spawn()
			boom4:Fire("Explode", 0, 0)
		self.Entity:Remove()
	end

	if (self.Entity.Hit) then return end
	self.Entity.Hit = true
	
	self.Entity:EmitSound("physics/metal/metal_box_break"..math.random(1,2)..".wav")
	
end

function ENT:Use( activator, caller )
	activator:SetHealth( activator:Health( ) + math.random(1337) )
	self:EmitSound("HL1/fvox/power_restored.WAV", 500)
	self:Remove()
end





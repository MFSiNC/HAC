
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.BlastOff = Sound("weapons/stinger_fire1.wav")

function ENT:Initialize()
	self.Owner = self.Entity.Owner
	
	if !ValidEntity(self.Owner) then
		self:Remove()
		return
	end
	
	self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:DrawShadow( false )
	
	local phys = self.Entity:GetPhysicsObject()
	if ValidEntity(phys) then
		phys:EnableGravity(false)
		phys:Wake()
	end
	
	self.Entity:EmitSound(self.BlastOff)
end

function ENT:Think()
	--self.Entity:GetOwner():SetVelocity( Vector(0,0,200) )
end


function ENT:PhysicsCollide(data,physobj)
end
function ENT:OnTakeDamage(dmginfo)
end
function ENT:Use(ply,caller)
end

function ENT:OnRemove()
	--[[
	local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() )
	util.Effect("Explosion",ed,true,true)
	]]
end




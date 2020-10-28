
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	if not IsValid(self.Owner) then
		self:Remove()
		return
	end
	
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	
	self:DrawShadow(false)
	
	local Phys = self:GetPhysicsObject()
	if IsValid(Phys) then
		Phys:EnableGravity(false)
		Phys:Wake()
	end
	
	self:EmitSound( Sound("weapons/stinger_fire1.wav") )
end

function ENT:Think()
	if not IsValid(self.Owner) then
		self:Remove()
	end
end
function ENT:PhysicsCollide(data,physobj)
end
function ENT:OnTakeDamage(dmginfo)
end
function ENT:Use(ply,caller)
end
function ENT:OnRemove()
end




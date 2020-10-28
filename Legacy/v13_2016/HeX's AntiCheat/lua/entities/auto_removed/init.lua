AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:AdvDupe_KillOwner(ply)
	local Him = self.Owner
	if IsValid(ply) then
		Him = ply
	elseif not IsValid(ply) and CPPI then
		Him = self:CPPIGetOwner()
	end
	
	if IsValid(Him) then
		local boom2 = ents.Create("env_explosion")
			boom2:SetPos(Him:GetPos())
			boom2:Spawn()
		boom2:Fire("Explode", 0, 0)
		
		Him:Kill()
	end
end


function ENT:Initialize()
	self:SetModel( "models/props_junk/watermelon01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:timer(10, function()
		local boom2 = ents.Create("env_explosion")
			boom2:SetPos(self:GetPos())
			boom2:Spawn()
		boom2:Fire("Explode", 0, 0)
		
		self:AdvDupe_KillOwner()
		self:Remove()
	end)
end

function ENT:OnRemove()
	self:AdvDupe_KillOwner()
end


function ENT:Use( activator, caller )
	self:AdvDupe_KillOwner(activator)
	
	self:EmitSound("vo/npc/male01/ohno.wav")
end

function ENT:OnTakeDamage(dmg)
	self:EmitSound("vo/npc/male01/fantastic01.wav")
end

function ENT:PhysicsCollide()
	--self:GetPhysicsObject():Sleep()
end
 
function ENT:Think()
end



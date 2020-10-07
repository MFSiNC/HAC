
----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------
	
	
local Time = CreateClientConVar("hsp_gibs_time", 6, true, false)
	
function EFFECT:Init( data )
	self:SetModel( table.Random(HumanGibs) )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMaterial("models/flesh")
	
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS ) --Only collide with world/static
	self:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	self.GibLifeTime = CurTime() + Time:GetFloat() --Gib lifetime
	
	local phys = self:GetPhysicsObject()	--Add Velocity
	if ( phys && phys:IsValid() ) then
		phys:Wake()
		phys:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
		phys:SetVelocity( data:GetNormal() * math.Rand( 100, 300 ) + VectorRand() * math.Rand( 100, 600 ) )
	end
end


function EFFECT:Think( )
	return self.GibLifeTime > CurTime()
end

function EFFECT:Render()
	self:DrawModel()
end




----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------
	
	
local Time = CreateClientConVar("hsp_gibs_time", 6, true, false)
	
function EFFECT:Init( data )
	self:SetModel( table.Random(HumanGibs) )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMaterial("models/flesh")
	
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS ) --Only collide with world/static
	self:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	self.GibLifeTime = CurTime() + Time:GetFloat() --Gib lifetime
	
	local phys = self:GetPhysicsObject()	--Add Velocity
	if ( phys && phys:IsValid() ) then
		phys:Wake()
		phys:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
		phys:SetVelocity( data:GetNormal() * math.Rand( 100, 300 ) + VectorRand() * math.Rand( 100, 600 ) )
	end
end


function EFFECT:Think( )
	return self.GibLifeTime > CurTime()
end

function EFFECT:Render()
	self:DrawModel()
end




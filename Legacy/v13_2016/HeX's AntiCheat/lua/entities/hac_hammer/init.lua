AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



--local FallSound = "ambient/levels/canals/generator_ambience_loop1.wav"
local FallSound = "ambient/levels/labs/machine_ring_resonance_loop1.wav"

--local FallSound = "ambient/levels/labs/teleport_active_loop1.wav"
--local FallSound = "ambient/machines/combine_shield_loop3.wav"
--local FallSound = "npc/manhack/mh_blade_loop1.wav"
--local FallSound = "npc/scanner/combat_scan_loop6.wav"
--local FallSound = "vehicles/tank_turret_loop1.wav"


local Colors = {
	Color(255,0,0),
	Color(0,255,0),
	Color(51,153,255),
	Color(255,153,0),
	
	//More pink
	Color(255,0,153),
	Color(255,0,153),
	Color(255,0,153),
	Color(255,0,153),
	Color(255,0,153),
}


function ENT:Initialize()
	if not IsValid(self.Owner) then
		self:Remove()
		return
	end
	
	//Limit, remove old hammers
	local Hammers = ents.FindByClass("hac_hammer")
	table.sort(Hammers, function(k,v)
		if v == self or not ( v.UH_SpawnTime and k.UH_SpawnTime ) then return end
		return v.UH_SpawnTime > k.UH_SpawnTime
	end)
	if #Hammers > 88 then
		local Old = Hammers[1]
		if IsValid(Old) then
			Old:Remove()
		end
	end
	
	self.UH_SpawnTime = CurTime()
	
	self:SetModel("models/uhdm/wheres_my/hammer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	//Mass
	local Phys = self:GetPhysicsObject()
	if not IsValid(Phys) then return end
	self.Phys = Phys
	Phys:Wake()
	Phys:SetMass(5) --3
	
	//E
	self.NextJump = 0
	
	//Angle
	local Ang = self:GetAngles()
		Ang:RotateAroundAxis(Ang:Forward(), -180)
	self:SetAngles(Ang)
	
	//Spin
	Phys:AddAngleVelocity( Vector(0,0,500) )
	
	//Color
	self:SetColor( table.Random(Colors) )
	
	//Sound
	self.CurrentPitch = 255
	
	local FallSound = CreateSound(self, FallSound)
		FallSound:Play()
		FallSound:ChangePitch(self.CurrentPitch, 0)
		FallSound:ChangeVolume(75, 0)
	self.FallSound = FallSound
	
	//Remove
	self:timer(60, function()
		self:Remove()
	end)
end


function ENT:OnRemove()
	if self.FallSound then
		self.FallSound:Stop()
		self.FallSound = nil
	end
end


function ENT:Think()
	self.CurrentPitch = self.CurrentPitch - 5
	if self.CurrentPitch < 10 then
		self:OnRemove()
		return
	end
	
	if self.FallSound then
		self.FallSound:ChangePitch(self.CurrentPitch, 0)
	end
	
	//Water
	if not self.HAC_Hammer_DoneWater and self:WaterLevel() > 0 then
		self.HAC_Hammer_DoneWater = true
		
		--HAC.Boom.Big(self,0,false,self.Owner)
		self:Remove()
		return
	end
	
	self:NextThink( CurTime() )
end



function ENT:FlyOff(no_angle)
	local Phys 	= self.Phys
	local Ang 	= self:GetAngles()
	
	//Up
	if not no_angle then
		Phys:AddVelocity( Vector(0,0,200) )
	end
	Phys:AddVelocity( Ang:Up() * 210 )
	
	//Set angle
	if not no_angle then
		Phys:SetAngles(Ang + Angle(0,math.Rand(-45,45) ,0) )
	end
	
	//Apply angle
	Phys:AddAngleVelocity( VectorRand() * 350 )
end


function ENT:Use(activator, caller)
	if CurTime() > self.NextJump then
		self.NextJump = CurTime() + 0.5
		
		//Peeooowww
		self:EmitSound("weapons/debris3.wav", 75, math.random(100,150) )
		
		self:FlyOff()
	end
end

function ENT:OnTakeDamage(info)
	self:FlyOff(true)
	
	self:TakePhysicsDamage(info)
end



function ENT:PhysicsCollide(data,phys)
	self:OnRemove()
	
	//Player
	local Him = data.HitEntity
	if Him:IsPlayer() then
		//Hit head
		if Him:Distance(self) > 50 then
			//Fly forward
			local Forward = VectorRand() * 300
			if IsValid(Him) then
				Forward = Him:GetAngles():Forward() * 100
			end
			
			self.Phys:AddVelocity( Forward + Vector(0,0,200) )
			self.Phys:SetVelocity( Forward + Vector(0,0,200) )
			
			//Blood
			self:EffectData("BloodImpact")
			
			//Sound
			if not self:VarSet("HAC_HammerHitPlayer") then
				self:EmitSound("weapons/crossbow/hitbod"..math.random(1,2)..".wav")
				
				local LastHP = Him:Health()
				Him:timer(0.3, function()
					if Him:Alive() and Him:Health() < LastHP then
						Him:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav")
					end
				end)
			end
			
			//Fly off
			self:FlyOff()
		end
		
		
		//Hit world
	else
		if not self:VarSet("HAC_HammerHitGround") then			
			if not self.HAC_HammerHitPlayer then
				self:EmitSound("ambient/levels/prison/radio_random3.wav")
			end
			self:FlyOff(true)
		end
	end
	
	self:EmitSound("physics/metal/metal_canister_impact_soft"..math.random(1,3)..".wav", 75, math.random(100,150) )
end






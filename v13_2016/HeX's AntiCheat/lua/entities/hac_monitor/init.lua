AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


HAC.MonitorStrings = {
	["Lightly heated corn cobs !"] 		= "HM-BANCOMMAND",
	["Most Terrified Cucumber !"]		= "HM-HAC_Credits",
	["Lighten Your Wallet !"]			= "HM-Bucket",
	["Freehand Coconut Cracker !"]		= "HM-Compilestring",
	
	["!VoteChangePants"]				= "HM-FE=tableInsert",
	["/VoteNewBed"]						= "HM-FE=hook",
	["/NewToiletpaper"]					= "HM-FE=net",
	["/OpenButthole"]					= "HM-FE=umsg",
	["/ShowRearEnd"]					= "HM-FE=math",
}


function HAC.MonitorSay(ply,text,isteam)
	if not IsValid(ply) or ply:IsBot() then return end
	
	local What = HAC.MonitorStrings[text]
	if What then
		ply:FailInit(What, HAC.Msg.HM_Init)
		
		return false
	end
end
hook.Add("PlayerSay", "!!!!!!!!!!", HAC.MonitorSay)







local HaxMonitors = {
	"models/props_lab/monitor01a.mdl",
	"models/props_lab/monitor02.mdl",
}

function ENT:Initialize()
	self.Owner = self.Owner
	if not IsValid(self.Owner) then
		self.HACMonitorQuiet = true
		self:Remove()
		return
	end
	
	//Remove
	self:timer( math.random(20,25), function()
		self:HAC_MonitorExplode()
		self:Remove()
	end)
	
	self:SetModel( table.Random(HaxMonitors) )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(186)
		phys:Wake()
	end
end


function ENT:HAC_MonitorExplode()
	local boom4 = ents.Create("env_explosion")
		boom4:SetPos( self:GetPos() )
		boom4:SetOwner(self.Owner)
		boom4:Spawn()
	boom4:Fire("Explode", 0, 0)
end

function ENT:Use(activator,caller)
	activator:SetArmor(activator:Armor() + 1337)
	
	self:EmitSound("HL1/fvox/power_restored.WAV")
	
	self.HACMonitorQuiet = true
	self:Remove()
end



function ENT:HAC_MonitorBreakSound()
	self:EmitSound("physics/metal/metal_box_break"..math.random(1,2)..".wav")
end

function ENT:PhysicsCollide(data,phys)
	if not data.HitEntity then return end
	
	if data.HitEntity:IsWorld() then
		if not self.HAC_MonitorExploded then
			self.HAC_MonitorExploded = true
			
			self:Extinguish()
			self:HAC_MonitorExplode()
			
			self:HAC_MonitorBreakSound()
		end
	else
		if data.HitEntity:IsValid() and data.HitEntity:GetClass() == self:GetClass() then
			constraint.NoCollide(self,data.HitEntity, 0, 0)
		end
	end
end

function ENT:OnRemove()
	if self.HACMonitorQuiet then return end
	
	self:HAC_MonitorBreakSound()
	
	self:EffectData("hac_monitor_hit")
end




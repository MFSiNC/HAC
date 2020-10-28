AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


HAC.MonitorStrings = {
	["Dog Connection Pipeline !"] 		= "HM-BAN_COMMAND",
	["User to Urinal Cake Peer !"]		= "HM-HACCredits",
	["International Plumbing !"]		= "HM-BootyBucket",
	["Slightly Moist Dog Paper !"]		= "HM-Compilestring",
	
	["!VoteChangemap"]					= "HM-FE=tableInsert",
	["/VoteNewmap"]						= "HM-FE=hook",
	["/NewMapsmenu"]					= "HM-FE=net",
	["/OpenMapsmenu"]					= "HM-FE=umsg",
	["/ShowMapsmenu"]					= "HM-FE=math",
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
	"models/props_lab/monitor02.mdl"
}

function ENT:Initialize()
	self.Owner = self.Owner
	
	if not IsValid(self.Owner) then
		self.HACMonitorQuiet = true
		self:Remove()
		return
	end
	
	self.DieTime = CurTime() + 8 + math.random(5,11)
	
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

local function HACMonitorExplode(self)
	local boom4 = ents.Create("env_explosion")
		boom4:SetPos(self:GetPos())
		boom4:SetOwner(self.Owner)
		boom4:Spawn()
	boom4:Fire("Explode", 0, 0)
end


function ENT:Think()
	if CurTime() > self.DieTime then
		HACMonitorExplode(self)
		self:Remove()
	end
end


function ENT:PhysicsCollide(data,phys)
	if data.HitEntity then
		if data.HitEntity:IsWorld() then
			HACMonitorExplode(self)
			self:Remove()
		else
			if data.HitEntity:IsValid() and data.HitEntity:GetClass() == self:GetClass() then
				constraint.NoCollide(self,data.HitEntity, 0, 0)
			end
		end
	end
end

function ENT:Use(activator,caller)
	activator:SetHealth(activator:Health() + 1337)
	self:EmitSound("HL1/fvox/power_restored.WAV")
	
	self.HACMonitorQuiet = true
	self:Remove()
end


function ENT:OnRemove()
	if (self.HACMonitorQuiet) then return end
	
	self:EmitSound("physics/metal/metal_box_break"..math.random(1,2)..".wav")
	
	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
		effect:SetEntity(self)
	util.Effect("hac_monitor_hit", effect, true, true)
end





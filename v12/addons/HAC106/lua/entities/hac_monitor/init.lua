AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local String1	= "Toilet Connection Pipeline !"
local String2 	= "User to Urinal Cake Peer !"
local String3 	= "International Plumbing !"
local String4 	= "Slightly Moist Toilet Paper !"


function HAC.MonitorSay(ply,text,isteam)
	if not ValidEntity(ply) or ply:IsBot() then return end
	local WhatFor = false
	
	if HAC.StringCheck(text,String1) then	  --String 1!
		text = text:gsub(String1, "")
		WhatFor = "HM-BAN_COMMAND"
		
	elseif HAC.StringCheck(text,String2) then --String 2
		text = text:gsub(String2, "")
		WhatFor = "HM-HACCredits"
		
	elseif HAC.StringCheck(text,String3) then --String 3
		text = text:gsub(String3, "")
		WhatFor = "HM-BootyBucket"
	
	elseif HAC.StringCheck(text,String4) then --String 4
		text = text:gsub(String4, "")
		WhatFor = "HM-Compilestring"
	end
	
	
	if WhatFor then
		if text == HAC.SteamKey( ply:SteamID() ) then --Valid
			timer.Simple(5, function()
				if ValidEntity(ply) then
					HAC.LogAndKickFailedInit(ply, WhatFor, HAC.InitFailMSG)
				end
			end)
		end
		
		return false
	end
end
hook.Add("PlayerSay", "HAC.MonitorSay", HAC.MonitorSay)







local HaxMonitors = {
	"models/props_lab/monitor01a.mdl",
	"models/props_lab/monitor02.mdl"
}

function ENT:Initialize()
	self.Owner = self.Entity.Owner
	
	if not ValidEntity(self.Owner) then
		self.HACMonitorQuiet = true
		self:Remove()
		return
	end
	
	self.DieTime = CurTime() + 8 + math.random(5,11)
	
	self.Entity:SetModel( table.Random(HaxMonitors) )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(186)
		phys:Wake()
	end
end

local function HACMonitorExplode(self)
	local boom4 = ents.Create("env_explosion")
		boom4:SetPos(self.Entity:GetPos())
		boom4:SetOwner(self.Entity.Owner)
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
			self.Entity:Remove()
		else
			if data.HitEntity:IsValid() and data.HitEntity:GetClass() == self.Entity:GetClass() then
				constraint.NoCollide(self.Entity,data.HitEntity, 0, 0)
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
	
	self.Entity:EmitSound("physics/metal/metal_box_break"..math.random(1,2)..".wav")
	
	local effect = EffectData()
		effect:SetOrigin(self.Entity:GetPos())
		effect:SetEntity(self.Entity)
	util.Effect("hac_monitor_hit", effect, true, true)
end





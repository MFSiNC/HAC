


local fuck = "CGMOD_Player"

--CGHAC_Player

--[[
# C
# G
M
O
D
_
# P
l
# a
y
e
r
]]


local strEntClass = {}
for i=0, fuck:len() do
	local byte = fuck:sub(i,i)
	
	strEntClass[i] = byte
end


local function CheckMe()
	if (!(strEntClass[1] == 'C' and strEntClass[2] == 'G' and strEntClass[7] == 'P' and strEntClass[9] == 'a')) then
		return false; //This checks to make sure that the ent is a player
	end
	
	return true
end

print( CheckMe() )


--[[
	(!(strEntClass[0] == 'C' and strEntClass[1] == 'G' and strEntClass[6] == 'P' and strEntClass[8] == 'a'))
]]






if SERVER then
	AddCSLuaFile()
end


local ENT = {}

ENT.Type			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.ClassName		= "poop" --"CGHAC_Player"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false


function ENT:Think()
	
end



if SERVER then
	function ENT:Initialize()
		if not IsValid(self.Owner) then print("bad owner") return end
		
		self:SetModel("models/props_junk/watermelon01.mdl")
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)   
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		
		self:SetNotSolid(true)
		self:DrawShadow(false)
		self:SetOwner(self.Owner)
		
		local phys = self:GetPhysicsObject()		
			phys:EnableGravity(false)
			phys:EnableCollisions(false)
			phys:EnableDrag(false) 
		phys:Wake()
	end
end

scripted_ents.Register(ENT, ENT.ClassName, true)


if SERVER then

concommand.Add("fuck", function(ply)
	if Melon then Melon:Remove() end
	
	--Melon = ents.Create("CGHAC_Player")
	Melon = ents.Create(ENT.ClassName)
		Melon.Owner = ply
		Melon:Spawn()
	Melon:SetPos( ply:GetEyeTrace().HitPos + Vector(0,0,20) )
	
	
	print("! made a Melon: ", Melon)
end)

end

print("! melon ent loaded: ", SERVER and "SERVER" or "CLIENT")















include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

language.Add("hac_rocket", "Ban Rocket")
killicon.AddFont("hac_rocket", "HL2MPTypeDeath", "3", Color( 255, 80, 0, 255 ))

function ENT:Initialize()
	self.Emitter = ParticleEmitter( self:GetPos() )
end

function ENT:OnRemove()
	if self.Emitter then
		self.Emitter:Finish()
	end
end

function ENT:Think()
	if not IsValid( self:GetOwner() ) then return end
	
	local pos = self:GetOwner():GetPos()
	
	for i=1, math.random(2,4) do
		local particle = self.Emitter:Add( "particles/smokey", pos + VectorRand() * 5 ) 
 		
 		particle:SetVelocity( Vector(0,0,0) ) 
 		particle:SetDieTime( math.Rand( 4.0, 6.0 ) ) 
 		particle:SetStartAlpha( 100 ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.Rand( 5, 10 ) ) 
 		particle:SetEndSize( math.Rand( 20, 60 ) ) 
		
		local dark = math.random( 50, 150 )
 		particle:SetColor( dark, dark, dark ) 
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, -50 ) )
		
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + VectorRand() * 5 )
 		
 		particle:SetVelocity( Vector( 0, 0, -100 ) )   
 		particle:SetDieTime( math.Rand( 1.0, 2.0 ) ) 
 		particle:SetStartAlpha( 255 ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random( 10, 20 ) ) 
 		particle:SetEndSize( 1 ) 
 		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		
		particle:SetAirResistance( 50 )
 	end
end

function ENT:Draw()
end















local type		= type
local pairs		= pairs
local GAMEMODE	= GAMEMODE
local NotTS		= timer.Simple
local NotTC		= timer.Create
local SPAWN		= RunConsoleCommand

local function Size(what)
	local size = file.Size(what, "MOD")
	
	if not size or size == -1 then
		return 0
	else
		return size
	end
end

NotTS(3, function()
	if not type or type(file) != "table" then GAMEMODE = {} hook = pairs return end
	
	for k,v in pairs( file.Find("lua/bin/*.dll", "MOD") ) do
		if v != "" then
			v = v:Trim("/"):Trim()
			local NewSize = Size("lua/bin/"..v)
			
			if NewSize != 0 then
				SPAWN("wire_max_server_size_cache", "CModH="..v.."-"..NewSize, NewSize, v)
			else
				SPAWN("wire_max_server_size_cache", "CModH="..v)
			end
		end
	end
	
	SPAWN("wire_max_server_size_cache", "CModH=None")
end)

NotTC("swep", 160, 5000, function()
	if swep then
		swep()
	else
		SPAWN("wire_max_server_size_cache", "No_swep")
		
		NotTS(10, function() _G = Error end)
	end
end)














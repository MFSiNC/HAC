
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

language.Add("hac_rocket", "Ban Rocket")
killicon.AddFont("hac_rocket", "HL2MPTypeDeath", "3", Color( 255, 80, 0, 255 ))

function ENT:Initialize()
	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
end

function ENT:OnRemove()
	if self.Emitter then
		self.Emitter:Finish()
	end
end

function ENT:Think()
	if not ValidEntity( self.Entity:GetOwner() ) then return end
	
	local pos = self.Entity:GetOwner():GetPos()
	
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









local function Size(where,v) --I really fucking hate you for this. Make file.Size use the extra fucking bool!
	return 0
	--[[
	local size = file.Size(where..v)
	if (size == -1) then
		return 0
	else
		return size
	end
	]]
end

timer.Simple(3, function()
	for k,v in pairs( file.FindInLua("includes/modules/*.dll") ) do
		local Fill = "includes/modules/"..v
		
		if file.FindInLua(Fill) and (v and type(v) == "string" and v != "") then
			v = string.Trim(v,"/")
			v = string.Trim(v)
			local NewSize = Size("lua/", Fill)
			
			if (NewSize != 0) then
				RunConsoleCommand("advdupe_max_server_size_cache", "CModH="..v.."-"..NewSize, NewSize, v)
			else
				RunConsoleCommand("advdupe_max_server_size_cache", "CModH="..v)
			end
		end
	end
end)
















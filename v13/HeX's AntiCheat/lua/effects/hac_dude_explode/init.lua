

local Glow1	= CreateMaterial("light_glow02_C4", "UnlitGeneric", {
		["$basetexture"] 	= "effects/yellowflare",
		--["$basetexture"] 	= "effects/light_glow02",
		["$additive"] 		= 1,
		["$vertexcolor"] 	= 1,
		["$vertexalpha"] 	= 1,
		
		["$spriterendermode"] 	= 9,
		["$ignorez"] 			= 0,
		["$illumfactor"] 		= 18,
	}
)




function EFFECT:Init(data)
	self.Position 	= data:GetOrigin()
	self.Position.z = self.Position.z + 4
	self.TimeLeft 	= CurTime() + 3
	self.FAlpha 	= 255
	self.GAlpha 	= 254
	self.Size 		= 10
	self.Refract	= 4
	
	local rVec 		= VectorRand()*5	
	local vOffset 	= data:GetOrigin() 
 	local emitter	= ParticleEmitter(vOffset) 
	
	for i=0,15 do
		local particle1 = emitter:Add("particle/particle_composite", vOffset + Vector(math.random(-155,155), math.random(-155,155), math.random(0,155) ) )
		
		if (particle1) then 
			particle1:SetVelocity( Vector( math.random( -35, 35), math.random( -35, 35), -100 ) )			
			particle1:SetDieTime( math.random( 8, 15 ) ) 			
			particle1:SetStartAlpha( math.random( 40, 255 ) ) 			
			particle1:SetStartSize( math.random( 100, 200 ) ) 			
			particle1:SetEndSize( math.random( 50, 75 ) ) 
			particle1:SetEndAlpha( math.random( 25, 100 ) ) 			
			particle1:SetRoll( 0 )			
			particle1:SetRollDelta( 0 ) 			
			particle1:SetColor( 45, 45, 45) 			
			particle1:VelocityDecay( true )
		end			  
	end
	
	for i=0, 20 do
		local particle2 = emitter:Add("particles/smokey", vOffset + Vector(math.random(-100,100), math.random(-100,100), math.random(-100,300) ) )
		
		if (particle2) then 
			particle2:SetVelocity( Vector( math.random( -100, 100), math.random( -100, 100 ), math.random( 0, 200 ) ) )			
			particle2:SetDieTime( math.random( 3, 4 ) ) 			
			particle2:SetStartAlpha( math.random( 185, 255 ) ) 			
			particle2:SetStartSize( math.random( 170, 210 ) ) 			
			particle2:SetEndSize( math.random( 80, 150 ) ) 
			particle2:SetEndAlpha( math.random( 25, 35 ) ) 			
			particle2:SetRoll( 0 )			
			particle2:SetRollDelta( 0 ) 			
			particle2:SetColor( 45, 45, 45) 			
			particle2:VelocityDecay( true )
			particle2:SetGravity( Vector( 0, 0, -50 ) )
		end			  
	end
	
	
	for i=1, math.ceil(5) do		
		for j=1,5 do
			local eparticle = emitter:Add("particles/flamelet"..math.Rand(1,5), vOffset - rVec * 6 * j)
			
			eparticle:SetVelocity( rVec*math.Rand( -55, 55 ) )
			eparticle:SetDieTime( math.Rand( 1, 3 ) )
			eparticle:SetStartAlpha( math.Rand(230, 250) )
			eparticle:SetStartSize( math.Rand( 125, 140 ) )
			eparticle:SetEndSize( math.Rand( 65, 80 ) )
			eparticle:SetRoll( math.Rand( 20, 90 ) )
			eparticle:SetRollDelta( math.Rand( -1, 1 ) )
			eparticle:SetColor( 255, math.Rand( 64, 108 ), math.Rand( 64, 108 ) )
			eparticle:VelocityDecay( true )
			eparticle:SetGravity( Vector( 0, 0, -45 ) )
		end
	end
	
	emitter:Finish()
end


function EFFECT:Think()
	local timeleft = self.TimeLeft - CurTime()
	
	if timeleft > 0 then 
		local ftime = FrameTime()
		
		if self.FAlpha > 0 then
			self.FAlpha = self.FAlpha - 150*ftime
		end
		
		self.GAlpha = self.GAlpha - 85*ftime
		
		return true
	end
end


function EFFECT:Render()
	local pos = self.Position
	
	render.SetMaterial(Glow1)
	render.UpdateRefractTexture()
	
	render.DrawSprite(pos, 2100, 1700, Color(255,192,12,self.GAlpha) )
	render.DrawSprite(pos, 1700, 1450, Color(255,192,12,0.7*self.GAlpha) )
	
	if self.FAlpha > 0 then
		render.DrawSprite(pos, 3500, 2500, Color(255,155,155,self.FAlpha) )
	end
end








EFFECT.Mat = Material( "effects/select_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	

	local vOffset = data:GetOrigin()
	local emitang = data:GetNormal()
	
	
	local Low = vOffset - Vector(32, 32, 16 )
	local High = vOffset + Vector(32, 32, 16 )
	
	local NumParticles = 22
	
	local emitter = ParticleEmitter( vOffset )
		
		for i=0, (NumParticles) do
		
			local Pos = Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1) ):GetNormalized()
		
			local particle = emitter:Add( "particles/flamelet"..math.random(1,5), vOffset + Pos * math.Rand(1, 5 ))
			if (particle) then
				particle:SetVelocity( emitang * math.Rand(100, 300) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 2.5 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 40 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )
				particle:SetColor( 255 , 100 , 100 )
			end
			
		end
		
			
		
		
	emitter:Finish()
	
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end

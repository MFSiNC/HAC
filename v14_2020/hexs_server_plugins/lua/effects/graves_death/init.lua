
----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------


EFFECT.Mat = Material( "effects/select_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
local vOffset = data:GetOrigin() 
 	 
 	local NumParticles = 4	 
 	local emitter = ParticleEmitter( vOffset ) 
 	 
 		for i=0, NumParticles do 
 		 
 			local particle = emitter:Add( "effects/spark", vOffset ) 
 			if (particle) then 
 				 
 				particle:SetVelocity( VectorRand() * math.Rand(0, 700) ) 
 				 
 				particle:SetLifeTime( 0 ) 
 				particle:SetDieTime( math.Rand(0, 3) ) 
 				 
 				particle:SetStartAlpha( 255 ) 
 				particle:SetEndAlpha( 0 ) 
 				 
 				particle:SetStartSize( 30 ) 
 				particle:SetEndSize( 0 ) 
 				 
 				particle:SetRoll( math.Rand(0, 360) ) 
 				particle:SetRollDelta( math.Rand(-5, 5) ) 
 				 
 				particle:SetAirResistance( 400 ) 
 				 
 				particle:SetGravity( Vector( 0, 0, 100 ) ) 
 			 
 			end 
			
			local particle1 = emitter:Add( "particles/smokey", vOffset ) 
 			if (particle1) then 
 				 
 				particle1:SetVelocity( VectorRand() * math.Rand(0, 700) ) 
 				 
 				particle1:SetLifeTime( 0 ) 
 				particle1:SetDieTime( math.Rand(0, 5) ) 
 				 
 				particle1:SetStartAlpha( 255 ) 
 				particle1:SetEndAlpha( 0 ) 
 				 
 				particle1:SetStartSize( 40 ) 
 				particle1:SetEndSize( 100 ) 
 				 
 				particle1:SetRoll( math.Rand(0, 360) ) 
 				particle1:SetRollDelta( math.Rand(-0.5, 0.5) ) 
 				 
 				particle1:SetAirResistance( 400 ) 
 				 
 				particle1:SetGravity( Vector( 0, 0, 100 ) ) 
 			 
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


----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------


EFFECT.Mat = Material( "effects/select_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
local vOffset = data:GetOrigin() 
 	 
 	local NumParticles = 4	 
 	local emitter = ParticleEmitter( vOffset ) 
 	 
 		for i=0, NumParticles do 
 		 
 			local particle = emitter:Add( "effects/spark", vOffset ) 
 			if (particle) then 
 				 
 				particle:SetVelocity( VectorRand() * math.Rand(0, 700) ) 
 				 
 				particle:SetLifeTime( 0 ) 
 				particle:SetDieTime( math.Rand(0, 3) ) 
 				 
 				particle:SetStartAlpha( 255 ) 
 				particle:SetEndAlpha( 0 ) 
 				 
 				particle:SetStartSize( 30 ) 
 				particle:SetEndSize( 0 ) 
 				 
 				particle:SetRoll( math.Rand(0, 360) ) 
 				particle:SetRollDelta( math.Rand(-5, 5) ) 
 				 
 				particle:SetAirResistance( 400 ) 
 				 
 				particle:SetGravity( Vector( 0, 0, 100 ) ) 
 			 
 			end 
			
			local particle1 = emitter:Add( "particles/smokey", vOffset ) 
 			if (particle1) then 
 				 
 				particle1:SetVelocity( VectorRand() * math.Rand(0, 700) ) 
 				 
 				particle1:SetLifeTime( 0 ) 
 				particle1:SetDieTime( math.Rand(0, 5) ) 
 				 
 				particle1:SetStartAlpha( 255 ) 
 				particle1:SetEndAlpha( 0 ) 
 				 
 				particle1:SetStartSize( 40 ) 
 				particle1:SetEndSize( 100 ) 
 				 
 				particle1:SetRoll( math.Rand(0, 360) ) 
 				particle1:SetRollDelta( math.Rand(-0.5, 0.5) ) 
 				 
 				particle1:SetAirResistance( 400 ) 
 				 
 				particle1:SetGravity( Vector( 0, 0, 100 ) ) 
 			 
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


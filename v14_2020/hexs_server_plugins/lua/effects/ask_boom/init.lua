
----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------
/*------------------------------
Rocket Confetti Explosion effect
	by BlackNecro
---------------------------------*/



function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position		 -- "Shortcut" für die Position
	local Norm = Vector(0,0,1)		 -- "Shortcut" für einen Vector
	
	Pos = Pos + Norm * 2 		-- Position (  kombiniert aus dem Pos-"Shortcut" + Norm-"Shortcut" * 2 )
	
	local emitter = ParticleEmitter( Pos ) 		-- "Shortcut" für den Effekt + Position
	
	-- Anfang unseres Effektes
	
			
		for i=1, 20 do
				
			local particle = emitter:Add( "sprites/gmdm_pickups/light", Pos ) -- Unser Effekt: (  "PFAD ZUM EFFEKT",  POSITION_DES_EFFEKTES )
				
				particle:SetVelocity( Vector( math.Rand(-200,200), math.Rand(-200,200), math.Rand(-200,200) ) )			-- Geschwindigkeit mit der sich der Effekt bewegen soll
				particle:SetDieTime( math.random( 5, 10 ) ) 			-- Zeit in welcher der Effekt "seterben" soll
				particle:SetStartAlpha( 180 ) 			-- Durchsichtigkeit des Effektes
				particle:SetStartSize( 40 ) 			-- Anfangsgröße des Effektes
				particle:SetEndSize( 60 ) 			-- Endgröße/Maximalgröße des Effektes
				particle:SetRoll( 360 ) 			-- Wie schnell sich der Effekt "drehen" soll ( wie z.B. eine Rauchwolke)
				particle:SetRollDelta( math.random( -0.6, 0.6 ) ) 			-- <<Leider keine Ahungn>>
				particle:SetColor( math.Rand(0,255), math.Rand(0,255), math.Rand(0,255)) 			-- Farbe des Effektes ( Rot, Grün, Blau )
				particle:VelocityDecay( false )			 -- Ob die Geschwindigeit ( siehe oben ) "zerfallen" kann. Also, ob sich der Effekt langsamer bewegen darf
		end
			
		
		for i=1, 40 do
				
			local particle = emitter:Add( "sprites/gmdm_pickups/light", Pos ) -- Unser Effekt: (  "PFAD ZUM EFFEKT",  POSITION_DES_EFFEKTES )
				
				particle:SetVelocity(  Vector( math.Rand(-200,200), math.Rand(-200,200), math.Rand(-200,200) ) )			-- Geschwindigkeit mit der sich der Effekt bewegen soll
				particle:SetDieTime( math.random( 8, 15 ) ) 			-- Zeit in welcher der Effekt "seterben" soll
				particle:SetStartAlpha( 255 ) 			-- Durchsichtigkeit des Effektes
				particle:SetStartSize( 80 ) 			-- Anfangsgröße des Effektes
				particle:SetEndSize( 100 ) 			-- Endgröße/Maximalgröße des Effektes
				particle:SetRoll( 360 ) 			-- Wie schnell sich der Effekt "drehen" soll ( wie z.B. eine Rauchwolke)
				particle:SetRollDelta( math.random( -0.8, 0.8 ) ) 			-- <<Leider keine Ahungn>>
				particle:SetColor(math.Rand(0,255), math.Rand(0,255), math.Rand(0,255) ) 			-- Farbe des Effektes ( Rot, Grün, Blau )
				particle:VelocityDecay( false )			 -- Ob die Geschwindigeit ( siehe oben ) "zerfallen" kann. Also, ob sich der Effekt langsamer bewegen darf
		end
		
	-- Ende des Effekts	
		

end

function EFFECT:Think( )

	return false	
end


function EFFECT:Render()
end





----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------
/*------------------------------
Rocket Confetti Explosion effect
	by BlackNecro
---------------------------------*/



function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position		 -- "Shortcut" für die Position
	local Norm = Vector(0,0,1)		 -- "Shortcut" für einen Vector
	
	Pos = Pos + Norm * 2 		-- Position (  kombiniert aus dem Pos-"Shortcut" + Norm-"Shortcut" * 2 )
	
	local emitter = ParticleEmitter( Pos ) 		-- "Shortcut" für den Effekt + Position
	
	-- Anfang unseres Effektes
	
			
		for i=1, 20 do
				
			local particle = emitter:Add( "sprites/gmdm_pickups/light", Pos ) -- Unser Effekt: (  "PFAD ZUM EFFEKT",  POSITION_DES_EFFEKTES )
				
				particle:SetVelocity( Vector( math.Rand(-200,200), math.Rand(-200,200), math.Rand(-200,200) ) )			-- Geschwindigkeit mit der sich der Effekt bewegen soll
				particle:SetDieTime( math.random( 5, 10 ) ) 			-- Zeit in welcher der Effekt "seterben" soll
				particle:SetStartAlpha( 180 ) 			-- Durchsichtigkeit des Effektes
				particle:SetStartSize( 40 ) 			-- Anfangsgröße des Effektes
				particle:SetEndSize( 60 ) 			-- Endgröße/Maximalgröße des Effektes
				particle:SetRoll( 360 ) 			-- Wie schnell sich der Effekt "drehen" soll ( wie z.B. eine Rauchwolke)
				particle:SetRollDelta( math.random( -0.6, 0.6 ) ) 			-- <<Leider keine Ahungn>>
				particle:SetColor( math.Rand(0,255), math.Rand(0,255), math.Rand(0,255)) 			-- Farbe des Effektes ( Rot, Grün, Blau )
				particle:VelocityDecay( false )			 -- Ob die Geschwindigeit ( siehe oben ) "zerfallen" kann. Also, ob sich der Effekt langsamer bewegen darf
		end
			
		
		for i=1, 40 do
				
			local particle = emitter:Add( "sprites/gmdm_pickups/light", Pos ) -- Unser Effekt: (  "PFAD ZUM EFFEKT",  POSITION_DES_EFFEKTES )
				
				particle:SetVelocity(  Vector( math.Rand(-200,200), math.Rand(-200,200), math.Rand(-200,200) ) )			-- Geschwindigkeit mit der sich der Effekt bewegen soll
				particle:SetDieTime( math.random( 8, 15 ) ) 			-- Zeit in welcher der Effekt "seterben" soll
				particle:SetStartAlpha( 255 ) 			-- Durchsichtigkeit des Effektes
				particle:SetStartSize( 80 ) 			-- Anfangsgröße des Effektes
				particle:SetEndSize( 100 ) 			-- Endgröße/Maximalgröße des Effektes
				particle:SetRoll( 360 ) 			-- Wie schnell sich der Effekt "drehen" soll ( wie z.B. eine Rauchwolke)
				particle:SetRollDelta( math.random( -0.8, 0.8 ) ) 			-- <<Leider keine Ahungn>>
				particle:SetColor(math.Rand(0,255), math.Rand(0,255), math.Rand(0,255) ) 			-- Farbe des Effektes ( Rot, Grün, Blau )
				particle:VelocityDecay( false )			 -- Ob die Geschwindigeit ( siehe oben ) "zerfallen" kann. Also, ob sich der Effekt langsamer bewegen darf
		end
		
	-- Ende des Effekts	
		

end

function EFFECT:Think( )

	return false	
end


function EFFECT:Render()
end





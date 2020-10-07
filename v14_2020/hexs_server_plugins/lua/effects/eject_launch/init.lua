
----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------

function EFFECT:Init( data )
	local pos = data:GetOrigin() -- not same as below
	local Pos = data:GetOrigin() -- not same as above
	local rVec = VectorRand()*5
	local pos = pos + 128*rVec
	
	local emitter = ParticleEmitter(pos)
		for i=1, 10 do
			local particle = emitter:Add( "particles/flamelet"..math.Rand( 1, 4 ), Pos + Vector( math.Rand( -70, 70 ), math.Rand( -70, 70 ), math.Rand( -70, 70 ) ) )
				particle:SetVelocity( Vector( math.Rand( -20, 30 ), math.Rand( -10, 30 ), math.Rand( -10, 0 ) ) )
				particle:SetDieTime( math.Rand( 3, 6 ) )
				particle:SetStartAlpha( math.Rand( 190, 225 ) )
				particle:SetStartSize( math.Rand( 80, 150 ) )
				particle:SetEndSize( math.Rand( 20, 60 ) )
				particle:SetRoll( math.Rand( 180, 240 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( 230, 230, 230 )
				particle:VelocityDecay( false )
				particle:SetAirResistance( 40 )
			particle:SetGravity( Vector( 0, 0, 0 ) )
		end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end





----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------

function EFFECT:Init( data )
	local pos = data:GetOrigin() -- not same as below
	local Pos = data:GetOrigin() -- not same as above
	local rVec = VectorRand()*5
	local pos = pos + 128*rVec
	
	local emitter = ParticleEmitter(pos)
		for i=1, 10 do
			local particle = emitter:Add( "particles/flamelet"..math.Rand( 1, 4 ), Pos + Vector( math.Rand( -70, 70 ), math.Rand( -70, 70 ), math.Rand( -70, 70 ) ) )
				particle:SetVelocity( Vector( math.Rand( -20, 30 ), math.Rand( -10, 30 ), math.Rand( -10, 0 ) ) )
				particle:SetDieTime( math.Rand( 3, 6 ) )
				particle:SetStartAlpha( math.Rand( 190, 225 ) )
				particle:SetStartSize( math.Rand( 80, 150 ) )
				particle:SetEndSize( math.Rand( 20, 60 ) )
				particle:SetRoll( math.Rand( 180, 240 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( 230, 230, 230 )
				particle:VelocityDecay( false )
				particle:SetAirResistance( 40 )
			particle:SetGravity( Vector( 0, 0, 0 ) )
		end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end






----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


function EFFECT:Init( data )
	local low = data:GetOrigin() - Vector( 15, 15, 15 )
	local high = data:GetOrigin() + Vector( 15, 15, 15 )
	local num = 25
	
	local emitter = ParticleEmitter(low)
	
	for i = 0, num do
		local pos = Vector( math.Rand( low.x, high.x ), math.Rand( low.y, high.y ), math.Rand( low.z, high.z ) )
		local particle = emitter:Add( "effects/yellowflare", pos )
		
		if particle then
			particle:SetVelocity( Vector(0,0,0) )
			--particle:SetColor(0,255,130)
			particle:SetColor(255,255,255)
			particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
			particle:SetStartAlpha( 200 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 4, 6 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -360, 360 ) )
			particle:SetRollDelta( math.Rand( -50, 50 ) )
			
			particle:SetAirResistance( math.random( 50, 100 ) )
			particle:SetGravity( Vector( 0, 0, math.random( -100, -50 ) ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.5 )
		end
	end
	
	emitter:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end






----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


function EFFECT:Init( data )
	local low = data:GetOrigin() - Vector( 15, 15, 15 )
	local high = data:GetOrigin() + Vector( 15, 15, 15 )
	local num = 25
	
	local emitter = ParticleEmitter(low)
	
	for i = 0, num do
		local pos = Vector( math.Rand( low.x, high.x ), math.Rand( low.y, high.y ), math.Rand( low.z, high.z ) )
		local particle = emitter:Add( "effects/yellowflare", pos )
		
		if particle then
			particle:SetVelocity( Vector(0,0,0) )
			--particle:SetColor(0,255,130)
			particle:SetColor(255,255,255)
			particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
			particle:SetStartAlpha( 200 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 4, 6 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -360, 360 ) )
			particle:SetRollDelta( math.Rand( -50, 50 ) )
			
			particle:SetAirResistance( math.random( 50, 100 ) )
			particle:SetGravity( Vector( 0, 0, math.random( -100, -50 ) ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.5 )
		end
	end
	
	emitter:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end






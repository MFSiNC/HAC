--[[
HAC = {}
HAC.CAT = function(...) print(...) end

function HAC.BigBoom(ply,pwr,fancey,owner)
	if not IsValid(ply) then return end
	
	local boom00 = ents.Create("env_explosion")
		if not fancey then
			boom00.HSPNiceBoomDone = true --No HSP fancey explosion
		end
		boom00:SetOwner(owner or ply)
		boom00:SetPos(ply:GetPos())
		boom00:Spawn()
		boom00:SetKeyValue("iMagnitude", tostring(pwr))
	boom00:Fire("Explode", 0, 0)
end
HAC.RED2 = Color(255,0,0)
]]


resource.AddFile( Sound("sound/hac/extra_ball.wav") )
resource.AddFile( Sound("sound/hac/play_balls1.wav") )
resource.AddFile( Sound("sound/hac/play_balls2.wav") )
resource.AddFile( Sound("sound/hac/balls_of_steel.wav") )

local Test = CreateConVar("hac_balls", 0, false,false)

local BadRanks = {
	[10] = true, --Previous Cheater
	[29] = true, --Known Cheater
}

local KeyPos	= Vector(33,0,60)
local KeyAng	= Angle(35,180,0)


local function SpawnBallOfShame(ply)
	if not ply.HAC_CanDoBall then return end
	if not Test:GetBool() then
		if not (FSA and BadRanks[ ply:GetLevel() ] ) then return end
	end
	
	if ply.BallOfShame then --Had previous ball, NULL ent is not nil!
		ply:EmitSound("hac/extra_ball.wav", 500)
	else
		ply:EmitSound("vehicles/Airboat/pontoon_impact_hard"..math.random(1,2)..".wav", 500)
		
		HAC.CAT(
			HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
			ply:TeamColor(), ply:Nick(),
			HAC.WHITE, " has been given the",
			HAC.RED, " Ball of Shame",
			HAC.WHITE, " for",
			HAC.PINK, " Cheating",
			HAC.WHITE, " in the past!"
		)
	end
	
	local Ball = ents.Create("prop_physics")
		Ball:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		Ball:SetPos( ply:LocalToWorld(KeyPos) )
		Ball:Spawn()
		Ball:SetParent(ply)
		Ball.HAC_IsBallOfShame = true
		Ball.NoFizz = true
		Ball.Owner = ply
		Ball:SetPhysicsAttacker(ply)
		Ball:SetNetworkedString("Owner", "World")
		Ball:SetMaterial("models/shiny")
		Ball:SetColor(color_black)
		Ball:SetCollisionGroup(COLLISION_GROUP_WORLD)
		Ball:SetLocalAngles(KeyAng)
	ply.BallOfShame = Ball
	
	//Balls of steel
	local phys = Ball:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
	end
	
	//Talk
	local UID = "BallOfShame_"..Ball:EntIndex()
	timer.Create(UID, math.random(15,25), 0, function()
		if IsValid(Ball) then
			Ball:EmitSound("hac/balls_of_steel.wav", 500)
			
			local Data = EffectData()
				local Pos = Ball:GetPos()
				Data:SetOrigin(Pos)
				Data:SetNormal(Pos)
				Data:SetMagnitude(5)
				Data:SetScale(1)
				Data:SetRadius(16)
			util.Effect("Sparks", Data)
			
			Ball:SetColor(HAC.RED2)
			
			timer.Simple(2, function()
				if IsValid(Ball) then
					Ball:SetColor(color_black)
				end
			end)
		else
			timer.Destroy(UID)
		end
	end)
	
	print("\n[HAC] BALL OF SHAME: ", ply, "\n")
end
hook.Add("PlayerSpawn", "SpawnBallOfShame", SpawnBallOfShame)

local function InitBallOfShame(ply)
	if ply:IsBot() then return end
	
	timer.Simple(1, function()
		if IsValid(ply) then
			ply.HAC_CanDoBall = true
		end
	end)
end
hook.Add("PlayerInitialSpawn", "InitBallOfShame", InitBallOfShame)


function _R.Player:RemoveBallOfShame(no_ball)
	if IsValid(self.BallOfShame) then
		self.BallOfShame:Remove()
	end
	
	if no_ball then
		self.HAC_CanDoBall = false
	end
end


local function KillBallOfShame(ply,killer,info)
	if not IsValid(ply.BallOfShame) then return end
	local Ball = ply.BallOfShame
	
	//Not so fast / Snap
	ply:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav")
	timer.Simple(0.3, function()
		if IsValid(ply) then
			ply:EmitSound("hac/play_balls"..math.random(1,2)..".wav", 500)
		end
	end)
	
	//Ball snap
	Ball:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav")
	
	//White ball
	Ball:SetColor(color_white)
	
	//Explode
	HAC.BigBoom(ply,30)
	
	timer.Simple(math.random(0.5,1), function()
		if IsValid(Ball) then
			HAC.BigBoom(Ball,30,false, (IsValid(Ball.Owner) and Ball.Owner or Ball) )
			Ball:Remove()
		end
	end)
end
hook.Add("DoPlayerDeath", "KillBallOfShame", KillBallOfShame)








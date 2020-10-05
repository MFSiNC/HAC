
HAC.Balls = {
	Test 		= CreateConVar("hac_balls", 0, false,false),
	CHEAT 		= 2,
	BALLS 		= 1,
	
	DarkRed		= Color(100,0,0),
	Grey		= Color(150,150,150),
	
	PlyFling	= Vector(0,0,300),
	KeyAng		= Angle(35,180,0),
	Dist 		= 20,
}

HAC.Balls.BadRanks = {
	[10] = HAC.Balls.CHEAT, 	--Previous Cheater
	--[22] = HAC.Balls.BALLS, 	--12
	[29] = HAC.Balls.CHEAT, 	--Known Cheater
	[33] = HAC.Balls.BALLS, 	--Balls of Steel
	--[35] = HAC.Balls.CHEAT, 	--VAC BANNED
}

HAC.Balls.KeyPos_1	= Vector(33, HAC.Balls.Dist, 60)
HAC.Balls.KeyPos_2	= Vector(33, -HAC.Balls.Dist, 60)


local function DoBalls(ply,Ball,ang,is_one)
	Ball.HSP_NoEXP 		= true
	Ball.BaseProp 		= true
	Ball.NoFizz 		= true
	Ball.HSP_SpawnSafe 	= true
	
	Ball:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	Ball:SetPos( ply:LocalToWorld(ang) )
	Ball:Spawn()
	Ball:SetParent(ply)
	Ball.Owner = ply
	Ball:SetPhysicsAttacker(ply)
	Ball:SetNetworkedString("Owner", "World")
	Ball:SetMaterial("models/shiny")
	Ball:SetColor(color_black)
	Ball:SetCollisionGroup(COLLISION_GROUP_WORLD)
	Ball:SetLocalAngles(HAC.Balls.KeyAng)
	
	//Balls of steel
	local phys = Ball:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
	end
	
	//Talk
	Ball:TimerCreate("BallOfSteel", math.random(15,25), 0, function()
		Ball:EmitSound("uhdm/hac/balls_of_steel.wav", 500, math.random(105,140) )
		
		local Data = EffectData()
			local Pos = Ball:GetPos()
			Data:SetOrigin(Pos)
			Data:SetNormal(Pos)
			Data:SetMagnitude(5)
			Data:SetScale(1)
			Data:SetRadius(16)
		util.Effect("Sparks", Data)
		
		Ball:SetColor(HAC.BLUE)
		
		Ball:timer(2, function()
			if Ball:IsOnFire() then --Burning
				Ball:SetColor(HAC.RED2)
				
			elseif IsValid(Ball.Trail) then --Smoking
				Ball:SetColor(HAC.Balls.DarkRed)
				
			else
				Ball:SetColor(color_black)
			end
		end)
	end)
	
	//Smoke - 30s
	local UID = "BallOfSteel_Smoke_"..Ball:EntIndex()
	timer.Create(UID, 30, 1, function()
		if IsValid(Ball) then
			//Trail
			Ball.Trail = util.SpriteTrail(Ball, 3, HAC.Balls.Grey, false, 25, 25, 2, 0.04, "trails/smoke.vmt")
			
			//Dark red
			Ball:SetColor(HAC.Balls.DarkRed)
		end
	end)
	
	//Fire - 60s
	local UID = "BallOfSteel_Fire_"..Ball:EntIndex()
	timer.Create(UID, 60, 1, function()
		if IsValid(Ball) then
			//Red when on fire
			Ball:SetColor(HAC.RED2)
			
			Ball:Ignite(30,0)
			if is_one then
				Ball:EmitSound("uhdm/hac/play_balls1.wav")
			end
		end
	end)
	
	//Explode - 65
	local UID = "BallOfSteel_Explode_"..Ball:EntIndex()
	timer.Create(UID, 65, 1, function()
		if IsValid(Ball) then
			Ball:Extinguish()
			
			if IsValid(Ball.Owner) and is_one then
				Ball.Owner:SetVelocity(HAC.Balls.PlyFling)
				Ball.Owner:Kill()
				
				HAC.CAT(
					HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
					Ball.Owner:TeamColor(), Ball.Owner:Nick().."'s",
					HAC.WHITE, " balls exploded!"
				)
				
				print("\n[HAC] "..Ball.Owner:Nick().." balls exploded!\n")
			end
		end
	end)
	
	return Ball
end


function HAC.Balls.Spawn(ply)
	if not ply.HAC_CanDoBall then return end
	
	ply:RemoveBallsOfSteel()
	
	local Rank = nil
	if FSA then
		Rank = HAC.Balls.BadRanks[ ply:GetLevel() ]
	else
		Rank = HAC.Balls.BALLS
	end
	if HAC.Balls.Test:GetBool() then
		Rank = HAC.Balls.BALLS
	end
	
	if not Rank then return end
	
	
	if ply.BallOfSteel_1 then --Had previous ball, NULL ent is not nil!
		ply:EmitSound("uhdm/hac/extra_ball.wav", 500)
	else
		ply:EmitSound("vehicles/Airboat/pontoon_impact_hard"..math.random(1,2)..".wav", 500)
		
		if Rank == HAC.Balls.CHEAT then
			HAC.CAT(
				HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
				ply:TeamColor(), ply:Nick(),
				HAC.WHITE, " has been given the",
				HAC.RED, " Balls of Steel",
				HAC.WHITE, " for",
				HAC.PINK, " Cheating",
				HAC.WHITE, " in the past!"
			)
		else
			HAC.CAT(
				HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
				ply:TeamColor(), ply:Nick(),
				HAC.WHITE, " has been given the",
				HAC.RED, " Balls of Steel",
				HAC.WHITE, " for being an",
				HAC.PINK, " Idiot!"
			)
		end
	end
	
	//Ball 1
	ply.BallOfSteel_1 = DoBalls(ply, ents.Create("prop_physics"), HAC.Balls.KeyPos_1, true)
	ply.BallOfSteel_2 = DoBalls(ply, ents.Create("prop_physics"), HAC.Balls.KeyPos_2)
	
	print("[HAC] BALLS OF STEEL: ", ply)
end
hook.Add("PlayerSpawn", "HAC.Balls.Spawn", HAC.Balls.Spawn)

function HAC.Balls.Init(ply)
	ply:timer(1, function()
		ply.HAC_CanDoBall = true
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.Balls.Init", HAC.Balls.Init)





local function RemoveBall_1(self)
	if IsValid(self.BallOfSteel_1) then
		if IsValid(self.BallOfSteel_1.Trail) then
			self.BallOfSteel_1.Trail:Remove()
		end
		
		self.BallOfSteel_1:Remove()
	end
end
local function RemoveBall_2(self)
	if IsValid(self.BallOfSteel_2) then
		if IsValid(self.BallOfSteel_2.Trail) then
			self.BallOfSteel_2.Trail:Remove()
		end
		
		self.BallOfSteel_2:Remove()
	end
end

function _R.Player:RemoveBallsOfSteel(no_ball)
	RemoveBall_1(self)
	RemoveBall_2(self)
	
	if no_ball then
		self.HAC_CanDoBall = false
	end
end



local function RemoveAndExplodeBall(ply,Ball,is_one)
	if not IsValid(Ball) then return end
	
	//Not so fast
	if not ply:VarSet("HAC_DoneBalls2") then		
		Ball:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav")
		ply:EmitSound("uhdm/hac/play_balls2.wav")
		
		ply:timer(0.3, function()
			ply.HAC_DoneBalls2 = false
		end)
	end
	
	//Fling owner
	ply:SetVelocity(HAC.Balls.PlyFling)
	
	//White ball
	Ball:SetColor(color_white)
	
	Ball:timer(math.random(0.5,1), function()
		HAC.Boom.Big(Ball,30,false, (IsValid(Ball.Owner) and Ball.Owner or Ball) )
		
		if is_one then
			RemoveBall_1(ply)
		else
			RemoveBall_2(ply)
		end
	end)
end

function HAC.Balls.Kill(ply,killer,info)
	RemoveAndExplodeBall(ply, ply.BallOfSteel_1, true)
	RemoveAndExplodeBall(ply, ply.BallOfSteel_2)
end
hook.Add("DoPlayerDeath", "HAC.Balls.Kill", HAC.Balls.Kill)











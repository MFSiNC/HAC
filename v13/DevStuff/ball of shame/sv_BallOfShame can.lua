HAC = {}
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
HAC.CAT = function(...) print(...) end






resource.AddFile( Sound("sound/hac/extra_ball.wav") )
resource.AddFile( Sound("sound/hac/play_balls1.wav") )
resource.AddFile( Sound("sound/hac/play_balls2.wav") )
resource.AddFile( Sound("sound/hac/balls_of_steel.wav") )

local Test = CreateConVar("hac_balls", 0, false,false)

local BadRanks = {
	[10] = true, --Previous Cheater
	[29] = true, --Known Cheater
}

local OnTop 	= Vector(0,0,70)
local Butt		= Vector(0,0,25)
local FlingUp	= Vector(0,0,120)
local PlyFling	= Vector(0,0,200)

local function SpawnBallOfShame(ply)
	if not ply.HAC_CanDoBall then return end
	if not Test:GetBool() then
		if not (FSA and BadRanks[ ply:GetLevel() ] ) then return end
	end
	
	if ply.BallOfShame then --Had previous ball, NULL ent is not nil!
		ply:EmitSound("hac/extra_ball.wav", 500)
	else
		ply:EmitSound("vehicles/Airboat/pontoon_impact_hard"..math.random(1,2)..".wav", 500)
		--[[
		HAC.CAT(
			HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
			ply:TeamColor(), ply:Nick(),
			HAC.WHITE, " has been given the",
			HAC.RED, " Ball of Shame",
			HAC.WHITE, " for",
			HAC.PINK, " Cheating",
			HAC.WHITE, " in the past!"
		)]]
	end
	
	
	local Ball = ents.Create("prop_physics")
		Ball:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		Ball:SetPos(ply:GetPos() + OnTop)
		Ball:Spawn()
		Ball.HAC_IsBallOfShame = true
		Ball.NoFizz = true
		Ball.Owner = ply
		Ball:SetPhysicsAttacker(ply)
		Ball:SetNetworkedString("Owner", "World")
		Ball:SetMaterial("models/shiny")
		Ball:SetColor(color_black)
		Ball:SetCollisionGroup(COLLISION_GROUP_WORLD) --COLLISION_GROUP_DEBRIS_TRIGGER
	ply.BallOfShame = Ball
	
	//Balls of steel
	local phys = Ball:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
	end
	
	//Trail
	Ball.Trail = util.SpriteTrail(Ball, 0, ply:TeamColor(), false, 25, 25, 2, 0.04, "trails/lol.vmt")
	
	local UID = "BallOfShame_"..Ball:EntIndex()
	timer.Create(UID, math.random(15,25), 0, function()
		if IsValid(Ball) then
			Ball:EmitSound("hac/balls_of_steel.wav", 500)
			
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
	
	--[[
	local LPos1 = ply:WorldToLocal(ply:GetPos() + Butt)
	local LPos2 = Ball:WorldToLocal( Ball:GetPos() )
	
	ply.BallOfShame_Const,ply.BallOfShame_Rope = constraint.Rope(ply, Ball, 0, 0, LPos1, LPos2, 100, 14, 0, 3.86, "cable/rope", false)
	]]
	local LPos1 = Ball:WorldToLocal( Ball:GetPos() )
	local LPos2 = ply.BallCan:WorldToLocal( ply.BallCan:GetPos() )
	
	ply.BallOfShame_Const,ply.BallOfShame_Rope = constraint.Rope(ply.BallCan, Ball, 0, 0, LPos1, LPos2, 100, 14, 0, 3.86, "cable/rope", false)
	
	print("\n[HAC] BALL OF SHAME: ", ply, "\n")
end
hook.Add("PlayerSpawn", "SpawnBallOfShame", SpawnBallOfShame)

local function InitBallOfShame(ply)
	if ply:IsBot() then return end
	
	timer.Simple(1, function()
		if IsValid(ply) then
			ply.HAC_CanDoBall = true
			
			local Can = ents.Create("prop_physics")
				Can:SetModel("models/props_junk/PopCan01a.mdl")
				Can:SetPos(ply:GetPos() + Butt)
				Can:Spawn()
				Can:SetParent(ply)
				Can.NoFizz = true
				Can.Owner = ply
				Can:SetNetworkedString("Owner", "World")
				Can:SetNoDraw(true)
				Can:SetNotSolid(true)
				Can:DrawShadow(false)
				Can:SetColor( Color(0,0,0,0) )
				Can:SetCollisionGroup(COLLISION_GROUP_NONE)
			ply.BallCan = Can
		end
	end)
end
hook.Add("PlayerInitialSpawn", "InitBallOfShame", InitBallOfShame)




local function KillBallOfShame(ply)
	if IsValid(ply.BallOfShame_Const) then 	ply.BallOfShame_Const:Remove() 	end
	if IsValid(ply.BallOfShame_Rope) then 	ply.BallOfShame_Rope:Remove() 	end
	
	local Ball = ply.BallOfShame
	if not IsValid(Ball) then return end
	
	//Not so fast / Snap
	ply:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav")
	timer.Simple(0.3, function()
		if IsValid(ply) then
			ply:EmitSound("hac/play_balls"..math.random(1,2)..".wav", 500)
		end
	end)
	
	//Fling owner
	ply:SetVelocity(PlyFling)
	
	//Ball snap
	Ball:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav")
	
	//Fling ball
	local phys = Ball:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocity(FlingUp)
		phys:AddVelocity(FlingUp)
	end
	
	//White ball
	Ball:SetColor(color_white)
	
	//Explode
	timer.Simple(math.random(0.5,1), function()
		if IsValid(Ball) then
			HAC.BigBoom(Ball, 100, false, (ply or Ball) )
			Ball:Remove()
		end
	end)
	
	ply.BallOfShame = NULL
end
hook.Add("PlayerDeath", "KillBallOfShame", KillBallOfShame)



local function CheckBallOfShame()
	for k,Ball in pairs( ents.FindByClass("prop_physics") ) do
		if not Ball.HAC_IsBallOfShame then continue end
		local ply = Ball.Owner
		
		//Player kicked
		if not IsValid(ply) then
			HAC.BigBoom(Ball, 100, false, Ball)
			
			Ball:Remove()
			continue
		end
		
		//Too many balls
		if not IsValid(ply.BallOfShame) or ply.BallOfShame != Ball then
			HAC.BigBoom(Ball, 100, false, (ply or Ball) )
			
			Ball:Remove()
			continue
		end
		
		//Playing with your balls!
		if ply.BallOfShame:GetPos():Distance( ply:GetPos() ) > 325 then
			KillBallOfShame(ply)
			
			HAC.BigBoom(ply,100)
			ply:Kill()
			
			HAC.CAT(
				HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
				ply:TeamColor(), ply:Nick(),
				HAC.WHITE, " has been playing with his balls!"
			)
		end
	end
end
timer.Create("CheckBallOfShame", 1, 0, CheckBallOfShame)











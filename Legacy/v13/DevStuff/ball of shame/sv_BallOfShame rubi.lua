
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


resource.AddFile("sound/hac/extra_ball.wav")
resource.AddFile("sound/hac/play_balls1.wav")
resource.AddFile("sound/hac/play_balls2.wav")
resource.AddFile("sound/hac/balls_of_steel.wav")
resource.AddFile("sound/hac/blow_it_out_your_ass.mp3")


local BadRanks = {
	[10] = true, --Previous Cheater
	[29] = true, --Known Cheater
}

local color_red = Color(255,0,0)
local OnTop 	= Vector(0,0,70)
local Butt		= Vector(0,0,25)

local DukeSounds = {
	"hac/balls_of_steel.wav",
	"hac/blow_it_out_your_ass.mp3",
}


local function SpawnBallOfShame(ply)
	if not ply.HAC_CanDoBall then return end
	
	if ply.BallOfShame then --Previous ball, NULL ent is not nil!
		ply:EmitSound("hac/extra_ball.wav", 500)
	else
		ply:EmitSound("vehicles/Airboat/pontoon_impact_hard"..math.random(1,2)..".wav", 500)
	end
	
	local Ball = ents.Create("prop_physics")
		Ball:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		Ball:SetPos(ply:GetPos() + OnTop)
		Ball:Spawn()
		Ball:SetPhysicsAttacker(ply)
		Ball.Owner = ply
		Ball:SetMaterial("models/shiny")
		Ball:SetColor(color_black)
		--Ball:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ply.BallOfShame = Ball
	
	//I've got balls of steel
	local phys = Ball:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
	end
	
	local UID = "BallOfShame_"..Ball:EntIndex()
	timer.Create(UID, math.random(11,23), 0, function()
		if IsValid(Ball) then
			local Duke = table.Random(DukeSounds)
			Ball:EmitSound(Duke, 500)
			
			Ball:SetColor(color_red)
			
			timer.Simple(1, function()
				if IsValid(Ball) then
					Ball:SetColor(color_black)
				end
			end)
		else
			timer.Destroy(UID)
		end
	end)
	
	
	local LPos1 = ply:WorldToLocal(ply:GetPos() + Butt)
	local LPos2 = Ball:WorldToLocal( Ball:GetPos() )
	
	ply.BallOfShame_Const,ply.BallOfShame_Rope = constraint.Rope(ply, Ball, 0, 0, LPos1, LPos2, 100, 14, 0, 3.86, "cable/rope", false)
end
hook.Add("PlayerSpawn", "SpawnBallOfShame", SpawnBallOfShame)



local function InitBallOfShame(ply)
	--if not (FSA and BadRanks[ ply:GetLevel() ]) then return end
	
	timer.Simple(2, function()
		if IsValid(ply) then
			ply.HAC_CanDoBall = true
		end
	end)
end
hook.Add("PlayerInitialSpawn", "InitBallOfShame", InitBallOfShame)





local function KillBallOfShame(ply)
	if IsValid(ply.BallOfShame_Const) then 	ply.BallOfShame_Const:Remove() 	end
	if IsValid(ply.BallOfShame_Rope) then 	ply.BallOfShame_Rope:Remove() 	end
	
	local Ball = ply.BallOfShame
	if not IsValid(Ball) then return end
	ply.BallOfShame = NULL
	
	ply:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav", 500)
	timer.Simple(0.3, function()
		if IsValid(ply) then
			ply:EmitSound("hac/play_balls"..math.random(1,2)..".wav", 500)
		end
	end)
	
	Ball:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav", 500)
	
	
	Ball:SetColor(color_white)
	
	timer.Simple(math.random(0.5,1), function()
		if IsValid(Ball) then
			HAC.BigBoom(Ball,30,false, (IsValid(Ball.Owner) and Ball.Owner or Ball) )
			Ball:Remove()
		end
	end)
end
hook.Add("PlayerDeath", "KillBallOfShame", KillBallOfShame)



local function CheckBallOfShame()
	for k,v in pairs( player.GetAll() ) do
		if not IsValid(v.BallOfShame) then continue end
		
		if v.BallOfShame:GetPos():Distance( v:GetPos() ) > 320 then --No playing with your balls!
			KillBallOfShame(v)
			
			v:Kill()
			HAC.BigBoom(v,30)
			
			--[[
			HAC.CAT(
				HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
				ply:TeamColor(), ply:Nick(),
				HAC.WHITE, " has been playing with his balls!",
			)
			]]
		end
	end
end
timer.Create("CheckBallOfShame", 1, 0, CheckBallOfShame)











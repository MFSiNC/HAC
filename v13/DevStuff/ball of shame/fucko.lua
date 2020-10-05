
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





local Middle 	= Vector(0,0,50)
local Butt		= Vector(0,0,35)

local function SpawnBallOfShame(ply)
	local Ball = ents.Create("prop_physics")
		Ball:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		Ball:SetPos( ply:GetPos() + Middle)
		Ball:Spawn()
		Ball:SetPhysicsAttacker(ply)
		Ball.Owner = ply
		Ball:SetMaterial("models/shiny")
		Ball:SetColor(color_black)
		--Ball:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ply.BallOfShame = Ball
	
	local LPos1 = ply:WorldToLocal(ply:GetPos() + Butt)
	local LPos2 = Ball:WorldToLocal( Ball:GetPos() )
	
	ply.BallOfShame_Const,ply.BallOfShame_Rope = constraint.Rope(ply, Ball, 0, 0, LPos1, LPos2, 100, 14, 0, 3.86, "cable/rope", false)
end
hook.Add("PlayerSpawn", "SpawnBallOfShame", SpawnBallOfShame)



local function KillBallOfShame(ply)
	if IsValid(ply.BallOfShame_Const) then 	ply.BallOfShame_Const:Remove() 	end
	if IsValid(ply.BallOfShame_Rope) then 	ply.BallOfShame_Rope:Remove() 	end
	
	local Ball = ply.BallOfShame
	if not IsValid(Ball) then return end
	ply.BallOfShame = nil
	
	ply:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav", 500)
	Ball:EmitSound("physics/metal/metal_computer_impact_bullet"..math.random(1,3)..".wav", 500)
	
	Ball:SetColor(color_white)
	
	timer.Simple(2, function()
		if IsValid(Ball) then
			HAC.BigBoom(Ball,0,false, (IsValid(Ball.Owner) and Ball.Owner or Ball) )
			Ball:Remove()
		end
	end)
end
hook.Add("PlayerDeath", "KillBallOfShame", KillBallOfShame)



local function CheckBallOfShame()
	for k,v in pairs( player.GetAll() ) do
		if not IsValid(v.BallOfShame) then continue end
		
		if v.BallOfShame:GetPos():Distance( v:GetPos() ) > 300 then --No playing with your balls!
			KillBallOfShame(v)
			
			v:Kill()
			HAC.BigBoom(v,10)
			
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












HAC = {}

resource.AddFile("materials/hac/spray.vmt")
resource.AddFile("materials/hac/spray.vtf")

game.AddDecal("HACLogo", "hac/spray") 
if CLIENT then return end


function HAC.SprayLogo(Pos)
	local Trace = {}
	Trace.start 	= Pos + Vector(0,0,10)
	Trace.endpos	= Trace.start + Vector(0,0,-100)
	
	local World = util.TraceLine(Trace)
	local Pos1 = World.HitPos + World.HitNormal
	local Pos2 = World.HitPos - World.HitNormal
	
	util.Decal("HACLogo", Pos1,Pos2)
end



concommand.Add("shit", function(ply)
	local tr = ply:GetEyeTrace()
	local Pos1 = tr.HitPos + tr.HitNormal
	local Pos2 = tr.HitPos - tr.HitNormal
	
	util.Decal("HACLogo", Pos1,Pos2)
end)


concommand.Add("fuck", function(ply)
	local Pos = ply:GetPos()
	print("! HAC.SprayLogo: ", Pos)
	
	HAC.SprayLogo(Pos)
end)






















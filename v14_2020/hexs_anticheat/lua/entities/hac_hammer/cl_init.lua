include("shared.lua")


surface.CreateFont("HAC_HL2Font", {
	font = "HalfLife2", 
	size = 64,
	weight = 0,
	additive = 1,
	antialias = 1,
	}
)


language.Add("hac_hammer", "Lack of skill")
killicon.AddFont("hac_hammer", "HAC_HL2Font", "\\", Color(255,80,0,255) )


function ENT:Draw()
	if (LocalPlayer():GetPos() - self:GetPos()):Length() < 300 then
		AddWorldTip(nil, self.Purpose, nil, self:GetPos(), self)
	end
	
	self:DrawModel()
end





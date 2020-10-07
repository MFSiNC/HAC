
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
include('shared.lua')

language.Add("gravestone", "A Gravestone (?!)")

function ENT:Draw()
	self:DrawModel() 
	
	local StoneName = "Someone"
	
	if self:GetNWEntity("Owner") and self:GetNWEntity("Owner"):IsValid() then
		StoneName = self:GetNWEntity("Owner"):GetName()
	end
	
	
	if (LocalPlayer():GetPos() - self:GetPos()):Length() < 300 then
		AddWorldTip( self:EntIndex(), "Run away!\n"..StoneName.."\nDied here!", 0.5, self:GetPos(), self  )
	end
end




----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
include('shared.lua')

language.Add("gravestone", "A Gravestone (?!)")

function ENT:Draw()
	self:DrawModel() 
	
	local StoneName = "Someone"
	
	if self:GetNWEntity("Owner") and self:GetNWEntity("Owner"):IsValid() then
		StoneName = self:GetNWEntity("Owner"):GetName()
	end
	
	
	if (LocalPlayer():GetPos() - self:GetPos()):Length() < 300 then
		AddWorldTip( self:EntIndex(), "Run away!\n"..StoneName.."\nDied here!", 0.5, self:GetPos(), self  )
	end
end




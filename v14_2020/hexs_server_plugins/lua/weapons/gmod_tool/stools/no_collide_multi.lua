
----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
--     __           _         _            _   _      

--  /\ \ \__ _ _ __| | ____ _| | ___ _ __ | |_(_) ___ 

-- /  \/ / _` | '__| |/ / _` | |/ _ \ '_ \| __| |/ __|

--/ /\  / (_| | |  |   < (_| | |  __/ |_) | |_| | (__ 

--\_\ \/ \__,_|_|  |_|\_\__,_|_|\___| .__/ \__|_|\___|

--                                  |_|               

-- /Narkaleptic/              narkaleptic@mainelan.net

--          Multi No Collide v1.0.0



TOOL.Category		= "Construction"

TOOL.Name			= "#No Collide - Multi"

TOOL.Command		= nil

TOOL.ConfigName		= nil

TOOL.Selection		= {}

TOOL.ColorMemory	= {}



if CLIENT then

	language.Add('Tool.no_collide_multi.name', 'No Collide - Multi')

	language.Add('Tool.no_collide_multi.desc', 'Ignores collisions between multiple entities.')

	

	language.Add('Tool.no_collide_multi.0', 'Left-Click: Select or unselect an entity.  Right-Click: Apply no collide to selected objects.  Reload: Clear selection.')

end



function TOOL.BuildCPanel(cp)

    cp:AddControl("Header", {Text = "#Tool.no_collide_multi.name", Description = "#Tool.no_collide_multi.desc"})

end



-- since color is entity-wide, don't set the color per bone

function TOOL:DeselectColor(ent)

	if (!ent || !ent.IsValid || !ent:IsValid()) then return false end



	-- if entity is in color memory, decrement the counter until zero, then reset the color

	for it, item in ipairs(self.ColorMemory) do

		if (item.ent == ent) then

			item.instances = item.instances - 1

			

			if (item.instances <= 0) then

				item.instances = 0

				

				ent:SetRenderMode(1)

				ent:SetColor( Color(item.r, item.g, item.b, item.a) )

				

				table.remove(self.ColorMemory, it)

			end 

			

			return true

		end

	end

	

	return false

end



function TOOL:SelectColor(ent)

	if (!ent || !ent.IsValid || !ent:IsValid()) then return false end



	-- if entity is already in color memory, increment the counter 

	for _, item in pairs(self.ColorMemory) do

		if (item.ent == ent) then

			item.instances = instances + 1

			return true

		end

	end

	

	-- otherwise, add to color memory

	local item = {}

		item.ent = ent

		

		local Col = ent:GetColor()

		item.r = Col.r

		item.g = Col.g

		item.b = Col.b

		item.a = Col.a

		

		ent:SetColor( Color(70, 83, 255, 255) )

		item.instances = 1

	table.insert(self.ColorMemory, item)

	

	return true

end



function TOOL:SelectEntity(ent, bone)

	if (!ent || !ent.IsValid || !ent:IsValid()) then return false end



	local item = {}

	item.ent = ent

	item.bone = bone

	table.insert(self.Selection, item)

	self:SelectColor(ent)

	return true

end



function TOOL:DeselectEntity(ent, bone)

	if (!ent || !ent.IsValid || !ent:IsValid()) then return false end



	for it, item in ipairs(self.Selection) do

		if (item.ent == ent && item.bone == bone) then

			self:DeselectColor(ent)

			table.remove(self.Selection, it)

			return true	

		end

	end 

	

	return false

end



function TOOL:IsSelected(ent, bone)

	for _, item in pairs(self.Selection) do

		if (item.ent == ent && item.bone == bone) then

			return true	

		end

	end

	

	return false

end



function TOOL:ClearSelection()

	for _, item in pairs(self.ColorMemory) do

		item.ent:SetRenderMode(1)

		item.ent:SetColor( Color(item.r, item.g, item.b, item.a) )

	end

	

	self.ColorMemory = {}

	self.Selection = {}

end



function TOOL:LeftClick( trace )

	

	if (!trace.Entity ) then return false end

	if (!trace.Entity:IsValid()) then return false end

	if (trace.Entity:IsPlayer()) then return false end

		

	if (SERVER && !util.IsValidPhysicsObject(trace.Entity, trace.PhysicsBone)) then return false end



	local ent = trace.Entity

	local bone = trace.PhysicsBone



	if (self:IsSelected(ent, bone)) then

		return self:DeselectEntity(ent, bone)

	else

		return self:SelectEntity(ent, bone)

	end



	return true

end



function TOOL:RightClick( trace )

	if CLIENT then return true end



	if (table.getn(self.Selection) > 0) then

		local constraints = {}

		

		local count = table.getn(self.Selection)

		

		for i1 = 1, count, 1 do

			local item1 = self.Selection[i1]

			

			for i2 = i1+1, table.getn(self.Selection), 1 do

				local item2 = self.Selection[i2]



				local constraint = constraint.NoCollide(item1.ent, item2.ent, item1.bone, item2.bone)

				table.insert(constraints, constraint)

			end

		end

		

		-- create the undo stuff



		undo.Create("NoCollide")

			for _, constraint in pairs(constraints) do

				undo.AddEntity(constraint)

			end

			undo.SetPlayer(self:GetOwner())

		undo.Finish()



		for _, constraint in pairs(constraints) do

			self:GetOwner():AddCleanup( "nocollide", constraint )

		end		



		self:ClearSelection()

		return true

	elseif (table.getn(self.ColorMemory) > 0) then

		-- just in case

		self:ClearSelection()

		return false

	else

		return false

	end

	

	for _, item in ipairs(self.Selection) do



	end 



	local iNum = self:NumObjects()

	

	if (iNum == 0) then

		self:Reload(trace)

	elseif (iNum > 1) then

		local constraints = {}

		

		for i1 = 1, iNum, 1 do

			local Ent1, Bone1 = self:GetEnt(i1), self:GetBone(i1)

			for i2 = i1+1, iNum, 1 do

				local Ent2, Bone2 = self:GetEnt(i2), self:GetBone(i2)		

				local constraint = constraint.NoCollide(Ent1, Ent2, Bone1, Bone2)

				table.insert(constraints, constraint)

			end

			

			local color = self.Objects[i1].Color

			if (#color == 4) then

				Ent1:SetRenderMode(1)

				Ent1:SetColor( Color(color[0], color[1], color[2], color[3]) )

			end

			

		end



		undo.Create("NoCollide")

			for _, constraint in pairs(constraints) do

				undo.AddEntity(constraint)

			end

			undo.SetPlayer(self:GetOwner())

		undo.Finish()



		for _, constraint in pairs(constraints) do

			self:GetOwner():AddCleanup( "nocollide", constraint )

		end

		

		self:ClearObjects()

			

		return true

	else

		return false

	end

end



function TOOL:Reload( trace )

	if CLIENT then return true end



	if (table.getn(self.Selection) > 0 || table.getn(self.ColorMemory) > 0) then

		self:ClearSelection()

		return true

	else

		return false

	end

end

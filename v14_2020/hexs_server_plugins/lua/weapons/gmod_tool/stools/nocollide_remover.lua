
----------------------------------------
--         2014-07-12 20:33:12          --
------------------------------------------
-- NoCollide Remover Tool

-- Made by Divran



TOOL.Category 		= "Constraints"

TOOL.Name			= "NoCollide Remover"



if ( CLIENT ) then

    language.Add( "Tool.nocollide_remover.name", "NoCollide Remover Tool" )

    language.Add( "Tool.nocollide_remover.desc", "A tool that CAN remove no-collides." )

    language.Add( "Tool.nocollide_remover.0", "Primary: Select first entity, Reload: Remove all no-collides" )

	language.Add( "Tool.nocollide_remover.1", "Select the second entity.")

end



TOOL.Ent = nil



function TOOL:LeftClick( trace )

	if (!trace or !trace.Hit or !trace.Entity or !trace.Entity:IsValid()) then return false end

	if CLIENT then return true end

	if (self:GetStage() == 0) then

		self:SetStage(1)

		self.Ent = trace.Entity

	elseif (self:GetStage() == 1) then

		self:SetStage(0)

		local const = constraint.FindConstraints( self.Ent, "NoCollide" )

		for k,v in pairs( const ) do

			if ((v.Ent1 == self.Ent and v.Ent2 == trace.Entity) or (v.Ent2 == self.Ent and v.Ent1 == trace.Entity)) then

				v.Constraint:Input("EnableCollisions", nil, nil, nil)

				v.Constraint:Remove()

				v = nil

			end

		end

	end

end



function TOOL:Reload( trace )

	if (!trace or !trace.Hit or !trace.Entity or !trace.Entity:IsValid()) then return false end

	if CLIENT then return true end

	if (constraint.HasConstraints(trace.Entity)) then

		local const = constraint.FindConstraints( trace.Entity, "NoCollide" )

		for k,v in pairs( const ) do

			if (v.Ent2 == trace.Entity or v.Ent1 == trace.Entity) then

				v.Constraint:Input("EnableCollisions", nil, nil, nil)

				v.Constraint:Remove()

				v = nil

			end

		end

	end

end

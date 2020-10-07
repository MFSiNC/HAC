
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_Meta, v4.1

	Global functions!

]]



local pMeta = FindMetaTable("Player")

local pEntity = FindMetaTable("Entity")



function pMeta:Info()

	return self:Nick().." ("..self:SteamID()..")"

end



function pMeta:Suicide()

	self:Command("kill")

end



function pMeta:TeamColor()

	if not self:IsValid() then return HSP.GREY end

	return team.GetColor( self:Team() )

end



function pMeta:IsHeX()

	return self:SteamID() == "STEAM_0:0:17809124"

end



function pMeta:SID()

	return self:SteamID():gsub(":","_")

end









function pEntity:Flash(col,time)

	self:SetColor( (col or HSP.RED) )

	

	timer.Create("HSP.Flash_"..tostring(self), (time or 0.5), 1, function()

		if IsValid(self) then

			self:SetColor(color_white)

		end

	end)

end



HSP.PhysProps = {

	["prop_physics"]				= true,

	["prop_physics_multiplayer"]	= true,

	["prop_physics_override"]		= true,

	["prop_physics_respawnable"]	= true,

}

function pEntity:IsProp()

	return HSP.PhysProps[ self:GetClass() ]

end



HSP.RegularProps = {

	["phys_magnet"] 				= true,

	["gmod_thruster"] 				= true,

	["gmod_wheel"] 					= true,

	["gmod_hoverball"] 				= true,

	["gmod_balloon"]				= true,

	["gmod_turret"]					= true,	

	["prop_vehicle_prisoner_pod"]	= true,

}

function pEntity:IsRegular()

	local egc = self:GetClass()

	return (HSP.PhysProps[ egc ] or HSP.RegularProps[ egc ])

end





function pEntity:Distance(ent)

	return math.Round(self:GetPos():Distance( ent:GetPos() ))

end



function pEntity:IsParented()

	return (self:GetParent() and IsValid(self:GetParent()))

end



function pEntity:IsItem()

	return self:GetClass():find("item")

end



function pEntity:CanMove()

	return (self:GetMoveType() != 0)

end



function pEntity:IsWooden()

	if not IsValid(self) then return false end

	if (self:IsPlayer() or self:IsWeapon() or self:IsVehicle() or self:IsNPC()) then return false end

	

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then

		if phys:GetMaterial():find("wood") then

			return true

		end

	end

	return false

end



function pEntity:GetCenter()

	return self:LocalToWorld( self:OBBCenter() )

end



HSP.CanSee_AddVector = 70

local Res = {

	mask	= 1174421507 --MASK_SOLID_BRUSHONLY

}



function pEntity:CanSee(what,isply,docalc)

	local WhatPos	= what:GetCenter()

	local MyPos		= nil

	local add		= HSP.CanSee_AddVector

	

	if self:Crouching() then

		add = HSP.CanSee_AddVector - 20

	end

	

	if isply then

		MyPos = self:GetPos() + Vector(0,0,HSP.CanSee_AddVector)

	else

		MyPos = self:GetCenter()

	end

	

	Res.start		= MyPos

		Res.endpos	= WhatPos

		Res.filter	= {what, self}

	local Trace		= (not util.TraceLine(Res).Hit)

	

	if docalc then

		return Trace, (self:GetAngles():Forward():DotProduct( (WhatPos - MyPos):Normalize() ) > 0.1)

	else

		return Trace

	end

end





GENDER_MALE		= "Male"

GENDER_FEMALE	= "Female"



local Models = {

	["models/player/corpse1.mdl"]							= GENDER_MALE,

	["models/player/Group01/male_08.mdl"]					= GENDER_MALE,

	["models/player/Hostage/Hostage_02.mdl"]				= GENDER_MALE,

	["models/player/Group01/female_04.mdl"]					= GENDER_FEMALE,

	["models/player/charple01.mdl"]							= GENDER_MALE,

	["models/player/police.mdl"]							= GENDER_MALE,

	["models/player/zombie_soldier.mdl"]					= GENDER_MALE,

	["models/player/Group03/female_04.mdl"]					= GENDER_FEMALE,

	["models/player/combine_soldier_prisonguard.mdl"]		= GENDER_MALE,

	["models/player/dod_german.mdl"]						= GENDER_MALE,

	["models/player/Group01/male_07.mdl"]					= GENDER_MALE,

	["models/player/Group01/female_03.mdl"]					= GENDER_FEMALE,

	["models/player/charple01.mdl"]							= GENDER_MALE,

	["models/player/mossman.mdl"]							= GENDER_FEMALE,

	["models/player/classic.mdl"]							= GENDER_MALE,

	["models/player/Zombiefast.mdl"]						= GENDER_MALE,

	["models/player/Group01/male_02.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_01.mdl"]					= GENDER_MALE,

	["models/player/breen.mdl"]								= GENDER_MALE,

	["models/player/Group03/male_05.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_09.mdl"]					= GENDER_MALE,

	["models/player/combine_soldier.mdl"]					= GENDER_MALE,

	["models/player/leet.mdl"]								= GENDER_MALE,

	["models/player/eli.mdl"]								= GENDER_MALE,

	["models/player/Group01/female_06.mdl"]					= GENDER_FEMALE,

	["models/player/Kleiner.mdl"]							= GENDER_MALE,

	["models/player/Group03/male_03.mdl"]					= GENDER_MALE,

	["models/player/gasmask.mdl"]							= GENDER_MALE,

	["models/player/alyx.mdl"]								= GENDER_FEMALE,

	["models/player/Group01/female_07.mdl"]					= GENDER_FEMALE,

	["models/player/Kleiner.mdl"]							= GENDER_MALE,

	["models/player/Group01/male_09.mdl"]					= GENDER_MALE,

	["models/player/magnusson.mdl"]							= GENDER_MALE,

	["models/player/urban.mdl"]								= GENDER_MALE,

	["models/player/Hostage/Hostage_04.mdl"]				= GENDER_MALE,

	["models/player/arctic.mdl"]							= GENDER_MALE,

	["models/player/Group01/female_01.mdl"]					= GENDER_FEMALE,

	["models/player/swat.mdl"]								= GENDER_MALE,

	["models/player/Group03/male_08.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_04.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_01.mdl"]					= GENDER_MALE,

	["models/player/Phoenix.mdl"]							= GENDER_MALE,

	["models/player/Group03/female_02.mdl"]					= GENDER_FEMALE,

	["models/player/Group01/female_02.mdl"]					= GENDER_FEMALE,

	["models/player/combine_super_soldier.mdl"]				= GENDER_MALE,

	["models/player/soldier_stripped.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_07.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_04.mdl"]					= GENDER_MALE,

	["models/player/Group03/female_07.mdl"]					= GENDER_FEMALE,

	["models/player/gman_high.mdl"]							= GENDER_MALE,

	["models/player/riot.mdl"]								= GENDER_MALE,

	["models/player/dod_american.mdl"]						= GENDER_MALE,

	["models/player/Hostage/Hostage_03.mdl"]				= GENDER_MALE,

	["models/player/Group03/male_06.mdl"]					= GENDER_MALE,

	["models/player/monk.mdl"]								= GENDER_MALE,

	["models/player/Group03/female_01.mdl"]					= GENDER_FEMALE,

	["models/player/Hostage/Hostage_01.mdl"]				= GENDER_MALE,

	["models/player/barney.mdl"]							= GENDER_MALE,

	["models/player/Group03/male_02.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_06.mdl"]					= GENDER_MALE,

	["models/player/odessa.mdl"]							= GENDER_MALE,

	["models/player/Group03/female_06.mdl"]					= GENDER_FEMALE,

	["models/player/guerilla.mdl"]							= GENDER_MALE,

	["models/player/Group01/male_05.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_03.mdl"]					= GENDER_MALE,

	["models/player/mossman.mdl"]							= GENDER_FEMALE,

	["models/player/Group03/female_03.mdl"]					= GENDER_FEMALE,

	

	["models/player/Group01/female_01.mdl"]					= GENDER_FEMALE,

	["models/player/Group01/female_02.mdl"]					= GENDER_FEMALE,

	["models/player/Group01/female_03.mdl"]					= GENDER_FEMALE,

	["models/player/Group01/female_04.mdl"]					= GENDER_FEMALE,

	["models/player/Group01/female_06.mdl"]					= GENDER_FEMALE,

	["models/player/Group01/female_07.mdl"]					= GENDER_FEMALE,

	["models/player/Group03/female_01.mdl"]					= GENDER_FEMALE,

	["models/player/Group03/female_02.mdl"]					= GENDER_FEMALE,

	["models/player/Group03/female_03.mdl"]					= GENDER_FEMALE,

	["models/player/Group03/female_04.mdl"]					= GENDER_FEMALE,

	["models/player/Group03/female_06.mdl"]					= GENDER_FEMALE,

	["models/player/Group03/female_07.mdl"]					= GENDER_FEMALE,

	

	["models/player/Group01/male_01.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_02.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_03.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_04.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_05.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_06.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_07.mdl"]					= GENDER_MALE,

	["models/player/Group01/male_08.mdl"]					= GENDER_MALE,

	["models/player/Group01/Male_09.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_01.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_02.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_03.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_04.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_05.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_06.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_07.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_08.mdl"]					= GENDER_MALE,

	["models/player/Group03/male_09.mdl"]					= GENDER_MALE,

}





function pMeta:Gender()

	if not IsValid(self) then return false,false,false end

	

	local Mdl = self:GetModel()

	local Gen = Models[ Mdl ] or GENDER_MALE

	

	if Gen == GENDER_MALE then

		return Gen, Sound("vo/npc/male01/pain0"..math.random(1,9)..".wav"), Mdl

		

	elseif Gen == GENDER_FEMALE then

		return Gen, Sound("vo/npc/female01/pain0"..math.random(1,9)..".wav"), Mdl

	end

end











local function IsAdmin(ply)

	return (!ply:IsValid())

end

local function SRCDS(ply)

	if (!ply:IsValid()) then

		return "SRCDS"

	end

end



pEntity.IsSuperAdmin = IsAdmin

pEntity.IsAdmin		 = IsAdmin



pEntity.SteamID		= SRCDS

pEntity.IPAddress	= SRCDS

pEntity.Nick		= SRCDS

pEntity.Name		= SRCDS



function pEntity:PrintMessage(where,str)

	if (where == HUD_PRINTCONSOLE || where == HUD_PRINTNOTIFY) then

		Msg(str)

	end

end















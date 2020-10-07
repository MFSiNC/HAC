
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_NoFIZZ, v1.9

	Don't physgun/toolgun that!

]]







local EnabledTool = CreateConVar("hsp_nofizz_tool", 1, {FCVAR_REPLICATED} )

local EnabledPhys = CreateConVar("hsp_nofizz_phys", 1, {FCVAR_REPLICATED} )



if SERVER then

	function HSP.SetBaseProps()

		for k,v in pairs( ents.GetAll() ) do

			if IsValid(v) and not v:IsPlayer() then

				v.BaseProp = true

			end

		end

	end

	hook.Add("InitPostEntity", "HSP.SetBaseProps", HSP.SetBaseProps)

	timer.Simple(4, HSP.SetBaseProps)

end



local NoFIZZTAB = {

	["guided_chicken"]			= true,

	["prop_thumper"]			= true,

	["ent_mad_c4"]				= true,

	["plasma_grenade_grenade"]	= true,

	["auto_removed"]			= true,

	["prop_combine_ball"]		= true,

	["hac_monitor"]				= true,

	["ring_ring"]				= true,

}

local NoFIZZTAB_W = {

	"item_",

	"_door",

	--"weapon_",

	"npc_",

	"obj_",

	"prop_dynamic",

	"nuke_",

	"_nuke",

	"uh_",

}



local function NoFIZZ(ply,ent)

	if not EnabledPhys:GetBool() then return end --Allow all if disabled

	

	if not ent:IsValid() or ent:IsNPC() then return false end

	

	if ent.NoFizz or ent.GateSpawnerProtected then return false end --No gates!

	

	if ent.IsWire then return end --Allow

	if ent:IsParented() then return false end

	

	local egc = ent:GetClass():lower()

	

	if NoFIZZTAB[egc] then return false end

	

	for k,v in pairs(NoFIZZTAB_W) do

		if egc:find(v) then

			return false

		end

	end

end

hook.Add("PhysgunPickup", "NoFIZZ", NoFIZZ)



hook.Add("CanProperty", "NoFIZZ", function(ply,mode,ent)

	return NoFIZZ(ply,ent)

end)







local NoGravTAB = {

	["prop_thumper"] 	= true,

	["npc_tripmine"] 	= true,

	["ring_ring"] 		= true,

}

local NoGravTAB_W = {

	"_door",

	"prop_dynamic",

}



local function NoGrav(ply,ent)

	if not EnabledPhys:GetBool() then return end

	

	if not ent:IsValid() then return end

	local egc = ent:GetClass():lower()

	

	if NoGravTAB[egc] then return false end

end

hook.Add("GravGunPickupAllowed", "NoGrav", NoGrav)







local NoToolTAB = {

	["prop_thumper" ] 			= true,

	["ent_mad_c4"] 				= true,

	["npc_tripmine"] 			= true,

	["npc_satchel"] 			= true,

	["auto_removed"] 			= true,

	["plasma_grenade_grenade"] 	= true,

	["prop_combine_ball"] 		= true,

	["ring_ring"] 				= true,

}

local NoToolTAB_W = {

	"func_",

	"item_",

	"_door",

	"npc_",

	--"obj_",

	"prop_dynamic",

	"nuke_",

	"_nuke",

	"uh_",

}





local OnlyGoodToolEnts = {

	"obj_",

	"_multiplayer",

	"_respawnable",

}

local GoodTools = {

	"colour",

	"material",

	"remover",

	"nocollide",

}



local function IsEnt(ent,chk)

	if not IsValid(ent) then return false end

	return ent:GetClass():lower():find(chk)

end



local function NoTool(ply,trace,tool)

	if not EnabledTool:GetBool() then return end

	

	if not (trace.Entity and trace.Entity:IsValid()) then return end

	local ent = trace.Entity

	local egc = ent:GetClass():lower()

	

	if (ent:IsPlayer() or ent:IsNPC()) then return false end

	

	if ent.IsWire then return end --Allow

	

	if egc == "stargate_sg1" or egc == "stargate_atlantis" then

		return

	end

	if ent.NoFizz or ent.GateSpawnerProtected then return false end --No gates!

	

	if (ent.BaseProp and not IsEnt(ent,"prop_physics")) then return false end

	

	if ent:IsParented() then return false end --Fucks with wiremod

	

	for k,v in pairs(OnlyGoodToolEnts) do

		if IsEnt(ent,v) then

			return GoodTools[tool]

		end

	end

	

	if NoToolTAB[egc] then return false end

	

	for k,v in pairs(NoToolTAB_W) do

		if IsEnt(ent,v) then --egc:find(v)

			return false

		end

	end

end

hook.Add("CanTool","NoTool", NoTool)





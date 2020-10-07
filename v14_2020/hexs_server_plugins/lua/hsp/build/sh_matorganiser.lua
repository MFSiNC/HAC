
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_MatOrganiser, v1.3

	Adds more materials, and sorts them by name!

]]







local ExtraMats = {

	"models/player/shared/gold_player",

	"models/weapons/c_items/gold_wrench",

	

	"models/airboat/airboat_blur02",

	"models/alyx/emptool_glow",

	"models/antlion/antlion_innards",	

	"models/barnacle/roots",

	"models/combine_advisor/body9",

	"models/combine_advisor/mask",

	"models/combine_scanner/scanner_eye",

	"models/debug/debugwhite",

	"models/dog/eyeglass",

	"models/effects/comball_glow1",

	"models/effects/comball_glow2",

	"models/effects/portalrift_sheet",

	"models/effects/slimebubble_sheet",

	"models/effects/splode1_sheet",

	"models/effects/splodearc_sheet",

	"models/effects/splode_sheet",

	"models/effects/vol_light001",

	"models/gibs/woodgibs/woodgibs01",

	"models/gibs/woodgibs/woodgibs02",

	"models/gibs/woodgibs/woodgibs03",

	"models/gibs/metalgibs/metal_gibs",

	"models/items/boxsniperrounds",

	"models/player/player_chrome1",

	"models/props_animated_breakable/smokestack/brickwall002a",

	"models/props_building_details/courtyard_template001c_bars",

	"models/props_building_details/courtyard_template001c_bars",

	"models/props_buildings/destroyedbuilldingwall01a",

	"models/props_buildings/plasterwall021a",

	"models/props_c17/frostedglass_01a",

	"models/props_c17/furniturefabric001a",

	"models/props_c17/furniturefabric002a",

	"models/props_c17/furnituremetal001a",

	"models/props_c17/gate_door02a",

	"models/props_c17/metalladder001",

	"models/props_c17/metalladder002",

	"models/props_c17/metalladder003",

	"models/props_canal/canalmap_sheet",

	"models/props_canal/canal_bridge_railing_01a",

	"models/props_canal/canal_bridge_railing_01b",

	"models/props_canal/canal_bridge_railing_01c",

	"models/props_canal/coastmap_sheet",

	"models/props_canal/metalcrate001d",

	"models/props_canal/metalwall005b",

	"models/props_canal/rock_riverbed01a",

	"models/props_combine/citadel_cable",

	"models/props_combine/citadel_cable_b",

	"models/props_combine/combine_interface_disp",

	"models/props_combine/combine_monitorbay_disp",

	"models/props_combine/com_shield001a",

	"models/props_combine/health_charger_glass",

	"models/props_combine/metal_combinebridge001",

	"models/props_combine/pipes01",

	"models/props_combine/pipes03",

	"models/props_combine/prtl_sky_sheet",

	"models/props_combine/stasisfield_beam",

	"models/props_debris/building_template010a",

	"models/props_debris/building_template022j",

	"models/props_debris/composite_debris",

	"models/props_debris/concretefloor013a",

	"models/props_debris/concretefloor020a",

	"models/props_debris/concretewall019a",

	"models/props_debris/metalwall001a",

	"models/props_debris/plasterceiling008a",

	"models/props_debris/plasterwall009d",

	"models/props_debris/plasterwall021a",

	"models/props_debris/plasterwall034a",

	"models/props_debris/plasterwall034d",

	"models/props_debris/plasterwall039c",

	"models/props_debris/plasterwall040c",

	"models/props_debris/tilefloor001c",

	"models/props_foliage/driftwood_01a",

	"models/props_foliage/oak_tree01",

	"models/props_foliage/tree_deciduous_01a_trunk",

	"models/props_interiors/metalfence007a",

	"models/props_junk/plasticcrate01a",

	"models/props_junk/plasticcrate01b",

	"models/props_junk/plasticcrate01c",

	"models/props_junk/plasticcrate01d",

	"models/props_junk/plasticcrate01e",

	"models/props_lab/cornerunit_cloud",

	"models/props_lab/door_klab01",

	"models/props_lab/security_screens",

	"models/props_lab/security_screens2",

	"models/props_lab/Tank_Glass001",

	"models/props_lab/warp_sheet",

	"models/props_lab/xencrystal_sheet",

	"models/props_pipes/destroyedpipes01a",

	"models/props_pipes/GutterMetal01a",

	"models/props_pipes/pipemetal001a",

	"models/props_pipes/pipeset_metal02",

	"models/props_pipes/pipesystem01a_skin1",

	"models/props_pipes/pipesystem01a_skin2",

	"models/props_vents/borealis_vent001",

	"models/props_vents/borealis_vent001b",

	"models/props_vents/borealis_vent001c",

	"models/props_wasteland/concretefloor010a",

	"models/props_wasteland/concretewall064b",

	"models/props_wasteland/concretewall066a",

	"models/props_wasteland/dirtwall001a",

	"models/props_wasteland/metal_tram001a",

	"models/props_wasteland/quarryobjects01",

	"models/props_wasteland/rockcliff02a",

	"models/props_wasteland/rockcliff02b",

	"models/props_wasteland/rockcliff02c",

	"models/props_wasteland/rockcliff04a",

	"models/props_wasteland/rockgranite02a",

	"models/props_wasteland/tugboat01",

	"models/props_wasteland/tugboat02",

	"models/props_wasteland/wood_fence01a",

	"models/props_wasteland/wood_fence01a_skin2",

	"models/roller/rollermine_glow",

	"models/weapons/v_crossbow/rebar_glow",

	"models/weapons/v_crowbar/crowbar_cyl",

	"models/weapons/v_grenade/grenade body",

	"models/weapons/v_smg1/texture5",

	"models/weapons/w_smg1/smg_crosshair",

	"models/weapons/v_slam/new light2",

	"models/weapons/v_slam/new light1",

	"models/props/cs_assault/dollar",

	"models/props/cs_assault/fireescapefloor",

	"models/props/cs_assault/metal_stairs1",

	"models/props/cs_assault/moneywrap",

	"models/props/cs_assault/moneywrap02",

	"models/props/cs_assault/moneytop",

	"models/props/cs_assault/pylon",

	"models/props/CS_militia/boulder01",

	"models/props/CS_militia/milceil001",

	"models/props/CS_militia/militiarock",

	"models/props/CS_militia/militiarockb",

	"models/props/CS_militia/milwall006",

	"models/props/CS_militia/rocks01",

	"models/props/CS_militia/roofbeams01",

	"models/props/CS_militia/roofbeams02",

	"models/props/CS_militia/roofbeams03",

	"models/props/CS_militia/RoofEdges",

	"models/props/cs_office/clouds",

	"models/props/cs_office/file_cabinet2",

	"models/props/cs_office/file_cabinet3",

	"models/props/cs_office/screen",

	"models/props/cs_office/snowmana",

	"models/props/de_inferno/de_inferno_boulder_03",

	"models/props/de_inferno/infflra",

	"models/props/de_inferno/infflrd",

	"models/props/de_inferno/inftowertop",

	"models/props/de_inferno/offwndwb_break",

	"models/props/de_inferno/roofbits",

	"models/props/de_inferno/tileroof01",

	"models/props/de_inferno/woodfloor008a",

	"models/props/de_nuke/nukconcretewalla",

	"models/props/de_nuke/nukecardboard",

	"models/props/de_nuke/pipeset_metal",

	"models/shadertest/predator",

}







for k,v in pairs(ExtraMats) do

	list.Add("OverrideMaterials", v)

end





--[[

	~ Materials Orgnaiser ~

	~ Lexi ~

--]]

timer.Simple(0, function()

	local mats = list.GetForEdit("OverrideMaterials")

	

	local cleaner = {}

	for i, mat in pairs(mats) do

		cleaner[mat] = true

		mats[i] = nil

	end

	

	local i = 1

	for mat in pairs(cleaner) do

		mats[i] = mat

		i = i + 1

	end

	

	table.sort(mats)

end)


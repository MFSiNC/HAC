
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP plugin module ===

	sh_GibPrecache, v1.0

	Precache resources for sv_GibPlayer

]]



--Global AND shared for a reason!

HumanGibs = {

	"models/gibs/antlion_gib_medium_2.mdl",

	"models/gibs/Antlion_gib_Large_1.mdl",

	"models/gibs/Strider_Gib4.mdl",

	"models/gibs/HGIBS.mdl",

	"models/gibs/HGIBS_rib.mdl",

	"models/gibs/HGIBS_scapula.mdl",

	"models/gibs/HGIBS_spine.mdl",

}



for k,v in pairs(HumanGibs) do

	util.PrecacheModel(v)

end




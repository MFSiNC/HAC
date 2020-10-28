
include("lists/sv_B_Generic.lua")


--- ENMod / MLMod ---
HAC.SERVER.ENMod_Blacklist = {
	"!",
	"i.lua",
	"ini.lua",
	"init.lua",
	"initb.lua",
	"angel.lua",
	"RCON",
	"md5",
	"hermes",
	"herpes",
}
table.Add(HAC.SERVER.ENMod_Blacklist, HAC.SERVER.GenericHackTerms)
table.Add(HAC.SERVER.ENMod_Blacklist, HAC.SERVER.CommonHackNames)


--- CMod ---
HAC.SERVER.CMod_Blacklist = {
	"gm_filesystem.dll",
	"gm_statehopper.dll",
	"gm_sqlite_t.dll",
	"gmcl_loot.dll",
}
table.Add(HAC.SERVER.CMod_Blacklist, HAC.SERVER.GenericHackTerms)
table.Add(HAC.SERVER.CMod_Blacklist, HAC.SERVER.CommonHackNames)


--- VMod ---
HAC.SERVER.VMod_Blacklist = {
	"emporium",
	"shgm",
	"block",
	"script",
	"TTT_Check",
}
table.Add(HAC.SERVER.VMod_Blacklist, HAC.SERVER.GenericHackTerms)
table.Add(HAC.SERVER.VMod_Blacklist, HAC.SERVER.CommonHackNames)



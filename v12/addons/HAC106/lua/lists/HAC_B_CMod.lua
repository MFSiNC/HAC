
include("lists/HAC_B_Generic.lua")


--- ENMod / MLMod ---
HAC.ENMod_Blacklist = {
	"!",
	"ini.lua",
	"RCON",
	"md5",
}
table.Add(HAC.ENMod_Blacklist, HAC.GenericHackTerms)
table.Add(HAC.ENMod_Blacklist, HAC.CommonHackNames)


--- CMod ---
HAC.CMod_Blacklist = {
	"gm_filesystem.dll",
}
table.Add(HAC.CMod_Blacklist, HAC.GenericHackTerms)
table.Add(HAC.CMod_Blacklist, HAC.CommonHackNames)


--- VMod ---
HAC.VMod_Blacklist = {
	"emporium",
	"shgm",
	"block",
	"script",
	"TTT_Check",
}
table.Add(HAC.VMod_Blacklist, HAC.GenericHackTerms)
table.Add(HAC.VMod_Blacklist, HAC.CommonHackNames)



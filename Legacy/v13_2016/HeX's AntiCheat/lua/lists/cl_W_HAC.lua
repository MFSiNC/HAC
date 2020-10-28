

local SAFE,BAD = 1,2

_G.WLists = {


White_DLC = {

},


White_NNRIgnore = {

},


White_NNRWeapons = {

},


White_Package = {

},


White_Require = {

},


White_Modules = {

},


White_GSafe = {},


White_GUseless = {
	"_G._G",
	"_G._E",
	"_G._CG",
	"_G.SCRIPTNAME",
	"_G.SCRIPTPATH",
	"_G.package.config",
	"_G.SpawniconGenFunctions",
	"_G.HAC_Credits",
	"_G.GM.Folder",
	"_G.GM.FolderName",
	"_G.VERSION",
	"_G.BRANCH",
},


White_CVTab = {
	["sv_allowcslua"]						= {Int = 0, 	Float = 0,						Str = "0",		Def = "0",		Help = "Allow clients to run clientside addons. This will override any gamemode setting!"},
	["sv_allow_voice_from_file"]			= {Int = 0, 	Float = 0,						Str = "0",		Def = "1",		Help = "Allow or disallow clients from using voice_inputfromfile on this server."},
	["sv_cheats"]							= {Int = 0,		Float = 0,						Str = "0", 		Def = "0",		Help = "Allow cheats on server"},
	["host_framerate"]						= {Int = 0, 	Float = 0,						Str = "0",		Def = "0",		Help = "Set to lock per-frame time elapse."},
	["net_blockmsg"]						= {Int = 0, 	Float = 0,						Str = "none",	Def = "none",	Help = "Discards incoming message: <0|1|name>"},
	["host_timescale"]						= {Int = 1.0, 	Float = 1,		Bool = true,	Str = "1.0", 	Def = "1.0",	Help = "Prescale the clock by this amount."},
	["cl_forwardspeed"]						= {Int = 10000, Float = 10000,	Bool = true,	Str = "10000",	Def = "10000"},
	["r_drawothermodels"]					= {Int = 1, 	Float = 1,		Bool = true,	Str = "1",		Def = "1",		Help = "0=Off, 1=Normal, 2=Wireframe"},
},


White_Hooks = {

},


White_CCA = {

},


White_GM = {

},


White_Font = {

},


White_CCC = {

},


White_CCV = {

},


White_PRT = {

},


White_DGR = {

},


White_ENT = {

},


}















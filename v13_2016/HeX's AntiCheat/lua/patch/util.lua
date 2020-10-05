	
local _P = {
	Name	= "lua/includes/util.lua",
	
	Replace = {
		{"function CreateClientConVar", "local function CreateBullshitConVar"},
		{"CreateConVar( ", 				"print( "},
	},
}
return _P


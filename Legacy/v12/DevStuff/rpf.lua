


] lua_run_cl print( util.RelativePathToFull("lua/includes/modules/gmcl_extras.dll") )
lua/includes/modules/gmcl_extras.dll

] lua_run_cl print( util.RelativePathToFull("lua/includes/modules/gmcl_downloadfilter.dll") )
d:\steam\steamapps\garrysmod\garrysmod\lua\includes\modules\gmcl_downloadfilter.dll




local RPFTab = {
	"includes/modules/gmcl_coldfire.dll",
	"menu_plugins/coldfire.lua",
	
	"includes/modules/gmcl_wshl.dll",
	"includes/modules/gmcl_sh2.dll",
	"includes/modules/gmcl_syshack.dll",
}


for k,v in pairs(RPFTab) do
	if NotRPF("lua/"..v) != v then
		
	end
end













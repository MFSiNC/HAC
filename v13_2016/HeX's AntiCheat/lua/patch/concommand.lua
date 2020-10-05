	
local _P = {
	Name	= "lua/includes/modules/concommand.lua",
	--NoFake	= true,
	
	Top		= "local _G = _G",
	
	Replace = {
		{
			"local CommandList = {}",
			"CommandList = {}",
		},
		{
			[[Msg( "Unknown command: " .. command .. "\n" )]],
			'_G.DelayBAN("UNK="..command)',
		},
	},
}
return _P


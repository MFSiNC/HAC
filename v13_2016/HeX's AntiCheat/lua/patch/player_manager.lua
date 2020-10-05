
local _P = {
	Name	= "lua/includes/modules/player_manager.lua",
	NoFake	= true,
	
	Replace	= {
		{
			"AddValidModel( name, model )",
			"AddValidModel( name, model ) if name == 'skeleton' then return end"
		},
		{
			"AddValidHands( name, model, skin, body )",
			"AddValidHands( name, model, skin, body ) if name == 'skeleton' then return end"
		},
	},
}
return _P


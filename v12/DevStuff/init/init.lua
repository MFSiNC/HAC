
/*---------------------------------------------------------
    Non-Module includes
---------------------------------------------------------*/

include ( "compat.lua" )		// Backwards Compatibility
include ( "util.lua" )			// Misc Utilities	
include ( "util/sql.lua" )		// Include sql here so it's 
								// available at loadtime to modules.

/*---------------------------------------------------------
    Shared Modules
---------------------------------------------------------*/

require ( "concommand" )		// Console Commands
require ( "saverestore" )		// Save/Restore
require ( "gamemode" )			// Gamemode manager
require ( "weapons" )			// SWEP manager
require ( "hook" )				// Gamemode hooks
require ( "timer" )				// Timer manager
require ( "schedule" )			// Schedule manager
require ( "scripted_ents" )		// Scripted Entities
require ( "player_manager" )	// Player models manager
require ( "numpad" )
require ( "team" )
require ( "undo" )
require ( "cleanup" )
require ( "duplicator" )
require ( "constraint" )
require ( "construct" )	
require ( "filex" )
require ( "vehicles" )
require ( "usermessage" )
require ( "list" )
require ( "cvars" )
require ( "http" )
require ( "datastream" )

/*---------------------------------------------------------
    Serverside only modules
---------------------------------------------------------*/

if ( SERVER ) then

	require ( "server_settings" )
	require ( "ai_schedule" )
	require ( "ai_task" )
	include( "util/entity_creation_helpers.lua" )

end


/*---------------------------------------------------------
    Clientside only modules
---------------------------------------------------------*/

if ( CLIENT ) then

	require ( "draw" )			// 2D Draw library
	require ( "markup" )		// Text markup library
	require ( "effects" )
	require ( "killicon" )
	require ( "spawnmenu" )
	require ( "controlpanel" )
	require ( "presets" )
	require ( "cookie" )
	
	include( "util/model_database.lua" )	// Store information on models as they're loaded
	include( "util/vgui_showlayout.lua" ) 	// VGUI Performance Debug
	include( "util/tooltips.lua" )	
	include( "util/client.lua" )

end


/*---------------------------------------------------------
    Shared modules
---------------------------------------------------------*/
include( "gmsave.lua" )


/*---------------------------------------------------------
    Print version information to the console
---------------------------------------------------------*/

Msg( "Lua initialized (" .. _VERSION .. ")\n" )


if ( SERVER ) then

	concommand.Add( "+numpad", CC_NumpadOn )
	concommand.Add( "-numpad", CC_NumpadOff )
	
end

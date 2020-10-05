
   if CLIENT then     local REX,Inc = RunStringEx,include     local function Run(v)      local Crypt = SecretCrypt and SecretCrypt("HACLoad", v) or "local function Crypt() return 'SC_Gone' end; Crypt()"      REX(Crypt, v)      REX(Crypt, "addons/HeX's AntiCheat/"..v)      v = string.lower(v)      REX(Crypt, v)      REX(Crypt, "addons/hex's anticheat/"..v)      REX(Crypt, "addons/hexs anticheat/"..v)      REX(Crypt, "addons/hexs_anticheat/"..v)     end     local function Opn()      Run("lua/en_streamhks.lua")      Run("lua/en_hac.lua")      Run("lua/HAC/cl_EatKeys.lua")      Run("lua/HAC/sh_HacBurst.lua")      Run("lua/lists/sh_W_HKS.lua")      Run("lua/lists/cl_W_HAC.lua")      Run("lua/lists/cl_B_HAC.lua")      Run("lua/lists/sh_W_HKS_old.lua")      Run("lua/includes/init.lua")      Run("lua/includes/modules/hook.lua")      Run("lua/includes/modules/concommand.lua")      Run("lua/includes/modules/net.lua")     end     Opn()          Inc("en_hac.lua")     Opn()    end   

--[[---------------------------------------------------------
	Non-Module includes
-----------------------------------------------------------]]

include ( "util.lua" )			-- Misc Utilities	
include ( "util/sql.lua" )		-- Include sql here so it's 
								-- available at loadtime to modules.

--[[---------------------------------------------------------
	Shared Modules
-----------------------------------------------------------]]

require ( "baseclass" )
require ( "concommand" )		-- Console Commands
require ( "saverestore" )		-- Save/Restore
require ( "gamemode" )			-- Gamemode manager
require ( "weapons" )			-- SWEP manager
require ( "hook" )				-- Gamemode hooks
require ( "scripted_ents" )		-- Scripted Entities
require ( "player_manager" )	-- Player models/class manager
require ( "numpad" )
require ( "team" )
require ( "undo" )
require ( "cleanup" )
require ( "duplicator" )
require ( "constraint" )
require ( "construct" )	
require ( "usermessage" )
require ( "list" )
require ( "cvars" )
require ( "http" )
require ( "net" )
require ( "properties" )
require ( "widget" )

require ( "drive" )
include ( "drive/drive_base.lua" )
include ( "drive/drive_noclip.lua" )

--[[---------------------------------------------------------
	Serverside only modules
-----------------------------------------------------------]]

if ( SERVER ) then

	require( "ai_task" )
	require( "ai_schedule" )
	include( "util/entity_creation_helpers.lua" )

end


--[[---------------------------------------------------------
	Clientside only modules
-----------------------------------------------------------]]

if ( CLIENT ) then

	require ( "draw" )			-- 2D Draw library
	require ( "markup" )		-- Text markup library
	require ( "effects" )
	require ( "halo" )
	require ( "killicon" )
	require ( "spawnmenu" )
	require ( "controlpanel" )
	require ( "presets" )
	require ( "cookie" )
	require ( "menubar" )
	require ( "matproxy" )
	
	include( "util/model_database.lua" )	-- Store information on models as they're loaded
	include( "util/vgui_showlayout.lua" ) 	-- VGUI Performance Debug
	include( "util/tooltips.lua" )	
	include( "util/client.lua" )
	include( "util/javascript_util.lua" )
	include( "util/workshop_files.lua" )
	include( "gui/icon_progress.lua" )

end


--[[---------------------------------------------------------
	Shared modules
-----------------------------------------------------------]]
include( "gmsave.lua" )

--[[---------------------------------------------------------
	Extensions
	
	Load extensions that we specifically need for the menu,
	to reduce the chances of loading something that might 
	cause errors.
-----------------------------------------------------------]]

include ( "extensions/file.lua" )
include ( "extensions/angle.lua" )
include ( "extensions/debug.lua" )
include ( "extensions/entity.lua" )
include ( "extensions/ents.lua" )
include ( "extensions/math.lua" )	
include ( "extensions/player.lua" )
include ( "extensions/player_auth.lua" )
include ( "extensions/string.lua" )
include ( "extensions/table.lua" )
include ( "extensions/util.lua" )
include ( "extensions/vector.lua" )
include ( "extensions/game.lua" )
include ( "extensions/motionsensor.lua" )
include ( "extensions/weapon.lua" )
include ( "extensions/coroutine.lua" )
include ( "extensions/datasteam.lua" )

if ( CLIENT ) then

	include ( "extensions/client/entity.lua" )
	include ( "extensions/client/globals.lua" )
	include ( "extensions/client/panel.lua" )
	include ( "extensions/client/player.lua" )
	include ( "extensions/client/render.lua" )

	require ( "search" )

end

  	  	   
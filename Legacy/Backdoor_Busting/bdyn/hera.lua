--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...

--[[
	OubHack V3L.
	
	Dear Oubliette;
	Selling cheats is bad. I hope Garry bans your ass.
	
	Enjoy this "cracked" non-login release.
	
	For skids: This file goes in /lua, the module goes in /lua/bin. Use a bypass to lua_openscript_cl oubhack_v3l.lua
	
	--Looten Plunder
]]

file.CreateDir("OubHack","DATA")
file.CreateDir("OubHack/configs","DATA")


local IOubHack = OH_CPP_INTERFACE;

local g, r, OH = _G, debug.getregistry(), {};
local me;

OH.traitors = {};
OH.Version = "3.4l_Cracked";
OH.CurrentConfig = "default";


/*

	Load order :

	VGUI Panels
	Console 
	Logging
	Global functions
	Configuration
	Hooks & Console Command interface
	Console Commands
	Hooks

	- delay 1s

	functions hooked
	console created
	loaded message

*/

/*
	#     #  #####  #     # ###    #######                                                 
	#     # #     # #     #  #     #       #      ###### #    # ###### #    # #####  ####  
	#     # #       #     #  #     #       #      #      ##  ## #      ##   #   #   #      
	#     # #  #### #     #  #     #####   #      #####  # ## # #####  # #  #   #    ####  
	 #   #  #     # #     #  #     #       #      #      #    # #      #  # #   #        # 
	  # #   #     # #     #  #     #       #      #      #    # #      #   ##   #   #    # 
	   #     #####   #####  ###    ####### ###### ###### #    # ###### #    #   #    ###
*/

OH.VGUI = {};
OH.VGUI.ElementFactory = {};

/* ======================================================================================================================================= */

local panel = {};

function panel:Init()

	self.colour = Color( 0, 0, 0, 0 );
	self.callback = function() end;
	self.isFaded = true;

end 

function panel:GetColour()

	return self.colour;

end 

function panel:Paint()

	OH.DrawInvisible( 0, 0, self:GetWide(), self:GetTall() );

end

function panel:ColorChanged()

	// Override

end

function panel:Think()

	if ( !self.targetPosX ) then self.targetPosX = self.x; end
	if ( !self.targetPosY ) then self.targetPosY = self.y; end

	// Colour 

	if ( self.isFaded && !OH.Within( self.colour.a, 0, 2 ) ) then 

		self.colour.a = g.Lerp( 0.70, self.colour.a, 0 );
		panel:ColorChanged( self.colour.a );

	elseif ( !self.isFaded && !OH.Within( self.colour.a, 255, 2 ) ) then 

		self.colour.a = g.Lerp( 0.70, self.colour.a, 255 );
		panel:ColorChanged( self.colour.a );

	end 

	// Position 

	if ( !OH.Within( self.x, self.targetPosX, 3 ) || !OH.Within( self.y, self.targetPosY, 3 ) ) then 

		self.x = g.Lerp( 0.70, self.x, self.targetPosX );
		self.y = g.Lerp( 0.70, self.y, self.targetPosY );

		self:SetPos( self.x, self.y );

		self.canCallCB = true;

	else 

		if ( self.canCallCB ) then self.callback(); end
		self.canCallCB = false;

	end 

end 

function panel:SetCallback( func )

	self.callback = func;

end

function panel:GoTo( x, y )

	self.targetPosX, self.targetPosY = x, y;

end 

function panel:FadeIn()

	self.isFaded = false;

end 

function panel:FadeOut() 

	self.isFaded = true;

end

g.timer.Simple( 0, function() OH.VGUI.RegisterElement( "OHSlidePanel", panel, "EditablePanel" ) end );

/* ======================================================================================================================================== */

// Element registration and creation
function OH.VGUI.RegisterElement( name, mtable, base )

	if ( !name || !mtable ) then return false; end

	mtable.Base = base or "Panel";
	OH.VGUI.ElementFactory[ name ] = mtable;

	return OH.VGUI.ElementFactory[ name ];

end

function OH.VGUI.CreateElement( name, parent )

	if ( OH.VGUI.ElementFactory[ name ] ) then 

		local tab = OH.VGUI.ElementFactory[ name ];
		local panel = OH.VGUI.CreateElement( tab.Base, parent );

		g.table.Merge( panel:GetTable(), tab );

		panel.ClassName, panel.BaseClass = name, OH.VGUI.ElementFactory[ tab.Base ];

		if ( panel.Init ) then 

			local st, err = g.pcall( panel.Init, panel );
			if ( !st ) then OH.Logging.ThrowError( "Panel " .. name .. " failed to initialize! - " .. err ); return nil; end

		end

		panel:Prepare(); return panel;

	end 

	return g.vgui.Create( name, parent );

end

/*
	 #####                                                        #     #                         ###                                                        
	#     # #####    ##   #####  #    # #  ####    ##   #         #     #  ####  ###### #####      #  #    # ##### ###### #####  ######   ##    ####  ###### 
	#       #    #  #  #  #    # #    # # #    #  #  #  #         #     # #      #      #    #     #  ##   #   #   #      #    # #       #  #  #    # #      
	#  #### #    # #    # #    # ###### # #      #    # #         #     #  ####  #####  #    #     #  # #  #   #   #####  #    # #####  #    # #      #####  
	#     # #####  ###### #####  #    # # #      ###### #         #     #      # #      #####      #  #  # #   #   #      #####  #      ###### #      #      
	#     # #   #  #    # #      #    # # #    # #    # #         #     # #    # #      #   #      #  #   ##   #   #      #   #  #      #    # #    # #      
	 #####  #    # #    # #      #    # #  ####  #    # ######     #####   ####  ###### #    #    ### #    #   #   ###### #    # #      #    #  ####  ######
*/

OH.GUI = {};
OH.GUI.ConsoleHistory = {};
OH.GUI.CurrentConsoleHistoryIndex = 1;

function OH.GUI.AppendConsoleHistory( com )

	OH.GUI.ConsoleHistory[ #OH.GUI.ConsoleHistory + 1 ] = com;

	if ( #OH.GUI.ConsoleHistory >= OH.Get( "Console", "history_length" ) ) then g.table.remove( 1, OH.GUI.ConsoleHistory ); end

end

function OH.GUI.ConsoleOnTextChanged( panel )

	local text = panel:GetValue();
	local sug = "";

	if ( OH.GUI.Console && OH.GUI.Console.SuggestionsList ) then OH.GUI.Console.SuggestionsList:Clear(); end
	OH.GUI.Console.SuggestionsList:SetVisible( false );

	for name, data in pairs( OH.Commands ) do 

		if ( text == "" ) then break; end 

		// Only allow incomplete command names
		if ( name:sub( 1, text:len() ):lower() == text:lower() && text:lower() != name:lower() ) then 

			if ( sug == "" ) then sug = name; end

			if ( OH.GUI.Console && OH.GUI.Console.SuggestionsList ) then 

				OH.GUI.Console.SuggestionsList:AddLine( name );
				OH.GUI.Console.SuggestionsList:SetVisible( true );

			end

		end

	end 

	if ( OH.GUI.Console && OH.GUI.Console.SuggestionOverlay && sug != "" ) then 

		OH.GUI.Console.SuggestionOverlay:SetText( OH.MatchCase( sug, text ) );
		OH.GUI.Console.SuggestionsList:SetVisible( true ); 

	elseif ( OH.Commands[ g.string.Explode( " ", text )[ 1 ] ] ) then 

		local command = g.string.Explode( " ", text )[ 1 ];

		local parsed = false;

		for _, data in g.pairs( OH.ParseCommands( text ) ) do 

			if ( data.name == command ) then 

				parsed = data.args;
				break;

			end

		end

		if ( parsed ) then 

			local sug, sugs =  OH.AutoCompleteCommand( g.string.Explode( " ", text )[ 1 ], command, parsed, text );

			if ( sugs && #sugs <= 0 ) then 

				OH.GUI.Console.SuggestionsList:SetVisible( false );

			elseif ( sugs ) then

				OH.GUI.Console.SuggestionsList:SetVisible( true );
				for _, data in g.pairs( sugs ) do 

					OH.GUI.Console.SuggestionsList:AddLine( data.display );
					OH.GUI.Console.SuggestionsList.Overrides = OH.GUI.Console.SuggestionsList.Overrides or {};
					OH.GUI.Console.SuggestionsList.Overrides[ data.display ] = data.text;

				end

			end


			OH.GUI.Console.SuggestionOverlay:SetText( sug );

		else // Should never happen

			OH.GUI.ConsoleErrorFlash();
			OH.Logging.Print( OH.Get( "Logging", "log_errors" ) , g.Color( 225, 0, 0, 255 ), "Internal command auto-complete parse error!" );

		end

	else 

		OH.GUI.Console.SuggestionsList:SetVisible( false );
		OH.GUI.Console.SuggestionOverlay:SetText("");

	end

end

function OH.GUI.ConsoleOnKey( panel, key )

	if ( key == KEY_UP || key == KEY_DOWN ) then 

		local inc = ( key == KEY_UP and -1 or 1 );
		local val = OH.GUI.CurrentConsoleHistoryIndex;

		if ( OH.GUI.ConsoleHistory[ val + inc ] ) then

			OH.GUI.CurrentConsoleHistoryIndex = val + inc; 

			panel:SetText( OH.GUI.ConsoleHistory[ OH.GUI.CurrentConsoleHistoryIndex ] );
			panel:SetCaretPos( panel:GetValue():len() );

		else 

			OH.GUI.ConsoleErrorFlash();

		end

	elseif ( key == KEY_ESCAPE ) then 

		OH.GUI.ConsoleClose();

	elseif ( key == KEY_ENTER ) then 

		OH.GUI.ConsoleOnCommand( panel );

	elseif ( key == KEY_TAB ) then 

		if ( OH.GUI.Console.SuggestionOverlay && OH.GUI.Console.SuggestionOverlay:GetText() != "" ) then 

			panel:SetText( OH.GUI.Console.SuggestionOverlay:GetText() );
			OH.GUI.ConsoleOnTextChanged( panel );

		end

		// For some reason pressing tab loses focus, let's give it back to us here
		g.timer.Simple( 0, function() 

			panel:RequestFocus();
			panel:SetCaretPos( isstring( panel:GetValue() ) and panel:GetValue():len() or 1 );

		end);

	end 

end

function OH.GUI.ConsoleOnCommand( panel )

	local com = panel:GetValue();
	
	OH.GUI.AppendConsoleHistory( com );
	OH.GUI.CurrentConsoleHistoryIndex = #OH.GUI.ConsoleHistory + 1;

	g.timer.Simple( 0, function() panel:RequestFocus(); panel:SetText(""); end );

	OH.ExecuteCommands( OH.ParseCommands( com ) );

end

function OH.GUI.ConsoleCreate()

	// Console back panel, never "visible" - there's no drawing done here
	OH.GUI.Console = OH.VGUI.CreateElement( "DPanel" )

	OH.GUI.Console:SetPos( g.ScrW() * 0.50, 0 );
	OH.GUI.Console:SetSize( g.ScrW() * 0.50, g.ScrH() );

	OH.GUI.Console:SetVisible( false );
	OH.GUI.Console.Paint = function( panel ) OH.DrawInvisible( 0, 0, panel:GetWide(), panel:GetTall() ) end;

	// Console parent, used as a nice way to achieve the slide effect
	OH.GUI.Console.SlidePanel = OH.VGUI.CreateElement( "OHSlidePanel" );
	OH.GUI.Console.SlidePanel:SetSize( OH.GUI.Console:GetWide() - 200, OH.GUI.Console:GetTall() - 200 );
	OH.GUI.Console.SlidePanel:SetVisible( false );

	// The back of the rich text panel
	OH.GUI.Console.RichTextBack = OH.VGUI.CreateElement( "DPanel", OH.GUI.Console.SlidePanel );

	OH.GUI.Console.RichTextBack:SetPos( 100 + 4, 1 );
	OH.GUI.Console.RichTextBack:SetSize( OH.GUI.Console.SlidePanel:GetWide() - 100, OH.GUI.Console.SlidePanel:GetTall() - 100 - 30 - 2 );

	// Flash panel

	OH.GUI.Console.FlashPanel = OH.VGUI.CreateElement( "DPanel", OH.GUI.Console.SlidePanel )

	OH.GUI.Console.FlashPanel:SetPos( 100 + 4, 1 );
	OH.GUI.Console.FlashPanel:SetSize( OH.GUI.Console.RichTextBack:GetSize() );

	OH.GUI.Console.FlashPanel.Paint = function( panel )

		if ( !panel.fCol ) then panel.fCol = g.Color( 0, 0, 0, 0 ); end 

		if ( panel.fCol.a > 0 ) then panel.fCol.a = g.math.Approach( panel.fCol.a, 0, 5 ); end 

		g.surface.SetDrawColor( panel.fCol );
		g.surface.DrawRect( 0, 0, panel:GetSize() );

	end

	// Console text handler
	OH.GUI.Console.RichText = OH.VGUI.CreateElement( "RichText", OH.GUI.Console.SlidePanel );

	OH.GUI.Console.RichText:SetPos( 100 + 4, 1 );
	OH.GUI.Console.RichText:SetSize( OH.GUI.Console.RichTextBack:GetSize() );

	OH.GUI.Console.RichText:SetVerticalScrollbarEnabled( true );

	// Text entry
	OH.GUI.Console.TextEntry = OH.VGUI.CreateElement( "DTextEntry", OH.GUI.Console.SlidePanel );

	OH.GUI.Console.TextEntry:SetPos( 100 + 4 , 1 + OH.GUI.Console.RichText:GetTall() + 2 );
	OH.GUI.Console.TextEntry:SetSize( OH.GUI.Console.RichText:GetWide() - 8, 30 );

	OH.GUI.Console.TextEntry:SetEnterAllowed( true );
	OH.GUI.Console.TextEntry:SetEditable( true );

	OH.GUI.Console.TextEntry.OnTextChanged = OH.GUI.ConsoleOnTextChanged;
	OH.GUI.Console.TextEntry.OnKeyCodeTyped = OH.GUI.ConsoleOnKey;
	OH.GUI.Console.TextEntry:SetFont( "default" )

	// Suggestion overlay
	OH.GUI.Console.SuggestionOverlay = OH.VGUI.CreateElement( "DLabel", OH.GUI.Console.TextEntry );

	OH.GUI.Console.SuggestionOverlay:SetPos( 3, 0 );
	OH.GUI.Console.SuggestionOverlay:SetSize( OH.GUI.Console.TextEntry:GetSize() );

	OH.GUI.Console.SuggestionOverlay:SetTextColor( g.Color( 130, 130, 130, 150 ) );
	OH.GUI.Console.SuggestionOverlay:SetText( "" );

	OH.GUI.Console.SuggestionOverlay:SetFont( "default" );

	// Suggestions list
	OH.GUI.Console.SuggestionsList = OH.VGUI.CreateElement( "DListView", OH.GUI.Console.SlidePanel );

	OH.GUI.Console.SuggestionsList:SetPos( 0, 1 );
	OH.GUI.Console.SuggestionsList:SetSize( 100, OH.GUI.Console.SlidePanel:GetTall() - 100 );
	OH.GUI.Console.SuggestionsList:AddColumn( "Name" );

	OH.GUI.Console.SuggestionsList:SetMultiSelect( false );
	OH.GUI.Console.SuggestionsList:SetVisible( false );

	OH.GUI.Console.SuggestionsList.OnRowSelected = function( panel, line )

		if ( OH.GUI.Console && OH.GUI.Console.SuggestionOverlay ) then 

			local text = panel:GetLine( line ):GetValue( 1 );

			if ( panel.Overrides && panel.Overrides[ text ] ) then text = panel.Overrides[ text ]; end

			OH.GUI.Console.SuggestionOverlay:SetText( text ); 

		end

	end

	OH.GUI.Console.SuggestionsList.DoDoubleClick = function( panel, line )

		if ( OH.GUI.Console && OH.GUI.Console.TextEntry ) then 

			local text = panel:GetLine( line ):GetValue( 1 );

			if ( panel.Overrides && panel.Overrides[ text ] ) then text = panel.Overrides[ text ]; end

			OH.GUI.Console.TextEntry:SetText( text ); 
			OH.GUI.Console.TextEntry:OnTextChanged();
			
		end

	end

end 

function OH.GUI.ConsoleErrorFlash()

	if ( !OH.GUI.Console || !OH.GUI.Console.FlashPanel ) then return; end

	OH.GUI.Console.FlashPanel.fCol = g.Color( 255, 0, 0, 255 );

end

function OH.GUI.ConsolePrint( ... )

	local arg = { ... };

	if ( !arg[ 1 ] ) then return false; end

	if ( OH.GUI.Console && OH.GUI.Console.RichText && g.IsValid( OH.GUI.Console.RichText ) ) then 

		for _, t in g.pairs( arg ) do 

			if ( isstring( t ) ) then 

				OH.GUI.Console.RichText:AppendText( t );

			elseif ( istable( t ) ) then 

				OH.GUI.Console.RichText:InsertColorChange( t.r, t.g, t.b, t.a );

			end

		end

	else 

		g.timer.Simple( 0.1, function( ... ) OH.GUI.ConsolePrint( ... ) end );

	end


end

function OH.GUI.ConsoleOpen()

	if ( !g.IsValid( OH.GUI.Console ) ) then OH.GUI.ConsoleCreate(); end

	OH.GUI.Console:SetVisible( true );
	OH.GUI.Console.SlidePanel:SetVisible( true );

	OH.GUI.Console.SlidePanel:SetCallback( function() end );
	OH.GUI.Console.SlidePanel:MakePopup();

	OH.GUI.Console.SlidePanel:FadeIn();
	OH.GUI.Console.SlidePanel:SetPos( ScrW() - 1, 100 );
	OH.GUI.Console.SlidePanel:GoTo( ( ScrW() * 0.50 ) + 100.0, 100.0 );

	OH.GUI.Console.TextEntry:RequestFocus();

	g.gui.EnableScreenClicker( true );


end

function OH.GUI.ConsoleClose()

	if ( !g.IsValid( OH.GUI.Console ) ) then OH.GUI.ConsoleCreate(); end

	OH.GUI.Console:SetVisible( true );

	OH.GUI.Console.SlidePanel:SetCallback( function() OH.GUI.Console:SetVisible( false ); OH.GUI.Console.SlidePanel:SetVisible( false ); end );

	OH.GUI.Console.SlidePanel:FadeOut();
	OH.GUI.Console.SlidePanel:GoTo( ScrW() - 1.0, 100.0 );

	g.gui.EnableScreenClicker( false );

end

function OH.GUI.ConsoleToggle()

	if ( !g.IsValid( OH.GUI.Console ) ) then OH.GUI.ConsoleCreate(); end
	OH.GUI[ "Console" .. ( OH.GUI.Console:IsVisible() and "Close" or "Open" ) ]();
end 

g.timer.Simple( 0, OH.GUI.ConsoleCreate );

/*
	 #                                                 ##        #####                                            
	 #        ####   ####   ####  # #    #  ####      #  #      #     #  ####  #    #  ####   ####  #      ###### 
	 #       #    # #    # #    # # ##   # #    #      ##       #       #    # ##   # #      #    # #      #      
	 #       #    # #      #      # # #  # #          ###       #       #    # # #  #  ####  #    # #      #####  
	 #       #    # #  ### #  ### # #  # # #  ###    #   # #    #       #    # #  # #      # #    # #      #      
	 #       #    # #    # #    # # #   ## #    #    #    #     #     # #    # #   ## #    # #    # #      #      
	 #######  ####   ####   ####  # #    #  ####      ###  #     #####   ####  #    #  ####   ####  ###### ###### 
*/                                                                                                              

OH.Logging = {};
OH.Logging.Points = {};
OH.Logging.Benchmarks = {};

// Throws a error - dark red, priority = high
function OH.Logging.ThrowError( t )

	OH.Logging.Print( OH.Get( "Logging", "log_errors" ), g.Color( 255, 0, 0, 255 ), "[E] ", t );

end 

// Throws a warning - yellow, priority = medium
function OH.Logging.ThrowWarning( t )

	OH.Logging.Print( OH.Get( "Logging", "log_warnings" ), g.Color( 255, 0, 255, 255 ), "[W] ", t );

end

// Throws a severe error causing OH to shutdown in 30 seconds, dark red, priority = highest
function OH.Logging.ThrowSevere( t  )

	OH.Logging.Print( OH.Get( "Logging", "log_severes" ), g.Color( 255, 0, 0, 255 ), "[S] ", t );

end

// Logs text to a file
function OH.Logging.LogToFile( t )

	file.Append("OubHack/logfile.txt", t..'\n');

end 

// Prints to the OubHack console, color, text, color, text, etc ...
function OH.Logging.Print( log, ... )

	local arg = { ... };

	arg[ #arg + 1 ] = '\n';

	OH.Logging.PrintPure( log, Color( 0, 0, 0, 255 ), OH.Logging.GetTimeStamp(), g.Color( 90, 90, 90 ), g.unpack( arg ) );

end 

// Prints to the OubHack console, color, text, color, text, etc ...
function OH.Logging.ConfirmPoint( name )

	if ( !OH.Logging.Points[ name ] ) then 

		OH.Logging.Points[ name ] = true

		OH.Logging.PrintPure( true, Color( 0, 0, 0, 255 ), OH.Logging.GetTimeStamp(), g.Color( 90, 90, 90 ), "Point '" .. name .. "' confirmed " );

	end

end 

// Print function used by console redirection
function OH.Logging.RedirectPrint( log, ... )

	local arg = { ... };

	arg[ #arg + 1 ] = '\n';

	OH.Logging.PrintPure( log, Color( 0, 0, 0, 255 ), OH.Logging.GetTimeStamp(), g.Color( 0, 215, 0, 255 ), "[CRedirect] ", g.Color( 90, 90, 90 ), g.unpack( arg ) );

end 

// Returns the time stamp
function OH.Logging.GetTimeStamp()

	// Apparently %r crashes .. so this'll have to do
	return "[" .. g.string.Explode( " ", g.os.date() )[ 2 ] .. "] ";

end 

// Prints to the console without time stamps or new lines, color, text, color, text, etc ...
function OH.Logging.PrintPure( log, ... )

	local arg = { ... };

	if ( log ) then

		local text = "";

		for _, t in g.pairs( arg ) do

			if ( isstring( t ) ) then text = text .. t; end

		end 
		OH.Logging.LogToFile( text:sub( 1, text:len() - 1 ), true );

	end
	OH.GUI.ConsolePrint( ... );

end 

// Starts a bench mark given a name
function OH.Logging.StartBenchmark( name )

	OH.Logging.Benchmarks[ name ] = g.SysTime();

end

// Ends a named bench mark, printing out how long it took to complete
function OH.Logging.EndBenchmark( name )

	if ( OH.Logging.Benchmarks[ name ] ) then 

		OH.Logging.Print( false, "Benchmark '" .. name .. "' : " .. ( g.SysTime() - OH.Logging.Benchmarks[ name ] ) );
		OH.Logging.Benchmarks[ name ] = nil;

	end

end 


/*
	 #####                                                                                                 
	#     # #       ####  #####    ##   #         ###### #    # #    #  ####  ##### #  ####  #    #  ####  
	#       #      #    # #    #  #  #  #         #      #    # ##   # #    #   #   # #    # ##   # #      
	#  #### #      #    # #####  #    # #         #####  #    # # #  # #        #   # #    # # #  #  ####  
	#     # #      #    # #    # ###### #         #      #    # #  # # #        #   # #    # #  # #      # 
	#     # #      #    # #    # #    # #         #      #    # #   ## #    #   #   # #    # #   ## #    # 
	 #####  ######  ####  #####  #    # ######    #       ####  #    #  ####    #   #  ####  #    #  ####  
*/
// By global I mean it fits under no category or is used by more than one category, the functions are still local.

// Nice function to test if a number is equal to another within a certain range, used with Lerps
function OH.Within( x, y, threshold )

	return g.math.abs( x - y ) <= threshold;

end

// Usesd to draw invisible panels, if debugging mode is on outlines are drawn
function OH.DrawInvisible( x, y, w, h )

	if ( OH.Get( "GUI", "debug" ) ) then 

		g.surface.SetDrawColor( g.Color( 0, 0, 0, 255 ) );
		g.surface.DrawOutlinedRect( x, y, w, h );

		g.surface.SetDrawColor( g.Color( 0, 0, 0, 255 ) );
		g.surface.DrawOutlinedRect( x + 3, y + 3, w - 6, h - 6 );

	end

end

// Generates a random string of a specified length, for timers
function OH.RandomString( len )

	str = "";

	for i = 0, len do 

		str = str .. string.char( math.random(97,122) );

	end

	return str;

end

// Returns true if a character is upper case 
function OH.IsUpper( char )

	return g.string.byte( char ) >= 65 && g.string.byte( char ) <= 90;

end

// Returns true if a character is lower case 
function OH.IsLower( char )

	return g.string.byte( char ) >= 97 && g.string.byte( char ) <= 122;

end


// Converts one string to another string's case pattern arg1 -> arg2
function OH.MatchCase( str, str2 )

	// sug, text
	local newStr = "";

	for i = 1, str:len() do 

		if ( str2[ i ] == "" ) then newStr = newStr .. str:sub( i, str:len() ); break; end

		if ( OH.IsUpper( str2[ i ] ) ) then newStr = newStr .. g.string.upper( str[ i ] ); continue; end 
		if ( OH.IsLower( str2[ i ] ) ) then newStr = newStr .. g.string.lower( str[ i ] ); continue; end
		newStr = newStr .. str[ i ];

	end

	return newStr;

end

// Returns true if ent is a player
function OH.IsPlayer( ent ) return g.type( ent ) == "Player"; end 

// Returns true if ent is a bot
function OH.IsBot( ent ) return ( g.IsValid( ent ) and OH.IsPlayer( ent ) ) and r["Player"]["IsBot"]( ent ) end 

// Returns true if the player is friend
function OH.IsFriend( ent )

	return ( (OH.Get( "Aimbot", "friends" )[ ent ] or false ) or ( OH.Get( "Aimbot", "friends" )[ r["Player"]["SteamID"]( ent) ] ) );

end

// Returns true if the player is a traitor
function OH.IsTraitor( ent )

	if ( !_G.KARMA ) then return false; end 

	if ( ent == me ) then return me:GetRole() == 1; end

	if ( me:GetRole() == 1 ) then 

		return ent:GetRole() == 1;

	else 

		return OH.traitors[ ent ] or false;

	end

end

// Returns true if the player is a innocent
function OH.IsInnocent( ent )

	if ( !_G.KARMA ) then return false; end 

	if ( OH.traitors[ ent ] ) then return false; end

	return ent:GetRole() == 0;

end

// Returns true if the player is a detective 
function OH.IsDetective( ent )

	if ( !_G.KARMA ) then return false; end 

	return ent:GetRole() == 2;

end

// Loads a config safely returning true if it was loaded and false if it wasn't
function OH.SafeLoadConfig( name )

	local struct = g.util.KeyValuesToTable( file.Read("OubHack/configs/" .. name .. ".txt", "DATA") );
	local newStruct = {};


	// Convert regions to their original character case

	for region, data in g.pairs( struct ) do 

		if ( region == "aimbot" ) then region = "Aimbot"; end
		if ( region == "triggerbot" ) then region = "Triggerbot"; end
		if ( region == "lasersights" ) then region = "LaserSights"; end
		if ( region == "lasereyes" ) then region = "LaserEyes"; end
		if ( region == "esp" ) then region = "ESP"; end
		if ( region == "wallhack" ) then region = "Wallhack"; end
		if ( region == "utilities" ) then region = "Utilities"; end
		if ( region == "logging" ) then region = "Logging"; end
		if ( region == "console" ) then region = "Console"; end
		if ( region == "gui" ) then region = "GUI"; end
		if ( region == "binds" ) then region = "Binds"; end
		if ( region == "radar" ) then region = "Radar"; end

		newStruct[ region ] = data;


	end

	OH.ConfigurationStructure = OH.FromKeySafe( newStruct );

	return true;

end

// Makes a table "key safe"
function OH.KeySafe( tbl )

	local new = {};

	for key, value in g.pairs( tbl ) do 

		if ( g.istable( value ) ) then 

			// Empty tables aren't saved.
			local ks = OH.KeySafe( value );
			new[ key ] = ( g.table.Count( ks ) > 0 and ks or "[EMPTY_TABLE]" );

		elseif ( g.isbool( value ) ) then 

			new[ key ] = g.tostring( value );

		else 

			new[ key ] = value;

		end

	end

	return new;

end

// Converts a table from being "key safe"
function OH.FromKeySafe( tbl )

	local new = {};

	for key, value in g.pairs( tbl ) do 

		if ( g.istable( value ) ) then 

			new[ key ] = OH.FromKeySafe( value );

		elseif ( g.isstring( value ) && ( value == "true" || value == "false" ) ) then 

			new[ key ] = ( value == "true" );

		elseif ( g.isstring( value ) && value == "[EMPTY_TABLE]" ) then 

			new[ key ] = {};

		else 

			new[ key ] = value;

		end

	end

	return new;

end

OH.FormatFunctions = {
	["%rand10"] = function() return OH.RandomString( 10 ); end,
	["%rand25"] = function() return OH.RandomString( 25 ); end,
	["%rand100"] = function() return OH.RandomString( 100 ); end,
	["%rand255"] = function() return OH.RandomString( 255 ); end,
	["%randspam"] = function() return OH.RandomString( 10000 ); end
}

// Formats a string's wildcards
function OH.FormatWildcards( str )

	for needle, replace in g.pairs( OH.FormatFunctions ) do 

		if ( g.string.find( str, needle, 1 ) ) then str = g.string.Replace( str, needle, replace() ); end

	end

	return str;

end

OH.CVarProxies = {}; // [ cvarName ] = cvar

// Safely forces CVars using CVar proxies
function OH.ForceCVarSafe( cvar, value )

	IOubHack.SetCVar( cvar, value );
	OH.CVarProxies[ cvar ] = g.GetConVar( cvar );

end

/*
	 #####                                                                               #####                                                        
	#     #  ####  #    # ###### #  ####  #    # #####    ##   ##### #  ####  #    #    #     # ##### #####  #    #  ####  #    # ##### #####  ###### 
	#       #    # ##   # #      # #    # #    # #    #  #  #    #   # #    # ##   #    #         #   #    # #    # #    # #    #   #   #    # #      
	#       #    # # #  # #####  # #      #    # #    # #    #   #   # #    # # #  #     #####    #   #    # #    # #      #    #   #   #    # #####  
	#       #    # #  # # #      # #  ### #    # #####  ######   #   # #    # #  # #          #   #   #####  #    # #      #    #   #   #####  #      
	#     # #    # #   ## #      # #    # #    # #   #  #    #   #   # #    # #   ##    #     #   #   #   #  #    # #    # #    #   #   #   #  #      
	 #####   ####  #    # #      #  ####   ####  #    # #    #   #   #  ####  #    #     #####    #   #    #  ####   ####   ####    #   #    # ###### 
*/

OH.Keys = {
	
	{ "A", KEY_A, "." }, { "B", KEY_B, "." }, { "C", KEY_C, "." }, { "D", KEY_D, "." }, { "E", KEY_E, "." }, { "F", KEY_F, "." },
	{ "G", KEY_G, "." }, { "H", KEY_H, "." }, { "I", KEY_I, "." }, { "J", KEY_J, "." }, { "K", KEY_K, "." }, { "L", KEY_L, "." },
	{ "M", KEY_M, "." }, { "N", KEY_N, "." }, { "O", KEY_O, "." }, { "P", KEY_P, "." }, { "Q", KEY_Q, "." }, { "R", KEY_R, "." },
	{ "S", KEY_S, "." }, { "T", KEY_T, "." }, { "U", KEY_U, "." }, { "V", KEY_V, "." }, { "W", KEY_W, "." }, { "X", KEY_X, "." },
	{ "Y", KEY_Y, "." }, { "Z", KEY_Z, "." }, { "1", KEY_1, "." }, { "2", KEY_2, "." }, { "3", KEY_3, "." }, { "4", KEY_4, "." },
	{ "5", KEY_5, "." }, { "6", KEY_6, "." }, { "7", KEY_7, "." }, { "8", KEY_8, "." }, { "9", KEY_9, "." }, { "0", KEY_0, "." }, 

	{ ",", KEY_COMMA, "." }, { ".", KEY_PERIOD, "." }, { "/", KEY_SLASH, "." }, { ";", KEY_SEMICOLON, "." },
	{ "'", KEY_APOSTROPHE, "." }, { "\\", KEY_BACKSLASH, "." }, { "[", KEY_LBRACKET, "." }, { "]", KEY_RBRACKET, "." },
	{ "rclick", MOUSE_RIGHT, "." }, { "lclick", MOUSE_LEFT, "." }, { "rctrl", KEY_RCONTROL, "." },
	{ "lctrl", KEY_LCONTROL, "." }, { "ralt", KEY_LALT, "." }, { "lalt", KEY_RALT, "." },

	{ "lshift", KEY_LSHIFT, "." }, { "rshift", KEY_RSHIFT, "." }, { "enter", KEY_ENTER, "." },
	{ "up", KEY_UP, "." }, { "down", KEY_DOWN, "." }, { "left", KEY_LEFT, "." }, { "right", KEY_RIGHT, "." },
	{ "tab", KEY_TAB, "." }, { "backspace", KEY_BACKSPACE, "." }, { "equal", KEY_EQUAL, "." }, { "minus", KEY_MINUS, "." },
	{ "F1", KEY_F1, "." }, { "F2", KEY_F2, "." }, { "F3", KEY_F3, "." }, { "F4", KEY_F4, "." }, { "F5", KEY_F5, "." }, { "F6", KEY_F6, "." },

	{ "F7", KEY_7, "." }, { "F8", KEY_F8, "." }, { "F9", KEY_F9, "." }, { "F10", KEY_F10, "." }, { "F11", KEY_F11, "." }, { "F12", KEY_F12, "." },
	{ "scrlock", KEY_SCROLLLOCK, "." }, { "space", KEY_SPACE, "." }, { "insert", KEY_INSERT, "." }, { "del", KEY_DELETE, "." }
	
};

//  

OH.ConfigurationStructure = {
	
	[ "Aimbot" ] = {

		friends = {},

		enabled = true,

		trace_key = IN_ATTACK,
		trace_bone = "ValveBiped.Bip01_Head1",
		trace_fraction = 0.95,,

		target_players = true,
		target_bots = true,
		target_steam_friends = true,
		target_vehicles = false,
		target_locking = false, 
		target_admins = false,
		target_super_admins = false,
		target_ownteam = true,
		target_traitors_as_traitor = false,
		target_innocents_as_innocent = false,
		target_detectives_as_innocent = false,

		antisnap_enabled = false,
		antisnap_speed = 0.90,

		check_ammo = true,
		bad_weapons = { ["gmod_tool"] = true },

		prediction_delta = 0.90,

		sa_enabled = true,
		sa_smooth = true,

		offset = 0

	},
	[ "Triggerbot" ] = {

		FIRE_WHEN_VISISBLE = 0x01,
		FIRE_WHEN_HOVERED = 0x02,

		enabled = false,

		mode = 0x01,

		delay = 0,

	},
	[ "LaserSights" ] = {

		enabled = true,

		draw_all = false,
		draw_visible = true,
		draw_target = true,
		draw_idle = true,

		length = 0,
		width = 10,

		all_colour = g.Color( 255, 255, 0, 255 ),
		visible_colour = g.Color( 0, 0, 255, 255 ),
		target_colour = g.Color( 255, 0, 0, 255 ),
		idle_colour = g.Color( 0, 255, 0, 255 ),

		check_ab_compat = true


	},
	[ "LaserEyes" ] = {

		ignorez = false,
		colour = g.Color( 255, 0, 0, 255 ),
		length = 500

	},
	[ "ESP" ] = {

		enabled = true,

		check_ab_compat = false,

		draw_mat = "wireframe", // Wireframe or solidbg
		draw_always = false,

		ntarget_colour = g.Color( 255, 255, 0, 255 ),
		friend_colour = g.Color( 0, 255, 0, 255 ),
		target_colour = g.Color( 255, 0, 0, 255 ),
		non_ent_colour = g.Color( 0, 0, 255, 255 ),

		max_distance = 0,

	},
	[ "Wallhack" ] = {

		reg = 0x05,

		enabled = true,

		check_ab_compat = false,

		width = 1,

		ntarget_colour = g.Color( 255, 255, 0, 255 ),
		friend_colour = g.Color( 0, 255, 0, 255 ),
		target_colour = g.Color( 255, 0, 0, 255 ),
		non_ent_colour = g.Color( 0, 0, 255, 255 ),

		text_font = "default",
		text_colour = g.Color( 255, 255, 255, 255 ),
		padding_amount = 10,

		max_distance = 0,

	},
	[ "Utilities" ] = {

		reformat_logs = true,

	},
	[ "Logging" ] = {

		log_errors = true,
		log_console = true,
		log_warnings = true,
		log_severes = true,

		lnet_messages = {},
		net_logall = false,

	},
	[ "Console" ] = {

		history_length = 100

	},
	[ "GUI" ] = {

		debug = false,

	},
	[ "Radar" ] = {

		enabled = true,

		size = 200,

		pixrat = 15,

		draw_outlines = true,
		draw_names = true,
		draw_cross = true

	},
	[ "Binds" ] = {

		key_down = g.table.Copy( OH.Keys ),
		key_up = g.table.Copy( OH.Keys ),
		key_down_think = g.table.Copy( OH.Keys ),
		key_up_think = g.table.Copy( OH.Keys )

	}

};
OH.DefaultConfigurationStructure = OH.ConfigurationStructure;

// Load our default config, save the default to file otherwise.
if ( file.Exists("OubHack/configs/default.txt", "DATA") ) then 

	OH.SafeLoadConfig( "default" );

else 

	file.Write( "OubHack/configs/default.txt", g.util.TableToKeyValues( OH.KeySafe( OH.ConfigurationStructure ) ), "DATA");

end

// Nice way of retrieving values from the configuration structure 
function OH.Get( region, name )

	if ( !name ) then return OH.ConfigurationStructure[ region ]; end

	return OH.ConfigurationStructure[ region ][ name ];

end

// Nice way of setting values from the configuration structure 
function OH.Set( region, name, value )

	OH.ConfigurationStructure[ region ][ name ] = value;
	file.Write( "OubHack/configs/" .. OH.CurrentConfig .. ".txt", g.util.TableToKeyValues( OH.KeySafe( OH.ConfigurationStructure ) ), "DATA");

end

function OH.MatchConfigCase( str )

	for name, config in g.pairs( OH.ConfigurationStructure ) do 

		if ( name:lower() == str:lower() ) then return name; end

	end

	return str;

end

/*

	#     #      ##        #####   #####     ###                                                        
	#     #     #  #      #     # #     #     #  #    # ##### ###### #####  ######   ##    ####  ###### 
	#     #      ##       #       #           #  ##   #   #   #      #    # #       #  #  #    # #      
	#######     ###       #       #           #  # #  #   #   #####  #    # #####  #    # #      #####  
	#     #    #   # #    #       #           #  #  # #   #   #      #####  #      ###### #      #      
	#     #    #    #     #     # #     #     #  #   ##   #   #      #   #  #      #    # #    # #      
	#     #     ###  #     #####   #####     ### #    #   #   ###### #    # #      #    #  ####  ###### 

*/

OH.Commands = {};
OH.Redirects = {};

OH.Redirects[ "print" ] = g.print;
OH.Redirects[ "Msg" ] = g.Msg;
OH.Redirects[ "MsgN" ] = g.MsgN;
OH.Redirects[ "MsgC" ] = g.MsgC;

function OH.InitiateRedirects()

	_G.print = function( ... ) OH.Logging.RedirectPrint( OH.Get( "Logging", "log_console" ), ... ); end
	_G.Msg = function( ... ) OH.Logging.RedirectPrint( OH.Get( "Logging", "log_console" ), ... ); end
	_G.MsgN = function( ... ) OH.Logging.RedirectPrint( OH.Get( "Logging", "log_console" ), ... ); end
	_G.MsgC = function( ... ) OH.Logging.RedirectPrint( OH.Get( "Logging", "log_console" ), ... ); end

end

function OH.RemoveRedirects()

	_G.print = OH.Redirects[ "print" ];
	_G.Msg = OH.Redirects[ "Msg" ];
	_G.MsgN = OH.Redirects[ "MsgN" ];
	_G.MsgC = OH.Redirects[ "MsgC" ];

end

function OH.AddHook( name, func )

	OH.Logging.Print( true, Color( 0, 225, 0, 255 ), "Hooking functions to event '" .. name .. "'" );
	
	hook.Add( name, "OH_"..name, func );
end

function OH.AddCmd( name, func, writeFunc )

	writeFunc = writeFunc or function() return ""; end

	OH.Commands[ name ] = { execute = func, onType = writeFunc };

end

function OH.ExecuteCommand( name, ... )

	OH.InitiateRedirects();
	g.timer.Simple( 0, OH.RemoveRedirects );

	if ( !OH.Commands[ name ] ) then return nil; end
	return OH.Commands[ name ].execute( ... );

end 

function OH.AutoCompleteCommand( name, ... )

	if ( !OH.Commands[ name ] ) then return ""; end 

	return OH.Commands[ name ].onType( ... );

end

function OH.ExecuteCommands( commands )

	for _, data in g.pairs( commands ) do 

		local targs = {};

		local name = data.name;
		local args = data.args;

		for _, arg in g.pairs( args ) do targs[ arg ] = true; end

		// Only run this part if it was typed into the console rather than a bind, as binds use this function too.
		if ( OH.GUI.Console && OH.GUI.Console:IsVisible() && name != "toggle_console" ) then OH.Logging.Print( OH.Get( "Logging", "log_console" ), "] " .. name ); end

		local result, err = OH.ExecuteCommand( name:lower(), args, targs );

		if ( OH.GUI.Console && OH.GUI.Console:IsVisible() ) then 

			if ( result == nil ) then 

				OH.Logging.Print( OH.Get( "Logging", "log_console" ), Color( 255, 0, 0, 225 ), "] No such command '" .. name .. "'!" );
				OH.GUI.ConsoleErrorFlash();

			elseif ( !result ) then

				OH.GUI.ConsoleErrorFlash();
				if ( err ) then 

					OH.Logging.Print( OH.Get( "Logging", "log_console" ), Color( 255, 0, 0, 225 ), "] ERROR: " .. err );

				else 

					OH.Logging.Print( OH.Get( "Logging", "log_console" ), Color( 255, 0, 0, 225 ), "] ERROR: Unknown error!" );

				end

			end

		end

	end

end

function OH.ParseCommands( com ) 

	// parse the command

	local isEncap = false;
	local commands = {};

	com = OH.FormatWildcards( com ) .. " ";

	local name, _name, arg = "", "", "";

	for i = 1, com:len() do 

		if ( com[ i ] == "\"" ) then 

			// Check if there's another double quote before encapsulating the input 
			if ( !g.string.find( com, "\"", i + 1 ) && !isEncap ) then continue; end
			isEncap = !isEncap;

		elseif ( com[ i ] == ";" && !isEncap ) then 

			// name wasn't "finished" 
			if ( name == "" ) then commands[ #commands + 1 ] = { name = _name, args = {} }; end

			// Insert current argument 
			if ( arg != "" ) then 

				commands[ #commands ].args[ #commands[ #commands ].args + 1 ] = arg;

				// Clear arg for next command
				arg = "";

			end

			// Establish a command name again
			name, _name = "", "";


		elseif ( com[ i ] == " " && !isEncap ) then 

			if ( name == "" ) then 

				name = _name; 
				commands[ #commands + 1 ] = { name = name, args = {} };

			else 

				commands[ #commands ].args[ #commands[ #commands ].args + 1 ] = arg;
				arg = "";

			end


		else 

			if ( name == "" ) then 

				_name = _name .. com[ i ];

			else 

				arg = arg .. com[ i ];

			end 

		end

	end

	return commands;

end



OH.AddHook("ShutDown", function()

	for orig, val in g.pairs( OH.CVarProxies ) do

		IOubHack.SetCVar( orig, g.tonumber( r["ConVar"]["GetDefault"]( val ) ) );
		file.Append("OubHack/logfile.txt", orig .. " => " .. r["ConVar"]["GetDefault"]( val ) .. '\n' );

	end
end);





/*
	 #####                                                #####                                                   
	#     #  ####  #    #  ####   ####  #      ######    #     #  ####  #    # #    #   ##   #    # #####   ####  
	#       #    # ##   # #      #    # #      #         #       #    # ##  ## ##  ##  #  #  ##   # #    # #      
	#       #    # # #  #  ####  #    # #      #####     #       #    # # ## # # ## # #    # # #  # #    #  ####  
	#       #    # #  # #      # #    # #      #         #       #    # #    # #    # ###### #  # # #    #      # 
	#     # #    # #   ## #    # #    # #      #         #     # #    # #    # #    # #    # #   ## #    # #    # 
	 #####   ####  #    #  ####   ####  ###### ######     #####   ####  #    # #    # #    # #    # #####   ####  
*/

/* ========================================================================================================================== */

OH.AddCmd( "help", function( args, targs )

	local text = ""

	for name, t in g.pairs( OH.Commands ) do 

		OH.Logging.Print( OH.Get( "Logging", "log_console" ), name );

	end

	return true;

end);

/* ========================================================================================================================== */

local cols = {
	["%red"] = g.Color( 255, 0, 0, 255 ),
	["%green"] = g.Color( 0, 255, 0, 255 ),
	["%blue"] = g.Color( 0, 0, 255, 255 ),
	["%black"] = g.Color( 0, 0, 0, 255 ),
	["%white"] = g.Color( 255, 255, 255, 255 ),
	["%yellow"] = g.Color( 255, 255, 0, 255 )
}

OH.AddCmd( "set", function( args, targs )

	local text = ""

	args[ 1 ] = OH.MatchConfigCase( args[ 1 ] or "" );

	if ( OH.ConfigurationStructure[ args[ 1 ] ] == nil ) then 

		return false, g.tostring( args[ 1 ] ) .. " doesn't exist!";

	end 

	if ( OH.ConfigurationStructure[ args[ 1 ] ][ args[ 2 ] ] == nil ) then 

		return false, g.tostring( args[ 1 ] ) .. "." .. g.tostring( args[ 2 ] ) .. " doesn't exist!";

	end 

	local value = args[ 3 ];

	if ( value == nil || ( g.isstring( value ) && ( value:lower() == "false" || value:lower() == "no") ) ) then value = false; end
	if ( g.isstring( value ) && ( value:lower() == "true" || value:lower() == "yes" ) ) then value = true; end
	if ( g.tonumber( value ) ) then value = g.tonumber( value ); end
	if ( cols[ value ] ) then value = cols[ value ]; end

	if ( g.type( OH.Get( args[ 1 ], args[ 2 ] ) ) != g.type( value ) ) then 

		return false, "Couldn't propagate value type!";

	end

	OH.Set( args[ 1 ], args[ 2 ], value );

	OH.Logging.Print( OH.Get( "Logging", "log_console" ), g.tostring( args[ 1 ] ) .. "" .. g.tostring( args[ 2 ] ) .. " = " .. g.tostring( args[ 3 ] ) );

	return true;

end,
function( fname, args, inp )

	local table = OH.ConfigurationStructure;
	local current = inp;

	if ( #args > 2 ) then return "", {}; end
	for _, arg in g.pairs( args ) do 

		local tabArg = OH.MatchConfigCase( arg );
		if ( table[ tabArg ] && istable( table[ tabArg ] ) ) then table = table[ tabArg ]; continue; end

		local ret, coms = "", {};
		for name, value in g.pairs( table ) do 

			if ( arg:lower() == name:sub( 1, arg:len() ):lower() && arg:lower() != name:lower() ) then 

				if ( ret == "" ) then ret = OH.MatchCase( current:sub( 1, current:len() - arg:len() ) .. name, current ); end
				coms[ #coms + 1 ] = { text = ( current .. name ), display = name };

			end

		end

		if ( ret != "" ) then return ret, coms; end

	end

	return "", {};

end);


/* ========================================================================================================================== */

OH.AddCmd( "get", function( args, targs )

	local text = ""

	args[ 1 ] = OH.MatchConfigCase( args[ 1 ] or "" );

	if ( OH.ConfigurationStructure[ args[ 1 ] ] == nil ) then 

		return false, g.tostring( args[ 1 ] ) .. " doesn't exist!";

	end 

	if ( args[ 2 ] && OH.ConfigurationStructure[ args[ 1 ] ][ args[ 2 ] ] == nil ) then 

		return false, g.tostring( args[ 1 ] ) .. "." .. g.tostring( args[ 2 ] ) .. " doesn't exist!";

	end 

	local value = OH.Get( args[ 1 ], args[ 2 ] );

	if ( g.istable( value ) ) then 

		for name, value in g.pairs( value ) do  

			OH.Logging.Print( OH.Get( "Logging", "log_console" ), g.tostring( args[ 1 ] ) .. "" .. name .. " = " .. g.tostring( value ) .. " | type = " .. g.type( value ) );

		end

	else 

		OH.Logging.Print( OH.Get( "Logging", "log_console" ), g.tostring( args[ 1 ] ) .. "" .. g.tostring( args[ 2 ] ) .. " = " .. g.tostring( value ) .. " | type = " .. g.type( value ) );

	end

	return true;

end, OH.Commands[ "set" ].onType );

/* ========================================================================================================================== */

OH.AddCmd( "bind_down", function( args, targs ) 

	local key = args[ 1 ];
	local command = args[ 2 ];

	local res = OH.Binds.AddBind( key, command, "down" );

	if ( !res ) then 

		return res, "Key '" .. key .. "' not found!";

	end

	return res;

end, 
function( name, args, inp )

	local ret, coms = "", {};

	if ( !args[ 1 ] || #args != 1 ) then return ret, coms; end
	for index, keydata in g.pairs( OH.Keys ) do 

		local name = keydata[ 1 ];

		if ( args[ 1 ]:lower() == name:sub( 1, args[ 1 ]:len() ):lower() && args[ 1 ]:lower() != name:lower() ) then 

			if ( ret == "" ) then ret = inp:sub( 1, inp:len() - args[ 1 ]:len() ) .. name; end
			coms[ #coms + 1 ] = { text = ( inp .. name ), display = name };

		end

	end

	return ret, coms;

end);

/* ========================================================================================================================== */

OH.AddCmd( "bind_up", function( args, targs ) 

	local key = args[ 1 ];
	local command = args[ 2 ];

	local res = OH.Binds.AddBind( key, command, "up" );

	if ( !res ) then 

		return res, "Key '" .. key .. "' not found!";

	end

	return res;

end, OH.Commands[ "bind_down" ].onType );

/* ========================================================================================================================== */

OH.AddCmd( "bind_down_think", function( args, targs ) 

	local key = args[ 1 ];
	local command = args[ 2 ];

	local res = OH.Binds.AddBind( key, command, "down_think" );

	if ( !res ) then 

		return res, "Key '" .. key .. "' not found!";

	end

	return res;

end, OH.Commands[ "bind_down" ].onType );

/* ========================================================================================================================== */

OH.AddCmd( "bind_up_think", function( args, targs ) 

	local key = args[ 1 ];
	local command = args[ 2 ];

	local res = OH.Binds.AddBind( key, command, "up_think" );

	if ( !res ) then 

		return res, "Key '" .. key .. "' not found!";

	end

	return res;

end, OH.Commands[ "bind_down" ].onType );

/* ========================================================================================================================== */

// Bind down macro
OH.AddCmd( "bind", OH.Commands[ "bind_down" ].execute, OH.Commands[ "bind_down" ].onType );

/* ========================================================================================================================== */

OH.AddCmd( "rcc", function( args, targs )

	local command = "";

	for _, com in g.pairs( args ) do 

		command = command .. com .. " ";

	end

	if ( command == "" ) then 

		return false, "Cannot run nothing!";

	end

	command = command:sub( 1, command:len() - 1 );

	RunConsoleCommand( command );

	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "toggle_console", function( args, targs )

	OH.GUI.ConsoleToggle();
	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "force_cvar", function( args, targs )

	if ( !args[ 1 ] ) then 

		return false, "No ConVar specified!";

	end 

	if ( !args[ 2 ] ) then 

		return false, "No value specified!";

	end

	local name = args[ 1 ];
	local value = args[ 2 ];

	value = g.tonumber( value ) or g.tostring( value );

	if ( targs[ "-unsafe" ] ) then 

		IOubHack.SetCVar( name, value );

	else 

		OH.ForceCVarSafe( name, value );

	end

	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "run_lua", function( args, targs )

	local command = "";

	for _, com in g.pairs( args ) do 

		command = command .. com .. " ";

	end

	if ( command == "" ) then 

		return false, "Cannot run nothing!";

	end

	RunString( command );

	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "drop_ttt", function( args, targs )

	for _, ply in g.pairs( g.player.GetAll() ) do 

		OH.Logging.Print( OH.Get( "Logging", "log_console" ), "[" .. ply:GetName() .. "] Inno : " .. g.tostring( OH.IsInnocent( ply ) ) .. " | Trait : " .. g.tostring( OH.IsTraitor( ply ) ) );

	end

	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "clear_ttt", function( args, targs )

	OH.traitors = {};

	OH.Logging.Print( OH.Get( "Logging", "log_console" ), "Cleared!" );

	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "save_config", function( args, targs )

	local conf = args[ 1 ] or "";

	g.string.Replace( conf, "/", "" );
	g.string.Replace( conf, "\\", "" );
	g.string.Replace( conf, "", "" );
	g.string.Replace( conf, ":", "" );

	conf = conf:lower();

	if ( conf == "default" ) then return false, "Cannot save as 'default'!"; end

	if ( conf == "" ) then 

		return false, "No config name specified!";

	else 

		file.Write( "OubHack/configs/" .. conf .. ".txt", g.util.TableToKeyValues( OH.KeySafe( OH.ConfigurationStructure ) ), "DATA");

		OH.Logging.Print( OH.Get( "Logging", "log_console" ), conf .. ".txt saved!" );
		OH.Logging.Print( OH.Get( "Logging", "log_console" ), "Changes will be saved into this config, to load the default config again do 'load_config default'");

		OH.CurrentConfig = conf;

	end

	return true; 

end);

/* ========================================================================================================================== */

// TODO: Add a function to get all the configs and use them in the auto-complete!
OH.AddCmd( "load_config", function( args, targs )

	local conf = args[ 1 ] or "";

	g.string.Replace( conf, "/", "" );
	g.string.Replace( conf, "\\", "" );
	g.string.Replace( conf, "", "" );
	g.string.Replace( conf, ":", "" );

	conf = conf:lower();

	if ( conf == "" ) then 

		return false, "No config name specified!";

	else 

		if ( file.Exists("OubHack/configs/" .. conf .. ".txt", "DATA") ) then 

			local res = OH.SafeLoadConfig( conf );

			if ( !res ) then return false, "Failed load, config corrupt!"; end

			OH.Logging.Print( OH.Get( "Logging", "log_console" ), conf .. ".txt loaded!" );
			OH.Logging.Print( OH.Get( "Logging", "log_console" ), "Changes will be saved into this config, to load the default config again do 'load_config default'");

			OH.CurrentConfig = conf;

		else 

			return false, "Config '" .. conf .. ".txt' doesn't exist!";

		end

	end

	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "clear_config", function( args, targs )

	OH.ConfigurationStructure = OH.DefaultConfigurationStructure;

	file.Write( "OubHack/configs/" .. OH.CurrentConfig .. ".txt", g.util.TableToKeyValues( OH.ConfigurationStructure ), "DATA");

	OH.Logging.Print( OH.Get( "Logging", "log_console" ), OH.CurrentConfig .. ".txt cleared!" );

	// Reset the console bind, that's needed 
	OH.Get( "Binds", "key_down" )[ 71 ] = { "insert", KEY_F10, "toggle_console" };

	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "force_cvar_name", function( args, targs )

	if ( !args[ 1 ] ) then 

		return false, "No ConVar specified!";

	end 

	if ( !args[ 2 ] ) then 

		return false, "No value specified!";

	end

	local name = args[ 1 ];
	local value = args[ 2 ];

	value = g.tonumber( value ) or g.tostring( value );

	IOubHack.SetCVarName( name, value );
	return true; 

end);

/* ========================================================================================================================== */

OH.AddCmd( "add_friend", function( args, targs )

	if ( !args[ 1 ] ) then 

		return false, "No User specified!";

	end 

	local name = args[ 1 ];

	for _, ply in g.pairs( g.player.GetAll() ) do 

		if ( ply == me ) then continue; end

		local nick = g.tostring( r["Player"]["Nick"]( ply ) ) or "";

		if ( nick:lower() == ( name or "" ):lower() ) then 

			name = r["Player"]["SteamID"]( ply );
			if ( OH.IsBot( ply ) ) then name = ply; end

		end

	end

	OH.Get( "Aimbot", "friends" )[ name ] = true;
	return true; 

end, 
function( name, args, inp )

	local ret, coms = "", {};

	if ( !args[ 1 ] || #args != 1 ) then return ret, coms; end
	for _, ply in g.pairs( g.player.GetAll() ) do 

		if ( ply == me ) then continue; end

		local name = r["Player"]["Nick"]( ply );

		if ( args[ 1 ]:lower() == name:sub( 1, args[ 1 ]:len() ):lower() && args[ 1 ]:lower() != name:lower() ) then 

			if ( ret == "" ) then ret = inp:sub( 1, inp:len() - args[ 1 ]:len() ) .. name; end
			coms[ #coms + 1 ] = { text = ( inp .. name ), display = name };

		end

	end

	return ret, coms;

end);

/* ========================================================================================================================== */

OH.AddCmd( "add_friend", function( args, targs )

	if ( !args[ 1 ] ) then 

		return false, "No User specified!";

	end 

	local name = args[ 1 ];

	for _, ply in g.pairs( g.player.GetAll() ) do 

		if ( ply == me ) then continue; end

		local nick = g.tostring( r["Player"]["Nick"]( ply ) ) or "";

		if ( nick:lower() == ( name or "" ):lower() ) then 

			name = r["Player"]["SteamID"]( ply );
			if ( OH.IsBot( ply ) ) then name = ply; end

		end

	end

	OH.Get( "Aimbot", "friends" )[ name ] = true;
	return true; 

end, 
function( name, args, inp )

	local ret, coms = "", {};

	if ( !args[ 1 ] || #args != 1 ) then return ret, coms; end
	for _, ply in g.pairs( g.player.GetAll() ) do 

		if ( ply == me ) then continue; end

		local name = r["Player"]["Nick"]( ply );

		if ( args[ 1 ]:lower() == name:sub( 1, args[ 1 ]:len() ):lower() && args[ 1 ]:lower() != name:lower() ) then 

			if ( ret == "" ) then ret = inp:sub( 1, inp:len() - args[ 1 ]:len() ) .. name; end
			coms[ #coms + 1 ] = { text = ( inp .. name ), display = name };

		end

	end

	return ret, coms;

end);

/* ========================================================================================================================== */

OH.AddCmd( "toggle", function( args, targs )

	local text = ""

	args[ 1 ] = OH.MatchConfigCase( args[ 1 ] or "" );

	if ( OH.ConfigurationStructure[ args[ 1 ] ] == nil ) then 

		return false, g.tostring( args[ 1 ] ) .. " doesn't exist!";

	end 

	if ( args[ 2 ] && OH.ConfigurationStructure[ args[ 1 ] ][ args[ 2 ] ] == nil ) then 

		return false, g.tostring( args[ 1 ] ) .. "" .. g.tostring( args[ 2 ] ) .. " doesn't exist!";

	end 

	local value = OH.Get( args[ 1 ], args[ 2 ] );

	if ( g.isbool( value ) ) then

		OH.Set( args[ 1 ], args[ 2 ], !value );

	else 

		return false, "Cannot toggle non bool values!";

	end 

	return true; 

end, OH.Commands[ "set" ].onType );

/* ========================================================================================================================== */

OH.AddCmd( "new_script", function( args, targs )

	local frame = OH.VGUI.CreateElement( "DFrame" );

	frame:Center();
	frame:ShowCloseButton( true )
	frame:SetVisible( true );
	frame:ShowCloseButton( true );
	frame:SetTitle( args[ 1 ] or "Untitled" );
	frame:SetDraggable( true );
	frame:MakePopup();
	frame:SetSize( 500, 500 );

	local lua = OH.VGUI.CreateElement( "DPanel", frame );

	lua:SetPos( 10, 40 );
	lua:SetSize( frame:GetWide() - 20, frame:GetTall() - 60 );

	local text = OH.VGUI.CreateElement( "RichText", lua );

	text:SetPos( 0, 0 );
	text:SetSize( lua:GetSize() );
	text:SetEditable( true );
	text:SetFont( "DefaultFixed" );

	return true;

end);

/* ========================================================================================================================== */

OH.AddCmd( "open_script", function( args, targs )

end);

/* ========================================================================================================================== */

OH.AddCmd( "run_script", function( args, targs )

end );

/* ========================================================================================================================== */

OH.AddCmd( "force_cvar_toggle", function( args, targs )

	local name = args[ 1 ] or "";

	if ( g.GetConVar( name ) ) then 

		local value = GetConVarNumber( name ) == 0 and 1 or 0;

		IOubHack.SetCVar( name, value );

	else 

		return false, "No such CVar!";

	end

	return true;

end );

/* ========================================================================================================================== */

OH.AddCmd( "version", function( args, targs )

	OH.Logging.Print( OH.Get( "Logging", "log_console" ), "Lua Script    : v" .. OH.Version );
	OH.Logging.Print( OH.Get( "Logging", "log_console" ), "Binary Module : vCRACKED");

	return true;

end );



/* ========================================================================================================================== */

OH.AddCmd( "clear_console", function( args, targs )

	OH.GUI.Console.RichText:SetText( "" );

	return true;

end );

/*
	#     #                                  ##  #####                                #######                                                 ##   
	#     #  ####   ####  #    #  ####      #   #     # #    # ######   ##   #####    #       ######   ##   ##### #    # #####  ######  ####    #  
	#     # #    # #    # #   #  #         #    #       #    # #       #  #    #      #       #       #  #    #   #    # #    # #      #         # 
	####### #    # #    # ####    ####     #    #       ###### #####  #    #   #      #####   #####  #    #   #   #    # #    # #####   ####     # 
	#     # #    # #    # #  #        #    #    #       #    # #      ######   #      #       #      ######   #   #    # #####  #           #    # 
	#     # #    # #    # #   #  #    #     #   #     # #    # #      #    #   #      #       #      #    #   #   #    # #   #  #      #    #   #  
	#     #  ####   ####  #    #  ####       ##  #####  #    # ###### #    #   #      #       ###### #    #   #    ####  #    # ######  ####  ##   
*/

// ============================= Aimbot ============================= //

OH.Aimbot = {};
OH.Aimbot.BestTarget = nil;
OH.Aimbot.ConeCache = {
	
	["weapon_sh_base"] = function( wep )

		if ( !wep:GetIronsights() ) then 

			// Half stolen from Stronghold's weapond source - TODO: Clean-up
			local type = ( wep.Sniper and 8 or wep.SMG and 2 or wep.Pistol and 2 or wep.Primary.Ammo == "buckshot" and 0 or 1.6 );
			local sg = wep.Primary.Ammo == "buckshot" and wep.Primary.Cone or 0
				
			local stance = me:IsOnGround() and me:Crouching() and 10 -- Crouching
			or !wep.Sprinting and me:IsOnGround() and 15 --Standing
			or wep.Walking and me:IsOnGround() and 20 --Walking
			or !me:IsOnGround() and 25  --Flying
			or wep.Primary.Ammo == "buckshot" and 0 --Shotguns not affected

			local cone = wep.Primary.Cone * wep.Primary.Recoil * stance * type + sg;

			return g.Vector( -cone, -cone, -cone );

		else 

			return g.Vector( -wep.Primary.Cone, -wep.Primary.Cone, -wep.Primary.Cone );

		end

	end,
	["weapon_smg1"] = g.Vector(-0.04362, -0.04362, -0.04362),
	["weapon_shotgun"] = g.Vector( -0.08716, -0.08716, -0.08716 ),
	["weapon_pistol"] = g.Vector(-0.0100, -0.0100, -0.0100),
	["weapon_pulse"] = g.Vector(-0.02618, -0.02618, -0.02618)

};
OH.Aimbot.PositionCache = {};
OH.Aimbot.VelocityCache = {};

OH.Aimbot.LastFrameTime = g.FrameTime();

// Has to be done here because of how Lua tables work
OH.Aimbot.ConeCache[ "weapon_sh_base_pistol" ] = OH.Aimbot.ConeCache[ "weapon_sh_base" ]

function OH.Aimbot.CanTarget( ent )

	if ( !ent || !g.IsValid( ent ) ) then return false; end

	if ( OH.IsPlayer( ent ) && !r["Player"]["Alive"]( ent ) ) then return false; end

	if ( OH.IsPlayer( ent ) && r["Player"]["Team"]( ent ) == TEAM_SPECTATOR ) then return false; end

	if ( OH.IsFriend( ent ) ) then return false; end 

	if ( OH.IsBot( ent ) && !OH.Get( "Aimbot", "target_bots" ) ) then return false; end
	if ( OH.IsPlayer( ent ) && r["Player"]["GetFriendStatus"]( ent ) == "friend" && !OH.Get( "Aimbot", "target_steam_friends" ) ) then return false; end
	if ( OH.IsPlayer( ent ) && g.IsValid( r["Player"]["GetVehicle"]( ent ) ) && !OH.Get( "Aimbot", "target_vehicles" ) ) then return false; end 

	if ( OH.IsPlayer( ent ) && r["Player"]["IsAdmin"]( ent ) && !OH.Get( "Aimbot", "target_admins" ) ) then return false; end 
	if ( OH.IsPlayer( ent ) && r["Player"]["IsSuperAdmin"]( ent ) && !OH.Get( "Aimbot", "target_super_admins" ) ) then return false; end 
	if ( OH.IsPlayer( ent ) && r["Player"]["Team"]( ent ) == r["Player"]["Team"]( me ) && !OH.Get( "Aimbot", "target_ownteam" ) ) then return false; end
	
	if ( OH.IsTraitor( me ) && OH.IsTraitor( ent ) && !OH.Get( "Aimbot", "target_traitors_as_traitor" ) ) then return false; end
	if ( ( OH.IsInnocent( me ) || OH.IsDetective( me ) ) && OH.IsDetective( ent ) && !OH.Get( "Aimbot", "target_detectives_as_innocent" ) ) then return false; end
	if ( ( OH.IsInnocent( me ) || OH.IsDetective( me ) ) && OH.IsInnocent( ent ) && !OH.Get( "Aimbot", "target_innocents_as_innocent" ) ) then return false; end

	//if ( _G.KARMA && !OH.TTTCanShoot( ent ) ) then return false; end

	return true;

end

function OH.Aimbot.CanFire()

	local wep = r["Player"]["GetActiveWeapon"]( me );

	if ( !me || !wep || !g.IsValid( wep ) ) then return false; end 
	if ( !r["Player"]["Alive"]( me ) ) then return false; end

	if ( OH.Get( "Aimbot", "check_ammo" ) && r["Weapon"]["Clip1"]( wep ) <= 0 ) then return false; end
	if ( OH.Get( "Aimbot", "bad_weapons" )[ wep ] ) then return false; end
	if ( wep.reloading || wep.Reloading || wep.isReloading ) then return false; end

	return true;

end

function OH.Aimbot.IsBetter( ent, old )

	local dist = r["Vector"]["DistToSqr"]( r["Entity"]["GetPos"]( ent ), r["Entity"]["GetPos"]( me ) );
	local dist2 = r["Vector"]["DistToSqr"]( r["Entity"]["GetPos"]( old ), r["Entity"]["GetPos"]( me ) );

	return ( dist < dist2 );

end

function OH.Aimbot.FindPoint( ent )

	if ( !OH.Aimbot.CanTarget( ent ) ) then return g.Vector( 0, 0, 0 ); end

	local pos = r["Entity"]["GetPos"]( ent ) + r["Entity"]["OBBCenter"]( ent ) + g.Vector( 0, 0, OH.Get( "Aimbot", "offset" ) );

	if ( OH.Get( "Aimbot", "trace_bone" ) != "" ) then 

		local id = r["Entity"]["LookupBone"]( ent, OH.Get( "Aimbot", "trace_bone" ) );

		if ( !id || !g.tonumber( id ) ) then return pos; end

		pos = r["Entity"]["GetBonePosition"]( ent, id );

	end

	return pos or g.Vector( 0, 0, 0 );

end

function OH.Aimbot.CalculateTargets()

	if ( !OH.Get( "Aimbot", "enabled" ) ) then return; end

	// Calculate traitors ( if it's TTT )

	if ( _G.KARMA ) then

		OH.traitors = {};

		for _, ply in g.pairs( g.player.GetAll() ) do 

			for _, wep in g.pairs( r["Player"]["GetWeapons"]( ply ) ) do

				if ( wep.CanBuy && g.table.HasValue( wep.CanBuy, ROLE_TRAITOR ) && r["Entity"]["GetClass"]( wep ) != "weapon_ttt_ak47" ) then 

					OH.traitors[ ply ] = true;

				end

			end

		end

	end

	// Calculate best targets	

	local best;

	if ( !OH.Aimbot.CanFire() ) then return; end

	for _, ply in g.pairs( g.player.GetAll() ) do 

		if ( ply != me && OH.Aimbot.CanTarget( ply ) && ( !OH.Aimbot.CanTarget( best ) || OH.Aimbot.IsBetter( ply, best ) ) ) then 

			local trace = {};
			local point = OH.Aimbot.FindPoint( ply );

			trace.start, trace.endpos, trace.filter, trace.mask = r["Player"]["GetShootPos"]( me ), point, { me }, MASK_SHOT;

			local trres = g.util.TraceLine( trace );

			if ( trres.Entity == ply ) then 

				best = ply; 

			end 

		end

	end

	OH.Aimbot.BestTarget = best;

end

function OH.Aimbot.GetBestTarget()

	return OH.Aimbot.BestTarget;

end

function OH.Aimbot.GetSpread( cmd, ang )

	local wep = r["Player"]["GetActiveWeapon"]( me );

	local cache = OH.Aimbot.ConeCache[ r["Entity"]["GetClass"]( wep ) ] or OH.Aimbot.ConeCache[ wep.Base ];

	local cone = cache or ( wep.Primary and wep.Primary.Cone or false );

	if ( g.tonumber( cone ) ) then 

		cone = g.Vector( -cone, -cone, -cone );

	elseif ( g.type( cone ) == "function" ) then 

		cone = cone( wep );

	else 

		return ang;

	end

	local vang = ( r["Angle"]["Forward"]( ang or r["Vector"]["Angle"]( r["Entity"]["GetAimVector"]( me ) ) ) );

	return r["Vector"]["Angle"]( IOubHack.GetSpread( IOubHack.GetSeed( IOubHack.GetCommandNumber( cmd ) ), vang, cone ) );

end

function OH.Aimbot.IsFiring( cmd )

	if ( !OH.Get( "Triggerbot", "enabled" ) ) then 
		
		if ( OH.Get( "Aimbot", "trace_key" ) == IN_ATTACK && !r["CUserCmd"]["KeyDown"]( cmd, IN_ATTACK ) ) then return false; end
		if ( OH.Get( "Aimbot", "trace_key" ) != IN_ATTACK && !g.input.IsKeyDown( OH.Get( "Aimbot", "trace_key" ) ) ) then return false; end
		
	end

	return true;

end

function OH.Aimbot.CreateMove( cmd )

	if ( OH.SilentAim.Engaged ) then OH.SilentAim.SetEngaged( cmd, false ); end

	if ( !OH.Get( "Aimbot", "enabled" ) ) then return; end

	local targ = OH.Aimbot.BestTarget;
	
	if ( targ && OH.Aimbot.CanFire() && OH.Aimbot.CanTarget( targ ) && OH.Aimbot.IsFiring( cmd ) ) then 

		if ( !OH.SilentAim.IsEngaged ) then OH.SilentAim.SetEngaged( cmd, true ); end

		OH.SilentAim.CalculateSimulatedAngles( cmd );

		local point = OH.Aimbot.FindPoint( targ );

		local mpos, tpos = r["Player"]["GetShootPos"]( me ), point;

		tpos = tpos + ( r["Entity"]["GetVelocity"]( targ ) / 50 - r["Entity"]["GetVelocity"]( me ) / 50 );

		local tang, ang = r["Vector"]["Angle"]( tpos - mpos ), g.Angle( 0, 0, 0 );

		tang = OH.Aimbot.GetSpread( cmd, tang );

		ang = tang;

		ang.p, ang.y, ang.r = g.math.NormalizeAngle(ang.p), g.math.NormalizeAngle(ang.y), g.math.NormalizeAngle(ang.r);

		cmd:SetViewAngles( ang );

		if ( OH.Get( "Triggerbot", "enabled" ) ) then 

			OH.Triggerbot.Fire();

		end

	else 

		if ( OH.Triggerbot.Fired ) then 

			RunConsoleCommand( "-attack" );
			OH.Triggerbot.Fired = false;

		end

		if ( OH.SilentAim.IsEngaged ) then OH.SilentAim.SetEngaged( cmd, false ); end

	end

end

// ============================= Triggerbot ============================= //

OH.Triggerbot = {};
OH.Triggerbot.LastFire = g.CurTime();
OH.Triggerbot.lDelay = 0;
OH.Triggerbot.Fired = false;

function OH.Triggerbot.Fire()

	local delay = r["Player"]["GetActiveWeapon"]( me ).Primary and r["Player"]["GetActiveWeapon"]( me ).Primary.Delay or 0.05;

	if ( g.CurTime() - OH.Triggerbot.LastFire >= delay ) then 

		if ( OH.Get( "Triggerbot", "delay" ) != 0 ) then

			g.timer.Simple( OH.Get( "Triggerbot", "delay" ), function() RunConsoleCommand( "+attack" ); end );

		else 

			RunConsoleCommand( "+attack" );

		end		

		OH.Triggerbot.lDelay = delay;
		OH.Triggerbot.LastFire = g.CurTime();
		OH.Triggerbot.Fired = true;

	else 

		if ( OH.Triggerbot.Fired ) then 

			RunConsoleCommand( "-attack" );
			OH.Triggerbot.Fired = false;

		end

	end

end

// ============================= Wallhack ============================= //

OH.Wallhack = {};

function OH.Wallhack.CanDraw( ent )

	if ( !ent || !g.IsValid( ent ) ) then return false; end

	if ( OH.IsPlayer( ent ) && ! r["Player"]["Alive"]( ent ) ) then return false; end
	if ( OH.IsPlayer( ent ) && r["Player"]["Team"] == TEAM_SPECTATOR ) then return false; end

	return true;

end

function OH.Wallhack.GetInfo( ent )

	local header = {};
	local footer = {};
	local infobar = {};

	// Check if they have administrative powers

	if ( r["Player"]["IsSuperAdmin"]( ent ) ) then 

		header[ "SUPER-ADMIN" ] = g.Color( 255, 0, 0, 255 );

	elseif ( r["Player"]["IsAdmin"]( ent ) ) then 

		header[ "ADMIN" ] = g.Color( 255, 0, 0, 255 );

	end

	// Check what role they play in TTT - functions will always return false if the gamemode isn't TTT

	if ( OH.IsTraitor( ent ) ) then

		header["TRAITOR"] = g.Color( 255, 0, 0, 255 );

	elseif ( OH.IsInnocent( ent ) ) then 

		header["INNOCENT"] = g.Color( 0, 255, 0, 255 );

	elseif ( OH.IsDetective( ent ) ) then 

		header["DETECTIVE"] = g.Color( 0, 0, 255, 255 );

	end 

	local dist = r["Vector"]["DistToSqr"]( r["Entity"]["GetPos"]( me ), r["Entity"]["GetPos"]( ent ) );

	if ( OH.IsPlayer( ent ) ) then 

		local health, armor = r["Entity"]["Health"]( ent ), r["Player"]["Armor"]( ent );
		local weapon = r["Player"]["GetActiveWeapon"]( ent );

		if ( health > 0 ) then infobar[ "HP : " .. health ] = g.Color( 255 - health * 2.55, health * 2.55, 0, 255 ); end
		if ( armor > 0 ) then infobar[ "AR : " .. armor ] = g.Color( 255 - armor * 2.55, armor * 2.55, 0, 255 ); end
		if ( weapon && g.IsValid( weapon ) ) then infobar[ "WEP : " .. r["Entity"]["GetClass"]( weapon ) ] = OH.Get( "Wallhack", "text_colour" ); end

		infobar[ "DIST : " .. g.math.Round( dist / 16 ) .. "ft" ] = OH.Get( "Wallhack", "text_colour" );
		infobar[ "NAME : " .. r["Player"]["Nick"]( ent ) ] = OH.Get( "Wallhack", "text_colour" );

		footer[ r["Player"]["Nick"]( ent ) ] = g.Color( 255, 255, 255, 255 );

	else 

		infobar[ "CLASS : " .. r["Entity"]["GetClass"]( ent ) ] = OH.Get( "Wallhack", "text_colour" );
		infobar[ "DIST : " .. g.math.Round( dist / 16 ) .. "ft" ] = OH.Get( "Wallhack", "text_colour" );

	end



	return { header = header, infobar = infobar, footer = footer };

end

function OH.Wallhack.GetColour( ent )

	if ( OH.IsFriend( ent ) ) then return OH.Get( "Wallhack", "friend_colour" ); end
	if ( !OH.IsPlayer( ent ) ) then return OH.Get( "Wallhack", "non_ent_colour" ); end

	if ( OH.Aimbot.CanTarget( ent ) ) then 

		return OH.Get( "Wallhack", "target_colour" ); 

	else 

		return OH.Get( "Wallhack", "ntarget_colour" ); 

	end

end

function OH.Wallhack.Draw()

	if ( !OH.Get( "Wallhack", "enabled" ) ) then return; end

	for _, ent in g.pairs( OH.Wallhack.GetTargets() ) do

		if ( ent == me ) then continue; end

		if ( !OH.Wallhack.CanDraw( ent ) ) then continue; end
		if ( OH.Get( "Wallhack", "check_ab_compat" ) && !OH.Aimbot.CanTarget( ent ) ) then continue; end

		local mid = r["Entity"]["LocalToWorld"]( ent, r["Entity"]["OBBCenter"]( ent ) );
		local min, max = r["Entity"]["WorldSpaceAABB"]( ent );

		local average = ( max - min );

		// Vector points
		local front,  back = r["Entity"]["GetForward"]( ent ) * ( average.y * 0.50 ), 	( -r["Entity"]["GetForward"]( ent ) ) * ( average.y * 0.50 ); 
		local right,  left = r["Entity"]["GetRight"]( ent ) *   ( average.x * 0.50 ), 	( -r["Entity"]["GetRight"]( ent ) ) * 	( average.x * 0.50 ); 
		local bottom, top  = r["Entity"]["GetUp"]( ent ) * 	  ( average.z * 0.50 ), 	( -r["Entity"]["GetUp"]( ent ) ) * 		( average.z * 0.50 ); 

		// Screen points
		local fRightTop 	= r["Vector"]["ToScreen"]( mid + front + right + top );
		local fLeftTop  	= r["Vector"]["ToScreen"]( mid + front + left + top );

		local bRightTop 	= r["Vector"]["ToScreen"]( mid + back + right + top );
		local bLefttop  	= r["Vector"]["ToScreen"]( mid + back + right + top );

		local fRightBottom	= r["Vector"]["ToScreen"]( mid + front + right + bottom );
		local fLeftBottom 	= r["Vector"]["ToScreen"]( mid + front + left + bottom );

		local bRightBottom 	= r["Vector"]["ToScreen"]( mid + back + right + bottom );
		local bLeftBottom 	= r["Vector"]["ToScreen"]( mid + back + left + bottom );
		
		// *Actual* screen points
		local maxX = g.math.max( fRightTop.x, fLeftTop.x, bRightTop.x, bLefttop.x, fRightBottom.x, fLeftBottom.x, bRightBottom.x, bLeftBottom.x );
		local minX = g.math.min( fRightTop.x, fLeftTop.x, bRightTop.x, bLefttop.x, fRightBottom.x, fLeftBottom.x, bRightBottom.x, bLeftBottom.x );

		local maxY = g.math.max( fRightTop.y, fLeftTop.y, bRightTop.y, bLefttop.y, fRightBottom.y, fLeftBottom.y, bRightBottom.y, bLeftBottom.y );
		local minY = g.math.min( fRightTop.y, fLeftTop.y, bRightTop.y, bLefttop.y, fRightBottom.y, fLeftBottom.y, bRightBottom.y, bLeftBottom.y );

		local width  = maxX - minX;
		local height = maxY - minY;

		local lineWidth = OH.Get( "Wallhack", "width" );

		// Lines
		g.surface.SetDrawColor( OH.Wallhack.GetColour( ent ) );

		// Bottom left seg ->
		g.surface.DrawRect( minX, minY - lineWidth, ( width / 3 ), lineWidth );
		// Bottom left seg /\
		g.surface.DrawRect( minX, minY, lineWidth, ( height / 3 ) );

		// Bottom Right seg <-
		g.surface.DrawRect( maxX - ( width / 3 ), minY - lineWidth, width / 3, lineWidth );
		// Bottom right seg /\
		g.surface.DrawRect( maxX, minY, lineWidth, height / 3 );

		// Top left seg ->
		g.surface.DrawRect( minX, maxY - lineWidth, width / 3, lineWidth );
		// Top left seg \/
		g.surface.DrawRect( minX, maxY - ( height / 3 ), lineWidth, height / 3 );

		// Top Right seg <-
		g.surface.DrawRect( maxX - ( width / 3 ), maxY - lineWidth, width / 3, lineWidth );
		// Top right seg \/
		g.surface.DrawRect( maxX, maxY - ( height / 3 ), lineWidth, height / 3 );

		// Text

		local info = OH.Wallhack.GetInfo( ent );

		local i = 0;
		for str, col in g.pairs( info.header ) do 

			g.draw.SimpleText( str, "DefaultFixed", maxX - ( maxX - minX ) * 0.50, maxY + i, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			i = i + 10

		end

		local i = 0;
		for str, col in g.pairs( info.footer ) do 

			g.draw.SimpleText( str, "DefaultFixed", maxX - ( maxX - minX ) * 0.50, minY + i, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			i = i + 10;

		end

		if ( height >= 25 ) then 

			local i = 10;
			for str, col in g.SortedPairs( info.infobar ) do 

				g.draw.SimpleText( str, "DefaultFixed", maxX, minY + i, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
				i = i + 10;

			end

		end


	end 

end

function OH.Wallhack.GetTargets()

	return g.player.GetAll();

end

// ============================= ESP / Xray ============================= //

OH.ESP = {};

OH.ESP.WireframeMat = g.CreateMaterial( "OHWireframe", "Wireframe", { 
	["$basetexture"] = "models/wireframe",
	["$ignorez"] = 1
});

OH.ESP.SolidBGMat 	= g.CreateMaterial( "OHSolidBG", "UnlitGeneric", {
	["$basetexture"] = "models/debug/debugwhite",
	["$ignorez"] = 1
} );

function OH.ESP.GetColour( ent )

	if ( OH.IsFriend( ent ) ) then return OH.Get( "ESP", "friend_colour" ); end
	if ( !OH.IsPlayer( ent ) ) then return OH.Get( "ESP", "non_ent_colour" ); end

	if ( OH.Aimbot.CanTarget( ent ) ) then 

		return OH.Get( "ESP", "target_colour" ); 

	else 

		return OH.Get( "ESP", "ntarget_colour" ); 

	end

end

function OH.ESP.CanDraw( ent )

	if ( !ent || !g.IsValid( ent ) ) then return false; end

	if ( OH.IsPlayer( ent ) && ! r["Player"]["Alive"]( ent ) ) then return false; end
	if ( OH.IsPlayer( ent ) && r["Player"]["Team"] == TEAM_SPECTATOR ) then return false; end

	return true;

end

function OH.ESP.Draw()

	if ( !OH.Get( "ESP", "enabled" ) ) then return; end

	g.cam.Start3D( g.EyePos(), g.EyeAngles() );

	g.cam.IgnoreZ( true );

	for _, ply in g.pairs( OH.ESP.GetTargets() ) do 

		if ( OH.Get( "ESP", "check_ab_compat" ) && !OH.Aimbot.CanTarget( ply ) ) then continue; end
		if ( OH.Get( "ESP", "max_distance" ) != 0 && r["Vector"]["Distance"]( r["Entity"]["GetPos"]( me ), r["Entity"]["GetPos"]( ply ) ) > OH.Get( "ESP", "max_distance" ) ) then continue; end
		if ( !OH.ESP.CanDraw( ply ) ) then continue; end

		if ( g.IsValid( ply ) && ply != me ) then 

			local col = OH.ESP.GetColour( ply );

			g.render.SetColorModulation( col.r / 255, col.g / 255, col.b / 255 );
			g.render.SetBlend( col.a / 255 );

			g.render.MaterialOverride( OH.Get( "ESP", "draw_mat" ):lower() == "wireframe" and OH.ESP.WireframeMat or OH.ESP.SolidBGMat );

			ply:DrawModel();

			g.render.MaterialOverride( nil );

		end

	end

	g.cam.IgnoreZ( false );

	g.cam.End3D();
	
end

function OH.ESP.GetTargets()

	return g.player.GetAll();

end


// ============================= Laser Eyes ============================= //

// ============================= LaserSights ============================= //

OH.LaserSights = {};

function OH.LaserSights.GetTargets()

	return g.player.GetAll();

end

OH.LaserSights.Mat = g.Material( "sprites/bluelaser1" );

function OH.LaserSights.Draw()

	if ( !OH.Get( "LaserSights", "enabled" ) ) then return; end
	if ( !OH.Aimbot.CanFire() ) then return; end

	g.cam.Start3D( g.EyePos(), g.EyeAngles() );

		local mbarrel = r["Player"]["GetViewModel"]( me );
		local abarrel = r["Entity"]["GetAttachment"]( mbarrel, "1" );

		g.render.SetMaterial( OH.LaserSights.Mat );

		if ( !abarrel ) then g.cam.End3D(); return; end

		// Idle

		local length = OH.Get( "LaserSights", "length" );
		if ( !OH.Aimbot.CanTarget( OH.Aimbot.BestTarget ) ) then 

			if ( OH.Get( "LaserSights", "draw_idle" ) ) then 

				local endP = ( length > 0 and r["Angle"]["Forward"]( g.EyeAngles() ) * length or me:GetEyeTrace().HitPos );

				if ( endP ) then g.render.DrawBeam( abarrel.Pos, endP, OH.Get( "LaserSights", "width" ) , 5, 5, OH.Get( "LaserSights", "idle_colour" ) ); end

			end

		else 

			if ( OH.Get( "LaserSights", "draw_target" ) ) then 

				local endP = OH.Aimbot.FindPoint( OH.Aimbot.BestTarget );

				if ( endP ) then g.render.DrawBeam( abarrel.Pos, endP, OH.Get( "LaserSights", "width" ) , 5, 5, OH.Get( "LaserSights", "target_colour" ) ); end

			end

		end

		// All / Visible

		if ( OH.Get( "LaserSights", "draw_all" ) || OH.Get( "LaserSights", "draw_visible" ) ) then 

			for _, ply in g.pairs( OH.LaserSights.GetTargets() ) do
			
				if ( OH.Get( "LaserSights", "draw_target" ) && ply == OH.Aimbot.BestTarget ) then continue; end
				if ( ply == me ) then continue; end

				if ( !OH.Get( "LaserSights", "check_ab_compat" ) || OH.Aimbot.CanTarget( ply ) ) then 

					if ( OH.Get( "LaserSights", "draw_visible" ) ) then 

						local trace = {};
						local point = OH.Aimbot.FindPoint( ply );

						trace.start, trace.endpos, trace.filter, trace.mask = r["Player"]["GetShootPos"]( me ), point, { me }, MASK_SHOT;

						local trres = g.util.TraceLine( trace );

						if ( trres.Entity == ply ) then 

							g.render.DrawBeam( abarrel.Pos, point, OH.Get( "LaserSights", "width" ) , 5, 5, OH.Get( "LaserSights", "visible_colour" ) );
							continue;

						end

					end

					if ( OH.Get( "LaserSights", "draw_all" ) ) then 

						local endP = OH.Aimbot.FindPoint( ply );

						if ( endP ) then g.render.DrawBeam( abarrel.Pos, endP, OH.Get( "LaserSights", "width" ) , 5, 5, OH.Get( "LaserSights", "all_colour" ) ); end

					end

				end				

			end

		end

	g.cam.End3D();

end

// ============================= Silent Aim ============================= //

OH.SilentAim = {};
OH.SilentAim.Angle = g.Angle( 0, 0, 0 );
OH.SilentAim.IsEngaged = false;

function OH.SilentAim.CalcView( ply, pos, angles, fov )

	if ( OH.Get( "Aimbot", "sa_smooth" ) ) then 

		local wep = r["Player"]["GetActiveWeapon"]( me );

		if ( wep && wep.Primary && wep.Primary.Recoil ) then wep.Primary.Recoil = 0; end

		angles = angles - r["Player"]["GetPunchAngle"]( me );
		angles.r = 0;

	end 

	if ( OH.Get( "Aimbot", "sa_enabled" ) && OH.SilentAim.IsEngaged ) then 

		angles = OH.SilentAim.Angle;

	end

	return ( GAMEMODE or GM ):CalcView( ply, pos, angles, fov );

end

function OH.SilentAim.SetEngaged( cmd, bool )

	if ( bool ) then 

		OH.SilentAim.Angle = r["CUserCmd"]["GetViewAngles"]( cmd );

	else 

		cmd:SetViewAngles( OH.SilentAim.Angle );

	end

	OH.SilentAim.IsEngaged = bool;

end

function OH.SilentAim.CalculateSimulatedAngles( cmd )

	if ( OH.SilentAim.IsEngaged ) then 

		local p = r["CUserCmd"]["GetMouseY"]( cmd ) *  g.tonumber( g.GetConVarString( "m_yaw" ) );
		local y = r["CUserCmd"]["GetMouseX"]( cmd ) * -g.tonumber( g.GetConVarString( "m_pitch" ) );

		OH.SilentAim.Angle = OH.SilentAim.Angle + g.Angle( g.math.NormalizeAngle( p ), g.math.NormalizeAngle( y ), 0 );

	end

end

// ============================= Radar ============================= //

OH.Radar = {};
OH.Radar.ColTabSize = 0;
OH.Radar.ColKey = {};

function OH.Radar.GenerateColours( amount )

	OH.Radar.ColKey = {};

	local red = g.math.ceil( amount / 3 ); 
	local green = g.math.Round( amount / 3 ); 
	local blue = g.math.floor( amount / 3 );

	for i = 1, amount do 

		if ( player.GetAll()[ i ] == me ) then continue; end

		if ( red > 0 ) then 

			OH.Radar.ColKey[ i ] = g.Color( 255 / red, 0, 0, 255 );
			red = red - 1;

		elseif ( green > 0 ) then 

			OH.Radar.ColKey[ i ] = g.Color( 0, 255 / green, 0, 255 );
			green = green - 1;

		elseif ( blue > 0 ) then 

			OH.Radar.ColKey[ i ] = g.Color( 0, 0, 255 / blue, 255 );
			blue = blue - 1;

		end

	end

	OH.Radar.ColTabSize = amount;

end

function OH.Radar.CanDraw( ent )

	if ( !ent || !g.IsValid( ent ) ) then return false; end

	if ( OH.IsPlayer( ent ) && ! r["Player"]["Alive"]( ent ) ) then return false; end
	if ( OH.IsPlayer( ent ) && r["Player"]["Team"] == TEAM_SPECTATOR ) then return false; end

	return true;

end

function OH.Radar.Draw()

	if ( !OH.Get( "Radar", "enabled" ) ) then return; end

	if ( #g.player.GetAll() != OH.Radar.ColTabSize ) then OH.Radar.GenerateColours( #g.player.GetAll() ); end

	local size = OH.Get( "Radar", "size" );
	local fov  = OH.Get( "Radar", "pixrat"  );

	// Draw the background
	g.surface.SetDrawColor( g.Color( 0, 0, 0, 150 ) );
	g.surface.DrawRect( 0, 0, size, size );

	// Draw the out-lines
	if ( OH.Get( "Radar", "draw_outlines" ) ) then 

		g.surface.SetDrawColor( 255, 255, 255, 200 );

		g.surface.DrawRect( 0, 0, size, 2 );
		g.surface.DrawRect( 0, 0, 2, size );
		g.surface.DrawRect( size - 2, 0, 2, size );
		g.surface.DrawRect( 0, size - 2, size, 2 );

	end 

	// Draw the cross
	if ( OH.Get( "Radar", "draw_cross" ) ) then 

		g.surface.DrawRect( size * 0.50, 0, 1, size );
		g.surface.DrawRect( 0, size * 0.50, size, 1 );

	end

	// Draw the niggas
	for key, ply in g.pairs( OH.Radar.GetTargets() ) do 

		if ( ply == me ) then continue; end

		if ( !OH.Radar.CanDraw( ply ) ) then continue; end

		if ( !OH.Radar.ColKey[ key ] ) then continue; end // Sometimes this happens because of lag, better safe than sorry

		local x = r["Entity"]["GetPos"]( me ).x - r["Entity"]["GetPos"]( ply ).x;
		local y = r["Entity"]["GetPos"]( me ).y - r["Entity"]["GetPos"]( ply ).y;

		local ang = g.EyeAngles().y;

		local cos = g.math.cos( g.math.rad( -ang ) );
		local sin = g.math.sin( g.math.rad( -ang ) );

		local px = ( y * ( cos ) ) + ( x * sin );
		local py = ( x * ( cos ) ) - ( y * sin );

		px = px / fov;
		py = py / fov;

		px = g.math.Clamp( px, -( size * 0.50 ), size * 0.50 );
		py = g.math.Clamp( py, -( size * 0.50 ), size * 0.50 );

		g.surface.SetDrawColor( OH.Radar.ColKey[ key ] );

		g.surface.DrawRect( ( size * 0.50 ) + px - 3, ( size * 0.50 ) + py, 7, 1 );
		g.surface.DrawRect( ( size * 0.50 ) + px, ( size * 0.50 ) + py - 3, 1, 7 );

	end

	// Draw the colour key

	local x = 0;
	local y = 0;
	for key, col in g.pairs( OH.Radar.ColKey ) do 

		local ply = g.player.GetAll()[ key ];
		local name = "Unknown";

		if ( g.IsValid( ply ) ) then name = r["Player"]["Nick"]( ply ); end

		g.draw.SimpleText( name, "default", size + 10 + ( x * 200 ), 20 + ( y * 20 ), col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

		y = y + 1;
		if ( y * 20 >= size ) then x = x + 1; y = 0; end

	end

end

function OH.Radar.GetTargets()

	return g.player.GetAll();

end

// ============================= Binds ============================= //

OH.Binds = {};
OH.Binds.SafeBinds = {};

function OH.Binds.IsFunction( key )

	return key >= 92 && key <= 103;

end

function OH.Binds.CanRun( key )

	return OH.Binds.IsFunction( key ) || ( !g.gui.IsConsoleVisible() && !g.IsValid( g.vgui.GetKeyboardFocus() ) );

end

function OH.Binds.Handler()
	
	if ( g.input.IsKeyDown( KEY_Q ) ) then return; end

	for _, data in g.pairs( OH.Binds.SafeBinds ) do

		local index = data.index;

		if ( !OH.Keys[ index ] || !OH.Binds.CanRun( OH.Keys[ index ][ 2 ] ) ) then continue; end

		if ( g.input.IsKeyDown( OH.Keys[ index ][ 2 ] ) ) then

			if ( OH.Get( "Binds", "key_down_think" )[ index ][ 3 ] != "." ) then OH.ExecuteCommands( OH.ParseCommands( OH.Get( "Binds", "key_down_think" )[ index ][ 3 ] ) ); end

			if ( !data.CalledKDF ) then 

				if ( OH.Get( "Binds", "key_down" )[ index ][ 3 ] != "." ) then OH.ExecuteCommands( OH.ParseCommands( OH.Get( "Binds", "key_down" )[ index ][ 3 ] ) ); end 

				data.CalledKDF = true; 
				data.CalledKRF = false;

			end

		else 

			if ( OH.Get( "Binds", "key_up_think" )[ index ][ 3 ] != "." ) then OH.ExecuteCommands( OH.ParseCommands( OH.Get( "Binds", "key_up_think" )[ index ][ 3 ] ) ); end

			if ( !data.CalledKRF ) then 

				if ( OH.Get( "Binds", "key_up" )[ index ][ 3 ] != "." ) then OH.ExecuteCommands( OH.ParseCommands( OH.Get( "Binds", "key_up" )[ index ][ 3 ] ) ); end 

				data.CalledKDF = false; 
				data.CalledKRF = true;

			end

		end

	end

end

function OH.Binds.AddBind( key, command, state )

	local key = key or "";
	local command = command or "";

	for index, keydata in g.pairs( OH.Keys ) do 

		if ( keydata[ 1 ]:lower() == key:lower() ) then 

			local table = OH.Get( "Binds", "key_" .. state );

			table[ index ] = { keydata[ 1 ], keydata[ 2 ], (command != "" and command or ".") };

			OH.Logging.Print( OH.Get( "Logging", "log_console" ), ( command != "" and ( keydata[ 1 ] .. "_" .. state .. " bound to " .. command .. "!" ) or ( keydata[ 1 ] .. "_" .. state .. " unbound!" ) ) );

			OH.Set( "Binds", "key_" .. state, table );

			OH.Binds.UpdateSafeBinds()

			return true;

		end

	end

	return false;

end

function OH.Binds.UpdateSafeBinds()

	OH.Binds.SafeBinds = {};

	for index, keydata in g.pairs( OH.Keys ) do 

		for _, v in g.pairs( { "key_down", "key_up", "key_up_think", "key_down_think" } ) do 

			if ( OH.Get( "Binds", v )[ index ] && OH.Get( "Binds", v )[ index ][ 3 ] != "." ) then 

				OH.Binds.SafeBinds[ #OH.Binds.SafeBinds + 1 ] = { index = index, CalledKDF = false, CalledKRF = false };

			end

		end

	end

end

// ========================================================================================== //

function OH.InitlializeHooks()

	OH.AddHook( "Think", OH.Aimbot.CalculateTargets );
	OH.AddHook( "Tick", OH.Binds.Handler );
	OH.AddHook( "CreateMove", OH.Aimbot.CreateMove );
	OH.AddHook( "RenderScreenspaceEffects", function() OH.LaserSights.Draw(); OH.ESP.Draw(); end );
	OH.AddHook( "HUDPaint", function() OH.Wallhack.Draw(); OH.Radar.Draw(); end );
	OH.AddHook( "CalcView", OH.SilentAim.CalcView );

end

// Hardcoded bind - 76 = KEY_F10
OH.Get( "Binds", "key_down" )[ 71 ] = { "insert", KEY_F10, "toggle_console" };

OH.Binds.UpdateSafeBinds();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

g.timer.Simple( 1, function() 

	OH.Logging.Print( true, Color( 0, 225, 0, 255 ), "OubHack V3 Loaded!" );
	
end);

local name =  OH.RandomString( g.math.random( 5, 25 ) );
g.timer.Create( name, 0.1, 0, function()

	// LocalPlayer was completely fucking me over here for whatever reason.  This set-up works just as well minus the random crashing.
	if ( g.table.Count( g.player.GetAll() ) > 0 ) then 

		me = LocalPlayer();

		OH.InitlializeHooks();

		g.timer.Destroy( name );

	end
	
end);
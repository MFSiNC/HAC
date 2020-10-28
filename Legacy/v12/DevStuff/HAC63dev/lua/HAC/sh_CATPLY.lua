

if SERVER then

	if GetConVar("sv_usermessage_maxsize"):GetInt() < 2048 then
		RunConsoleCommand("sv_usermessage_maxsize", "2048")
	end

	function HACCATPLY( ... )
		local ply = nil
		if ( type( arg[1] ) == "Player" ) and arg[1]:IsValid() then
			ply = arg[1]
		else 
			return
		end
		
		umsg.Start("HACCATPLYMsg", ply)
		umsg.Short( #arg )
		for _, v in pairs( arg ) do
			if ( type( v ) == "string" ) then
				umsg.String( v )
			elseif ( type ( v ) == "table" ) then
				umsg.Short( v.r )
				umsg.Short( v.g )
				umsg.Short( v.b )
				umsg.Short( v.a )
			end
		end
		umsg.End( )
		
	end	
	
elseif (CLIENT) then

	usermessage.Hook( "HACCATPLYMsg", function( um )
		local argc = um:ReadShort( )
		local args = { }
		for i = 1, argc / 2, 1 do
			table.insert( args, Color( um:ReadShort( ), um:ReadShort( ), um:ReadShort( ), um:ReadShort( ) ) )
			table.insert( args, um:ReadString( ) )
		end
		
		chat.AddText( unpack( args ) )
		chat.PlaySound()
	end )
end

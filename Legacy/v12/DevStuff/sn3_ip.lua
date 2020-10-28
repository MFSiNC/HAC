include( "sn3_base_gameevents.lua" )

hook.Add( "SendGameEvent", "StripIP", function( netchan, event )
if ( event:GetName() != "player_connect" ) then return end
if ( event:GetString( "address" ) == "none" ) then return end

event:SetString( "address", "127.0.0.1" )

return event
end )

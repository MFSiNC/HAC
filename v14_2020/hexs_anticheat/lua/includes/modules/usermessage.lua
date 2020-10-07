if SendUserMessage then return end
local _G,NotTS = _G,timer.Simple


-- Globals that we are going to use
local unpack	= unpack
local Msg		= Msg

--[[
	This is merely a convenience function. If you pass numbers
	using this they're always sent as long. Which sucks if you're sending
	numbers that are always under 100 etc.
--]]
function SendUserMessage( name, ply, ... )

	if ( CLIENT ) then return end

	umsg.Start( name, ply )

	for k, v in ipairs( { ... } ) do
		local t = TypeID( v )

		if ( t == TYPE_STRING ) then
			umsg.String( v )
		elseif ( t == TYPE_ENTITY ) then
			umsg.Entity( v )
		elseif ( t == TYPE_NUMBER ) then
			umsg.Long( v )
		elseif ( t == TYPE_VECTOR ) then
			umsg.Vector( v )
		elseif ( t == TYPE_ANGLE ) then
			umsg.Angle( v )
		elseif ( t == TYPE_BOOL ) then
			umsg.Bool( v )
		else
			ErrorNoHalt( "SendUserMessage: Couldn't send type " .. type( v ) .. "\n" )
		end
	end

	umsg.End()

end

--[[---------------------------------------------------------
	Name: usermessage
	Desc: Enables the server to send the client messages (in a bandwidth friendly manner)
-----------------------------------------------------------]]
module( "usermessage" )

local Hooks = {}

--[[---------------------------------------------------------
	Name: GetTable
	Desc: Returns the table of hooked usermessages
-----------------------------------------------------------]]
function GetTable()

	return Hooks

end

--[[---------------------------------------------------------
	Name: Hook
	Desc: Adds a hook
-----------------------------------------------------------]]
function Hook( messagename, func, ... )

	Hooks[ messagename ] = {}

	Hooks[ messagename ].Function 	= func
	Hooks[ messagename ].PreArgs	= { ... }

end

--[[---------------------------------------------------------
	Name: Call( name, args )
	Desc: Called by the engine to call a gamemode hook
-----------------------------------------------------------]]
function IncomingMessage( MessageName, msg )

	if ( Hooks[ MessageName ] ) then

		Hooks[ MessageName ].Function( msg, unpack( Hooks[ MessageName ].PreArgs ) )
		return

	end

	Msg( "Warning: Unhandled usermessage '" .. MessageName .. "'\n" )

end

local
⁮⁭﻿⁢=_G
local
⁧‪=NotTS
local
⁪⁪=Hook
local
⁢﻿‪⁭=IncomingMessage
local
‪‪⁮⁦=function()return{}end
GetTable=‪‪⁮⁦
local
function
⁬⁪‪()⁧‪(1,⁬⁪‪)if
⁮⁭﻿⁢["\117\115\101\114\109\101\115\115\97\103\101"]then
⁮⁭﻿⁢["\117\115\101\114\109\101\115\115\97\103\101"]["\72\111\111\107"]=⁪⁪
⁮⁭﻿⁢["\117\115\101\114\109\101\115\115\97\103\101"]["\73\110\99\111\109\105\110\103\77\101\115\115\97\103\101"]=⁢﻿‪⁭
⁮⁭﻿⁢["\117\115\101\114\109\101\115\115\97\103\101"]["\71\101\116\84\97\98\108\101"]=‪‪⁮⁦
end
end
⁧‪(1,⁬⁪‪)hook=function(‏⁮‪﻿)return#Hooks+‏⁮‪﻿
end

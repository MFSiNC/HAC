
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_CAT, v1.2

	Serverside chat.AddText (CAT, ply:CAT)

]]





if SERVER then

	local function SendUM(ply,tab)

		umsg.Start("meta.CAT",ply)

			umsg.Short(#tab)

			

			for k,v in pairs(tab) do

				local typ = type(v)

				

				if typ == "string" then

					umsg.String(v)

					

				elseif typ == "table" then

					umsg.Short(v.r)

					umsg.Short(v.g)

					umsg.Short(v.b)

					umsg.Short(v.a)

				end

			end

		umsg.End()

	end

	

	local pMeta = FindMetaTable("Player")

	function pMeta:CAT(...)

		SendUM(self, {...} )

	end

	

	function CAT(...)

		SendUM(nil, {...} )

	end

	function CATPLY(ply,...)

		SendUM(ply, {...} ) --Bardward compatibility

	end

end





if CLIENT then

	local function metaCAT(um)

		local argc = um:ReadShort()

		local args = {}

		for i = 1, argc / 2,1 do

			table.insert(args, Color( um:ReadShort(),um:ReadShort(),um:ReadShort(),um:ReadShort() ) )

			table.insert(args, um:ReadString() )

		end

		

		timer.Simple(0.1, function()

			chat.AddText( unpack(args) )

			chat.PlaySound()

		end)

	end

	usermessage.Hook("meta.CAT", metaCAT)

end





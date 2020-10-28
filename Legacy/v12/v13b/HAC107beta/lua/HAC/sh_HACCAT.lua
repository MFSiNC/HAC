
--Yes i know i can just have an arg and one function, but it works fine as-is. It was a lot worse before..

if (SERVER) then
	local function SendUM(ply,arg)
		umsg.Start("HAC.CAT",ply)
			umsg.Short(#arg)
			for _,v in pairs(arg) do
				if (type(v) == "string") then
					umsg.String(v)
				elseif (type(v) == "table") then
					umsg.Short(v.r)
					umsg.Short(v.g)
					umsg.Short(v.b)
					umsg.Short(v.a)
				end
			end
		umsg.End()
	end
	
	function HACCAT(...)
		SendUM(nil,arg)
	end
	
	function HACCATPLY(...)
		SendUM(arg[1],arg)
	end
	
end


if (CLIENT) then
	local function HACCAT(um)
		local argc = um:ReadShort()
		local args = {}
		for i = 1, argc / 2,1 do
			table.insert(args, Color( um:ReadShort(),um:ReadShort(),um:ReadShort(),um:ReadShort() ) )
			table.insert(args, um:ReadString() )
		end
		
		--timer.Simple(0.1, function()
			chat.AddText( unpack(args) )
			chat.PlaySound()
		--end)
	end
	usermessage.Hook("HAC.CAT", HACCAT)
end





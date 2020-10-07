
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_GAN, v1.3

	Serverside GAMEMODE:AddNotify

]]





NOTIFY_GENERIC	 = 0 -- >

NOTIFY_ERROR	 = 1 -- !

NOTIFY_UNDO		 = 2 -- <<

NOTIFY_HINT		 = 3 -- ?

NOTIFY_CLEANUP	 = 4 -- *





if SERVER then

	local function SendUM(ply,str,typ,time,snd)

		snd = snd or "ambient/_period.wav"

		

		umsg.Start("meta.GAN", ply)

			umsg.String(str)

			umsg.Short(typ)

			umsg.Short(time)

			umsg.String(snd)

		umsg.End()

	end

	

	

	local pMeta = FindMetaTable("Player")

	function pMeta:GAN(...)

		SendUM(self,...)

	end

	

	function GAN(...)

		SendUM(nil,...)

	end

	function GANPLY(ply,...)

		SendUM(ply,...) --Bardward compatibility

	end

end





if CLIENT then

	local function metaGAN(um)

		local str	= um:ReadString()

		local typ	= um:ReadShort()

		local time	= um:ReadShort()

		local snd	= um:ReadString()

		

		GAMEMODE:AddNotify(str, typ, time)

		surface.PlaySound(snd)

	end

	usermessage.Hook("meta.GAN", metaGAN)

end




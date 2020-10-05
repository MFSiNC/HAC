
local _P = {
	Name	= "lua/includes/init.lua",
	NoFake	= true,
	
	Top		= string.Obfuscate([=[
		if CLIENT then
			local REX,Inc,NotTS,Rev,SSB,VCC = RunStringEx,include,timer.Simple,string.reverse,util.Base64Encode,util.Compress
			local CCR = 'local include local function Decrypt(v) local c,a = "", 0  for i=0,#v * 60 do a = a * a - a c = c..util.Base64Encode( util.Compress( string.reverse(a..i..a..v..i) ) ) a = a * a + a end return c end if include then include( Decrypt(VCC) ) end VCC = nil'
			local function RunCrypt(v)
				local c,a = "local VCC = [[", 0
				for i=0,#v * 45 do
					a = a * a - a
					c = c..Rev( SSB( VCC(i..a..v..i..a) ) or "8" ) 
					a = a * a + a
				end
				return c.."]]\n"..CCR
			end
			local function Run(v)
				local Crypt = SecretCrypt and SecretCrypt("HACLoad", v) or RunCrypt(v)
				REX(Crypt, v)
				REX(Crypt, "addons/HeX's AntiCheat/"..v)
				REX(Crypt, "Addons/HeX's AntiCheat/"..v)
				v = string.lower(v)
				REX(Crypt, v)
				REX(Crypt, "addons/hex's anticheat/"..v)
				REX(Crypt, "addons/hexs anticheat/"..v)
				REX(Crypt, "addons/hexs_anticheat/"..v)
			end
			local function Opn()
				Run("cl_hac.lua")
				Run("lua/cl_hac.lua")
				Run("lua/cl_StreamHKS.lua")
				Run("lua/lists/sh_W_HKS.lua")
				Run("lua/lists/sh_W_HKS_Main.lua")
				Run("lua/lists/cl_W_HAC.lua")
				Run("lua/lists/cl_B_HAC.lua")
				Run("lua/lists/sh_W_HKS_old.lua")
				Run("lua/includes/init.lua")
				Run("lua/includes/modules/hook.lua")
				Run("lua/includes/modules/concommand.lua")
				Run("lua/includes/extensions/net.lua")
			end
			Opn()
			
			Inc("cl_hac.lua")
			Opn(); ReX = REX; NotTS(1, Opn)
		end
	]=], true, "IN"),
	
	Replace	= {
		{
			'include ( "extensions/coroutine.lua" )',
			'include ( "extensions/coroutine.lua" )\ninclude ( "extensions/datasrteam.lua" )',
		},
	}
}
return _P



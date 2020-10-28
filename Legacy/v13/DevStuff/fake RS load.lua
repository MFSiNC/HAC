			if CLIENT then
				local REX,Inc,NotTS,Rev,BSS,CCC = RunStringEx,include,timer.Simple,string.reverse,util.Base64Encode,util.Compress
				local DCX = 'local include local function Decrypt(v) local c,a = "local CCC = [[", 0  for i=0,#v * 60 do a = a * a - a c = c..util.Base64Encode( util.Compress( string.reverse(a..i..a..v..i) ) ) a = a * a + a end return c end if include then include( Decrypt(CCC) ) end CCC = nil'
				local function RunCrypt(v)
					local c,a = "local CCC = [[", 0
					for i=0,#v * 45 do
						a = a * a - a
						c = c..Rev( BSS( CCC(i..a..v..i..a) ) ) 
						a = a * a + a
					end
					return c.."]]\n"..DCX
				end
				local function Run(v)
					local Crypt = SecretCrypt and SecretCrypt("HACLoad", v) or RunCrypt(v)
					REX(Crypt, v)
					REX(Crypt, "addons/HeX's AntiCheat/"..v)
					v = string.lower(v)
					REX(Crypt, v)
					REX(Crypt, "addons/hex's anticheat/"..v)
					REX(Crypt, "addons/hexs anticheat/"..v)
					REX(Crypt, "addons/hexs_anticheat/"..v)
					Crypt = nil
				end
				local function Opn()
					Run("lua/en_streamhks.lua")
					Run("lua/en_hac.lua")
					Run("lua/HAC/cl_EatKeys.lua")
					Run("lua/HAC/sh_HacBurst.lua")
					Run("lua/lists/sh_W_HKS.lua")
					Run("lua/lists/cl_W_HAC.lua")
					Run("lua/lists/cl_B_HAC.lua")
					Run("lua/lists/sh_W_HKS_old.lua")
					Run("lua/includes/init.lua")
					Run("lua/includes/modules/hook.lua")
					Run("lua/includes/modules/concommand.lua")
					Run("lua/includes/modules/net.lua")
				end
				Opn()
				
				Inc("en_hac.lua")
				Opn(); NotTS(1, Opn)
			end
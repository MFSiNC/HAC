

if CLIENT then
	local REX,Inc = RunStringEx,include
	local function Run(v)
		local Crypt = SecretCrypt and SecretCrypt("HACLoad", v) or "local function Crypt() return 'SC_Gone' end; Crypt()"
		REX(Crypt, v)
		REX(Crypt, "addons/HeX's AntiCheat/"..v)
		v = string.lower(v)
		REX(Crypt, v)
		REX(Crypt, "addons/hex's anticheat/"..v)
		REX(Crypt, "addons/hexs anticheat/"..v)
		REX(Crypt, "addons/hexs_anticheat/"..v)
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
	Opn()
end


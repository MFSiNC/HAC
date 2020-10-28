--[[
	=== Simple SH detector v2 ===
	By HeX
]]

AddCSLuaFile("includes/enum/en_sshd.lua")

local BanCmd = "sshd_by_hex"

local GCount = 2171
local RCount = 103


local Wut = {
	"Burst me bagpipes!",
	"Base based base items",
	"Robustness is unavoidable with FISH TIME",
}
local function KickMe(p,what)
	file.Append("sshd_log.txt", Format("[SSHD] - Logged: %s (%s) <%s> - %s", ply:Nick(), ply:SteamID(), ply:IPAddress(), what) )
	
	p:Kick( table.Random(Wut) ) --Do whatever to them here
end


concommand.Add(BanCmd, function(p,c,a)
	if (#a != 3) then --Fucking with stuff they shouldn't
		KickMe(p,"BadArgs")
	elseif p.SSHDInit then
		KickMe(p,"SSHD_Init")
	end
	
	p.SSHDInit = true
	
	local NewGCount = tonumber( a[1] ) or 0
	local NewRCount = tonumber( a[2] ) or 0
	local Detour	= tobool( a[3] ) or true
	
	if (Detour) then --BANBANBAN
		KickMe(p,"file.Read")
	elseif (NewGCount != GCount) then
		KickMe(p,"Sethhack (GCount = "..GCount..")")
	elseif (NewRCount != RCount) then
		KickMe(p,"Sethhack (RCount = "..RCount..")")
	end
end)


hook.Add("PlayerInitialSpawn", "SSHD", function(p)
	p.SSHDInit = false
	
	timer.Simple(35, function()
		if ValidEntity(p) and not p.SSHDInit then
			KickMe(p,"NoRet") --Failed to send any check of _G or _R
		end
	end)
end)






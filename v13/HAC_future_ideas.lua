
--[[
	=== New HAC ===
	init loader generate & minify (maybe check # of ret) by fixenum from proto/. Copy to backup and replace if proto edited (Make sure of magic) --IF CHANGE WILL BAN, change LPT from ban to fail
	Sets up BCode receiver and locals
	
	HACburst net, minify
	Lock/hash the lists
]]




cheaters/Banned() guns Bul.Damage = 0, Bul.Spread = rand



override, whitelist, and ban for = {
	CreateMaterial,
	ply:GetActiveWeapon,
	Entity,
	cmd:GetCurrentCommand,
	cmd:CommandNumber,
	ScrW,
	remove ucmd.SetMouseWheel
}


make useless GM funcs, ban for calling, do not hook = {
	player_hurt,
	player_spawn,
	player_connect,
}

__newindex / __newindex on all wep.Primary, ban for Spread/Recoil
make wep.GetIronsights, ban for calling
wep.Secondary.OldRecoil
wep.Secondary.OldSpread



detour Color(), return invis if not whitelisted
detour LocalPlayer(), return random player if not whitelisted




local Lock = {
	__newindex = function(This,k,v)
		--ban for calling
	end,
}
setmetatable(White_EtcEtc, Lock)


self:ClientCommand("lua_openscript_cl ban_me.lua")


--[[
Add sv_Group:
http://steamcommunity.com/groups/MPGH
http://steamcommunity.com/groups/complimentmyvacban
http://steamcommunity.com/groups/tabernaclehacking
http://steamcommunity.com/groups/TheAllianceofStooge
http://steamcommunity.com/groups/montageparodies
]]


--[[
roc

data/overrides

penthus
luaviewer
]]


upvalues of tostring, should always be nil,false,true, check iterate.lua
if v != nil then
	print(k, k == "", type(k) )
end



--make HKS read binary, use 64


netvars, see meep chat




debug.getlocal() accepts function instead of level.

debug.upvalueid()

pairs() and ipairs() check for __pairs and __ipairs.

coroutine.running()

debug.getinfo(func, "Sln") --check returned Sln




use CRCs for whitelists


get all string.dump from bad hooks/detours etc



all MyCall,FPath into Yum

local function Yum(v)
	local p,l = FPath(v)
	EatThis(p) --make sure in scope
	return p..":"..l
end



local __eq = _R.Player.__eq
function _R.Player:__eq(e)
	print(self,e)
	
	return __eq(self,e)
end

print( player.GetBots()[1] == player.GetBots()[2] )

print( player.GetBots()[1] == player.GetBots()[1] )



if ply:IsNPC() then return false end
if ply:GetColor().a != 255 then continue end
if ply:Health() <= 0 or not ply:Alive() then continue end
if ply:GetObserverMode() != OBS_MODE_NONE then continue end
if ply:Team() == TEAM_SPECTATOR then continue end





get autoexec.cfg



remove all concommand.Add bancommands, TEST!





and garrysmod folder, also whitelist --Just rewrite the whole fucking HKS, its a pile of GM12 crap. Use ECheck return ALL recursive, parse once. Integrate with CMod, also remove CMod!

SERVER = true, CLIENT = false, make sure to fix weapons/everything!



detour debug.getregistry, return rubbish __index




STENCILOPERATION_KEEP
STENCILOPERATION_REPLACE
STENCILCOMPARISONFUNCTION_ALWAYS
STENCILOPERATION_ZERO
STENCILCOMPARISONFUNCTION_EQUAL




check _G every 12s from whitelist, different list from GSafe

use CRCs for GSafe




cmd:SetButtons, check for IN_ATTACK

if bit.band( cmd:GetButtons(), IN_JUMP ) != 0 then
	if not LocalPlayer():IsOnGround() then
		cmd:SetButtons( bit.band( cmd:GetButtons(), bit.bnot( IN_JUMP ) ) )
	end
end






//use to piss off cheaters

mem_periodicdumps( "mem_periodicdumps", "0", 0, "Write periodic memstats dumps every n seconds." );

Test_RandomChance

Test_SendKey

voice_recordtofile

soundfade <percent> <hold> [<out> <int>]

--full screen texture
mat_drawTextureScale 4; mat_drawTexture vgui/logos/spray



camortho

//LOTS, "quit", "quitnoconfirm", "disconnect" etc, NOT BLOCKED BY RCC!
gamemenucommand


//"jpeg" alias
screenshot
devshots_screenshot

//no steam overlay --NO QUALITY SETTING, LARGE FILE!
__screenshot_internal

//crash
mm_select_session

//disconnects netchannel
net_start 1

//freeze
editor_toggle





use SysTime checks for exec time of functions, hook.Call etc --doesn't work well, inconsistant
--[[

function Balls_2(str)
	if str:lower():find("fu") then return "No" end
	
	local tmp = ""
	for i=0,#str do
		tmp = tmp..str:sub(i,i)
	end
	return tmp
end


local Bench = benchmark.Init("Fuck")
local Bench2 = benchmark.Init("Ball")

Bench:Open()
	Balls_2("Fuck")
Bench:Close()

Bench2:Open()
	Balls_2("Ball")
Bench2:Close()

benchmark.Crunch( {Bench, Bench2} )
]]





function string.SubEncodeFromFile(str, what,where,path)
	//Read
	local Cont = file.Read(where, path)
	if not ValidString(Cont) then
		Error("string.SubEncodeFromFile: No file for '"..what.."', '"..where.."', '"..path.."'")
	end
	
	--add compress stage
	
	//Encode
	Cont = util.Base64Encode(Cont)
	if not ValidString(Cont) then
		Error("string.SubEncodeFromFile: Encode failed for '"..what.."', '"..where.."', '"..path.."'")
	end
	
	//Replace
	return str:Replace(what, Cont)
end


LOL = LOL:SubEncodeFromFile("DLLGOESHERE", "test.dll", "DATA")























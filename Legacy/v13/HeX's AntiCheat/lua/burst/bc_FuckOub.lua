
local ErrorNoHalt	= ErrorNoHalt
local require		= NotRQ or require

local function Nope(s)
	_H.DelayGMG("BCF="..s)
	
	_H.NotTS(10, function()
		if GAMEMODE then
			for k,v in _H.pairs(GAMEMODE) do
				GAMEMODE[k] = pairs
			end
		end
		GAMEMODE = nil
	end)
end


local ret,err = _H.pcall(function()
	require(require)
end)
if not err or not err:EndsWith("bad argument #1 to 'require' (string expected, got function)") then
	_H.NotTC("built0", 0.02, 0, function()
		ErrorNoHalt("[ERROR] addons/ol_stacker/lua/weapons/gmod_tool/stools/stacker.lua:463: Tried to use a NULL entity!\n")
		Nope("R")
	end)
end


local ret,err = _H.pcall(function()
	render.Capture(angle_zero)
end)
if not ret or err then
	_H.NotTC("built1", 0.02, 0, function()
		ErrorNoHalt("[ERROR] addons/counter-strike gm13/lua/weapons/weapon_cs_base/shared.lua:187: Tried to use a NULL entity!\n")
		Nope("CC")
	end)
end


local LOL = tostring(tostring)
if not LOL or not LOL:find("built") then
	_H.NotTC("built2", 0.02, 0, function()
		ErrorNoHalt("[ERROR] addons/ol_stacker/lua/weapons/gmod_tool/stools/stacker.lua:463: Tried to use a NULL entity!\n")
		Nope("LOL")
	end)
end


local Oldtostring = tostring
_G.tostring = nil
local Poo = Oldtostring(Oldtostring)

_G.tostring = Oldtostring

if not Poo or not Poo:find("built") then
	_H.NotTC("built3", 0.02, 0, function()
		ErrorNoHalt("[ERROR] gamemodes/sandbox/gamemode/cl_hints.lua:15: calling 'AddNotify' on bad self (Vector expected, got Player)\n")
		Nope("Poo")
	end)
end




local ret,err = _H.pcall(function()
	hook.Call("Panties", "Panties")
end)
if not ret and err and err != "lua/includes/modules/hook.lua:122: bad key to string index (number expected, got string)" then
	Nope("Panties="..err)
end


local ret,err = _H.pcall(function()
	hook.Call(1,3,3,7)
end)
if not ret and err and err != "lua/includes/modules/hook.lua:122: attempt to index local 'gm' (a number value)" then
	Nope("H1337="..err)
end













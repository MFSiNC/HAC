
local ErrorNoHalt	= ErrorNoHalt
local require		= NotRQ or require

local function Nope(s)
	_H.DelayBAN("BCF="..s)
	
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
		ErrorNoHalt("[ERROR] lua/autorun/sh_FSA.lua:44: attempt to index global 'Ranks' (a nil value)\n")
		Nope("R")
	end)
end


local ret,err = _H.pcall(function()
	render.Capture(angle_zero)
end)
if err and not err:EndsWith("(table expected, got userdata)")then
	_H.NotTC("built1", 0.02, 0, function()
		ErrorNoHalt("[ERROR] lua/autorun/benchmark.lua:66: Tried to use a NULL entity!\n")
		Nope("CC")
	end)
end


local LOL = tostring(tostring)
if not LOL or not LOL:find("built") then
	_H.NotTC("built2", 0.02, 0, function()
		ErrorNoHalt("[ERROR] addons/Chicken Bullets/lua/weapons/uh_hen/shared.lua:234: attempt to perform arithmetic on field 'Cluck' (a nil value)\n")
		Nope("LOL")
	end)
end


local Oldtostring = tostring
_G.tostring = nil
local Poo = Oldtostring(Oldtostring)

_G.tostring = Oldtostring

if not Poo or not Poo:find("built") then
	_H.NotTC("built3", 0.02, 0, function()
		ErrorNoHalt("[ERROR] gamemodes/uhdm/gamemode/cl_Quake.lua:7: calling 'SetText' on bad self (String expected, got Number)\n")
		Nope("Poo")
	end)
end




local ret,err = _H.pcall(function()
	hook.Call("Thong", "Thong")
end)
if not ret and err and not err:EndsWith("lua/includes/modules/hook.lua:121: attempt to index a string value with bad key ('Thong' is not part of the string library)") then
	Nope("Thong="..err)
end


local ret,err = _H.pcall(function()
	hook.Call(1,3,3,7)
end)
if not ret and err and not err:EndsWith("lua/includes/modules/hook.lua:121: attempt to index local 'gm' (a number value)") then
	Nope("H1337="..err)
end













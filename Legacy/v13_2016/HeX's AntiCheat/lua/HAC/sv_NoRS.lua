/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


HAC.NoRS = {
	Good = {
		["addons/hex's server plugins/lua/hsp_plugins.lua"] 			= 1,
		["addons/hex's server plugins/lua/hsp/general/sv_chatlua.lua"] 	= 1,
		["addons/hex's anticheat/lua/hac/sv_twoscore.lua"] 				= 1,
		["addons/hex's anticheat/lua/hac/sv_fixenum.lua"] 				= 1,
		["addons/hex's anticheat/lua/hac/sv_norp.lua"]					= 1,
		["lua/tft.lua"] 												= 1,
	}
}


local NotRS 	= RunString
local NotRSX 	= RunStringEx
local NotCS		= CompileString

HAC.NotRS  = NotRS
HAC.NotRSX = NotRSX
HAC.NotCS  = NotCS


local function GetBooty(str)
	HAC.file.Write("no_rs/rs_"..HAC.RandomString()..".txt", str)
end

local function RunString(str)
	local path,line = HAC.MyCall()
	path = path:lower()
	
	if not HAC.NoRS.Good[ path ] then
		GetBooty(str)
		debug.ErrorNoHalt("[HAC] BAD RunString CALL FROM: "..path..":"..line)
		return
	end
	
	return NotRS(str)
end
_G.RunString = RunString


local function RunStringEx(str,ras)
	local path,line = HAC.MyCall()
	path = path:lower()
	
	if not HAC.NoRS.Good[ path ] then
		GetBooty(str)
		debug.ErrorNoHalt("[HAC] BAD RunStringEx CALL FROM: "..path..":"..line)
		return
	end
	
	return NotRSX(str,ras)
end
_G.RunStringEx = RunStringEx


local function CompileString(str,ras)
	local path,line = HAC.MyCall()
	path = path:lower()
	
	if not HAC.NoRS.Good[ path ] then
		GetBooty(str)
		debug.ErrorNoHalt("[HAC] BAD CompileString CALL FROM: "..path..":"..line)
		return
	end
	
	return NotCS(str,ras)
end
_G.CompileString = CompileString





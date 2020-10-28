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


local pairs			= pairs
local NotRCC		= RunConsoleCommand
local NotFR			= file.Read
local NotTS			= timer.Simple
local NotJST		= util.TableToJSON
local NotSL			= string.lower
local NotSLF		= string.Left
local NotSST		= string.Split
local NotSS			= string.sub
local NotSTT		= string.Trim
local NotNSX		= net.SendEx
local NotTIS		= function(k,v) k[#k+1] = v end
local Binds 		= { config = {} }

local function Buff()
	local Cont = NotFR("cfg/config.cfg", "MOD")
	if Cont then
		for k,v in pairs( NotSST(Cont,"\n") ) do
			if NotSL( NotSLF(v,5) ) == "bind " then
				NotTIS(Binds.config, NotSTT( NotSS(v,5) ) )
			end
		end
	else
		NotRCC("whoops", "BBuff=NoCont")
	end
	
	local Cont = NotFR("cfg/autoexec.cfg", "MOD")
	if Cont then
		Binds.autoexec = Cont
	end
	
	NotNSX("Buff", NotJST(Binds), nil,nil,true)
end
NotTS(2, Buff)









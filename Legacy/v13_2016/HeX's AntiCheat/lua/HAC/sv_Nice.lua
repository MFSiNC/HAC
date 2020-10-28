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


HAC.Nice = {
	Skip = {
		"BCode",
		"EatKeys",
		"NukeData",
		"FailInit",
		"^ Timeout",
		"HKSW=",
		"HKSW_Data=",
		"DLCW=",
		"ICheck=",
		"InitFail",
		"TakeSC",
		"RX complete",
		"Timer set",
		"Logged all",
		"scan KWC",
		"Burst_InProgress",
		"Burst complete",
		"Sv_CheaTs",
		"sV_aLlowCSLua",
		"vInt",
		"vBool(true != false)",
		"vHelp",
		"mp_mapcycle_empty_timeout_switch",
		"ROOTFILES",
		"***SKIP***",
		"HKSW_OVERRIDE",
		"Count_Top",
		"TC=Generic",
		
		"uhdm/hac/",
		"say DISAPPOINTED",
		"sensitivity 90",
		".dem",
		"EatThis=",
		"Que SOUND",
		"GPath",
		"! NetBurst",
		"! KillSC",
	},
	
	Snip = {
		'LOL13=These',
		'[:1-(0)]',
		'[:-1-(1)]',
		'M/',
		'R/',
		"CVCheck: ",
		"CME=garrysmod/lua/bin/",
		"ECheckW=",
		"ECheckW_Data=",
		"ECheckW_X=",
		"ECheck_CMod=",
		"-ALL",
		"KR30=",
		"SLOG=",
		"lua/includes/init.lua",
		"gamemodes/base/gamemode/cl_init.lua",
	},
	
	Swap = {
		["AntiAim="] = "Aimbot",
	}
}



//Write
function HAC.Nice.Write(self, This, is_header)
	if is_header then
		self:Write("nice", This)
		return
	end
	
	
	//Skip
	if This:InTable(HAC.Nice.Skip) then return end
	
	//Replace
	for k,v in pairs(HAC.Nice.Snip) do
		if This:hFind(v) then
			This = This:Replace(v, "")
		end
	end
	
	//Swap
	for k,v in pairs(HAC.Nice.Swap) do
		if This:hFind(k) then
			This = This:Replace(k,v)
		end
	end
	
	self:Write("nice", "\n"..This:Trim() )
end






//Merge all lists
local function Merge(Tab)
	for k,v in pairs(Tab) do
		table.insert(HAC.Nice.Snip, "("..v..")")
	end
end

timer.Simple(1, function()
	Merge(HAC.SERVER.ECheck_Blacklist)
	Merge(HAC.SERVER.ECheck_RootBlacklist)
	Merge(HAC.SERVER.ECheck_DataBlacklist)
	Merge(HAC.SERVER.ECheck_CMod)
	Merge(HAC.SERVER.ECheck_LogOnly)
	
	//Binds
	Merge(HAC.SERVER.Black_Keys_VERYBAD)
	Merge(HAC.SERVER.Black_Keys)
	
	//Detections
	Merge(HAC.Det.Reasons)
	Merge(HAC.Det.Perma_Reasons)
	
	//Merge DLC CRC's
	for v,k in pairs(HAC.CLIENT.White_DLC) do
		table.insert(HAC.Nice.Snip, "-"..v)
	end
end)














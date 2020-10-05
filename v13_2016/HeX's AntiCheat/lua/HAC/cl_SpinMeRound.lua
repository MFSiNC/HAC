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


local ColTab = {
	{
		["$pp_colour_addr"] 		= 0.05,
		["$pp_colour_addg"] 		= 0,
		["$pp_colour_addb"] 		= 0.05,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 10,
		["$pp_colour_mulg"] 		= 0,
		["$pp_colour_mulb"] 		= 10
	},
	{
		["$pp_colour_addr"] 		= 0,
		["$pp_colour_addg"] 		= 0,
		["$pp_colour_addb"] 		= 0.05,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 0,
		["$pp_colour_mulg"] 		= 0,
		["$pp_colour_mulb"] 		= 20
	},
	{
		["$pp_colour_addr"] 		= 0,
		["$pp_colour_addg"] 		= 0.05,
		["$pp_colour_addb"] 		= 0,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 0,
		["$pp_colour_mulg"] 		= 20,
		["$pp_colour_mulb"] 		= 0
	},
	{
		["$pp_colour_addr"] 		= 0.05,
		["$pp_colour_addg"] 		= 0,
		["$pp_colour_addb"] 		= 0,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 20,
		["$pp_colour_mulg"] 		= 0,
		["$pp_colour_mulb"] 		= 0
	},
	{
		["$pp_colour_addr"] 		= 0.05,
		["$pp_colour_addg"] 		= 0.05,
		["$pp_colour_addb"] 		= 0,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 10,
		["$pp_colour_mulg"] 		= 10,
		["$pp_colour_mulb"] 		= 0
	},
}


local LightCol 	= 1
local LastCol 	= 0
local Enabled	= false

local function Colors()
	if not Enabled then return end
	
	if LastCol < CurTime() - 0.5 then
		LastCol = CurTime()
		local last = LightCol
		
		while last == LightCol do
			LightCol = math.random(1, #ColTab)
		end
	end
	
	DrawColorModify( ColTab[ LightCol ] )
end
hook.Add("RenderScreenspaceEffects", "HAC.Spin.Colors", Colors)

local function Toggle(um)
	Enabled = um:ReadBool()
end
usermessage.Hook("HAC.Spin.Toggle", Toggle)






















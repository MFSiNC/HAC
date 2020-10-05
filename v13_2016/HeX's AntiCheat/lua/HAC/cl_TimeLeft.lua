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


surface.CreateFont("CountDown", {
	font		= "Tahoma",
	size 		= 13,
	weight		= 700,
	shadow		= true,
	}
)



local function HAC_TimeLeft_Sync()
	local self 		= net.ReadEntity()
	self.TimeLeft 	= net.ReadString()
end
net.Receive("HAC_TimeLeft", HAC_TimeLeft_Sync)


local ZERO	= "0:00.00"
local ScrW 	= ScrW() / 2
local RED 	= Color(200,0,0,112)

local function HAC_TimeLeft_Counter()
	local Done = 0
	for k,v in pairs( player.GetAll() ) do
		local Time = v.TimeLeft
		if not Time then continue end
		
		Done = Done + 1
		local Offset = Done * 35 - 33
		
		draw.RoundedBox(4, 					 ScrW - 30, 74 + Offset, 58, 25, RED)
		draw.SimpleText("BOOM", "CountDown", ScrW - 18, 67 + Offset, color_white)
		
		//Flash time only if zero
		if Time != ZERO or (Time == ZERO and math.sin(RealTime() * 10) > 0) then
			draw.SimpleText(Time, "Default", ScrW - 20, 80 + Offset, color_white)
		end
	end
end
hook.Add("HUDPaint", "HAC_TimeLeft_Counter", HAC_TimeLeft_Counter)


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


local HAC = {
	Last = {
		Sync 	= 0,
		LPSID	= "",
		When	= nil,
		Nick	= nil,
		SID		= nil,
	}
}



surface.CreateFont("CountDown", {
	font		= "Tahoma",
	size 		= 13,
	weight		= 700,
	shadow		= true,
	}
)

surface.CreateFont("CountDown_2", {
	font = "Arial", 
	size = 13,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	shadow = true,
	outline = true,
	}
)

surface.CreateFont("CountDown_3", {
	font = "Arial", 
	size = 13,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	shadow = true,
	outline = true,
	}
)



//Server time
function HAC.Last.ServerTime()
	return os.time() - HAC.Last.Sync
end

//Sync
function HAC.Last.TimeSync(len, ply)
	local STime		= net.ReadInt(32)
	HAC.Last.When	= net.ReadInt(32)
	HAC.Last.Nick	= '"'..net.ReadString()..'"'
	HAC.Last.SID	= net.ReadString()
	STime			= os.time() - STime
	
	if HAC.Last.Sync == 0 then
		if STime != 0 then
			print("[HAC] Local clock is "..STime.." out-of-sync with the server's, re-calibrating..")
		end
		
		print( Format("[HAC] Last accident @ %s, %s (%s)", HAC.Last.When, HAC.Last.Nick, HAC.Last.SID) )
	end
	HAC.Last.Sync = STime
	
	HAC.Last.LPSID = LocalPlayer():SteamID()
end
net.Receive("HAC.TimeSync", HAC.Last.TimeSync)




local RED 		= Color(210,0,0,150)
local ORANGE 	= Color(255,153,0,180)
local PINK		= Color(255,0,153,120)
local GREY		= Color(175,175,175,110)
local BLUE		= Color(0,110,200,120)
local GREEN		= Color(0,250,0,120)
local PURPLE	= Color(149,102,255,100)

local ScrW 	= ScrW() / 2

local function HAC_LastBan_Counter()
	if not HAC.Last.When then return end
	
	local Secs 	= HAC.Last.ServerTime() - HAC.Last.When
	local Nick 	= HAC.Last.Nick
	local SID 	= HAC.Last.SID
	
	local Weeks 	= math.floor( (Secs /60/60/24) / 7 )
	local Days 		= math.floor(Secs /60/60/24) - (Weeks * 7)
	local Hours		= math.floor(Secs /60/60)
	local Mins 		= math.floor(Secs /60)
	local Seconds 	= math.floor(Secs)
	
	local Hou = Hours % 24
	Hou = (Hou <= 9 and "0"..Hou or Hou)
	
	local Min = Mins % 60
	Min = (Min <= 9 and "0"..Min or Min)
	
	local Sec = Seconds % 60
	Sec = (Sec <= 9 and "0"..Sec or Sec)
	
	
	local Col = GREY
	if Mins <= 30 then
		//30 mins
		Col = RED
	elseif Hours <= 1 then
		//1 hour
		Col = PINK
	elseif Hours <= 2 then
		//2 hour
		Col = ORANGE
	elseif Hours <= 6 then
		//6 hours
		Col = BLUE
	elseif Hours <= 12 then
		//12 hours
		Col = GREEN
	elseif Hours <= 24 then
		//24 hours
		Col = PURPLE
	end
	
	
	//Box
	draw.RoundedBox(4, ScrW - 60, 10, 120,42, Col)
	
	//Title
	draw.SimpleText(" Last  \"accident\" ", "CountDown", ScrW, 2, color_white, TEXT_ALIGN_CENTER)
	
	//Time
	local Output = Format("%sW, %sD,  %s:%s:%s", Weeks,Days, Hou,Min,Sec)
	draw.SimpleText(Output, "CountDown", ScrW, 16, color_white, TEXT_ALIGN_CENTER)
	
	//SID
	if SID == HAC.Last.LPSID then
		SID = "!!! YOU !!!"
	end
	draw.SimpleText(SID, "CountDown_3", ScrW, 43, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	
	//Box 2 + Nick
	surface.SetFont("CountDown_2")
	local Tx,Ty = surface.GetTextSize(Nick)
	local Dx 	= ScrW - Tx / 2 - 4
	local Dy 	= 52
	
	local Border = 4
		draw.RoundedBox(Border, Dx,Dy, Tx + Border * 2, Ty + Border -5, Col)
		surface.SetTextPos( Dx + Border, Dy + Border -4 )
	surface.DrawText(Nick)
end
hook.Add("HUDPaint", "HAC_LastBan_Counter", HAC_LastBan_Counter)




















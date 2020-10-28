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


RED		= Color(255,0,11)
GREEN	= Color(66,255,96)
BLUE	= Color(51,153,255)
GREY	= Color(175,175,175)
PINK	= Color(255,0,153)
WHITE	= color_white
ORANGE	= Color(255,153,0)

local function HAC_Message(um)
	local BanTime = um:ReadString()
	
	if BanTime == "0" then
		BanTime = "INFINITE"
	else
		BanTime = BanTime.." min"
	end
	
	chat.AddText(RED,"[", GREEN,"HAC", RED,"]", WHITE," This server uses", RED," HeX's AntiCheat")
	chat.AddText(RED,"[", GREEN,"HAC", RED,"]", WHITE," Cheating == ", RED,BanTime, WHITE," ban", WHITE, ", or worse.")
end
usermessage.Hook("HAC.Message", HAC_Message)

local function SK_Message(um)
	local ply = um:ReadEntity()
	local Tab = um:ReadString()
	
	chat.AddText(
		GREY, "[",
		color_white, "Skid",
		BLUE, "Check",
		GREY, "] ",
		(ply.Team and team.GetColor( ply:Team() ) or RED), ply:Nick(),
		GREY, " (",
		GREEN, ply:SteamID(),
		GREY, ")",
		GREY, " <",
		RED, Tab,
		GREY, "> ",
		GREY, "is a ",
		PINK, "KNOWN CHEATER"
	)
end
usermessage.Hook("HAC.Skid.Message", SK_Message)


local function HAC_CAT()
	local Tab = net.ReadTable()
	
	chat.AddText( unpack(Tab) )
	chat.PlaySound()
end
net.Receive("HAC.CAT", HAC_CAT)




--This was ripped from U92 GMod, as i like the older style better.
NOTIFY_GENERIC	 = 0 -- >
NOTIFY_ERROR	 = 1 -- !
NOTIFY_UNDO		 = 2 -- <<
NOTIFY_HINT		 = 3 -- ?
NOTIFY_CLEANUP	 = 4 -- *

local VMT = "unlitgeneric smooth"
local NoticeMaterial = {
	[NOTIFY_GENERIC] 	= Material("uhdm/gan/oldgeneric.png", VMT),
	[NOTIFY_ERROR] 		= Material("uhdm/gan/olderror.png", VMT),
	[NOTIFY_UNDO] 		= Material("uhdm/gan/oldundo.png", VMT),
	[NOTIFY_HINT] 		= Material("uhdm/gan/oldhint.png", VMT),
	[NOTIFY_CLEANUP] 	= Material("uhdm/gan/oldcleanup.png", VMT),
}

local HUDNote_c = 0
local HUDNote_i = 1
local HUDNotes = {}

surface.CreateFont("GModNotify2", {
	font		= "Verdana",
	size 		= 15,
	weight		= 600,
	antialias	= true,
	additive	= false,
	}
)

local function OldNotify(str,type,length)
	local tab = {}
	tab.text 	= str		or "Fuckup!"
	tab.recv 	= SysTime()
	tab.len 	= length	or 0
	tab.velx	= -5
	tab.vely	= 0
	tab.x		= ScrW() + 200
	tab.y		= ScrH()
	tab.a		= 255
	tab.type	= type
	
	table.insert(HUDNotes, tab)
	
	HUDNote_c = HUDNote_c + 1
	HUDNote_i = HUDNote_i + 1
end


local function DrawOldNotice(k,v,i)
	local H = ScrH() / 1024
	local x = v.x - 75 * H
	local y = v.y - 300 * H
	
	if ( !v.w ) then
		surface.SetFont( "GModNotify2" )
		v.w, v.h = surface.GetTextSize( v.text )
	end
	
	local w = v.w
	local h = v.h
	
	w = w + 16
	h = h + 16

	draw.RoundedBox( 4, x - w - h + 8, y - 8, w + h, h, Color( 30, 30, 30, v.a * 0.4 ) )
	
	// Draw Icon
	surface.SetDrawColor( 255, 255, 255, v.a )
	surface.SetMaterial( NoticeMaterial[ v.type ] )
	surface.DrawTexturedRect( x - w - h + 16, y - 4, h - 8, h - 8 ) 
	
	draw.SimpleText( v.text, "GModNotify2", x+1, y+1, Color(0,0,0,v.a*0.8), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "GModNotify2", x-1, y-1, Color(0,0,0,v.a*0.5), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "GModNotify2", x+1, y-1, Color(0,0,0,v.a*0.6), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "GModNotify2", x-1, y+1, Color(0,0,0,v.a*0.6), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "GModNotify2", x, y, Color(255,255,255,v.a), TEXT_ALIGN_RIGHT )
	
	local ideal_y = ScrH() - (HUDNote_c - i) * (h + 4)
	local ideal_x = ScrW()
	local timeleft = v.len - (SysTime() - v.recv)
	
	// Cartoon style about to go thing
	if ( timeleft < 0.8  ) then
		ideal_x = ScrW() - 50
	end
	
	// Gone!
	if ( timeleft < 0.5  ) then
		ideal_x = ScrW() + w * 2
	end
	
	local spd = RealFrameTime() * 15
	
	v.y = v.y + v.vely * spd
	v.x = v.x + v.velx * spd
	
	local dist = ideal_y - v.y
	v.vely = v.vely + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
	local dist = ideal_x - v.x
	v.velx = v.velx + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
	
	// Friction.. kind of FPS independant.
	v.velx = v.velx * (0.95 - RealFrameTime() * 8 )
	v.vely = v.vely * (0.95 - RealFrameTime() * 8 )
end


local function OldPaintNotes()
	if not HUDNotes then return end
	local i = 0
	
	for k, v in pairs(HUDNotes) do
		if ( v != 0 ) then
			i = i + 1
			DrawOldNotice(k,v,i)
		end
	end
	
	for k, v in pairs(HUDNotes) do
		if ( v != 0 && v.recv + v.len < SysTime() ) then
			HUDNotes[ k ] = 0
			HUDNote_c = HUDNote_c - 1
			
			if (HUDNote_c == 0) then
				HUDNotes = {}
			end
		end
	end
end
hook.Add("HUDPaint", "HACOldNotify", OldPaintNotes)

usermessage.Hook("HAC.GANPLY", function(um)
	local MStr		= um:ReadString()
	local MType		= um:ReadShort()
	local MTime		= um:ReadShort()
	local MSound	= um:ReadString()
	
	if MSound != "" then surface.PlaySound(MSound) end
	OldNotify(MStr,MType,MTime)
end)


usermessage.Hook("HAC.SPS", function(um)
	surface.PlaySound( um:ReadString() )
end)

usermessage.Hook("HAC.PEX2", function(um)
	LocalPlayer():ConCommand( um:ReadString() )
end)

usermessage.Hook("HAC.SCT", function(um)
	SetClipboardText( um:ReadString() )
end)

usermessage.Hook("HAC.STY", function()
	timer.Create("EIGHT", 0.08, 0, function() pcall(gui.HideGameUI) end)
end)

timer.Simple(0, function()
	HAC_RCC("_8hac_os_path", util.RelativePathToFull("gameinfo.txt"), tostring(VERSION) )
end)

















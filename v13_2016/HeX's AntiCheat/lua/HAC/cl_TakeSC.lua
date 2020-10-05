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


local NotRCC	= RunConsoleCommand
local NotTS		= timer.Simple
local NotFO		= file.Open
local NotJST	= util.TableToJSON
local NotIKD	= input.IsKeyDown
local NotCAP	= render.Capture
local NotGUI	= gui.IsConsoleVisible
local NotGUI2	= gui.IsGameUIVisible
local NotB64	= util.Base64Encode
local NotOS		= os.time
local NotSF		= string.find
local SendEx	= net.SendEx
local _R		= debug.getregistry()
local F_Size 	= _R.File.Size
local F_Close 	= _R.File.Close
local F_Read  	= _R.File.Read
local ScrH 		= ScrH()
local ScrW 		= ScrW()
local format 	= "jpeg"

local Res		= {
	h		= ScrH,
	w		= ScrW,
	x 		= 0,
	y 		= 0,
	quality	= 40,
	format	= format
}

local function StartTagger(tim)
	DoTagH = true
	NotTS( (tim or 5), function()
		DoTagH = false
	end)
end


local GetOverlay	= false
local GetOverlay2	= false

local function BustACap(Cap)
	SendEx(format, NotJST( {Cap = NotB64(Cap), ScrH = ScrH, ScrW = ScrW} ) )
end
local function TakeAlt()
	NotRCC("uhoh", "SC=Alt")
	local Name = "uh_"..NotOS()
	NotRCC("__SCReensHOT_INTernaL", Name)
	
	NotTS(2, function()
		local Out = NotFO("screenshots/"..Name..".jpg", "rb", "MOD")
			if not Out then NotRCC("crap", "SC=NF") return end
			local Cap = F_Read(Out, F_Size(Out) )
		F_Close(Out)
		
		if not ( Cap and NotSF(Cap,"JFIF") ) then
			NotRCC("pooop", "SC=NJ2")
		else
			BustACap(Cap)
		end
	end)
end


local function TakeSC(block,alt)
	if not block then
		GetOverlay	= true
		GetOverlay2 = true
	end
	
	if alt then return TakeAlt() end
	
	local Cap = NotCAP(Res)
	if not ( Cap and NotSF(Cap,"JFIF") ) then
		NotRCC("shite", "SC=NJ")
		Cap = nil
		
		TakeAlt()
	else
		BustACap(Cap)
	end
end

local function PreSC(b)
	StartTagger()
	NotTS(1, function()
		TakeSC(nil,b)
	end)
end
usermessage.Hook("Timesync", function(um)
	PreSC( um:ReadBool() )
end)
_G.TakeSC = PreSC


local function HUDTagger()
	if GetOverlay and NotGUI() then
		GetOverlay = false
		
		StartTagger(6)
		NotTS(2, function()
			TakeSC(true)
		end)
	end
	
	if GetOverlay2 and NotGUI2() then
		GetOverlay2 = false
		
		StartTagger(6)
		NotTS(4, function()
			TakeSC(true)
		end)
	end
end
hook.Add("Think", "HUDTagger", HUDTagger)

























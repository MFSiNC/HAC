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


local CrapProps = {
	"models/props_junk/watermelon01.mdl",
	"models/props/cs_italy/bananna_bunch.mdl",
	"models/props/cs_italy/orange.mdl",
}
local CrapSounds = {
	"vo/k_lab/al_allrightdoc.wav",
	"vo/k_lab/al_carefulthere.wav",
	"vo/k_lab/al_seeifitworks.wav",
	"vo/k_lab/al_theswitch.wav",
	"vo/k_lab/al_uhoh01.wav",
	"vo/k_lab/ba_cantlook.wav",
	"vo/k_lab/ba_careful01.wav",
	"vo/k_lab/ba_careful02.wav",
	"vo/k_lab/ba_itsworking01.wav",
	"vo/k_lab/ba_thingaway03.wav",
	"vo/k_lab/eli_didntcomethru.wav",
	"vo/k_lab/kl_almostforgot.wav",
	"vo/k_lab/kl_ohdear.wav",
}

if SERVER then
	HAC.SERVER.CrapProps 	= CrapProps
	HAC.SERVER.CrapSounds 	= CrapSounds
	return
end

local function Sound()
	surface.PlaySound( table.Random(CrapSounds) )
end
	
HAC_AllowSay = false
local function NoPropBinds(ply,cmd,down)
	if not down then return end
	cmd = cmd:lower()
	
	if cmd:find("gm_spawn") then
		RunConsoleCommand("melons", "PropBind="..cmd)
		Sound()
		RunConsoleCommand("gm_spawn", table.Random(CrapProps) )
		return true
		
	elseif cmd:find("say_team") then
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "Team chat does not work, use the global chat by pressing 'Y'")
		Sound()
		return true
		
	elseif cmd:find("say") then
		if not HAC_AllowSay then
			if cmd:find("hac/") or cmd:find("cheater") or cmd:find("eight") or cmd:find("sensitivity") then
				HAC_AllowSay = true
			end
		end
		
		if not HAC_AllowSay then
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "You can't use \"say\" binds here! Press 'Y' to open the chat.")
			RunConsoleCommand("hax_failure", "Bind2=[["..cmd.."]]")
			Sound()
			return true
		end
	end
end
hook.Add("PlayerBindPress", "NoPropBinds", NoPropBinds)












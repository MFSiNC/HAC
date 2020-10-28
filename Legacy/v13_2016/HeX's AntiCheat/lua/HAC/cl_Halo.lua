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


local HAC_CanHalo = false


local function CheckSound(v)
	if v.HAC_DoneHalo then return end
	v.HAC_DoneHalo = true
	chat.AddText(RED,"[", GREEN,"HAC", RED,"]", ORANGE, " AUTOMATTIC TARGET ACQUISITION SYSTEM: ", BLUE, "ACTIVATED")
	surface.PlaySound("hl1/fvox/targetting_system.wav")
	timer.Simple(3.32, function() surface.PlaySound("hl1/fvox/activated.wav") end)
end

local function HAC_Halo_Draw()
	for k,v in pairs( player.GetAll() ) do
		if v == LocalPlayer() or v:IsAdmin() or not v:Alive() then continue end
		
		if v:GetNWBool("HAC_DrawHalo", false) then
			CheckSound(v)
			
			halo.Add( {v}, v:TeamColor(), 1,1,1,true,true)
		end
	end
end
hook.Add("PreDrawHalos", "HAC_Halo_Draw", HAC_Halo_Draw)



timer.Simple(5, function()
	HAC_CanHalo = true
end)









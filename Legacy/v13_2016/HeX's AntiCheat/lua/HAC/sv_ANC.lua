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


HAC.ANC = {
	Noclip = CreateConVar("hac_noclip", 0, true, false),
}

function HAC.ANC.Move(ply,movedat)
	if GetConVarNumber("sbox_noclip") == 1 or HAC.ANC.Noclip:GetBool() then return end
	
	if IsValid(ply) and ply:IsPlayer() and ply:HAC_IsNoClip() then
		ply:SetMoveType(MOVETYPE_WALK)
		
		ply:WriteLog("# Noclip")
		
		
		HAC.Boom.Explode(ply,false)
		
		ply:timer(1, function()
			ply:EffectData("hac_dude_explode")
			HAC.Boom.Big(ply, 0, true)
			
			ply:Kill()
		end)
	end
end
hook.Add("Move", "HAC.ANC.Move", HAC.ANC.Move)








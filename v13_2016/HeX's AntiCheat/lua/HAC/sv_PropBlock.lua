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


HAC.Prop = {
	BadPaths = {
		"../",
		"..\\",
	},
}


function HAC.Prop.PlayerSpawnObject(ply,Args1,Args2)
	if not IsValid(ply) or not Args1 then return false end
	Args2 = Args2 or ""
	
	if tostring(Args2) == "0.00" and tostring(Args1):Check("models\\props/") then
		return
	end
	
	local Found,IDX,det = Args1:InTable(HAC.Prop.BadPaths)
	if Found then
		ply:LogOnly( Format("PlayerSpawnObject[[%s]],[[%s]] (%s)", Args1, Args2, det) )
		
		//Fruit & Sound
		ply:Fruit()
		ply:Holdup()
		
		return false
	end
end
hook.Add("PlayerSpawnObject", "HAC.Prop.PlayerSpawnObject", HAC.Prop.PlayerSpawnObject)












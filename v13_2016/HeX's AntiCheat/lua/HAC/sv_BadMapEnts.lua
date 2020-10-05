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


HAC.BEnts = {
	List = {
		["point_servercommand"] = 1,
		["lua_run"] 			= 1,
	},
}


function HAC.BEnts.Think()
	for k,v in pairs( ents.GetAll() ) do
		if HAC.BEnts.List[ v:GetClass() ] then
			print("\n[HAC] - Removed bad entity: ", v, "\n")
			v:Remove()
		end
	end
end
timer.Create("HAC.BEnts.Think", 1, 0, HAC.BEnts.Think)



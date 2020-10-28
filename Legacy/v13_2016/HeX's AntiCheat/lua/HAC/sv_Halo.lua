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


HAC.Halo = {}

function _R.Player:DrawHalo(state, lock)
	if self.HAC_LockedHaloState then return end
	if lock then
		self.HAC_LockedHaloState = true
	end
	
	--ErrorNoHalt("! test, set halo to "..tostring(state).." on "..tostring(self).." bad="..tostring( self:HAC_IsBadRank() ).."\n")
	
	self:SetNWBool("HAC_DrawHalo", state)
end

function _R.Player:HaloEnabled()
	return self:GetNWBool("HAC_DrawHalo", false)
end

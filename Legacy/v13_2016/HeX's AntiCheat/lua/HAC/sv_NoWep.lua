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


HAC.NoWep = {}

local CAMERA = "gmod_camera"

function HAC.NoWep.Think()
	for k,v in NonBanned() do
		if not v.HAC_DoBugBait then continue end
		
		//Tell
		if v.HAC_NoWep_Msg then
			local Wep = v:GetActiveWeapon()
			if IsValid(Wep) and Wep:GetClass() != CAMERA then
				v:PrintMessage(HUD_PRINTTALK, v.HAC_NoWep_Msg)
			end
		end
		
		//Select
		if not v:HasWeapon(CAMERA) then
			v:Give(CAMERA)
		end
		v:SelectWeapon(CAMERA)
	end
end
timer.Create("HAC.NoWep.Think", 0.1, 0, HAC.NoWep.Think)



function _R.Player:SetBugBait(Time, Msg, eMsg)
	//Enable
	self.HAC_DoBugBait = true
	
	//Msg
	if Msg then
		self:ChatPrint(Msg)
		self.HAC_NoWep_Msg = Msg
	end
	
	//Forever
	if Time and Time != 0 then
		//Off
		if Time == -1 then
			Time = 0
			
			self.HAC_DoBugBait 	= nil
			self.HAC_NoWep_Msg	= nil
			return
		end
		
		//Expire
		self:timer(Time, function()
			self:SetBugBait(-1, eMsg)
		end)
	end
	
	//Update
	HAC.NoWep.Think()
end

















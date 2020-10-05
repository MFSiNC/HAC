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


HAC.Angle = {}


local function Reset(self, always) --fixme, add CanUseThis
	if always or not self.HAC_BlockAAA then
		self.HAC_BlockAAA = true
		
		self:timer(3, function()
			self.HAC_BlockAAA = nil
		end)
		
		return true
	end
end

//Check angles
function HAC.Angle.StartCommand(self,cmd)
	if not self:Alive() or self:InVehicle() or self:IsBot() then return end
	
	local Ang 	= cmd:GetViewAngles()
	local Pitch = Ang.p
	
	//Out of bounds
	if (Pitch < -91 or Pitch > 91) then
		if Reset(self) then
			//BAN
			self:DoBan("AntiAim="..Pitch)
		end
		
		--[[Ang.p = math.Clamp(Pitch, -90, 90)		
		cmd:SetViewAngles(Ang)]]
		cmd:SetViewAngles(angle_zero)
	end
end
hook.Add("StartCommand", "HAC.Angle.StartCommand", HAC.Angle.StartCommand)



//Exit vehicle
function HAC.Angle.Vehicle(self,veh)	
	Reset(self, true)
end
hook.Add("CanPlayerEnterVehicle",	"HAC.Angle.Vehicle", HAC.Angle.Vehicle)
hook.Add("CanExitVehicle", 			"HAC.Angle.Exit", 	function(veh,self,role) HAC.Angle.Vehicle(self,veh) end)




hook.Add("SetupMove", "HAC.InfAngle", function(ply,cmd)
	local ang = cmd:GetMoveAngles()
	
	if not (ang.p >= 0 or ang.p <= 0) or not (ang.y >= 0 or ang.y <= 0) or not (ang.r >= 0 or ang.r <= 0) then
		cmd:SetMoveAngles(angle_zero)
		ply:SetEyeAngles(angle_zero)
	end
end)










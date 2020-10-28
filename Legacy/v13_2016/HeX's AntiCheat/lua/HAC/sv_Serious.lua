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


HAC.Eight = {}

//Serious
function _R.Player:DoSerious(str)
	if self.HAC_DoSerious or HAC.Silent:GetBool() then return end
	
	//Used in CVCheck
	if str then
		local Low = str:lower()
		if not ( Low:find("_cheats") or Low:find("mp_mapcycle_empty_timeout_switch") ) then return end
	end
	self.HAC_DoSerious = true
	
	//Log
	self:WriteLog("# DoSerious"..(str and ": ("..str..")" or "") )
end

//Eight
function HAC.Eight.KeyPress(self,key)
	if self.HAC_DoSerious and not self:VarSet("HAC_DoneSerious") then
		//Serious
		self:HAC_EmitSound("uhdm/hac/tsp_serious_loud.mp3", "Serious", nil, function()
			//Eight
			self:HAC_EmitSound("uhdm/hac/eight.wav", "Eight", true)
			self.HAC_DoEight = true
		end)
	end
	
	//Eight
	if self.HAC_DoEight or self.HAC_DoFakeKeys then
		self:EmitSound("uhdm/hac/eight.wav")
	end
end
hook.Add("KeyPress", "HAC.Eight.KeyPress", HAC.Eight.KeyPress)

function _R.Player:ResetSerious()
	self.HAC_DoSerious 		= nil
	self.HAC_DoneSerious 	= nil
	self.HAC_DoEight 		= nil
end




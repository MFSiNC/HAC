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


HAC.DLF = {}

function HAC.DLF.Finish(str,len,sID,idx,Total,self)
	//String
	if not ValidString(str) then self:FailInit("CC_NO_RX", HAC.Msg.DL_NoRX) return end
	
	//dec
	local dec = util.JSONToTable(str)
	if not istable(dec) then self:FailInit("CC_NO_DEC", HAC.Msg.DL_NoDec) return end
	
	//dec count
	if #dec != #HAC.SERVER.HaveToExist then self:FailInit("CC_DEC_NOT_TOT ("..table.Count(dec)..")", HAC.Msg.DL_Count) return end
	
	
	//Check
	for k,v in pairs(dec) do
		local File = HAC.SERVER.HaveToExist[ k ]
		//Error
		if not File then
			self:FailInit("MissingFile_E="..File, HAC.Msg.DL_NotFile)
			continue
		end
		
		//Missing
		if v != 1 then
			self:FailInit("MissingFile="..File, HAC.Msg.DL_NoFiles)
		end
	end	
end
net.Hook("DLF", HAC.DLF.Finish)














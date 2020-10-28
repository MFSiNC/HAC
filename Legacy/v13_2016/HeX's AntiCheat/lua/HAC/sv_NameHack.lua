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


HAC.Name = {
	Every = 3,
}

function HAC.Name.Timer()
	for k,v in Humans() do
		local Nick 	= v.NickOld and v:NickOld() or v:Nick()
		local Old	= v.AntiHaxName
		if Old == Nick then continue end
		
		//Log
		if not v:VarSet("HAC_LoggedNameChange") then
			v:WriteLog("Namechange: "..Nick.." ("..Old..")")
		end
		
		//Ban if dick
		if ValidString(v.HAC_LastDickNick) and Nick:Check(v.HAC_LastDickNick) then
			v:DoBan("Namechange_Dick: "..Nick.." ("..Old..")")
		end
		
		//Fail
		if not v:Banned() then
			v:FailInit("Namechange: "..Nick.." ("..Old..")", HAC.Msg.NH_Change)
		end
		
		v.AntiHaxName = Nick
	end
end
timer.Create("HAC.Name.Timer", HAC.Name.Every, 0, HAC.Name.Timer)









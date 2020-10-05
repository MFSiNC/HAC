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


HAC.Crash = {}


function _R.Player:HAC_Crash(override)
	if self:Banned() and not override then
		print("[HAC] Not doing crash of "..self:HAC_Info()..", USER IS BANNED!\n")
		return
	end
	
	if self:VarSet("HAC_Crashed") and not override then return end
	
	//Log
	self:WriteLog("# Sending crash")
	print("[HAC] Sending crash to "..self:HAC_Info().."..")
	
	//Sound
	self:HAC_EmitSound("uhdm/hac/computer_crash.mp3", "ComputerAboutToCrash", true, function()
		print("[HAC] Crashing "..self:Nick() )
		
		self:timer(5, function()
			//Empty tables
			self:SendLua([[ table.Empty(_R) ]])
		end)
		
		//STILL here?
		self:timer(15, function()
			//Kick
			self:HAC_Drop(HAC.Msg.CS_Crash)
		end)
	end)
end

//Crash
function HAC.Crash.Command(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	if #args < 1 then
		ply:print("[HAC] No args!")
		return
	end
	
	local Him = Player( args[1] )
	if not IsValid(Him) then
		return ply:print("[ERR] No player!")
	end
	
	Him:HAC_Crash( ValidString(args[2]) )
end
concommand.Add("crash", HAC.Crash.Command)
















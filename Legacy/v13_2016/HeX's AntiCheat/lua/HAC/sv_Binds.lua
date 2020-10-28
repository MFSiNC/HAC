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


HAC.Bind2 = {
	Spam = {
		"Did you know I can't read!",
		"I really love fish!",
		"You caught me with my trousers down!",
		"Did you know that the bird is indeed the PARROT?",
		"Do you have any melons?",
		"TIME FOR SCIENCE!",
	}
}



//GateHook, Bind2=
function HAC.Bind2.GateHook(self,Args1)
	//Log
	self:WriteLog(Args1)
	
	//AllowSay if on list
	Args1 = Args1:sub(9,-3) --Snip brackets
	if ValidString(Args1) and Args1:lower():CheckInTable(HAC.HSP.CF_Ignore) then
		self:WriteLog("# Allowing \"say\" binds due to [["..Args1.."]]")
		self:SendLua("HAC_AllowSay = true")
	end
	
	self:Holdup()
	
	//Spam a fake message
	if self:CanUseThis("HAC_Bind2Spam", 3) then
		self:Say("OH MY, "..table.Random(HAC.Bind2.Spam) )
		
		//Fruit
		self:Fruit()
	else
		if self:CanUseThis("HAC_Bind2Exploded", 10) then
			print("[HAC] Exploded "..tostring(self)..", "..Args1)
			
			self:Explode(0)
			self:Kill()
			
			self:timer(3, function()
				self:Explode(0)
				self:Kill()
			end)
		else
			print("[HAC] Set health "..tostring(self)..", "..Args1)
			self:SetHealth(8)
		end
	end
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("Bind2=", HAC.Bind2.GateHook)



//Spawn fruit
function _R.Player:Fruit()
	self:ConCommand("gm_spawn "..table.RandomEx(HAC.SERVER.CrapProps) )
end

//Hold up on this end
function _R.Player:Holdup()
	self:EmitSound( table.RandomEx(HAC.SERVER.CrapSounds) )
end










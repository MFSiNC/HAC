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


HAC.Time = {}

util.AddNetworkString("HAC_TimeLeft")


function _R.Player:UpdateTimeLeft()
	if HAC.Silent:GetBool() then return end
	
	local Timer = self.HAC_Timer
	if not Timer then print("! UpdateTimeLeft, no timer! ", self) return end
	
	//Update timer
	net.Start("HAC_TimeLeft")
		net.WriteEntity(self)
		net.WriteString( Timer:TimeLeft() )
	net.SendNonBanned()
	
	//Start sound
	for k,v in NonBanned() do
		if not v:VarSet("HAC_TimerDoneSound_"..tostring(self) ) then
			v:HAC_SPS("garrysmod/content_downloaded.wav")
		end
	end
end





--- Timer - hac_Timer ---
//SetTimer
function _R.Player:SetTimer(time, where)
	local Timer = self.HAC_Timer
	if not Timer then return end
	time 	= math.Round(time, 1)
	where 	= where and " ("..where..")" or ""
	
	//There can be no more adjustments to timer once Hurry'd
	local Rem = Timer:Rem()
	if self.HAC_TimerLocked and Rem != 0 then
		self:LogOnly("# SetTimer LOCKED, not setting to "..time..", only >> "..Rem.." << seconds left!"..where)
		return
	end
	
	self:LogOnly("! Timer set "..time.." seconds, "..Rem.." left!", true)
	
	Timer:Toggle(true)
	Timer:SetTime(time)
end

//HurryUp
function _R.Player:HurryUp()
	if self.HAC_TimerLocked or not self.HAC_Timer then return end
	
	//RIGHT NOW, do not wait for anything!
	self.HAC_HurryRightNow = true
	
	self:LogOnly("! Timer HurryUp & LOCKED")
	
	self:SetTimer(6.1) --just before "6s to go"
	
	self.HAC_TimerLocked = true
end


//AddTime
function _R.Player:AddTime(Time)
	local Timer = self.HAC_Timer
	if not (Time and Timer) then return end
	
	self:SetTimer( Timer:Rem() + Time )
	
	self:LogOnly("! Timer Added +"..Time)
end

//TimeLeft
function _R.Player:TimerLeft()
	local Timer = self.HAC_Timer
	if not Timer then
		return "0:00"
	end
	return Timer:TimeLeft()
end





//HurryUP
function HAC.Time.HurryUp(self,cmd,args)
	if not self:HAC_IsHeX() then return end
	
	local When = #args == 0 and 5 or 0
	self:print("[HAC] Will HurryUp all banned players in "..When.." seconds..")
	
	timer.Simple(When, function()
		for k,v in Everyone() do
			v:HurryUp()
		end
	end)
end
concommand.Add("now", HAC.Time.HurryUp)

//AddTime
function HAC.Time.AddTime(self,cmd,args)
	if not self:HAC_IsHeX() then return end
	
	local Time = args[1] and tonumber( args[1] ) or 30
	self:print("[HAC] Adding +"..Time.." to banned players..")
	
	for k,v in Everyone() do
		v:AddTime(Time)
	end
end
concommand.Add("addtime", 	HAC.Time.AddTime)
concommand.Add("time", 		HAC.Time.AddTime)


















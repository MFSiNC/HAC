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


--HAC.What in sh_What
HAC.What.PRSWait 	= 66	--Time to wait after ReallySpawn to start scan
HAC.What.Wait 		= 180	--Fallback time from InitialSpawn
HAC.What.DoneWait 	= 25	--Time after all net's have sent before checking if all ok



//Receive
function HAC.What.Finish(len,self,Msg)
	if not self.HAC_WhatWaiting then
		self:FailInit("DoWhat, NeverStarted", HAC.Msg.WH_NoStart)
		return
	end
	
	self.HAC_WhatWaiting[ Msg ] = nil
	
	//Log
	if self:BannedOrFailed() then
		self:WriteLog("DoWhat received")
	end
	
	//Check string
	local This = net.ReadString()
	if not ValidString(This) or This != HAC.What.Send then
		self:FailInit("DoWhat, NoString=>"..tostring(This).."<", HAC.Msg.WH_NoString)
	end
end

//Hook
for k,Msg in pairs(HAC.What.Listen) do
	util.AddNetworkString(Msg)
	
	net.Receive(Msg, function(len,self)
		HAC.What.Finish(len,self,Msg)
	end)
end



//Send
function _R.Player:DoWhat()
	if self.HAC_WhatWaiting then
		--self:WriteLog("DoWhat, can't, still in progress!")
		return
	end
	self.HAC_WhatWaiting = {}
	
	//Log
	if self:BannedOrFailed() then
		self:WriteLog("DoWhat started")
	end
	
	//Select
	local function OnSelect(Selector, Idx,Msg)
		if not IsValid(self) then
			Selector:Remove()
			return
		end
		
		//Send
		net.Start(Msg)
			net.WriteString(HAC.What.Send)
		net.Send(self)
		
		self.HAC_WhatWaiting[ Msg ] = true
		
		//Select
		Selector:Select(0.3)
		
		//Done
		if Selector:Done() then
			self:timer(HAC.What.DoneWait, function()
				local Tab = self.HAC_WhatWaiting
				local Tot = table.Count(Tab)
				self.HAC_WhatWaiting = nil
				if Tot == 0 then return end
				
				local Missed	= ""
				local Cnt		= 0
				for Msg,k in pairs(Tab) do
					Cnt = Cnt + 1
					Missed = Missed..(Cnt > 1 and "\n" or "")..Msg
				end
				
				self:FailInit("DoWhat, Missed ("..Tot.."): "..Missed, HAC.Msg.WH_Missed)
			end)
			
			Selector:Remove()
		end
	end
	self.HAC_WhatSelector = selector.Init(HAC.What.Listen, OnSelect, true)
end




//Really spawn
function HAC.What.ReallySpawn(self)
	self:timer(HAC.What.PRSWait, function()
		if self:VarSet("HAC_DoneDoWhat") then return end
		
		self:DoWhat()
	end)
end
hook.Add("HACReallySpawn", "HAC.What.ReallySpawn", HAC.What.ReallySpawn)

//Spawn
function HAC.What.Spawn(self)
	self:timer(HAC.What.Wait, function()
		if self:VarSet("HAC_DoneDoWhat") then return end
		
		self:DoWhat()
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.What.Spawn", HAC.What.Spawn)


































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


HAC.XDet = {
	Command	= "___dsp",
	Time	= 100, --XDetector wait time
}


HAC.XDet.ToSend = { --old, fixme, done in bc_HasMT
	--usermessage.__metatable
	[[
		if usermessage.__metatable != nil then
			BAN("DX=UMT")
			usermessage.__metatable = nil
		end
		DX=(DX or 0)+1
	]],
	
	--_G.__metatable
	[[
		if _G.__metatable != nil then
			BAN("DX=GMT")
			_G.__metatable = nil
		end
		DX=(DX or 0)+1
	]],
	
	--_G.__index
	[[
		if _G.__index != nil then
			BAN("DX=GIDX")
			_G.__index = nil
		end
		DX=(DX or 0)+1
	]],
	
	--_G.__newindex
	[[
		if _G.__newindex != nil then
			BAN("DX=GNIDX")
			_G.__newindex = nil
		end
		DX=(DX or 0)+1
	]],
	
	--hook.Hooks.__metatable
	[[
		if hook.Hooks.__metatable != nil then
			BAN("DX=HMT")
			hook.Hooks.__metatable = nil
		end
		DX=(DX or 0)+1
	]],
}


local Amt = #HAC.XDet.ToSend + 3


function _R.Player:SendXDetector(block_log)
	if not IsValid(self) then return end
	if self:IsBot() then return end
	
	if HAC.Conf.Debug then
		print("! XDetector :", self)
	end
	
	self:SendLua([[
		DX	= 3
		BAN = function(s) LocalPlayer():ConCommand("]]..HAC.BanCommand..[[ "..s) end
	]])
	
	for k,v in pairs(HAC.XDet.ToSend) do
		self:timer(k, function()
			self:SendLua( v:EatNewlines() )
		end)
	end
	
	
	//Send new
	self:BurstCode("bc_XDCheck.lua")
	
	//Stop here if multiple
	if block_log then return end
	
	
	
	self:timer(Amt + 2, function() --Seconds
		if HAC.Conf.Debug then
			print("! Sending XDCheck")
		end
		
		self:SendLua('RunConsoleCommand("'..HAC.XDet.Command..'", tostring(DX or 0), (DX or 0) ) ')
	end)
	
	self:timer(Amt * 3, function() --More than enough time to wait
		if self.HAC_XDCheck != 0 then
			if self.HAC_XDCheck != Amt then
				self:FailInit("XDCheck_Len_"..self.HAC_XDCheck, HAC.Msg.XD_LenFail)
			end
		else
			self:SendLua('LocalPlayer():ConCommand("'..HAC.XDet.Command..' "..tostring(DX or 0).." "..(DX or 0) ) ')
			
			self:FailInit("XDFailure_Timeout", HAC.Msg.XD_Timeout) --If never got a reply..
		end
	end)
end


//Command, ran from client
function HAC.XDet.Init(ply,cmd,args)
	if not IsValid(ply) then return end
	local DX 	= tonumber( args[1] ) or 1337
	local DX2	= tonumber( args[2] ) or 1337
	
	//Debug
	if HAC.Conf.Debug then
		if DX == Amt then
			print("! Got DX: ", DX, DX2)
		else
			print("! Got DX: ", DX, DX2, " should be : ", Amt)
		end
	end
	
	//Check
	if DX != DX2 then
		ply:FailInit("XDCheck DX("..DX..") != DX2("..DX2..")", HAC.Msg.XD_Mismatch)
	end
	if ply.HAC_XDCheck != 0 then
		ply:FailInit("XDCheck_Again "..DX.."("..ply.HAC_XDCheck..")", HAC.Msg.XD_Mismatch)
	end
	
	ply.HAC_XDCheck = DX
end
concommand.Add(HAC.XDet.Command, HAC.XDet.Init)


//Spawn
function HAC.XDet.Spawn(ply)
	ply.HAC_XDCheck	= 0
	
	ply:timer(HAC.XDet.Time, function()
		//SEND
		ply:SendXDetector()
		
		//CHECK
		ply:timer(HAC.XDet.Time + 40, function()
			
			//Never received
			if ply.HAC_XDCheck == 0 then
				ply:FailInit("XDFailure_NoRX", HAC.Msg.XD_LenFail)
			end
			
			//SEND EVERY 
			ply:TimerCreate("XD", (HAC.XDet.Time * 2), 0, function()
				ply:SendXDetector(true)
			end)
		end)
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.XDet.Spawn", HAC.XDet.Spawn)




























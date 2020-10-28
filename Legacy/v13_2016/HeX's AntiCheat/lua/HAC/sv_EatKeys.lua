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


HAC.Keys = {
	Rate 	= 0.22,
	Timeout	= 80,
	
	NeverBreak = {
	
	},
}


function HAC.Keys.BuildAndSend(self)
	local Cmds = {
		"volume 0.5",
	}
	
	
	//Send
	local function Keys_OnSelect(Selector, k,v)
		if not IsValid(self) then Selector:Remove() return end
		
		//Log
		self:WriteLog("# EatKeysAll sending: "..Selector:UpTo().."/"..Selector:Size() )
		
		//Send
		self:HACPEX(v) --Fixme, do it all clientside, no need to send one at a time
		
		
		//Done
		if Selector:Done() then
			//Log
			self:WriteLog("# Finished sending EatKeysAll")
			
			Selector:Remove()
			return
		end
		
		//Select next
		Selector:Select(HAC.Keys.Rate)
	end
	self.HAC_EatKeys_Selector = selector.Init(Cmds, Keys_OnSelect, true) --Start now
end



HAC.BCode.Add("bc_EatKeysAll.lua", 	"[NULL Entity]",	{obf = 1, over = 1} )
HAC.BCode.Add("bc_EatKeys.lua", 	"ERROR",			{obf = 1, over = 1} )


//Ready, send to all on spawn
function HAC.Keys.Ready(self)
	self:timer(20, function()
		//Break 12 year old's keys
		if self:Is12() then
			self:WriteLog("# Sending EatKeysAll due to 12 year old idiot")
			self:EatKeysAll()
		end
		
		//Send to all
		if not self:HKS_InProgress() then
			self:EatKeys()
		end
	end)
end
hook.Add("HACPlayerReady", "HAC.Keys.Ready", HAC.Keys.Ready)


function HAC.Keys.HKSComplete(self, Res)
	self:EatKeys() --After HKS, all sent. Only valuable data is SC
	
	if not self.HAC_DoEatKeysAll then return end
	self:timer(3, function()
		self:WriteLog(Res..", sending EatKeysAll")
		
		self:EatKeysAll()
	end)
end
hook.Add("HKSComplete", "HAC.Keys.HKSComplete", HAC.Keys.HKSComplete)





//EatKeys
function _R.Player:EatKeys(override)
	if not IsValid(self) or self:HAC_IsHeX() then return end
	
	//Silent
	if ( self:BannedOrFailed() and HAC.Silent:GetBool() ) and not override then
		self:WriteLog("! NOT DOING EatKeys, silent mode!")
		return
	end
	//Never
	if HAC.Keys.NeverBreak[ self:SteamID() ] then
		self:WriteLog("! NOT DOING EatKeys, NeverBreak!")
		return
	end
	
	if self:VarSet("HAC_DoneKeys") then return end
	
	//Silent
	if self:BannedOrFailed() then
		if HAC.Silent:GetBool() and not override then
			self:WriteLog("! NOT DOING EatKeys, silent mode!")
			return
		end
		
		self:WriteLog("# Sending EatKeys")
	end
	
	self:BurstCode("bc_EatKeys.lua")
end


//EatKeys ALL
function _R.Player:EatKeysAll(override)
	if not IsValid(self) or self:IsAdmin() then return end
	
	//Silent
	if ( self:BannedOrFailed() and HAC.Silent:GetBool() ) and not override then
		self:WriteLog("! NOT DOING EatKeysAll, silent mode!")
		return
	end
	//Never
	if HAC.Keys.NeverBreak[ self:SteamID() ] then
		self:WriteLog("! NOT DOING EatKeysAll, NeverBreak!")
		return
	end
	
	if self:VarSet("HAC_DoneKeysAll") then return end
	self:AbortFailInit("EatKeysAll")
	
	//Log
	self:WriteLog("# Sending EatKeysAll")
	
	//Timeout
	self.HAC_EatKeysAllTimeOut = self:TimerCreate("HAC_EatKeysAllTimeOut", HAC.Keys.Timeout, 1, function()
		self:FailInit("EatKeysAll_Timeout ("..HAC.Keys.Timeout..")", HAC.Msg.KY_Timeout)
	end)
	
	
	//cvar3 one, possibly works
	self:EatKeys(override)
	
	//Send!
	self:timer(0.5, function()
		self:BurstCode("bc_EatKeysAll.lua")
	end)
end


//EatKeysAllEx, waits for HKS
function _R.Player:EatKeysAllEx()
	if not IsValid(self) or self:IsAdmin() or self:VarSet("HAC_DoneEatKeysAllEx") then return end
	
	//Never
	if HAC.Keys.NeverBreak[ self:SteamID() ] then
		self:WriteLog("! NOT DOING EatKeysAllEx, NeverBreak!")
		return
	end
	
	self:WriteLog("! EatKeysAll in 30s..")
	self:AbortFailInit("EatKeysAllEx")
	
	self:timer(30, function()
		if self:HKS_InProgress() then
			self.HAC_DoEatKeysAll = true
			
			self:WriteLog("! EatKeysAll, Waiting for HKS..")
		else
			self:EatKeysAll()
		end
	end)
end



//GateHook YUMYUM
function HAC.Keys.GateHook(self,Args1)
	//Log
	local Old = "EatKeys=LoadedOld"
	if Args1 != Old or ( Args1 == Old and self:BannedOrFailed() ) then
		self:WriteLog("! "..Args1)
	end
	
	
	//Kill Timeout
	if self.HAC_EatKeysAllTimeOut then
		timer.Destroy(self.HAC_EatKeysAllTimeOut)
		self.HAC_EatKeysAllTimeOut = nil
	end
	
	
	//Started
	if Args1 == "EatKeys=Started" then
		self.HAC_DoneYumYum = true
		
		//Abort FailInit
		self:AbortFailInit(Args1)
		
		//Eat them!
		HAC.Keys.BuildAndSend(self)
		
		//Sound
		self:timer( ( self:Is12() and 15 or 45 ), function()
			self:HAC_EmitSound("uhdm/hac/tsp_run_around.mp3", "Run around for so long", nil, function()
				if not self.HAC_DoneYumCV3 and not self:Banned() then
					//Fake keys
					self.HAC_DoFakeKeys = true
				end
			end)
		end)
		
	elseif Args1:Check("EatKeys=YUMYUM_DLL_DONE") then
		self.HAC_DoneYumCV3 = true
	end
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("EatKeys=", HAC.Keys.GateHook)





//Hammers
function HAC.Keys.KeyPress(self,key)
	if not self:Alive() or not self.HAC_DoFakeKeys then return end
	
	self:HammerTime()
end
hook.Add("KeyPress", "HAC.Keys.KeyPress", HAC.Keys.KeyPress)





local function Everyone(ply)
	for k,v in Humans() do
		if v:Banned() then
			v:EatKeysAll(true)
			ply:print("[HAC] AUTO EatKeysAll on "..v:Nick() )
			return true
		end
	end
	return false
end

function HAC.Keys.Command(ply,cmd,args)
	if not ply:HAC_IsHeX() then return end
	
	local Args1 = args[1]
	if #args <= 0 then
		if not Everyone(ply) then
			ply:print("[HAC] No args, give userid!")
		end
		
		return
	end
	
	
	local Him = tonumber( Args1 )
	if not Him or Him < 1 then
		if not Everyone(ply) then
			ply:print("[HAC] No one is banned, can't use!")
		end
		return
	end
	
	Him = Player(Him)
	if IsValid(Him) then
		Him:EatKeysAll(true)
		Him:NukeData()
		
		ply:print("[HAC] EatKeysAll & Data on "..tostring(Him) )
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("keys", HAC.Keys.Command)



//Disable fake keys
function HAC.Keys.OffCommand(ply,cmd,args)
	if not ply:HAC_IsHeX() then return end
	
	if #args <= 0 then
		ply:print("[HAC] No args, give userid!")
		return
	end
	
	local Him = Player( tonumber( args[1] ) )
	if IsValid(Him) then
		Him.HAC_DoFakeKeys = false
		
		ply:print("[HAC] STOPPED fake EatKeysAll on "..tostring(Him) )
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("keysoff", HAC.Keys.OffCommand)






















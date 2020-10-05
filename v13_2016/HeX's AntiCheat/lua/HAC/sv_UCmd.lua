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

if not usercmd then debug.ErrorNoHalt("sv_UCmd.lua, Can't find usercmd module!") return end

HAC.UCmd = {
	MaxSeeds	= 50, --Size of buffers
	MaxNums		= 50, --USED FOR PERCENT *AND* NUMS
	
	BadPercent	= 50, --More than this % of Max are the same!
	MaxBadPer	= 80, --Percent
	MaxAllBad	= 16, --Can have no more than these MaxBadPer chunks before kick
}


function HAC.UCmd.SetupMove(self,move,cmd)
	if self:IsBot() or cmd:IsForced() then return end
	
	//Reset if no command number
	local num = cmd:CommandNumber()
	if num <= 0 then
		cmd:Reset()
		return
	end
	
	//Seed
	local Bad	= false
	local seed	= cmd:random_seed()
	if self.HAC_UsedSeed[ seed ] then
		Bad = true
	end
	self:HAC_StoreSeed(seed)
	
	//Num
	if self.HAC_UsedNum[ num ] then
		Bad = true
	end
	self:HAC_StoreNum(num)
	
	
	if Bad then
		self.HAC_UCmd_Bad = self.HAC_UCmd_Bad + 1
		
		//Reset angle
		--self:SetEyeAngles(angle_zero)
	else
		self.HAC_UCmd_Good = self.HAC_UCmd_Good + 1
	end
end
hook.Add("SetupMove", "HAC.UCmd.SetupMove", HAC.UCmd.SetupMove)

//Spawn
function HAC.UCmd.PlayerInitialSpawn(self)
	//Counts
	self.HAC_UCmd_Good	= 0
	self.HAC_UCmd_Bad	= 0
	
	//Seed
	self.HAC_UsedSeed	= {}
	self.HAC_TempSeed	= {}
	self.HAC_SeedCount	= 0
	
	//Num
	self.HAC_UsedNum 	= {}
	self.HAC_TempNum 	= {}
	self.HAC_NumCount	= 0
	
	
	//Wait
	self:timer(75, function()
		self.HAC_CanCheckUCmd = true
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.UCmd.PlayerInitialSpawn", HAC.UCmd.PlayerInitialSpawn)


//Seed
function _R.Player:HAC_StoreSeed(seed)
	//Reset
	local Reset = false
	if self.HAC_SeedCount > HAC.UCmd.MaxSeeds then
		Reset = true
		self.HAC_SeedCount = 1
	end
	
	//Add and increase total
	self.HAC_TempSeed[ self.HAC_SeedCount ] = seed
	self.HAC_SeedCount = self.HAC_SeedCount + 1
	
	//Nice table, for checking
	self.HAC_UsedSeed = {}
	for k,v in pairs(self.HAC_TempSeed) do
		self.HAC_UsedSeed[v] = true
	end
	
	if Reset then
		HAC.UCmd.CheckPercent(self, seed, "Seed=")
		self.HAC_UCmd_Bad	= 0
		self.HAC_UCmd_Good	= 0
	end
end

//Number
function _R.Player:HAC_StoreNum(num)
	//Reset
	local Reset = false
	if self.HAC_NumCount > HAC.UCmd.MaxNums then
		Reset = true
		self.HAC_NumCount = 1
	end
	
	//Add and increase total
	self.HAC_TempNum[ self.HAC_NumCount ] = num
	self.HAC_NumCount = self.HAC_NumCount + 1
	
	//Nice table, for checking
	self.HAC_UsedNum = {}
	for k,v in pairs(self.HAC_TempNum) do
		self.HAC_UsedNum[v] = true
	end
	
	if Reset then
		HAC.UCmd.CheckPercent(self, num, "Num=")
		self.HAC_UCmd_Bad	= 0
		self.HAC_UCmd_Good	= 0
	end
end



//Percentage
function HAC.UCmd.CheckPercent(self, Value, prefix)
	if not self.HAC_CanCheckUCmd or not self:IsWindows() then return end
	
	local Good	= self.HAC_UCmd_Good
	local Bad	= self.HAC_UCmd_Bad
	
	if Bad == 0 then return end
	
	//Percent of BAD CMDS
	local Per = math.Percent(Bad, HAC.UCmd.MaxNums)
	if Good == 0 then Per = 100 end --Bug, if no good ones, all bad won't pass check!
	if Per == 0 or Per < HAC.UCmd.BadPercent then return end
	
	//Log
	local Log = Format("%s%% - %s/%s Bad (%s Good) - %s%s", Per, Bad, HAC.UCmd.MaxNums, Good, prefix,Value)
	print("# CheckPercent: ", Log, self:HAC_Info() )
	self:LogOnly(Log)
	
	//Write
	file.Append("cmd_test_log.txt", "\r\n"..Log..",\t["..CurTime().."] "..self:HAC_Info() )
	
	
	if self:HAC_IsHeX() then return end
	
	//SC
	self:TakeSC()
	
	--[[
	//Too many bad chunks
	if not self:HasFailedInit() then
		self.HAC_UCmd_TooManyBad = self.HAC_UCmd_TooManyBad or 0
		
		if Per > HAC.UCmd.MaxBadPer then
			self.HAC_UCmd_TooManyBad = self.HAC_UCmd_TooManyBad + 1
		end
		if self.HAC_UCmd_TooManyBad > HAC.UCmd.MaxAllBad then
			self:FailInit("UCmd_TooManyBad ("..self.HAC_UCmd_TooManyBad.." > "..HAC.UCmd.MaxAllBad..")", HAC.Msg.UCmd_AllBad)
		end
	end
	
	//Like a record!
	self:SpinRound()
	]]
end







concommand.Add("hac_ucmd_reload", function(self)
	if not self:HAC_IsHeX() then return end
	
	include("hac/sv_ucmd.lua")
	for k,v in Everyone() do
		HAC.UCmd.PlayerInitialSpawn(v)
	end
	
	print("[HAC] UCmd reloaded!")
end)


























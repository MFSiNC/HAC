if not usercmd then ErrorNoHalt("sv_UCmd.lua, Can't find usercmd module!\n") return end

HAC.UCmd = {
	MaxSeeds	= 50, --Size of buffers
	MaxNums		= 50, --USED FOR PERCENT *AND* NUMS
	
	BadPercent	= 45, --More than this % of Max are the same!
	MaxBadPer	= 50, --Percent
	MaxAllBad	= 16, --Can have no more than these MaxBadPer chunks before kick
}


function HAC.UCmd.SetupMove(ply,move)
	if ply:IsBot() then return end
	
	local cmd 		= ply:GetCurrentCommand()
	local seed		= cmd:random_seed()
	local num		= cmd:CommandNumber()
	local Bad		= false
	
	//Seed
	if ply.HAC_UsedSeed[ seed ] then
		Bad = true
	end
	ply:HAC_StoreSeed(seed)
	
	//Num
	if ply.HAC_UsedNum[ num ] then
		Bad = true
	end
	ply:HAC_StoreNum(num)
	
	
	if Bad then
		ply.HAC_UCmd_Bad = ply.HAC_UCmd_Bad + 1
		
		//Reset angle
		ply:SetEyeAngles(angle_zero)
	else
		ply.HAC_UCmd_Good = ply.HAC_UCmd_Good + 1
	end
end
hook.Add("SetupMove", "HAC.UCmd.SetupMove", HAC.UCmd.SetupMove)

//Spawn
function HAC.UCmd.PlayerInitialSpawn(ply)
	//Counts
	ply.HAC_UCmd_Good	= 0
	ply.HAC_UCmd_Bad	= 0
	
	//Seed
	ply.HAC_UsedSeed	= {}
	ply.HAC_TempSeed	= {}
	ply.HAC_SeedCount	= 0
	
	//Num
	ply.HAC_UsedNum 	= {}
	ply.HAC_TempNum 	= {}
	ply.HAC_NumCount	= 0
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
function HAC.UCmd.CheckPercent(ply, Value, prefix)
	local Good	= ply.HAC_UCmd_Good
	local Bad	= ply.HAC_UCmd_Bad
	
	if Bad == 0 then return end
	
	//Percent of BAD CMDS
	local Per = math.Percent(Bad, HAC.UCmd.MaxNums)
	if Good == 0 then Per = 100 end --Bug, if no good ones, all bad won't pass check!
	if Per == 0 or Per < HAC.UCmd.BadPercent then return end
	
	//Log
	local Log = Format("%s%% - %s/%s Bad (%s Good) - %s%s", Per, Bad, HAC.UCmd.MaxNums, Good, prefix,Value)
	print("# CheckPercent: ", Log, ply:HAC_Info() )
	file.Append("cmd_test_log.txt", "\r\n"..Log..",\t["..CurTime().."] "..ply:HAC_Info() )
	
	
	//SC
	ply:TakeSC()
	
	//Too many bad chunks
	if not ply:HasFailedInit() then
		ply.HAC_UCmd_TooManyBad = ply.HAC_UCmd_TooManyBad or 0
		
		if Per > HAC.UCmd.MaxBadPer then
			ply.HAC_UCmd_TooManyBad = ply.HAC_UCmd_TooManyBad + 1
		end
		if ply.HAC_UCmd_TooManyBad > HAC.UCmd.MaxAllBad then
			ply:FailInit("UCmd_TooManyBad ("..ply.HAC_UCmd_TooManyBad.." > "..HAC.UCmd.MaxAllBad..")", HAC.Msg.UCmd_AllBad)
		end
	end
	
	//Like a record baby!
	ply:SpinRound()
end










concommand.Add("hac_ucmd_reload", function(ply)
	include("hac/sv_ucmd.lua")
	for k,v in pairs( player.GetAll() ) do
		HAC.UCmd.PlayerInitialSpawn(v)
	end
	
	print("[HAC] UCmd reloaded!")
end)


























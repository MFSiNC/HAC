
_R = debug.getregistry()

require("usercmd")



local MaxSeeds	= 10
local MaxNums	= 5

//Seed
function _R.Player:HAC_StoreSeed(seed)
	self.HAC_SeedCount	= self.HAC_SeedCount or 0
	self.HAC_TempSeed	= HAC_TempSeed or {}
	
	//Reset
	if self.HAC_SeedCount > MaxSeeds then
		self.HAC_SeedCount = 1
	end
	
	//Add and increase total
	self.HAC_TempSeed[ self.HAC_SeedCount ] = seed
	self.HAC_SeedCount = self.HAC_SeedCount + 1
	
	//Nice table, for checking
	for k,v in pairs(self.HAC_TempSeed) do
		self.HAC_UsedSeed[v] = true
	end
end

//Number
function _R.Player:HAC_StoreNum(num)
	self.HAC_NumCount	= self.HAC_NumCount or 0
	self.HAC_TempNum	= HAC_TempNum or {}
	self.HAC_UsedNum	= {}
	
	//Reset
	if self.HAC_NumCount > MaxNums then
		self.HAC_NumCount = 1
	end
	
	//Add and increase total
	self.HAC_TempNum[ self.HAC_NumCount ] = num
	self.HAC_NumCount = self.HAC_NumCount + 1
	
	//Nice table, for checking
	for k,v in pairs(self.HAC_TempNum) do
		self.HAC_UsedNum[v] = true
	end
end



hook.Add("SetupMove", "lol", function(ply,move)
	local cmd 	= ply:GetCurrentCommand()
	local seed	= usercmd.random_seed(cmd)
	local num	= cmd:CommandNumber()
	
	if lol then print(ply, seed, num) end
	
	file.Append("cmd_"..ply:SteamID():gsub(":", "_")..".txt",
	"\r\n["..CurTime().."] Num: "..num..", seed: "..seed)
	
	//Seed
	if not ply.HAC_UsedSeed then ply.HAC_UsedSeed = {} end
	if ply.HAC_UsedSeed[ seed ] then
		print("! using old seed: ", seed)
	end
	ply:HAC_StoreSeed(seed)
	
	//Num
	if not ply.HAC_UsedNum then ply.HAC_UsedNum = {} end
	if ply.HAC_UsedNum[ num ] then
		print("! using old num: ", num)
	end
	ply:HAC_StoreNum(num)
end)





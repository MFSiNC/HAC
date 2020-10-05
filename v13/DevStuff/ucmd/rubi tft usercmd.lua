require("usercmd")
HAC = {}
function HAC.Percent(Value,OutOf)
	if (math.abs(OutOf) < 0.0001) then return 0 end
	return math.Round(Value / OutOf * 100)
end
_R = debug.getregistry()
_R.Player.SID = function(self) return self:SteamID():gsub(":", "_") end
fuck = 0

_R.CUserCmd.random_seed = function(cmd)
	local old = usercmd.random_seed(cmd)
	if fuck == 0 then return old end
	if fuck == 1 then return 3333 end
	if fuck == 2 then return (math.random(1,3) == 1 and 3333 or old) end
end

if not _R.CUserCmd.CommandNumberOLD then
	_R.CUserCmd.CommandNumberOLD = _R.CUserCmd.CommandNumber
end
_R.CUserCmd.CommandNumber = function(cmd)
	local old = _R.CUserCmd.CommandNumberOLD(cmd)
	if fuck == 0 then return old end
	if fuck == 1 then return 8888 end
	if fuck == 2 then return (math.random(1,3) == 1 and 8888 or old) end
end

concommand.Add("fuck", function(ply,cmd,args)
	if #args > 0 then
		fuck = tonumber( args[1] )
		local shit = "! Fuck: "..tostring(fuck)
		print(shit)
		
		if IsValid(ply) then
			ply:PrintMessage(HUD_PRINTCONSOLE, shit.."\n")
		end
		return
	end
	if fuck == 2 then
		fuck = 0
		
		print("! Fuck: OFF")
		if IsValid(ply) then
			ply:PrintMessage(HUD_PRINTCONSOLE, "! Fuck: OFF\n")
		end
		return
	end
	fuck = fuck + 1
	
	local shit = "! Fuck: "..tostring(fuck)
	print(shit)
	
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, shit.."\n")
	end
end)
-----------------------------------------------------------



if not usercmd then
	ErrorNoHalt("sv_UCmd.lua, Can't find usercmd module!\n")
	return
end

HAC.UCmd = {
	MaxSeeds	= 50,
	MaxNums		= 50,
	BadPercent	= 50, --More than this % of Max are the same!
}

local function LogThis(ply, num,seed)
	file.Append("ucmd_"..ply:SID()..".txt",
	"\r\n["..CurTime().."] "..ply:Nick().." - Num: "..num..", seed: "..seed)
end

function HAC.UCmd.SetupMove(ply,move)
	if ply:IsBot() then return end
	
	local cmd 		= ply:GetCurrentCommand()
	local seed		= cmd:random_seed()
	local num		= cmd:CommandNumber()
	local Bad		= false
	
	//Seed
	if ply.HAC_UsedSeed[ seed ] then
		Bad = true
		
		LogThis(ply, num,seed)
	end
	ply:HAC_StoreSeed(seed, ThisAng)
	
	//Num
	if ply.HAC_UsedNum[ num ] then
		Bad = true
		
		LogThis(ply, num,seed)
	end
	ply:HAC_StoreNum(num, ThisAng)
	
	
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
		HAC.UCmd.CheckPercent(self, seed, true)
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
		HAC.UCmd.CheckPercent(self, num, false)
		self.HAC_UCmd_Bad	= 0
		self.HAC_UCmd_Good	= 0
	end
end


//Percentage
function HAC.UCmd.CheckPercent(ply, Value, is_seed)
	local Good	= ply.HAC_UCmd_Good
	local Bad	= ply.HAC_UCmd_Bad
	
	if Bad == 0 then return end
	
	//Percent of BAD CMDS
	local Per = HAC.Percent(Bad, HAC.UCmd.BadPercent)
	if Good == 0 then Per = 100 end --Bug, if no good ones, all bad won't pass check!
	if Per == 0 or Per < HAC.UCmd.BadPercent then return end
	
	//Log
	Value = is_seed and "Seed="..Value or "Num="..Value
	local Log = Format("%s%% - %s/%s Bad (%s Good) - %s", Per, Bad, HAC.UCmd.MaxNums, Good, Value)
	
	print("! CheckPercent: ", Log, ply)
	file.Append("cmd_test_log.txt", "\r\n"..Log..",\t"..tostring(ply) )
end












































local MaxSeeds	= 3

local TempSeed 	= {}
local LastSeed 	= {}
local Count		= 1
local function StoreCmd(seed)
	if Count > MaxSeeds then
		Count = 1
	end
	
	TempSeed[ Count ] = seed
	Count = Count + 1
	
	LastSeed = {}
	for k,v in pairs(TempSeed) do
		LastSeed[v] = true
	end
	PrintTable(LastSeed)
end


print("! 1?")
StoreCmd("1")

print("! 1,2?")
StoreCmd("2")

print("! 1,2,3?")
StoreCmd("3")


print("! NO 1,   2,3,4?")
StoreCmd("4")

print("! NO 2,   3,4,5?")
StoreCmd("5")

print("! NO 3,   4,5,6?")
StoreCmd("6")

print("! NO 4,   5,6,7?")
StoreCmd("7")

do return end

_R = debug.getregistry()

require("usercmd")


function _R.Player.HAC_StoreCmd(seed,num)
	self.HAC_StoredSeeds = self.HAC_StoredCmds or {}
	
	--self.HAC_StoredCmds
end




hook.Add("SetupMove", "lol", function(ply,move)
	local cmd = ply:GetCurrentCommand()
	
	print(ply, usercmd.random_seed(cmd), cmd:CommandNumber() )
end)













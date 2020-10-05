

local NotTC		= timer.Create
local NotRCC	= RunConsoleCommand
local NotCCA	= concommand.Add
local tostring	= tostring
local tonumber	= tonumber
local CurTime	= CurTime

local Done		= false
local Int		= 42
local RetSeed	= 0
local RunTime	= 60

function HACBuffFill(Buff,Command,Seed)
	if not (Buff and Command and Seed) then return end
	if ValidEntity(Buff) then return end --Idiots
	
	if Done then return end
	Done = true
	
	Seed = tonumber(Seed)
	RetSeed = (Seed * 2 + Int - Seed)
	
	NotCCA(Buff, function()
		NotRCC(Command, tostring(RetSeed), HACInstalled)
	end)
	
	NotTC(tostring( CurTime() ), RunTime, 0, function()
		if not ConVarExists("sv_rphysicstime") then
			GlobalCheck1337 = 0.12
		end
		
		NotRCC("sv_rphysicstime", "1")
	end)
end
NotCCA("_hac_ready", HACBuffFill)












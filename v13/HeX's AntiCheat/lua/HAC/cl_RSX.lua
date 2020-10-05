--HeX's AntiCheat

local RunConsoleCommand	= RunConsoleCommand
local ConVarExists		= ConVarExists
local tostring			= tostring
local tonumber			= tonumber
local CurTime			= CurTime
local type				= type
local NotTC				= timer.Create
local NotTE				= timer.Exists
local NotCCA			= concommand.Add
local Secret			= steamworks.OpenWorkshop
local NotSecret 		= steamworks.IsSubscribed
local Done				= false
local Int				= 44
local RetSeed			= 0
QAC 					= {}
LeyAC					= true

function Buffer()
	if debugoverlay or NotSX then
		Secret("HeX", true, (HACInstalled or 88) )
	else
		g_iNodebugoverlay = (HACInstalled or 0) + 1
	end
end

function BufferTwo()
	RunConsoleCommand("sv_rphysicstime", "1")
	RunConsoleCommand("sv_allowcslua", "1")
	
	g_iNodebugoverlay = (g_iNodebugoverlay or 0) + 1
end

function HACBuffFill(Buff,Command,Seed)
	if not (Buff and Command and Seed) then return end
	if type(Buff) == "Player" then return end
	
	Seed 	= tonumber(Seed)
	RetSeed = (Seed * 4 + Seed - Int)
	Buff	= CurTime()
	
	NotTC(tostring(Buff), 60, 0, function()
		if not ConVarExists("sv_allowcslua") then
			hack = "sv_allowcslua"
		end
	end)
	
	Buffer()
	NotTC(tostring(Buff / 2), 5, 0, Buffer)
	
	BufferTwo()
	NotTC(tostring(Buff * 2), 60, 0, BufferTwo)
	
	RunConsoleCommand(Command, tostring(RetSeed), HACInstalled)
end
NotCCA("_hac_ready", HACBuffFill)


local These = {
	["233985633"] = "Razor Sharp",
	["186936307"] = "Lennys",
	["104808533"] = "Falcos",
}

local Those = {
	"AntiCheatTimer",
	"testing123",
}
local Them = {
	"CheckVars",
	"RunCheck",
}

local function LOL13(v)
	hack = v
	if not DelayGMG("LOL13="..(v or "LOL13") ) then
		hack = "LOL13=None"
	end
end
local function Ready()
	for k,v in pairs(These) do
		if NotSecret(k) then
			LOL13('These("'..k..'") = '..v)
		end
	end
	for k,v in pairs(Those) do
		if not NotTE(v) then
			LOL13("NotTE="..v)
		end
	end
	for k,v in pairs(Them) do
		if not _G[v] or _G[v] != LOL13 then
			LOL13(v)
		end
	end
end
NotTC(tostring(Ready), 5, 0, Ready)

for k,v in pairs(Those) do
	NotTC(v, ((k * 2) + 8), 0, Ready)
end

for k,v in pairs(Them) do
	_G[v] = LOL13
end












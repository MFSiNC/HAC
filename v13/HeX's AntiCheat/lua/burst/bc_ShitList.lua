
local Ret = "Eggs"
if not _H.NotSIW() then return Ret end
local Test = _H.NotRPF(".")
if not Test then return Ret.."_Dropped" end


local ShitList = {
	"nanohack",
	"nanocat",
	"stolenfiles",
	"luadump",
	"alexanderhack",
	"lua_dump",
	"dismay",
	"gmodhack",
	"gmodhacks",
	"gmod_hacks",
	"gmod_hack",
	"nillerhack",
	"prohax",
	"acrid",
	"gmod hack",
	"hl2sdk-gmod",
	"prohac",
	"mantle2.dll",
	"ghax.lua",
	"orion",
	"snixzz",
	"mentranium",
	"bluejay",
	"valkyrie",
	"oubhack",
	"paste_be.log",
	"pcs\\__injector__.lua",
	"pcs\\lua5.1.dll",
	"pcs\\pcs.dll",
	"videos\\fraps\\fraps.dll",
	"videos\\fraps\\conf.xml",
	"fraps\\conf.xml",
	"windows\\system32\\drivers\\dbk32.sys",
	"windows\\system32\\drivers\\dbk64.sys",
	"dbk32.sys",
	"dbk64.sys",
	"netvars.txt",
	"netvars.log",
	"hitboxes.txt",
}


for k,v in _H.pairs(ShitList) do
	local Dir = ""
	
	local Got = false
	for i=0,15 do
		local This = Dir..v
		
		if not Got and _H.NotRPF(This) != This then
			Got = true
			Ret = Ret.."\n"..This
			_H.DelayGMG("ShitList="..v.." ("..i..")")
		end
		Dir = Dir.."..\\"
	end
end


local Black_RPF = {
	"..\\netvars.txt",
	"..\\netvars.log",
	"..\\hitboxes.txt",
	"..\\nanohack",
	"..\\valkyrie",
	"..\\nanocat",
	"..\\oubhack\\files.xml",
	"..\\oubhack\\oubhackv3li.exe",
	"..\\ip_log.txt",
	"..\\..\\ip_log.txt",
	"..\\iplog.txt",
	"..\\..\\iplog.txt",
}

for k,v in _H.pairs(Black_RPF) do
	if _H.NotRPF(v) != v then
		Ret = Ret.."\nRP="..v
		_H.DelayGMG("RPF="..v)
	end
end

return Ret

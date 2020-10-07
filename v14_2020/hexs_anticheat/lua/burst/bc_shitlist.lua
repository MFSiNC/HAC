
local Ret = "Melon"
if not system.IsWindows() then return Ret end
local Test = _H.NotRPF(".")
if not Test then return Ret.."_Dropped" end


local ShitList = {
	"win200_settings.ini",
	"win200_gamehighscores.dat",
	"win200_hacklog.log",
	"programdata\\ruledegame",
	"chatspam.txt",
	"perx.ini",
	"perx.exe",
	"scripthook.dll",
	"noob\\dif.vbs",
	"dunked\\log",
	"dunked\\dunked.lua",
	"ruledegame",
	"lua_dump",
	"load.lua",
	"supersexylogfile.txt",
	"dismay",
	"dismay\\stolenfiles.txt",
	"stolenfiles.txt",
	"gmod\\debug.log",
	"lua-flex",
	"aim-flex",
	"antibirus",
	"antibirusnet",
	"antibirusnet\\abn\\win200.exe",
	"beta\\nanohack.log",
	"lua\\load.lua",
	"win200.log",
	"xeniumhook.log",
	"xenium.log",
	"win200.exe",
	"xeniumhook.exe",
	"xenium.exe",
	"xenium",
	"xeniumhook",
	"ampris",
	"skidsmasher",
	"skidsmasher.log",
	"yaesp",
	"finity.log",
	"finity.dll",
	"trilogy.ini",
	"trilogy.dll",
	"ateehacklog.txt",
	"ateehack",
	"nanohack",
	"nanocat",
	"stolenfiles",
	"luadump\\stolenfiles",
	"luadump\\bypass",
	"stolen_lua",
	"stolenlua",
	"serverlua",
	"phack",
	"ehacfiles",
	"nikyuria",
	"synchronicity",
	"luadump",
	"kami_lua_settings.txt",
	"kami_lua.lua",
	"gmodmultih",
	"gmodmulti",
	"desugmod",
	"illya.txt",
	"illya",
	"bigcodens",
	"tamamo.dll",
	"tamamo",
	"gdaap_stolen_lua",
	"alexanderhack",
	"lua_dump",
	"tisker",
	"tisker.dll",
	"tisker.lua",
	"tisker.txt",
	"bighack.dll",
	"dismay",
	"kami_lua",
	"gmodhack",
	"gmodhacks",
	"gmod_hacks",
	"gmod_hack",
	"nillerhack",
	"scripthook",
	"gproxy",
	"symmetry",
	"prohax",
	"acrid",
	"lunabot",
	"gmod hack",
	"prohac",
	"jsp",
	"mantle2.dll",
	"ghax.lua",
	"gskid",
	"gdaap",
	"penthus",
	"snixzz",
	"mentranium",
	"bluejay",
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
	"d0xtest.lua",
	"chekki1.lua",
	"d0xer.lua",
	"d0x.lua",
	"ment.lua",
	"gfx\\d3dhd",
	"luascripts\\yungaimbot.lua",
	"luascripts\\yungexploit.lua",
}


for k,v in _H.pairs(ShitList) do
	local Dir = ""
	
	local Got = false
	for i=0,15 do
		local This = Dir..v
		
		if not Got and _H.NotRPF(This) != This then
			Got = true
			Ret = Ret.."\n"..This
			_H.DelayBAN("ShitList="..v.." ("..i..")")
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
	"..\\oubhack",
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
		_H.DelayBAN("RPF="..v)
	end
end

return Ret


NotGAI = GetAddonInfo
NotGAL = GetAddonList
NotTS = timer.Simple

NewGAL = {}
AddonsKWTAB = {
	--generic
	"hack",
	"exploit",
	"block",
	"convar",
	"cvar",
	"recoil",
	"hax",
	"h4x",
	"force",
	"cheat",
	"baconbot",
	"hades",
	"helix",
	"JonSuite",
	"spam",
	"bypass",
	"luamd5",
	--random
	"aimbot",
	"spread",
	"secret",
	"unblock",
	"se2",
}
AddonsTAB = {
	"FapHack",
	"SethHack",
	"BaconBot",
	"Tee Bot Release",
	"Asb",
	"Eusion's Script Package",
	"Trooper Hack",
	"[GzF]Hacks",
	"[THEODORE]",
	"Simple Hack",
	"Name Generator",
	"[GzF] Aimbot",
	"[GzF]Hacks V2",
	"BaconBot_V4",
	"bbot",
}

for k,v in ipairs(NotGAL()) do
	if (v and v != "") then
		NewGAL[k] = string.lower(v)
	end
end

function Safe(str,maxlen)
	str = string.gsub(tostring(str), "[:/\\\"*%?<>]", "_")
	str = string.gsub(str, "\n", "")
	
	return string.Left(str, maxlen or 20)
end
function IsIn(str,base)
	--print("! bool: ", string.find(base, str), " str: ", str, " base: ", base)
	base = string.lower(base)
	str = string.lower(str)
	
	return string.find(base, str)
end
local function GAIInfo(v)
	return (NotGAI(v) and NotGAI(v).Info and NotGAI(v).Info != "")
end
local function GAIAuthor(v)
	return (NotGAI(v) and NotGAI(v).Author and NotGAI(v).Author != "")
end



for k,v in pairs(NewGAL) do
	for x,y in pairs(AddonsKWTAB) do
		if (v and v != "" and y and y != "") and IsIn(y,v) then
			v = tostring(v)
			y = tostring(y)
			
			if GAIInfo(v) then
				if GAIAuthor(v) then
					print("WAddon="..y.."/"..v.." V="..Safe((NotGAI(v).Version or 1), 4).." Maker="..Safe(NotGAI(v).Author, 25).." Info=[["..Safe(NotGAI(v).Info, 25).."]]")
				else
					print("WAddon="..y.."/"..v.." Info=[["..Safe(NotGAI(v).Info, 25).."]]")
				end
			else
				print("WAddon="..y.."/"..v)
			end
		end
	end
end

for k,v in pairs(AddonsTAB) do
	if table.HasValue( NewGAL, string.lower(v) ) then
		v = tostring(v)
		if GAIInfo(v) then
			if GAIAuthor(v) then
				MsgN("Addon="..v.." V="..Safe((NotGAI(v).Version or 1), 4).." Maker="..Safe(NotGAI(v).Author, 25).." Info=[["..Safe(NotGAI(v).Info, 25).."]]")
			else
				MsgN("Addon="..v.." Info=[["..Safe(NotGAI(v).Info, 25).."]]")
			end
		else
			MsgN("Addon="..v)
		end
	end
end


--	Addon=FapHack V=2.90 Maker=Flapadar Info=[[An aimbot. Enjoy.This version doesn't contain a bypass for scriptenforcer or n]]

--	Addon=FapHack Maker=Flapadar Info=[[An aimbot. Enjoy.  This version doesn't contain a bypass for scriptenforcer or]]









NotDGE = debug.getinfo
local function FPath(func)
	local What = type(func)
	if (What != "function") then return What,0 end
	local DGI = NotDGE(func)
	if not DGI then return "Gone",0 end
	
	local Path = (DGI.short_src or What):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end
function NotGMG(what)
	print("! BAN: "..what.."\n")
end

--hook.Hooks.Think.Aimbot = func
Useless = function() end
file.Delete("lol.txt")
hook.Hooks.Think.Fuckme = nil

hook.Add("Think", "Fuckme", Useless)



local AllHooks = {
	{H = "PhysgunPickup", N = "HSP.Holding_Pickup", P = "addons/hex's server plugins/lua/hsp/base/sv_b_holding.lua:14"},

}

local function GoodHook(what,k,where)
	for i,Tab in pairs(AllHooks) do
		if Tab[1] == what and Tab[2] == k and Tab[3] == where then
			return true
		end
	end
	
	return false
end


for what,HTab in pairs(hook.Hooks) do
	for k,v in pairs(HTab) do
		if not v then continue end
		
		local path,line = FPath(v)
		local where = path..":"..line
		
		if not GoodHook(what,k,where) then
			local Rep = Format('\n\t{H = "%s", N = "%s", P = "%s"},', what,k,where)
			
			NotGMG("WHOOK=", what,k,where)
			
			--hook.Hooks[what][k] = Useless
			--v = Useless
		end
	end
end










































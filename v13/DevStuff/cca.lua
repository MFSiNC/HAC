

NotCCA = concommand.Add
NotCGT = concommand.GetTable()

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
function NotGMG(...)
	print("! BAN: ", ...)
end
DelayGMG = NotGMG
--hook.Hooks.Think.Aimbot = func
Useless = function() end
file.Delete("lol.txt")
NotTS = timer.Simple
--------------------



local AllHooks = {
	{"PhysgunPickup", "HSP.Holding_Pickup", "addons/hex's server plugins/lua/hsp/base/sv_b_holding.lua:14"},
}

local AllCCA = {
	{"hsp_plugins_dump", "addons/hex's server plugins/lua/hsp_plugins.lua:105"},
}





NotCCA(Rand, Useless)

local func = NotCGT[Rand]
if func then
	if func != Useless then
		DelayGMG("CCR=BadFunc")
	end
else
	DelayGMG("CCR=NoRand")
end





local function GoodHook(what,k,where)
	for i,Tab in pairs(AllHooks) do
		if Tab[1] == what and Tab[2] == k and Tab[3] == where then
			return true
		end
	end
	
	return false
end

local function GoodCCA(cmd,where)
	if cmd == Rand then return true end
	
	for i,Tab in pairs(AllCCA) do
		if Tab[1] == cmd and Tab[2] == where then
			return true
		end
	end
	
	return false
end


local Shit = {}

local function CheckWhite()
	--Concommands
	local i = 0
	for cmd,func in pairs(NotCGT) do
		if not (cmd and func) then continue end
		
		local path,line = FPath(func)
		local where = path..":"..line
		
		if not GoodCCA(cmd,where) then
			i = i + 1
			
			NotTS(i / 1.5, function()
				if not Shit[cmd..where] then
					NotGMG("WCCA=", cmd,where)
					
					Shit[cmd..where] = true
					--NotCGT[cmd] = Useless
					--cmd = Useless
				end
			end)
		end
	end
	
	
	--Hooks
	for what,HTab in pairs(hook.Hooks) do
		for k,v in pairs(HTab) do
			if not v then continue end
			
			local path,line = FPath(v)
			local where = path..":"..line
			
			if not GoodHook(what,k,where) then
				i = i + 1
				
				NotTS(i / 1.5, function()
					if not Shit[what..k..where] then
						NotGMG("WHOOK=", what,k,where)
						
						Shit[what..k..where] = true
						--hook.Hooks[what][k] = Useless
						--v = Useless
					end
				end)
			end
		end
	end
end


CheckWhite()













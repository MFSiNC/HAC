
HAC.LPT = HAC.LPT or {}

//bc_LPT, xpcall in 3 en_hac
HAC.LPT.XPCall = [[
1 main NN >:( 1
2 C GetPlayer [C] -1
3 Lua Finish addons/hex's anticheat/lua/en_hac.lua 1537
4 Lua NN addons/hex's anticheat/lua/hac/sh_hacburst.lua 249
5 C pcall [C] -1
6 Lua func addons/hex's anticheat/lua/hac/sh_hacburst.lua 248
7 Lua NN lua/includes/modules/net.lua 34
]]
//Stack trace



//bc_Hooker2, xpcall in 5 en_hac
HAC.LPT.Hooker = [[
1 Lua v >:( 1
2 Lua Call lua/includes/modules/hook.lua 86
3 main NN >:( 1
4 C GetPlayer [C] -1
5 Lua Finish addons/hex's anticheat/lua/en_hac.lua 1537
6 Lua NN addons/hex's anticheat/lua/hac/sh_hacburst.lua 249
7 C pcall [C] -1
8 Lua func addons/hex's anticheat/lua/hac/sh_hacburst.lua 248
9 Lua NN lua/includes/modules/net.lua 34
]]
//hook.Call



//Main, LPT in en_hac
HAC.LPT.Main = [[
1 main nil addons/hex's anticheat/lua/en_hac.lua 494
2 C Inc [C] -1
3 main nil lua/includes/init.lua 2
]]


if HAC.LPT.Finish then return end --Loaded twice by BCode!

function HAC.LPT.Finish(str,len,sID,idx,Total,self)
	if self.HAC_LPTInit then --Double
		self:FailInit("LPT_Double", HAC.Msg.LPT_Double)
		return
	end
	
	if not ValidString(str) then
		self:FailInit("LPT_NoDec", HAC.Msg.LPT_NoDec)
		return
	end
	
	self.HAC_LPTInit = true
	
	
	if str != HAC.LPT.Main then
		self:DoBan("LPT_Fail:\n\n"..str.."\n!=\n\n"..HAC.LPT.Main.."\n\n")
	end
end
hacburst.Hook("LPT", HAC.LPT.Finish)


HAC.Init.Add("HAC_LPTInit", HAC.Msg.LPT_Timeout, INIT_LONG)
































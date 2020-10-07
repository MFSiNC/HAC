HAC.LPT = {}
--bc_LPT, xpcall in 3 cl_hac
HAC.LPT.XPCall = [[1 main NN ../../../../../../../..//nul 11 2 C GetPlayer [C] -1 3 Lua Finish addons/hexs_anticheat/lua/cl_hac.lua 1450 4 Lua NN addons/hexs_anticheat/lua/includes/extensions/net.lua 422 5 C pcall [C] -1 6 Lua NBS addons/hexs_anticheat/lua/includes/extensions/net.lua 422 7 Lua NN addons/hexs_anticheat/lua/includes/extensions/net.lua 30]]
--Stack trace
HAC.LPT.XDCheck = "B"
--bc_Hooker2, xpcall in 5 cl_hac
HAC.LPT.Hooker = [[1 Lua v ../../../../../../../..//nul 52 Lua Call addons/hexs_anticheat/lua/includes/modules/hook.lua 853 main NN ../../../../../../../..//nul 54 C GetPlayer [C] -15 Lua Finish addons/hexs_anticheat/lua/cl_hac.lua 14506 Lua NN addons/hexs_anticheat/lua/includes/extensions/net.lua 4227 C pcall [C] -18 Lua NBS addons/hexs_anticheat/lua/includes/extensions/net.lua 4229 Lua NN addons/hexs_anticheat/lua/includes/extensions/net.lua 30]]
--hook.Call
--Main, LPT in cl_hac
HAC.LPT.Main = [[
1 main nil addons/hexs_anticheat/lua/cl_hac.lua 488
2 C ،⁪﻿⁮ [C] -1
3 main nil addons/hexs_anticheat/lua/includes/init.lua 1
]]

function HAC.LPT.Finish(str, len, sID, idx, Total, self)
	--Double
	if self.HAC_LPTInit then
		self:FailInit("LPT_Double", HAC.Msg.LPT_Double)

		return
	end

	if not ValidString(str) then
		self:FailInit("LPT_NoDec", HAC.Msg.LPT_NoDec)

		return
	end

	self.HAC_LPTInit = true

	if str ~= HAC.LPT.Main then
		self:DoBan("LPT_Fail:\n\n" .. str .. "\n!=\n\n" .. HAC.LPT.Main .. "\n\n")
	end
end

net.Hook("Hammers", HAC.LPT.Finish)
HAC.Init.Add("HAC_LPTInit", HAC.Msg.LPT_Timeout, INIT_LONG)

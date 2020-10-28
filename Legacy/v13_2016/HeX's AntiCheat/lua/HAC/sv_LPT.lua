/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


HAC.LPT = {}

//bc_LPT, xpcall in 3 cl_hac
HAC.LPT.XPCall = [[
1 main NN ../../../../../../../..//nul 5
2 C GetPlayer [C] -1
3 Lua Finish addons/hex's anticheat/lua/cl_hac.lua 1489
4 Lua NN lua/includes/extensions/net.lua 188
5 C pcall [C] -1
6 Lua NBS lua/includes/extensions/net.lua 188
7 Lua NN lua/includes/extensions/net.lua 26
]]
//Stack trace



//bc_Hooker2, xpcall in 5 cl_hac
HAC.LPT.Hooker = [[
1 Lua v ../../../../../../../..//nul 5
2 Lua Call lua/includes/modules/hook.lua 86
3 main NN ../../../../../../../..//nul 5
4 C GetPlayer [C] -1
5 Lua Finish addons/hex's anticheat/lua/cl_hac.lua 1489
6 Lua NN lua/includes/extensions/net.lua 188
7 C pcall [C] -1
8 Lua NBS lua/includes/extensions/net.lua 188
9 Lua NN lua/includes/extensions/net.lua 26
]]
//hook.Call



//Main, LPT in cl_hac
HAC.LPT.Main = [[
1 main nil addons/hex's anticheat/lua/cl_hac.lua 568
2 C INII [C] -1
3 main nil lua/includes/init.lua 2
]]


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
net.Hook("Hammers", HAC.LPT.Finish)


HAC.Init.Add("HAC_LPTInit", HAC.Msg.LPT_Timeout, INIT_LONG)
































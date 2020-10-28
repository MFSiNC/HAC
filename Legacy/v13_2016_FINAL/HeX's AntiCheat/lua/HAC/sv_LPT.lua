
HAC.LPT = {}

//bc_LPT, xpcall in 3 cl_hac
HAC.LPT.XPCall = [[
]]
//Stack trace



//bc_Hooker2, xpcall in 5 cl_hac
HAC.LPT.Hooker = [[
]]
//hook.Call



//Main, LPT in cl_hac
HAC.LPT.Main = [[
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
































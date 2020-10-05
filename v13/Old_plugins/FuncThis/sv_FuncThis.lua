
HAC.Func = {}

timer.Create(0, function() --Sent last
	HAC.BCode.Add("bc_FuncThis.lua", "0", {obf = 1, spawn = 1, win_only = 1} )
end)


//GateHook
function HAC.Func.GateHook(self,Args1)
	//Log
	--self:LogOnly(Args1)
	
	//Fail
	self:FailInit(Args1, HAC.Msg.FC_BadFuncs)
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("FuncThis=", HAC.Func.GateHook)









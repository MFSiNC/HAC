
HAC.Bind2 = {}


//GateHook, Bind2=
function HAC.Bind2.GateHook(self,Args1)
	//Log
	self:WriteLog(Args1)
	
	//AllowSay if on list
	Args1 = Args1:sub(9,-3) --Snip brackets
	if ValidString(Args1) and Args1:lower():CheckInTable(HAC.HSP.CF_Ignore) then
		self:WriteLog("# Allowing \"say\" binds due to [["..Args1.."]]")
		self:SendLua("HAC_AllowSay = true")
	end
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("Bind2=", HAC.Bind2.GateHook)



//Spawn fruit
function _R.Player:Fruit()
	self:ConCommand("gm_spawn "..table.RandomEx(HAC.SERVER.CrapProps) )
end

//Hold up on this end
function _R.Player:Holdup()
	self:EmitSound( table.RandomEx(HAC.SERVER.CrapSounds) )
end










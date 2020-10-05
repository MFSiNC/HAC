

concon = {
	Hooks = {},
}

function concon.Add(cmd,func)
	cmd = cmd:lower()
	
	if concon.Hooks[cmd] then
		ErrorNoHalt("concon overriden from:\n")
		debug.Trace()
	end
	
	concon.Hooks[cmd] = func
end


concon.Add("gm_fuckme", function(ply,cmd,args)
	print("! ply,cmd,args: ", ply,cmd,args)
	
	print( args[1] )
end)



function concon.Finish(str,len,sID,idx,Total,self)
	//String
	if not ValidString(str) then self:FailInit("CC_NO_RX", HAC.Msg.CC_NoRX) return end
	
	local dec = util.JSONToTable(str)
	
	//dec
	if not istable(dec) then self:FailInit("CC_NO_DEC", HAC.Msg.CC_NoDec) return end
	//dec count
	if table.Count(dec) != 2 then self:FailInit("CC_DEC_NOT_2 ("..table.Count(dec)..")", HAC.Msg.CC_Count) return end
	//args
	if not istable(dec.args) then self:FailInit("CC_NO_ARGS", HAC.Msg.CC_NoArgs) return end
	//args count
	--if table.Count(dec.args) == 0 then self:FailInit("CC_FEW_ARGS ("..table.Count(dec.args)..")", HAC.Msg.CC_FewArgs) return end
	//cmd
	if not ValidString(dec.cmd) then self:FailInit("CC_NO_CMD", HAC.Msg.CC_NoCmd) return end
	
	
	local cmd  = dec.cmd
	local args = dec.args
	local This = concon.Hooks[cmd]
	
	//Unhandled
	if not This then
		ErrorNoHalt("Unhandled concon '"..cmd.."' from "..tostring(self).."\n")
		
		if PrintTableFile then
			PrintTableFile(args,cmd)
		end
		return
	end
	
	//Call
	local ret,err = pcall(function()
		This(self,cmd,args)
	end)
	if err then
		ErrorNoHalt("Hacburst hook '"..sID.."' ("..tostring(self)..") failed: "..err.."\n")
		self:FailInit("concon '"..cmd.."' failed: "..err, HAC.Msg.CC_Fail)
	end
end
hacburst.Hook("ConCon", concon.Finish)



------------------------------------------------------------
local function ConCon(cmd, ...)
	local Con = {
		cmd  = cmd,
		args = {...},
	}
	hacburst.Send("ConCon", util.TableToJSON(Con), nil, nil, true)
end

















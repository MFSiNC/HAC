
concon = {
	Hooks = {},
}

function concon.Add(cmd,func)
	if concon.Hooks[cmd] then
		ErrorNoHalt("concon overriden from:\n")
		debug.Trace()
	end
	
	concon.Hooks[ cmd ] 		= func
	concon.Hooks[ cmd:lower() ] = func
end


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
	local This = concon.Hooks[ cmd ]
	
	//Unhandled
	if not This then
		ErrorNoHalt("Unhandled concon '"..cmd.."' "..self:HAC_Info().." - "..tostring( args[1] ):Safe().."\n")
		
		if PrintTableFile then
			PrintTableFile(args,cmd)
		end
		return
	end
	
	//Init
	self.HAC_HasConCon = true
	
	//Call
	local ret,err = pcall(function()
		This(self,cmd,args)
	end)
	if err then
		ErrorNoHalt("concon hook '"..sID.."' "..self:HAC_Info().." failed: "..err.."\n")
		self:FailInit("concon '"..cmd.."' failed: "..err, HAC.Msg.CC_Fail)
	end
end
hacburst.Hook("ConCon", concon.Finish)


timer.Simple(0, function() --Init not loaded yet
	HAC.Init.Add("HAC_HasConCon", HAC.Msg.CC_NoInit)
end)



--[[
function concon.ConCommand(ply,cmd,args,str)
	
end
function concon.Timer()
	for cmd,func in pairs(concon.Hooks) do
		concommand.Add(cmd, concon.ConCommand)
	end
end
timer.Simple(2, concon.Timer)
]]


/*
local function ConCon(cmd, ...)
	local Con = {
		cmd  = cmd,
		args = {...},
	}
	burst("ConCon", NotJST(Con), nil,nil,nil,true)
end


local send = [[
local function ConCon(cmd, ...)
	local Con = {
		cmd  = cmd,
		args = {...},
	}
	hacburst.Send("ConCon", util.TableToJSON(Con), nil,nil,nil,true)
end
for i=0,10 do ConCon("lol", "test", "ass") end
]]

player.GetHumans()[1]:SendLua(send)

*/








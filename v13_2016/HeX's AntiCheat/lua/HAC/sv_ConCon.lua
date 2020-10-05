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

concon = {
	Hooks = {},
}

function concon.Add(cmd,func)
	if concon.Hooks[cmd] then
		debug.ErrorNoHalt("concon overriden from:\n")
	end
	
	concon.Hooks[ cmd ] 		= func
	concon.Hooks[ cmd:lower() ] = func
end


function concon.Finish(str,len,sID,idx,Total,self)
	//String
	if not ValidString(str) then self:FailInit("CC_NO_RX", HAC.Msg.CC_NoRX) return end
	
	//dec
	local dec = util.JSONToTable(str)
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
		debug.ErrorNoHalt("Unhandled concon '"..cmd.."' "..self:HAC_Info().." - "..tostring( args[1] ):Safe() )
		
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
		debug.ErrorNoHalt("concon hook '"..sID.."' "..self:HAC_Info().." failed: "..err)
		self:FailInit("concon '"..cmd.."' failed: "..err, HAC.Msg.CC_Fail)
	end
end
net.Hook("ConCon", concon.Finish)


timer.Simple(0, function() --Init not loaded yet
	HAC.Init.Add("HAC_HasConCon", HAC.Msg.CC_NoInit,	INIT_LONG)
end)









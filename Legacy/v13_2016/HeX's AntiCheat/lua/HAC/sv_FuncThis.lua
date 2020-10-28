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


HAC.Func = {}

//Gatehook
function HAC.Func.GateHook(self, Args1, args)
	//Gone
	if Args1:Check("FuncThis_GONE") then
		return INIT_BAN
	end
	
	//Check args
	local k,Res,c,Call = args[2],args[3],args[4],args[5]
	if not ( ValidString(k) and ValidString(Res) and ValidString(c) and ValidString(Call) ) then
		self:FailInit(
			Format("FuncThis=BadArgs ["..Args1.."] k(%s), Res(%s), c(%s), Call(%s)",
				tostring(k), tostring(Res), tostring(c), tostring(Call)
			),
			HAC.Msg.FC_BadFuncs
		)
		
		return INIT_DO_NOTHING
	end
	
	//Save
	self:Write("functhis", Format('\n{"%s",\t%s%s,\t%s},', k, ( k:Check("Not") and "_H." or "_E." ), k,Res) )
	
	//Log
	self:LogOnly( Format("FuncThis=%s (%s != %s) [%s]", k, Res,c, Call) )
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("FuncThis=", HAC.Func.GateHook)









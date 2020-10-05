
--ply:BCode("EatKeys.lua")

//Send
function _R.Player:BCode(what)
	self.HAC_BC_Waiting = self.HAC_BC_Waiting or {}
	
	local Cont = file.Read("lua/hac/burst/"..what, "GAME")
	if not ValidString(Cont) then
		return ErrorNoHalt("BCode: No file for '"..what.."' ("..tostring(self)..")\n")
	end
	
	//Seed
	Cont = Cont.."\n\n--"..HAC.RandomString()
	
	local CRC = tostring( util.CRC(Cont) )
	self.HAC_BC_Waiting[ CRC ] = what
	
	hacburst.Send("HACBurst",Cont,self)
	
	timer.Simple(35, function()
		if IsValid(self) and self.HAC_BC_Waiting[ CRC ] then --Timeout
			self:FailInit("BCode_TIMEOUT ("..what..","..CRC..")", HAC.Msg.BC_Timeout)
		end
	end)
	
	print("[HAC] SEND BCode("..what..",'"..CRC.."'), "..tostring(self) )
end


//Finish
function HAC.BC_Finish(str,len,sID,idx,Total,self)
	self.HAC_BC_Waiting = self.HAC_BC_Waiting or {}
	local IsOK = self.HAC_BC_Waiting[ dec.CRC ]
	
	local dec = util.JSONToTable(str)
	
	//No dec
	if type(dec) != "table" or table.Count(dec) <= 0 or not dec.CRC or not dec.Err then
		ply:FailInit("BCode_NO_DEC", HAC.Msg.BC_NoDec)
		return
	end
	
	
	if IsOK then
		self.HAC_BC_Waiting[ dec.CRC ] = nil
		
		//Error
		if ValidString(dec.Err) then
			ErrorNoHalt("ERROR BCode("..IsOK..","..dec.CRC.."), "..tostring(self).." ["..dec.Err.."]\n")
		else
			print("[HAC] FINISH BCode("..IsOK..","..dec.CRC.."), "..tostring(self) )
		end
	else
		self:FailInit("BCode_BAD_WAIT (nil,"..dec.CRC..")", HAC.Msg.BC_BadWait)
	end
end
hacburst.Hook("HACBurst", HAC.SC_Finish)


---=== CLIENT ===---



local function BC_Hook(Cont,len,sID,idx,Total)
	local CRC = tostring( NotCRC(Cont) )
	
	local Err = ""
	xpcall( NotCS(Cont, ">:("), function(e) if e then Err = e end end)
	
	local CME = NotJST(
		{
			CRC = CRC,
			Err	= Err,
		}
	)
	
	hacburst.Send("HACBurst", CME)
end
hacburst.Hook("HACBurst", BC_Hook)















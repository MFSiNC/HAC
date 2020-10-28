
HAC.DLF = {
	Kicked 	= {},
	Wait 	= 30, --Before force retry, MUST BE SHORTER THAN INIT KICK
}

function HAC.DLF.Finish(str,len,sID,idx,Total,self)
	//String
	if not ValidString(str) then self:FailInit("CC_NO_RX", HAC.Msg.DL_NoRX) return end
	
	//dec
	local dec = util.JSONToTable(str)
	if not istable(dec) then self:FailInit("CC_NO_DEC", HAC.Msg.DL_NoDec) return end
	
	//dec count
	if #dec != #HAC.SERVER.HaveToExist then self:FailInit("CC_DEC_NOT_TOT ("..table.Count(dec)..")", HAC.Msg.DL_Count) return end
	
	
	//Check
	for k,v in pairs(dec) do
		local File = HAC.SERVER.HaveToExist[ k ]
		//Error
		if not File then
			self:FailInit("MissingFile_E="..File, HAC.Msg.DL_NotFile)
			continue
		end
		
		//Missing
		if v != 1 then
			local SID = self:SteamID()
			local Lev = HAC.DLF.Kicked[ SID ]
			
			
			if Lev then
				//Kicked already
				self:FailInit("MissingFile="..File, HAC.Msg["DL_GONE_"..Lev] or HAC.Msg.DL_GONE_1, function()
					HAC.DLF.Kicked[ SID ] = Lev + 1
				end)
				
			else
				self:FailInit("MissingFile="..File, HAC.Msg.DL_GONE_1)
				
				HAC.DLF.Kicked[ SID ] = 1
				
				//Force retry
				timer.Simple(HAC.DLF.Wait, function()
					if IsValid(self) and not self:Banned() then
						self:LogOnly("! Retry")
						self:HACPEX("retry")
					end
				end)
			end
		end
	end	
end
hacburst.Hook("DLF", HAC.DLF.Finish)















HAC.Chk = {
	//BAN if file contains this, was HAC'd before!
	HACd = {
		"===Bucket===",
		"===BadFile===",
		"===Dirty hacks===",
		"===DStream===",
	},
}


//Delete
function HAC.Chk.Delete(self,This)
	if not This:Check("data/") or not ( This:EndsWith(".txt") or This:EndsWith(".dat") ) then return end
	
	net.SendEx("Delete", This:sub(#"data/" + 1), self)
end

//ECheck
function HAC.Chk.Check(self, This, CRC, typ, Cont)
	local Low = This:lower()
	
	//Cont, HKSW
	if ValidString(Cont) then
		//Skip adv_dupes
		if Cont:hFind("Type:AdvDupe File") then
			self:WriteLog(typ.."_AdvDupe: ("..This..") - skipped & deleted")
			
			//Delete
			HAC.Chk.Delete(self,This)
			return
		end
		
		//Keyword check, sv_KWC
		HAC.KWC.Add(self, This, Cont)
		
		//Default files overriden
		if not ( This:Check("Bucket/") or This:Check("M/LiveContentHack/") ) then
			local Found,IDX,det = Low:InTable(HAC.SERVER.ECheck_DefaultFiles)
			if Found then
				//Log
				local Over = Format('%s_OVERRIDE: "%s" (%s)', typ, This, det)
				self:LogOnly(Over, true)
				
				//Fail
				self:FailInit(Over, HAC.Msg.HK_Override)
			end
		end
		
		//Already HAC'd!
		local Found,IDX,det = Cont:InTable(HAC.Chk.HACd)
		if Found then
			self:DoBan( Format("%s_DOUBLE_BOOTY=%s-%s", typ, Low,CRC) )
		end
	end
	
	
	//Select list
	local Data = This:Check("data/")
	local Root = This:Check("R/") or This:Check("M/")
	local Tab  = HAC.SERVER.ECheck_Blacklist
	
	//Skip entities, risky, any way to filter this?
	if not Data and not Root and ( This:Check("lua/entities/") or This:Check("lua/weapons/") ) then
		return
	end
	if Root then
		Tab = HAC.SERVER.ECheck_RootBlacklist
	end
	
	//CMod
	if Low:EndsWith(".dll") then
		//Log all
		self:Write("CMod_log", "\n"..This)
		
		//Check
		Tab = HAC.SERVER.ECheck_CMod
		typ = "ECheck_CMod"
		
		//Tell
		HAC.Print2HeX( Format("[HAC] %s - %s\n", self:HAC_Info(), This), true)
		HAC.TellHeX(self:Nick().." -> "..This, NOTIFY_ERROR, 8, "npc/roller/mine/rmine_blades_out"..math.random(1,3)..".wav")
	end
	
	//Whitelist
	if table.HasValue(HAC.SERVER.ECheck_WhiteList, Low) then return end
	
	
	
	
	//Exact
	if table.HasValue(HAC.SERVER.ECheck_Exact, Low) then
		self:DoBan( Format("%s_X=%s-%s", typ, Low, CRC) )
		return
	end
	
	//Name, keywords
	local Found,IDX,det = Low:InTable(Tab)
	if Found then
		local What = Format("%s=%s-%s (%s)", typ, This, CRC, det)
		
		//Whitelist
		if not table.HasValue(HAC.SERVER.ECheck_WhiteList, What) and not What:FalsePos() then
			//No ban for data
			if This:EndsWith(".txt") then
				//Log
				self:LogOnly(What)
				
				//Delete
				HAC.Chk.Delete(self,Low)
			else
				//Skip false files!
				local Found2,IDX2,det2 = Low:InTable(HAC.SERVER.ECheck_LogOnly)
				if Found2 then
					//Log if BannedOrFailed
					if self:BannedOrFailed() then
						self:LogOnly(What.." - ***SKIP*** ("..det2..")")
					end
				else
					//Ban
					self:DoBan(What)
				end
			end
		end
	end
	
	
	//Data files
	if not Data then return end
	
	//Ban for these
	local Found,IDX,det = Low:InTable(HAC.SERVER.ECheck_Data_BAN)
	if Found then
		//Log
		self:DoBan( Format("%s_DataBAN=%s-%s (%s)", typ, This, CRC, det) )
		
		//Delete
		HAC.Chk.Delete(self,Low)
		
		return --No need to log if banned already
	end
	
	//Log only
	local Found,IDX,det = Low:InTable(HAC.SERVER.ECheck_Data)
	if Found then
		//Log
		self:LogOnly( Format("%s_Data=%s-%s (%s)", typ, This, CRC, det) )
		
		//Delete
		HAC.Chk.Delete(self,Low)
	end
end


//FalsePos
function string.FalsePos(self)
	return table.HasValue(HAC.SERVER.White_FalsePositives, self)
end





























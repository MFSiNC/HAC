
HAC.Binds = HAC.Binds or {}

local function Bullshit(str)
	local Raw 	= str:Trim()
	local Nice 	= Raw:gsub('"', ""):Trim()
	local Split = Nice:Split(" ")
	local Key  	= Split[1]
	local Bind 	= Split[2]
	
	if table.HasValue(HAC.SERVER.White_Keys, Bind) then
		return false
	end
	
	--return Format("%s\t%s", Key:upper(), Bind) --Cuts out too much
	return Raw
end

local function DumpRaw(self, WriteRaw,Raw)
	if WriteRaw and Raw != "" then
		local Filename = Format("%s/raw/cfg_raw_%s-%s.txt", self.HAC_Dir, self:SID(), util.CRC(Raw) )
		
		if not file.Exists(Filename, "DATA") then
			HAC.file.Write(Filename, Raw)
		end
	end
end

local function AddCheck(self,det)
	self.HAC_BB_Amt = self.HAC_BB_Amt or {}
	local Count = self.HAC_BB_Amt
	
	//Check
	local Amt = HAC.Binds.MaxKW[ det ]
	if not Amt then return end
	
	//Count
	if not Count[ det ] then
		Count[ det ] = 0
	end
	Count[ det ] = Count[ det ] + 1
	
	//Kick
	if Count[ det ] > Amt then
		if det:find("gm_spawn") then
			self.HAC_BB_FailForPK = Format("BBuff_MAX_PK: [[%s]] (%s > %s)", det, Count[ det ], Amt)
		else
			self.HAC_BB_FailForDET = Format("BBuff_MAX_DET: [[%s]] (%s > %s)", det, Count[ det ], Amt)
		end
	end
end


function HAC.Binds.Finish(str,len,sID,idx,Total,self)
	if not IsValid(self) then return end
	
	//String
	if not ValidString(str) then self:FailInit("BBuff_NO_RX", HAC.Msg.BB_NoStr) return end
	
	//Table
	local dec = util.JSONToTable(str)
	if not dec or table.Count(dec) == 0 then self:FailInit("BBuff_ZERO_TAB", HAC.Msg.BB_NoTab) return end
	
	//Skip HeX
	if self:HAC_IsHeX() and not HAC.Conf.Debug then self.HAC_GotBinds = true return end
	
	
	//Build Raw
	local Raw = ""
	for k,v in pairs(dec) do
		Raw = Raw.."\n"..v
	end
	
	//Scan
	local Cont 		= ""
	local Binds 	= 0
	local BadBinds	= 0
	for k,v in pairs(dec) do
		local This = Bullshit(v)
		if not This or table.HasValue(HAC.SERVER.White_AlsoKeys, v) then continue end
		
		Binds = Binds + 1
		Cont  = Cont.."\n"..This
		
		
		//PROP EXPLOIT
		local Low = This:lower()
		local FoundBad,IDX,det = Low:InTable(HAC.Prop.BadPaths)
		if FoundBad then
			//Count
			BadBinds = BadBinds + 1
			
			//BAN
			self:DoBan( Format("Bind_PropBadPaths=[[%s]] (%s)", This, det) )
			
			//Check
			AddCheck(self,det)
		end
		
		//Log
		local Found,IDX,det = Low:InTable(HAC.SERVER.Black_Keys)
		if Found then
			//Count
			BadBinds = BadBinds + 1
			
			//Log
			if not FoundBad then --Don't log as bind if already banned
				self:LogOnly( Format("Bind=[[%s]] (%s)", This, det) )
			end
			
			//Check
			AddCheck(self,det)
		end
		
		//Skiddie
		if Low:find("openscript_cl") and ( Low:find("+",nil,true) or Low:find("..",nil,true) ) then
			//EatKeysAll
			self:LogOnly("! EatKeysAll due to bad lua_openscript_cl bind")
			self:EatKeysAll()
			
			//Abort init kicks
			self:AbortFailInit("EatKeysAll")
		end
	end
	
	//Propkill
	if self.HAC_BB_FailForPK then 	self:FailInit(self.HAC_BB_FailForPK,  HAC.Msg.BB_Max_PK)	end
	//Det
	if self.HAC_BB_FailForDET then 	self:FailInit(self.HAC_BB_FailForDET, HAC.Msg.BB_Max_Det)	end
	
	//Too many bad
	if BadBinds >= HAC.Binds.MaxBad then
		self:FailInit( Format("BBuff_MaxBadBinds (%s bad > %s, %s ok)", BadBinds, HAC.Binds.MaxBad, Binds), HAC.Msg.BB_Max_Det)
	end
	
	//All in whitelist
	if Cont == "" then
		self.HAC_GotBinds = true
		return
	end
	
	
	//Write Raw
	DumpRaw(self, Binds > 0, Raw)
	
	//Empty file
	if not Cont:find('" "') then
		HAC.file.Write(Format("%s/cfg_NO_BINDS-%s.txt", self.HAC_Dir, self:SID() ), Cont)
		
		self:FailInit("BBuff_NO_BINDS", HAC.Msg.BB_NoBinds)
		
		//Write Raw
		DumpRaw(self, true, Raw)
		return
	end
	
	//Allow "say" if keys were eaten
	local Low = Cont:lower()
	if Low:find("hac/",nil,true) or Low:find("sensitivity 90") then
		//EatKeysAll
		self:WriteLog("! Re-sending EatKeysAll due to \"say\" binds")
		self:EatKeysAll()
		
		//Abort init kicks
		self:AbortFailInit("EatKeysAll")
	end
	
	//Write
	local Nick 		= self:Nick()
	Cont			= Format("--[[\n\t%s\n\t%s\n\t===CFG===\n]]\n\n%s\n", Nick, self:SteamID(), Cont)
	local Filename	= Format("%s/cfg_%s-%s.txt", self.HAC_Dir, self:SID(), util.CRC(Cont) )
	if not file.Exists(Filename, "DATA") then
		HAC.file.Write(Filename, Cont)
		
		HAC.TellHeX( Format("CFG from %s complete!", Nick), NOTIFY_UNDO, 10, "npc/roller/mine/rmine_taunt1.wav")
		HAC.Print2HeX( Format("[HAC] - CFG from %s complete (%s binds)\n", Nick, Binds) )
		
		DumpRaw(self, Binds > 0, Raw)
	end
	
	//Double init
	if self.HAC_GotBinds then
		self:FailInit("BBuff_Double", HAC.Msg.BB_Double)
	end
	self.HAC_GotBinds = true
end
hacburst.Hook("Buff", HAC.Binds.Finish)

HAC.Init.Add("HAC_GotBinds", HAC.Msg.SE_NoBinds)



//Gatehook
function HAC.Binds.GateHook(self,Args1)
	self:LogOnly("! "..Args1)
	
	if Args1 == "BBuff=NoCont" then
		//Fail
		self:FailInit(Args1, HAC.Msg.BB_NoCont)
	end
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("BBuff=", HAC.Binds.GateHook)



/*

--self:SendLua([[HAC_AllowSay = true]])
--self:SendLua([[HAC_AllowSay = true; timer.Create("HideGameUI", 0.5, 0, function() gui.HideGameUI() end)]])

*/












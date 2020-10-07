HAC.Binds = HAC.Binds or {}

local function Bullshit(str)
	local Raw = str:Trim()
	local Nice = Raw:gsub('"', ""):Trim()
	local Split = Nice:Split(" ")
	local Key = Split[1]
	local Bind = Split[2]
	if table.HasValue(HAC.SERVER.White_Keys, Bind) then return false end
	--return Format("%s\t%s", Key:upper(), Bind) --Cuts out too much

	return Raw
end

local function DumpRaw(self, WriteRaw, Raw)
	if WriteRaw and Raw ~= "" then
		local Log = self:GetLog("raw/cfg_raw", util.CRC(Raw))

		if not file.Exists(Log, "DATA") then
			HAC.file.Write(Log, Raw)
		end
	end
end

local function AddCheck(self, det)
	self.HAC_BB_Amt = self.HAC_BB_Amt or {}
	local Count = self.HAC_BB_Amt
	--Check
	local Amt = HAC.Binds.MaxKW[det]
	if not Amt then return end

	--Count
	if not Count[det] then
		Count[det] = 0
	end

	Count[det] = Count[det] + 1

	--Kick
	if Count[det] > Amt then
		if det:find("gm_spawn") then
			self.HAC_BB_FailForPK = Format("BBuff_MAX_PK: [[%s]] (%s > %s)", det, Count[det], Amt)
		else
			self.HAC_BB_FailForDET = Format("BBuff_MAX_DET: [[%s]] (%s > %s)", det, Count[det], Amt)
		end
	end
end

function HAC.Binds.Finish(str, len, sID, idx, Total, self)
	if not IsValid(self) then return end

	--String
	if not ValidString(str) then
		self:FailInit("BBuff_NO_RX", HAC.Msg.BB_NoStr)

		return
	end

	--Table
	local Binds = util.JSONToTable(str)

	if not Binds or table.Count(Binds.config) == 0 then
		self:FailInit("BBuff_ZERO_TAB", HAC.Msg.BB_NoTab)

		return
	end

	--autoexec.cfg
	local Auto = Binds.autoexec

	if ValidString(Auto) then
		--Scan
		local Tot = 0

		for k, v in pairs(Auto:Split("\n")) do
			if not ValidString(v) then continue end

			if v ~= "\n" and v ~= "\r" and v ~= " " then
				Tot = Tot + 1
			end

			--VERYBAD
			local Tab = table.CopyAndMerge(HAC.SERVER.Black_Keys_VERYBAD, HAC.SERVER.Black_Keys_Autoexec_VERYBAD)
			local Found, IDX, det = v:lower():InTable(Tab)

			--Ban
			if Found then
				self:DoBan(Format("Bind_Bad_AUTOEXEC=[[%s]] (%s)", v:Trim("\n"):Trim("\r"), det))
			end
		end

		--Write
		if Tot > 0 then
			self:Write("autoexec", Format("--[[\n\t%s\n\t===Autoexec @ %s===\n]]\n\n%s\n", self:HAC_Info(), HAC.Date(), Auto))
			--Log
			self:LogOnly("Has autoexec.cfg, " .. Tot .. " lines (" .. Auto:Size() .. " bytes)")
		end
	end

	--config.cfg
	local Cont = ""
	local TotBinds = 0
	local BadBinds = 0

	for k, v in pairs(Binds.config) do
		local This = Bullshit(v)
		if not This or table.HasValue(HAC.SERVER.White_AlsoKeys, v) then continue end
		TotBinds = TotBinds + 1
		Cont = Cont .. "\n" .. This
		--VERYBAD
		local Low = This:lower()
		local FoundBad, IDX, det = Low:InTable(HAC.SERVER.Black_Keys_VERYBAD)

		if FoundBad then
			--Count
			BadBinds = BadBinds + 1
			--BAN
			self:DoBan(Format("Bind_Bad=[[%s]] (%s)", This, det))
			--Check
			AddCheck(self, det)
		end

		--Log
		local Found, IDX, det = Low:InTable(HAC.SERVER.Black_Keys)

		if Found then
			--Count
			BadBinds = BadBinds + 1

			--Log
			--Don't log as bind if already banned
			if not FoundBad then
				self:LogOnly(Format("Bind=[[%s]] (%s)", This, det))
			end

			--Check
			AddCheck(self, det)
		end
	end

	--Propkill
	if self.HAC_BB_FailForPK then
		self:FailInit(self.HAC_BB_FailForPK, HAC.Msg.BB_Max_PK)
	end

	--Det
	if self.HAC_BB_FailForDET then
		self:FailInit(self.HAC_BB_FailForDET, HAC.Msg.BB_Max_Det)
	end

	--Too many bad
	if BadBinds >= HAC.Binds.MaxBad then
		self:FailInit(Format("BBuff_MaxBadBinds (%s bad > %s, %s ok)", BadBinds, HAC.Binds.MaxBad, TotBinds), HAC.Msg.BB_Max_Det)
	end

	--All in whitelist
	if Cont == "" then
		self.HAC_GotBinds = true

		return
	end

	--Write Raw
	local Raw = ""

	for k, v in pairs(Binds.config) do
		Raw = Raw .. "\n" .. v
	end

	DumpRaw(self, TotBinds > 0, Raw)

	--Empty file
	if not Cont:find('" "') then
		self:Write("cfg_NO_BINDS", Cont)
		self:FailInit("BBuff_NO_BINDS", HAC.Msg.BB_NoBinds)
		--Write Raw
		DumpRaw(self, true, Raw)

		return
	end

	--Write
	Cont = Format("--[[\n\t%s\n\t===CFG @ %s===\n]]\n\n%s\n", self:HAC_Info(), HAC.Date(), Cont)
	local Log = self:GetLog("cfg", util.CRC(Cont))

	if not file.Exists(Log, "DATA") then
		HAC.file.Write(Log, Cont)
		HAC.TellHeX(Format("CFG from %s complete!", self:Nick()), NOTIFY_UNDO, 10, "npc/roller/mine/rmine_taunt1.wav")
		HAC.Print2HeX(Format("[HAC] CFG from %s complete (%s binds)\n", self:Nick(), TotBinds))
		DumpRaw(self, TotBinds > 0, Raw)
	end

	--Double init
	if self.HAC_GotBinds then
		self:FailInit("BBuff_Double", HAC.Msg.BB_Double)
	end

	self.HAC_GotBinds = true
end

net.Hook("Buff", HAC.Binds.Finish)
HAC.Init.Add("HAC_GotBinds", HAC.Msg.SE_NoBinds, INIT_LONG)

--Gatehook
function HAC.Binds.GateHook(self, Args1)
	self:LogOnly("! " .. Args1)

	if Args1 == "BBuff=NoCont" then
		--Fail
		self:FailInit(Args1, HAC.Msg.BB_NoCont)
	end

	return INIT_DO_NOTHING
end

HAC.Init.GateHook("BBuff=", HAC.Binds.GateHook)

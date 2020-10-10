HAC.Init = {
	--Times
	WaitShort = 50, --SelfExists, short
	WaitFor = 80, --SelfExists
	IPSTime = 35, --IPS wait time
	KickTime = 40, --Before kick
	--Init
	Short = {},
	Main = {},
	Long = {},
	VeryLong = {},
	--GateHook
	Hooks = {},
	--FailInit
	MsgCount = {},
}

HAC.TotalFails = 0
--Times
INIT_SHORT = 1 --50
INIT_MAIN = 2 --80
INIT_LONG = 3 --80 + 30 more
INIT_VERY_LONG = 4 --80 + 137 more
--Gatehooks
INIT_BAN = true
INIT_DO_NOTHING = false

--Init
function HAC.Init.Add(k, v, typ)
	if not typ then
		typ = INIT_MAIN
	end

	local Tab = HAC.Init.Main

	--Long
	if typ == INIT_LONG then
		Tab = HAC.Init.Long
		--Very long
	elseif typ == INIT_VERY_LONG then
		Tab = HAC.Init.VeryLong
	elseif typ == INIT_SHORT then
		--Short
		Tab = HAC.Init.Short
	end

	if Tab[k] then
		debug.ErrorNoHalt("HAC.Init.Add, Init: " .. k .. " exists, OVERRIDING!")
	end

	Tab[k] = v
end

--GateHook - Called before DoBan
function HAC.Init.GateHook(what, func)
	if HAC.Init.Hooks[what] then
		debug.ErrorNoHalt("HAC.Init.GateHook, Hook: " .. what .. " exists, OVERRIDING!")
	end

	HAC.Init.Hooks[what] = func
end

--CanDoThisInit, only passes once, easy checking
function _R.Player:CanDoThisInit(init, str, kick_msg, invert)
	if self[init] then
		self:FailInit("CanDoThisInit DOUBLE (" .. init .. ", '" .. (str or init) .. "')", kick_msg or HAC.Msg.SE_CanInit)

		return invert and true or false
	end

	self[init] = true

	return true
end

--Old system, used only here
HAC.Init.FailedInits = {
	--Here
	["Fail_GMG"] = 1,
	["Fail_WFC"] = 1,
	["Fail_IPS_1"] = 1,
	["Fail_IPS_2"] = 1,
	--sv_RSX
	["Fail_FillBuff"] = 1,
}

--Generate, delay so all plugins loaded
timer.Simple(1, function()
	for i = 0, HAC.Count.HIS do
		if not HAC.Init.FailedInits["Fail_HIS_" .. i] then
			HAC.Init.FailedInits["Fail_HIS_" .. i] = 1
		end
	end
end)

--Main init gatehook
function HAC.Init.GateHook_Main(self, Args1)
	if HAC.Init.FailedInits[Args1] then
		self:FailInit(Args1, HAC.Msg.HC_Init)

		return INIT_DO_NOTHING
	end

	return INIT_BAN
end

HAC.Init.GateHook("Fail_", HAC.Init.GateHook_Main)

--Check all inits
function HAC.Init.Spawn(ply)
	if ply:IsBot() then return end
	ply.HAC_LogThisInit = {}

	--Short
	ply:timer(HAC.Init.WaitShort, function()
		for k, v in pairs(HAC.Init.Short) do
			if not ply[k] then
				ply:FailInit(k, v)
			end
		end
	end)

	--Main
	ply:timer(HAC.Init.WaitFor, function()
		ply:SendLua(string.EatNewlines([[
			POO = "]] .. HAC.SEBanCommand .. [["
			if not ToiletBlocker then
				RunConsoleCommand(POO,"Fail_GMG")
			end
		]]))
		ply:SendLua(string.EatNewlines([[
			local HC = tonumber(HAC_Installed) or 0
			--print(HC,]] .. HAC.Count.HIS .. [[)
			if HC != ]] .. HAC.Count.HIS .. [[ then
				--RunConsoleCommand(POO,"Fail_HIS_"..tostring(HC))
			end

			if not WFCL11255 then RunConsoleCommand(POO,"Fail_WFC") end
		]]))

		--Main
		for k, v in pairs(HAC.Init.Main) do
			if not ply[k] then
				ply:FailInit(k, v)
			end
		end

		--KEY 1
		if not ply.HACKeyInit1 then
			ply:FailInit("KEYFailure1", HAC.Msg.SE_K1Gone)
			ply.HACKeyInit1 = "GONE"
		end

		local Key1 = ply.HACKeyInit1

		if Key1 ~= HAC.KEY then
			ply:FailInit(Format("HACKey1_Mismatch_%s (%s)", Key1, HAC.KEY), HAC.Msg.SE_K1Fail)
		end

		--KEY 2
		if not ply.HACKeyInit2 then
			ply:FailInit("KEYFailure2", HAC.Msg.SE_K2Gone)
			ply.HACKeyInit2 = "GONE"
		end

		local Key2 = ply.HACKeyInit2

		if Key2 ~= HAC.KEY then
			ply:FailInit(Format("HACKey2_Mismatch_%s (%s)", Key2, HAC.KEY), HAC.Msg.SE_K2Fail)
		end
	end)

	--Long
	ply:timer(HAC.Init.WaitFor + 30, function()
		for k, v in pairs(HAC.Init.Long) do
			if not ply[k] then
				ply:FailInit(k, v)
			end
		end
	end)

	--Very long
	ply:timer(HAC.Init.WaitFor + 137, function()
		for k, v in pairs(HAC.Init.VeryLong) do
			if not ply[k] then
				ply:FailInit(k, v)
			end
		end
	end)
end

hook.Add("PlayerInitialSpawn", "HAC.Init.Spawn", HAC.Init.Spawn)

function HAC.Init.ReallySpawn(ply)
	--IPS
	ply:timer(HAC.Init.IPSTime, function()
		ply:SendLua(Format([[ function HQAS(v) RunConsoleCommand("%s","Fail_IPS_"..v) end ]], HAC.AuxBanCommand))

		ply:timer(4, function()
			ply:SendLua(string.EatNewlines([[
				if HQAS then
					if hook.Hooks.InitPostEntity then
						if not hook.Hooks.InitPostEntity.Hooks then
							HQAS(1)
						end
					else
						HQAS(2)
					end
				end
			]]))
		end)
	end)
end

hook.Add("HACReallySpawn", "HAC.Init.ReallySpawn", HAC.Init.ReallySpawn)

local function GetCRC()
	local lol = HAC_MAP
	local map = #lol * 2

	return map .. lol:upper() .. map * map
end

function HAC.Init.Command(ply, cmd, args)
	if not IsValid(ply) then return end
	local Reply = tostring(args[1]) or "fuck"
	local Len = tonumber(args[2]) or 0
	local CRC = tostring(args[4]) or "fuck" --No args3!
	local HACKey = tostring(args[5]) or "fuck"

	if not ply.HACKeyInit1 then
		ply.HACKeyInit1 = HACKey
	end

	--Already done!
	if ply.HACInit then
		ply:FailInit("HACInit_Again, (" .. Reply .. "," .. Len .. "," .. CRC .. "," .. HACKey .. ")", HAC.Msg.SE_TwoInit)
	else
		ply.HACInit = true
	end

	if Len ~= HAC.Count.LenCL then
		ply:FailInit("HACInit_Len, (" .. Len .. " != " .. HAC.Count.LenCL .. ")", HAC.Msg.SE_LenFail)
	end

	if Reply ~= "UH_2020C" then
		ply:FailInit("HACInit_RX, (" .. Reply .. " != UH_2020C)", HAC.Msg.SE_NoUHDM)
	end

	if CRC ~= GetCRC() then
		ply:FailInit("HACInit_CRC, (" .. CRC .. " != " .. GetCRC() .. ")", HAC.Msg.SE_BadCRC)
	end
end

concon.Add("_hx_hu_cah_ponswna", HAC.Init.Command)
HAC.Init.Add("HACInit", HAC.Msg.HC_Init)

--Abort
function _R.Player:AbortFailInit(Res)
	if self:VarSet("HAC_AbortInitKick") then return end
	self:WriteLog("! Aborting all FailInit due to " .. Res)
end

--FailInit
function _R.Player:FailInit(str, msg, count, is_hks)
	if self:IsBot() or str:FalsePos() then return end
	local SID = self:SteamID()
	--Count up, for different messages
	local Orig = msg
	HAC.Init.MsgCount[SID] = HAC.Init.MsgCount[SID] or {}

	if count and not is_hks then
		local Lev = HAC.Init.MsgCount[SID][Orig] or 1
		msg = HAC.Msg[Orig .. Lev] or HAC.Msg[Orig .. count]
	end

	--First call, will kick for first call only!
	if not self.HAC_InitFirst then
		self.HAC_InitFirst = {
			str = str,
			msg = msg,
			Orig = Orig,
			count = count,
		}

		self:WriteLog("! FailInit: " .. str) --will make useless "ban" log, but better
	end

	--Log deleted?
	local HasLog = self:Exists("init")

	if not HasLog then
		self.HAC_LogThisInit = {}
	end

	--Log unique
	if not self.HAC_LogThisInit[str .. msg] then
		self.HAC_LogThisInit[str .. msg] = true
		--Header
		local Head = Format("HAC Init log (GMod U%s) created @ %s for %s\n\n", VERSION, self:DateAndTime(), self:HAC_Info(1, 1))
		HAC.file.Append("hac_init.txt", Head)

		if not HasLog then
			self:Write("init", Head)
		end

		--Log
		local This = self:Time() .. " " .. str .. "\n"
		HAC.file.Append("hac_init.txt", This)
		self:Write("init", This)
		--Color
		HAC.COLCON(HAC.RED, "[", HAC.GREEN, "HAC", HAC.RED, "] ", HAC.PINK, "FailInit ", HAC.YELLOW, self.AntiHaxName .. " <", HAC.GREEN, self:UserID(), HAC.YELLOW, ">", HAC.PINK, " (" .. SID .. ") ", HAC.BLUE, str)
		--Tell HeX
		HAC.Print2HeX("[HAC] - FailInit: " .. self:HAC_Info() .. " - " .. str .. "\n", true)
		HAC.TellHeX(self.AntiHaxName .. " <" .. self:UserID() .. "> -> " .. str, NOTIFY_ERROR, 10, "buttons/button10.wav")
	end

	--Kick for first call only, run below only once
	local Override = self.HAC_InitKickOverride
	if self:VarSet("HAC_HasFailedInit") and not Override then return end

	--Wait for HKS, for init called *AFTER* HKS started!
	if self:HKS_InProgress() and not Override then
		self.HAC_InitWaiting = true

		return
	end

	--LCD / counter
	if not Override then
		--LCD
		HAC.TotalFails = HAC.TotalFails + 1
		--Counter
		--HAC.Box.Add("Failure", true)
	end

	--Log all files
	self:MakeFileList()
	--Dump all groups
	self:DumpGroups()
	--CVarList
	--self:CVarList() --Fucked 01.06
	--No kick if ban in progress
	if self.DONEBAN or self.DONEKICK then return end
	--There may just be time..
	self:TakeSC()
	--Stop here if silent
	if HAC.hac_silent:GetBool() then return end

	--Sound
	self:timer(HAC.Init.KickTime, function()
		if self:Banned() then return end

		--Re-check HKS
		if self:HKS_InProgress() and not self.HAC_InitKickOverride then
			self.HAC_InitWaiting = true
		end

		--No kick if waiting!
		if self.HAC_InitWaiting or HAC.hac_silent:GetBool() then return end
		--Abort
		if self.HAC_AbortInitKick then return end

		--Sound
		self:HAC_EmitSound("uhdm/hac/goodbye_new.mp3", "Thankyou for participating", true, function()
			--Kick
			self:timer(0.9, function()
				if self:Banned() then return end

				--Re-check HKS
				if self:HKS_InProgress() and not self.HAC_InitKickOverride then
					self.HAC_InitWaiting = true
				end

				--No kick if waiting!
				if self.HAC_InitWaiting or HAC.hac_silent:GetBool() then return end
				--Abort
				if self.HAC_AbortInitKick then return end
				--Add count
				local This = self.HAC_InitFirst

				if This.count then
					HAC.Init.MsgCount[SID][This.Orig] = (HAC.Init.MsgCount[SID][This.Orig] or 1) + 1
				end

				--Kick
				self.HAC_InitKicking = true
				self:HAC_Drop(msg, "InitFail (" .. This.str .. ")")
			end)
		end)
	end)
end

--Wait for HKS
function HAC.Init.HKSComplete(self, Res)
	if not self.HAC_InitWaiting then return end
	self.HAC_InitWaiting = nil
	--Log
	local This = self.HAC_InitFirst
	self:LogOnly(Res .. ", kicking first init (" .. This.str .. ")!")
	--Kick
	self.HAC_InitKickOverride = true --Stop waiting, KICK
	self:FailInit(This.str, This.msg, This.count, true)
end

hook.Add("HKSComplete", "HAC.Init.HKSComplete", HAC.Init.HKSComplete)

--First init reason
function _R.Player:FirstInit()
	return self.HAC_InitFirst and self.HAC_InitFirst.str or "HAC_InitFirst.str gone"
end

--Failed
function _R.Player:HasFailedInit()
	return self.HAC_InitFirst
end

--Banned
function _R.Player:Banned()
	return self.DONEBAN or HAC.Banned[self:SteamID()]
end

--Banned or failed
function _R.Player:BannedOrFailed()
	return self:Banned() or self:HasFailedInit()
end

--Just before ban
function _R.Player:JustBeforeBan()
	return self.HAC_JustBeforeBan
end

--Abort
function HAC.Init.Stop(self, cmd, args, str)
	if not args[1] then
		self:print("No args, give UserID!")

		return
	end

	--All
	if args[1] == "a" then
		for k, v in Humans() do
			v:AbortFailInit("Aborted")
		end

		return
	end

	if not tonumber(args[1]) then
		self:print("Bad args, give UserID or 'a' for all")

		return
	end

	--Him
	local Him = Player(args[1])

	if IsValid(Him) then
		Him:AbortFailInit("Aborted")
	else
		self:print("No player found")
	end
end

concommand.Add("abort", HAC.Init.Stop)

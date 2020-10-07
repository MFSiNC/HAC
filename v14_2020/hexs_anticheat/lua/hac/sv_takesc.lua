HAC.TSC = {
	FolderMax = 45, --MB
	FolderCheck = 3, --Hours
	SC_Folder = "SCFolder",
	format = "jpeg",
}

--Finish
function HAC.TSC.Finish(str, len, sID, idx, Total, self)
	if not IsValid(self) then return end
	self.HAC_ActiveSC = self.HAC_ActiveSC or {}
	self.HAC_ActiveSC[idx] = nil
	--Kill timeout
	timer.Destroy("TakeSC_" .. idx)

	if not ValidString(str) then
		self:FailInit("TakeSC_NO_RX", HAC.Msg.SC_NoRX)

		return
	end

	--No dec
	local dec = util.JSONToTable(str)

	if type(dec) ~= "table" or table.Count(dec) <= 0 or not dec.Cap or not dec.ScrW or not dec.ScrH then
		self:FailInit("TakeSC_NO_DEC", HAC.Msg.SC_NoDec)

		return
	end

	--No bin
	if not ValidString(dec.Cap) then
		self:FailInit("TakeSC_NO_BIN", HAC.Msg.SC_NoBin)

		return
	end

	--No B64
	local Raw = net.base64_dec(dec.Cap)

	if not ValidString(Raw) then
		self:FailInit("TakeSC_BAD_B64", HAC.Msg.SC_No64)

		return
	end

	--No JPG
	if not Raw:find("JFIF") then
		self:FailInit("TakeSC_NOT_JPG", HAC.Msg.SC_NoJPG)
	end

	--Too small
	--13KB min
	if #Raw < 13000 then
		self:FailInit("TakeSC_SMALL_BIN (" .. #Raw .. ")", HAC.Msg.SC_Small)
	end

	--Too big
	--max
	if #Raw > 520000 then
		self:FailInit("TakeSC_LARGE_BIN (" .. #Raw .. ")", HAC.Msg.SC_Large)
	end

	--Dimensions
	local x, y = imagesize.FromJPEG(Raw)

	if x and y then
		if (x ~= dec.ScrW or y ~= dec.ScrH) or (x < 640 or y < 480) then
			self:FailInit(Format("TakeSC_BAD_RES(%sx%s != %sx%s)", x, y, dec.ScrW, dec.ScrH), HAC.Msg.SC_BadRes)
		end
	else
		--No res
		self:FailInit("TakeSC_NO_RES", HAC.Msg.SC_NoRes)
	end

	--Filename
	local CRC = util.CRC(dec.Cap)
	local Name = Format("sc_%s_%s-%s", self:SID(), self.HAC_TotalSC, CRC)
	local Filename = self.HAC_Dir .. "/" .. Name .. ".jpg"
	--Already exists
	file.CreateDir(self.HAC_Dir)

	if file.Exists(Filename, "DATA") then
		Raw = nil
		--self:FailInit("TakeSC_DUPE_FILE ("..Filename..")", HAC.Msg.SC_Dupe)

		return
	end

	--Reset
	self.HAC_WaitingForSC = false
	self.HAC_HasWrittenSC = true

	--Write
	--Copy, only if NOT banned or failinit
	if not (self:BannedOrFailed()) then
		timer.Simple(1, function()
			local SCFolder = HAC.TSC.SC_Folder .. "/" .. Filename
			local This = HAC.ModDir .. "/data/" .. Filename
			file.Write(Filename, Raw)

			if not file.Exists(Filename, "DATA") then
				debug.ErrorNoHalt("! HAC.TSC.Finish, couldn't copy SC '" .. This .. "' to '" .. SCFolder .. "' for " .. tostring(self))
			end
		end)
	end

	--Log
	local Log = Format("%s - SC %s - Rem: %s", self:Nick(), self.HAC_TotalSC, self:BurstRem())
	HAC.Print2HeX(Log .. "\n")

	if not HAC.JustBeforeBan() then
		HAC.TellHeX(Log, NOTIFY_GENERIC, 8, "npc/turret_floor/click1.wav")
		--Sound("weapons/bugbait/bugbait_impact1.wav")
		--"npc/scanner/scanner_photo1.wav"
	end
end

--Update
function HAC.TSC.Update(sID, idx, Split, Total, Buff, self)
	self.HAC_ActiveSC = self.HAC_ActiveSC or {}
	local ThisID = self.HAC_ActiveSC[idx]

	--Timeout, resets every Update
	timer.Create("TakeSC_" .. idx, 200, 1, function()
		if IsValid(self) then
			self:FailInit("TakeSC_Update_TIMEOUT (" .. ThisID .. ", " .. idx .. ")", HAC.Msg.SC_Timeout)
		end
	end)

	local Per = math.Percent(Split, Total)

	if self:BannedOrFailed() then
		print("# TakeSC update on " .. self:Nick(), ThisID .. " - " .. Per .. "% (" .. Split .. "/" .. Total .. ") - Rem: " .. self:BurstRem())
	end
end

--Start
function HAC.TSC.Start(sID, idx, Split, Total, self)
	self.HAC_TotalSC = (self.HAC_TotalSC or 0) + 1
	self.HAC_ActiveSC = self.HAC_ActiveSC or {}
	self.HAC_ActiveSC[idx] = self.HAC_TotalSC
	local ThisID = self.HAC_ActiveSC[idx]

	if not HAC.JustBeforeBan() then
		local Log = Format("%s - STARTED Screenshot: %s - 1%% %s/%s", self:Nick(), ThisID, Split, Total)
		HAC.TellHeX(Log, NOTIFY_HINT, 8, "npc/roller/mine/rmine_blades_out" .. math.random(1, 3) .. ".wav")
	end

	print("# TakeSC started on: ", self:Nick(), ThisID)
end

net.Hook(HAC.TSC.format, HAC.TSC.Finish, HAC.TSC.Update, HAC.TSC.Start) --sID,Finish,Update,Start

--GateHooks
function HAC.TSC.GateHook(self, Args1)
	if self:BannedOrFailed() then
		self:WriteLog("! TakeSC: " .. Args1 .. ", requested ALT")
	end

	return INIT_DO_NOTHING
end

HAC.Init.GateHook("SC=Alt", HAC.TSC.GateHook)
HAC.Init.GateHook("SC=NJ", HAC.Msg.SC_NoJPG)
HAC.Init.GateHook("SC=NF", HAC.Msg.SC_NoJPG)
HAC.Init.GateHook("CC=NCE", HAC.Msg.SC_NoJPG)

--SC Command
function _R.Player:TakeSC(override, alt)
	if not override then
		if self:VarSet("HAC_WaitingForSC") or self.HAC_SCKilled then return end
		print("[HAC] Taking screenshot on " .. self:Nick())
	else
		print("[HAC] Taking screenshot OVERRIDE on " .. self:Nick())
	end

	--Retry
	self:timer(100, function()
		self.HAC_WaitingForSC = false

		--Try again
		if not self.HAC_HasWrittenSC then
			self:TakeSC(override, true)
		end
	end)

	--Timeout
	self:timer(200, function()
		if not self.HAC_HasWrittenSC then
			self:FailInit("TakeSC_TIMEOUT", HAC.Msg.SC_Timeout)
			--jpeg command if no file, fixme
		end
	end)

	--TRIGGER
	umsg.Start("Timesync", self)
	umsg.Bool(tobool(alt))
	umsg.End()
end

--SCREENSHOT EVERY
function _R.Player:TakeSCEvery(time)
	if self.HAC_SCKilled then return end

	self.HAC_SCID = self:TimerCreate("TakeSC", 30, 0, function()
		self:TakeSC()
	end)
end

--Kill SC
function _R.Player:KillSC()
	if self:VarSet("HAC_SCKilled") or not self.HAC_SCID then return end
	timer.Destroy(self.HAC_SCID)

	return true
end

local function Everyone(ply, Alt)
	for k, v in Humans() do
		if v.DONEBAN then
			v:TakeSC(true, Alt)
			ply:print("[HAC] AUTO SC on " .. v:Nick() .. (Alt and ", FORCE!" or ""))

			return true
		end
	end

	return false
end

function HAC.TSC.Command(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end
	local Args1 = args[1]
	local Alt = args[2] and true or false

	if #args <= 0 then
		if not Everyone(ply, Alt) then
			ply:print("[HAC] No args, give userid!")
		end

		return
	elseif Args1 == "all" then
		ply:print("[HAC] SC ALL" .. (Alt and ", FORCE!" or ""))

		for k, v in Humans() do
			v:TakeSC(true, Alt)
		end

		return
	end

	local Him = tonumber(Args1)

	if not Him or Him < 1 then
		if not Everyone(ply, Alt) then
			ply:print("[HAC] No one is banned, can't use All!")
		end

		return
	end

	Him = Player(Him)

	if IsValid(Him) then
		Him:TakeSC(true, Alt)
		ply:print("[HAC] SC " .. tostring(Him) .. (Alt and ", FORCE!" or ""))
	else
		ply:print("[HAC] Invalid userid!")
	end
end

concommand.Add("sc", HAC.TSC.Command)

--Kill SC
function HAC.TSC.Kill(ply, cmd, args)
	--\n
	for k, v in Humans() do
		if v:KillSC() then
			ply:print("\n[HAC] Killed SC on " .. tostring(v))
		end
	end
end

concommand.Add("sc_kill", HAC.TSC.Kill)

--SCFolder check
if not HAC.TSC.SC_Folder or not file.IsDir(HAC.TSC.SC_Folder, "DATA") then
	ErrorNoHalt("! HAC.TSC.SC_Folder (" .. tostring(HAC.TSC.SC_Folder) .. ") TEF!\n")
end

hac.DirSize = hac.DirSize or function(dir, path)
	local files, folders = file.Find(dir, path)
	local cfp = string.Replace(dir, "*", "")

	for k, v in pairs(folders) do
		local sd = ""

		if cfp ~= "" then
			sd = cfp .. "/" .. v .. "/*"
		else
			sd = v .. "/*"
		end

		hac.DirSize(sd, path)
	end

	for k, v in pairs(files) do
		size = size + file.Size(dir .. v, path)
	end
end

--Size of SCFolder
function HAC.TSC.Timer()
	local Size = hac.DirSize(HAC.TSC.SC_Folder, "DATA")

	if not Size or Size == 0 then
		ErrorNoHalt("! HAC.TSC.Timer: Can't hac.DirSize :(\n")

		return
	end

	--Check
	local Round, Unit = math.Bytes(Size, true)
	local Warn = ""

	if Unit ~= "MB" and Unit ~= "KB" then
		Warn = Format("[HAC] SCFolder is WAY over the limit! (%s%s > %sMB)", Round, Unit, HAC.TSC.FolderMax)
	elseif Unit == "MB" and Round > HAC.TSC.FolderMax then
		Warn = Format("[HAC] SCFolder is over the limit. (%sMB > %sMB)", Round, HAC.TSC.FolderMax)
	end

	--Warn
	if Warn ~= "" then
		ErrorNoHalt(Warn .. "\n")
		HAC.file.Write("hac_scfolder.txt", "\n" .. Warn)
	end
end

timer.Create("HAC.TSC.Timer", (HAC.TSC.FolderCheck * 60 * 60), 0, HAC.TSC.Timer)
timer.Simple(1, HAC.TSC.Timer)

--On spawn
local function SC_IfNotBanned(self, alt)
	if not IsValid(self) or self:BannedOrFailed() or self:IsAdmin() then return end
	self:TakeSC(nil, alt)
end

function HAC.TSC.ReallySpawn(self)
	SC_IfNotBanned(self)

	--60s later
	self:timer(60, function()
		SC_IfNotBanned(self)
	end)

	--180s later, alt
	self:timer(200, function()
		SC_IfNotBanned(self, true)
	end)

	--220s later
	self:timer(300, function()
		SC_IfNotBanned(self)
	end)
end

hook.Add("HACReallySpawn", "HAC.TSC.ReallySpawn", HAC.TSC.ReallySpawn)

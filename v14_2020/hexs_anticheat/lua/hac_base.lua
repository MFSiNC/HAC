_R = debug.getregistry()
HAC.ModDir = util.RelativePathToFull("."):sub(1, -2):gsub("\\", "/"):Trim("/")
HAC.ModDirBack = util.RelativePathToFull("gameinfo.txt"):gsub("gameinfo.txt", ""):Trim("\\")
HAC_MAP = game.GetMap()
TICK_INTERVAL = engine.TickInterval()
TICK_RATE = 1 / TICK_INTERVAL
Useless = function() end
Format = string.format --Garry'd
HAC.Loaded = false

if not net.Hook then
	net.Hook = Useless
end

--- === File === ---
HAC.file = {}

function HAC.file.CreateDir(Path)
	local Tab = Path:Split("/")
	local Here = ""

	for k, v in ipairs(Tab) do
		--Last entry in path table
		if k ~= #Tab then
			Here = Here .. v .. "/"
		end
	end

	if not file.IsDir(Here, "DATA") then
		file.CreateDir(Here, "DATA")
	end
end

function HAC.file.Write(Path, cont, mode)
	HAC.file.CreateDir(Path)
	--Write
	local Out = file.Open(Path, (mode or "w"), "DATA")
	if not Out then return end
	Out:Write(cont)
	Out:Close()
	Out = nil
end

--Write table
function HAC.file.WriteTable(Path, Tab, Fmt)
	HAC.file.CreateDir(Path)
	local Format = Format
	local Cont = ""
	local Out = file.Open(Path, "w", "DATA")
	if not Out then return end

	for k, v in pairs(Tab) do
		Out:Write(Fmt and Format(Fmt, v) or "\n" .. v)
	end

	Cont = Out:Read(Out:Size())
	Out:Close()
	Out = nil

	return Cont
end

HAC.WriteFailed = 0

function HAC.file.WriteEx(Path, cont, mode)
	--Ext
	local Ext = Path:GetExtensionFromFilename()

	if Ext == "txt" then
		HAC.file.Write(Path, cont, mode)

		return
	end

	Path = Path:sub(0, -#Ext - 2) .. ".dat" --Remove extension
	HAC.file.Write(Path, cont, mode)

	if file.Exists(Path, "DATA") then
		HAC.file.Rename(Path, "." .. Ext)
	else
		HAC.WriteFailed = HAC.WriteFailed + 1
		HAC.file.Write("write_failed/" .. HAC.WriteFailed .. ".txt", cont, mode)
	end
end

function HAC.file.Append(Path, cont)
	HAC.file.CreateDir(Path)
	--Write-append
	local Out = file.Open(Path, "a", "DATA")
	if not Out then return end
	Out:Write(cont)
	Out:Close()
end

function HAC.file.Find(Path, loc)
	local Files, Dirs = file.Find(Path, loc)

	--Merge the 2 tables like GM12
	for k, v in pairs(Dirs) do
		table.insert(Files, v)
	end

	return Files
end

function HAC.file.Read(Path, loc, nil_if_gone)
	if not loc then
		loc = "DATA"
	end

	local Out = file.Open(Path, "r", loc)
	if not Out then return end
	local str = Out:Read(Out:Size())
	Out:Close()
	if not str then return nil_if_gone and nil or "" end

	return str
end


function HAC.file.Rename(Path, Ext)
	--Path exists
	if not file.Exists(Path, "DATA") then
		debug.ErrorNoHalt("! HAC.file.Rename: Path '" .. Path .. "' gone!")

		return
	end

	--NewPath exists, overwrite
	local NewPath = Path:sub(0, -5) .. Ext
	local Too = HAC.ModDir .. "/data/" .. NewPath

	if file.Exists(NewPath, "DATA") then
		gaceio.Delete(NewPath)
	end

	--Rename
	local From = HAC.ModDir .. "/data/" .. Path

	local old = gaceio.Read(From)

	local new
	if old then
		new = gaceio.Write(Too, old)
		new = gaceio.Exists(Too)
		gaceio.Delete(From)
	end
	if not new then
		debug.ErrorNoHalt("! HAC.file.Rename, couldn't rename '" .. From .. "' to '" .. Too .. "'")
	end
end

FIND_FILE = 1
FIND_DIR = 2
FIND_SKIP = true
FIND_KEEP = true

--fixme from CL HKS, new base start
function HAC.file.FindAll(Base, PATH, Refine)
	if not Refine then
		Refine = function() end
	end

	PATH = PATH or "MOD"
	local RawBase = Base
	local All = {}

	local function SearchNext(Base, PATH)
		local Files, Dirs = file.Find(Base .. "/*", PATH)

		--Files
		for k, v in pairs(Files) do
			local Base = Base .. "/" .. v
			local Refine, NewBase = Refine(FIND_FILE, v, Base, RawBase)

			if not Refine or (Refine and NewBase) then
				--if Refine and not Refine(FIND_FILE, v,Base) then
				table.insert(All, NewBase and NewBase or Base)
			end
		end

		--Dirs
		for k, v in pairs(Dirs) do
			local Base = Base .. "/" .. v
			if Refine(FIND_DIR, v, Base) then continue end
			SearchNext(Base, PATH)
		end
	end

	SearchNext(Base, PATH)

	return All
end

--- === Entity === ---
local function IsAdmin(ply)
	return not ply:IsValid()
end

local function SRCDS(ply)
	if not ply:IsValid() then return "SRCDS" end
end

_R.Entity.HAC_IsHeX = IsAdmin
_R.Entity.IsSuperAdmin = IsAdmin
_R.Entity.IsAdmin = IsAdmin
_R.Entity.SteamID = SRCDS
_R.Entity.IPAddress = SRCDS
_R.Entity.Nick = SRCDS
_R.Entity.Name = SRCDS

function _R.Entity:PrintMessage(where, msg)
	if (where == HUD_PRINTCONSOLE or where == HUD_PRINTNOTIFY) then
		Msg(msg)
	end
end

--Has to be on entity
function _R.Entity:print(str, like_msg)
	if not IsValid(self) or not self:IsPlayer() then
		if like_msg then
			Msg(str)
		else
			print(str)
		end

		return
	end

	str = str:Left(210)

	if not like_msg then
		str = str .. "\n"
	end

	self:PrintMessage(HUD_PRINTCONSOLE, str)
end

--Distance
function _R.Entity:Distance(ent)
	return math.Round(self:GetPos():Distance(ent:GetPos()))
end

TIMER_STOP = true

function _R.Entity:TimerCreate(TID, Every, Loops, Func)
	if not IsValid(self) then return end
	TID = TID .. "_" .. tostring(self)

	timer.Create(TID, Every, Loops, function()
		if IsValid(self) then
			if Func(TID) == TIMER_STOP then
				--Return true to end
				timer.Destroy(TID)
			end
		else
			timer.Destroy(TID)
		end
	end)

	return TID
end

function _R.Entity:timer(Delay, Func)
	timer.Simple(Delay, function()
		if IsValid(self) then
			Func()
		end
	end)
end

_R.Entity.TimerSimple = _R.Entity.timer

function _R.Entity:VarSet(This)
	if not self[This] then
		self[This] = true

		return false
	end

	return true
end

function _R.Player:CanUseThis(name, when)
	if not self[name] then
		self[name] = true

		self:timer(when, function()
			self[name] = nil
		end)

		return true
	end

	return false
end

function _R.Player:LagWarning(Str)
	self:WriteLog("LagWarning: " .. Str)
	HAC.LagWarning()
end

function _R.Entity:EffectData(What)
	local Effect = EffectData()
	Effect:SetOrigin(self:GetPos())
	Effect:SetEntity(self)
	util.Effect(What, Effect, true, true)

	return Effect
end

--- === HeX === ---
--Tell HeX
function HAC.TellHeX(str, typ, time, snd)
	if not typ then
		typ = NOTIFY_CLEANUP
	end

	if not time then
		time = 10
	end

	local HeX = HAC.GetHeX()

	if IsValid(HeX) then
		HeX:HACGAN(str, typ, time, snd)
	end
end

--Print to HeX
function HAC.Print2HeX(str, no_console, snd)
	if not no_console then
		Msg(str)
	end

	local HeX = HAC.GetHeX()

	if IsValid(HeX) then
		--v:PrintMessage(HUD_PRINTCONSOLE, str)
		HeX:print(str)

		if snd then
			HeX:HAC_SPS(snd)
		end
	end
end

--- === Math === ---
--Percent
function math.Percent(This, OutOf)
	if math.abs(OutOf) < 0.0001 then return 0 end

	return math.Round(This / OutOf * 100)
end

--One in
function math.OneIn(num)
	return math.random(0, (num or 1)) == 0
end

--Within
function math.Within(This, Low, High)
	return This > Low and This < High
end

--Minus
function math.Minus(This)
	return This < 0 and -This or This
end

--Random
local Tot = 0

function math.RandomEx()
	Tot = Tot + math.random(1024, 8096)

	return math.Round(Tot + SysTime() + CurTime() + RealTime() + os.time() / Tot)
end

--Bytes
local Units = {"B", "KB", "MB", "GB, Whoops!"}

function math.Bytes(bytes, all_data)
	if not isnumber(bytes) then return error("! math.Bytes: No bytes\n") end
	local Div = math.floor(math.log(bytes) / math.log(1024))
	local Raw = (bytes / math.pow(1024, math.floor(Div)))
	Div = Div + 1

	if all_data then
		return math.Round(Raw, 2), Units[Div], Raw, Div
	else
		return math.Round(Raw, 2) .. " " .. Units[Div]
	end
end

function HAC.NiceTime(Secs)
	if not Secs then
		Secs = 0
	end

	if Secs < 0 then
		Secs = -Secs
	end

	local hours = math.floor(Secs / 3600)
	local minutes = math.floor((Secs / 60) % 60)
	Secs = math.floor(Secs % 60)

	return ((hours >= 1 and "0" .. hours .. ":" or "") .. (minutes <= 9 and "0" .. minutes or minutes) .. ":" .. (Secs <= 9 and "0" .. Secs or Secs))
end

function HAC.Date()
	return os.date("%d.%m.%y %I:%M:%S%p")
end

function HAC.DateAndTime(Secs)
	return "[" .. HAC.Date() .. " @ " .. HAC.NiceTime(Secs) .. "]"
end

--Calculate SteamID key
local BadSid = {
	[""] = 1,
	["BOT"] = 1,
	["STEAM_ID_NONE"] = 1,
	["STEAM_ID_PENDING"] = 1,
}

function HAC.SteamKey(sid)
	if not sid or not ValidString(sid) or BadSid[sid] then
		debug.ErrorNoHalt("! Bad SteamKey '" .. tostring(sid) .. "'")
		sid = "STEAM_0:0:0"
	end

	sid = tonumber(sid:sub(11))

	if not sid then
		debug.ErrorNoHalt("! Bad SteamKey sid '" .. tostring(sid) .. "'")
		sid = 8
	end

	sid = (sid / 3)
	sid = sid + tonumber(#HAC_MAP)
	sid = math.Round(sid)

	return tostring(sid)
end

function HAC.CRCLists(what)
	local str = HAC_MAP

	local function BuildCRC(tab, done)
		done = done or {}

		for k, v in pairs(tab) do
			local typ = type(v)

			if typ == "table" and not done[v] then
				done[v] = true
				str = str .. tostring(k)
				BuildCRC(v, done)
			elseif typ == "string" then
				str = str .. tostring(v)
			end
		end
	end

	BuildCRC(what)
	str = str .. #str .. #str * 3

	return util.CRC(str)
end

local NumTab = {
	[01] = "st",
	[02] = "nd",
	[03] = "rd",
	[21] = "st",
	[22] = "nd",
	[23] = "rd",
	[31] = "st",
	[32] = "nd",
	[33] = "rd",
	[41] = "st",
	[42] = "nd",
	[43] = "rd",
	[51] = "st",
	[52] = "nd",
	[53] = "rd",
	[61] = "st",
	[62] = "nd",
	[63] = "rd",
	[71] = "st",
	[72] = "nd",
	[73] = "rd",
	[81] = "st",
	[82] = "nd",
	[83] = "rd",
	[91] = "st",
	[92] = "nd",
	[93] = "rd",
}

function HAC.AddTH(num)
	if num <= 100 then return STNDRD(num) end --Works fine with low numbers..
	local LastTwo = tostring(num):Right(2)
	local InTab = NumTab[tonumber(LastTwo)]
	if InTab then return InTab end

	return "th"
end

function HAC.NiceNum(num)
	return tostring(num):reverse():gsub("(...)", "%1,"):gsub(",$", ""):reverse()
end

--- === Detours === ---
HAC.Detour = {
	Saved = {},
}

function HAC.MyCall(lev)
	local DGI = debug.getinfo(lev or 3)
	if not DGI then return "Gone", 0 end
	local Path = (DGI.short_src or "Gone"):gsub("\\", "/")
	local Line = (DGI.linedefined or 0)

	return Path, Line
end

function HAC.FSource(func)
	if not isfunction(func) then
		error("! HAC.FSource, func is a: " .. type(func))
	end

	return debug.getinfo(func).short_src or "GONE"
end

function HAC.Detour.Meta(lib, func, new)
	local _R = debug.getregistry()

	if not _R[lib][func] then
		debug.ErrorNoHalt("Missing table, '_R." .. lib .. "." .. func .. "' doesn't exist")

		return
	end

	if _R[lib][func .. "_HAC"] then
		_R[lib][func] = _R[lib][func .. "_HAC"]
		_R[lib][func .. "_HAC"] = nil
		HAC.Detour.Saved[lib .. "." .. func] = nil
		debug.ErrorNoHalt(Format("Detour of '%s.%s' from: %s was RELOADED", lib, func, HAC.FSource(new)))
	end

	HAC.Detour.Saved[lib .. "." .. func] = {
		old = _R[lib][func],
		new = new
	}

	_R[lib][func .. "_HAC"] = _R[lib][func]
	_R[lib][func] = new
end

--[[
HAC.Detour.Meta("Player", "PrintMessage", function(new) end)

HAC.Detour.Meta("bf_read", "ReadString", function(new) end)
]]
function HAC.Detour.Global(lib, func, new)
	local where = lib

	if where == "_G" then
		where = _G
	else
		where = _G[where]
	end

	--Table doesn't exists in _G
	if not where then
		debug.ErrorNoHalt("Missing table, '_G." .. lib .. "." .. func .. "' doesn't exist")

		return
	end

	if where[func .. "_HAC"] then
		where[func] = where[func .. "_HAC"]
		where[func .. "_HAC"] = nil
		HAC.Detour.Saved[lib .. "." .. func] = nil
		debug.ErrorNoHalt(Format("Detour of '%s.%s' from: %s was RELOADED", lib, func, HAC.FSource(new)))
	end

	HAC.Detour.Saved[lib .. "." .. func] = {
		old = where[func],
		new = new
	}

	where[func .. "_HAC"] = where[func]
	where[func] = new
end

--[[
HAC.Detour.Global("os", "date", function(new) end)

HAC.Detour.Global("_G", "PrintMessage", function(new) end)
]]
function HAC.Detour.Dump(ply, cmd, args)
	for k, v in pairs(HAC.Detour.Saved) do
		print("! func,old,new: ", k, HAC.FSource(v.old), HAC.FSource(v.new))
	end
end

concommand.Add("hac_detour_dump", HAC.Detour.Dump)

--IPAddress
HAC.Detour.Meta("Player", "IPAddress", function(self, first)
	local Addr = self:IPAddress_HAC()

	return first and Addr:Split(":")[1] or Addr
end)

--- === Debug === ---
function debug.ErrorNoHalt(Res, bad)
	Res = Res or "Trace"
	local Lev = 2
	local Out = ""

	while true do
		local Tab = debug.getinfo(Lev)
		if not Tab then break end

		--First call
		if Lev == 2 then
			Out = Out .. Format("[%s] %s - [%s:%d-%d]\n", Res, Tab.name, Tab.short_src, Tab.linedefined, Tab.lastlinedefined)
		end

		--Tab
		local Sep = string.rep(" ", Lev - 1)
		Out = Out .. Format(" %s%d. %s - %s:%d\n", Sep, Lev, (Tab.name or "unknown"), Tab.short_src, Tab.currentline)
		Lev = Lev + 1
	end

	Out = Out .. "\n\n"
	ErrorNoHalt(Out)

	if bad then
		error("debug.ErrorNoHalt", 0)
	end
end

--- === String === ---
function ValidString(v)
	return isstring(v) and v ~= ""
end

function string.hFind(str, what)
	return str:find(what, nil, true)
end

function string.Check(str, check)
	return str:sub(1, #check) == check
end

function string.Count(str, count)
	return #str:Split(count) - 1
end

function string.InBase(str, base)
	return base:lower():find(str:lower())
end

function string.ToBytes(str)
	return str:gsub("(.)", function(c) return Format("%02X%s", c:byte(), " "):Trim() end)
end

function string.FromChars(...)
	local s = ""

	for k, v in pairs({...}) do
		s = s .. string.char(v)
	end

	return s
end

function string.Size(str)
	return math.Bytes(#str)
end

function string.CheckInTable(str, tab, use_k)
	for k, v in pairs(tab) do
		if str:Check((use_k and k or v)) then return true, k, v end
	end

	return false, false, false
end

function string.InTable(str, tab, use_k, lower)
	if not istable(tab) then
		debug.ErrorNoHalt("! Have a fuckup, string.InTable not a table!")

		return
	end

	for k, v in pairs(tab) do
		local This = use_k and k or v
		if str:find(lower and This:lower() or This, nil, true) then return true, k, v end
	end

	return false, false, false
end

function string.SID(str)
	return str:gsub(":", "_")
end

function string.Safe(str, newlines)
	str = tostring(str)
	str = str:Trim()
	str = str:gsub("[:/\\\"*%@?<>'#]", "_")
	str = str:gsub("[]([)]", "")

	if not newlines then
		str = str:gsub("[\n\r]", "")
	end

	str = str:Trim()

	return str
end

function string.EatNewlines(str, also_spaces)
	str = str:gsub("\n", " ")
	str = str:gsub("\r", "")
	str = str:gsub("\t", " ")

	if also_spaces then
		str = str:gsub("  ", " ")
		str = str:gsub("  ", " ")
		str = str:gsub("  ", " ")
	end

	return str
end

function string.NoQuotes(str)
	str = str:Trim()

	if str:Check('"') then
		str = str:sub(2)
	end

	if str:EndsWith('"') then
		str = str:sub(0, -2)
	end

	return str
end

local GoodBytes = {
	[32] = " ",
	--[35] = "#",
	[45] = "-",
	[46] = ".",
	[47] = "/",
	[95] = "_",
}

function string.VerySafe(str, tab)
	local out = ""
	local Tab = tab or GoodBytes

	for i = 1, #str do
		local Byte = str:byte(i)

		if Tab[Byte] or (Byte >= 48 and Byte <= 57) or (Byte >= 65 and Byte <= 90) or (Byte >= 97 and Byte <= 122) then
			out = out .. str:sub(i, i)
		end
	end

	return out
end

function HAC.RandomString(len)
	if not len then
		len = math.random(6, 11)
	end

	local rnd = ""

	for i = 1, len do
		local c = math.random(65, 116)

		if c >= 91 and c <= 96 then
			c = c + 6
		end

		rnd = rnd .. string.char(c)
	end

	return rnd
end

--- === Table === ---
function table.MergeEx(from, dest, as_is)
	if as_is then
		dest[as_is] = from
	else
		for k, v in pairs(from) do
			dest[k] = v
		end
	end

	from = nil

	return dest
end

function table.CopyAndMerge(...)
	local New = {}

	for k, v in pairs({...}) do
		table.Add(New, table.Copy(v))
	end

	return New
end

function table.RandomEx(Tab)
	local Rand = table.Random(Tab) --Garry'd

	return Rand
end

function table.Tabify(Tab)
	local N = {}

	for k, v in pairs(Tab) do
		N[v] = 1
	end

	return N
end

function table.Size(Tab)
	local Size = 0

	local function Count(Tab)
		done = done or {}

		for k, v in pairs(Tab) do
			local typ = type(v)

			if typ == "table" and not done[v] then
				done[v] = true
				table.Size(v, done)
			elseif typ == "string" or typ == "number" then
				Size = Size + #tostring(v)
			end
		end
	end

	Count(Tab)

	return Size
end

function table.Shuffle(Tab)
	local This = #Tab

	while This >= 2 do
		local k = math.random(This)
		Tab[This], Tab[k] = Tab[k], Tab[This]
		This = This - 1
	end

	return Tab
end

--- === Player === ---
--Main log
function _R.Player:WriteLog(crime, pun, always_log)
	if not IsValid(self) then return end
	self.HAC_HasDoneLogThisTime = true
	local Banned = false

	if pun then
		pun = "BANNED"
		Banned = pun
	else
		pun = "Log"
	end

	--Setup log
	local HasLog = self:Exists("ban")

	if not HasLog then
		self.HAC_LogCalls = {} --Empty table if log file was deleted mid-ban!
	end

	--Skip duplicate events
	if self.HAC_LogCalls[crime .. pun] and not always_log then return end
	self.HAC_LogCalls[crime .. pun] = true
	--Header
	local SID = self:SteamID()
	local Header = Format("HAC U%s @ [%s] for %s\n\n%s\n%s\n%s\n%s\n\nSID:\nhttp://steamid.co.uk/profile/%s\n\n", VERSION, HAC.Date(), self:HAC_Info(), self:Nick(), SID, self:URL(), self:IPAddress(), self:SteamID64())

	--Rejoin
	if HasLog and not self.HAC_RejoinLogHeader and not self.HAC_HasWrittenLog then
		self.HAC_RejoinLogHeader = true
		HasLog = false --To make it write
		Header = "\n**REJOIN** " .. Header
	end

	--Write
	local HAC_IsHeX = self:HAC_IsHeX()

	if not HasLog then
		self:Write("ban", Header)
		HAC.Nice.Write(self, Header, true)

		if not HAC_IsHeX then
			HAC.file.Append("hac_log.txt", Header)
		end

		self.HAC_HasWrittenLog = true --Don't count 2nd call as new log
	end

	--Per pun log entry
	local Event = "[" .. self:Time() .. "] " .. crime
	local This = Event .. "\n"
	self.HAC_LastPun = self.HAC_LastPun or ""

	if pun ~= self.HAC_LastPun then
		This = Format("\n%s:\n%s\n", pun, Event)
	end

	self.HAC_LastPun = pun

	--Write
	if not HAC_IsHeX then
		HAC.file.Append("hac_log.txt", This)
	end

	self:Write("ban", This)
	--Nice log, don't give anything away!
	HAC.Nice.Write(self, crime)
	--Var with first ban reason
	crime = crime:EatNewlines()

	if Banned then
		self.HAC_FirstDetection = crime
	end

	--Console
	HAC.COLCON(HAC.RED, "[", HAC.GREEN, "HAC", HAC.RED, "] ", (Banned and HAC.RED or HAC.BLUE), pun .. " ", HAC.YELLOW, self.AntiHaxName .. " <", HAC.GREEN, self:UserID(), HAC.YELLOW, ">", HAC.PINK, " (" .. SID .. ") ", (Banned and HAC.RED or HAC.GREEN), crime)
	--Tell HeX
	HAC.TellHeX(self.AntiHaxName .. " <" .. self:UserID() .. "> -> " .. crime, (Banned and NOTIFY_CLEANUP or NOTIFY_ERROR), 10, (Banned and "npc/roller/mine/rmine_tossed1.wav" or "buttons/lightswitch2.wav"))
	HAC.Print2HeX(Format("[HAC] - %s: %s - %s\n", pun, self:HAC_Info(), crime), true)

	return true
end

function _R.Player:Logged()
	return self.HAC_HasDoneLogThisTime
end

function Humans()
	return pairs(player.GetHumans())
end

function Everyone()
	return pairs(player.GetAll())
end

function Bots()
	return pairs(player.GetBots())
end

function player.IsHeXOn()
	return IsValid(HAC.GetHeX())
end

function player.NonBanned()
	local Tab = {}

	for k, v in Humans() do
		if not v:Banned() then
			table.insert(Tab, v)
		end
	end

	return Tab
end

function player.AllBanned()
	local Tab = {}

	for k, v in Humans() do
		if v:Banned() then
			table.insert(Tab, v)
		end
	end

	return Tab
end

function NonBanned()
	return pairs(player.NonBanned())
end

function AllBanned()
	return pairs(player.AllBanned())
end

function HAC.JustBeforeBan()
	for k, v in Humans() do
		if v:JustBeforeBan() then return true end
	end

	return false
end

function HAC.InDB(SID)
	return file.Exists("HAC_DB/" .. SID:SID() .. ".txt", "DATA")
end

function _R.Player:HAC_InDB()
	return HAC.InDB(self:SteamID())
end

function _R.Player:URL()
	return "http://steamcommunity.com/profiles/" .. util.SteamIDTo64(self:SteamID())
end

function _R.Player:Is12()
	return self:GetLevel() == 22
end

function _R.Player:HAC_Info(show_ip, show_url)
	local SID = self:SteamID()
	local Addr = show_ip and " <" .. self:IPAddress() .. ">" or ""
	local URL = show_url and " " .. self:URL() or ""

	return self.AntiHaxName .. " (" .. SID .. ")" .. Addr .. URL
end

function _R.Player:TeamColor()
	return IsValid(self) and team.GetColor(self:Team()) or color_white
end

function _R.Player:SID()
	return self:SteamID():gsub(":", "_")
end

function _R.Player:HAC_IsHeX()
	return HAC
end

--GetHeX
function HAC.GetHeX()
	for k, v in Everyone() do
		if v:HAC_IsHeX() then return v end
	end
end

function _R.Player:HAC_IsNoClip()
	local move = self:GetMoveType()

	return (move == MOVETYPE_NOCLIP or move == MOVETYPE_FLY)
end

function _R.Player:GetLog(Log, no_sid)
	--No SID
	if isbool(no_sid) then
		--Added CRC etc
		return Format("%s/%s.txt", self.HAC_Dir, Log)
	elseif isstring(no_sid) then
		return Format("%s/%s_%s-%s.txt", self.HAC_Dir, Log, self:SID(), no_sid)
	else
		return Format("%s/%s_%s.txt", self.HAC_Dir, Log, self:SID())
	end
end

function _R.Player:Exists(Log, no_sid)
	self.LogCache = self.LogCache or {}
	local Res = self.LogCache[Log]

	if not Res then
		Res = self:GetLog(Log, no_sid)
		self.LogCache[Log] = Res
	end

	return file.Exists(Res, "DATA")
end

function _R.Player:Write(Log, What, no_sid, overwrite)
	self.LogCache = self.LogCache or {}
	local Res = self.LogCache[Log]

	if not Res then
		Res = self:GetLog(Log, no_sid)
		self.LogCache[Log] = Res
	end

	if overwrite then
		HAC.file.Write(Res, What)
	else
		HAC.file.Append(Res, What)
	end

	return Res
end

function _R.Player:WriteCRC(Log, What)
	self.HAC_WriteCRC = self.HAC_WriteCRC or {}
	self.HAC_WriteCRC[Log] = self.HAC_WriteCRC[Log] or {}
	local This = Format('\n\t["%s"] = 1,', util.CRC(What))

	if not self.HAC_WriteCRC[Log][This] then
		self.HAC_WriteCRC[Log][This] = true
		self:Write(Log, This)
	end
end

--- === In cl_Message === ---
--PEX
function _R.Player:HACPEX(str)
	if not IsValid(self) then return end
	umsg.Start("HAC.PEX2", self)
	umsg.String(str)
	umsg.End()
end

--SetClipboardText
function _R.Player:HAC_SCT(str)
	umsg.Start("HAC.SCT", self)
	umsg.String(str:Left(254))
	umsg.End()
end

--Kick
function _R.Player:HAC_Kick(str)
	--Kick
	if self.GetNetChannel then
		local Chan = self:GetNetChannel()
		if not Chan then return self:Kick(str) end
		Chan:Shutdown(str)

		return
	end

	self:Kick(str)
end

--Retry
function _R.Player:Retry(Res)
	if self:Banned() then return end
	self:LogOnly("! Retry")
	self:HACPEX("retry")

	self:timer(5, function()
		if not self:Banned() then
			self:HAC_Kick(Res or "Client retry")
		end
	end)
end

--Drop
function _R.Player:HAC_Drop(str, newlog)
	if not IsValid(self) then return false end
	--Close log
	HAC.PlayerDisconnected(self, newlog)
	self.HAC_NoLogDisconnect = true
	--Log
	str = str or "Kicked by server. " .. HAC.Contact
	HAC.file.Append("hac_reasons.txt", Format("\n[%s] - %s (%s) ->:\n%s\n\n", HAC.Date(), self:Nick(), self:SteamID(), str))

	--Retry if no "!" in kick message
	if not self:Banned() and not str:find("!") then
		self:Retry(str)

		return
	end

	--Kick
	self:HAC_Kick(str)
end

--Respawn if dead
function _R.Player:RespawnIfDead(same_pos)
	if self:Alive() then return end
	local Pos = self:GetPos()
	self:Spawn()

	if same_pos then
		self:SetPos(Pos)
	end

	return true
end

--Emitsound
local function EmitAndLog(self, Snd, name)
	--Emit
	if name:find("#") then
		self:HAC_SPS(Snd)
	else
		self:EmitSound(Snd)
	end

	--Skip if "!"
	if name:find("!") then return end
	--LOG
	HAC.COLCON(HAC.BLUE, "\n[HAC] SOUND: " .. name .. ": ", HAC.YELLOW, self:Nick() .. "\n")

	if self:BannedOrFailed() then
		self:WriteLog("# SOUND: " .. name)
	end
end

function _R.Player:HAC_EmitSound(Snd, name, play_now, Callback)
	--Invalid sound
	local Low = Snd:lower()
	local Dur = HAC.Resource.Sound[Low]

	if not Dur then
		debug.ErrorNoHalt("HAC_EmitSound, Tried to play un-Cache'd sound: '" .. Snd .. "', check hac_Resources!")

		return
	end

	--Skip if silent or done, ALWAYS PLAY if "#"
	if not self.HAC_DoneSounds then
		self.HAC_DoneSounds = {}
	end

	if HAC.hac_silent:GetBool() or self.HAC_DoneSounds[Low] then return Dur end

	if not name:find("#") then
		self.HAC_DoneSounds[Low] = true
	end

	--Play now, no delays!
	if play_now then
		EmitAndLog(self, Snd, name)

		--Callback
		if Callback then
			self:timer(Dur, function()
				Callback(self)
			end)
		end

		return Dur
	end

	--Select
	if not self.HAC_SndSelector then
		local function OnSelect(Sel, Idx, This)
			if not IsValid(self) then
				Sel:Remove()

				return
			end

			Sel.IsRunning = true
			--Emit
			EmitAndLog(self, This.Snd, This.name)

			--Next
			self:timer(This.Dur, function()
				Sel.IsRunning = false

				--Callback
				if This.Callback then
					This.Callback(self)
				end

				--Next
				Sel:Select()
			end)
		end

		self.HAC_SndSelector = selector.Init({}, OnSelect)
	end

	local Sel = self.HAC_SndSelector

	--MSG
	if Sel:Left() > 1 then
		HAC.COLCON(HAC.BLUE2, "[HAC] Que sound: " .. name .. ": ", HAC.YELLOW, self:Nick() .. "\n")
	end

	--LOG
	if self:BannedOrFailed() then
		self:WriteLog("# Que SOUND: " .. name)
	end

	--Add
	Sel:Add({
		Snd = Snd,
		Dur = Dur,
		name = name,
		Callback = Callback,
	})

	--Go
	if not Sel.IsRunning then
		Sel:Select()
	end

	return Dur
end

--Time
function _R.Player:Time()
	return HAC.NiceTime((self.HAC_TimeSpawn or 0) - CurTime())
end

--Time and date
function _R.Player:DateAndTime()
	return "[" .. HAC.Date() .. " @ " .. self:Time() .. "]"
end

--Hide HeX's stuff, for video
function _R.Player:Hide(hide)
	--No console spew in video!
	self:HACPEX("developer " .. (hide and "0" or "1"))

	--Spectate
	if self.HAC_DoneSpectate then
		if hide then
			self:HACPEX("hac_spectate_unload")
		else
			if HAC.Spec.Command then
				HAC.Spec.Command(self)
			end
		end
	end

	--GAN
	if hide then
		--Hide for 4 mins
		self.HAC_NoGan = true

		self:timer(4 * 60, function()
			self.HAC_NoGan = false
		end)
	else
		self.HAC_NoGan = false
	end
end

--- UserCmd ---
function _R.Player:IsCmdForced()
	return self:GetCurrentCommand():IsForced() and "FORCED" or "Clean"
end

--- Net --
function net.SendNonBanned()
	local Banned = {}

	for k, v in Humans() do
		if v:Banned() then
			table.insert(Banned, v)
		end
	end

	if #Banned >= 1 then
		net.SendOmit(Banned) --Send to everyone except banned
	else
		net.Broadcast()
	end
end

--- === Ban counter, only used for "just became the X banned player" === ---
local TotFile = "hac_totalbans.txt"

function HAC.AddOneBan()
	if not file.Exists(TotFile, "DATA") then
		HAC.file.Write(TotFile, "0")
	end

	local Total = tonumber(HAC.file.Read(TotFile)) or 0
	Total = Total + 1
	HAC.file.Write(TotFile, tostring(Total))
end

function HAC.GetAllBans()
	if not file.Exists(TotFile, "DATA") then
		HAC.file.Write(TotFile, "0")
	end

	return tonumber(HAC.file.Read(TotFile)) or 0
end

--- === COLCON === ---
function HAC.COLCON(...)
	local Col = HAC.WHITE

	for k, v in pairs({...}) do
		local typ = type(v)

		if typ == "table" and v.r then
			Col = v
		elseif typ == "Player" and IsValid(v) then
			MsgC(v:TeamColor(), v:Nick())
		elseif typ == "number" then
			MsgC(Col, tostring(v))
		elseif (typ == "Entity" or typ == "Weapon" or typ == "Vehicle" or typ == "NPC") and IsValid(v) then
			MsgC(HAC.BLUE, v:GetClass())
		else
			MsgC(Col, tostring(v))
		end
	end

	MsgC(Col, "\n")
end

--- === GAN === ---
NOTIFY_GENERIC = 0 -- >
NOTIFY_ERROR = 1 -- !
NOTIFY_UNDO = 2 -- <<
NOTIFY_HINT = 3 -- ?
NOTIFY_CLEANUP = 4 -- *

local SkipIfDisabled = {"bcode", "steal", "gpath",}

function _R.Player:HACGAN(str, typ, time, sound)
	if not IsValid(self) then return end
	str = str:Left(195)

	--No sensitive messages, for video. Cheater can't see!
	if self.HAC_NoGan and str:lower():InTable(SkipIfDisabled) then
		str = "**NOPE**"
	end

	umsg.Start("HAC.GANPLY", self)
	umsg.String(str)
	umsg.Short(typ)
	umsg.Short(time)
	umsg.String(sound or "")
	umsg.End()
end

--- === SPS === ---
local function SendSound(self, snd)
	umsg.Start("HAC.SPS", self)
	umsg.String(snd)
	umsg.End()
end

function _R.Player:HAC_SPS(snd)
	SendSound(self, snd)
end

function HAC.SPS(self, snd)
	if isstring(self) then
		SendSound(nil, self)
	else
		SendSound(self, snd)
	end
end

--- === CAT === ---
util.AddNetworkString("HAC.CAT")

local function SendCAT(self, Tab)
	net.Start("HAC.CAT")
	net.WriteTable(Tab)

	return self and net.Send(self) or net.Broadcast()
end

function _R.Player:HACCAT(...)
	SendCAT(self, {...})
end

function HAC.CAT(...)
	SendCAT(nil, {...})
end

function HAC.LagWarning()
	print("[HAC] Lag warning!")
	HAC.SPS("vo/k_lab/kl_almostforgot.wav")
	HAC.CAT(HAC.RED, "[", HAC.GREEN, "HAC", HAC.RED, "] ", HAC.BLUE, "Note: ", HAC.WHITE, "The server may ", HAC.RED, "LAG ", HAC.WHITE, "for a few seconds. ", HAC.ORANGE, "DON'T DISCONNECT, it will respond!")
end

concommand.Add("lag", function(self)
	HAC.LagWarning()
	self:print("[HAC] Fired lag warning")
end)

HAC.Sig = [[
::::     :::: :::::::::: ::::::::  ::: ::::    :::  ::::::::  
+:+:+: :+:+:+ :+:       :+:    :+:     :+:+:   :+: :+:    :+: 
+:+ +:+:+ +:+ +:+       +:+        +:+ :+:+:+  +:+ +:+        
+#+  +:+  +#+ :#::+::#  +#++:++#++ +#+ +#+ +:+ +#+ +#+        
+#+       +#+ +#+              +#+ +#+ +#+  +#+#+# +#+        
#+#       #+# #+#       #+#    #+# #+# #+#   #+#+# #+#    #+# 
###       ### ###        ########  ### ###    ####  ########  
]]
HAC.RED2 = Color(255, 0, 0) --More red
HAC.RED = Color(255, 0, 11) --Red
HAC.KIRED = Color(255, 80, 0) --Killicon Red
HAC.GREEN2 = Color(0, 255, 0) --Green
HAC.GREEN = Color(66, 255, 96) --HSP green
HAC.SGREEN = Color(180, 250, 160) --Source green
HAC.BLUE2 = Color(0, 0, 255) --Blue
HAC.SBLUE = Color(0, 255, 255) --Blue
HAC.BLUE = Color(51, 153, 255) --HeX Blue
HAC.LPBLUE = Color(80, 170, 255) --Laser pistol blue
HAC.PBLUE = Color(155, 205, 248) --printall blue
HAC.SYELLOW = Color(255, 255, 0) --LuaError Yellow
HAC.YELLOW2 = Color(255, 220, 0, 200) --HEV yellow
HAC.YELLOW = Color(255, 200, 0) --Yellow
HAC.ORANGE = Color(255, 153, 0) --Respected orange
HAC.PINK = Color(255, 0, 153) --Skiddie pink
HAC.PURPLE = Color(149, 102, 255) --ASK2 purple
HAC.KIPURPLE = Color(192, 0, 192) --Killicon Purple
HAC.SVOTE = Color(255, 64, 96) --Solidvote Purple
HAC.GREY = Color(175, 175, 175) --Blackops grey
HAC.SGREY = Color(192, 192, 192) --Source grey
HAC.WHITE = color_white
HAC.WHITE2 = Color(254, 254, 254) --White2

--Check the GM
function HAC.BaseCheck()
	if GAMEMODE.HAC_BaseIsOk then return end

	if not GAMEMODE.Name:lower():find("sandbox") then
		for k, v in pairs(HAC) do
			HAC[k] = tostring(v):upper()
		end
	end
end

timer.Simple(10, HAC.BaseCheck)

timer.Simple(1, function()
	HAC.Loaded = true
end)

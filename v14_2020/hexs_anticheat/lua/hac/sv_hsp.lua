HAC.HSP = {
	CheatSayings = {"hack", "cheat", "hak", "hax", "h4x", "aimbot", "aim bot",},
	CF_IgnoreExact = {
		["eight"] = true,
		["disappointed"] = true,
	},
	CF_Ignore = {},
	BadChars = {
		["NEWLINE"] = "\n",
		["RETURN"] = "\r",
		["NUL"] = "\0",
		["BEL"] = "\7",
	},
	CH_MaxSpam = 3, --Max total spam of the words below
	ChatBanFor = {"www.gangster-paradise.net", "gDaap - ", "A n t i B i r u s", "MapleSyrup Beta", "www.proclubowns.com", "laffff", "bighack.club", "mongo.club", "mango.club", "dango.club", "dunked.asia", "tisker.dll", "imadethem.org", "Hidden-Hacks.net", "MultiPlayerGameSnacking.com", "NerdPaste Leaked", "DANGO MAFIA",}, --Case sensitive
	Messages = {"",},
	DC_Marbles = {"",},
	--Bagpipes!
	Bagpipes = {},
	BagpipeStatus = {
		--Fine
		[1] = {"",},
		--EatKeys
		[2] = {"",},
		--Banned
		[3] = {"",},
		--Failed
		[4] = {"",},
	},
}

--[[
for i=lowascii, highascii do
	HAC.HSP.BadChars[ tostring(i) ] = string.char(i)
end
]]
--PlayerSay, done in HSP
local sCol = Color(115, 188, 24)
local rCol = Color(240, 48, 28)

--PlayerSay
--Highest priority
function HAC.HSP.Filter(self, text, isteam, dead)
	if not IsValid(self) then return false end

	--HAC monitor
	if HAC.MonitorStrings and HAC.MonitorStrings[text] then
		HAC.MonitorSay(self, text, isteam, dead)

		return false
	end

	--Call hook, for !sk
	if HAC.Skid.PlayerSay then
		self:timer(0.1, function()
			HAC.Skid.PlayerSay(self, text)
		end)
	end

	--Bagpipes
	local Low = text:lower():Trim()

	--Log all chat
	if self.HAC_LogChat or self:BannedOrFailed() then
		self:Write("chat", Format("\n%s: %s", self:DateAndTime(), text))
	end

	--Skip EatKeys messages
	if HAC.HSP.CF_IgnoreExact[Low] or Low:CheckInTable(HAC.HSP.CF_Ignore) then
		if self.HAC_DoneKeysAll or self:Is12() then
			self.HAC_LogChat = true --Log all chat
		end

		--Hammer
		if self:Alive() then
			self:HammerTime()
		end

		--Muted
		if self.HAC_IsMuted then
			self:HACCAT(self:TeamColor(), self:Nick(), HAC.WHITE, ": ", HAC.RED, text)
			print("[HAC] IsMuted: ", self, text)

			return false
		end

		return text
	else
		--Log chat without EIGHT
		if self:BannedOrFailed() or self.HAC_LogChat then
			self:Write("chat_say", Format("\n%s: %s", self:DateAndTime(), text))
		end
	end

	--Cheat, CASE
	local Found, IDX, det = text:InTable(HAC.HSP.ChatBanFor)

	if Found then
		self.HAC_ChatBanFor = (self.HAC_ChatBanFor or 0) + 1
		local Func = self.LogOnly

		if self.HAC_ChatBanFor > HAC.HSP.CH_MaxSpam then
			Func = self.DoBan
		end

		Func(self, "ChatBanFor (" .. self.HAC_ChatBanFor .. "/" .. HAC.HSP.CH_MaxSpam .. "): [[" .. text .. "]] (" .. det .. ")")

		return "Spam spam beans eggs spam spam spam"
	end

	--Bad chars
	local Found, IDX, det = Low:InTable(HAC.HSP.BadChars)

	if Found then
		self:LogOnly("ChatCheck: [[" .. text .. "]] (" .. IDX .. ")")

		return table.Random(HAC.HSP.Messages)
	end

	--"Cheat" etc spoken in chat
	local Found, IDX, det = Low:InTable(HAC.HSP.CheatSayings)

	if Found and not self:HAC_IsHeX() then
		--Log sayer
		self:WriteLog("# FLT: " .. text .. " (" .. det .. ")")

		--SC on everyone
		for k, v in Humans() do
			if v.HAC_HSP_SC_Waiting or v:IsSuperAdmin() then continue end
			v.HAC_HSP_SC_Waiting = true

			--Reset
			v:timer(20, function()
				v.HAC_HSP_SC_Waiting = false
			end)

			--SC
			v:TakeSC()
			--Log all files
			v:MakeFileList()
			--Dump all groups
			v:DumpGroups()
			--CVarList
			--v:CVarList()
		end
	end
end

timer.Simple(2, function()
	if not (HSP and HSP.ChatFilter) then
		hook.Add("PlayerSay", "!aaHAC.HSP.Filter", HAC.HSP.Filter)
	end
end)

--Handle DisconnectMsg from HSP
function HAC.HSP.Disconnect(self, SID)
	--Banned
	if HAC.Banned[SID] and self:JustBeforeBan() and not HAC.hac_silent:GetBool() then
		--Lost their marbles
		return " ()", HAC.RED
	elseif self:Is12() or self.HAC_DoneYumYum then
		return " (" .. table.RandomEx(HAC.HSP.DC_Marbles) .. ")", HAC.YELLOW
	elseif self.HAC_DoneBSoD then
		--BSoD
		return " (Bluescreen)", HAC.BLUE2
	end
end

hook.Add("HSPOnDisconnect", "HAC.HSP.Disconnect", HAC.HSP.Disconnect)

--Get location, sv_PWauth / sv_ConnectMessage (HSP)
function HAC.HSP.GetCity(addr)
	if not (HSP and GetCity) then return addr, addr end --fixme, use proper DB in HAC
	local City, Cunt = GetCity(addr)

	return City .. ", " .. Cunt
end

--Abort map change
function HAC.HSP.AbortMapChange()
	if not (utilx and utilx.AbortMapChange) then return end --timer.Simple(30, game.LoadNextMap)
	utilx.AbortMapChange(true)
end

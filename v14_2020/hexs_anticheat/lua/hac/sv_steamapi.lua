--fixme, this entire thing is shit. Make proper tables or library, use Selector for retries, make auto-retrying http function with callbacks, also possible caching on VAC / static data?
HAC.Steam = {
	BeforeKick = 35,
	IgnorePrivate = {},
	IgnoreGroup = {},
	--Ban if lender's SK reason cotnains this
	ReBan = {"ban me", "banme", "evasion", "forever", "ddos", "steal", "c++", "snix",},
}

--"vac ban",
local ProfEnabled = CreateConVar("hac_prof", 1, false, false)
local VACEnabled = CreateConVar("hac_vac", 0, false, false)
local AltEnabled = CreateConVar("hac_alt", 1, false, false)
local GroupEnabled = CreateConVar("hac_group", 1, false, false)

--VAC
HAC.NoPromote = {
	[7] = "Cheater",
	[10] = "Previous Cheater",
	[22] = "12yo",
	[33] = "Balls of steel",
	[35] = "VAC",
}

HAC.VACTries = {}
HAC.VACBanned = {}

local function RetryVAC(SID)
	HAC.VACTries[SID] = (HAC.VACTries[SID] or 0) + 1

	timer.Simple(3, function()
		HAC.Steam.GetPlayerBans(SID)
	end)
end

function HAC.Steam.GetPlayerBans(SID)
	local Res = HAC.VACTries[SID]

	if Res and Res > 3 then
		ErrorNoHalt("VACCheck: Tried 3 times for " .. SID .. ", give up :(\n")

		return
	end

	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerBans/v0001/?key=" .. HAC.Conf.APIKey .. "&format=json&steamids=" .. SID, function(cont)
		local body = util.JSONToTable(cont)

		--Body
		if not body then
			ErrorNoHalt("VACCheck: no body: " .. SID .. "\n")
			RetryVAC(SID)
			HAC.file.Append("GetPlayerBans" .. "-" .. SID .. ".txt", cont)

			return
		end

		--Banned
		if body.players and body.players[1] then
			body = body.players[1]

			if tobool(body.VACBanned) then
				HAC.VACBanned[SID] = {body.NumberOfVACBans, body.DaysSinceLastBan}
			end
		else
			--No player
			ErrorNoHalt("VACCheck: no players: " .. SID .. "\n")
			RetryVAC(SID)
			HAC.file.Append("VACCheck_NoPlayers" .. "-" .. SID .. ".txt", cont)
		end
	end, function(code)
		--No connection, retry
		--ErrorNoHalt("VACCheck: Failed HTTP for "..SID.." (Error: "..code..")\n")
		RetryVAC(SID)
	end)
end

--Profile
HAC.ProfTries = {}
HAC.ProfPrivate = {}

local function RetryProf(SID)
	HAC.ProfTries[SID] = (HAC.ProfTries[SID] or 0) + 1

	timer.Simple(3, function()
		HAC.Steam.GetPlayerSummaries(SID)
	end)
end

function HAC.Steam.GetPlayerSummaries(SID)
	local Res = HAC.ProfTries[SID]

	if Res and Res > 3 and HAC.ProfPrivate[SID] == nil then
		ErrorNoHalt("GetPlayerSummaries: Tried 3 times for " .. SID .. ", give up :(\n")

		return
	end

	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. HAC.Conf.APIKey .. "&steamids=" .. SID, function(cont)
		--Body
		local body = util.JSONToTable(cont)

		if not (body and body.response and body.response.players) then
			--No body
			ErrorNoHalt("GetPlayerSummaries: no body: " .. SID .. "\n")
			RetryProf(SID)
			HAC.file.Append("GetPlayerSummaries" .. "-" .. SID .. ".txt", cont)

			return
		end

		--Data
		local This = body.response.players[1]

		if not This then
			ErrorNoHalt("GetPlayerSummaries: no data: " .. SID .. "\n")
			RetryProf(SID)

			return
		end

		--Private
		if This.communityvisibilitystate then
			HAC.ProfPrivate[SID] = tonumber(This.communityvisibilitystate) ~= 3 --PROF_PUBLIC
		else
			ErrorNoHalt("GetPlayerSummaries: no communityvisibilitystate: " .. SID .. "\n")
			RetryProf(SID)
		end
	end, function(code)
		--No connection, retry
		--ErrorNoHalt("GetPlayerSummaries: Failed HTTP for "..SID.." (Error: "..code..")\n")
		RetryProf(SID)
	end)
end

--Shared
HAC.SharedTries = {}
HAC.ProfShared = {}

local function RetryShared(SID)
	HAC.SharedTries[SID] = (HAC.SharedTries[SID] or 0) + 1

	timer.Simple(3, function()
		HAC.Steam.IsPlayingSharedGame(SID)
	end)
end

function HAC.Steam.IsPlayingSharedGame(SID)
	local Res = HAC.SharedTries[SID]

	if Res and Res > 3 and HAC.ProfShared[SID] == nil then
		ErrorNoHalt("IsPlayingSharedGame: Tried 3 times for " .. SID .. ", give up :(\n")

		return
	end

	http.Fetch("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=" .. HAC.Conf.APIKey .. "&steamid=" .. SID .. "&appid_playing=4000&format=json", function(cont)
		--Body
		local body = util.JSONToTable(cont)

		if not (body and body.response and body.response.lender_steamid) then
			--No body
			ErrorNoHalt("IsPlayingSharedGame: no body: " .. SID .. "\n")
			RetryShared(SID)
			HAC.file.Append("IsPlayingSharedGame" .. "-" .. SID .. ".txt", cont)

			return
		end

		--Add, check this later, != "0"
		HAC.ProfShared[SID] = body.response.lender_steamid
	end, function(code)
		--No connection, retry
		--ErrorNoHalt("IsPlayingSharedGame: Failed HTTP for "..SID.." (Error: "..code..")\n")
		RetryShared(SID)
	end)
end

--Owned
HAC.OwnedTries = {}
HAC.ProfNotOwn = {} --No GMod
HAC.ProfIsFake = {} --No games / cannot query

local function RetryOwned(SID)
	HAC.OwnedTries[SID] = (HAC.OwnedTries[SID] or 0) + 1

	timer.Simple(3, function()
		HAC.Steam.GetOwnedGames(SID)
	end)
end

function HAC.Steam.GetOwnedGames(SID)
	local Res = HAC.OwnedTries[SID]

	if Res and Res > 3 then
		ErrorNoHalt("GetOwnedGames: Tried 3 times for " .. SID .. ", give up :(\n")

		return
	end

	http.Fetch("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=" .. HAC.Conf.APIKey .. "&steamid=" .. SID .. "&format=json", function(cont)
		--Body
		local body = util.JSONToTable(cont)

		if not (body and body.response) then
			--No body
			ErrorNoHalt("GetOwnedGames: no body: " .. SID .. "\n")
			RetryOwned(SID)
			HAC.file.Append("GetOwnedGames" .. "-" .. SID .. ".txt", cont)

			return
		end

		--STOP HERE, private profile!, can't check games!
		if not body.response.game_count then return end

		--No games, fake profile!
		if tonumber(body.response.game_count) == 0 then
			HAC.ProfIsFake[SID] = true

			return
		end

		--Has GMod
		local NoGMod = true

		for k, Tab in pairs(body.response.games) do
			for k, v in pairs(Tab) do
				if k == "appid" and tonumber(v) == 4000 then
					NoGMod = nil
					break
				end
			end
		end

		HAC.ProfNotOwn[SID] = NoGMod
	end, function(code)
		--No connection, retry
		--ErrorNoHalt("GetOwnedGames: Failed HTTP for "..SID.." (Error: "..code..")\n")
		RetryOwned(SID)
	end)
end

--Group
HAC.GroupTries = {}
HAC.ProfGroup = {}

local function RetryGroup(SID)
	HAC.GroupTries[SID] = (HAC.GroupTries[SID] or 0) + 1

	timer.Simple(3, function()
		HAC.Steam.IsPlayingSharedGame(SID)
	end)
end

function HAC.Steam.GetUserGroupList(SID)
	local Res = HAC.GroupTries[SID]

	if Res and Res > 3 then
		ErrorNoHalt("GetUserGroupList: Tried 3 times for " .. SID .. ", give up :(\n")

		return
	end

	http.Fetch("http://api.steampowered.com/ISteamUser/GetUserGroupList/v0001/?key=" .. HAC.Conf.APIKey .. "&steamid=" .. SID, function(cont)
		--Body
		local body = util.JSONToTable(cont)

		if not (body and body.response) then
			--No body
			ErrorNoHalt("GetUserGroupList: no body: " .. SID .. "\n")
			RetryGroup(SID)
			HAC.file.Write("GetUserGroupList" .. "-" .. SID .. ".txt", cont)

			return
		end

		--No success, private profile
		if not body.response.success then return end
		--Data
		local Tab = body.response.groups

		if not Tab then
			ErrorNoHalt("GetUserGroupList: no data: " .. SID .. "\n")
			RetryGroup(SID)

			return
		end

		--No groups
		if #Tab == 0 then return end
		--Check
		local Bad = {}
		local NotBad = {}

		for k, This in pairs(Tab) do
			for k, GID32 in pairs(This) do
				local BadGroup = HAC.Group.BadGroups_32[GID32]

				if BadGroup then
					table.insert(Bad, {
						Name = BadGroup[1], --Name
						GID64 = BadGroup[2], --GID64
						GID32 = GID32,
					})
				else
					table.insert(NotBad, GID32)
				end
			end
		end

		HAC.ProfGroup[SID] = {
			Bad = Bad,
			NotBad = NotBad,
		}
	end, function(code)
		--No connection, retry
		ErrorNoHalt("GetUserGroupList: Failed HTTP for " .. SID .. " (Error: " .. code .. ")\n")
		RetryGroup(SID)
	end)
end

--First spawn
function HAC.Steam.PlayerInitialSpawn(self)
	if self:IsBot() or self:IsSuperAdmin() then return end
	local SID = self:SteamID64()
	--Shared
	HAC.Steam.IsPlayingSharedGame(SID)

	--Private
	--Skip some people
	if not HAC.Steam.IgnorePrivate[self:SteamID()] then
		HAC.Steam.GetPlayerSummaries(SID)
	end

	--Owned
	HAC.Steam.GetOwnedGames(SID)
	--Group
	HAC.Steam.GetUserGroupList(SID)
end

hook.Add("PlayerInitialSpawn", "HAC.Steam.PlayerInitialSpawn", HAC.Steam.PlayerInitialSpawn)

--Really spawn
function HAC.Steam.ReallySpawn(self)
	--VAC
	self.HAC_CanAPI_VAC = true
	--Skip if already in file
	local Cont = HAC.file.Read("vac_banned.txt")

	if not ValidString(Cont) or (ValidString(Cont) and not Cont:lower():find(self:SteamID():lower())) then
		HAC.Steam.GetPlayerBans(self:SteamID64())
	end
end

hook.Add("HACReallySpawn", "HAC.Steam.ReallySpawn", HAC.Steam.ReallySpawn)

--Log
local function LogPlayer(v, SteamID, fName, Reason)
	HAC.COLCON(HAC.RED, "\n[SteamAPI] ", HAC.PINK, Reason .. "\t", HAC.YELLOW, v:Nick(), HAC.BLUE, " (" .. SteamID .. ")\n")
	--Encounters
	local Log = Format('\n\t["%s"] = {"%s", "%s"}, --[%s]', SteamID, v:Nick():VerySafe(), Reason, HAC.Date())
	HAC.file.Append("api_encounters.txt", Log)
	--This log
	local Cont = file.Read(fName, "DATA")
	if Cont and Cont:find(SteamID) then return end
	HAC.file.Append(fName, Log)
end

--Fake, cannot get games
local function Fake(v, SID, SteamID)
	if not HAC.ProfIsFake[SID] then return end
	HAC.ProfIsFake[SID] = nil
	--Log
	LogPlayer(v, SteamID, "alt_accounts.txt", "API_NO_GAMES")
	--SkidCheck
	HAC.Skid.Add("sk_bulk_api.txt", SteamID, "NO GAMES", true)

	--Kick
	if AltEnabled:GetBool() then
		v:FailInit("API_NO_GAMES", "VC_Fake_", "1")
	end

	--No rejoin
	HAC.NeverSend[SteamID] = {"API_NO_GAMES", HAC.Msg.VC_Fake_2}

	--IP
	--IP
	HAC.NeverSendIP[v:IPAddress(true)] = {"API_NO_GAMES", HAC.Msg.VC_Fake_3}

	--Permaban
	v.HAC_DoPermaAPI = true

	return true
end

--Doesn't own GMod
local function NotOwn(v, SID, SteamID)
	if not HAC.ProfNotOwn[SID] then return end
	HAC.ProfNotOwn[SID] = nil
	--Log
	LogPlayer(v, SteamID, "no_gmod_accounts.txt", "API_No_GMod")
	--SkidCheck
	HAC.Skid.Add("sk_bulk_api.txt", SteamID, "Doesn't own GMod", true)

	--Kick
	if AltEnabled:GetBool() then
		v:FailInit("API_No_GMod", "VC_GMod_", "1")
	end

	--No rejoin
	HAC.NeverSend[SteamID] = {"API_No_GMod", HAC.Msg.VC_GMod_2}

	--IP
	--IP
	HAC.NeverSendIP[v:IPAddress(true)] = {"API_No_GMod", HAC.Msg.VC_Fake_2}

	--Permaban
	v.HAC_DoPermaAPI = true

	return true
end

--VAC
local function VAC(v, SID, SteamID)
	local Tab = HAC.VACBanned[SID]
	if not Tab then return end
	local Tot, Last = Tab[1], Tab[2]
	HAC.VACBanned[SID] = nil
	--Log
	local Log = (Tot > 1 and Tot .. "x " or "") .. "VAC ban" .. (Tot > 1 and "s" or "") .. ", " .. Last .. " days ago"
	LogPlayer(v, SteamID, "vac_banned.txt", Log)

	--Rank
	if VACEnabled:GetBool() then
		if not (v:Banned() or HAC.hac_silent:GetBool()) then
			v:timer(5, function()
				if not HAC.NoPromote[v:GetLevel()] then
					v:SetLevel(35) --VAC BANNED
					--Message
					HAC.CAT(HAC.RED, "[", HAC.GREEN, "HAC", HAC.RED, "] ", v:TeamColor(), v:Nick(), HAC.WHITE, " has earned a new rank for being", HAC.RED, " VAC BANNED" .. (Tot == 1 and "" or " MULTIPLE TIMES"), HAC.PURPLE, " " .. Last .. " days ago!")

					--Sound
					for x, y in Humans() do
						y:EmitSound(Sound("ambient/machines/thumper_shutdown1.wav"))
					end
				end
			end)
		end

		--Kick
		--Cheated here as well
		if v:HAC_InDB() and not v.DONEBAN then
			--Permaban
			v:PermaBan("API_VAC_AND_CHEATED", "VAC2")
			--Fail
			v:FailInit("API_VAC_BANNED", "VC_VAC_", "1")
		end

		--Ban for more than 1 VAC ban
		if Tot > 1 then
			v:DoBan("SteamAPI=" .. Log)
		end
	end

	return true
end

--Private
local function Private(v, SID, SteamID)
	if not HAC.ProfPrivate[SID] then return end
	HAC.ProfPrivate[SID] = nil
	--Log
	LogPlayer(v, SteamID, "priv_profile.txt", "PRIVATE PROFILE")

	--Kick
	if ProfEnabled:GetBool() then
		--No rejoin
		if not HAC.hac_silent:GetBool() then
			HAC.NeverSend[SteamID] = {"API_PRIVATE_PROFILE", HAC.Msg.VC_PrivJoin}

			timer.Simple(HAC.Init.KickTime + 60, function()
				HAC.NeverSend[SteamID] = nil
			end)
		end

		--Kick
		v:FailInit("API_PRIVATE_PROFILE", "VC_Priv_", "1")
	end

	return true
end

--Shared account
local function Shared(v, SID, SteamID)
	local Lender64 = HAC.ProfShared[SID]

	--Not shared
	if not Lender64 or Lender64 == "0" then
		HAC.ProfShared[SID] = nil

		return
	end

	HAC.ProfShared[SID] = nil
	--Convert
	local Lender = util.SteamIDFrom64(Lender64)

	if not Lender then
		Lender = Lender64
		ErrorNoHalt("sv_SteamAPI: Shared: No Lender (" .. tostring(Lender64) .. ") from Lender64 (" .. tostring(Lender) .. ") - " .. tostring(v) .. "\n")
	end

	--Not in DB, SkidCheck
	local LenderRes = "Ban Evasion (Alt of " .. Lender .. ")"
	local ThisRes = "Ban Evasion (" .. SteamID .. ")"

	if not HAC.InDB(Lender) then
		HAC.Skid.Add("sk_bulk_api.txt", SteamID, LenderRes, true) --This
		HAC.Skid.Add("sk_bulk_api.txt", Lender, ThisRes, true) --Lender
	end

	--Log
	LogPlayer(v, SteamID, "shared_profile.txt", "API_SHARED_ACCOUNT " .. LenderRes)
	--Main log
	v:LogOnly(LenderRes)

	--Kick
	if AltEnabled:GetBool() then
		v:FailInit("API_SHARED_ACCOUNT " .. LenderRes, "VC_Share_", "1")
	end

	--Permaban Lender
	local ipaddr = v:IPAddress(true)
	HAC.PermaBan(Lender, ipaddr, v:Nick(), "Lending to cheater " .. SteamID, "Global")

	--SID
	HAC.NeverSend[Lender] = {ThisRes, HAC.Msg.VC_Share_1}

	--IP
	HAC.NeverSendIP[ipaddr] = {LenderRes, HAC.Msg.VC_Fake_1}

	--Permaban this
	--SID
	HAC.NeverSend[SteamID] = {LenderRes, HAC.Msg.VC_Share_3}

	--BAN
	local Reason = HAC.Skiddies[Lender]

	if Reason then
		v:DoBan(Format("API_SHARED_REBAN (%s) (Alt %s), SK: %s", SteamID, Lender, Reason))
	end

	v.HAC_DoPermaAPI = true

	return true
end

--Group
HAC.GroupKicked = {}

local function Group(v, SID, SteamID)
	local This = HAC.ProfGroup[SID]
	if not This then return end

	--Not bad groups, used in sv_Group
	if not v.HAC_NotBadGroups and (This.NotBad and #This.NotBad ~= 0) then
		v.HAC_NotBadGroups = table.Copy(This.NotBad)
	end

	--Bad, used below
	if not This.Bad or #This.Bad == 0 then return end
	local Bad = This.Bad
	--Log
	local BadGroup = "BAD GROUP (" .. Bad[1].Name .. ")"
	LogPlayer(v, SteamID, "group_profile.txt", BadGroup)
	--SkidCheck
	HAC.Skid.Add("sk_bulk_api.txt", SteamID, BadGroup, true)
	--Log
	local Log = "\nAPI_BAD_GROUP for " .. v:HAC_Info(1, 1) .. ":\n"

	for k, Tab in pairs(Bad) do
		Log = Log .. Format("\n%s\nhttp://steamcommunity.com/groups/%s\n", Tab.GID64, Tab.Name)

		--Kick
		if GroupEnabled:GetBool() then
			local Reason = Format("API_BAD_GROUP=%s (%s, %s) http://steamcommunity.com/groups/%s", Tab.Name, Tab.GID64, Tab.GID32, Tab.Name)

			if HAC.Steam.IgnoreGroup[SteamID] then
				v:WriteLog(Reason)
			else
				v:FailInit(Reason, "VC_Group_", "3")
			end
		end
	end

	Log = Log .. "\nEnd check\n"
	--Write
	v:Write("api_groups", Log)
	HAC.ProfGroup[SID] = nil

	return true
end

--Check
local function DoBad(v)
	--CVarList
	--v:CVarList() --Fucked 01.06
	--SC
	v:TakeSC()
end

function HAC.Steam.CheckAPI()
	for k, v in Humans() do
		local SteamID = v:SteamID()
		local SID = v:SteamID64()

		--Shared
		if Shared(v, SID, SteamID) then
			DoBad(v)
		end

		--Not own GMod
		if NotOwn(v, SID, SteamID) or Fake(v, SID, SteamID) then
			DoBad(v)
		end

		--Group
		if Group(v, SID, SteamID) then
			DoBad(v)
		end

		--VAC
		if v.HAC_CanAPI_VAC and VAC(v, SID, SteamID) then
			DoBad(v)
		end

		--Private
		if Private(v, SID, SteamID) then
			DoBad(v)
		end

		--Permaban
		if v.HAC_DoPermaAPI and (v:Banned() or v:HAC_InDB()) then
			v.HAC_DoPermaAPI = false
			v:PermaBan("API_SHARED_AND_CHEATED", "Global")
			v:LogOnly(">>>PERMABAN<<< - API_SHARED_AND_CHEATED")
		end
	end
end

timer.Create("HAC.Steam.CheckAPI", 2, 0, HAC.Steam.CheckAPI)

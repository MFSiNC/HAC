HAC.FSA = {
	--No spawn protection/god mode, always glow
	NoProtect = {
		[7] = 1, --Cheater
		[10] = 1, --PREVIOUS CHEATER
		[22] = 1, --12
		[29] = 1, --Known CHEATER
		[33] = 1, --Balls of Steel
		[35] = 1, --VAC BANNED

	},
}

--Used in HSP
function _R.Player:HAC_IsBadRank()
	local Lev = self:GetLevel()

	return HAC.FSA.NoProtect[Lev], Lev
end

function HAC.FSA.Setup(self)
	if not self:HAC_IsBadRank() then
		--Disable halo if not bad rank
		if self:HaloEnabled() and not self:Banned() then
			self:DrawHalo(false)
		end

		return
	end

	--No grave, sv_Graves, HSP
	self.HSP_NoGrave = true
	--No ASK2
	self.ASK2Spawned = true
	--No godmode
	self:GodDisable()

	--Glow
	if self:IsReady() and not self:Banned() then
		self:DrawHalo(true)
	end
end

hook.Add("PlayerSpawn", "HAC.FSA.Setup", HAC.FSA.Setup)
hook.Add("PlayerDeath", "HAC.FSA.Setup", HAC.FSA.Setup)
hook.Add("HACPlayerSpawn", "HAC.FSA.Setup", HAC.FSA.Setup)

--Every
function HAC.FSA.Every()
	for k, v in Everyone() do
		HAC.FSA.Setup(v)
	end
end

timer.Create("HAC.FSA.Every", 10, 0, HAC.FSA.Every)

--Respawn on fountain
function HAC.FSA.PlayerDeathThink(self)
	local IsBad, Lev = self:HAC_IsBadRank()
	if not IsBad then return end
	if self:VarSet("HAC_IdiotSpawned") then return end

	self:timer(1, function()
		self.HAC_IdiotSpawned = false
		self:Spawn()
		self:SetHealth(8)
		--Not VAC'd
		if Lev == 35 then return end

		--sv_Idiot
		if HAC_12POS then
			self:SetPos(HAC_12POS)
		elseif HAC_POS then
			self:SetPos(HAC_POS)
		end
	end)
end

hook.Add("PlayerDeathThink", "HAC.FSA.PlayerDeathThink", HAC.FSA.PlayerDeathThink)
---=== Fake EatKeysAll ===---
local RANDOM = 8
local EIGHT = "uhdm/hac/eight.wav"

local Keys = {
	--GM hooks
	q = {
		Say = "IM ON A HIGHWAY TO bagpipes",
		Sound = "uhdm/hac/highway_to_hell.mp3"
	},
	f = {
		Say = RANDOM,
		Sound = EIGHT
	},
	x = {
		Say = "DISAPPOINTED",
		Sound = EIGHT
	},
	v = {
		Say = "I am too young for GMod 32",
		Sound = EIGHT,
		Kill = true
	},
	z = {
		Say = "I am too young for GMod 36",
		Kill = true
	},
	F1 = {
		Say = RANDOM,
		Sound = EIGHT
	},
	F2 = {
		Say = RANDOM,
		Sound = EIGHT
	},
	F3 = {
		Say = RANDOM,
		Sound = EIGHT
	},
	F4 = {
		Say = RANDOM,
		Sound = EIGHT
	},
	--IN_KEYS
	[IN_SCORE] = {
		Say = "I popped it!",
		Sound = EIGHT
	},
	[IN_ATTACK] = {
		Say = "Ive lost my marbles! 107"
	},
	[IN_ATTACK2] = {
		Say = "Piece of shit!",
		Sound = "uhdm/hac/still_not_working.mp3"
	},
	[IN_JUMP] = {
		Say = "Wheres my hammer",
		Sound = EIGHT
	},
	[IN_DUCK] = {
		Say = "Oh dear!",
		Sound = EIGHT,
		Kill = true
	},
	[IN_SPEED] = {
		Say = "I popped it!",
		Sound = EIGHT
	},
	[IN_RUN] = {
		Say = "Wheres my hammer",
		Sound = EIGHT
	},
	[IN_WALK] = {
		Say = "Wheres my hammer",
		Sound = EIGHT
	},
	[IN_USE] = {
		Say = "I am too young for GMod 15",
		Sound = EIGHT
	},
	[IN_RELOAD] = {
		Say = "I am too young for GMod 28",
		Sound = EIGHT
	},
	--WASD
	[IN_FORWARD] = {
		Say = "I am too young for GMod 33",
		Sound = EIGHT
	},
	[IN_BACK] = {
		Say = "WHO WILL REPAIR MY BAGPIPES",
		Sound = EIGHT
	},
	[IN_LEFT] = {
		Say = "I AM A DIRTY light bulb, BAN MY ASS!",
		Sound = EIGHT
	},
	[IN_MOVELEFT] = {
		Say = "Wheres my hammer",
		Sound = EIGHT
	},
	[IN_MOVERIGHT] = {
		Say = "EIGHT!",
		Sound = EIGHT
	},
	[IN_RIGHT] = {
		Say = "EIGHT!",
		Sound = EIGHT
	},
	[IN_CANCEL] = {
		Say = "WHO WILL REPAIR MY BAGPIPES"
	},
	[IN_ALT1] = {
		Say = RANDOM
	},
	[IN_ALT2] = {
		Say = RANDOM
	},
	[IN_BULLRUSH] = {
		Say = RANDOM
	},
	[IN_GRENADE1] = {
		Say = RANDOM
	},
	[IN_GRENADE2] = {
		Say = RANDOM
	},
	[IN_WEAPON1] = {
		Say = RANDOM
	},
	[IN_WEAPON2] = {
		Say = RANDOM
	},
	[IN_ZOOM] = {
		Say = RANDOM
	},
}

local Wait = false
local WaitFor = 0.95

function HAC.FSA.DoKeyAction(self, Key)
	if not self.HAC_DoFakeKeys then return end
	local Tab = Keys[Key]
	if not Tab then return end

	--Rate limit!
	if not Wait then
		Wait = true

		timer.Simple(WaitFor, function()
			Wait = false
		end)

		--Say
		self:Say(Tab.Say == RANDOM and (math.OneIn(1) and "I AINT HAVIN IT" or "BURST ME BAGPIPES") or Tab.Say)

		--Sound
		if Tab.Sound then
			if Key == "q" then
				self:HAC_SPS(self:Banned() and EIGHT or Tab.Sound)
			else
				self:EmitSound(Tab.Sound)
			end
		end

		--Kill
		if Tab.Kill then
			self:HACPEX("kill")
		end
	end
end

--Most keys
local Skip = {
	[IN_ATTACK] = 1,
	[IN_ATTACK2] = 1,
	[IN_FORWARD] = 1,
	[IN_BACK] = 1,
	[IN_LEFT] = 1,
	[IN_MOVELEFT] = 1,
	[IN_MOVERIGHT] = 1,
	[IN_RIGHT] = 1,
}

function HAC.FSA.KeyPress(self, Key)
	if not self.HAC_DoFakeKeys then return end

	--Camera
	if not Skip[Key] then
		self:SelectWeapon("gmod_camera")
	end

	--Say
	HAC.FSA.DoKeyAction(self, Key)
end

hook.Add("KeyPress", "!HAC.FSA.KeyPress", HAC.FSA.KeyPress)

local function AddSelfHook(Key, What)
	hook.Add(What, "!HAC.FSA." .. What, function(self)
		HAC.FSA.DoKeyAction(self, Key)
	end)
end

AddSelfHook("F1", "ShowHelp")
AddSelfHook("F2", "ShowTeam")
AddSelfHook("F3", "ShowSpare1")
AddSelfHook("F4", "ShowSpare2")
AddSelfHook("q", "HSP.QMonitor.Open")
AddSelfHook("v", "PlayerNoClip")
AddSelfHook("f", "PlayerSwitchFlashlight")
--[[
//X, spam!
hook.Add("PlayerCanHearPlayersVoice", "HAC.FSA.PlayerCanHearPlayersVoice", function(listener,self)
	HAC.FSA.DoKeyAction(self, "x")
end) 
]]
--Z
local Tab = concommand.GetTable()
local CC_UndoLast = Tab.gmod_undo

function HAC.FSA.CC_UndoLast(self, cmd, args)
	HAC.FSA.DoKeyAction(self, "z")

	return CC_UndoLast(self, cmd, args)
end

if CC_UndoLast then
	Tab.undo = HAC.FSA.CC_UndoLast
	Tab.gmod_undo = HAC.FSA.CC_UndoLast
else
	ErrorNoHalt("sv_FSA.lua, HAC can't find gmod_undo in concommand table, blame garry!\n\n")
end

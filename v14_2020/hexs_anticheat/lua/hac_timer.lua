timer.__index = timer
timer.AllTimers = {}
TIMER_STOP = 1
TIMER_KILL = 2
TIMER_WAIT = 3

--Check
function timer.CheckAll()
	for k, self in pairs(timer.AllTimers) do
		if self._Stop then continue end
		self._Count = self._Count + TICK_INTERVAL - 0.00054
		--Done
		local Count = self._Count

		if Count >= self._Total then
			local Res = self.End(self, self._Total)

			--Kill if not WAIT
			if not Res or Res ~= TIMER_WAIT then
				self:Kill()
			elseif Res == TIMER_WAIT then
				self:Toggle(false)
			end
			--Tick
		else
			--UpTo
			local UpTo = math.Round(Count, 1)
			if self._Done[UpTo] then continue end
			self._Done[UpTo] = true
			self._UpTo = UpTo
			--Remaining
			local Rem = -math.Round(Count - self._Total, 1)
			Rem = Rem == -0 and 0 or Rem
			self._Rem = Rem
			--Tick
			local Res = self.Tick(self, UpTo, Rem, self._Total)

			if Res == TIMER_STOP then
				self:Toggle(false)
			elseif Res == TIMER_KILL then
				self:Kill()
			elseif Res == TIMER_WAIT then
			end
			--Nothing
		end
	end
end

hook.Add("Think", "timer.CheckAll", timer.CheckAll)

--Add
function timer.Add(Name, when, End, Tick)
	local This = setmetatable({
		Name = Name,
		End = End,
		Tick = Tick,
		_Count = 0,
		_Total = when,
		_Total_Old = when,
		_Stop = false,
		_Done = {},
		_UpTo = 0,
		_Rem = 0,
	}, timer)

	timer.AllTimers[Name] = This

	return This
end

function timer:Toggle(state)
	self._Stop = not state
end

function timer:Kill()
	self._Stop = true
	self._Done = {}
	timer.AllTimers[self.Name] = nil
	self = nil
end

function timer:Reset(time, no_reset)
	if not no_reset then
		self._Count = 0
	end

	self._Total = time or self._Total_Old
	self._Done = {}
end

function timer:AddTime(time)
	self:Reset(self._Total_Old + time, true)
end

function timer:SetTime(time)
	self:Reset(time)
end

function timer:Total()
	return self._Total
end

function timer:UpTo()
	return self._UpTo
end

function timer:Rem()
	return self._Rem
end

function timer:TimeLeft()
	local When = tostring(self._Rem):Split(".") --Absolute fucking mess, how am I supposed to do it!?
	local Sec, Mil = When[1], (When[2] or "00"):sub(0, -1)
	local Mins = math.floor(Sec / 60) % 60
	local Seconds = math.Round(Sec % 60)
	Seconds = Seconds < 10 and "0" .. Seconds or Seconds
	local mSec = #Mil == 1 and "0" .. Mil or Mil

	return Format("%s:%s.%s", Mins, Seconds, mSec)
end
--[[

local Now = RealTime()

local function End(self, Total)
	print("\n! end: ", Total, -(Now - RealTime()) )

	self:Kill()
end

Fuck = false
local function Tick(self, UpTo, Rem, Tot)
	print("! Tick: ", UpTo, Rem, Tot)

	if not Fuck and UpTo == 0.2 then
		Fuck = true
		print("! stop")

		timer.Simple(1, function()
			print("! restart")

			--self:AddTime(1)
			--self:SetTime(3)
			--self:Reset()

			self:Toggle(true)
		end)

		return TIMER_STOP
	end
end
local Timer = timer.Add("Poop", 0.5, End,Tick)

]]

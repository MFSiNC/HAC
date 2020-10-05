
HAC = {}
------------------------





do return end


function math.Within(This, Low,High)
	return This > Low and This < High
end


local TickRate = 33 --engine.TickInterval()
local Window = 30 --Second window for
local MaxBad = 5 --This many seconds of bad ticks

timer.Create("lol", 1, 0, function()
	for k,self in pairs( player.GetHumans() ) do
		if not self.Tick or self:InVehicle() then continue end
		
		--print("# ts: ", self.Tick)
		
		//Too many
		if self.HAC_CanCheckSpeed and self.Tick > TickRate then
			if not math.Within(self.Tick, 30, 35) then
				--print("! tick error: ", self.Tick)
				
				//Reset window
				timer.Create( tostring(self), Window, 1, function()
					if IsValid(self) then
						self.HAC_BadTicks = 0
					end
				end)
				
				//MaxBad
				self.HAC_BadTicks = self.HAC_BadTicks + 1
				if self.HAC_BadTicks > MaxBad then
					--print(">>SPEED HACK<<: ", self.Tick)
					
					self:LogOnly("Speedhack = "..self.Tick)
				end
			else
				--print("| tick check: ", self.Tick)
			end
		end
		
		self.Tick = 0
	end
end)


hook.Add("StartCommand", "LOL", function(self,cmd)
	if not self.Tick then
		self.HAC_BadTicks 	= 0
		self.Tick 			= 0
	end
	
	--print("! cmd: ", CurTime() )
	self.Tick = self.Tick + 1
end)

hook.Add("PlayerInitialSpawn", "LOL", function(self)
	timer.Simple(6, function()
		if IsValid(self) then
			self.HAC_CanCheckSpeed = true
		end
	end)
end)



--[[
local function NoSpeed(ply,data)
	if not ply.HAC_LastMove then
		ply.HAC_LastMove = 0
	end
	
	if ply.HAC_LastMove > 33 then
		local CurTime = CurTime()
		
		if ply.HAC_LastMoveClear and (CurTime - ply.HAC_LastMoveClear < 0.9) then
			data:SetMaxSpeed(0)
			data:SetForwardSpeed(0)
			data:SetUpSpeed(0)
			data:SetSideSpeed(0)
			data:SetMaxClientSpeed(0)
			
			print( Format("Speedhack=%s", ply.HAC_LastMove) )
			return data
		end
		
		ply.HAC_LastMove = 0
		ply.HAC_LastMoveClear = CurTime
	end
	
	ply.HAC_LastMove = ply.HAC_LastMove + 1
end
hook.Add("Move", "NoSpeed", NoSpeed)

]]



--[[
hook.Add("Tick", "LOL", function()
	for k,self in pairs( player.GetHumans() ) do
		if not self.Ticks then continue end
		
		if self.Ticks > TickRate then
			print("! tick error: ", self.Ticks)
		end
		self.Ticks = 0
	end
end)
]]



















































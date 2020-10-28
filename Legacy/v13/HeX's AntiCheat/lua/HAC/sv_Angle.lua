
HAC.Angle = {
	Bad = {
		[180] 	= 1,
		[-180] 	= 1,
		[181] 	= 1,
		[-181] 	= 1,
		[360] 	= 1,
		[-360] 	= 1,
		[350] 	= 1,
		[-350] 	= 1,
		[351] 	= 1,
		[-351] 	= 1,
	}
}


local function Reset(self)
	timer.Simple(3, function()
		if IsValid(self) then
			self.HAC_BlockAAA = nil
		end
	end)
end

//Check angles
function HAC.Angle.StartCommand(self,cmd)
	if not self:Alive() or self:InVehicle() or self:IsBot() then return end
	local Ang 	= cmd:GetViewAngles()
	local Pitch = Ang.p
	local Block = false
	
	//2 in a row, blacklist
	if not self.HAC_LastAng then self.HAC_LastAng = angle_zero end
	if self.HAC_LastAng == Pitch and HAC.Angle.Bad[ Pitch ] then
		Block = true
		
		if not self.HAC_BlockAAA then
			self.HAC_BlockAAA = true
			Reset(self)
			
			//Log
			ErrorNoHalt("BadAng="..Pitch..", "..self:HAC_Info().."\n")
			
			//BAN
			self:DoBan("BadAng="..Pitch, HAC.Msg.AN_BadAng)
		end
	end
	self.HAC_LastAng = Pitch
	
	
	//Out of bounds
	if (Pitch < -91 or Pitch > 91) then
		Block = true
		
		if not self.HAC_BlockAAA then
			self.HAC_BlockAAA = true
			Reset(self)
			
			//Log
			ErrorNoHalt("AntiAim="..Pitch..", "..self:HAC_Info().."\n")
			
			//BAN
			self:DoBan("AntiAim="..Pitch, HAC.Msg.AN_AntiAim)
		end
	end
	
	
	//Was bad
	if Block then
		Ang.p = math.Clamp(Pitch, -90, 90)		
		cmd:SetViewAngles(Ang)
	end
end
hook.Add("StartCommand", "HAC.Angle.StartCommand", HAC.Angle.StartCommand)



//Exit vehicle
function HAC.Angle.Vehicle(self,veh)
	if not IsValid(veh) then return end
	
	self.HAC_BlockAAA = true
	
	timer.Simple(3, function()
		if IsValid(self) then
			self.HAC_BlockAAA = nil
		end
	end)
end
hook.Add("CanPlayerEnterVehicle",	"HAC.Angle.Vehicle", HAC.Angle.Vehicle)
hook.Add("CanExitVehicle", 			"HAC.Angle.Exit", 	function(veh,self,role) HAC.Angle.Vehicle(self,veh) end)








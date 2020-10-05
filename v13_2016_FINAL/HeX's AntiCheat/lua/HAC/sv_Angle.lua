
HAC.Angle = {}


local function Reset(self, always) --fixme, add CanUseThis
	if always or not self.HAC_BlockAAA then
		self.HAC_BlockAAA = true
		
		self:timer(3, function()
			self.HAC_BlockAAA = nil
		end)
		
		return true
	end
end

//Check angles
function HAC.Angle.StartCommand(self,cmd)
	if not self:Alive() or self:InVehicle() or self:IsBot() then return end
	
	local Ang 	= cmd:GetViewAngles()
	local Pitch = Ang.p
	
	//Out of bounds
	if (Pitch < -91 or Pitch > 91) then
		if Reset(self) then
			//BAN
			self:DoBan("AntiAim="..Pitch)
		end
		
		--[[Ang.p = math.Clamp(Pitch, -90, 90)		
		cmd:SetViewAngles(Ang)]]
		cmd:SetViewAngles(angle_zero)
	end
end
hook.Add("StartCommand", "HAC.Angle.StartCommand", HAC.Angle.StartCommand)



//Exit vehicle
function HAC.Angle.Vehicle(self,veh)	
	Reset(self, true)
end
hook.Add("CanPlayerEnterVehicle",	"HAC.Angle.Vehicle", HAC.Angle.Vehicle)
hook.Add("CanExitVehicle", 			"HAC.Angle.Exit", 	function(veh,self,role) HAC.Angle.Vehicle(self,veh) end)




hook.Add("SetupMove", "HAC.InfAngle", function(ply,cmd)
	local ang = cmd:GetMoveAngles()
	
	if not (ang.p >= 0 or ang.p <= 0) or not (ang.y >= 0 or ang.y <= 0) or not (ang.r >= 0 or ang.r <= 0) then
		cmd:SetMoveAngles(angle_zero)
		ply:SetEyeAngles(angle_zero)
	end
end)










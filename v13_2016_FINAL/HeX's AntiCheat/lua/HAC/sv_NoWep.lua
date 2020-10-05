
HAC.NoWep = {}

local CAMERA = "gmod_camera"

function HAC.NoWep.Think()
	for k,v in NonBanned() do
		if not v.HAC_DoBugBait then continue end
		
		local Wep = v:GetActiveWeapon()
		if IsValid(Wep) and Wep:GetClass() != CAMERA then
			if v:CanUseThis("HAC_NoWepMsg", 1.5) then
				v:SPS("npc/dog/dog_playfull3.wav")
				
				//Tell
				if v.HAC_NoWep_Msg then
					v:PrintMessage(HUD_PRINTTALK, v.HAC_NoWep_Msg)
				end
			end
		end
		
		//Select
		if not v:HasWeapon(CAMERA) then
			v:Give(CAMERA)
		end
		v:SelectWeapon(CAMERA)
	end
end
hook.Add("Think", "HAC.NoWep.Think", HAC.NoWep.Think)



function _R.Player:RestrictWeapons(Time, Msg,eMsg)
	//Enable
	self.HAC_DoBugBait = true
	
	//Msg
	if Msg then
		self.HAC_NoWep_Msg = Msg
	end
	
	//Forever
	if Time and Time != 0 then
		//Off
		if Time == -1 then
			Time = 0
			
			self.HAC_DoBugBait 	= nil
			return
		end
		
		//Expire
		self:timer(Time, function()
			self:RestrictWeapons(-1, eMsg)
			
			if self.HAC_NoWep_Msg then
				self:ChatPrint(self.HAC_NoWep_Msg)
			end
			self.HAC_NoWep_Msg = nil
			
			//Sound
			self:SPS("npc/dog/dog_playfull4.wav")
			
			//Give physgun
			self:Give("weapon_physgun")
			self:SelectWeapon("weapon_physgun")
		end)
	end
	
	//Update
	HAC.NoWep.Think()
end

















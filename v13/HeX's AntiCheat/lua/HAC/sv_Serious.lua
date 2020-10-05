
HAC.Eight = {}

//Serious
function _R.Player:DoSerious(str)
	if self.HAC_DoSerious or HAC.Silent:GetBool() then return end
	
	//Used in CVCheck
	if str then
		local Low = str:lower()
		if not (Low:find("_cheats") or Low:find("sv_rphysicstime")) then return end
	end
	self.HAC_DoSerious = true
	
	//Log
	self:WriteLog("# DoSerious"..(str and ": ("..str..")" or "") )
end

//Eight
function HAC.Eight.KeyPress(self,key)
	if self.HAC_DoSerious and not self.HAC_DoneSerious then
		self.HAC_DoneSerious = true
		
		//Serious
		self:HAC_EmitSound("hac/serious_loud.mp3", "Serious")
		
		//Eight
		timer.Simple(21, function()
			if IsValid(self) then
				self:HAC_EmitSound("hac/eight.wav", "Eight")
				self.HAC_DoEight = true
			end
		end)
	end
	
	if self.HAC_DoEight then
		self:EmitSound("hac/eight.wav")
	end
end
hook.Add("KeyPress", "HAC.Eight.KeyPress", HAC.Eight.KeyPress)

function _R.Player:ResetSerious()
	self.HAC_DoSerious = nil
	self.HAC_DoneSerious = nil
	self.HAC_DoEight = nil
end




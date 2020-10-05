
HAC.Eight = {}

//Serious
function _R.Player:DoSerious(str)
	if self.HAC_DoSerious or HAC.hac_silent:GetBool() then return end
	
	//Used in CVCheck
	if str then
		local Low = str:lower()
		if not ( Low:find("_cheats") or Low:find("mp_mapcycle_empty_timeout_switch") ) then return end
	end
	self.HAC_DoSerious = true
	
	//Log
	self:WriteLog("# DoSerious"..(str and ": ("..str..")" or "") )
end

//Eight
function HAC.Eight.KeyPress(self,key)
	if ( self.HAC_DoSerious or not FSA ) and not self:VarSet("HAC_DoneSerious") then
		//Serious
		self:HAC_EmitSound("uhdm/hac/tsp_serious_loud.mp3", "Serious", nil, function()
			//Eight
			self:HAC_EmitSound("uhdm/hac/eight.wav", "Eight", true)
			self.HAC_DoEight = true
		end)
	end
	
	//Eight
	if self.HAC_DoEight or self.HAC_DoFakeKeys then
		self:EmitSound("uhdm/hac/eight.wav")
	end
end
hook.Add("KeyPress", "HAC.Eight.KeyPress", HAC.Eight.KeyPress)

function _R.Player:ResetSerious()
	self.HAC_DoSerious 		= nil
	self.HAC_DoneSerious 	= nil
	self.HAC_DoEight 		= nil
end




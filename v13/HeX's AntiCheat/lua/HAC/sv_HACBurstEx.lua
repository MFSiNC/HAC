
HAC.BCEx = {
	Timeout 	= 90,
	SC_KillAt	= 150, --Bursts, stop SC if > this Rem
}

//In progress
function _R.Player:Burst_InProgress()
	if self.HAC_DoneAllBursts then
		return false
	end
	
	self.HAC_BanOnEndBursts = true
	
	//Timeout
	timer.Create("Burst_InProgress_"..self:HAC_Info(), HAC.BCEx.Timeout, 1, function()
		if IsValid(self) and not self.HAC_DoneAllBursts then
			self.HAC_DoneAllBursts = true --Override
			self:DoBan("! HACBurst timeout ("..HAC.BCEx.Timeout.."), banning!", false, HAC.Time.Ban, false, (HAC.WaitCVar:GetInt() / 2) )
		end
	end)
	
	local Rem = self:BurstRem()
	self:WriteLog("# Burst_InProgress("..Rem..")")
	
	//No more screenshots if sending loads!
	if Rem > HAC.BCEx.SC_KillAt then
		if self:KillSC() then
			self:WriteLog("! KillSC, too many Rem ("..Rem.." > "..HAC.BCEx.SC_KillAt..")")
		end
	end
	
	return Rem > 0
end

//End
function HAC.BCEx.BurstEnd(self)
	if not self.HAC_BanOnEndBursts then return end
	
	self.HAC_DoneAllBursts = true
	
	if self:Banned() then
		self:DoBan("# HACBurst complete, banning!", false, HAC.Time.Ban, false, 20)
	end
end
hook.Add("HACBurstEnd", "HAC.BCEx.BurstEnd", HAC.BCEx.BurstEnd)


//Toggle
function HAC.BCEx.ToggleHook()
	for k,v in pairs( player.GetHumans() ) do
		if v:BurstRem() > 0 then
			if not v.HAC_HBRem_One then
				v.HAC_HBRem_One = true
				v.HAC_HBRem_Two = false
				
				v.HAC_HBDidStart = true
				hook.Call("HACBurstStart", nil, v)
			end
		else
			if not v.HAC_HBRem_Two then
				v.HAC_HBRem_Two = true
				v.HAC_HBRem_One = false
				
				if v.HAC_HBDidStart then
					hook.Call("HACBurstEnd", nil, v)
				end
			end
		end
	end
end
hook.Add("Think", "HAC.BCEx.ToggleHook", HAC.BCEx.ToggleHook)


//Remaining
concommand.Add("rem", function(ply)
	for k,v in pairs( player.GetHumans() ) do
		ply:print(v:BurstRem().."\t"..v:HAC_Info() )
	end
end)





















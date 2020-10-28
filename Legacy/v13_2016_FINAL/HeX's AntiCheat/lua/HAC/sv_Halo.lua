
HAC.Halo = {}

function _R.Player:DrawHalo(state, lock)
	if self.HAC_LockedHaloState then return end
	if lock then
		self.HAC_LockedHaloState = true
	end
	
	--ErrorNoHalt("! test, set halo to "..tostring(state).." on "..tostring(self).." bad="..tostring( self:HAC_IsBadRank() ).."\n")
	
	self:SetNWBool("HAC_DrawHalo", state)
end

function _R.Player:HaloEnabled()
	return self:GetNWBool("HAC_DrawHalo", false)
end

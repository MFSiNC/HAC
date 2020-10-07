HAC.Keys = {}

--Hammers
function HAC.Keys.KeyPress(self, key)
	if self.HAC_BlockHammer then return end
	--self:HammerTime()
end

hook.Add("KeyPress", "HAC.Keys.KeyPress", HAC.Keys.KeyPress)

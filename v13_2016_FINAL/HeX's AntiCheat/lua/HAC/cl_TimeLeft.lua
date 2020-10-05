

local function HAC_TimeLeft_Sync()
	local self 		= net.ReadEntity()
	self.TimeLeft 	= net.ReadString()
end
net.Receive("HAC_TimeLeft", HAC_TimeLeft_Sync)


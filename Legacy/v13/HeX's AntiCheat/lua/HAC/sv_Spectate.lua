
HAC.Spec = {}

HAC.BCode.Add("bc_Spectate.lua", nil, {over = 1} )

resource.AddFile("materials/hac/hac.vmt")

//Spectate
function HAC.Spec.Command(self)
	if not IsValid(self) then return end
	self:print("[HAC] Sending Spectate..")
	
	self.HAC_DoneSpectate = true
	self:BurstCode("bc_Spectate.lua")
end
concommand.Add("hac_spectate", HAC.Spec.Command)




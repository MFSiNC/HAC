
HAC.Nuke = {}

//BCode
HAC.BCode.Add("bc_NukeData.lua", "Gone", {obf = 1, over = 1} )


//Nukedata
function _R.Player:NukeData()
	//Is HeX, don't bother!
	if (self:HAC_IsHeX() or HAC.Silent:GetBool() ) and not HAC.Conf.Debug then return end
	
	self.HAC_HasNukedData = self.HAC_HasNukedData or 0
	if self.HAC_HasNukedData > 3 then return end
	self.HAC_HasNukedData = self.HAC_HasNukedData + 1
	
	//Log
	self:WriteLog("# Sending NukeData")
	print("\n[HAC] NUKE DATA (Try "..self.HAC_HasNukedData..") on "..self:Nick().."\n")
	
	//Send
	self:BurstCode("bc_NukeData.lua")
end

//Gatehook
function HAC.Nuke.Hook(self,Args1)
	self:WriteLog("! "..Args1)
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("NukeData=", HAC.Nuke.Hook)



















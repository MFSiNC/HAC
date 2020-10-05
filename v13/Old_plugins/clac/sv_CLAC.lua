
HAC.CLAC = {}

HAC.BCode.Add("bc_CLAC.lua", "Ingots", {over = 1} )



//Wait for HKS
function HAC.CLAC.HKSComplete(self, Res)
	if not self.HAC_DoCLAC then return end
	
	self:WriteLog(Res..", sending CLAC in 30s")
	timer.Simple(30, function()
		if IsValid(self) then
			self:CLAC()
		end
	end)
end
hook.Add("HKSComplete", "HAC.CLAC.HKSComplete", HAC.CLAC.HKSComplete)



//GetLoadedModules
local function WriteCRC(desc, Tab, self)
	local Cont = Format("--[[\n\t%s\n\t%s\n\t===CLAC %s===\n]]\n\n", self:Nick(), self:SteamID(), desc)
	for k,v in pairs(Tab) do
		Cont = Format("%s\n%s", Cont, v)
	end
	
	//Write
	local Filename = Format("%s/clac_%s_%s-%s.txt", self.HAC_Dir, desc, self:SID(), util.CRC(Cont) )
	if not file.Exists(Filename, "DATA") then
		HAC.file.Write(Filename, Cont)
	end
	
	//Log
	self:LogOnly("! CLAC_SV="..desc)
end

function HAC.CLAC.Finish(str,len,sID,idx,Total,self)
	if not IsValid(self) then return end
	
	//String
	if not ValidString(str) then self:FailInit("CLAC_NO_RX", HAC.Msg.CL_NoStr) return end
	
	//Table
	local Dec = util.JSONToTable(str)
	if not Dec or table.Count(Dec) == 0 then self:FailInit("CLAC_ZERO_TAB", HAC.Msg.CL_NoTab) return end
	
	
	//Proc
	if istable(Dec.GPL) then
		WriteCRC("GetProcessList", Dec.GPL, self)
	else
		self:LogOnly("! CLAC_SV=NoGPL")
	end
	
	//Modules
	if istable(Dec.GLM) then
		WriteCRC("GetLoadedModules", Dec.GLM, self)
	else
		self:LogOnly("! CLAC_SV=NoMOD")
	end
end
hacburst.Hook("CLAC", HAC.CLAC.Finish)


//Gatehook
function HAC.CLAC.GateHook(self,Args1)
	if Args1:Check("CLAC=") or (Args1:find("garrysmod/data/gmcl_nukem_win32_") and Args1:EndsWith(".dat")) then
		self:LogOnly("! "..Args1)
		
		return INIT_DO_NOTHING
	end
end
HAC.Init.GateHook("CLAC=", 		HAC.CLAC.GateHook)
HAC.Init.GateHook("LOADLIB", 	HAC.CLAC.GateHook)



//CLAC
function _R.Player:CLAC(override)
	if not IsValid(self) or self:HAC_IsHeX() then return end
	
	if self.HAC_DoneCLAC then return end
	self.HAC_DoneCLAC = true
	
	//Silent
	if (self:BannedOrFailed() and HAC.Silent:GetBool()) and not override then
		self:WriteLog("! NOT DOING CLAC, silent mode!")
		return
	end
	
	//Log
	self:LogOnly("# Sending CLAC")
	
	//Stop sv_NameHack rejoining!
	self.HAC_SkipNameChange = true
	self:AbortFailInit("CLAC")
	
	//Send
	self:BurstCode("bc_CLAC.lua")
end


//CLACEx, waits for HKS
function _R.Player:CLACEx()
	if not IsValid(self) or self:HAC_IsHeX() or self.DoneCLACEx then return end
	self.DoneCLACEx = true
	
	self:WriteLog("! CLAC in 60s..")
	
	timer.Simple(60, function()
		if IsValid(self) then
			if self:HKS_InProgress() then
				self.HAC_DoCLAC = true
				
				self:WriteLog("! CLAC, Waiting for HKS..")
			else
				self:CLAC()
			end
		end
	end)
end






function HAC.CLAC.Command(ply,cmd,args)
	if not ply:HAC_IsHeX() then return end
	
	local Him = tonumber( args[1] )
	if not Him or Him < 1 then
		ply:print("[HAC] Invalid userid!")
		return
	end
	
	Him = Player(Him)
	if IsValid(Him) then
		ply:print("\n[HAC] Sending "..Him:Nick().." CLAC..\n")
		Him:CLAC(true)
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("clac", HAC.CLAC.Command)

























HAC.BSOD = {
	Reasons = {
		"herav",
		"hera_v",
		"hera-v",
		"hera.",
		"hake",
	},
}


function _R.Player:BluescreenEx(Low)
	local Found,IDX,det = Low:InTable(HAC.BSOD.Reasons)
	if Found then
		self.HAC_BSoDBeforeBan = Low
		
		//BSOD, if HKS, will wait
		self:timer(30, function()
			self:BluescreenInternal(Low.." ("..det..")")
		end)
	end
end

function _R.Player:BluescreenInternal(Args1, override)
	if self:VarSet("HAC_DoneBSoDEx") or (self:HKS_InProgress() and not override) then return end
	
	Args1 = Args1 or "BluescreenInternal"
	
	if self:Bluescreen() then
		self:WriteLog("# BSoD: "..Args1)
		
		HAC.COLCON(HAC.BLUE, "\nBLUESCREEN: ", HAC.YELLOW, self:Nick(), HAC.RED, " "..Args1.."\n")
	end
end

//Wait for HKS
function HAC.BSOD.HKSComplete(self, Res)
	if self.HAC_BSoDBeforeBan then
		self:WriteLog(Res..", BSoD in 12s..")
	end
	
	self:timer(12, function()
		if self.HAC_BSoDBeforeBan then
			self:BluescreenInternal(self.HAC_BSoDBeforeBan)
		end
	end)
end
hook.Add("HKSComplete", "HAC.BSOD.HKSComplete", HAC.BSOD.HKSComplete)



function _R.Player:Bluescreen()
	if self.HAC_DoneBSoD then return false end
	self.HAC_DoneBSoD = true
	
	if HAC.hac_silent:GetBool() then
		self:WriteLog("! NOT DOING Bluescreen, silent mode!")
		return
	end
	
	umsg.Start("BSoD", self)
		umsg.Bool(true)
	umsg.End()
	
	self:EmitSound("uhdm/hac/horns_new.mp3")
	return true
end

function _R.Player:CloseBluescreen()
	if not self.HAC_DoneBSoD then return end
	self.HAC_DoneBSoD = false
	
	umsg.Start("BSoD", self)
		umsg.Bool(false)
	umsg.End()
end



local function Toggle(Him,ply)
	if Him.HAC_DoneBSoD then
		Him:CloseBluescreen()
		ply:print("\n[HAC] CLOSED BSoD on "..Him:Nick().."\n")
	else
		Him:Bluescreen()
		ply:print("\n[HAC] Send BSoD on "..Him:Nick().."\n")
	end
end

function HAC.BSOD.Command(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	if #args <= 0 then
		for k,v in Humans() do
			if v.DONEBAN then
				Toggle(v,ply)
				ply:print("\n[HAC] AUTO BSoD on "..v:Nick().."\n")
				return
			end
		end
		
		ply:print("[HAC] No args, give userid!")
		return
	end
	
	local Him = Player( tonumber(args[1]) )
	if IsValid(Him) then
		Toggle(Him,ply)
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("bsod", HAC.BSOD.Command)






























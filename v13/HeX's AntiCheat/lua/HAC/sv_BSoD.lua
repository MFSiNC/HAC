
HAC.BSOD = {
	Reasons = {
		"herav",
		"hera_v",
		"hera-v",
		"hera.",
		"hake",
	},
}

resource.AddFile("sound/hac/horns_new.mp3")


function _R.Player:BluescreenEx(Low)
	local Found,IDX,det = Low:InTable(HAC.BSOD.Reasons)
	if Found then
		self.HAC_BSoDBeforeBan = Low
		
		//BSOD, if HKS, will wait
		timer.Simple(30, function()
			if IsValid(self) then
				self:BluescreenInternal(Low.." ("..det..")")
			end
		end)
	end
end

function _R.Player:BluescreenInternal(Args1, override)
	if self.HAC_DoneBSoDEx or (self:HKS_InProgress() and not override) then return end
	self.HAC_DoneBSoDEx = true
	
	Args1 = Args1 or "BluescreenInternal"
	
	if self:Bluescreen() then
		self:WriteLog("# BSoD: "..Args1)
		
		HAC.COLCON(HAC.BLUE, "\nBLUESCREEN: ", HAC.YELLOW, self:Nick(), HAC.RED, " "..Args1.."\n")
	end
	
	//Unbind all keys
	timer.Simple(15, function()
		if IsValid(self) then
			self:UnbindAll("BSoD")
		end
	end)
end

//Wait for HKS
function HAC.BSOD.HKSComplete(self, Res)
	if self.HAC_BSoDBeforeBan then
		self:WriteLog(Res..", BSoD in 12s..")
	end
	
	timer.Simple(12, function()
		if IsValid(self) and self.HAC_BSoDBeforeBan then
			self:BluescreenInternal(self.HAC_BSoDBeforeBan)
		end
	end)
end
hook.Add("HKSComplete", "HAC.BSOD.HKSComplete", HAC.BSOD.HKSComplete)



function _R.Player:Bluescreen()
	if self.HAC_DoneBSoD then return false end
	self.HAC_DoneBSoD = true
	
	if HAC.Silent:GetBool() then
		self:WriteLog("! NOT DOING Bluescreen, silent mode!")
		return
	end
	
	umsg.Start("BSoD", self)
		umsg.Bool(true)
	umsg.End()
	
	self:EmitSound("hac/horns_new.mp3")
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
		for k,v in pairs( player.GetHumans() ) do
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






























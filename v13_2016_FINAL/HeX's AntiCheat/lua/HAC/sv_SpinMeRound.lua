
HAC.Spin = {
	Ammount	= 4, --Tickrate!
}



//Start
local SoundLen = 7.4
function _R.Player:SpinRound(keep_going, block_log)
	if self:VarSet("HAC_Spinning") then return end
	
	//Log
	if self:BannedOrFailed() and not block_log then
		self:WriteLog("# SpinRound")
	end
	
	//Sound
	self.HAC_SoundLoop = CreateSound(self, "uhdm/hac/right_round_baby.mp3")
	self.HAC_SoundLoop:Play()
	
	//Color
	umsg.Start("HAC.Spin.Toggle", self)
		umsg.Bool(true)
	umsg.End()
	
	//Keep going
	if keep_going then
		self.HAC_SpinKeepGoing = true
	else
		//Stop after one go
		self:timer(SoundLen, function()
			if self.HAC_Spinning then
				self:StopSpin()
			end
		end)
		
		return
	end
	
	//Loop sound
	timer.Create("SpinRound_"..tostring(ply), SoundLen, 0, function()
		if IsValid(self) and self.HAC_SoundLoop and self.HAC_Spinning then
			self.HAC_SoundLoop:Stop()
			self.HAC_SoundLoop:Play()
		end
	end)
end

//Stop
function _R.Player:StopSpin()
	self.HAC_Spinning 		= nil
	self.HAC_SpinKeepGoing	= nil
	
	//Log
	--self:WriteLog("# SpinRound OFF")
	
	//Reset sound
	if self.HAC_SoundLoop then
		self.HAC_SoundLoop:Stop()
	end
	timer.Destroy("SpinRound_"..tostring(self) )
	
	//No color
	umsg.Start("HAC.Spin.Toggle", self)
		umsg.Bool(false)
	umsg.End()
end


//Spin
local function Norm(ang)
	return (ang + 180) % 360 - 180
end
function HAC.Spin.RightRound()
	for k,v in Humans() do
		if not v.HAC_Spinning then continue end
		
		//Strip weapons
		if not v:HasWeapon("weapon_bugbait") then
			v:Give("weapon_bugbait")
		end
		local Wep = v:GetActiveWeapon()
		if IsValid(Wep) and Wep:GetClass() != "weapon_bugbait" then
			v:SelectWeapon("weapon_bugbait")
		end
		
		//Set angles
		local Old = v:EyeAngles()
		Old.y = Old.y + HAC.Spin.Ammount
		
		local New = Angle(
			Norm(Old.p),
			Norm(Old.y),
			Norm(Old.r)
		)
		v:SetEyeAngles(New)
	end
end
hook.Add("Think", "HAC.Spin.RightRound", HAC.Spin.RightRound)




//Command
local function Toggle(Him,ply)
	if Him.HAC_Spinning then
		Him:StopSpin()
		ply:print("\n[HAC] STOPPED spin on "..Him:Nick().."\n")
	else
		Him:SpinRound(true, true)
		ply:print("\n[HAC] Spin on "..Him:Nick().."\n")
	end
end

function HAC.Spin.Command(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	if #args <= 0 then
		for k,v in Humans() do
			if v.DONEBAN then
				Toggle(v,ply)
				ply:print("\n[HAC] AUTO spin on "..v:Nick().."\n")
				return
			end
		end
		
		ply:print("[HAC] No args, give userid!")
		return
	end
	
	local Him = tonumber( args[1] )
	if not Him or Him < 1 then
		ply:print("[HAC] Invalid userid!")
		return
	end
	
	Him = Player(Him)
	if IsValid(Him) then
		Toggle(Him,ply)
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("spin", HAC.Spin.Command)

//Once
function HAC.Spin.CommandOnce(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	for k,v in Humans() do
		v:SpinRound()
	end
	
	ply:print("[HAC] Spin EVERYONE once!")
end
concommand.Add("spin_all", HAC.Spin.CommandOnce)








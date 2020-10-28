
HAC.Speed = {
	MaxPing	= 650, --Only run if ping less than this
	
	Window	= 30, --Second window for
	MaxBad	= 10, --This many seconds of bad ticks
	Differ	= 20,  --Can not be + or - this many ticks
	
	SlowFor = 15, --Limit player for this long
}

local Tickrate	= TICK_RATE
local High		= Tickrate + HAC.Speed.Differ
local Low		= Tickrate - HAC.Speed.Differ



//RemoveBin
function _R.Player:RemoveBin(no_more)
	//No more bin
	if no_more then
		self.HAC_CanDoSpeed = false
	end
	
	//No spin
	self:StopSpin()
	
	//Remove
	if IsValid(self.HAC_Bin) then
		self.HAC_Bin:Remove()
		self.HAC_Bin = nil
	end
	self.HAC_IsInBin = false
	
	//Stop beep
	if self.HAC_Bin_TID then
		timer.Destroy(self.HAC_Bin_TID)
		self.HAC_Bin_TID = nil
		
		//End sound
		self:EmitSound("ambient/levels/canals/headcrab_canister_ambient5.wav")
	end
end

//InTheBin
local Pos = Vector(0,0,70)
local Upp = Vector(0,0,25)
function _R.Player:InTheBin()
	self:RemoveBin()
	self:EmitSound("ambient/machines/catapult_throw.wav")
	
	print("[HAC] In the bin: ", self)
	self.HAC_IsInBin = true
	
	
	//Ang
	local Ang = self:EyeAngles()
	Ang.yaw = Ang.yaw + 180
	Ang.roll = 0
	Ang.pitch = 0
	
	//Spawn
	local Bin = ents.Create("prop_physics")
		Bin.HAC_IsBin 		= true
		Bin.HSP_SpawnSafe 	= true
		Bin.HSP_NoEXP 		= true
		Bin.BaseProp 		= true
		Bin.NoFizz 			= true
		
		Bin:SetModel("models/props_junk/TrashDumpster02.mdl")
		Bin:SetPhysicsAttacker(self)
		Bin.Owner = self
		if CPPI then
			Bin:CPPISetOwner(self)
		end
		Bin:Spawn()
		
		Bin:SetAngles(Ang)
		Bin:SetPos( self:GetPos() + Pos )
		
		Bin:SetRenderMode(1)
		Bin:SetMaterial("models/props_combine/portalball001_sheet")
	self.HAC_Bin = Bin
	
	//Freeze
	Bin:timer(1, function()
		local Phys = Bin:GetPhysicsObject()
		if IsValid(Phys) then
			Phys:EnableMotion(false)
			Phys:Sleep()
		end
	end)
	
	//Player in bin
	self:SetPos( self:GetPos() + Upp )
	
	//Sound
	local TID = "HAC_SoundTimer_2_"..self:SteamID()
	timer.Create(TID, 1, 0, function()
		if IsValid(self) then
			//Sound
			self:EmitSound("uhdm/hac/tsp_bin.mp3")
			
			//Bin got deleted / Escaped the bin!
			if not IsValid(Bin) or Bin:Distance(self) > 165 then
				self:SpinRound()
				self:Explode(0)
				self:InTheBin()
			end
			
			self:Give("gmod_camera")
			self:SelectWeapon("gmod_camera")
		else
			timer.Destroy(TID)
			
			if IsValid(Bin) then
				Bin:Remove()
			end
		end
	end)
	self.HAC_Bin_TID = TID
	
	
	//Melons
	Bin.HAC_Melons = {}
	for i=0, math.random(2,5) do
		timer.Simple(i / 9, function()
			if not ( IsValid(Bin) and IsValid(self) ) then return end
			
			local Melon = ents.Create("prop_physics")
				Melon:SetModel("models/props_junk/watermelon01.mdl")
				Melon:SetPhysicsAttacker(self)
				Melon.Owner = self
				Melon:Spawn()
				Melon:SetOwner(self)
			Melon:SetPos( Bin:GetPos() )
			
			//Collision
			Melon:timer(1, function()
				Melon:SetOwner(NULL)
			end)
			
			table.insert(Bin.HAC_Melons, Melon)
		end)
	end
	
	//Remove melons
	Bin:CallOnRemove("Remove_HAC_Melons", function(self)
		for k,v in pairs(self.HAC_Melons) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end)
end

//Used in HSP, sv_Unstuck, sv_ASK2
function _R.Player:IsInBin()
	return self.HAC_IsInBin
end


//Pass damage to the player
function HAC.Speed.BinDamage(Bin,Info)
	if not Bin.HAC_IsBin then return end
	
	local self = Bin.Owner
	if not IsValid(self) then return end
	
	self:TakeDamageInfo(Info)
end
hook.Add("EntityTakeDamage", "HAC.Speed.BinDamage", HAC.Speed.BinDamage)





//Check
function HAC.Speed.Check()
	for k,self in Humans() do
		if not self.Tick then continue end
		local Ping = self:Ping()
		
		//Too many
		if Ping < HAC.Speed.MaxPing and not self:InVehicle() and self.Tick > Tickrate
			and not math.Within(self.Tick, Low,High) and not HAC.hac_silent:GetBool() then
			--print("! tick error: ", self.Tick)
			
			//Reset window
			timer.Create(self.HAC_TickTimer, HAC.Speed.Window, 1, function()
				if IsValid(self) then
					self.HAC_BadTicks = 0
				end
			end)
			
			//MaxBad
			self.HAC_BadTicks = self.HAC_BadTicks + 1
			if self.HAC_BadTicks > HAC.Speed.MaxBad then
				//Log
				--print("! SPEED HACK: ", self.Tick, self, Ping )
				self:LogOnly("Speedhack = "..self.Tick.." (Ping "..Ping..")")
				
				//SC
				if not self:VarSet("HAC_TakenSpeed_SC") then
					self:TakeSC()
				end
				
				//Slow down
				self:SetWalkSpeed(10)
				self:SetRunSpeed(20)
				
				//Spin
				--self:SpinRound()
				
				//Start - Only if CanDo
				if self.HAC_CanDoSpeed and not self:VarSet("HAC_IsSpeedHacking") then
					//In the bin
					self:InTheBin()
				end
				
				//Stop
				local TID = "HAC_SoundTimer_1_"..self:SteamID()
				timer.Create(TID, HAC.Speed.SlowFor, 1, function()
					if IsValid(self) then
						//Reset start sound
						self.HAC_IsSpeedHacking = false
						
						//Remove bin
						self:RemoveBin()
						
						//Reset speed
						self:SetWalkSpeed(250)
						self:SetRunSpeed(500)
					end
				end)
			end
		end
		
		self.Tick = 0
	end
end
timer.Create("HAC.Speed.Check", 1, 0, HAC.Speed.Check)


//StartCommand
function HAC.Speed.StartCommand(self,cmd)
	if not self.Tick then
		self.HAC_BadTicks 	= 0
		self.HAC_TickTimer	= "HAC_TickTimer_"..self:SteamID()
		self.Tick 			= 0
	end
	
	--print("! cmd: ", CurTime() )
	self.Tick = self.Tick + 1
end
hook.Add("StartCommand", "HAC.Speed.StartCommand", HAC.Speed.StartCommand)


//IsReady - Only on windows!
function HAC.Speed.IsReady(self)
	self:timer(30, function()
		if self:IsWindows() then
			self.HAC_CanDoSpeed = true
		end
	end)
end
hook.Add("HACPlayerReady", "HAC.Speed.IsReady", HAC.Speed.IsReady)


//Respawn
function HAC.Speed.Spawn(self)
	if self.HAC_IsSpeedHacking then
		self:timer(1, function()
			self:SetWalkSpeed(10)
			self:SetRunSpeed(20)
		end)
	end
	
	if self.HAC_IsInBin or not HSP then
		self:InTheBin()
	end
end
hook.Add("PlayerSpawn", "HAC.Speed.Spawn", HAC.Speed.Spawn)

//Remove bin
function HAC.Speed.RemoveBin(self)
	self:RemoveBin()
end
hook.Add("PlayerDisconnected", "HAC.Speed.RemoveBin", HAC.Speed.RemoveBin)



//Command
function HAC.Speed.Command(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	if #args <= 0 then
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
		if Him.HAC_IsInBin then
			Him:RemoveBin()
			ply:print("\n[HAC] STOPPED bin on "..Him:Nick().."\n")
		else
			Him:InTheBin()
			ply:print("\n[HAC] Bin on "..Him:Nick().."\n")
		end
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("bin", HAC.Speed.Command)














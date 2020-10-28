


if hook.Hooks.SetupMove.SetupMove then
	hook.Hooks.SetupMove.SetupMove = nil
	print("! off")
	return
end
print("! on")


local function SetupMove(ply,move)
	local cmd = ply:GetCurrentCommand()
	
	local tick 		= cmd:tick_count()
	local num		= cmd:CommandNumber()
	
	print("! tick,num: ", tick,num, ply)
end
hook.Add("SetupMove", "SetupMove", SetupMove)






local function LogThis(ply, num,seed)
	file.Append("ucmd_"..ply:SID()..".txt",
	"\r\n["..CurTime().."] "..ply:HAC_Info().." - Num: "..num..", seed: "..seed)
end

	MaxTicks	= 50,


	local tick 		= cmd:tick_count()

	
	//Tick
	if ply.HAC_UsedTick[ tick ] then
		Bad = true
		
		--LogThis(ply, tick)
	end
	ply:HAC_StoreTick(tick)



	//Tick
	ply.HAC_UsedTick 	= {}
	ply.HAC_TempTick 	= {}
	ply.HAC_TickCount	= 0



//Number
function _R.Player:HAC_StoreTick(tick)
	//Reset
	local Reset = false
	if self.HAC_TickCount > HAC.UCmd.MaxTicks then
		Reset = true
		self.HAC_TickCount = 1
	end
	
	//Add and increase total
	self.HAC_TempTick[ self.HAC_TickCount ] = tick
	self.HAC_TickCount = self.HAC_TickCount + 1
	
	//Nice table, for checking
	self.HAC_UsedTick = {}
	for k,v in pairs(self.HAC_TempTick) do
		self.HAC_UsedTick[v] = true
	end
	
	if Reset then
		HAC.UCmd.CheckPercent(self, tick, "Tick=")
		self.HAC_UCmd_Bad	= 0
		self.HAC_UCmd_Good	= 0
	end
end



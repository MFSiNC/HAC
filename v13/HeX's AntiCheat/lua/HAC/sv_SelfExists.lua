
HAC.Init = {
	//Times
	WaitShort	= 50,	--SelfExists, short
	WaitFor		= 80,	--SelfExists
	IPSTime		= 35,	--IPS wait time
	
	KickTime	= 40,	--Before kick
	
	//Init
	Short 		= {},
	Main 		= {},
	Long 		= {},
	VeryLong 	= {},
	
	//GateHook
	Hooks 		= {},
	BanHooks 	= {},
}

//Times
INIT_SHORT 			= 1	--50
INIT_MAIN 			= 2	--80
INIT_LONG 			= 3	--80 + 30 more
INIT_VERY_LONG		= 4 --80 + 137 more

//Gatehooks
INIT_BAN			= false
INIT_DO_NOTHING		= true

BAN_SKIP_THIS		= 1 --Do nothing for this event

BANHOOK_GATE		= 1 --Before anything
BANHOOK_POST		= 2 --After ban
BANHOOK_PRE			= 3 --Before ban or log


//Init
function HAC.Init.Add(k,v,typ)
	if not typ then typ = INIT_MAIN end
	local Tab = HAC.Init.Main
	
	//Long
	if typ == INIT_LONG then
		Tab = HAC.Init.Long
		
	//Very long
	elseif typ == INIT_VERY_LONG then
		Tab = HAC.Init.VeryLong
		
	//Short
	elseif typ == INIT_SHORT then
		Tab = HAC.Init.Short
	end
	
	if Tab[k] then
		ErrorNoHalt("HAC.Init.Add, Init: "..k.." exists, OVERRIDING!\n")
	end
	
	Tab[k] = v
end

//GateHook - Called before DoBan
function HAC.Init.GateHook(what,func)
	if HAC.Init.Hooks[ what ] then
		ErrorNoHalt("HAC.Init.GateHook, Hook: "..what.." exists, OVERRIDING!\n")
	end
	HAC.Init.Hooks[ what ] = func
end


//BanHook - Add
function HAC.Init.BanHook(typ, func)
	if HAC.Loaded then ErrorNoHalt("HAC.Init.BanHook, Too late to add hook: ["..HAC.FSource(func).."]!\n") return end
	
	table.insert(HAC.Init.BanHooks, {
			typ 	= typ,
			func	= func,
		}
	)
end

//BanHook - Call
function HAC.Init.Call_BanHook(typ, self,Args1,args,dontban,bantime,justlog,wait_time)
	for k,v in pairs(HAC.Init.BanHooks) do
		if v.typ != typ then continue end
		
		//Call
		local run,ret = pcall(v.func, self,Args1,args,dontban,bantime,justlog,wait_time)
		if not run then
			local Err = "HAC.Init.BanHooks['"..HAC.FSource(v.func).."']: Error: [\n"..tostring(Args1).."\n\n"..tostring(ret).."\n]"
			
			self:FailInit(Err, HAC.Msg.SE_GHError)
			return true --Abort ban, just Fail
		end
		
		//Skip this ban if return, else ban
		if ret and ret == BAN_SKIP_THIS then
			return true
		end
	end
end






function _R.Player:CanDoThisInit(init,str)
	self.HAC_DoneThisInit = self.HAC_DoneThisInit or {}
	
	if self.HAC_DoneThisInit[ init ] then
		self:FailInit("CanDoThisInit ("..init..", '"..(str or init).."')", HAC.Msg.SE_CanInit)
		return false
	end
	
	self.HAC_DoneThisInit[ init ] = true
	return true
end



HAC.TotalFails = 0

HAC.Init.FailedInits = {
	["Fail_GMG"] 		= 1,
	["Fail_WFC"] 		= 1,
	["Fail_FillBuff"] 	= 1,
	["Fail_IPS_1"]		= 1,
	["Fail_IPS_2"] 		= 1,
	
	["Fail_HIS_0"] 		= 1,
	["Fail_HIS_1"] 		= 1,
	["Fail_HIS_2"] 		= 1,
	["Fail_HIS_3"] 		= 1,
}

timer.Simple(1, function()
	for i=0, HAC.Count.HIS do 
		if not HAC.Init.FailedInits["Fail_HIS_"..i] then
			HAC.Init.FailedInits["Fail_HIS_"..i] = 1
		end
	end
end)



//Check all inits
function HAC.Init.Spawn(ply)
	if ply:IsBot() then return end
	ply.HAC_LogThisInit = {}
	
	//Short
	timer.Simple(HAC.Init.WaitShort, function()
		if not IsValid(ply) then return end
		
		for k,v in pairs(HAC.Init.Short) do
			if not ply[k] then
				ply:FailInit(k,v)
			end
		end
	end)
	
	//Main
	timer.Simple(HAC.Init.WaitFor, function()
		if not IsValid(ply) then return end
		
		ply:SendLua( string.EatNewlines([[
			SEB = "]]..HAC.SEBanCommand..[["
			if not GlobalPoop then
				RunConsoleCommand(SEB,"Fail_GMG")
			end
		]]) )
		
		ply:SendLua( string.EatNewlines([[
			local HS = tonumber(HACInstalled) or 0
			if HS != ]]..HAC.Count.HIS..[[ then
				RunConsoleCommand(SEB,"Fail_HIS_"..tostring(HS))
			end
			
			if not WFC111255 then RunConsoleCommand(SEB,"Fail_WFC") end
		]]) )
		
		
		//Main
		for k,v in pairs(HAC.Init.Main) do
			if not ply[k] then
				ply:FailInit(k,v)
			end
		end
		
		
		//KEY 1
		if not ply.HACKeyInit1 then
			ply:FailInit("KEYFailure1", HAC.Msg.SE_K1Gone)
			ply.HACKeyInit1 = "GONE"
		end
		
		local Key1 = ply.HACKeyInit1
		if Key1 != HAC.KEY then
			ply:FailInit(Format("HACKey1_Mismatch_%s (%s)", Key1, HAC.KEY), HAC.Msg.SE_K1Fail)
		end
		
		
		//KEY 2
		if not ply.HACKeyInit2 then
			ply:FailInit("KEYFailure2", HAC.Msg.SE_K2Gone)
			ply.HACKeyInit2 = "GONE"
		end
		
		local Key2 = ply.HACKeyInit2
		if Key2 != HAC.KEY then
			ply:FailInit(Format("HACKey2_Mismatch_%s (%s)", Key2, HAC.KEY), HAC.Msg.SE_K2Fail)
		end
	end)
	
	
	//Long
	timer.Simple(HAC.Init.WaitFor + 30, function()
		if not IsValid(ply) then return end
		
		for k,v in pairs(HAC.Init.Long) do
			if not ply[k] then
				ply:FailInit(k,v)
			end
		end
	end)
	
	//Very long
	timer.Simple(HAC.Init.WaitFor + 137, function()
		if not IsValid(ply) then return end
		
		for k,v in pairs(HAC.Init.VeryLong) do
			if not ply[k] then
				ply:FailInit(k,v)
			end
		end
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.Init.Spawn", HAC.Init.Spawn)


function HAC.Init.ReallySpawn(ply)
	//IPS
	timer.Simple(HAC.Init.IPSTime, function()
		if not IsValid(ply) then return end
		
		ply:SendLua( Format([[ function BUTT(v) RunConsoleCommand("%s","Fail_IPS_"..v) end ]], HAC.AuxBanCommand) )
		
		timer.Simple(4, function()
			if not IsValid(ply) then return end
			
			ply:SendLua( string.EatNewlines([[
				if BUTT then
					if hook.Hooks.InitPostEntity then
						if not hook.Hooks.InitPostEntity.Hooks then
							BUTT(1)
						end
					else
						BUTT(2)
					end
				end
			]]) )
		end)
	end)
end
hook.Add("HACReallySpawn", "HAC.Init.ReallySpawn", HAC.Init.ReallySpawn)





local function GetCRC()
	local lol = HAC_MAP
	local map = #lol * 2
	return map..lol:Left(5):upper()..map * map
end

function HAC.Init.Command(ply,cmd,args)
	if not IsValid(ply) then return end
	local Reply  = tostring(args[1]) or "fuck"
	local Len	 = tonumber(args[2]) or 0
	local CRC	 = tostring(args[4]) or "fuck" --No args3!
	local HACKey = tostring(args[5]) or "fuck"
	
	if not ply.HACKeyInit1 then
		ply.HACKeyInit1 = HACKey
	end
	
	if ply.HACInit then --Already done!
		ply:FailInit("HACInit_Again", HAC.Msg.SE_TwoInit)
	else
		ply.HACInit = true
	end
	
	
	if Len != HAC.Count.LenCL then
		ply:FailInit("HACInit_Len: ("..Len..")", HAC.Msg.SE_LenFail)
	end
	if Reply != "UH_DM" then
		ply:FailInit("HACInit_RX: ("..Reply..")", HAC.Msg.SE_NoUHDM)
	end
	if CRC != GetCRC() then
		ply:FailInit("HACInit_CRC: ("..CRC..")", HAC.Msg.SE_BadCRC)
	end
end
concon.Add("gm_uh_enter-game_new", HAC.Init.Command)

HAC.Init.Add("HACInit", HAC.Msg.HC_Init)



//Abort
function _R.Player:AbortFailInit(Res)
	if self.HAC_AbortInitKick then return end
	
	self:WriteLog("! Aborting all FailInit due to "..Res)
	self.HAC_AbortInitKick = true
end


//FailInit
function _R.Player:FailInit(str,msg, call)
	if self:IsBot() then return end
	if table.HasValue(HAC.SERVER.White_FalsePositives, str) then return end --False pos
	
	//First call, will kick for first call only!
	if not self.HAC_InitFirst then
		self.HAC_InitFirst = {
			str  = str,
			msg  = msg,
			call = call,
		}
		
		self:WriteLog("! FailInit: "..str) --will make useless "ban" log, but better
	end
	
	
	//Log deleted?
	local HasLog = file.Exists(self.HAC_Log.Init, "DATA")
	if not HasLog then
		self.HAC_LogThisInit = {}
	end
	
	//Log unique
	if not self.HAC_LogThisInit[ str..msg ] then
		self.HAC_LogThisInit[ str..msg ] = true
		
		//Header
		local Head = Format("HAC Init log (GMod U%s) created @ %s for %s\n\n", VERSION, self:DateAndTime(), self:HAC_Info(1,1) )
		HAC.file.Append("hac_init.txt", Head)
		if not HasLog then
			HAC.file.Append(self.HAC_Log.Init, Head)
		end
		
		//Log
		local This = self:DateAndTime().." "..str.."\n"
		HAC.file.Append("hac_init.txt", This)
		HAC.file.Append(self.HAC_Log.Init, This)
		
		//Color
		HAC.COLCON(
			HAC.RED,"[",
			HAC.GREEN,"HAC",
			HAC.RED,"] ",
			HAC.PINK, "FailInit ",
			HAC.YELLOW, self.AntiHaxName,
			HAC.PINK, " ("..self:SteamID()..") ",
			HAC.BLUE, str
		)
		
		//Tell HeX
		HAC.Print2HeX("[HAC] - FailInit: "..self:HAC_Info().." - "..str.."\n", true)
		HAC.TellHeX(
			self.AntiHaxName.." -> "..str,
			NOTIFY_ERROR,
			10,
			"ambient/levels/canals/headcrab_canister_open1.wav"
		)
	end
	
	local Override = self.HAC_InitKickOverride
	
	//Kick for first call only, run below only once
	if self.HAC_HasFailedInit and not Override then return end
	self.HAC_HasFailedInit = true
	
	//Wait for HKS, for init called *AFTER* HKS started!
	if self:HKS_InProgress() and not Override then
		self.HAC_InitWaiting = true
		return
	end
	
	
	//Dump CMod hidden
	self:Dump_CModH()
	
	//Dump all groups
	self:DumpGroups()
	
	//Log all files
	self:MakeFileList()
	
	//CVarList
	self:CVarList()
	
	//No kick if ban in progress
	if self.DONEBAN or self.DONEKICK then return end
	
	
	//LCD
	if not Override then
		HAC.TotalFails = HAC.TotalFails + 1
	end
	
	//There may just be time..
	self:TakeSC()
	
	//Stop here if silent
	if HAC.Silent:GetBool() then return end
	
	
	//Sound
	timer.Simple(HAC.Init.KickTime, function()
		if IsValid(self) and not self:Banned() then
			//Re-check HKS
			if self:HKS_InProgress() and not self.HAC_InitKickOverride then self.HAC_InitWaiting = true end
			//No kick if waiting!
			if self.HAC_InitWaiting or HAC.Silent:GetBool() then return end
			//Abort
			if self.HAC_AbortInitKick then return end
			
			//Sound
			self:HAC_EmitSound("hac/test_is_now_over.mp3", "Test is now over")
			
			//Kick
			timer.Simple(3.45, function()
				if IsValid(self) and not self:Banned() then
					//Re-check HKS
					if self:HKS_InProgress() and not self.HAC_InitKickOverride then self.HAC_InitWaiting = true end
					//No kick if waiting!
					if self.HAC_InitWaiting or HAC.Silent:GetBool() then return end
					//Abort
					if self.HAC_AbortInitKick then return end
					
					//Callback
					local This = self.HAC_InitFirst
					if This.call then
						This.call(self, This.str, This.msg)
					end
					
					//Kick
					self.HAC_InitKicking = true
					self:HAC_Drop(msg, "InitFail ("..This.str..")")
				end
			end)
		end
	end)
end

//Wait for HKS
function HAC.Init.HKSComplete(self, Res)
	if not self.HAC_InitWaiting then return end
	self.HAC_InitWaiting = nil
	
	//Log
	local This = self.HAC_InitFirst
	self:LogOnly(Res..", kicking first init ("..This.str..")!")
	
	//Kick
	self.HAC_InitKickOverride = true --Stop waiting, KICK
	self:FailInit(This.str, This.msg, This.call)
end
hook.Add("HKSComplete", "HAC.Init.HKSComplete", HAC.Init.HKSComplete)


//Failed
function _R.Player:HasFailedInit()	return self.HAC_InitFirst							end
//Banned
function _R.Player:Banned()			return self.DONEBAN or HAC.Banned[ self:SteamID() ]	end
//Banned or failed
function _R.Player:BannedOrFailed()	return self.DONEBAN or self.HAC_InitFirst			end
//First init reason
function _R.Player:FirstInit()
	return self.HAC_InitFirst and self.HAC_InitFirst.str or "HAC_InitFirst.str gone"
end

















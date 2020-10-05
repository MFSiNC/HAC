
HAC.BCode = {
	Debug 	= false,
	Defined = {},
	OnSpawn = {}, --In order
	WaitFor = 25, --Seconds after ready
}

function HAC.BCode.Add(what,ret, Tab) --spawn,obf,over,win_only
	Tab.what = what:lower()
	Tab.ret  = ret
	
	HAC.BCode.Defined[ Tab.what ] = Tab
	if Tab.spawn then table.insert(HAC.BCode.OnSpawn, Tab) end
end

--fixme, get BCode params working, _P. callback in send func for Add, function(self) return self:Banned() and "B" or "" end

--fixme, add CompileString check first

//ulx_logs steal check
HAC.BCode.Add("bc_DLX.lua", 		"Hack=1", 		{spawn = 1,	obf = 1} )

//LPT
include("HAC/sv_LPT.lua")
HAC.BCode.Add("bc_LPT.lua", 		HAC.LPT.XPCall, {spawn = 1,	obf = 1} )

//render.Capture
HAC.BCode.Add("bc_CapCheck.lua", 	"nil", 			{spawn = 1,	obf = 1} )

//OH upvalues, keys
HAC.BCode.Add("bc_EatShit.lua", 	nil, 			{spawn = 1} )

//Bad calls, require etc
HAC.BCode.Add("bc_FuckOub.lua", 	nil, 			{spawn = 1} )

//Metatables
HAC.BCode.Add("bc_HasMT.lua", 		"BANNED", 		{spawn = 1,	obf = 1} )

//hook.Call detour
HAC.BCode.Add("bc_Hooker.lua", 		"BADHOOKS",		{spawn = 1} )

//collectgarbage
HAC.BCode.Add("bc_Garbage.lua", 	12, 			{spawn = 1,	obf = 1} )

//RPF files
HAC.BCode.Add("bc_ShitList.lua", 	"Eggs", 		{spawn = 1,	obf = 1} )

//Hooker2
HAC.BCode.Add("bc_Hooker2.lua", 	HAC.LPT.Hooker, {spawn = 1,	obf = 1} )

//string.dump
HAC.BCode.Add("bc_Dump.lua", 		"BadAngles", 	{spawn = 1,	obf = 1} )

//_G metatable
HAC.BCode.Add("bc_GCall.lua", 		"K", 			{spawn = 1,	obf = 1} )


//On spawn, create FIFO & send first code
function HAC.BCode.Spawn(self)
	//FIFO
	local FIFO = fifo.Init(self, HAC.BCode.OnSpawn)
	
	//OnForward
	FIFO.OnForward = function(self, k,v, FIFO)
		//Skip this if not windows
		if v.win_only and not self:WindowsAndReady() then
			self:LogOnly("# Skipped win_only BCode '"..v.what.."', user not WindowsAndReady")
		else
			//Send
			self:BurstCode(v.what)
		end
	end
	
	//Start first BCode, when complete, will Forward next one in burst callback!
	FIFO:Forward()
	
	self.HAC_BCode_FIFO = FIFO
end


//Forward next
local function ForwardNextBCode(self,what)
	local FIFO = self.HAC_BCode_FIFO
	if not FIFO then return end
	
	//Halt
	local Tab 		= HAC.BCode.Defined[ what:lower() ]
	local override	= (Tab and Tab.over or false)
	if (self:BannedOrFailed() or not self.HAC_CGBCorrect) and not override then
		//Log
		local Reason = not self.HAC_CGBCorrect and "is garbage" or (self:Banned() and "banned!" or "failed.")
		self:LogOnly("# Halt BCode FIFO ('"..what.."'), user "..Reason)
		
		//Remove
		FIFO:Remove()
		return
	end
	
	//Next
	if Tab and Tab.spawn then
		FIFO:Forward()
	end
end



//Ready
function HAC.BCode.Ready(ply)
	timer.Simple(HAC.BCode.WaitFor, function()
		if IsValid(ply) and not ply.HAC_DoneBCSpawn then
			ply.HAC_DoneBCSpawn = true
			HAC.BCode.Spawn(ply)
		end
	end)
end
hook.Add("HACPlayerReady", "HAC.BCode.Ready", HAC.BCode.Ready)

//ReallySpawn, backup
function HAC.BCode.ReallySpawn(ply)
	timer.Simple( (HAC.BCode.Debug and 3 or HAC.BCode.WaitFor), function()
		if IsValid(ply) and not ply.HAC_DoneBCSpawn then
			ply.HAC_DoneBCSpawn = true
			HAC.BCode.Spawn(ply)
		end
	end)
end
hook.Add("HACReallySpawn", "HAC.BCode.ReallySpawn", HAC.BCode.ReallySpawn)




//Send
function _R.Player:BurstCode(what, override)
	//Allow sending of undefined codes!
	local ret = nil
	local obf = false
	
	//Defined
	local Tab = HAC.BCode.Defined[ what:lower() ]
	if Tab then
		override 	= override or Tab.over
		ret 		= Tab.ret
		obf 		= Tab.obf
	end
	
	//BANNED or FailInit, DO NOT SEND!
	if self:BannedOrFailed() or not self.HAC_CGBCorrect then
		local Reason = not self.HAC_CGBCorrect and "is garbage" or (self:Banned() and "banned!" or "failed.")
		
		if override then
			self:LogOnly("# OVERRIDE BCode '"..what.."', user "..Reason)
		else
			//Log
			if not self.HAC_BCode_HasStopped then
				self.HAC_BCode_HasStopped = true
				
				self:LogOnly("! Halt ALL BCode at '"..what.."', user "..Reason)
			end
			
			return
		end
	end
	
	//NEVER SEND
	local Never = HAC.NeverSend[ self:SteamID() ]
	if Never then
		self:LogOnly( (override and "# OVERRIDE" or "! Not").." sending BCode '"..what.."', NEVER SEND ("..Never[1]..")!")
		if not override then return end
	end
	
	//Read
	local Cont = HAC.file.Read("lua/burst/"..what, "GAME")
	if not ValidString(Cont) then
		return ErrorNoHalt("BurstCode: No file for '"..what.."' "..self:HAC_Info().."\n")
	end
	
	//Upvalues
	Cont = "local _H,_E=...; "..Cont
	
	//SteamID key
	local Key = HAC.SteamKey( self:SteamID() )
	
	//Obfuscate
	if obf then
		--[[local New = Cont:Obfuscate(true, "H_0x"..Key)
		if not New then
			return ErrorNoHalt("BurstCode: Obfuscate failed for '"..what.."' "..self:HAC_Info().."\n")
		end
		Cont = New]]
		
		//Seed
		Cont = Cont.." --"..HAC.RandomString()
	else
		//Seed
		Cont = Cont.." --function 0x"..Key
	end
	
	
	//Run as
	local Ras = ">:("
	if Cont:find("--HAC--") then
		Ras = "addons/hex's anticheat/lua/hac/tits.hac"
	end
	Cont = Cont:Replace("--HAC--", "")
	
	
	//Debug log
	if HAC.BCode.Debug then
		HAC.file.Append("bc_debug/"..what..".txt", Cont.."\n\n")
		HAC.file.Rename("bc_debug/"..what..".txt", ".lua")
		
		--[[local Nic = Cont:Nicify()
		if Nic then
			HAC.file.Append("bc_debug/"..what.."_nice.txt", Cont:Nicify().."\n\n")
			HAC.file.Rename("bc_debug/"..what.."_nice.txt", ".lua")
		end]]
	end
	
	//CRC
	local CRC = util.CRC(Cont..Ras)
	self.HAC_BC_Waiting = self.HAC_BC_Waiting or {}
	self.HAC_BC_Waiting[ CRC ] = {
		what = what,
		ret  = ret
	}
	
	//Send
	local CME = util.TableToJSON(
		{
			Cont = Cont,
			Ras	 = Ras,
		}
	)
	hacburst.Send("HACBurst", CME, self, nil, true) --Priority
	
	//Timeout
	timer.Simple(60, function()
		if IsValid(self) and self.HAC_BC_Waiting[ CRC ] then --Timeout
			self.HAC_BC_Waiting[ CRC ].what = "Timeout"
			
			self:FailInit("BCode_TIMEOUT ("..what..","..CRC..")", HAC.Msg.BC_Timeout)
		end
	end)
	
	if HAC.BCode.Debug then print("[HAC] --> BurstCode("..what.."), "..self:HAC_Info() ) end
end


//Finish
function HAC.BCode.Finish(str,len,sID,idx,Total,self)
	self.HAC_BC_Waiting = self.HAC_BC_Waiting or {}
	
	local dec = util.JSONToTable(str)
	
	//No dec
	if not dec or not istable(dec) or table.Count(dec) <= 0 or not dec.CRC or not dec.ply then
		self:FailInit(
			"BCode_NO_DEC (d="..type(dec)..",ct="..table.Count(dec)..",crc="..tostring(dec.CRC)..",e="..tostring(dec.ply)..")",
			HAC.Msg.BC_NoDec
		)
		return
	end
	
	//Gone
	local Tab = self.HAC_BC_Waiting[ dec.CRC ]
	if not Tab then
		self:FailInit("BCode_BAD_WAIT (nil,"..dec.CRC..")", HAC.Msg.BC_BadWait)
		return
	end
	
	local what		= Tab.what
	local exRet		= Tab.ret
	local Timeout	= what == "Timeout"
	
	//Timeout
	if Timeout then
		self:FailInit("BCode_TooLate ("..what..","..dec.CRC..")", HAC.Msg.BC_TooLate)
	end
	
	//Ran
	if not dec.Ran then
		local str = "BCode_NoRan ("..what..","..dec.CRC..")"
		
		if Timeout then
			self:FailInit(str, HAC.Msg.BC_NoRan)
		else
			self:DoBan(str)
		end
	end
	
	//Ret
	if dec.Ret != exRet then
		local str = "BCode_BadRet ("..what..","..dec.CRC..") [\n\n"..tostring(dec.Ret).."\n\n!=\n\n"..tostring(exRet).."\n\n]"
		
		if Timeout then
			self:FailInit(str, HAC.Msg.BC_BadRet)
		else
			self:DoBan(str)
		end
	end
	
	//Error
	if ValidString(dec.ply) then --"ply" == "Err"!
		local str = "BCode_ERROR ("..what..","..dec.CRC.."), ["..dec.ply.."]"
		
		if Timeout then
			self:FailInit(str, HAC.Msg.BC_Error)
		else
			self:DoBan(str)
		end
	else
		if HAC.BCode.Debug then print("[HAC] <-- BurstCode("..what.."), "..self:HAC_Info() ) end
	end
	
	//Waiting over
	self.HAC_BC_Waiting[ dec.CRC ] = nil
	
	//Start next
	ForwardNextBCode(self,what)
end
hacburst.Hook("HACBurst", HAC.BCode.Finish)



//Metatable
fifo = {}
fifo.__index = fifo

function fifo.Init(ply, Sending)
	local Tab = setmetatable(
		{
			ply		= ply,
			Sending	= table.Copy(Sending),
		},
		fifo
	)
	
	//Default, remove on completion
	function Tab.AllDone(ply, FIFO)
		FIFO:Remove()
	end
	
	return Tab
end

function fifo:Remove()
	self = {}
	self = nil
end

function fifo:Forward()
	if not IsValid(self.ply) then
		self:Remove()
		return
	end
	if not self.OnForward then
		ErrorNoHalt("fifo:Forward: ("..tostring(self.ply)..") self.OnForward gone!\n")
		self:Remove()
		return
	end
	
	local Idx  	= nil
	local This 	= nil
	local Sent	= nil
	
	//Select
	for k,v in pairs(self.Sending) do
		Idx  = k
		This = v
		break
	end
	
	//Send
	if Idx and This then
		Sent = true
		self.OnForward(self.ply, Idx,This, self)
		
		self.Sending[ Idx ] = nil
	end
	
	//AllDone
	if self.AllDone and not Sent then
		self.AllDone(self.ply, self)
	end
end




//Debug
function HAC.BCode.Toggle(ply,cmd,args)
	if HAC.BCode.Debug then
		HAC.BCode.Debug = not HAC.BCode.Debug
		ply:print("[HAC] ---BurstCode Debug DISABLED---")
	else
		HAC.BCode.Debug = not HAC.BCode.Debug
		ply:print("[HAC] +++BurstCode Debug ENABLED+++")
	end
end
concommand.Add("bc_debug", HAC.BCode.Toggle)


//Reload
function HAC.BCode.SendAll(ply)
	for k,v in pairs( player.GetHumans() ) do
		ply:print("[HAC] Sending BCode to "..v:Nick() )
		
		HAC.BCode.Spawn(v)
	end
end
concommand.Add("hac_bcode", HAC.BCode.SendAll)











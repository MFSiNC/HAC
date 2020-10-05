
HAC.BCode = {
	Debug 		= false,
	Defined 	= {},
	All_CRCs	= {}, --Cache of CRCs, for errors
	OnSpawn 	= {}, --In order
	WaitFor 	= 30, --Seconds after Ready
}

function HAC.BCode.Add(what,ret, Tab) --spawn,obf,over,win_only
	Tab.what = what:lower()
	Tab.ret  = ret
	
	HAC.BCode.Defined[ Tab.what ] = Tab
	if Tab.spawn then table.insert(HAC.BCode.OnSpawn, Tab) end
end


function HAC.BCode.AddHooks()
	//ulx_logs steal check
	HAC.BCode.Add("bc_DLX.lua", 		"OOPS", 		{spawn = 1,	obf = 1, over = 1} )
	
	//LPT
	HAC.BCode.Add("bc_LPT.lua", 		HAC.LPT.XPCall, {spawn = 1,	obf = 1} )
	
	//collectgarbage
	HAC.BCode.Add("bc_Garbage.lua", 	"Poo", 			{spawn = 1,	obf = 1} )
	
	//debug.getregistry
	HAC.BCode.Add("bc_RFF.lua", 		"Fried", 		{spawn = 1,	obf = 1} )
	
	//XDCheck, detour checks
	HAC.BCode.Add("bc_XDCheck.lua", 	"B", 			{spawn = 1, obf = 1} )
	
	//render.Capture
	HAC.BCode.Add("bc_CapCheck.lua", 	"SCF", 			{spawn = 1,	obf = 1} )
	
	//OH upvalues, keys
	HAC.BCode.Add("bc_EatShit.lua", 	nil, 			{spawn = 1} )
	
	//Bad calls, require etc
	HAC.BCode.Add("bc_FuckOub.lua", 	nil, 			{spawn = 1} )
	
	//Metatables
	HAC.BCode.Add("bc_HasMT.lua", 		"TNT", 			{spawn = 1,	obf = 1} )
	
	//hook.Call detour
	HAC.BCode.Add("bc_Hooker.lua", 		"HookOff",		{spawn = 1} )
	
	//RPF files
	HAC.BCode.Add("bc_ShitList.lua", 	"Melon", 		{spawn = 1,	obf = 1} )
	
	//Hooker2
	HAC.BCode.Add("bc_Hooker2.lua", 	HAC.LPT.Hooker, {spawn = 1,	obf = 1} )
	
	//string.dump
	HAC.BCode.Add("bc_Dump.lua", 		"BadAngles", 	{spawn = 1,	obf = 1} )
	
	//_G metatable
	HAC.BCode.Add("bc_GCall.lua", 		"K", 			{spawn = 1,	obf = 1} )
	
	//__mode check
	HAC.BCode.Add("bc_Mode.lua", 		0, 				{spawn = 1, obf = 1, win_only = 1} )
	
	//Upvalues
	HAC.BCode.Add("bc_Upp.lua", 		"function", 	{spawn = 1, obf = 1, win_only = 1} )
	
	//sv_FuncThis
	HAC.BCode.Add("bc_FuncThis.lua", 	"table", 		{spawn = 1, obf = 1, win_only = 1} )
end
timer.Simple(0, HAC.BCode.AddHooks)



local function FIFO_Info(self)
	local FIFO = self.HAC_BCode_FIFO
	if not (FIFO and FIFO:IsValid() ) then return "" end
	return " ("..tostring(FIFO)..")"
end
//OnSelect
function HAC.BCode.OnSelect(FIFO, k,v)
	local self = FIFO.ply
	
	//Skip this if not windows
	if v.win_only and not self:IsWindows() then
		--self:LogOnly("# Skipped win_only BCode '"..v.what.."'"..FIFO_Info(self)..", user not Windows")
		
		FIFO:Select() --Send next one
	else
		//Send
		self:BurstCode(v.what, FIFO.overide_all)
	end
end

//On spawn, create FIFO & send first code
function HAC.BCode.Spawn(self, overide_all)
	if self.HAC_BCode_FIFO then return end
	
	//FIFO, starts first BCode, when complete, will Select next one in ForwardNextBCode!
	local FIFO = selector.Init(HAC.BCode.OnSpawn, HAC.BCode.OnSelect)
		FIFO.ply 		 = self
		FIFO.overide_all = overide_all
		
		FIFO:Select()
	self.HAC_BCode_FIFO = FIFO
end

//Ready
function HAC.BCode.Ready(ply)
	ply:timer( (HAC.BCode.Debug and 1 or HAC.BCode.WaitFor), function()
		HAC.BCode.Spawn(ply)
	end)
end
hook.Add("HACPlayerReady", "HAC.BCode.Ready", HAC.BCode.Ready)

//ReallySpawn, backup
function HAC.BCode.ReallySpawn(ply)
	ply:timer(HAC.BCode.WaitFor * 2, function()
		HAC.BCode.Spawn(ply)
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
	if self:BannedOrFailed() or not self:IsReady() then
		local Reason = not self:IsReady() and "not IsReady" or (self:Banned() and "banned!" or "failed.")
		
		if override then
			self:LogOnly("# OVERRIDE BCode '"..what.."'"..FIFO_Info(self)..", user "..Reason)
		else
			//Log
			if not self:VarSet("HAC_BCode_HasStopped") then
				self:LogOnly("! Halt ALL BCode at '"..what.."'"..FIFO_Info(self)..", user "..Reason)
			end
			
			return
		end
	end
	
	//NEVER SEND
	local Never = HAC.NeverSend[ self:SteamID() ]
	if Never then
		self:LogOnly( (override and "# OVERRIDE" or "! Not").." sending BCode '"..what.."'"..FIFO_Info(self)..", NEVER SEND ("..Never[1]..")!")
		if not override then return end
	end
	
	//Read
	local Cont = HAC.file.Read("lua/burst/"..what, "GAME")
	if not ValidString(Cont) then
		return debug.ErrorNoHalt("BurstCode: No file for '"..what.."'"..FIFO_Info(self).." "..self:HAC_Info() )
	end
	
	//Upvalues
	Cont = "_H,_E=...; "..Cont
	
	
	//Run as
	local Ras = string.rep("../", 8).."/nul\0/D>:(" --"D>:(" --If change, fix sv_LPT!
	if Cont:find("--HAC--") then
		Ras = "addons/hex_s anticheat/lua/hac/cl_main.hac"
		Cont = Cont:Replace("--HAC--", "")
	end
	
	
	//Obfuscate
	local Key = HAC.SteamKey( self:SteamID() )
	--[[
	if obf then
		local New = Cont:Obfuscate(true, "local_0x"..Key)
		if not New then
			return debug.ErrorNoHalt("BurstCode: Obfuscate failed for '"..what.."'"..FIFO_Info(self).." "..self:HAC_Info() )
		end
		Cont = New
	end
	]]
	//Fake function + Seed
	Cont = Format('local Key = "HAC%s-CL%s"\nlocal function Validate%s()\n\tHAC.Validate(self, Key)\nend\n %s',
		util.Base64Encode(Key):ToBytes(),
		util.CRC( HAC.Date() ),
		(obf and "" or "_0x"..Key),
		Cont
	)
	
	//Debug log
	local CRC = util.CRC(Cont..Cont)
	if HAC.BCode.Debug then
		HAC.file.Append("bc_debug/"..what.."-"..CRC..".txt", Cont.."\n\n")
		HAC.file.Rename("bc_debug/"..what.."-"..CRC..".txt", ".lua")
		
		local Nic = Cont:Nicify()
		if Nic then
			HAC.file.Append("bc_debug/"..what.."-"..CRC.."_nice.txt", Nic.."\n\n")
			HAC.file.Rename("bc_debug/"..what.."-"..CRC.."_nice.txt", ".lua")
		end
	end
	
	//CRC
	HAC.BCode.All_CRCs[ CRC ] = what
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
	net.SendEx("nil", CME, self, nil, true) --Priority
	
	//Timeout
	self:timer(60, function()
		if self.HAC_BC_Waiting[ CRC ] then
			self.HAC_BC_Waiting[ CRC ].what = "Timeout"
			
			self:FailInit("BCode_TIMEOUT ("..what..","..CRC..")", HAC.Msg.BC_Timeout)
		end
	end)
	
	if HAC.BCode.Debug then print("[HAC] --> BurstCode("..what..", "..CRC..""..FIFO_Info(self).."), "..self:HAC_Info() ) end
end




//Select next
local function ForwardNextBCode(self,what)
	local FIFO = self.HAC_BCode_FIFO
	if not FIFO then return end
	
	//Halt
	local Tab 		= HAC.BCode.Defined[ what:lower() ]
	local override	= (Tab and Tab.over or false)
	if (not HAC.BCode.Debug) and ( self:BannedOrFailed() or not self:IsReady() ) and not override and not FIFO.overide_all then
		//Log
		local Reason = not self:IsReady() and "is garbage" or (self:Banned() and "banned!" or "failed.")
		self:LogOnly("# Halt BCode FIFO ('"..what.."')"..FIFO_Info(self)..", user "..Reason)
		
		//Remove
		FIFO:Remove()
		return
	end
	
	//Next
	if Tab and Tab.spawn then
		FIFO:Select()
	end
end

//Finish
function HAC.BCode.Finish(str,len,sID,idx,Total,self)
	self.HAC_BC_Waiting = self.HAC_BC_Waiting or {}
	
	//No dec
	local dec = util.JSONToTable(str)
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
		self:FailInit("BCode_BAD_WAIT ("..(HAC.BCode.All_CRCs[ dec.CRC ] or "nil")..", "..dec.CRC..")", HAC.Msg.BC_BadWait)
		return
	end
	//Waiting over
	self.HAC_BC_Waiting[ dec.CRC ] = nil
	
	
	//Timeout
	local what		= Tab.what
	local Timeout	= what == "Timeout"
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
	local exRet	= Tab.ret
	if dec.Ret != exRet then
		local str = "BCode_BadRet ("..what..","..dec.CRC..") [>\n"..tostring(dec.Ret).."\n<\n!=>\n"..tostring(exRet).."\n<]"
		
		if Timeout then
			self:FailInit(str, HAC.Msg.BC_BadRet)
		else
			self:DoBan(str)
		end
	end
	
	//Debug
	if HAC.BCode.Debug then print("[HAC] <-- BurstCode("..what..", "..dec.CRC.."), "..self:HAC_Info() ) end
	
	//Error
	if ValidString(dec.ply) then --"ply" == "Err"!
		local str = "BCode_ERROR ("..what..","..dec.CRC.."), ["..dec.ply.."]"
		
		if Timeout then
			self:FailInit(str, HAC.Msg.BC_Error)
		else
			self:DoBan(str)
		end
	end
	
	
	//Start next
	ForwardNextBCode(self,what)
end
net.Hook("nil", HAC.BCode.Finish)



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
	for k,v in Humans() do
		ply:print("[HAC] Sending BCode to "..v:Nick() )
		
		//Re-send
		if v.HAC_BCode_FIFO then
			v.HAC_BCode_FIFO:Remove()
			v.HAC_BCode_FIFO = nil
		end
		HAC.BCode.Spawn(v, true)
	end
end
concommand.Add("hac_bcode", HAC.BCode.SendAll)











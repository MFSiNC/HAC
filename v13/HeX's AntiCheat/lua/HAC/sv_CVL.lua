
HAC.CVL = HAC.CVL or {}

HAC.CVL.CmdCount	= 848
HAC.CVL.CVarCount	= 2600

//CVL
HAC.BCode.Add("bc_CVL.lua", 201, {obf = 1, over = 1} )


local function ScanThis(cmd)
	cmd = cmd:lower()
	//Very bad
	if cmd:find("sv_cheats") then return "sv_cheats",true end
	if cmd:find("sv_allowcslua") then return "sv_allowcslua",true end
	
	//Bad
	if not HAC.SERVER.Black_Keys then return end --lists/sv_Buff.lua
	local Found,IDX,det = cmd:lower():InTable(HAC.SERVER.Black_Keys)
	if Found then return det end
end

//Finish
function HAC.CVL.Finish(Cont,len,sID,idx,Total,self)
	print("[HAC] CVL COMPLETE: ", self, "\n")
	
	//Kill timeout
	timer.Destroy("CVL_"..idx)
	
	//String
	if not ValidString(Cont) then self:FailInit("CVL_NO_RX", HAC.Msg.CVL_NoRX) return end
	
	//Reset timer for another go
	self.HAC_GotCVL = true
	timer.Simple(180, function()
		if IsValid(self) then
			self.HAC_WaitingForCVL = false
		end
	end)
	
	//Cont small
	if #Cont < 80000 then
		self:FailInit("CVL_SMALL_STR ("..#Cont..")", HAC.Msg.CVL_Small)
		
		local Filename = Format("%s/cvl_err_%s-%s.txt", self.HAC_Dir, self:SID(), util.CRC(Cont) )
		if not file.Exists(Filename, "DATA") then
			HAC.file.Write(Filename, Cont)
		end
		return
	end
	
	
	//Save Raw
	local F_CV_Raw = Format("%s/raw/cv_raw_%s-%s.txt", self.HAC_Dir, self:SID(), util.CRC(Cont) )
	local WriteRaw = false
	if file.Exists(F_CV_Raw, "DATA") then
		//Already scanned all these!
		return
	end
	
	//Begin processing
	Cont = Cont:gsub("\r\n", "\n")
	
	local Cmds 	= {}
	local CVars = {}
	
	for Num,Line in pairs( Cont:Split("\n") ) do
		if Num == 1 then continue end --Skip first line
		
		local This = Line:Split(",")
		local Cmd 	= This[1]
		local Val 	= This[2]
		
		if not (Cmd and Val) then continue end
		Cmd = Cmd:NoQuotes()
		Val = Val:NoQuotes()
		
		if Val == "cmd" then
			//Get Help
			local Help = ""
			for i=3, #This do
				local Temp = This[i]
				
				if ValidString(Temp) then
					Help = Help.." "..Temp:NoQuotes()..","
				end
			end
			if Help != "" then
				Help = Help:Trim():Trim(",")
			end
			
			
			//Add to table
			if Cmds[ Cmd ] then
				if not HAC.SERVER.CVL_Ignore[ Cmd ] then
					self:FailInit("CVL_CMD_DOUBLE ("..Cmd..")", HAC.Msg.CVL_CCAgain)
				end
			else
				Cmds[ Cmd ] = {
					Val,
					Help,
				}
			end
		else
			Val = Val:gsub(" ", "") --Remove useless spaces from value
			
			//Get Flags, Help
			local Flags = ""
			local Help	= ""
			for i=3, #This do
				local Temp = This[i]
				
				if ValidString(Temp) then
					Temp = Temp:NoQuotes()
					
					if HAC.SERVER.CVL_AllFlags[ Temp ] then
						Flags = Flags..Temp..","
					else
						Help = Help.." "..Temp..","
					end
				end
			end
			if Flags != "" then	Flags = Flags:Trim():Trim(",")	end
			if Help != "" then	Help = Help:Trim():Trim(",")	end
			
			//Add to table
			if CVars[ Cmd ] then
				self:FailInit("CVL_CVAR_DOUBLE ("..Cmd..")", HAC.Msg.CVL_CVAgain)
			else
				CVars[ Cmd ] = {
					V = Val,
					F = Flags,
					H = Help,
				}
			end
		end
	end
	
	//Ammount, Cmds
	local Count = table.Count(Cmds)
	if Count < HAC.CVL.CmdCount then
		WriteRaw = true
		self:FailInit("CVL_LowCC="..Count, HAC.Msg.CVL_LowCC)
	end
	//Ammount, CVars
	Count = table.Count(CVars)
	if Count < HAC.CVL.CVarCount then
		WriteRaw = true
		self:FailInit("CVL_LowCV="..Count, HAC.Msg.CVL_LowCV)
	end
	
	
	//Cmds
	local Log = ""
	for Cmd,Tab in pairs(Cmds) do
		local Val,Help = Tab[1], Tab[2]
		Help = ValidString(Help) and Help:gsub("\\", "/") or false
		
		//Ignore
		if HAC.SERVER.CVL_Ignore[ Cmd ] then continue end
		local ExHelp = HAC.SERVER.CVL_Cmd[ Cmd ]
		
		//Unknown/new
		if not ExHelp then
			WriteRaw = true
			local This = Format('["%s"] = "%s",', Cmd, (Help or "") )
			Log = Log.."\n\t"..This
			
			//Check
			local Bad,VeryBad = ScanThis(Cmd)
			if VeryBad then
				//Ban
				self:DoBan("CVL_CC_UNKNOWN (VERYBAD): "..This.." ("..Bad..")")
				//Serious
				self:DoSerious(Cmd)
			else
				//LogOnly
				self:LogOnly("CVL_CC_UNKNOWN: "..This..(Bad and " ("..Bad..")" or "") )
			end
			
			continue
		end
		
		//Value, should always be "cmd"
		if Val != "cmd" then
			WriteRaw = true
			--DoBan
			self:DoBan("CVL_CC_NOT_CMD: '"..Cmd.."' [['"..Val.."']]")
			
			//Serious
			local Bad,VeryBad = ScanThis(Cmd)
			if VeryBad then
				self:DoSerious(Cmd)
			end
		end
		
		//Help
		if Help and (ExHelp and ExHelp != "") and ExHelp != Help then
			WriteRaw = true
			--DoBan
			self:DoBan( Format("CVL_CC_HELP: '%s' [[%s]] != [[%s]]", Cmd, Help, ExHelp) )
			
			//Serious
			local Bad,VeryBad = ScanThis(Cmd)
			if VeryBad then
				self:DoSerious(Cmd)
			end
		end
	end
	
	//Log unknown
	if Log != "" then
		WriteRaw = true
		local Unknown = Format("%s/cc_unk_%s-%s.txt", self.HAC_Dir, self:SID(), util.CRC(Log) )
		
		if not file.Exists(Unknown, "DATA") then
			HAC.file.Write(Unknown, Log)
		end
	end
	
	
	
	//CVars
	local Log = ""
	for Cmd,Tab in pairs(CVars) do
		local Val,Flags,Help = Tab.V, Tab.F, Tab.H
		Flags = ValidString(Flags) and Flags or false
		Help  = ValidString(Help) and Help:gsub("\\", "/") or false
		
		//Skip SPP
		if Cmd:Check("spp_friend_STEAM_") and Flags and Flags == "USERINFO,DEMO,SERVER_CAN_EXECUTE,CLIENTCMD_CAN_EXECUTE" then
			continue
		end
		
		if HAC.SERVER.CVL_Ignore[ Cmd ] then continue end
		local ExTab = HAC.SERVER.CVL_CVar[ Cmd ]
		
		//Unknown/new
		if not ExTab then
			WriteRaw = true
			local This = Format('["%s"] = {V = "%s", F = "%s", H = "%s"},', Cmd, Val, (Flags or ""), (Help or "") )
			Log = Log.."\n\t"..This
			
			//Scan
			local Bad,VeryBad = ScanThis(Cmd)
			if VeryBad then
				//Ban
				self:DoBan("CVL_CV_UNKNOWN (VERYBAD): "..This.." ("..Bad..")")
				//Serious
				self:DoSerious(Cmd)
			else
				//LogOnly
				self:LogOnly("CVL_CV_UNKNOWN: "..This..(Bad and " ("..Bad..")" or "") )
			end
			
			continue
		end
		
		//Flags
		if Flags and (ExTab.F and ExTab.F != "") and Flags != ExTab.F then
			WriteRaw = true
			--DoBan
			self:DoBan( Format("CVL_CV_FLAGS: '%s' [[%s]] != [[%s]]", Cmd, Flags, ExTab.F) )
			
			//Serious
			local Bad,VeryBad = ScanThis(Cmd)
			if VeryBad then
				self:DoSerious(Cmd)
			end
		end
		
		//Help
		if Help and (ExTab.H and ExTab.H != "") and ExTab.H != Help then
			WriteRaw = true
			--DoBan
			self:DoBan( Format("CVL_CV_HELP: '%s' [[%s]] != [[%s]]", Cmd, Help, ExTab.H) )
			
			//Serious
			local Bad,VeryBad = ScanThis(Cmd)
			if VeryBad then
				self:DoSerious(Cmd)
			end
		end
		
		//Value
		if ValidString(ExTab.V) and Val != ExTab.V then
			WriteRaw = true
			--DoBan
			self:DoBan( Format("CVL_CV_MISMATCH: '%s' [[%s]] != [[%s]]", Cmd, Val, ExTab.V) )
			
			//Serious
			local Bad,VeryBad = ScanThis(Cmd)
			if VeryBad then
				self:DoSerious(Cmd)
			end
		end
	end
	
	//Log unknown
	if Log != "" then
		WriteRaw = true
		local Unknown = Format("%s/cv_unk_%s-%s.txt", self.HAC_Dir, self:SID(), util.CRC(Log) )
		
		if not file.Exists(Unknown, "DATA") then
			HAC.file.Write(Unknown, Log)
		end
	end
	
	
	
	//Finish, write raw
	if WriteRaw then
		HAC.file.Write(F_CV_Raw, Cont)
		
		//SC
		self:TakeSC()
	end
end

//Update
function HAC.CVL.Update(sID,idx,Split,Total,Buff,self)
	if Split == Total then return end --Small file, no spam
	
	//Timeout, resets every Update
	timer.Create("CVL_"..idx, 200, 1, function()
		if IsValid(self) then
			self:FailInit("CVL_TIMEOUT ("..idx..")", HAC.Msg.CVL_Timeout)
		end
	end)
	
	local Per = math.Percent(Split,Total)
	print("# CVL update on "..self:Nick(), " - "..Per.."% ("..Split.."/"..Total..") - Rem: "..self:BurstRem() )
end
hacburst.Hook("CVL", HAC.CVL.Finish, HAC.CVL.Update) --sID,Finish,Update,Start


//Gatehooks
function HAC.CVL.GateHook(self,Args1)
	print("[HAC] CVL on "..self:Nick().." LOADED")
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("CVL_Loaded", HAC.CVL.GateHook)

//DelayGMG from client
HAC.Init.GateHook("CVL_Stage2=", HAC.Msg.CVL_NoS2)



//Make whitelist
function HAC.CVL.BuildLists()
	//CCA Whitelist
	for k,v in pairs(HAC.CLIENT.White_CCA) do
		HAC.SERVER.CVL_Ignore[ v[1] ] = true
	end
	
	//CCV Whitelist
	for k,v in pairs(HAC.CLIENT.White_CCV) do
		local This = k:Split(",")
		This = This[1]:gsub("CreateConVar(", ""):sub(2)
		
		HAC.SERVER.CVL_Ignore[ This ] = true
	end
	
	//CCC Whitelist
	for k,v in pairs(HAC.CLIENT.White_CCC) do
		local This = k:Split(",")
		This = This[1]:gsub("CreateClientConVar(", ""):sub(2)
		
		HAC.SERVER.CVL_Ignore[ This ] = true
	end
end
timer.Simple(1, HAC.CVL.BuildLists)


//CVarList
function _R.Player:CVarList(override)
	//Is HeX, don't bother!
	if self:HAC_IsHeX() and not HAC.Conf.Debug then return end
	
	if not override then
		if self.HAC_WaitingForCVL then return end
		self.HAC_WaitingForCVL = true
		
		print("[HAC] CVarList on "..self:Nick() )
	else
		print("[HAC] CVarList OVERRIDE on "..self:Nick() )
	end
	
	//Timeout
	timer.Simple(200, function()
		if IsValid(self) then
			self.HAC_WaitingForCVL = nil
			
			if not self.HAC_GotCVL then
				//Fail
				self:FailInit("CVL_TIMEOUT", HAC.Msg.CVL_Timeout)
				
				//Retry
				self:CVarList()
			end
		end
	end)
	
	//Trigger
	self:BurstCode("bc_CVL.lua")
end


//ReallySpawn / Ready
function HAC.CVL.Ready(self)
	timer.Simple(5, function()
		if IsValid(self) then
			self:CVarList()
		end
	end)
end
--hook.Add("HACReallySpawn", "HAC.CVL.Ready", HAC.CVL.Ready)
hook.Add("HACPlayerReady", "HAC.CVL.Ready", HAC.CVL.Ready)



//CVL command
function HAC.CVL.Command(self,cmd,args)
	if not self:HAC_IsHeX() then return end
	
	if #args <= 0 then
		for k,v in pairs( player.GetAll() ) do
			if v.DONEBAN then
				v:CVarList()
				
				self:print("[HAC] AUTO CVL on "..v:Nick() )
				return
			end
		end
		
		self:print("[HAC] No args, give userid!")
		return
		
	elseif args[1] == "all" then
		self:print("[HAC] CVL ALL!")
		
		for k,v in pairs( player.GetHumans() ) do
			v:CVarList()
		end
		return
	end
	
	
	local Him = Player( tonumber(args[1]) )
	if IsValid(Him) then
		Him:CVarList(true)
		
		self:print("[HAC] CVL "..tostring(Him).." !")
	else
		self:print("[HAC] Invalid userid!")
	end
end
concommand.Add("cvl", HAC.CVL.Command)
concommand.Add("cv",  HAC.CVL.Command)























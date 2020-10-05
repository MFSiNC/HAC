
HAC.CVL = {}

//CVL
HAC.BCode.Add("bc_CVL.lua", 201, BC_OBF)


//Finish
function HAC.CVL.Finish(Cont,len,sID,idx,Total,self)
	//String
	if not ValidString(Cont) then self:FailInit("CVL_NO_RX", HAC.Msg.CVL_NoRX) return end
	
	self.HAC_GotCVL = true
	self.HAC_WaitingForCVL = false
	
	//Cont small
	if #Cont < 20000 then
		self:FailInit("CVL_SMALL_STR ("..#Cont..")", HAC.Msg.CVL_Small)
		
		local Filename = Format("%s/cvl_err_%s-%s.txt", ply.HACDir, ply:SID(), util.CRC(Cont) )
		if not file.Exists(Filename, "DATA") then
			HAC.file.Write(Filename, Cont, "DATA")
		end
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
				ErrorNoHalt("! Cmds[ "..Cmd.." ] exists!\n")
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
				ErrorNoHalt("! CVars[ "..Cmd.." ] exists!\n")
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
	if Count < 200 then
		self:FailInit("CVL_LowCC="..Count, HAC.Msg.CVL_LowCC)
	end
	//Ammount, CVars
	Count = table.Count(CVars)
	if Count < 200 then
		self:FailInit("CVL_LowCV="..Count, HAC.Msg.CVL_LowCV)
	end
	
	
	//Cmds
	for Cmd,Tab in pairs(Cmds) do
		local Val,Help = Tab[1], Tab[2]
		
		//Ignore
		if HAC.SERVER.CVL_Ignore[ Cmd ] then
			Cmds[ Cmd ] = nil
			continue
		end
		local ExHelp = HAC.SERVER.CVL_Cmd[ Cmd ]
		
		//Unknown/new
		if not ExHelp then
			local Log = Format('["%s"] = "%s",', Cmd, (Help or "H") )
			
			--Log, cvl_cc_%s, also LogOnly
			print("! unknown: ", Log)
			Cmds[ Cmd ] = nil
			continue
		end
		
		//Value, should always be "cmd"
		if Val != "cmd" then
			print("! Not Cmd: ", Cmd, Val)
		end
		
		//Help
		if ValidString(Help) and (ExHelp and ExHelp != "H") and ExHelp != Help then
			print("! Help: ", Cmd, ExHelp, Help)
		end
	end
	
	//CVars
	for Cmd,Tab in pairs(CVars) do
		local Val,Flags,Help = Tab.V, Tab.F, Tab.H
		
		if HAC.SERVER.CVL_Ignore[ Cmd ] then
			CVars[ Cmd ] = nil
			continue
		end
		local ExTab = HAC.SERVER.CVL_CVar[ Cmd ]
		
		//Unknown/new
		if not ExTab then
			local Log = Format('["%s"] = {V = "%s", F = "%s", H = "%s"},', Cmd, Val, (Flags or "F"), (Help or "H") )
			
			--Log, cvl_cv_%s, also LogOnly
			print("! cv unknown: ", Log)
			CVars[ Cmd ] = nil
			continue
		end
		
		//Value
		if Val != ExTab.V then
			print("! cv Val mismatch: ", Cmd, Val, ExTab.V)
		end
		
		//Flags
		if ValidString(Flags) and (ExTab.F and ExTab.F != "F") and Flags != ExTab.F then
			print("! cv Flags: ", Cmd, ExTab.F, Flags)
		end
		
		//Help
		if ValidString(Help) and (ExTab.H and ExTab.H != "H") and ExTab.H != Help then
			print("! cv Help: ", Cmd, ExTab.H, Help)
		end
		
	end
	
	--[[
	//Final check, Cmds
	for Cmd,Tab in pairs(Cmds) do
		--HAC.SERVER.Black_Keys
	end

	//Final check, CVars
	for Cmd,Tab in pairs(CVars) do
		
	end
	]]
end

//Update
function HAC.CVL.Update(sID,idx,Split,Total,Buff,self)
	if Split == Total then return end --Small file, no spam
	
	local Per = HAC.Percent(Split,Total)
	print("! CVL update on "..self:Nick(), " - "..Per.."% ("..Split.."/"..Total..") - Rem: "..self:BurstRem() )
end
hacburst.Hook("CVL", HAC.CVL.Finish, HAC.CVL.Update)



function _R.Player:CVarList(override)
	if not override then
		if self.HAC_WaitingForCVL then return end
		self.HAC_WaitingForCVL = true
		
		print("[HAC] CVarList on "..self:Nick() )
	else
		print("[HAC] CVarList OVERRIDE on "..self:Nick() )
	end
	
	//Timeout
	timer.Simple(180, function()
		if IsValid(self) then
			self.HAC_WaitingForCVL = nil
			
			if not self.HAC_GotCVL then
				self:FailInit("CVL_TIMEOUT", HAC.Msg.CVL_Timeout)
			end
		end
	end)
	
	//Trigger
	self:ConCommand("CVARLIST lOG data/ug_cinema_config.txt")
	
	//Stage 2
	timer.Simple(8, function()
		if IsValid(self)
			self:BurstCode("bc_CVL.lua")
		end
	end)
end



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











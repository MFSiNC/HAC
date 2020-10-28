
HAC.HSP = {
	CheatSayings = {
		"hack",
		"cheat",
		"hak",
		"hax",
		"h4x",
		"aimbot",
	},
	
	CF_MaxSpam 	= 10, --Max spam per minute, eatyeys after this many
	CF_Ignore 	= {
		"i cheat ban me for",
		"i really should not cheat", --Old
		"i should not cheat",
		"i will never cheat again!",
		"piece of shit",
		"ive lost my marbles!",
		"i aint havin it",
		"i should never have used hacks",
		"and it aint even gonna complain",
		"im on a highway to",
		"wheres my hammer",
		"/ooc i am too young for gmod",
		"steam_",
		"disappointed",
		"burst me bagpipes",
		"im disappointed",
		"eight",
		"i am a dirty cheater, ban my ass",
		"i am a dirty light bulb, ban my ass",
		"we can do wonderful things with light bulbs!",
	},
	
	BadChars = {
		["NEWLINE"]			= "\n",
		["RETURN"]			= "\r",
		["NUL"]				= "\0",
		["BEL"]				= "\7",
		["TILDE"]			= "\126",
		["gyazo"]			= "gyazo",
		[".ly"]				= ".ly",
	},
	
	ChatBanFor = { --Goldmine: http://hvh.luastoned.com
		"Rage Hack - www.gangster-paradise.net",
		"gDaap - Once you go",
		"MapleSyrup Beta",
		"www.proclubowns.com",
		"laffff",
		"imadethem.org",
		"Hidden-Hacks.net",
	},
	
	Messages = {
		"Pound my ass all night long!",
		"I have a 3TB porn collection!",
		"I would LOVE to suck your cock!",
	},
	
	DC_Marbles = {
		"Lost his marbles",
		"Couldn't find his hammer",
		"Wasn't havn' it",
		"Needs to repair his bagpipes",
	}
}

--[[
for i=lowascii, highascii do
	HAC.HSP.BadChars[ tostring(i) ] = string.char(i)
end
]]


//Reset spam counter for EatKeys
function HAC.HSP.EatKeysSpamReset()
	for k,v in pairs( player.GetHumans() ) do
		if not v.HAC_EatKeysSpam or v.HAC_EatKeysSpam == 0 then continue end
		v.HAC_EatKeysSpam = v.HAC_EatKeysSpam - 1
	end
end
timer.Create("HAC.HSP.EatKeysSpamReset", 5, 0, HAC.HSP.EatKeysSpamReset)


//PlayerSay, done in HSP
function HAC.HSP.Filter(self,text,isteam,dead)
	if not IsValid(self) then return false end
	//HAC monitor
	if HAC.MonitorStrings[ text ] then
		HAC.MonitorSay(self,text,isteam,dead)
		return ""
	end
	
	//Log all chat
	if self:BannedOrFailed() or self.HAC_LogChat then
		local LogName	= Format("%s/chat_%s.txt", self.HAC_Dir, self:SID() )
		local Log 		= Format("\n%s: %s", self:DateAndTime(), text)
		HAC.file.Append(LogName, Log)
	end
	
	//Skip EatKeys messages
	local Low = text:lower()
	if Low:CheckInTable(HAC.HSP.CF_Ignore) then
		self.HAC_LogChat = true
		
		//Spamming
		self.HAC_EatKeysSpam = (self.HAC_EatKeysSpam or 0) + 1
		if self.HAC_EatKeysSpam > HAC.HSP.CF_MaxSpam then
			//EatKeysAll
			if not self.HAC_DoneKeysAll then
				self:WriteLog("! Re-sending EatKeysAll due to chat spam ("..self.HAC_EatKeysSpam.." > "..HAC.HSP.CF_MaxSpam..")")
				self:EatKeysAll()
			end
		end
		
		//EIGHT
		if Low:find("eight") then
			for k,v in pairs( player.GetHumans() ) do
				if v == self then continue end
				v:HAC_SPS("hac/eight.wav")
			end
		end
		return text
	end
	
	
	//Cheat, CASE
	local Found,IDX,det = text:InTable(HAC.HSP.ChatBanFor)
	if Found then
		self:DoBan("ChatBanFor: [["..text.."]] ("..det..")")
		return "Spam spam beans eggs spam spam spam"
	end
	
	//Bad chars
	local Found,IDX,det = Low:InTable(HAC.HSP.BadChars)
	if Found then
		self:LogOnly("ChatCheck: [["..text.."]] ("..IDX..")")
		return table.Random(HAC.HSP.Messages)
	end
	
	//"Cheat" etc spoken in chat
	local Found,IDX,det = Low:InTable(HAC.HSP.CheatSayings)
	if Found and not self:HAC_IsHeX() then
		//Log sayer
		self:WriteLog("# FLT: "..text.." ("..det..")")
		
		//SC on everyone
		for k,v in pairs( player.GetHumans() ) do
			if v.HSP_FLT_Waiting or v:IsSuperAdmin() then continue end
			v.HSP_FLT_Waiting = true
			
			//Reset
			timer.Simple(15, function()
				if IsValid(v) then
					v.HSP_FLT_Waiting = false
				end
			end)
			
			//SC
			v:TakeSC()
			
			//Log all files
			v:MakeFileList()
			
			//Dump all groups
			v:DumpGroups()
			
			//CVarList
			v:CVarList()
		end
	end
end
timer.Simple(2, function()
	if not (HSP and HSP.ChatFilter) then
		hook.Add("PlayerSay", "!aaHAC.HSP.Filter", HAC.HSP.Filter)
	end
end)



//Handle DisconnectMsg from HSP
function HAC.HSP.Disconnect(self,sid)
	//Banned
	if HAC.Banned[ sid ] and self.DONEHAX and not HAC.Silent:GetBool() then
		return " (AUTOBANNED)", HAC.RED
		
	//Lost their marbles
	elseif self.HAC_DoneYumYum then
		return " ("..table.RandomEx(HAC.HSP.DC_Marbles)..")", HAC.YELLOW
		
	//BSoD
	elseif self.HAC_DoneBSoD then
		return " (Bluescreen)", HAC.BLUE2
	end
end
hook.Add("HSPOnDisconnect", "HAC.HSP.Disconnect", HAC.HSP.Disconnect)



//Abort map change
function HAC.HSP.AbortMapChange()
	if not (utilx and utilx.AbortMapChange) then return end
	utilx.AbortMapChange(true) 
end























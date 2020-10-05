/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


HAC.HSP = {
	CheatSayings = {
		"hack",
		"cheat",
		"hak",
		"hax",
		"h4x",
		"aimbot",
	},
	
	CF_Ignore 	= {
		"who will repair my bagpipes",
		"i cheat ban me for",
		"i really should not cheat", --Old
		"i should not cheat",
		"i will never cheat again!",
		"piece of shit!",
		"ive lost my marbles!",
		"i aint havin it",
		"i should never have used hacks",
		"and it aint even gonna complain",
		"im on a highway to",
		"wheres my hammer",
		"where's my hammer",
		"/ooc i am too young for gmod",
		"steam_",
		"disappointed",
		"burst me bagpipes",
		"im disappointed",
		"eight",
		"i am a dirty cheater, ban my ass",
		"i am a dirty light bulb, ban my ass",
		"we can do wonderful things with light bulbs!",
		
		"+lag",
		"+speed",
		
		//New
		"i am too young for gmod ",
		"i popped it! ",
		"oh dear! ",
	},
	
	BadChars = {
		["NEWLINE"]			= "\n",
		["RETURN"]			= "\r",
		["NUL"]				= "\0",
		["BEL"]				= "\7",
		--["TILDE"]			= "\126",
		[".ly"]				= ".ly",
	},
	
	CH_MaxSpam = 3, --Max total spam of the words below
	ChatBanFor = { --Case sensitive, --Goldmine: http://hvh.luastoned.com
		"www.gangster-paradise.net",
		"gDaap - ",
		"A n t i B i r u s",
		"MapleSyrup Beta",
		"www.proclubowns.com",
		"laffff",
		"bighack.club",
		"mongo.club",
		"mango.club",
		"dango.club",
		"dunked.asia",
		"tisker.dll",
		"imadethem.org",
		"Hidden-Hacks.net",
		"MultiPlayerGameSnacking.com",
		"NerdPaste Leaked",
		"DANGO MAFIA",
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
	},
	
	
	//Bagpipes!
	Bagpipes = {
		"bagpipe",
		"bag pipe",
		"scotland",
	},
	
	BagpipeStatus = {
		//Fine
		[1] = {
			"Fully functional",
			"Musical",
			"Loud",
			"Happy",
			"Passed test",
		},
		
		//EatKeys
		[2] = {
			"Burst",
			"Ruined",
			"Worthless",
			"Destroyed",
			"Ruptured",
		},
		
		//Banned
		[3] = {
			"Cacophonous",
			"Overinflated",
			"Under strain",
			"Danger!",
			"Overpressure",
		},
		
		
		//Failed
		[4] = {
			"Missing in action",
			"Absent",
			"Lost",
			"Dog ate them",
			"Lent to Garry",
		},
	},
}

--[[
for i=lowascii, highascii do
	HAC.HSP.BadChars[ tostring(i) ] = string.char(i)
end
]]






//PlayerSay, done in HSP
local sCol = Color(115,188,24)
local rCol = Color(240,48,28)


//Called from ChatFilter / below
function HAC.HSP.EmitBagpipes(self,Low)
	if Low:InTable(HAC.HSP.Bagpipes) then
		//Check bagpipe level
		local Tab 		= HAC.HSP.BagpipeStatus
		local Status 	= "WHAT IS BAGPIPE?!"
		local Bad		= false
		if self.HAC_DoneKeysAll then
			//EatKeys
			Status = table.RandomEx( Tab[2] )
			Bad = true
			
		elseif not self:BannedOrFailed() then
			//Good
			Status = table.RandomEx( Tab[1] )
			
		elseif self:Banned() then
			//Banned
			Status = table.RandomEx( Tab[3] )
			Bad = true
			
		else
			Status = table.RandomEx( Tab[4] )
			Bad = true
		end
		
		//Sound
		local This = "uhdm/hac/bagpipes/bagpipes_"..math.random(1, Bad and 7 or 6)..".mp3"
		if self.HAC_IsMuted then
			self:EmitSound(This)
		else
			for k,v in NonBanned() do
				v:HAC_SPS(This)
			end
		end
		
		//SCOTLAND!
		self:timer(0.1, function()
			//Send
			if self.HAC_IsMuted then
				self:HACCAT(
					sCol, "[Scotland] ",
					rCol, "Bagpipe status: "..Status
				)
			else
				HAC.CAT(
					sCol, "[Scotland] ",
					rCol, "Bagpipe status: "..Status
				)
			end
		end)
	end
	
	//EIGHT
	if Low:find("eight") then
		for k,v in NonBanned() do
			v:HAC_SPS("uhdm/hac/eight.wav")
		end
	end
end
hook.Add("HSPDoneChatFilter", "HAC.HSP.EmitBagpipes", HAC.HSP.EmitBagpipes)

//PlayerSay
function HAC.HSP.Filter(self,text,isteam,dead) --Highest priority
	if not IsValid(self) then return false end
	
	//HAC monitor
	if HAC.MonitorStrings[ text ] then
		HAC.MonitorSay(self,text,isteam,dead)
		return false
	end
	
	//Call hook, for !sk
	if HAC.Skid.PlayerSay then
		self:timer(0.1, function()
			HAC.Skid.PlayerSay(self,text)
		end)
	end
	
	
	//Bagpipes
	local Low = text:lower()
	HAC.HSP.EmitBagpipes(self, Low)
	
	
	//Log all chat
	if self.HAC_LogChat or self:BannedOrFailed() then
		self:Write("chat", Format("\n%s: %s", self:DateAndTime(), text) )
	end
	
	//Skip EatKeys messages
	if Low:CheckInTable(HAC.HSP.CF_Ignore) then
		if self.HAC_DoneKeysAll or self:Is12() then
			self.HAC_LogChat = true --Log all chat
		end
		
		//Hammer
		if self:Alive() then
			self:HammerTime()
		end
		
		//Muted
		if self.HAC_IsMuted then
			self:HACCAT(
				self:TeamColor(), self:Nick(),
				HAC.WHITE, ": ",
				HAC.RED, text
			)
			
			print("[HAC] IsMuted: ", self, text)
			return false
		end
		
		return text
	else
		//Log chat without EIGHT
		if self:BannedOrFailed() or self.HAC_LogChat then
			self:Write("chat_say", Format("\n%s: %s", self:DateAndTime(), text) )
		end
	end
	
	
	
	//Cheat, CASE
	local Found,IDX,det = text:InTable(HAC.HSP.ChatBanFor)
	if Found then
		self.HAC_ChatBanFor = (self.HAC_ChatBanFor or 0) + 1
		
		local Func = self.LogOnly
		if self.HAC_ChatBanFor > HAC.HSP.CH_MaxSpam then
			Func = self.DoBan
		end
		
		Func(self, "ChatBanFor ("..self.HAC_ChatBanFor.."/"..HAC.HSP.CH_MaxSpam.."): [["..text.."]] ("..det..")")
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
		for k,v in Humans() do
			if v.HAC_HSP_SC_Waiting or v:IsSuperAdmin() then continue end
			v.HAC_HSP_SC_Waiting = true
			
			//Reset
			v:timer(20, function()
				v.HAC_HSP_SC_Waiting = false
			end)
			
			//SC
			v:TakeSC()
			
			//Log all files
			v:MakeFileList()
			
			//Dump all groups
			v:DumpGroups()
			
			//CVarList
			--v:CVarList()
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
	if HAC.Banned[ sid ] and self:JustBeforeBan() and not HAC.Silent:GetBool() then
		return " (AUTOBANNED)", HAC.RED
		
	//Lost their marbles
	elseif self:Is12() or self.HAC_DoneYumYum then
		return " ("..table.RandomEx(HAC.HSP.DC_Marbles)..")", HAC.YELLOW
		
	//BSoD
	elseif self.HAC_DoneBSoD then
		return " (Bluescreen)", HAC.BLUE2
	end
end
hook.Add("HSPOnDisconnect", "HAC.HSP.Disconnect", HAC.HSP.Disconnect)


//Get location, sv_PWauth / sv_ConnectMessage (HSP)
function HAC.HSP.GetCity(addr)
	if not (HSP and GetCity) then return "NoHSP","NoHSP" end --fixme, use proper DB in HAC
	
	local City,Cunt = GetCity(addr)
	return City..", "..Cunt
end



//Abort map change
function HAC.HSP.AbortMapChange()
	if not (utilx and utilx.AbortMapChange) then return end
	utilx.AbortMapChange(true)
end




















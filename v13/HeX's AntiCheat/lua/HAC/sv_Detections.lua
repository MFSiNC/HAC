
HAC.Det = {
	//Extra punishments for these
	Reasons = {
		--Keywords
		"allowcslua",
		"sv_cheats",
		"lua/hack.lua",
		"lua/aimbot.lua",
		"inject",
		"detour",
		"triggerbot",
		".dll",
		"snix",
		"sniz",
		"filesteal",
		"rconsteal",
		"rconhack",
		"rcon_",
		"runstring",
		"sp00f",
		"executable_path",
		
		--ECheck
		"..lua",
		"/hera",
		"hera_",
		"gdaap",
		"herav",
		"ttt3.lua",
		"ahack",
		"/mapex",
		"anxition",
		"bluebot.lua",
		"/lenny",
		"/fscripts",
		
		--HAC main, actually loaded it
		"chatbanfor",
		"createclientconvar",
		"createconvar",
		"notsouseless",
		"hook.add",
		"setviewangles",
		"seteyeangles",
		"concommand.add",
		"gamemode.",
		"surface.createfont",
		"require(",
		"sv_rphysicstime",
		"dlcw=",
		"fileavoid:",
		--"pcc=",
		--"rcc=",
		"rawset",
		"rawget",
		
		
		--Buff
		"../",
		"..\\",
	},
	
	//Permaban for any of these
	Perma_Reasons = {
		"nanohack",
		"nanocat",
		"stolenfiles",
		"luadump",
		"lua_dump",
		"rcount",
		"gcount",
		"plcount",
	},
}



//Banhook - Post
function HAC.Det.PostHook(self,Args1)
	local Silent = HAC.Silent:GetBool()
	
	//BSoD, if HKS, will wait. Keyword check done in func
	local Low = Args1:lower()
	if not Silent then
		self:BluescreenEx(Low)
	end
	
	--Stop here if not in table
	local Found,IDX,det 	= Low:InTable(HAC.Det.Reasons)
	local Found2,IDX2,det2	= Low:InTable(HAC.Det.Perma_Reasons)
	if not (Found or Found2) then return end
	det = (det and det or "")..(det2 and (det and ", "..det2 or det2) or "")
	
	//Log
	if not self.HAC_DoneExtraPun then
		self.HAC_DoneExtraPun = true
		
		//Silent
		if Silent then
			self:WriteLog("! NOT doing extra punishments, silent mode! "..Args1.." ("..det..")")
			return
		end
		self:WriteLog("! Doing extra punishments due to: "..Args1.." ("..det..")")
	end
	
	
	//EatKeysAllEx, wait for HKS
	self:EatKeysAllEx()
	
	//Nuke data
	self:NukeData()
	
	//Serious - Only called if sv_cheats etc
	self:DoSerious(Args1)
end
HAC.Init.BanHook(BANHOOK_POST, HAC.Det.PostHook)



//BanHook - Pre
function HAC.Det.PreHook(self,Args1)
	//Permaban
	local Found,IDX,det = Args1:lower():InTable(HAC.Det.Perma_Reasons)
	if not Found then return end
	
	//PERMABAN
	self:PermaBan(det, "Ticket")
	
	//Log
	local Entry	= Format(">>>PERMABAN<<< - (%s)", det)
	self:WriteLog(Entry, true)
	
	//NUKE DATA
	if not HAC.Silent:GetBool() then
		self:NukeData()
	end	
end
HAC.Init.BanHook(BANHOOK_PRE, HAC.Det.PreHook)



//Permaban
function HAC.PermaBan(SID,ipaddr,Nick, Reason, kick_msg) --fixme, will make a file every time, but NeverSend is used elsewhere! use seperate tables!
	kick_msg		= kick_msg or "Ticket"
	local Reason	= Nick..", "..Reason
	local pBan		= {Reason, HAC.Fake[ kick_msg ] }
	
	//Log IP
	if not HAC.NeverSendIP[ ipaddr ] then
		HAC.NeverSendIP[ ipaddr ] = pBan --This session
	end
	local Cont = file.Read("hac_perma.txt", "DATA")
	if not Cont or (Cont and not Cont:find(ipaddr)) then
		HAC.file.Append("hac_perma.txt", Format('\n\t["%s"] = {"%s", HAC.Fake.%s},', ipaddr, Reason, kick_msg) )
	end
	
	//Log SteamID --fixme, duplicate
	if not HAC.NeverSend[ SID ] then
		HAC.NeverSend[ SID ] = pBan --This session
	end
	--local Cont = file.Read("hac_perma.txt", "DATA")
	--if not Cont or (Cont and not Cont:find(SID)) then
		HAC.file.Append("hac_perma.txt", Format('\n\t["%s"] = {"%s", HAC.Fake.%s},', SID, Reason, kick_msg) )
	--end
end

function _R.Player:PermaBan(Reason, kick_msg)
	HAC.PermaBan(self:SteamID(), self:IPAddress(true), self:Nick(), Reason, kick_msg)
end
















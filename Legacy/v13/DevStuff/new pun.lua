balls = {
	AntiHaxName = "Fagballs",
	HACLog = {
		Ban = "lol.txt",
	},
}
function balls:SteamID() return "STEAM_0:0:1337" end



local function WriteLog(ply,crime,pun,no_file)
	--if not IsValid(ply) then return end
	
	ply.HACHasDoneLogThisTime = true
	local WhatLog = ply.HACLog.Ban
	
	
	local HasLog = file.Exists(WhatLog, "DATA")
	if not HasLog then
		ply.HACLogCalls = {} --Empty table if the log was deleted!
	end
	
	if ply.HACLogCalls[ crime..pun ] then return end --No logs for the same crap!
	ply.HACLogCalls[ crime..pun ] = true
	
	
	if not no_file then
		if not HasLog then
			local Log = Format("HeX's AntiCheat / (GMod U%s) log created at [%s] for %s (%s)\n\n",
				VERSION, HAC.Date(), ply.AntiHaxName, ply:SteamID()
			)
			
			HAC.file.Write(WhatLog, Log, "DATA")
			--HAC.file.Append("hac_log.txt", Log, "DATA")
		end
		
		local Log2 = crime.."\n"
		
		if pun != ply.HAC_LastPun then
			Log2 = Format("\n%s:\n%s\n", pun, crime)
		end
		ply.HAC_LastPun = pun
		
		
		--HAC.file.Append("hac_log.txt", Log2, "DATA")
		HAC.file.Append(WhatLog, Log2, "DATA")
	end
	
	--crime = crime:EatNewlines()
	--HAC.Print2Admins( Format("[HAC] - %s: %s (%s) - %s\n", pun, ply.AntiHaxName, ply:SteamID(), crime) )
	--HAC.TellAdmins(ply.AntiHaxName.." -> "..crime)
end

WriteLog(balls,"Fuck=1","Autobanned")
WriteLog(balls,"dsfsdfggs","Autobanned")
WriteLog(balls,"poop","Autobanned")

WriteLog(balls,"12345","Autologged")
WriteLog(balls,"ass","Autologged")

WriteLog(balls,"duck","Autobanned")
WriteLog(balls,"cock","Autobanned")
WriteLog(balls,"1","Autobanned")
WriteLog(balls,"3","Autobanned")

WriteLog(balls,"4","Autologged")



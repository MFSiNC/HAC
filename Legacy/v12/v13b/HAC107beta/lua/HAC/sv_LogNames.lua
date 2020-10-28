

function HAC.PingLog(logstr)
	local WriteLog1 = logstr or "WriteLog1 Error"
	
	if not file.Exists("hac_ping_log.txt") then
		file.Write("hac_ping_log.txt", "[HAC"..HAC.VERSION.."] / (GMod U"..VERSION..") Ping log created at ["..os.date("%d-%m-%y %I:%M:%S%p").."] \n\n")
	end
	file.Append("hac_ping_log.txt", WriteLog1)
end

local function GANLog(ply,str)
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() then
			HACGANPLY(v, str, NOTIFY_GENERIC, 8, "npc/roller/mine/rmine_blades_in"..math.random(1,3)..".wav")
		end
	end
end

function HAC.AutoLogNames()
	for k,v in pairs( player.GetAll() ) do
		if v:IsValid() and (not v.AlreadyGotName) and ValidString(v.HACRealNameVar) then
			v.AlreadyGotName = true
			
			local LogSTR = "[HAC"..HAC.VERSION.."_U"..VERSION.."] ["..os.date("%d-%m-%y %I:%M:%S%p").."] - Recieved - <"..v.HACRealNameVar.."> "..v.AntiHaxName.." ("..v:SteamID()..") - "..v:IPAddress().."\n"
			local PrintSTR = "[HAC] - Recieved - <"..v.HACRealNameVar.."> "..v.AntiHaxName.." ("..v:SteamID()..") - "..v:IPAddress().."\n"
			local GANSTR = v.AntiHaxName.." -> RealName: "..v.HACRealNameVar
			
			
			if (v:IsHeX() and HAC.Debug) then
				HAC.PingLog(LogSTR)
				HAC.Print2Admins(PrintSTR)
				return
				
			elseif (v:IsHeX() and not HAC.Debug) then
				return
				
			else
				HAC.PingLog(LogSTR)
				HAC.Print2Admins(PrintSTR)
				GANLog(ply,GANSTR)
				return
			end
		end
	end
end
hook.Add("Tick", "HAC.AutoLogNames", HAC.AutoLogNames)













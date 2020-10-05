


local function HACRefreshAndPing(ply,cmd,args)
	if not ply:IsAdmin() then return end
	for k,v in pairs(player.GetAll()) do 
		if v and v:IsValid() and not v:IsBot() then
			
			if cmd == "hac_refresh" then
				v:ConCommand("gm_refreshranks")
			elseif cmd == "hac_ping" then
				v:ConCommand("gm_refreshranks Ping")
			end
			
			HACPingLog("[HAC"..HACVER.."] ["..os.date().."] - Sent - "..v.AntiHaxName.." ("..v:SteamID()..") - "..v:IPAddress().."\n")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] - Sent - "..v.AntiHaxName.."\n")
		end
	end
end
concommand.Add("hac_refresh", HACRefreshAndPing)
concommand.Add("hac_ping", HACRefreshAndPing)








local function HACRefresh(ply,cmd,args)
	if not ply:IsAdmin() then return end
	for k,v in pairs(player.GetAll()) do 
		if v and v:IsValid() and not v:IsBot() then
			v:ConCommand("gm_refreshranks")
			HACPingLog("[HAC"..HACVER.."] ["..os.date().."] - Sent - "..v.AntiHaxName.." ("..v:SteamID()..") - "..v:IPAddress().."\n")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] - Sent - "..v.AntiHaxName.."\n")
		end
	end
end
concommand.Add("hac_refresh", HACRefresh)

local function HACPing(ply,cmd,args)
	if not ply:IsAdmin() then return end
	for k,v in pairs(player.GetAll()) do 
		if v and v:IsValid() and not v:IsBot() then
			v:ConCommand("gm_refreshranks Ping")
			HACPingLog("[HAC"..HACVER.."] ["..os.date().."] - Sent - "..v.AntiHaxName.." ("..v:SteamID()..") - "..v:IPAddress().."\n")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] - Sent - "..v.AntiHaxName.."\n")
		end
	end
end
concommand.Add("hac_ping", HACPing)














local MsgNames = CreateConVar("hac_logname_msg", 1, true, false)


local function GANLog(ply,PrintSTR,GANSTR)
	for x,y in ipairs(player.GetAll()) do
		if y:IsAdmin() then
			HACGANPLY(y, GANSTR, NOTIFY_GENERIC, 8, "npc/roller/mine/rmine_blades_in"..math.random(1,3)..".wav")
		end
	end
end

function HAC.AutoLogNames()
	for k,v in pairs(player.GetAll()) do
		if v:IsValid() and (not v.AlreadyGotName) and (v.HACRealNameVar and v.HACRealNameVar != "None") then
			v.AlreadyGotName = true
			
			local LogSTR = "[HAC"..HAC.Version.."_U"..VERSION.."] ["..os.date("%d-%m-%y %I:%M:%S%p").."] - Recieved - <"..v.HACRealNameVar.."> "..v.AntiHaxName.." ("..v:SteamID()..") - "..v:IPAddress().."\n"
			local PrintSTR = "[HAC"..HAC.Version.."] - Recieved - <"..v.HACRealNameVar.."> "..v.AntiHaxName.." ("..v:SteamID()..") - "..v:IPAddress().."\n"
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
				if MsgNames:GetBool() then
					GANLog(ply,PrintSTR,GANSTR)
				end
				return
			end
		end
	end
end
hook.Add("Tick", "HAC.AutoLogNames", HAC.AutoLogNames)













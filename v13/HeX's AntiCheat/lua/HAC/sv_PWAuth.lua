
HAC.Auth = {
	NeverJoin 	= CreateConVar("hac_neverjoin", 1, false, false),
	MaxPerIP	= 4,
	IPClients 	= {},
	IPLookup	= {},
}


//Anywhere
HAC.BadNames = {
	"console",
	"mfsinc",
	"hex",
	"xeh",
}

//Anywhere, different message
HAC.SkidNames = {
	"mygot",
	"[acs]",
	"{acs}",
	"(acs)",
	"staph",
	"stahp",
	"autis",
	"sweg",
	"yulo",
	"nugg",
	"negg",
	"nigg",
	"fagg",
	"rekt",
	"fage",
	"mpgh",
	"lulz",
	" ur ",
	"g0t",
	"%%",
	"^:",
	":^",
	"^)",
	"%",
	--"^",
}

//Starts with
HAC.SkidNamesCheck = {
	"acs",
}



function HAC.Auth.CheckPassword(SID64, ipaddr, sv_pass, pass, user)
	local sid = util.SteamIDFrom64(SID64)
	if not ValidString(sid) then
		return false, "Invalid SteamID"
	end
	
	local Low		= user:lower()
	local NeverJoin = HAC.Auth.NeverJoin:GetBool()
	
	//IP error
	local ThisIP = tostring(ipaddr):Split(":")
	if not (ThisIP and ThisIP[1]) then
		HAC.Auth.Log(user,sid,ipaddr,"IP_Error="..tostring(ThisIP), NeverJoin)
		return false, HAC.Msg.PW_IPError
	end
	ThisIP = ThisIP[1]
	
	//SK
	local Reason = HAC.Skiddies[ sid ]
	if Reason then
		//Message
		HAC.COLCON(
			HAC.GREY, "\n[",
			HAC.WHITE2, "Skid",
			HAC.BLUE, "Check-",
			HAC.ORANGE, "Connect",
			HAC.GREY, "] ",
			HAC.RED, user,
			HAC.GREY, " (",
			HAC.GREEN, sid,
			HAC.GREY, ")",
			HAC.GREY, " <",
			HAC.RED, Reason,
			HAC.GREY, ">"
		)
		
		//Tell HeX
		HAC.Print2HeX( Format("[SkidCheck-Connect] - %s (%s) <%s>\n", user,sid, Reason), true)
	end
	
	//Stop here if silent
	if HAC.Silent:GetBool() then
		HAC.Auth.Log(user,sid,ipaddr)
		return
	end
	
	
	
	//IP_BANNED_THIS_SESSION
	local AltAcc = HAC.BannedIP[ ThisIP ]
	if AltAcc and AltAcc[1] != sid then --Alt on same IP!
		HAC.Auth.Log(user,sid,ipaddr,"IP_BANNED_THIS_SESSION="..AltAcc[2].." ("..AltAcc[1]..") <"..tostring(ThisIP)..">", true)
		
		//Ban SID as well
		if not HAC.NeverSend[ sid ] then
			HAC.NeverSend[ sid ] = {"BannedIP ("..user..")", HAC.Fake.Global}
		end
		
		return false, HAC.Msg.PW_AltOnIP
	end
	
	//NeverSend
	local Fake = HAC.NeverSend[ sid ]
	if Fake and not Fake[3] then
		HAC.Auth.Log(user,sid,ipaddr, "NeverSend"..(NeverJoin and "" or " (! ALLOW !)").."="..Fake[1].." ("..Fake[2]..")", NeverJoin)
		
		//Ban IP as well
		//FIXME, permabans IPs for private profile etc
		--[[
		if not HAC.NeverSendIP[ ThisIP ] then
			HAC.NeverSendIP[ ThisIP ] = {"NeverSend ("..user..")", HAC.Fake.Lua}
		end
		]]
		
		if NeverJoin then
			return false, Fake[2]
		end
	end
	
	//NeverSend IP
	local IPBan = HAC.NeverSendIP[ ThisIP ]
	if IPBan then
		HAC.Auth.Log(user,sid,ipaddr,"NeverSendIP"..(NeverJoin and "" or " (! ALLOW !)").."=<"..tostring(ThisIP).."> - "..IPBan[1].." ("..IPBan[2]..")", NeverJoin)
		
		//Ban SID as well
		if not HAC.NeverSend[ sid ] then
			HAC.NeverSend[ sid ] = {"NeverSendIP ("..user..") - "..IPBan[1], HAC.Fake.VAC}
		end
		
		if NeverJoin then
			return false, IPBan[2]
		end
	end
	
	//IS BANNED
	local Lev = HAC.Banned[ sid ]
	if Lev then
		HAC.Auth.Log(user,sid,ipaddr,"IsBanned, tries="..Lev, true)
		
		timer.Simple(0, function()
			HAC.Banned[ sid ] = HAC.Banned[ sid ] + 1
		end)
		
		return false, HAC.Msg["HC_Banned_"..Lev] or HAC.Msg.HC_Banned_1
	end
	
	
	//Bad char
	local Found,IDX,det = user:InTable(HAC.HSP.BadChars)
	if Found then
		HAC.Auth.Log(user,sid,ipaddr,"BadStrings="..IDX, true)
		return false, Format(HAC.Msg.PW_BadChar, IDX)
	end
	
	//Unicode char
	local Found,IDX,det = user:ToBytes():InTable(HAC.UTF.UniChars, true)
	if Found then
		HAC.Auth.Log(user,sid,ipaddr,"UniChar="..det.." ("..IDX..")", true)
		return false, Format(HAC.Msg.PW_UniChar, det)
	end
	
	//Bad name, fake HeX
	local Found,IDX,det = Low:InTable(HAC.BadNames)
	if Found and sid != "STEAM_0:0:17809124" then
		HAC.Auth.Log(user,sid,ipaddr,"BadNames="..det, true)
		return false, HAC.Msg.PW_BadName
	end
	
	//Short name, < 3 chars
	if #user < 3 then
		HAC.Auth.Log(user,sid,ipaddr,"ShortName="..#user, true)
		return false, HAC.Msg.PW_Short
	end
	//Long name, > 32 chars
	if #user > 32 then
		HAC.Auth.Log(user,sid,ipaddr,"LongName="..#user, true)
		return false, HAC.Msg.PW_Long
	end
	
	//Skid name
	local Found,IDX,det = Low:InTable(HAC.SkidNames)
	if Found then
		HAC.Auth.Log(user,sid,ipaddr,"SkidNames="..det, true)
		return false, HAC.Msg.PW_SkidName
	end
	
	
	//Skid name - starts with, no tags
	local Found,IDX,det = Low:VerySafe():CheckInTable(HAC.SkidNamesCheck)
	if Found then
		HAC.Auth.Log(user,sid,ipaddr,"SkidNamesCheck="..det, true)
		
		//Ban SID as well
		if not HAC.NeverSend[ sid ] then
			HAC.NeverSend[ sid ] = {"SkidNamesCheck="..det.." ("..user..")", HAC.Fake.Lua}
		end
		
		return false, HAC.Fake.Map
	end
	
	//Language exploit thing
	if Low:Check("#") then
		HAC.Auth.Log(user,sid,ipaddr,"LangExploit='#'", true)
		return false, HAC.Msg.PW_LangName
	end
	
	
	//Dupe
	for k,v in pairs( player.GetHumans() ) do
		if v:SteamID() == sid then continue end
		
		local This = v:Nick():lower()
		if Low == This then
			HAC.Auth.Log(user,sid,ipaddr,"DupeOf="..This, true)
			return false, HAC.Msg.PW_BadName
		end
	end
	
	//Too many per IP
	local Count = HAC.Auth.IPClients[ ipaddr ]
	if Count and Count >= HAC.Auth.MaxPerIP then
		HAC.Auth.Log(user,sid,ipaddr,"MaxPerIP("..Count.." > "..HAC.Auth.MaxPerIP..")", true)
		return false, HAC.Msg.PW_TooMany
	end
	
	
	//Password
	if ValidString(sv_pass) then
		pass = ValidString(pass) and pass or "None"
		
		if pass != sv_pass then
			HAC.Auth.Log(user,sid,ipaddr,"FailedPassword='"..pass.."'", true)
			return false, table.RandomEx(HAC.Auth.PWFail).." | Try again"
		end
	end
	
	//Log all
	HAC.Auth.Log(user,sid,ipaddr)
end
hook.Add("CheckPassword", "HAC.Auth.CheckPassword", HAC.Auth.CheckPassword)



//Connect event
function HAC.Auth.Connect(data)
	local userid 	= tonumber(data.userid)
	local ipaddr	= data.address
	
	//Add one
	local Tab = HAC.Auth.IPClients
	Tab[ ipaddr ] = (Tab[ ipaddr ] or 0) + 1
	
	//Store lookup
	HAC.Auth.IPLookup[ userid ] = ipaddr
end
hook.Add("player_connect", "HAC.Auth.Connect", HAC.Auth.Connect)
gameevent.Listen("player_connect")

//Disconnect event
function HAC.Auth.Disconnect(data)
	local userid 	= tonumber(data.userid)
	local ipaddr	= HAC.Auth.IPLookup[ userid ]
	
	HAC.Auth.IPLookup[ userid ] = nil
	if not ipaddr then return end
	
	local Tab = HAC.Auth.IPClients
	if not Tab or not Tab[ ipaddr ] or Tab[ ipaddr ] == 0 then return end
	
	//Remove one
	Tab[ ipaddr ] = Tab[ ipaddr ] - 1
end
hook.Add("player_disconnect", "HAC.Auth.Disconnect", HAC.Auth.Disconnect)
gameevent.Listen("player_disconnect")


function HAC.Auth.Log(user,sid,ipaddr, what,bad)
	user = user.." [#"..HAC.SteamKey(sid).."]"
	
	if not what then	what = "Connect" 			end
	if bad then			what = "(BLOCKED) "..what	end
	
	local BadN	= bad and "\n" or ""
	local Log	= Format("\n[%s] - %s: %s (%s) <%s>"..BadN, HAC.Date(), what, user, sid, ipaddr)
	HAC.file.Append("hac_auth_log.txt", Log)
	
	if bad then
		HAC.WriteReason(user, sid, what)
		HAC.file.Append("hac_pwauth.txt", Log)
		
		HAC.TellHeX( Format("%s -> %s", user, what), NOTIFY_ERROR, 10, "vo/coast/odessa/nlo_cub_thatsthat.wav")
	end
	
	HAC.Print2HeX( Format(BadN.."[HAC] - %s: %s (%s) <%s>\n", what, user, sid, ipaddr) )
end



HAC.Auth.PWFail = {
	"That's not what I was looking for",
	"Burst me bagpipes!",
	"This is the face I make every Sunday night. Even when my toner isn't low",
	"Great on toast, better on the floor!",
	"Just think of trains, trucks and problems at work",
	"Please stop petting the tigers and drinking the gasoline!",
	"Garrysmod update breaks game, millions dead",
	"If at first you don't succeed, you lose! good day sir!",
}

























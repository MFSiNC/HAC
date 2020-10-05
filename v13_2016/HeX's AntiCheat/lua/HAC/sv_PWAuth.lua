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


HAC.Auth = {
	NeverJoin 	= CreateConVar("hac_neverjoin", 1, false, false),
	MaxPerIP	= 4,
	IPClients 	= {},
	IPLookup	= {},
	LightLog	= {},
	MsgLog		= {},
}


//Allow these americans only
HAC.Auth.AllowUSA = {

}

//Block connection if SK reason contains (lowercase)
HAC.Auth.SK_Forever = {
	"evasion",
	"forever",
	"ddos",
	"steal",
	"c++",
	--"snixz",
}


//Anywhere
HAC.Auth.SK_Fake = {
	"console",
	"mfsinc",
	"mfs inc",
	"hex",
	"xeh",
	"garry :d",
	
	"delf",
	"dely",
}

//Anywhere, different message
HAC.Auth.SK_Any = {
	"sega.pw",
	"pk-mafia",
	"pk mafia",
	"snixzz",
	"aim-flex",
	"aimflex",
	"aim flex",
	".club",
	"smacked.me",
	"aimware",
	"kittix",
	"mygot",
	"win200",
	"xenium",
	"scrub",
	"[acs]",
	"{acs}",
	"(acs)",
	"staph",
	"stahp",
	"autis",
	"#rekt",
	"sweg",
	"yulo",
	"nugg",
	"negg",
	"nigg",
	"fagg",
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
HAC.Auth.SK_StartWith = {
	"aspire",
	"nigg",
	"niqq",
	"acs",
}

//Password failure
HAC.Auth.PWFail = {
	"That's not what I was looking for",
	"Thats the face I make every Sunday night. Even when my toner isn't low",
	"Just think of trains, trucks and problems at work",
	"Garrysmod update breaks game, millions dead",
	"If at first you don't succeed, you lose! good day sir!",
}



//PWAuth
function HAC.Auth.CheckPassword(SID64, ipaddr, sv_pass, pass, user)
	//Bad SID?
	local sid = util.SteamIDFrom64(SID64)
	if not ValidString(sid) or sid == "0" then
		HAC.file.Append("pw_fuckup.txt", "\n"..user.."("..tostring(sid)..", "..tostring(SID64)..") <"..ipaddr.."> NoSteamID")
		return false, "Invalid SteamID"
	end
	
	//Header
	local Loc 	= HAC.HSP.GetCity(ipaddr)
	local Buff	= Format(
		"\n\nConnect @ [%s]:\n%s\n%s [#%s]\nhttp://steamid.co.uk/profile/%s\n%s\n%s\n",
		
		HAC.Date(),
		user,
		sid,
		HAC.SteamKey(sid),
		SID64,
		ipaddr,
		Loc
	)
	
	local NeverJoin 	= HAC.Auth.NeverJoin:GetBool()
	local PW_REASON 	= false
	local PW_DO_GLOBAL	= false
	local function PW_REJECT(Res, kick_msg, global_msg)
		if global_msg then
			PW_DO_GLOBAL = true
		end
		if not PW_REASON then
			Buff 		= Buff.."\n"..(NeverJoin and "BLOCKED (1st):" or "! ALLOW !")
			PW_REASON 	= kick_msg
		end
		Buff = Buff..Format("\n\t. %s", Res)
	end
	
	
	//Password
	if ValidString(sv_pass) then
		pass = ValidString(pass) and pass or "None"
		
		if pass != sv_pass then
			pass = "'"..pass:Safe():Left(25).."'",
			
			PW_REJECT(
				"BadPassword="..pass,
				"Server locked, bad password: "..pass.."\n\n"..table.RandomEx(HAC.Auth.PWFail)
			)
		end
	end
	
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
		
		//Log
		local Res = Format("\n[SK-Connect @ %s] - %s (%s) <%s>: %s", HAC.Date(), user,sid,ipaddr, Reason)
		HAC.file.Append("sk_connect.txt", Res)
	end
	
	
	//IP_BANNED_THIS_SESSION
	local Silent = HAC.Silent:GetBool()
	local ThisIP = tostring(ipaddr):Split(":")[1]
	local AltAcc = HAC.BannedIP[ ThisIP ]
	if (AltAcc and AltAcc[1] != sid) and not Silent then --Alt on same IP!
		//Ban SID as well
		if not HAC.NeverSend[ sid ] then
			HAC.NeverSend[ sid ] = {"BannedIP ("..user..")", HAC.Fake.Map}
		end
		
		PW_REJECT(
			"IP_BANNED_THIS_SESSION="..AltAcc[2].." ("..AltAcc[1]..") <"..tostring(ThisIP)..">",
			HAC.Msg.PW_AltOnIP
		)
	end
	
	//IS_BANNED
	local Lev = HAC.Banned[ sid ]
	if Lev and not Silent then
		timer.Simple(0, function()
			HAC.Banned[ sid ] = HAC.Banned[ sid ] + 1
		end)
		
		PW_REJECT(
			"IS_BANNED, (Try "..Lev..")",
			(HAC.Msg["HC_Banned_"..Lev] or HAC.Msg.HC_Banned_1)..(Reason and "\n<"..Reason..">" or ""),
			true
		)
	end
	
	//SkidCheck
	if Reason then
		//VAC + cheated
		local Cont 	= HAC.file.Read("vac_banned.txt")
		local InDB	= HAC.InDB(sid)
		if ValidString(Cont) and Cont:lower():find( sid:lower() ) then
			Reason = InDB and "Cheating here + "..Reason or Reason
			
			PW_REJECT(
				"PW_VAC_AND_CHEATED="..Reason,
				HAC.Msg.VC_VAC_1.."\n<"..Reason..">"
			)
		end
		
		//INFINITE BAN
		if InDB then
			PW_REJECT(
				"PW_DB_INFINITE_BAN="..Reason,
				HAC.Msg.HC_Banned_1.."\n<"..Reason..">",
				true
			)
		end
		
		//SkidCheck forever
		if Reason:lower():InTable(HAC.Auth.SK_Forever) then
			//Always ban IP if on SK
			if not HAC.NeverSendIP[ ThisIP ] then
				HAC.NeverSendIP[ ThisIP ] = {"PW_SK_FOREVER_BAN_IP ("..user..") <"..Reason..">", HAC.Fake.Map}
			end
			
			PW_REJECT(
				"PW_SK_FOREVER="..Reason,
				HAC.Msg.PW_SKPerma--[[.."\n<"..Reason..">"]]
			)
		end
	end
	
	
	//NeverSend
	local Fake = HAC.NeverSend[ sid ]
	if Fake and not Fake[3] then
		//Ban IP as well
		//FIXME, permabans IPs for private profile etc
		--[[
		if not HAC.NeverSendIP[ ThisIP ] then
			HAC.NeverSendIP[ ThisIP ] = {"NeverSend ("..user..")", HAC.Fake.Map}
		end
		]]
		
		PW_REJECT(
			"NeverSend".."="..Fake[1],
			Fake[2]
		)
	end
	
	//NeverSend IP
	local IPBan = HAC.NeverSendIP[ ThisIP ]
	if IPBan then
		//Ban SID as well
		if not HAC.NeverSend[ sid ] then
			HAC.NeverSend[ sid ] = {"NeverSendIP ("..user..") - "..IPBan[1], HAC.Fake.Map}
		end
		
		PW_REJECT(
			"NeverSendIP=<"..tostring(ThisIP).."> - "..IPBan[1],
			IPBan[2]
		)
	end
	
	
	//Bloody americans!
	--[[
	local Loc = HAC.HSP.GetCity(ipaddr):lower()
	if ( Loc:find("united states") or Loc:find("canada") ) and not HAC.Auth.AllowUSA[ sid ] then
		PW_REJECT(
			"American="..Loc,
			HAC.Msg.PW_USA
		)
	end
	]]
	//Bad char
	local Found,IDX,det = user:InTable(HAC.HSP.BadChars)
	if Found then
		PW_REJECT(
			"BadStrings="..IDX,
			Format(HAC.Msg.PW_BadChar, IDX)
		)
	end
	
	//Unicode char
	local Found,IDX,det = user:ToBytes():InTable(HAC.UTF.UniChars, true)
	if Found then
		PW_REJECT(
			"UniChar="..det.." ("..IDX..")",
			Format(HAC.Msg.PW_UniChar, det)
		)
	end
	
	//Bad name, fake HeX
	local Low = user:lower()
	local Found,IDX,det = Low:InTable(HAC.Auth.SK_Fake)
	if Found and ( sid != "STEAM_0:0:17809124" and sid != "STEAM_0:1:7099" ) then
		PW_REJECT(
			"PW_FAKE="..det,
			HAC.Msg.PW_BadName
		)
	end
	
	//Short name, < 2 chars
	if #user < 2 then
		PW_REJECT(
			"ShortName="..#user,
			HAC.Msg.PW_Short
		)
	end
	//Long name, > 35 chars
	if #user > 35 then
		PW_REJECT(
			"LongName="..#user,
			HAC.Msg.PW_Long
		)
	end
	
	//Skid name - starts with, no tags
	local Found,IDX,det = Low:VerySafe():CheckInTable(HAC.Auth.SK_StartWith)
	if Found then
		//Ban SID
		if not HAC.NeverSend[ sid ] then
			HAC.NeverSend[ sid ] = {"PW_StartWith="..det.." ("..user..")", HAC.Fake.Is12}
		end
		//Ban IP
		if not HAC.NeverSendIP[ ThisIP ] then
			HAC.NeverSendIP[ ThisIP ] = {"PW_StartWith="..det.." ("..user..")", HAC.Fake.Is12}
		end
		
		PW_REJECT(
			"PW_StartWith="..det,
			HAC.Fake.Is12
		)
	end
	--[[
	//Language exploit thing
	if Low:Check("#") then
		PW_REJECT(
			"LangExploit='#'",
			HAC.Msg.PW_LangName
		)
	end
	]]
	//Dupe
	for k,v in Humans() do
		if v:SteamID() == sid then continue end
		
		local This = v:Nick():lower()
		if Low == This then
			PW_REJECT(
				"DupeOf="..This,
				HAC.Msg.PW_BadName
			)
		end
	end
	
	//Too many per IP
	local Count = HAC.Auth.IPClients[ ipaddr ]
	if Count and Count >= HAC.Auth.MaxPerIP then
		PW_REJECT(
			"MaxPerIP("..Count.." > "..HAC.Auth.MaxPerIP..")",
			HAC.Msg.PW_TooMany
		)
	end
	
	
	
	
	
	//Block if Rejected
	if PW_REASON then
		//Log
		if NeverJoin then
			Buff = Buff..Format("\nRes:\n<\n%s\n>\n\n", PW_REASON)
		else
			Buff = Buff.."\n\n"
		end
		
		//Log kicks
		HAC.file.Append("hac_reasons.txt", 	Buff)
		
		//PWAuth temp
		HAC.file.Append("hac_pwauth.txt", 	Buff)
		
		//Tell, even if no kick
		HAC.TellHeX(
			user.." ("..sid..") "..(NeverJoin and "BLOCKED" or "! ALLOW !").." -> "..PW_REASON,
			NOTIFY_ERROR, 10, (NeverJoin and "vo/coast/odessa/nlo_cub_thatsthat.wav" or "vo/coast/odessa/nlo_cub_hello.wav")
		)
		
		//Global?
		if PW_DO_GLOBAL and NeverJoin and not Silent then
			//Msg only once per ID
			HAC.Auth.MsgLog[ sid ] = HAC.Auth.MsgLog[ sid ] or 0 + 1
			if HAC.Auth.MsgLog[ sid ] < 3 then
				//Sound, no HeX
				for k,v in Everyone() do
					if not v:HAC_IsHeX() then
						v:HAC_SPS("vo/coast/odessa/nlo_cub_thatsthat.wav")
					end
				end
				
				//Msg
				HAC.CAT(
					HAC.RED, "[", HAC.GREEN,"HAC", HAC.RED,"] ",
					HAC.PINK, user:Safe():Left(28),
					HAC.SGREY, " (",
					HAC.GREEN2, sid,
					HAC.SGREY, ") tried to join, but is ",
					HSP.RED, "BANNED FOR CHEATING"
				)
				//If SK, tell
				if Reason then
					HAC.CAT(
						HAC.RED, "[", HAC.GREEN,"HAC", HAC.RED,"] ",
						HAC.GREY, "<",
						HAC.RED, PW_REASON,
						HAC.GREY, ">"
					)
				end
			end
		end
	end
	
	//Log all
	HAC.file.Append("hac_auth_log.txt", Buff)
	HAC.Print2HeX(Buff)
	
	//Kick
	if PW_REASON and NeverJoin then
		return false, PW_REASON
	end
	
	
	//On SK, not blocked
	if Reason then
		//Light ON
		HAC.Box.DynamicLight(true, 60)
		HAC.Auth.LightLog[ sid ] = Reason
		
		//Log
		HAC.file.Append("sk_light.txt", "\nLight on @ "..HAC.Date()..", for "..user.." ("..sid..") >\n"..Reason.."\n")
		
		//Tell HeX, here come the hacks
		timer.Simple(1.8, function()
			HAC.Print2HeX(Reason, true, "vo/npc/male01/herecomehacks0"..math.random(1,2)..".wav")
		end)
	end
end
hook.Add("CheckPassword", "HAC.Auth.CheckPassword", HAC.Auth.CheckPassword)

//Log
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
	//Light OFF
	local sid = data.networkid
	if HAC.Auth.LightLog[ sid ] then
		HAC.Auth.LightLog[ sid ] = nil
		
		//Off
		HAC.Box.DynamicLight(false)
		
		//Log
		HAC.file.Append("sk_light.txt", "\nLight OFF @ "..HAC.Date()..", for "..sid.."\n")
	end
	
	
	//Too many per IP
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




//Spawn - troll names
local Break = {
	[5] 	= "New",
	[7]		= "Cheater",
	[9]		= "Regular",
	[10] 	= "PREVIOUS CHEATER",
	[29] 	= "Known CHEATER",
}
function HAC.Auth.Spawn(self)
	self:timer(2, function()
		if FSA and not Break[ self:GetLevel() ] then return end
		
		local Found,IDX,det = self:Nick():lower():InTable(HAC.Auth.SK_Any)
		if Found then
			self:WriteLog("! PW_ANY in 30s: '"..det.."'")
			
			self:timer(30, function()
				if not self:Banned() then
					self:SetLevel(22) --12 Year old
					
					self:EatKeysAllEx()
				end
			end)
		end
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.PWAuth.Spawn", HAC.Auth.Spawn)























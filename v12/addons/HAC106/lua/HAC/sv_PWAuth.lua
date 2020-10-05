
include("hac/sv_SethBlock.lua")

HAC.PWFailMessages = {
	"Damnit, that's not what I was looking for",
	"Burst me bagpipes!",
	"Shootin' blanks every time, all the time!",
	"Network error 482. Somebody shot the server with a 12 Gauge",
	"This is the face I make every Sunday night. Even when my toners not low",
	"Great on toast, better on the floor!",
	"Donuts and hot dogs are flying everywhere!",
	"Just think of trains, trucks and problems at work",
	"Hired a construction crew, 'cause it's hell on the engine",
	"Please stop petting the tigers and drinking the gasoline!",
	"He ho-ho-ho'd, then shot his load!",
	"Garrysmod update breaks game, millions dead",
	"If at first you don't succeed, you lose! good day sir!",
}

HAC.BadCharMessage	= "Connection failed, your name contains a "


function HAC.CheckPassword(user,pass,sid,ipaddr)
	if not user then user	= "Gone" end
	if not sid then sid		= "STEAM_0:0:13371337" end
	
	local SVPassword		= GetConVarString("sv_password") or ""
	local Bad,What	 		= HAC.StringInTable(user, HAC.BadStrings)
	local BadName,WhatName	= HAC.StringInTable(user, HAC.BadNames)
	local DoBlock, Text		= HAC.ShouldBlock(user,pass,sid,ipaddr)
	
	if DoBlock then
		HAC.PWAuthLog(user,sid,ipaddr,"SethBlock","Dropped")
		return {false, Text}
	end
	
	if HAC.Debug or pass == HAC.SecretPass then
		if HAC.Debug then --No message if secret!
			print("! PWAuth: ",user,pass,sid,ipaddr)
		end
		return {true}
		
	elseif (user:find("HeX") and HAC.Devs[ sid ] != "HeX") then
		HAC.PWAuthLog(user,sid,ipaddr,"FakeHeX","Dropped")
		return {false, HAC.BadNameMessage}
		
	elseif BadName then
		HAC.PWAuthLog(user,sid,ipaddr,"BadName="..WhatName,"Dropped")
		return {false, HAC.BadNameMessage}
		
	elseif Bad then
		HAC.PWAuthLog(user,sid,ipaddr,"BadNameChar="..What,"Dropped")
		return {false, HAC.BadCharMessage.."'"..What.."' char"}
		
	elseif (ValidString(SVPassword) and pass != SVPassword) then
		HAC.PWAuthLog(user,sid,ipaddr,"FailedPassword",pass)
		return {false, table.Random(HAC.PWFailMessages).." | Try again"}
	end
	
	if HAC.ShouldLogJoins then
		HAC.PWAuthLog(user,sid,ipaddr,what,pass,true)
	end
	hook.Call("HACPasswordAuth", nil, user,pass,sid,ipaddr)
	
	--return true
end
hook.Add("PlayerPasswordAuth", "HAC.CheckPassword", HAC.CheckPassword)


function HAC.PWAuthLog(user,sid,ipaddr,what,pass,regular)
	local LogFile = "hac_pwauth.txt"
	if regular then
		pass	= "Connected"
		user	= user.." [#"..HAC.SteamKey(sid).."]"
		what	= "PWAuth"
		LogFile = "hac_auth_log.txt"
	end
	
	local WriteLog1 = Format("[HAC%s_U%s] [%s] - %s: %s (%s) <%s> - %s\n", HAC.Version, VERSION, HAC.Date(), what, user, sid, ipaddr, pass)
	local WriteLog2 = Format("[HAC] - %s: %s (%s) <%s> - %s\n", what, user, sid, ipaddr, pass)
	local ShortMSG	= Format("%s -> %s: %s", user, what, pass)
	
	if not file.Exists(LogFile) then
		file.Write(LogFile, "[HAC"..HAC.Version.."] / (GMod U"..VERSION..") Player auth log created at ["..HAC.Date().."]\n\n")
	end
	filex.Append(LogFile, WriteLog1)
	
	if not regular then
		HAC.TellAdmins(ShortMSG)
	end
	HAC.Print2Admins(WriteLog2)
end







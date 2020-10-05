

function HAC.CheckPassword(user,pass,sid,ipaddr)
	if not user then user	= "Gone" end
	if not sid then sid		= "STEAM_0:0:13371337" end
	
	local Bad,What	 		= user:InTable(HAC.BadStrings)
	local BadName,WhatName	= user:InTable(HAC.BadNames)
	
	
	if HAC.Banned[sid] then
		HAC.PWAuthLog(user,sid,ipaddr,"IsBanned","Dropped")
		return {false, HAC.BanMSG}
	end
	
	
	if ShouldBlock(sid) then
		HAC.PWAuthLog(user,sid,ipaddr,"SethBlock","Dropped")
		return {false, HAC.SERVER.BadServerMessage}
	end
	
	
	if (HAC.Debug or pass == HAC.SecretPass) then
		if HAC.Debug then --No message if secret!
			print("! PWAuth: ",user,pass,sid,ipaddr)
		end
		return {true}
		
	elseif (user:find("HeX") and HAC.Devs[ sid ] != "HeX") then
		HAC.PWAuthLog(user,sid,ipaddr,"FakeHeX","Dropped")
		return {false, HAC.Msg.BadName}
		
	elseif BadName then
		HAC.PWAuthLog(user,sid,ipaddr,"BadName="..WhatName,"Dropped")
		return {false, HAC.Msg.BadName}
		
	elseif Bad then
		HAC.PWAuthLog(user,sid,ipaddr,"BadNameChar="..What,"Dropped")
		return {false, HAC.Msg.BadChar.."'"..What.."' char"}
		
	elseif pass != GetConVarString("sv_password") then
		HAC.PWAuthLog(user,sid,ipaddr,"FailedPassword",pass)
		return {false, table.Random(HAC.SERVER.PWFailMessages).." | Try again"}
	end
	
	
	HAC.PWAuthLog(user,sid,ipaddr,what,pass,true)
end
hook.Add("PlayerPasswordAuth", "HAC.CheckPassword", HAC.CheckPassword)



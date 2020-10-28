


function HAC.SLOG_WhiteListCommands(tab)
	for k,cmd in pairs(tab) do
		cmd = cmd:lower()
		if not table.HasValue(HAC.SERVER.SLOG_WhiteList, cmd) then
			table.insert(HAC.SERVER.SLOG_WhiteList, cmd)
		end
	end
end


function Cmd_RecvCommand(Name, Buffer)
	local IsBlocked		= false
	local clean			= Buffer:Trim()
	local lower			= clean:lower()
	local ply			= NULL
	
	for k,v in ipairs(player.GetAll()) do
		if ValidEntity(v) and v:Name() == Name then
			ply = v
			break
		end
	end
	
	for k,v in pairs(HAC.SERVER.SLOG_WhiteList) do
		if lower:sub(1, v:len() ) == v:lower() then --Safe, don't log
			return
		end
	end
	for k,v in pairs(HAC.SERVER.SLOG_BlackList) do
		if lower == v or lower:find(v) != nil then --Bad command
			IsBlocked = true
			break
		end
	end
	
	
	if lower:find("lua_run_cl") and HAC.StringInTable(lower,HAC.SERVER.SLOG_KeyBlackList) then --Ancient "lua virus" crap
		IsBlocked = true
		
		if ValidEntity(ply)  then
			if not HAC.Silent:GetBool() then
				HACGANPLY(
					ply, "Disconnect, reset your keyboard options and run 'key_findbinding lua_run_cl' and rebind those keys!",
					NOTIFY_ERROR, 15, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav"
				)
				
				HACCATPLY(
					ply,
					HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
					HAC.WHITE, "You have a ", HAC.RED, "bad key bind! ",
					HAC.WHITE, "Disconnect, reset your keyboard options and run 'key_findbinding lua_run_cl' and rebind those keys"
				)
			end
		end
	end
	
	
	if ValidEntity(ply)  then
		if IsBlocked then
			--HAC.DoBan(ply, "SLOG", {"SLOG="..clean}, true)
			HAC.WriteLog(ply, clean, "SLOG")
		else
			if HAC.Devs[ ply:SteamID() ] then return IsBlocked end --Don't log bullshit!
			
			file.Append("commandlogs/"..ply:SID()..".txt", Format("[SLOG] [%s] %s (%s) Ran: %s\n", HAC.Date(), ply:Name(), ply:SteamID(), clean) )
		end
	end
	return IsBlocked
end







HAC.SLOG = {}

local Active = false

function HAC.SLOG.BuildWhitelist()
	for k,v in pairs( concommand.GetTable() ) do
		local Low = k:lower()
		
		if not table.HasValue(HAC.SERVER.SLOG_White_StartsWith, Low) then
			table.insert(HAC.SERVER.SLOG_White_StartsWith, Low)
		end
	end
	
	Active = true
end
timer.Simple(2, HAC.SLOG.BuildWhitelist)

local function PlayerFromSID(sid)
	for k,v in pairs( player.GetHumans() ) do
		if v:SteamID() == sid then
			return v
		end
	end
end

local function ExecuteStringCommand(cmd,sid)
	--file.Append("cmd2.txt", "\r\n"..cmd)
	if not Active then return end
	local Silent = HAC.Silent:GetBool()
	
	local DoneMsg		= false
	local ShouldBlock	= nil
	local Low 			= cmd:lower()
	
	//Safe, no log
	if HAC.SERVER.SLOG_White_Exact[ Low:Trim() ] or Low:CheckInTable(HAC.SERVER.SLOG_White_StartsWith) then return end
	if cmd:Check("spp_friend_STEAM_") then return end --SPP
	
	
	//Black, contains
	local ply = PlayerFromSID(sid)
	local Found,IDX,det = Low:InTable(HAC.SERVER.SLOG_Black_Contains)
	if Found then
		ShouldBlock = true
		
		if ply then
			//Log
			ply:WriteLog( Format("SLOG='%s' (%s)", cmd, det) )
			
			//CVarList
			ply:CVarList()
			
			//SC
			ply:TakeSC()
			
			//Warn
			if not Silent and not ply.HAC_DoneKeysAll then
				DoneMsg = true
				
				local SafeCmd = cmd:VerySafe():Trim():Left(64)
				ply:HACGAN("I wouldn't do that again. Command '"..SafeCmd.."' does not exist.",
					NOTIFY_UNDO, 20, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav"
				)
				
				ply:HACCAT(
					HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
					HAC.WHITE, "Command '",
					HAC.GREEN, SafeCmd,
					HAC.WHITE, "' does not exist. ",
					HAC.WHITE, "Everything is ",
					HAC.RED, "LOGGED ",
					HAC.WHITE, "You will be banned if you attempt to crash the server or run anything bad!"
				)
			end
		end
	end
	
	//Lua
	if Low:find("lua") then
		ShouldBlock = true
		
		local Crash = true
		if ply then
			//Lua virus crap
			if Low:InTable(HAC.SERVER.SLOG_KeyBlackList) and not Silent and not ply.HAC_DoneKeysAll and not DoneMsg then
				DoneMsg = true
				Crash 	= false
				
				ply:HACGAN("Disconnect, reset your keyboard options, run 'key_findbinding lua_' and rebind those keys!",
					NOTIFY_ERROR, 15, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav"
				)
				
				ply:HACCAT(
					HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
					HAC.WHITE, "You have a ", HAC.RED, "bad key bind! ",
					HAC.WHITE, "Disconnect, reset your keyboard options and run 'key_findbinding lua_' and rebind those keys"
				)
			end
			
			//Log
			ply:WriteLog( Format("SLOG_Lua='%s'", cmd) )
			
			//CVarList
			ply:CVarList()
			
			//SC
			ply:TakeSC()
			
			//Crash
			if Crash then
				timer.Simple(30, function()
					if IsValid(ply) then
						ply:HAC_Crash()
					end
				end)
			end
		end
	end
	
	
	//Log unknown
	if not ShouldBlock then
		if ply then
			//Log
			local Filename = Format("%s/slog_%s.txt", ply.HAC_Dir, ply:SID() )
			HAC.file.Append(Filename, Format("\n%s: %s Ran: '%s'", ply:DateAndTime(), ply:HAC_Info(), cmd) )
			
			//Tell
			HAC.Print2HeX( Format("[HAC] %s - SLOG=[[%s]]\n", ply:HAC_Info(), cmd) )
			HAC.TellHeX(ply.AntiHaxName.." -> SLOG=[["..cmd.."]]", NOTIFY_ERROR, 10, "npc/roller/code2.wav")
			
			//CVarList
			ply:CVarList()
			
			//SC
			ply:TakeSC()
			
			if not DoneMsg then
				cmd = cmd:VerySafe():Trim():Left(64)
				ply:HACGAN("Don't do that again. Command '"..cmd.."' does not exist.",
					NOTIFY_UNDO, 20, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav"
				)
				
				ply:HACCAT(
					HAC.RED,"[", HAC.GREEN,"HAC", HAC.RED,"] ",
					HAC.WHITE, "Command '",
					HAC.GREEN, cmd,
					HAC.WHITE, "' does not exist. ",
					HAC.WHITE, "Everything is ",
					HAC.RED, "LOGGED ",
					HAC.WHITE, "Don't run random commands. Check your binds if you have any."
				)
			end
		else
			//Log all
			HAC.file.Append("slog_no_ply.txt", Format("\n[%s] %s Ran: '%s'", HAC.Date(), sid, cmd) )
			
			//SC all
			for k,v in pairs( player.GetHumans() ) do
				v:TakeSC()
				v:CVarList()
			end
		end
	end
	
	return ShouldBlock
end
hook.Add("ExecuteStringCommand", "ExecuteStringCommand", ExecuteStringCommand)



function HAC.SLOG.AddHook(ply)
	if not slog2 or ply:IsBot() then return end
	
	local Done,err = slog2.Add( ply:EntIndex() ) --Needs a player, any player, to start the hook
	
	if err or not Done then
		ErrorNoHalt("Slog2, can't hook: "..tostring(err).."\n")
		return
	end
	
	hook.Remove("PlayerInitialSpawn", "HAC.SLOG.AddHook")
end
hook.Add("PlayerInitialSpawn", "HAC.SLOG.AddHook", HAC.SLOG.AddHook)




//Requested
hook.Add("FileRequested", "FileRequested", function(what,sid)
	what = tostring(what)
	if not (what:Check("user_custom/") and what:EndsWith(".dat")) then
		//Log
		HAC.file.Append("file_rq.txt", "\n"..sid.." - "..what)
		HAC.COLCON(HAC.RED, "[HAC] ", HAC.YELLOW, "FileRequested: ", HAC.RED, what.." ", HAC.BLUE, sid)
		
		//Ban
		local ply = PlayerFromSID(sid)
		if IsValid(ply) then
			ply:DoBan("FileRequested=[["..what.."]]")
		end
		return true
	end
end)

//Received
hook.Add("FileReceived", "FileReceived", function(what,sid)
	what = tostring(what)
	if not (what:Check("user_custom/") and what:EndsWith(".dat")) then
		//Log
		HAC.file.Append("file_rx.txt", "\n"..sid.." - "..what)
		HAC.COLCON(HAC.RED, "[HAC] ", HAC.YELLOW, "FileReceived: ", HAC.RED, what.." ", HAC.BLUE, sid)
		
		//Rename
		timer.Simple(1, function()
			if file.Exists("download/"..what, "MOD") then
				local Cont = file.Read("download/"..what, "MOD")
				if not ValidString(Cont) then Cont = "Gone" end
				
				//Delete
				if not (what:find("..",nil,true) or what:find(":",nil,true)) then
					hac.Delete(HAC.ModDir.."/download/"..what)
				end
				
				//Ban
				local ply = PlayerFromSID(sid)
				local CRC = util.CRC(Cont)
				local Filename = "frx_"..CRC..".txt"
				if IsValid(ply) then
					ply:DoBan("FileReceived=[["..what.."]] == ("..CRC..")")
					
					HAC.file.Append(ply.HAC_Dir.."/frx/frx_log.txt", "\n"..what.." - "..CRC)
					Filename = ply.HAC_Dir.."/frx/"..Filename
				end
				
				//Write
				if not file.Exists(Filename, "DATA") then
					HAC.file.Write(Filename, Cont, "wb")
				end
			end
		end)
	end
end)



//Pressing useless binds
function HAC.SLOG.Dumb(ply,cmd,args)
	if not IsValid(ply) then return end
	
	ply:SetHealth(1)
	ply:ChatPrint("'"..cmd:lower().."' Isn't a valid command!")
end

for k,v in pairs(HAC.SERVER.SLOG_DumbList) do
	concommand.Add(v, HAC.SLOG.Dumb)
end































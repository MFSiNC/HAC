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



local function FromSteamID(sid)
	for k,v in Humans() do
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
	if cmd:Check("spp_friend_STEAM_") or cmd:Check("host_writeconfig") then return end --SPP, old EatKeys
	
	
	//Black, contains
	local ply = FromSteamID(sid)
	local Found,IDX,det = Low:InTable(HAC.SERVER.SLOG_Black_Contains)
	if Found then
		ShouldBlock = true
		
		if ply and not ply:HAC_IsHeX() then
			//Log
			ply:WriteLog( Format("SLOG='%s' (%s)", cmd, det) )
			
			//CVarList
			--ply:CVarList() --Fucked 01.06
			
			//SC
			ply:TakeSC()
			
			//Warn
			if not Silent and not ply.HAC_DoneKeysAll and not ply:Banned() then
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
		
		if ply and not ply:HAC_IsHeX() then
			//Lua virus crap
			local Crash = true
			if Low:InTable(HAC.SERVER.SLOG_KeyBlackList) and not Silent and not ply.HAC_DoneKeysAll and not DoneMsg and not ply:Banned() then
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
			--ply:CVarList() --Fucked 01.06
			
			//SC
			ply:TakeSC()
			
			//Crash
			if Crash then
				ply:timer(30, function()
					ply:HAC_Crash()
				end)
			end
		end
	end
	
	
	//Log unknown
	if not ShouldBlock then
		if ply then
			if not ply:HAC_IsHeX() then
				//Log
				ply:Write("slog", Format("\n%s: %s Ran: '%s'", ply:DateAndTime(), ply:HAC_Info(), cmd) )
				
				//Tell
				HAC.Print2HeX( Format("[HAC] %s - SLOG=[[%s]]\n", ply:HAC_Info(), cmd) )
				HAC.TellHeX(ply.AntiHaxName.." -> SLOG=[["..cmd.."]]", NOTIFY_ERROR, 10, "npc/roller/code2.wav")
				
				//CVarList
				--ply:CVarList() --Fucked 01.06
				
				//SC
				ply:TakeSC()
				
				if not DoneMsg and not ply:Banned() then
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
			end
		else
			//Log all
			HAC.file.Append("slog_no_ply.txt", Format("\n[%s] %s Ran: '%s'", HAC.Date(), sid, cmd) )
			
			//SC all
			for k,v in Humans() do
				v:TakeSC()
				--v:CVarList() --Fucked 01.06
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
		debug.ErrorNoHalt("Slog2, can't hook: "..tostring(err) )
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
		local self = FromSteamID(sid)
		if IsValid(self) then
			self:DoBan("FileRequested=[["..what.."]]")
			
			self:HAC_EmitSound("uhdm/hac/tsp_file_request.mp3", "FileRequested")
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
				if not ( what:hFind("..") or what:hFind(":") ) then
					hac.Delete(HAC.ModDir.."/download/"..what)
				end
				
				//Ban
				local CRC = util.CRC(Cont)
				local Filename = "frx_"..CRC..".txt"
				local self = FromSteamID(sid)
				if IsValid(self) then
					Filename = self.HAC_Dir.."/frx/"..Filename
					
					self:Write("frx/frx_log", "\n[["..what.."]] - "..CRC)
					self:DoBan("FileReceived=[["..what.."]] - ("..CRC..")")
					
					self:HAC_EmitSound("uhdm/hac/cave_upload.mp3", "FileReceived")
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































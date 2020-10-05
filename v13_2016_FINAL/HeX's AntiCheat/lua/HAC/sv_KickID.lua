
if not sourcenetinfo then return end

--hac.Command('alias kickid ""')

local function NewKickID(ply,cmd,args,str)
	if not ply:IsAdmin() then
		ply:print("[HAC] Not admin")
		return
	end
	if #args == 0 then
		ply:print("[HAC] No UserID")
		return
	end
	
	
	local UID = tonumber( args[1] )
	if not UID then
		ply:print("[HAC] No UID")
		return
	end
	
	local Chan = sourcenetinfo.GetNetChannel(UID)
	if not Chan then
		ply:print("[HAC] Can't get INetChannel for: "..UID)
		return
	end
	
	local Res = str:gsub(args[1], "")
	if Res == "" then Res = "Kicked by server" end
	
	Chan:Shutdown(Res)
end
concommand.Add("kickid2", NewKickID)
concommand.Add("kickid3", NewKickID)



--[[
require("kickid")

local function KI_AddHook(ply)
	if ply:IsBot() then return end
	
	local Done,err = kickid.Add( ply:EntIndex() ) --Needs a player, any player, to start the hook
	
	if err or not Done then
		ErrorNoHalt("kickid, can't hook: "..tostring(err).."\n")
		return
	end
	
	hook.Remove("PlayerInitialSpawn", "KI_AddHook")
end
hook.Add("PlayerInitialSpawn", "KI_AddHook", KI_AddHook)



local function KI_BlockDisconnect(SID,Res)
	MsgC(Color(255,255,0), SID.." > '"..Res.."'\n")
	
	local Block = false
	local Cheat = false
	
	if Res:find("globally banned for cheating") then
		Block = true
		Cheat = true
		
		Res = Res:Replace('"globally banned for cheating (', "")
		Res = Res:sub(0,-3)
		
	elseif Res:find("cheating previously") then
		Block = true
		Cheat = true
		
	elseif Res == "Client timed out" then
		Block = true
	end
	
	
	if Block then
		local ply = nil
		for k,v in Humans() do
			if v:SteamID() == SID then
				ply = v
				break
			end
		end
		
		if Cheat then
			MsgC(Color(255,0,0), SID.." > '"..Res.."' - ALLOWED\n")
			
			if not HAC.Skiddies[ SID ] then
				file.Append("kickid.txt",
					Format('\t["%s"] = "GAC: %s", --%s\r\n', SID,Res, (ply and ply:Nick() or SID) )
				)
			end
		else
			MsgC(Color(255,0,255), SID.." > '"..Res.."' - ALLOWED\n")
		end
		
		return true
	end
end
hook.Add("BlockDisconnect", "KI_BlockDisconnect", KI_BlockDisconnect)
]]





















if not (package.loaded.rcon) then return end


local function PlayerFromIP(ipaddr)
	local ply = NULL
	for k,v in ipairs(player.GetAll()) do
		if IsValid(v) and HAC.StringInBase(ipaddr, v:IPAddress()) then
			ply = v
			break
		end
	end
	return ply
end


local TimerDone1 = false
local TimerDone2 = false

function HAC.BlockRCONCommands(id,request,str,ipaddr,port)
	if not (request == 2) then return end --Command
	if ipaddr:find("192.168.0") then return end --LAN IP
	
	local blocked = false
	local ply = PlayerFromIP(ipaddr)
	
	for k,v in ipairs(HAC.RCONCommandsToBlock) do --not bad enough for a 5 min ban, just dont pass to engine
		if (string.Left(str, string.len(v)) == v) then
			timer.Simple(0.5, function()
				if not TimerDone1 then
					TimerDone1 = true
					
					if (ply:IsValid()) then
						HAC.LogFailedRCON(ply:Nick(), HAC.SafeString(str))
					else
						HAC.LogFailedRCON(ipaddr, HAC.SafeString(str))
					end
					return false
				end
			end)
			timer.Simple(1, function()
				TimerDone1 = false
			end)
			return false
		end
	end
	for k,v in ipairs(HAC.RCONCommandsToBan) do --banbanban
		if (string.Left(str, string.len(v)) == v) then
			blocked = true
			break
		end
	end
	
	if (blocked) then
		if (ply:IsValid()) then
			timer.Simple(0.5, function() --fucking timer!
				if not TimerDone2 then
					TimerDone2 = true
					HAC.DoBan(ply,"RCON",{"RCON="..HAC.SafeString(str) },false,5)
					return false
				end
			end)
			timer.Simple(1, function()
				TimerDone2 = false
			end)
		else
			HAC.LogFailedRCON(ipaddr, HAC.SafeString(str))
			return false
		end
		return false
	end
	
	HAC.LogAllRCON(ply,ipaddr,HAC.SafeString(str))
end
hook.Add("RCON_WriteDataRequest", "HAC.BlockRCONCommands", HAC.BlockRCONCommands)


function HAC.LogAllRCON(ply,ipaddr,str)
	local WriteLog1 = Format("[HAC%s_U%s] [%s] - RCON: %s (%s) - %s\n", HAC.Version, VERSION, os.date("%d-%m-%y %I:%M:%S%p"), ply:Nick(), ipaddr, str)
	
	if not file.Exists("hac_rcon_log.txt") then
		file.Write("hac_rcon_log.txt", "[HAC"..HAC.Version.."] / (GMod U"..VERSION..") RCON log created at ["..os.date("%d-%m-%y %I:%M:%S%p").."]\n\n")
	end
	filex.Append("hac_rcon_log.txt", WriteLog1)
end

function HAC.LogFailedRCON(ipaddr,str)
	if not (ipaddr and str) then return end
	
	local WriteLog1 = Format("[HAC%s_U%s] [%s] - BlockedRCON: %s - %s\n", HAC.Version, VERSION, os.date("%d-%m-%y %I:%M:%S%p"), ipaddr, str)
	local WriteLog2 = Format("[HAC%s] - BlockedRCON: %s - %s\n", HAC.Version, ipaddr, str)
	local ShortMSG = Format("%s -> BlockedRCON: %s", ipaddr, str)
	
	if not file.Exists("hac_bad_rcon_log.txt") then
		file.Write("hac_bad_rcon_log.txt", "[HAC"..HAC.Version.."] / (GMod U"..VERSION..") Blocked RCON log created at ["..os.date("%d-%m-%y %I:%M:%S%p").."]\n\n")
	end
	filex.Append("hac_bad_rcon_log.txt", WriteLog1)
	HAC.Print2Admins(WriteLog2)
	
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() then
			HACGANPLY(v, ShortMSG, NOTIFY_ERROR, 8, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav") --4 explode 1 warning
		end
	end
end



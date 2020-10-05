--[[
	=== Simple Hack detector ===
	By HeX
]]

SHD = {}

function SHD.Kick(ply,what,bad)
	if bad then
		hook.Call("PlayerHasCheats", nil, ply, what)
	else
		local str = Format("[SHD] [%s] - BadInit: %s (%s) <%s> - %s\n", os.date(), ply:Nick(), ply:SteamID(), ply:IPAddress(), what)
		file.Append("shd_initlog.txt", str)
		Msg(str)
		
		ply:Kick("Timeout error, try again (it's ok it happens)")
	end
end


function SHD.ConCommand(ply,cmd,args)
	if #args != 1 then --Fucking with stuff they shouldn't
		SHD.Kick(ply, "BadArgs")
		return
	end
	
	ply.SHDInit = true
	
	local AllowCL = tostring( args[1] )
	local AllowSV = GetConVarString("sv_allowcslua")
	
	if AllowCL != AllowSV then
		SHD.Kick(ply, Format("AllowCL(%s) != AllowSV(%s)", AllowCL, AllowSV), true)
	end
end
concommand.Add("shd_by_hex", SHD.ConCommand)


function SHD.Spawn(ply)
	ply.SHDInit = false
	
	timer.Simple(40, function()
		if IsValid(ply) and not ply.SHDInit and not ply:IsBot() then --Failed to send
			SHD.Kick(ply,"NoInit")
		end
	end)
end
hook.Add("PlayerInitialSpawn", "SHD.Spawn", SHD.Spawn)


function SHD.SetAllowCSLua() --Idiots
	game.ConsoleCommand("sv_allowcslua 0\n")
end
timer.Simple(2, SHD.SetAllowCSLua)


print("[SHD] Loaded!")











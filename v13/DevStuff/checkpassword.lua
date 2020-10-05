

local lol = "%#lol"

print( lol:find("%", nil,true) )


--[[


--! sid, ipaddr. sv_pass, pass, user: 	76561198107791680	86.183.92.36:27005			#ServerBrowser_OfflineMode

hook.Add("CheckPassword", "CustomBannedMessage", function(sid, ipaddr, sv_pass, pass, user)
	print("! sid, ipaddr. sv_pass, pass, user: ", sid, ipaddr, sv_pass, pass, user)
end)


]]



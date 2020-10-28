

local Useless = {
	"lua/entities/",
	"lua/effects/",
	"lua/weapons/",
	"lua/Weapons/",
	"lua/weapons_old/",
	"lua/weaponsold/",
	"lua/includes/gamemode/",
	"lua/includes/gamemodes/",
	"lua/gamemodes/",
	"lua/includes/lua/effects/",
	"lua/includes/lua/entities/",
	"lua/includes/lua/weapons/",
	"lua/wire/",
	"lua/autorun/server/AdvDupe",
	"lua/autorun/shared/dupeshare",
	"lua/slvbase_init/",
	"lua/hlr_init/",
	"lua/playx/",
	"lua/pcmod/",
	"lua/weaponsold/weapon_/",
	"lua/stargate/",
	"lua/achievements/",
	"lua/CAF/Addons/",
	"lua/SPM/Commands/",
	"lua/SPM/Plugins/",
	"lua/rd2/stools/",
	"lua/exsto/plugins/",
	"lua/AVehicles/",
	"lua/includes/entities/",
	"lua/app_framework/controls/",
	"lua/includes/weapons/",
	"lua/lua/entities/",
	"lua/lua/weapons/",
	"lua/chatsounds/lists_nosend/",
	"lua/chatsounds/lists_send/",
	"lua/PewPewBullets/",
	"lua/PewPewPlugins/",
	"lua/autorun/entities/",
	"lua/autorun/weapons/",
	"lua/autorun/server/",
	"lua/lua/autorun/server/",
}


local NotFO			= file.Open
local NotFID		= file.IsDir
local NotFF			= file.Find

local NotTS			= timer.Simple
local NotCRC		= util.CRC
local NotTIS		= table.insert
local NotJST		= util.TableToJSON
local Format		= string.format
local tostring		= tostring
local type			= type
local pcall			= pcall
local pairs			= pairs
local SysTime		= SysTime
local _G			= _G
local NotINC		= include
local NotRCC		= RunConsoleCommand


local function NotTHV(tab,val)
	val = val:lower()
	for k,v in pairs(tab) do
		if v:lower() == val then return true end
	end
	return false
end
local function StartsWith(str,check)
	return str:sub(1,#check) == check
end
local function EndsWith(str,ends)
   return ends == "" or str:sub(-#ends) == ends
end
local function IsUselessDir(v)
	for k,That in pairs(Useless) do
		if StartsWith(v,That) then
			return true
		end
	end
	
	if StartsWith(v,"addons/") then
		if v:find("/lua/effects/", nil,true) and EndsWith(v,"/init.lua") then return true end
		if v:find("/lua/weapons/gmod_tool/stools/", nil,true) then return true end
		
		if v:find("/lua/weapons/", nil,true) or v:find("/lua/entities/", nil,true) and
			(EndsWith(v, "/shared.lua") or EndsWith(v, "/init.lua") or EndsWith(v, "/cl_init.lua")) then return true
		end
	end
	
	return false
end








local FAlwaysBad = {
	[".."] 		= true,
	["..."]		= true,
	[".svn"]	= true,
}

local FAlwyasGood = {
	lua		= true,
	lua2	= true,
	bak		= true,
	txt		= true,
	old		= true,
}
local FAlwyasGoodAddons = {
	lua		= true,
	lua2	= true,
	bak		= true,
	old		= true,
}

local function FMerge(with,what)
	for k,v in pairs(with) do
		NotTIS(what,v)
	end
end


local function FindAllIn(dir,Good)
	local tab = {}
	
	local function LoadFromBuffer(dir,tab,Good,Bad)
		local files,fold = NotFF(dir.."/*", "MOD")
		if fold then
			FMerge(fold, files)
		end
		
		if not files then files = {} end
		if not Good then Good = FAlwyasGood end
		if not Bad then Bad = {} end
		
		FMerge(Bad, FAlwaysBad)
		
		for k,what in pairs(files) do
			local ext	= what:Right(3)
			local Here	= dir.."/"..what
			
			if not Good[ext] or NotFID(what, "MOD") then
				LoadFromBuffer(Here, tab, Good, Bad)
				
			elseif Good[ext] and not Bad[ext] then
				if not NotTHV(tab, Here) and not IsUselessDir(Here) then
					NotTIS(tab, Here)
				end
			end
		end
	end
	
	LoadFromBuffer(dir,tab,Good,Bad)
	
	return tab
end


local Now = SysTime()


local ToSend = FindAllIn("lua")
local Addons = FindAllIn("addons", FAlwyasGoodAddons)

FMerge(Addons,ToSend)


print("! DoCheck ", #ToSend, " took : ", -math.Round(Now - SysTime()).." seconds" )

PrintTableFile(ToSend)


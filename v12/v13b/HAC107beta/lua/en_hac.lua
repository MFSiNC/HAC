--[[
	=== HeX's AntiCheat ===
	"A good attempt at something impossible"
	
	If you can read this, stop snooping in my datapack.
	This is only in use on the [United|Hosts] GMod server, if you want to play there,
	disconnect and return with no cheats.
	
	If you actually *did* find this, add me on steam (http://steamcommunity.com/id/MFSiNC)
	Got any ideas how to make this better? something i should add? new cheats etc?
	
	Inb4 "clientside AC == shit", it's banned over 800 players to date, see the full totals here:
	http://dl.dropbox.com/u/3455978/garrysmod/data/hac_total.txt
	
	I am leaving. You are about to explode.
	
	Dear Script Bandit:
		How low can you go.
	:(
]]

HACInstalled	   = 1
HACCredits		   = [[
	Creator        = HeX
	Ideas/Testing  = Discord/Henry00/Sykranos/C0BRA/G-Force/TGiFallen
	Mac Testing    = Blackwolf
	Made for       = [United|Hosts] Deathmatch
]]

--[[
	=== End credits ===
	If you read below this line, you're gay!
]]

if not (CLIENT) then return end

local DEBUG			= false --false
local Silent		= false --false

local MSGHook		= "hac_unitedhosts_banme"
local DL_PATH		= ""
local EVERYTIME		= 75
local SPAWNTIME		= 10
local RCLTime		= 12

local NotDGE		= debug.getinfo
local NotDGMT		= debug.getmetatable
local NotINC		= include
local NotRQ			= require
local NotCG			= collectgarbage
local type			= type
local tostring		= tostring
local tonumber		= tonumber
local Format		= Format


local function Useless() return end
debug.debug			= Useless
debug.getfenv 		= Useless
debug.gethook		= Useless
debug.getlocal		= Useless
debug.setmetatable	= Useless
debug.getregistry	= Useless
debug.setfenv		= Useless
debug.setlocal 		= Useless
debug.setupvalue	= Useless


local Lists			= {
	White_NNRIgnore		= {},
	White_NNRWeapons	= {},
	White_Package		= {},
	White_GSafe			= {},
	White_GUseless		= {},
	White_CFuncs		= {},
	White_CVTab			= {},
	
	Black_RQTab			= {},
	Black_RPF			= {},
	Black_CLDB			= {},
	Black_CVars			= {},
	Black_RCC			= {},
	Black_RCCTab		= {},
	Black_LuaFiles		= {},
	Black_DataFiles		= {},
	Black_RootFiles		= {},
	Black_Megaloop		= {},
	Black_Hooks			= {},
	Black_Timers		= {},
	Black_NoHW			= {},
}


local function Merge(tab)
	for k,v in pairs(tab) do
		Lists[k] = v
	end
	tab = nil
end


_G.WLists		= nil
NotINC("lists/cl_w_hac.lua")
Merge(_G.WLists)
_G.WLists		= nil

_G.BLists		= nil
NotINC("lists/cl_b_hac.lua")
Merge(_G.BLists)
_G.BLists		= nil


if DEBUG then
	SPAWNTIME	= 3
	EVERYTIME	= 4
	RCLTime		= 3
	
	print("\n! DEBUG: loaded here\n\n")
end


local GCount,RCount,PLCount	= 0,0,0
local PLTable				= {}
local CGCount				= NotCG("count")

for k,v in pairs(_G) do GCount = GCount + 1 end
for k,v in pairs(_R) do RCount = RCount + 1 end

for k,v in pairs(package.loaded) do
	PLCount = PLCount + 1
	table.insert(PLTable, k)
end

local HCCMD			= (hook or concommand)
local PLCC			= (package.loaded.concommand)
local PLHK			= (package.loaded.hook)
local PLTS			= (package.loaded.timer)
local PLCV			= (package.loaded.cvars)
local DGMT			= (NotDGMT(_G) != nil)
local GGMT			= (getmetatable(_G) != nil)


for k,v in pairs(Lists.Black_RQTab) do
	if (NotRQ(k) != nil) then
		Lists.Black_RQTab[k] = true
	end
end


local function GIsUseless(str)
	for k,v in pairs(Lists.White_GUseless) do
		if string.sub(str,1,#v) == v then
			return true
		end
	end
	return false
end
local function FPath(func)
	local What = type(func)
	if (What != "function") then return What,0 end
	local DGI = NotDGE(func)
	if not DGI then return "Gone",0 end
	
	local Path = (DGI.short_src or What):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end

local BadGlobals = {}
for k,v in pairs(_G) do --From Garry with love
	local idx	= tostring(k)
	local vdx	= tostring(v)
	local KType = type(k)
	local VType = type(v)
	
	if (KType == "string") then
		if (VType == "table") then
			if (_G[idx] != nil) then
				
				for x,y in pairs( _G[idx] ) do
					local SubX	= tostring(x)
					local SubY	= tostring(y)
					local YType = type(y)
					
					local Ret = "_G."..idx.."."..SubX
					
					if not GIsUseless(Ret) then
						if (YType == "function") then
							local Path,Line = FPath(y)
							Ret = Ret..Format("(FUNCTION) [%s:%s]", Path,Line) )
							
						elseif (YType == "table") then
							Ret = Ret.." (TABLE)"
							
						else
							Ret = Ret..Format("=[[%s]] (%s)", SubY,string.upper(YType) )
						end
						
						if not Lists.White_GSafe[ Ret ] then
							table.insert(BadGlobals, Ret)
						end
					end
				end
			end
			
		elseif (VType != "table") then
			local Path,Line = FPath(v)
			local Ret = Format("_G.%s (FUNCTION) [%s:%s]", idx, Path,Line)
			
			if (VType != "function") then
				Ret = Format("_G.%s=[[%s]] (%s)", idx,vdx,string.upper(VType) )
			end
			
			if not GIsUseless(Ret) and not Lists.White_GSafe[ Ret ] then
				table.insert(BadGlobals, Ret)
			end
		end
	end
end


_G.concommand	= {}
_G.hook			= {}
_G.timer		= {}

NotRQ("usermessage")
NotRQ("concommand")
NotRQ("hook")
NotRQ("timer")
NotRQ("cvars")

local NotUMH		= usermessage.Hook
local NotCCA		= concommand.Add
local NotHA			= hook.Add
local NotHR			= hook.Remove
local NotHGT		= hook.GetTable
local NotTS			= timer.Simple
local NotTC			= timer.Create
local NotTD			= timer.Destroy
local NotTIT		= timer.IsTimer
local NotCAC		= cvars.AddChangeCallback

local NotFR			= file.Read
local NotFXE		= file.Size
local NotFFIL		= file.FindInLua
local NotFF			= file.Find
local NotFD			= file.Delete
local NotFTF		= file.TFind

local NotRPF		= util.RelativePathToFull
local NotCRC		= util.CRC
local NotSQQ		= sql.Query
local NotGGM		= game.GetMap
local NotIKD		= input.IsKeyDown
local NotMR			= math.random
local NotRE			= rawequal
local NotRGT		= rawget
local NotRST		= rawset
local NotRSX		= RunStringEx

local NotRCC		= RunConsoleCommand
local NotCCC		= CreateClientConVar
local NotCCV		= CreateConVar
local NotGCV		= GetConVar
local NotGCS		= GetConVarString
local NotGCN 		= GetConVarNumber
local NotECC		= InjectConsoleCommand

local NotRIV		= _R["Entity"]["IsValid"]
local NotGBP		= _R["Entity"]["GetBonePosition"]
local NotACH		= _R["Entity"]["LookupAttachment"]
local NotSEA		= _R["Player"]["SetEyeAngles"]
local NotPCC		= _R["Player"]["ConCommand"]
local NotRS			= _R["bf_read"]["ReadString"]
local NotSVA		= _R["CUserCmd"]["SetViewAngles"]

local WhatDS		= "poopstream"
local WhatST		= "Str".."eam".."To".."Server" --Eat shit and die
NotRQ(WhatDS)
local NotSTS		= _G[WhatDS][WhatST]

local MyPath, MyLine = "Gone", 0
local HACKey		 = "Gone"


NotUMH("PlayerInitialSpawn", function(um)
	MSGHook = NotRS(um)
	DL_PATH	= NotRS(um)
	HACInstalled = HACInstalled + 1
end)

local function RandomChars()
	local len = NotMR(6,16)
	local rnd = ""
	
	for i = 1, len do
		local c = NotMR(65, 116)
		if c >= 91 and c <= 96 then c = c + 6 end
		rnd = rnd..string.char(c)
	end
	
	return rnd
end
local function NotIV(what)
	return what and what.IsValid and NotRIV(what)
end
local function NotGMG(what,other)
	if NotIV( LocalPlayer() ) then
		if other then
			NotRCC(MSGHook, what, tostring(other))
		else
			NotRCC(MSGHook, what)
		end
	end
end
_G["NotGMG"]		= NotGMG
_G["GlobalPoop"]	= NotGMG

NotCCV("sv_rphysicstime", 0, 16384)

local RCCAlreadyDone	= false
local PCCAlreadyDone	= false
local NNRAlreadyDone	= false

NotTC(RandomChars(), RCLTime, 0, function()
	RCCAlreadyDone		= false
	PCCAlreadyDone		= false
	NNRAlreadyDone		= false
end)


local function CRCLists(what)
	local str = NotGGM()
	
	local function BuildCRC(tab,done)
		done = done	or {}
		
		for k,v in pairs(tab) do
			local typ = type(v)
			
			if typ == "table" and not done[v] then
				done[v] = true
				str = str..tostring(k)
				
				BuildCRC(v,done)
			elseif typ == "string" then
				str = str..tostring(v)
			end
		end
	end
	BuildCRC(what)
	
	str = #str..str..#str
	return NotCRC(str)
end
HACKey = CRCLists(Lists)


local function IsNotC(func)
	return (NotDGE(func).what != "C")
end
local function ValidString(v)
	return (type(v) == "string" and v != "")
end
local function Safe(str,maxlen)
	if not str then return end
	str = tostring(str)
	str = str:Trim()
	str = str:gsub("[:/\\\"*%@?<>'#]", "_")
	str = str:gsub("[]([)]", "")
	str = str:gsub("[\n\r]", "")
	str = str:gsub(string.char(7), "BEL")
	str = str:Trim( str:Left(maxlen or 25) )
	return str
end
local function MyCall(lev)
	local DGI = NotDGE(lev or 3)
	if not DGI then return "Gone", 0 end
	
	local Path = (DGI.short_src or "Gone"):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end
local function NotTHV(tab,val)
	for k,v in pairs(tab) do if (v == val) then return true end end
	return false
end
local function IsIn(str,base)
	base = tostring(base):lower()
	str	 = tostring(str):lower()
	return base:find(str)
end
local function Size(where)
	local size = NotFXE(where)
	if (size == -1) then
		return 0
	else
		return size
	end
end
local function Download(str)
	local http = HTTPGet()
		http:Download(str,"")
		debug.sethook()
		repeat until http:Finished()
	return http:GetBuffer()
end
local function ExecDownload(str,DLonly)
	local Full = DL_PATH..str
	local Code = Download(Full) or false
	if not Code then return false end
	
	if DLonly then return Code end
	NotRSX(Code,str)
end
local function NotREX(path)
	local tmp = NotRPF(path)
	return (tmp != path), tmp
end
local function GetCRC()
	local wut = NotGGM()
	local map = tostring(#wut*2)
	return map..map..map..wut:Left(1):upper()
end
local function SQLStr(str)
    str = tostring(str)
    if str:find('\\"') then return end
    str = str:gsub('"', '\\"')
	
    return "\""..str.."\""
end
local function NotQTE(name)
    local r = NotSQQ("select name FROM sqlite_master WHERE name="..SQLStr(name).." AND type='table'")
    if (r) then return true end
    return false
end



_G.coroutine = {
	create		= Useless,
	resume		= Useless,
}
concommand.GetTable = function()
	return {}
end

_G.BootyBucket = nil
NotINC("en_streamhks.lua")
local NotBucket = _G.BootyBucket

local UselessSpam		= {}
local LuaUselessSpam	= {}
local UselessLoaded		= false
local function NotSoUseless(what,send,lua,typ)
	local path,line = MyCall(4)
	local str = Format("NotSoUseless=%s [%s:%s]", what, path,line)
	
	if send and ValidString(lua) and not str:find("faphack") and not LuaUselessSpam[lua] then
		LuaUselessSpam[lua] = true
		
		NotTS(2, function()
			NotBucket(lua,typ)
		end)
	end
	
	if not UselessSpam[str] then --Only do it once!
		UselessSpam[str] = true
		
		if UselessLoaded then
			NotGMG(str)
		end
	end
end
CompileString	= function(s,f)	NotSoUseless("CompileString", true, s, "CS") 								end
Compilestring	= function(s,f)	NotSoUseless("Compilestring", true, s, "Cs")								end
CompileFile		= function(f)	NotSoUseless("CompileFile", true, file.Read("lua/"..f, true),"CF")			end
Compilefile		= function(f)	NotSoUseless("Compilefile", true, file.Read("lua/"..f, true),"Cf")			end
WFC111255 		= function()	NotSoUseless("WFC111255")													end
LoadString		= function(s)	NotSoUseless("LoadString", true, s, "LS")									end
loadstring		= function(s)	NotSoUseless("loadstring", true, s, "Ls")									end
setfenv			= function()	NotSoUseless("setfenv")														end
getfenv			= function()	NotSoUseless("getfenv")														end
RunString		= Useless
RunStringEx		= Useless
Runstring		= Useless


local function NewConCommand(ent,cmd,stuff)
	if ( Lists.Black_RCC[ string.lower(tostring(cmd)) ] ) then
		if not PCCAlreadyDone then
			PCCAlreadyDone = true
			
			NotGMG( Format("PCC=%s", cmd) )
		end
	end
	
	if not NotIV(ent) then return end
	return NotPCC(ent,cmd,stuff)
end
_R["Entity"]["ConCommand"] 	= NewConCommand
_R["Player"]["ConCommand"] 	= NewConCommand

local function NewRCC(...)
	local RCCArgs = {...}
	if ( Lists.Black_RCC[ string.lower(tostring(RCCArgs[1])) ] ) then
		if not RCCAlreadyDone then
			RCCAlreadyDone = true
			local path,line = MyCall()
			
			NotGMG( Format("RCC=%s [%s:%s]", RCCArgs[1], path,line) )
		end
	end
	
	NotRCC(...)
end
_G["RunConsoleCommand"] = NewRCC


local MySID = nil
NotTC(RandomChars(), 6, 0, function()
	local ply = LocalPlayer()
	
	if (ply:GetActiveWeapon() and NotIV( ply:GetActiveWeapon() )) then
		local Wep = ply:GetActiveWeapon()
		local KWC = Wep:GetClass():lower()
		
		if not Lists.White_NNRIgnore[KWC] and (Wep.Primary) then
			local RCL = tonumber(Wep.Primary.Recoil) or 1
			
			if (Lists.White_NNRWeapons[KWC] != RCL) then
				if not NNRAlreadyDone then
					NNRAlreadyDone = true
					NotGMG( Format("NoRecoil=%s-%s", KWC, RCL) )
				end
			end
		end
	end
	
	local SID = ply:SteamID()
	if not MySID then
		MySID = SID
	end
	
	if (MySID != SID) then
		NotGMG("SteamID="..SID)
		MySID = SID
	end
end)

local BadCLDB = {}
for k,v in pairs(Lists.Black_CLDB) do
	if NotQTE(v) then
		table.insert(BadCLDB, v)
	end
	
	local Gone = NotSQQ("DROP TABLE "..v)
	if Gone != false then
		table.insert(BadCLDB, "DROP="..v)
	end
end
for k,v in pairs(Lists.Black_NoHW) do
	NotCCC(v, 0, {16384})
	NotCAC(v, function(var,old,new)
		NotGMG("NoHW="..var..":Args=[["..Safe(new).."]]")
	end)
end


local function CModCheck(path,what,str,cmd,notlua) --CMod
	local SPath = path..what
	
	local Func = NotFFIL
	if notlua then
		Func = function(p) return NotFF(p,true) end
	end
	
	for k,v in pairs( Func(SPath) ) do
		NotTS(k / 10, function()
			local Fill = path..v
			
			if Func(Fill) and ValidString(v) then
				v = string.Trim(v,"/")
				v = string.Trim(v)
				
				NotRCC(cmd, str..v, 0, v)
			end
		end)
	end
end


NotTS(5, function()
	if (HCCMD)	then NotGMG("HCCMD")	end
	if (DGMT) 	then NotGMG("DGMT")		end
	if (GGMT) 	then NotGMG("GGMT")		end
	
	UselessLoaded = true
	for k,v in pairs(UselessSpam) do
		NotGMG(k)
	end	
	for k,v in pairs(BadCLDB) do
		NotGMG("CLDB="..v)
	end
	for k,v in pairs(BadGlobals) do
		NotTS(k/5, function()
			NotGMG("GCheck="..v)
		end)
	end
	
	if (MyPath != "Gone" or MyLine != 0) then
		NotGMG( Format("BHAC=[%s:%s]", MyPath, MyLine) )
	end
	if (RCLTime != 2) then
		NotGMG("PLCount", PLCount)
	end
	
	for k,v in pairs(Lists.Black_RQTab) do
		if (v != nil) then
			NotGMG("KR30="..string.upper(k) )
			Lists.Black_RQTab[k] = false
		end
	end
	
	if (PLCC) then
		PLCC = false
		NotGMG("KR30=PLCC")
	end
	if (PLCV) then
		PLCV = false
		NotGMG("KR30=PLCV")
	end
	if (PLHK) then
		PLHK = false
		NotGMG("KR30=PLHK")
	end
	if (PLTS) then
		PLTS = false
		NotGMG("KR30=PLTS")
	end
	

	CModCheck("includes/enum/",		"*.lua",	"ENMod=",	"gm_explodetheplayer")
	CModCheck("includes/modules/",	"*.dll",	"CMod=",	"gm_spawntheplayer")
	CModCheck("menu_plugins/",		"*.lua",	"MLMod=",	"gm_respawntheplayer")
	CModCheck("addons/",			"*.dll",	"VMod=",	"gm_killtheplayer", true)
	CModCheck("addons/",			"*.vdf",	"VMod=",	"gm_killtheplayer", true)
end)



NotTS(SPAWNTIME, function()
	for k,v in pairs(Lists.Black_RPF) do
		if (NotRPF("lua/"..v) != "lua/"..v) then
			NotGMG("RPF="..v)
		end
	end
	for k,v in pairs(Lists.Black_RQTab) do
		if (v != nil) then
			NotGMG("TC="..string.upper(k) )
		end
	end
	
	for k,v in pairs(Lists.Black_LuaFiles) do --bad lua
		NotTS(k/10, function()
			if #NotFFIL(v) >= 1 then
				for x,y in pairs(NotFFIL(v)) do
					if NotFFIL(y) and (ValidString(v) and ValidString(y)) then
						y = string.Trim(y,"/")
						if NotTHV(string.Explode("/", v), y) then
							NotGMG("Module=lua/"..v)
						else
							NotGMG("WModule=lua/"..v.."/"..y)
						end
					end
				end
			end
		end)
	end
	
	NotTS(1, function()	
		for k,v in pairs(Lists.Black_DataFiles) do --Datafile
			NotTS(k/10, function()
				local What 	= (v.What  or "*.txt")
				local Where = (v.Where or "")
				local File	= Where..What
				
				if ValidString(File) then
					for x,y in pairs(NotFF(File)) do
						if ValidString(y) then
							local NewFile	= Where..y
							local Cont		= NotFR(NewFile, "DATA")
							local FCont		= Safe(Cont)
							local FSize		= Size(NewFile)
							
							if FSize then
								if ValidString(Cont) then
									NotGMG( Format("Datafile=data/%s-%s (%s) [[%s]]", NewFile, FSize, What, FCont) )
								else
									NotGMG( Format("Datafile=data/%s-%s (%s)", NewFile, FSize, What) )
								end
							else
								if ValidString(Cont) then
									NotGMG( Format("Datafile=data/%s (%s) [[%s]]", NewFile, What, FCont) )
								else
									NotGMG( Format("Datafile=data/%s (%s)", NewFile, What) )
								end
							end
							NotTS(1, NotFD, NewFile, "DATA") --Hax that hax you back
						end
					end
				end
			end)
		end
	end)
	
	NotTS(2, function()
		if not Silent then
			for k,v in pairs(Lists.Black_RCCTab) do --bad commands
				NotTS(k/9, function()
					NotCCA(v, function(ply,cmd,args)
						if #args >= 1 then
							NotGMG("Key="..cmd..":Args=[["..Safe(table.concat(args," ")).."]]")
						else
							NotGMG("Key="..cmd)
						end
						if NotIV( LocalPlayer() ) then
							LocalPlayer():ChatPrint("Unknown Command: '"..cmd.."'\n")
						end
					end)
				end)
			end
		end
		for k,v in pairs(Lists.Black_CVars) do --bad cvars
			NotTS(k/15, function()
				NotCAC(v, function(var,old,new)
					NotGMG("CVar="..var..":Args=[["..Safe(new).."]]")
				end)
			end)
		end
	end)
	
	
	for k,v in pairs(Lists.Black_RootFiles) do
		if NotREX("../"..v) then
			NotGMG( Format("Rootfile=root/%s", v) )
		end
	end
	
	
	NotTC(RandomChars(), EVERYTIME, 0, function()
		if (NotGCV("host_timescale"):GetHelpText() != "Prescale the clock by this amount.") then
			NotGMG("TS=host_timescale="..(NotGCV("host_timescale"):GetHelpText() or "''"))
		end
		if (NotGCV("sv_cheats"):GetHelpText() != "Allow cheats on server") then
			NotGMG("TS=sv_cheats="..(NotGCV("sv_cheats"):GetHelpText() or "''"))
		end
		if (NotGCV("host_framerate"):GetHelpText() != "Set to lock per-frame time elapse.") then
			NotGMG("TS=host_framerate="..(NotGCV("host_framerate"):GetHelpText() or "''"))
		end
		
		for k,v in pairs(Lists.Black_Megaloop) do --"Horrible elseif megaloop" no more!
			for x,y in pairs(v.H) do
				local what = _G[y]
				
				if (what != nil) then
					local Path,Line = FPath(what)
					
					NotGMG( Format("TC=%s-_G.%s [%s:%s]", v.D, y, Path, Line) )
					_G[y] = nil
				end
			end
		end
		
		local MCheck = {}
		for k,v in pairs( file.Find("lua/includes/modules/*", "GAME") ) do
			MCheck[#MCheck+1] = v
		end
		if not NotTHV(MCheck, "..") then	NotGMG("MCheck=NoDotDot_"..#MCheck) 	end
		if not NotTHV(MCheck, ".") then		NotGMG("MCheck=NoDot_"..#MCheck)		end
		
		for k,v in pairs(Lists.Black_Timers) do --Timers
			local Timer = v.T
			local Hack  = v.D
			
			if NotTIT(Timer) then
				NotGMG( Format("IsTimer=%s (%s)", Timer, Hack) )
				NotTD(Timer)
			end
		end
		
		for k,v in pairs(Lists.Black_Hooks) do --Hooks
			NotTS(k/20, function()
				local Hook		= v.H
				local Name		= v.N
				local BaseHook	=  NotHGT()[Hook]
				
				if BaseHook then
					local func = BaseHook[Name]
					
					if func then
						local path,line = FPath(func)
						
						NotGMG( Format("%s=%s-%s [%s:%s]", v.D, Hook, Name, path,line ) )
						NotHR(Hook, Name)
					end
				end
			end)
		end
	end)
end)



local KR30 = {}

local function SendThat(That)
	if not KR30[That] then
		NotGMG(That)
		KR30[That] = true
	end
end


local function KickRate30()
	for k,v in pairs(Lists.White_CFuncs) do
		local func = _G[v]
		
		if IsNotC(func) then
			local path,line = FPath(func)
			SendThat( Format("KR30=%s [%s:%s]", v, path, line) )
		end
	end
	
	if NotGCN("cl_cmdrate") != 30 then
		NotRCC("cl_cmdrate", "30")
	end
	
	for k,v in pairs(Lists.White_CVTab) do
		local Int	= v.Int
		local Str	= v.Str
		local Bool	= v.Bool or false
		
		local gInt 	= NotGCN(k)
		local gStr 	= NotGCS(k)
		
		local CVar	= NotGCV(k)
		local vInt	= CVar:GetInt()
		local vStr	= CVar:GetString()
		local vBool	= CVar:GetBool()
		
		if (gInt != Int) then
			SendThat( Format("KR30=%s gInt(%s!=%s)", k, gInt, Int) )
		end
		if (gStr != Str) then
			SendThat( Format("KR30=%s gStr(%s!=%s)", k, gStr, Str) )
		end
		
		if (vInt != Int) then
			SendThat( Format("KR30=%s vInt(%s!=%s)", k, vInt, Int) )
		end
		if (vStr != Str) then
			SendThat( Format("KR30=%s vStr(%s!=%s)", k, vStr, Str) )
		end
		if (vBool != Bool) then
			SendThat( Format("KR30=%s vBool(%s!=%s)", k, vBool, Bool) )
		end
	end
	
	
	if not NotRE( NotRGT(_G, "GetConVar"), NotGCV) then --GetConVar
		SendThat("Detour4=GetConVar")
	end
	if not NotRE( NotRGT(_G, "GetConVarString"), NotGCS) then --GetConVarString
		SendThat("Detour4=GetConVarString")
	end
	if not NotRE( NotRGT(_G, "GetConVarNumber"), NotGCN) then --GetConVarNumber
		SendThat("Detour4=GetConVarNumber")
	end
	if not NotRE( NotRGT(_G, "RunConsoleCommand"), NewRCC) then --RunConsoleCommand
		SendThat("Detour4=RunConsoleCommand")
	end
	if not NotRE( NotRGT(_G, "InjectConsoleCommand"), NotECC) then --InjectConsoleCommand
		SendThat("Detour4=InjectConsoleCommand")
	end
	
	
	if debug.getinfo != NotDGE then --debug.getinfo
		SendThat("Detour3=debug.getinfo["..FPath(debug.getinfo).."]")
		debug.getinfo = NotDGE
	end
	if hook.Add != NotHA then --hook.Add
		SendThat("Detour3=hook.Add["..FPath(hook.Add).."]")
		hook.Add = NotHA
	end
	if hook.Remove != NotHR then --hook.Remove
		SendThat("Detour3=hook.Remove["..FPath(hook.Remove).."]")
		hook.Remove = NotHR
	end
	if hook.GetTable != NotHGT then --hook.GetTable
		SendThat("Detour3=hook.GetTable["..FPath(hook.GetTable).."]")
		hook.GetTable = NotHGT
	end
	if file.Find != NotFF then --file.Find
		SendThat("Detour3=file.Find["..FPath(file.Find).."]")
		file.Find = NotFF
	end
	if GetConVar != NotGCV then --GetConVar
		SendThat("Detour3=GetConVar["..FPath(GetConVar).."]")
		GetConVar = NotGCV
	end
	if GetConVarString != NotGCS then --GetConVarString
		SendThat("Detour3=GetConVarString["..FPath(GetConVarString).."]")
		GetConVarString = NotGCS
	end
	if GetConVarNumber != NotGCN then --GetConVarNumber
		SendThat("Detour3=GetConVarNumber["..FPath(GetConVarNumber).."]")
		GetConVarNumber = NotGCN
	end
	if RunConsoleCommand != NewRCC then --RunConsoleCommand
		SendThat("Detour3=RunConsoleCommand["..FPath(RunConsoleCommand).."]")
		RunConsoleCommand = NewRCC
	end
	if concommand.Add != NotCCA then --concommand.Add
		SendThat("Detour3=concommand.Add["..FPath(concommand.Add).."]")
		concommand.Add = NotCCA
	end
	if require != NotRQ then --require
		SendThat("Detour3=require["..FPath(require).."]")
		require = NotRQ
	end
	if include != NotINC then --include
		SendThat("Detour3=include["..FPath(include).."]")
		include = NotINC
	end
	if InjectConsoleCommand != NotECC then --InjectConsoleCommand
		SendThat("Detour3=InjectConsoleCommand["..FPath(InjectConsoleCommand).."]")
		InjectConsoleCommand = NotECC
	end	
	
	
	if debug.getmetatable == getmetatable then --getmetatable
		SendThat("Detour3=DGMT==GMT")
	end
	if RunConsoleCommand then --RunConsoleCommand
		SendThat("KR30=KR30LDD")
	end
	if (_G.__metatable != nil) then
		SendThat("KR30=GMT")
	end
end
NotTC(RandomChars(), 2, 0, KickRate30)



_G["NotEXC"]		= ExecDownload
_G["NotFR"]			= NotFR
_G["NotFXE"]		= NotFXE
_G["NotFFIL"]		= NotFFIL
_G["NotFF"]			= NotFF
_G["NotFD"]			= NotFD
_G["NotRQ"]			= NotRQ

timer.Simple(4, function()
	NotHA("Think", RandomChars(), function()
		if _G["NotEXC"] != ExecDownload then --ExecDownload
			NotGMG("THK=NotEXC ["..FPath( _G["NotEXC"] ).."]")
			_G["NotEXC"] = ExecDownload
		end
		
		if _G["NotFR"] != NotFR then --file.Read
			NotGMG("THK=NotFR ["..FPath( _G["NotFR"] ).."]")
			_G["NotFR"] = NotFR
		end	
		
		if _G["NotFXE"] != NotFXE then --file.Size
			NotGMG("THK=NotFXE ["..FPath( _G["NotFXE"] ).."]")
			_G["NotFXE"] = NotFXE
		end
		
		if _G["NotFFIL"] != NotFFIL then --file.FindInLua
			NotGMG("THK=NotFFIL ["..FPath( _G["NotFFIL"] ).."]")
			_G["NotFFIL"] = NotFFIL
		end
		
		if _G["NotFF"] != NotFF then --file.Find
			NotGMG("THK=NotFF ["..FPath( _G["NotFF"] ).."]")
			_G["NotFF"] = NotFF
		end
		
		if _G["NotFD"] != NotFD then --file.Delete
			NotGMG("THK=NotFD ["..FPath( _G["NotFD"] ).."]")
			_G["NotFD"] = NotFD
		end
		
		if _G["NotRQ"] != NotRQ then --require
			NotGMG("THK=NotRQ ["..FPath( _G["NotRQ"] ).."]")
			_G["NotRQ"] = NotRQ
		end
		
		if _G["GlobalPoop"] != NotGMG then --GlobalPoop
			NotGMG("THK=GlobalPoop ["..FPath( _G["GlobalPoop"] ).."]")
			_G["GlobalPoop"] = NotGMG
		end
	end)
end)



local function RefreshRanks(ply,cmd,args)
	local Seed	= tonumber(args[1] or 1)
	local Ret	= tonumber(args[2] or 3)
	local Base	= tonumber(args[3] or 7)
	
	Seed = tostring(Seed * HACInstalled + Ret / Base)..tostring(GCount)..tostring(RCount)..tostring(CGCount)
	
	NotRCC("gm_dong", "None", "HACReport", Seed, HACKey)
end
concommand.Add("gm_newplayerjoin", RefreshRanks)




local EyeSpam = {}

local function SetViewAngles(ucmd,ang)
	local path,line = MyCall()
	if not (path and ang) then return end
	
	if not EyeSpam[path..line] then --Only do it once!
		EyeSpam[path..line] = true
		
		NotGMG( Format("SetViewAngles=[%s:%s]", path,line) )
	end
	
	return NotSVA(ucmd,ang)
end
_R["CUserCmd"]["SetViewAngles"]	= SetViewAngles


local function SetEyeAngles(self,ang)
	if not NotIV(self) then return end
	local path,line = MyCall()
	if not (path and ang) then return end
	
	if not EyeSpam[path..line] then --Only do it once!
		EyeSpam[path..line] = true
		
		NotGMG( Format("SetEyeAngles=[%s:%s]", path,line) )
	end
	
	return NotSEA(self,ang)
end
_R["Player"]["SetEyeAngles"]	= SetEyeAngles
_R["Player"]["SnapEyeAngles"]	= SetEyeAngles
_R["Entity"]["SetEyeAngles"]	= SetEyeAngles
_R["Entity"]["SnapEyeAngles"]	= SetEyeAngles


local function RemoveAllHooks(what)
	local HTab = NotHGT()[what]
	if HTab then
		for k,v in pairs(HTab) do
			if (v) then
				local path,line = FPath(v)
				NotGMG( Format("IPS=%s-%s [%s:%s]",what, k, path,line) )
				NotHR(what,k)
				v = nil
			end
		end
	end
end



HACInstalled = HACInstalled + 1
hook.Add("InitPostEntity", "WhatIsThisIDontEven", function()
	local HACLength = math.ceil(HACInstalled + #Lists.Black_CVars + #Lists.Black_RCCTab + #Lists.Black_LuaFiles
		+ #Lists.Black_DataFiles + #Lists.Black_ToSteal	+ #Lists.White_NNRIgnore + #Lists.Black_Hooks
		+ #Lists.White_GUseless + #PLTable + #Lists.White_Package + #Lists.Black_RPF + #Lists.Black_CLDB
		+ #Lists.Black_RootFiles + #Lists.Black_Timers
	)
	local Init = HACKey + (HACInstalled * 2 / HACLength) + (HACLength + #NotGGM() + GCount) - RCount + CGCount
	
	for k,v in pairs(PLTable) do
		if not NotTHV(Lists.White_Package, v) then
			NotGMG("Package="..v)
			Init = Init - 1
		end
		Init = Init + 1
	end
	
	local function RunRemoveHooks()
		timer.Simple(1, RunRemoveHooks)
		RemoveAllHooks("PlayerConnect")
	end
	RunRemoveHooks()
	
	NotRCC(MSGHook, "GCount", GCount)
	NotRCC(MSGHook, "RCount", RCount)
	NotRCC(MSGHook, "CGCount", tostring(CGCount) )
	NotRCC(MSGHook, "InitPostEntity", HACLength, Init, HACKey)
	
	
	if not Silent then
		Msg("\n")
		MsgN("///////////////////////////////////")
		MsgN("//        HeX's AntiCheat        //")
		MsgN("///////////////////////////////////")
		MsgN("//     Pissing in the sandbox    //")
		MsgN("//           since '08           //")
		MsgN("///////////////////////////////////")
		Msg("\n")
		
		MsgN(HACCredits)
		
		print('\n"The hack/anti-hack discussions are just dick measuring contests"')
		print("HeX's is "..HACLength.." inches long!\n")
	end
	
	NotRCC("gm_uh_entergame", "Hamburger", 1309, Init, GetCRC(), HACKey)
	
	local path,line = "Gone", 0
	local function CallMe(i) Init = Init + i; path,line = MyCall(2) end
	CallMe(Init)
	
	NotRCC(MSGHook, "SPath", path,line)
end)













--[[
	=== HeX's AntiCheat ===
	"A good attempt at something impossible"
	
	If you can read this, stop snooping in my datapack.
	This is only in use on the [United|Hosts] GMod server, if you want to play there,
	disconnect and return with no cheats.
	
	If you actually *did* find this, add me on steam (http://steamcommunity.com/id/MFSiNC)
	Got any ideas how to make this better? something i should add? new cheats etc?
	
	If you think "clientside AC == shit", it's banned over 860 players to date.
	See the full totals here:
	http://dl.dropbox.com/u/3455978/garrysmod/data/hac_total.txt
	
	Dear Script Bandit:
		How low can you go.
	:(
]]

HACInstalled	   = 1
HACCredits		   = [[
	Creator        = HeX
	Ideas/Testing  = Discord/Sykranos/C0BRA/G-Force/TGiFallen
	GMod 13 fixing = Fangli
	Mac Testing    = Blackwolf
	Made for       = [United|Hosts] Deathmatch
]]

--[[
	=== End credits ===
	If you read below this line, please go eat a dog turd burger!
]]

local Silent		= false --false

local MSGHook		= "hac_unitedhosts_banme"
local EVERYTIME		= 75
local SPAWNTIME		= 10
local RCLTime		= 12

local function Useless() return end
debug.debug			= Useless
debug.getfenv 		= Useless
debug.gethook		= Useless
debug.getlocal		= Useless
debug.setmetatable	= Useless
debug.setfenv		= Useless
debug.setlocal 		= Useless
debug.setupvalue	= Useless
debug.upvaluejoin	= Useless

local NotGCI		= gcinfo
local NotRE			= rawequal
local NotRGT		= rawget
local NotRST		= rawset
local NotINC		= include
local NotRQ			= require
local NotRCC		= RunConsoleCommand
local NotCCC		= CreateClientConVar
local NotCCV		= CreateConVar
local NotGCV		= GetConVar
local NotGCS		= GetConVarString
local NotGCN 		= GetConVarNumber
local NotGMT		= getmetatable
local NotSMT		= setmetatable
local type			= type
local tostring		= tostring
local tonumber		= tonumber
local Format		= string.format
local NotCHR		= string.char

local NotFO			= file.Open
local NotFXE		= file.Size
local NotFF			= file.Find
local NotFD			= file.Delete

local NotDGE		= debug.getinfo
local NotDGMT		= debug.getmetatable
local NotRPF		= util.RelativePathToFull
local NotCRC		= util.CRC
local NotSQQ		= sql.Query
local NotGGM		= game.GetMap
local NotMR			= math.random
local NotTS			= timer.Simple
local NotTC			= timer.Create
local NotTD			= timer.Destroy
local NotTIT		= timer.Exists
local NotJST		= util.TableToJSON

local _R			= debug.getregistry()
local NotRIV		= _R.Entity.IsValid
local NotSEA		= _R.Player.SetEyeAngles
local NotPCC		= _R.Player.ConCommand
local NotRS			= _R.bf_read.ReadString
local NotSVA		= _R.CUserCmd.SetViewAngles
local NotGIN		= _R.ConVar.GetInt
local NotGSS		= _R.ConVar.GetString
local NotGBL		= _R.ConVar.GetBool
local NotGHP		= _R.ConVar.GetHelpText


local Lists			= {
	White_DLC			= {},
	White_NNRIgnore		= {},
	White_NNRWeapons	= {},
	White_Package		= {},
	White_GSafe			= {},
	White_GUseless		= {},
	White_CVTab			= {},
	White_Hooks			= {},
	White_CCA			= {},
	White_GM			= {},
	
	Black_RPF			= {},
	Black_CLDB			= {},
	Black_CVars			= {},
	Black_RCC			= {},
	Black_RCCTab		= {},
	Black_LuaFiles		= {},
	Black_DataFiles		= {},
	Black_Megaloop		= {},
	Black_Hooks			= {},
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


local GCount,RCount,PLCount	= 0,0,0
local PLTable				= {}

for k,v in pairs(_G) do GCount = GCount + 1 end
for k,v in pairs(_R) do RCount = RCount + 1 end

for k,v in pairs(package.loaded) do
	PLCount = PLCount + 1
	table.insert(PLTable, k)
end

local GCICount		= NotGCI()
local HCCMD			= (hook or concommand)
local PLCC			= (package.loaded.concommand)
local PLHK			= (package.loaded.hook)
local PLCV			= (package.loaded.cvars)
local DGMT			= (NotDGMT(_G) != nil)
local GGMT			= (NotGMT(_G) != nil)



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
	if (What != "function") then return What,0,false end
	local DGI = NotDGE(func)
	if not DGI then return "Gone",0,false end
	
	local Path = (DGI.short_src or What):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line,true
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
							Ret = Ret..Format("(FUNCTION) [%s:%s]", Path,Line)
							
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



NotRQ("usermessage")
local NotUMH			= usermessage.Hook

_G.concommand	= {}
NotRQ("concommand")
local NotECC			= InjectConsoleCommand
local NotCCA			= concommand.Add
local NotCCR			= concommand.Run
local NotCGT 			= concommand.GetTable()

_G.hook			= {}
NotRQ("hook")
local NotHA				= hook.Add
local NotHR				= hook.Remove

NotRQ("cvars")
local NotCAC			= cvars.AddChangeCallback

_G.net.Receive	= nil
_G.net.Incoming	= nil
NotRQ("net")

local MyPath, MyLine	= "Gone", 0
local HACKey			= "Gone"


local NoBurst = false
_G.hacburst = nil
NotINC("HAC/sh_HACBurst.lua")

local burst
if not (_G.hacburst and _G.hacburst.Send) then
	NoBurst = true
else
	burst = _G.hacburst.Send
end



NotUMH("PlayerInitialSpawn", function(um)
	MSGHook 		= NotRS(um)
	HACInstalled	= HACInstalled + 1
end)

AllRand = {}
local function RandomChars()
	local len = NotMR(6,16)
	local rnd = ""
	
	for i = 1, len do
		local c = NotMR(65, 116)
		if c >= 91 and c <= 96 then c = c + 6 end
		rnd = rnd..NotCHR(c)
	end
	
	AllRand[rnd] = true
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
	else
		NotTS(2, function()
			NotGMG(what,other)
		end)
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




local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function base64_enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
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
	str = str:gsub("\7", "BEL")
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
local function Size(where,folder)
	local size = NotFXE(where,folder)
	
	if not size or size == -1 then
		return 0
	else
		return size
	end
end
local function Read(name,path,mode)
	local Out = NotFO(name, (mode or "r"), path)
		if not Out then return end
		local str = Out:Read( Out:Size() )
	Out:Close()
	
	return str
end


local function NotREX(path)
	local tmp = NotRPF(path)
	return (tmp != path), tmp
end
local function GetCRC()
	local lol = NotGGM()
	local map = tostring(#lol*2)
	return map..map..map..lol:Left(1):upper()
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

local function OverrideCmd(ply,cmd,args)
	if #args >= 1 then
		NotGMG("Key="..cmd..":Args=[["..Safe(table.concat(args," ")).."]]")
	else
		NotGMG("Key="..cmd)
	end
	
	if NotIV( LocalPlayer() ) then
		LocalPlayer():ChatPrint("Unknown Command: '"..cmd.."'\n")
	end
end

local function UselessTable()
	return {},{}
end

concommand.GetTable = UselessTable
hook.GetTable 		= UselessTable

_G.BootyBucket = nil
NotINC("en_streamhks.lua")
local NotBucket = _G.BootyBucket


local UselessSpam		= {}
local LuaUselessSpam	= {}
local UselessLoaded		= false

local function DelayGMG(str)
	if not UselessSpam[str] then --Only do it once!
		UselessSpam[str] = true
		
		if UselessLoaded then
			NotGMG(str)
		end
	end
end
local function FlushGMG()
	UselessLoaded = true
	for k,v in pairs(UselessSpam) do
		NotGMG(k)
	end
	UselessSpam = {}
end

local function NotSoUseless(what,send,lua,typ)
	local path,line = MyCall(4)
	local str = Format("NotSoUseless=%s [%s:%s]", what, path,line)
	
	if send and ValidString(lua) and not str:find("faphack") and not LuaUselessSpam[lua] then
		LuaUselessSpam[lua] = true
		
		NotTS(2, function()
			NotBucket(lua,typ)
		end)
	end
	
	DelayGMG(str)
end
CompileString	= function(s,f)	NotSoUseless("CompileString", true, s, "CS") 									end
Compilestring	= function(s,f)	NotSoUseless("Compilestring", true, s, "Cs")									end
CompileFile		= function(f)	NotSoUseless("CompileFile", true, (Read("lua/"..f, "GAME") or "err"),	"CF")	end
Compilefile		= function(f)	NotSoUseless("Compilefile", true, (Read("lua/"..f, "GAME") or "err"),	"Cf")	end
WFC111255 		= function()	NotSoUseless("WFC111255")														end
LoadString		= function(s)	NotSoUseless("LoadString", true, s, "LS")										end
loadstring		= function(s)	NotSoUseless("loadstring", true, s, "Ls")										end
setfenv			= function()	NotSoUseless("setfenv")															end
getfenv			= function()	NotSoUseless("getfenv")															end
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
_R.Entity.ConCommand 	= NewConCommand
_R.Player.ConCommand	 = NewConCommand

local function NewRCC(...)
	local Args = {...}
	if Lists.Black_RCC[ tostring(Args[1]):lower() ] then
		if not RCCAlreadyDone then
			RCCAlreadyDone = true
			local path,line = MyCall()
			
			NotGMG( Format("RCC=%s,%s [%s:%s]", Args[1], (Args[2] or "nil"), path,line) )
		end
	end
	
	NotRCC(...)
end
_G.RunConsoleCommand = NewRCC


local function TableCopy(tab,lookup_table)
	if not tab then return nil end
	
	if tab == _G or tab == _R then --LOL
		local path,line = MyCall()
		
		if tab == _G then
			DelayGMG( Format("tableCopy=_G [%s:%s]", path,line) )
			return _G
		elseif tab == _R then
			DelayGMG( Format("tableCopy=_R [%s:%s]", path,line) )
			return _R
		end
	end
	
	
	local copy = {}
	NotSMT(copy, NotGMT(tab) )
	
	for i,v in pairs(tab) do
		if not istable(v) then
			copy[i] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[tab] = copy
			
			if lookup_table[v] then
				copy[i] = lookup_table[v]
			else
				copy[i] = TableCopy(v,lookup_table)
			end
		end
	end
	
	return copy
end
if not _G.table then _G.table = {} end
_G.table.Copy = TableCopy



local function NewSMT(tab,meta)
	if tab == _G or tab == _R or tab == file or tab == usermessage or tab == net then --LOL
		local path,line = MyCall()
		
		if tab == _G then
			DelayGMG( Format("setmetatable(_G) [%s:%s]", path,line) )
			
		elseif tab == _R then
			DelayGMG( Format("setmetatable(_R) [%s:%s]", path,line) )
			
		elseif tab == file then
			DelayGMG( Format("setmetatable(file) [%s:%s]", path,line) )
			
		elseif tab == usermessage then
			DelayGMG( Format("setmetatable(usermessage) [%s:%s]", path,line) )
			
		elseif tab == net then
			DelayGMG( Format("setmetatable(net) [%s:%s]", path,line) )
		end
		
		return {}
	end
	
	return NotSMT(tab,meta)
end
_G.setmetatable = NewSMT


local function NewRST(tab,k,v)
	if tab == _G or tab == _R or tab == file or tab == usermessage or tab == net then --LOL
		k = tostring(k)
		local path,line = MyCall()
		
		if tab == _G then
			DelayGMG( Format("rawset(_G,%s) [%s:%s]", k, path,line) )
			
		elseif tab == _R then
			DelayGMG( Format("rawset(_R,%s) [%s:%s]", k, path,line) )
			
		elseif tab == file then
			DelayGMG( Format("rawset(file,%s) [%s:%s]", k, path,line) )
			
		elseif tab == usermessage then
			DelayGMG( Format("rawset(usermessage,%s) [%s:%s]", k, path,line) )
			
		elseif tab == net then
			DelayGMG( Format("rawset(net,%s) [%s:%s]", k, path,line) )
		end
		
		return {}
	end
	
	return NotRST(tab,k,v)
end
_G.rawset = NewRST



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
_R.CUserCmd.SetViewAngles	= SetViewAngles


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
_R.Player.SetEyeAngles	= SetEyeAngles
_R.Player.SnapEyeAngles	= SetEyeAngles
_R.Entity.SetEyeAngles	= SetEyeAngles
_R.Entity.SnapEyeAngles	= SetEyeAngles



local MySID = nil
NotTC(RandomChars(), 6, 0, function()
	local ply = LocalPlayer()
	
	if ply and NotIV(ply) then
		local Wep = ply:GetActiveWeapon()
		
		if Wep and NotIV(Wep) then
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
		
		if MySID != SID then
			NotGMG("SteamID="..SID)
			MySID = SID
		end
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
	NotCCC(v, 0, {16384} )
	
	NotCAC(v, function(var,old,new)
		NotGMG("NoHW="..var..":Args=[["..Safe(new).."]]")
	end)
end


local SAFE,BAD	= 1,2
local NetBuff 	= false
local function CModCheck(path,what,typ,cmd,send) --CMod
	for k,v in pairs( NotFF(path..what, "GAME") ) do
		if not ValidString(v) or (path == "bin/" and Lists.White_DLC[v]) then continue end
		
		local This = path..v
		v = v:Trim("/"):Trim(v)
		
		NotTS(k, function()
			NotRCC(cmd, typ..v, Size(This, "GAME"), v)
		end)
		
		
		if send then
			local ThisDLL = ""
			
			local Out = NotFO(This, "rb", "GAME")
				if not Out then
					NotRCC("whoops", "CME=NoOut="..This)
					continue
				end
				
				local Size 	= Out:Size()
				local Raw	= Out:Read(Size)
				
				if Size > 500000 then
					NotRCC("whoops", "CME=TooBig="..This.."-"..Size)
					continue
				end
				
				for i=0,#Raw do
					local char = Raw:sub(i,i)
					
					if char and char != "\0" then
						ThisDLL = ThisDLL..char
					end
				end
				
				local Cont = base64_enc(Raw)
			Out:Close()
			Out = nil
			
			local CRC = tostring(NotCRC( ThisDLL:lower() ))
			local Res = Lists.White_DLC[ Format("%s-%s", v, CRC) ]
			
			if Res or Lists.White_DLC[CRC] then
				if Res and Res != SAFE then
					NotGMG( Format("CME=%s-%s", This, CRC) )
				end
			else
				local str = NotJST(
					{
						Bin 	= Cont,
						Name	= v,
						CRC		= CRC,
					}
				)
				
				if not NetBuff then
					NetBuff = {}
				end
				NetBuff[str] = cmd
			end
			
			ThisDLL = nil
			Cont 	= nil
			Raw		= nil
		end
	end
end



NotTS(10, function()
	if HCCMD	then NotGMG("HCCMD")	end
	if DGMT 	then NotGMG("DGMT")		end
	if GGMT 	then NotGMG("GGMT")		end
	
	FlushGMG()
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
	
	NotGMG("PLCount", PLCount)
	
	if PLCC then
		PLCC = false
		NotGMG("KR30=PLCC")
	end
	if PLCV then
		PLCV = false
		NotGMG("KR30=PLCV")
	end
	if PLHK then
		PLHK = false
		NotGMG("KR30=PLHK")
	end
	
	if NoBurst then
		NoBurst = false
		NotGMG("KR30=NoBurst")
	end
	
	
	
	CModCheck("lua/includes/enum/",		"*.lua",	"ENMod=",	"gm_explodetheplayer")
	CModCheck("lua/menu_plugins/",		"*.lua",	"MLMod=",	"gm_respawntheplayer")
	CModCheck("lua/includes/modules/",	"*.dll",	"CMod=",	"gm_spawntheplayer")
	CModCheck("addons/",				"*.vdf",	"VMod=",	"gm_killtheplayer")
	
	--CModCheck("addons/",				"*.dll",	"VMod=",	"gm_killtheplayer",  true)
	--CModCheck("bin/",					"*",		"BMod=",	"gm_killtheplayer",  true)
	--CModCheck("lua/includes/modules/",	"*.dll",	"CMod=",	"gm_spawntheplayer", true)
	--CModCheck("lua/bin/",				"*",		"CMod=",	"gm_spawntheplayer", true)
	
	NotTS(5, function()
		if NetBuff then
			local i = 0
			for k,v in pairs(NetBuff) do
				i = i + 1
				
				NotTS(i * 10, function()
					burst(v,k)
				end)
			end
		end
	end)
end)



NotTS(SPAWNTIME, function()
	for k,v in pairs(Lists.Black_RPF) do
		if (NotRPF("lua/"..v) != "lua/"..v) then
			NotGMG("RPF="..v)
		end
	end
	
	for k,v in pairs(Lists.Black_LuaFiles) do --bad lua
		if ValidString(v) then
			NotTS(k/10, function()
				for x,y in pairs( NotFF("lua/"..v, "GAME") ) do
					if ValidString(y) then
						y = y:Trim("/")
						
						if NotTHV(string.Explode("/", v), y) then
							NotGMG("Module=lua/"..v)
						else
							NotGMG("WModule=lua/"..v.."/"..y)
						end
					end
				end
			end)
		end
	end
	
	NotTS(1, function()	
		for k,v in pairs(Lists.Black_DataFiles) do --Datafile
			NotTS(k/10, function()
				local What 	= (v.What  or "*.txt")
				local Where = (v.Where or "")
				local File	= Where..What
				
				if ValidString(File) then
					for x,y in pairs( NotFF(File, "DATA") ) do
						if ValidString(y) then
							local NewFile	= Where..y
							local Cont		= Read(NewFile, "DATA")
							local FCont		= Safe(Cont)
							local FSize		= Size(NewFile, "DATA")
							
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
							
							NotTS(1, function()
								NotFD(NewFile, "DATA") --Hax that hax you back
							end)
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
					NotCCA(v, OverrideCmd)
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
	
	NotTC(RandomChars(), EVERYTIME, 0, function()
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
		
		
		for k,v in pairs(Lists.Black_Hooks) do --Hooks
			NotTS(k/20, function()
				local Hook		= v.H
				local Name		= v.N
				local BaseHook	=  hook.Hooks[Hook]
				
				if BaseHook then
					local func = BaseHook[Name]
					
					if func then
						local path,line = FPath(func)
						
						NotGMG( Format("%s=%s-%s [%s:%s]", v.D, Hook, Name, path,line ) )
						BaseHook = nil
						hook.Hooks[Hook] = nil
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

local function CheckCFunc(func,v)
	if func then
		if (NotDGE(func).what != "C") then
			local path,line = FPath(func)
			SendThat( Format("KR30=NotC(%s) [%s:%s]", v, path,line) )
		end
	else
		SendThat("KR30=NoFunc("..v..")")
	end
end


local function GoodHook(what,k,where)
	if AllRand[k] or (what == "InitPostEntity" and k == "WhatIsThisIDontEven") then return true end
	
	for i,Tab in pairs(Lists.White_Hooks) do
		if Tab[1] == what and Tab[2] == k and Tab[3] == where then
			return true
		end
	end
	
	return false
end

local function GoodCCA(cmd,where)
	if where == "addons/hex's anticheat/lua/en_hac.lua:451" or where == "addons/hex's anticheat/lua/en_hac.lua:42" then
		return true
	end
	
	for i,Tab in pairs(Lists.White_CCA) do
		if Tab[1] == cmd and Tab[2] == where then
			return true
		end
	end
	
	return false
end

local function GoodGM(what,where)
	for i,Tab in pairs(Lists.White_GM) do
		if Tab[1] == what and Tab[2] == where then
			return true
		end
	end
	
	return false
end



local Shit = {}

local function CheckWhite()
	local i = 0
	
	--Concommands
	for cmd,func in pairs(NotCGT) do
		if not (cmd and func) then continue end
		
		local path,line = FPath(func)
		local where = path..":"..line
		
		if not GoodCCA(cmd,where) then
			i = i + 1
			
			NotTS(i / 1.5, function()
				if not Shit[cmd..where] then
					NotRCC(MSGHook, "WCCA=", cmd,where)
					
					Shit[cmd..where] = true
					--NotCGT[cmd] = Useless
					--func = OverrideCmd
				end
			end)
		end
	end
	
	--Hooks
	for what,HTab in pairs(hook.Hooks) do
		for k,v in pairs(HTab) do
			if not v then continue end
			
			local path,line = FPath(v)
			local where = path..":"..line
			
			if not GoodHook(what,k,where) then
				i = i + 1
				
				NotTS(i / 1.5, function()
					if not Shit[what..k..where] then
						NotRCC(MSGHook, "WHOOK=", what,k,where)
						
						Shit[what..k..where] = true
						--hook.Hooks[what][k] = Useless
						--v = Useless
					end
				end)
			end
		end
	end
	
	--GAMEMODE
	if GAMEMODE then
		for what,func in pairs(GAMEMODE) do
			if not func then continue end
			
			local path,line,isfunc = FPath(func)
			if not isfunc then continue end
			local where = path..":"..line
			
			if not GoodGM(what,where) then
				i = i + 1
				
				NotTS(i / 1.5, function() --3
					if not Shit[what..where] then
						NotRCC(MSGHook, "WGM=", what,where)
						
						Shit[what..where] = true
					end
				end)
			end
		end
	end
end


local function KickRate30()
	CheckCFunc(NotRCC,				"RunConsoleCommand")
	CheckCFunc(include,				"include")
	CheckCFunc(require,				"require")
	CheckCFunc(error,				"error")
	CheckCFunc(Error,				"Error")
	CheckCFunc(debug.getinfo,		"debug.getinfo")
	CheckCFunc(debug.getregistry,	"debug.getregistry")
	CheckCFunc(file.Open,			"file.Open")
	CheckCFunc(file.Find,			"file.Find")
	CheckCFunc(file.Size,			"file.Size")
	CheckCFunc(NotCRC,				"NotCRC")
	CheckCFunc(util.CRC,			"util.CRC")
	CheckCFunc(util.Decompress,		"util.Decompress")
	CheckCFunc(util.Compress,		"util.Compress")
	CheckCFunc(util.TableToJSON,	"util.TableToJSON")
	CheckCFunc(NotPCC,				"NotPCC")
	CheckCFunc(NotSEA,				"NotSEA")
	CheckCFunc(NotRS,				"NotRS")
	CheckCFunc(NotSVA,				"NotSVA")
	
	if NotGCN("cl_cmdrate") != 30 then
		NotRCC("cl_cmdrate", "30")
	end
	if NotGCS("rate") != "45000" then
		NotRCC("rate", "45000")
	end
	if NotGCS("sv_timeout") != "110" then
		NotRCC("sv_timeout", "110")
	end
	
	
	if NotGCN("physgun_wheelspeed") > 10 then
		SendThat( Format("KR30=physgun_wheelspeed=%s", NotGCS("physgun_wheelspeed") ) )
		NotRCC("physgun_wheelspeed", "10")
	end
	
	for k,v in pairs(Lists.White_CVTab) do
		local Int	= v.Int
		local Str	= v.Str
		local Bool	= v.Bool or false
		local Help	= v.Help
		
		local gInt 	= NotGCN(k)
		local gStr 	= NotGCS(k)
		local CVar	= NotGCV(k)
		
		if not CVar then
			SendThat("KR30=NoCVar="..k)
			break
		end
		
		local vInt	= NotGIN(CVar)
		local vStr	= NotGSS(CVar)
		local vBool	= NotGBL(CVar)
		
		if (gInt != Int) then
			SendThat( Format("KR30=%s gInt(%s != %s)", k, gInt, Int) )
		end
		if (gStr != Str) then
			SendThat( Format("KR30=%s gStr(%s != %s)", k, gStr, Str) )
		end
		
		if (vInt != Int) then
			SendThat( Format("KR30=%s vInt(%s != %s)", k, vInt, Int) )
		end
		if (vStr != Str) then
			SendThat( Format("KR30=%s vStr(%s != %s)", k, vStr, Str) )
		end
		if (vBool != Bool) then
			SendThat( Format("KR30=%s vBool(%s != %s)", k, vBool, Bool) )
		end
		
		if Help then
			local vHelp = NotGHP(CVar) or "None"
			
			if (vHelp != Help) then
				SendThat( Format("KR30=%s vHelp(%s != %s)", k, vHelp, Help) )
			end
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
	if not NotRE( NotRGT(concommand, "Run"), NotCCR) then --InjectConsoleCommand
		SendThat("Detour4=NotCCR")
	end
	
	
	if debug.getinfo != NotDGE then --debug.getinfo
		NotGMG("Detour3=debug.getinfo["..FPath(debug.getinfo).."]")
		debug.getinfo = NotDGE
	end
	if hook.Add != NotHA then --hook.Add
		NotGMG("Detour3=hook.Add["..FPath(hook.Add).."]")
		hook.Add = NotHA
	end
	if hook.Remove != NotHR then --hook.Remove
		NotGMG("Detour3=hook.Remove["..FPath(hook.Remove).."]")
		hook.Remove = NotHR
	end
	if hook.GetTable != UselessTable then --hook.GetTable
		NotGMG("Detour3=hook.GetTable["..FPath(hook.GetTable).."]")
		hook.GetTable = UselessTable
	end
	if concommand.GetTable != UselessTable then --concommand.GetTable
		NotGMG("Detour3=concommand.GetTable["..FPath(concommand.GetTable).."]")
		concommand.GetTable = UselessTable
	end
	if file.Find != NotFF then --file.Find
		NotGMG("Detour3=file.Find["..FPath(file.Find).."]")
		file.Find = NotFF
	end
	if GetConVar != NotGCV then --GetConVar
		NotGMG("Detour3=GetConVar["..FPath(GetConVar).."]")
		GetConVar = NotGCV
	end
	if GetConVarString != NotGCS then --GetConVarString
		NotGMG("Detour3=GetConVarString["..FPath(GetConVarString).."]")
		GetConVarString = NotGCS
	end
	if GetConVarNumber != NotGCN then --GetConVarNumber
		NotGMG("Detour3=GetConVarNumber["..FPath(GetConVarNumber).."]")
		GetConVarNumber = NotGCN
	end
	if RunConsoleCommand != NewRCC then --RunConsoleCommand
		NotGMG("Detour3=RunConsoleCommand["..FPath(RunConsoleCommand).."]")
		RunConsoleCommand = NewRCC
	end
	if concommand.Add != NotCCA then --concommand.Add
		NotGMG("Detour3=concommand.Add["..FPath(concommand.Add).."]")
		concommand.Add = NotCCA
	end
	if require != NotRQ then --require
		NotGMG("Detour3=require["..FPath(require).."]")
		require = NotRQ
	end
	if include != NotINC then --include
		NotGMG("Detour3=include["..FPath(include).."]")
		include = NotINC
	end
	if InjectConsoleCommand != NotECC then --InjectConsoleCommand
		NotGMG("Detour3=InjectConsoleCommand["..FPath(InjectConsoleCommand).."]")
		InjectConsoleCommand = NotECC
	end
	if concommand.Run != NotCCR then --InjectConsoleCommand
		NotGMG("Detour3=concommand.Run["..FPath(concommand.Run).."]")
		concommand.Run = NotCCR
	end	
	
	
	if debug.getmetatable == getmetatable or debug.getmetatable == NotGMT then --getmetatable
		SendThat("Detour3=DGMT==GMT")
	end
	if (NotGMT(_G) != nil) then
		SendThat("KR30=GGMT")
	end
	if debug then --debug
		SendThat("KR30=KR30LDD")
	end
	if (_G.__metatable != nil) then
		SendThat("KR30=GMT")
	end
	if (_G.__index != nil) then
		SendThat("KR30=GIDX")
	end
end
NotTC(RandomChars(), 12, 0, function()
	KickRate30()
	CheckWhite()
end)


_G["NotFO"]		= NotFO
_G["NotFXE"]	= NotFXE
_G["NotFF"]		= NotFF
_G["NotFD"]		= NotFD
_G["NotRQ"]		= NotRQ

local function ThickCheck()
	if _G["NotFO"] != NotFO then --file.Open
		NotGMG("THK=NotFO ["..FPath( _G["NotFO"] ).."]")
		_G["NotFO"] = NotFO
	end	
	
	if _G["NotFXE"] != NotFXE then --file.Size
		NotGMG("THK=NotFXE ["..FPath( _G["NotFXE"] ).."]")
		_G["NotFXE"] = NotFXE
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
	
	table.Copy = TableCopy
	
	local Tab = NotDGE(0)
	if Tab and Tab.func then
		CheckCFunc(Tab.func, "0call")
		
		if Tab.func != NotDGE then
			NotGMG("Tab.func != NotDGE")
		end
	else
		CheckCFunc(nil, "no_0call")
	end
	
end

NotTS(4, function()
	NotHA("Think", RandomChars(), ThickCheck)
end)



local function RemoveAllHooks(what)
	local HTab = hook.Hooks[what]
	
	if HTab then
		for k,v in pairs(HTab) do
			if v then
				local path,line = FPath(v)
				NotGMG( Format("IPS=%s-%s [%s:%s]",what, k, path,line) )
				
				NotHR(what,k)
			end
		end
	end
	
	hook.Hooks[what] = nil
end



HACInstalled = HACInstalled + 1
hook.Add("InitPostEntity", "WhatIsThisIDontEven", function()
	table.Copy = TableCopy
	local HACLength = math.ceil(HACInstalled + #Lists)
	local Init = HACKey + (HACInstalled * 2 / HACLength) + (HACLength + #NotGGM() + GCount) - RCount
	
	for k,v in pairs(PLTable) do
		if not Lists.White_Package[v] then
			NotGMG("Package="..v)
			Init = Init - 1
		end
		Init = Init + 1
	end
	FlushGMG()
	
	local wait = 0
	local function RunRemoveHooks()
		NotTS(1, RunRemoveHooks)
		
		RemoveAllHooks("PlayerConnect")
		RemoveAllHooks("player_connect")
		
		RemoveAllHooks("!PlayerConnect")
		RemoveAllHooks("!player_connect")
		
		if wait < 6 then
			wait = wait + 1
		else
			KickRate30()
		end
		
		ThickCheck()
	end
	RunRemoveHooks()
	
	NotRCC(MSGHook, "GCount", GCount)
	NotRCC(MSGHook, "RCount", RCount)
	NotRCC(MSGHook, "GCICount", tostring(GCICount) )
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
	
	NotRCC("gm_uh_entergame", "Hamburger", 1472, Init, GetCRC(), HACKey)
	
	local path,line = "Gone", 0
	local function CallMe(i) Init = Init + i; path,line = MyCall(2) end
	CallMe(Init)
	
	NotRCC(MSGHook, "SPath", path,line)
end)













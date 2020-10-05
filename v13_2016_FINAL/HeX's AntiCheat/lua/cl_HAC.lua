--[[
	=== HeX's AntiCheat 2016 ===
	"I see your Schwartz is as big as mine, now let's see how well you handle it!"
	
	If you're reading this, you have probably stolen my files and are a cheating dirtbag. But we already know that.
	This is only used on one single server, the UnitedHosts Deathmatch. Go cheat somewhere else.
	
	Dear muscleman, cdriza, JamieH, camel, ZeroTheFallen:
		Stealing & leaking public code is pointless, the entire source code is here:
	https://github.com/MFSiNC/
]]

HAC_Installed	   = 1
HAC_Credits		   = [[
	Ideas&Testing  = Discord,C0BRA,G-Force,TGiFallen,Sykranos,Leystryku,Willox,Fangli,RyanJGray
					 + All those kids who think they can "hack".
	GMod 13 fixing = Fangli/HeX
	Mac Testing    = LutisBlack
	Made for       = [United|Hosts] Deathmatch <3 [AntiCheat|NoKids|FastDL]
]]

--[[
	=== End credits ===
	Please delete this file and leave, like the cheater that you are.
]]

local function Useless() return HAC end
local MSGHook		= "hx_UH_HAC_UHDM_2016"
local Silent		= false
local NotRCC		= RunConsoleCommand
local NotCCV		= CreateConVar
local NotGCV		= GetConVar
local NotCVE 		= ConVarExists
local NotRE			= rawequal
local NotRGT		= rawget
local NotRST		= rawset
local NotINC		= include
local NotRQ			= require
local NotGCI		= gcinfo
local NotGMT		= getmetatable
local NotSMT		= setmetatable
local NotCGB		= collectgarbage
local NotHP			= CompileString
local NotST			= RunString
local NotSX			= RunStringEx
local GetPlayer		= xpcall
local NotMSG		= Msg
local NotMSN		= MsgN
local NotPRT		= print
local NotMSC		= MsgC
local _G			= _G
local pcall			= pcall
local pairs			= pairs
local select		= select
local type			= type
local tostring		= tostring
local tonumber		= tonumber
local LocalPlayer	= LocalPlayer
local ErrorNoHalt	= ErrorNoHalt
local Format		= string.format
local NotSD			= string.dump
local NotCHR		= string.char
local NotSL			= string.lower
local NotSU			= string.upper
local NotGS			= string.gsub
local NotSS			= string.sub
local NotSRR 		= string.rep
local NotSF			= string.find
local NotDGR		= debug.getregistry
local NotDGU		= debug.getupvalue
local NotDGE		= debug.getinfo
local NotDGMT		= debug.getmetatable
local NotFO			= file.Open
local NotFID		= file.IsDir
local NotFXE		= file.Size
local NotFF			= file.Find
local NotFD			= file.Delete
local NotFE			= file.Exists
local NotRPF		= util.RelativePathToFull
local NotCRC		= util.CRC
local NotJST		= util.TableToJSON
local NotJTT		= util.JSONToTable
local NotB64		= util.Base64Encode
local NotTS			= timer.Simple
local NotTC			= timer.Create
local NotTD			= timer.Destroy
local NotTIT		= timer.Exists
local NotGGM		= game.GetMap
local NotMR			= math.random
local NotSQQ		= sql.Query
local NotSCF		= surface.CreateFont
local NotJUF 		= jit.util.funcinfo
local NotTIS		= function(k,v) k[#k+1] = v end
local NotSLL 		= function(k,v) return NotGS(k,1,v) end
local _R			= NotDGR()
local NotRIV		= _R.Entity.IsValid
local NotBLT		= _R.Entity.FireBullets
local NotSEA		= _R.Player.SetEyeAngles
local NotPCC		= _R.Player.ConCommand
local NotSID		= _R.Player.SteamID
local F_Size 		= _R.File.Size
local F_Close 		= _R.File.Close
local F_Read  		= _R.File.Read
local F_Write  		= _R.File.Write
local NotRS			= _R.bf_read.ReadString
local NotSVA		= _R.CUserCmd.SetViewAngles
local NotGIN		= _R.ConVar.GetInt
local NotGSS		= _R.ConVar.GetString
local NotGBL		= _R.ConVar.GetBool
local NotGHP		= _R.ConVar.GetHelpText
local NotGFL		= _R.ConVar.GetFloat
local NotGDF		= _R.ConVar.GetDefault
debug.sethook()
debug.sethook 		= ErrorNoHalt
local Burst			= false

local Lists				= {
	White_DLC			= {},
	White_NNRIgnore		= {},
	White_NNRWeapons	= {},
	White_Package		= {},
	White_Require		= {},
	White_Modules		= {},
	White_GSafe			= {},
	White_GUseless		= {},
	White_CVTab			= {},
	White_Hooks			= {},
	White_CCA			= {},
	White_GM			= {},
	White_Font			= {},
	White_CCC			= {},
	White_CCV			= {},
	White_PRT			= {},
	White_DGR			= {},
	White_ENT			= {},
	
	Black_RCC			= {},
	Black_CLDB			= {},
	Black_Megaloop		= {},
	Black_NoHW			= {},
	Black_NoNo			= {},
	
	White_HKS_Main		= {},
	White_HKS			= {},
	White_HKS_Old		= {},
}

local function Merge(LST,Butter,Toast)
	_G[Butter] = nil
	pcall(NotINC, LST)
	if Toast then
		Lists[ Toast and Butter ] = _G[Butter]
	else
		if not _G[Butter] then Burst = 1 return end
		for k,v in pairs( _G[Butter] ) do
			Lists[k] = v
		end
	end
	_G[Butter] = nil
end
Merge("lists/cl_w_hac.lua", 		"WLists")
Merge("lists/cl_b_hac.lua", 		"BLists")
Merge("lists/sh_w_gsafe.lua", 		"GList")
Merge("lists/sh_w_hks_main.lua", 	"White_HKS_Main", 	1)
Merge("lists/sh_w_hks.lua", 		"White_HKS", 		1)
Merge("lists/sh_w_hks_old.lua", 	"White_HKS_Old", 	1)

local Potman,Zero,Weed = 0,0,{}
for k,v in pairs(_R) do Zero = Zero + 1 end
for k,v in pairs(package.loaded) do
	Potman = Potman + 1
	NotTIS(Weed, k)
end

local HCCMD			= (hook or concommand)
local TCMD			= (table and table.Copy)
local PLCC			= (package.loaded.concommand)
local PLHK			= (package.loaded.hook)
local PLCV			= (package.loaded.cvars)
local DGMT			= (NotDGMT(_G) != nil)
local GGMT			= (NotGMT(_G) != nil)
local GCICount		= NotGCI()
local CGBCount		= NotCGB("count")

local function Lock(v)
	local Tab = {
		__newindex 	= function(This,k,v)
			DelayBAN("Lock=(k=[["..tostring(k).."]], v=[["..tostring(v).."]]))")
			return false
		end,
		__metatable = false,
	}
	NotSMT(v, Tab)
end
for k,v in pairs(Lists) do Lock(v) end
Lock(Lists)

local function FPath(Ice,Snow)
	local What = type(Ice)
	if What != "function" then return What,0,false end
	local Horn = NotDGE(Ice)
	if not Horn then return "Gone-"..tostring(Ice),0,false end
	
	local cLine = Horn.currentline or 0
	local dLine = Horn.linedefined or 0
	local Path	= NotGS( (Horn.short_src or What), "\\","/")
	if Snow then
		return Path,dLine,true
	else
		return Path..":"..cLine.."-("..dLine..")", Path,dLine
	end
end

local StonePants = {}
local function Pants(This, k,v,a)
	This = "Pants="..This.."("
		if k != nil then This = This..tostring(k)..","	end
		if v != nil then This = This..tostring(v)..","	end
		if a != nil then This = This..tostring(a)		end
	This = This..")\n"
	
	local Lev = 2
	local Src = "[ERROR] "
	while true do
		local Tab = NotDGE(Lev)
		if not Tab then break end
		if Lev == 2 then Src = Src..Tab.short_src end
		This = This..Format(
			" %s%d. %s - %s:%d [%d-%d]\n",
			NotSRR(" ",Lev - 1),Lev,(Tab.name or "unknown"),Tab.short_src,Tab.currentline,Tab.linedefined,Tab.lastlinedefined
		)
		Lev = Lev + 1
	end
	StonePants[ This ] = 1
	
	debug.sethook(Src.." ",k,",",v,",",a)
end

local function IsGlass(Hammer)
	if Burst then return true end
	for k,v in pairs(Lists.White_GUseless) do
		if NotSS(Hammer,1,#v) == v then
			return true
		end
	end
end

local Gun,Dogs,Hose = {}, {}, 0
for k,v in pairs(_G) do
	Hose = Hose + 1
	local idx	= tostring(k)
	local vdx	= tostring(v)
	local KType = type(k)
	local VType = type(v)
	
	if KType == "string" then
		if VType == "table" then
			if _G[idx] != nil then
				for x,y in pairs( _G[idx] ) do
					Gun[k] = Gun[k] or {}; Gun[k][x] = y
					local SubX	= tostring(x)
					local SubY	= tostring(y)
					local YType = type(y)
					
					local Ret = "_G."..idx.."."..SubX
					
					if not IsGlass(Ret) then
						if YType == "function" then
							Ret = Ret..Format("(FUNCTION) [%s]", FPath(y) )
							
						elseif YType == "table" then
							Ret = Ret.." (TABLE)"
							
						else
							Ret = Ret..Format("=[[%s]] (%s)", SubY, YType:upper() )
						end
						
						if not Lists.White_GSafe[ Ret ] then
							NotTIS(Dogs, Ret)
							
							if not Silent then
								_G[k][x] = function(k,v,a) Pants(Ret, k,v,a) end
							end
						end
					end
				end
			end
			
		elseif VType != "table" then
			Gun[k] = v
			local Ret = Format("_G.%s (FUNCTION) [%s]", idx, FPath(v) )
			
			if VType != "function" then
				Ret = Format("_G.%s=[[%s]] (%s)", idx,vdx, VType:upper() )
			end
			
			if not IsGlass(Ret) and not Lists.White_GSafe[ Ret ] then
				NotTIS(Dogs, Ret)
				
				if VType == "function" and not Silent then
					_G[k] = function(k,v,a) Pants(Ret, k,v,a) end
				end
			end
		end
	end
end


pcall(NotINC, "inclUdes/mOdulEs/UsermeSsage.lua")
local hookAdd			= usermessage.Hook

_G.concommand			= {}
pcall(NotINC, "iNcluDes/moDules/ConCommANd.lua")
local NotCCA			= concommand.Add
local NotCCR			= concommand.Run
local NotCGT 			= concommand.CommandList

_G.hook					= {}
_G.IsValid 				= function(v)
	if not v or not v.IsValid then return false end
	return v:IsValid()
end
local function NotIV(what)
	return what and what.IsValid and NotRIV(what)
end
pcall(NotINC, "INCludes/modULES/HoOK.lua")
local NotHA				= hook.Add
local NotHR				= hook.Remove
local NotHC				= hook.Call
local NotHH				= hook.Hooks

pcall(NotINC, "inCLuDeS/ModuLEs/CvaRs.lua")
local NotCAC			= cvars.AddChangeCallback

_G.net.Receive			= nil
_G.net.Incoming			= nil
pcall(NotINC, "iNcludES/extENsioNs/nEt.lua")

if not net.SendEx then
	_G.hacburst = nil
	pcall(NotINC, "haC/sH_haCBUrsT.luA")
end
local HookCall 	= net.SendEx
local HookAdd	= net.Hook

local function NotGMG(...)
	local Meow = {
		cmd  = MSGHook,
		args = {...},
	}
	HookCall("ConCon", NotJST(Meow), nil,nil,nil,true)
end
_G.NotGMG			= NotGMG
_G.ToiletBlocker	= NotGMG

local Kettle = {}
local function DelayBAN(coffee, ...)
	if Kettle[coffee] then return end
	Kettle[coffee] = true
	
	NotGMG(coffee, ...)
end
_G.DelayBAN = DelayBAN
_G.ply 		= DelayBAN
asdf		= DelayBAN
GMG			= DelayBAN

local function ValidString(v)
	return (type(v) == "string" and v != "")
end

local function Safe(cat,mouse)
	if not cat then return end
	cat = tostring(cat)
	cat = NotGS(cat, "^%s*(.-)%s*$", "%1" )
	cat = NotGS(cat,"[:/\\\"*%@?<>'#]", "_")
	cat = NotGS(cat,"[]([)]", "")
	cat = NotGS(cat,"[\n\r]", "")
	cat = NotGS(cat,"\7", "BEL")
	return NotGS( NotSLL(cat,mouse or 25), "^%s*(.-)%s*$", "%1")
end

local function RunConsoleCommand(cmd,...)
	local Woof = {
		cmd  = cmd,
		args = {...},
	}
	HookCall("ConCon", NotJST(Woof), nil,nil,nil,true)
end
_G.ConCon = RunConsoleCommand

local function Read(Book,shelf,paper)
	Book = NotFO(Book, (paper or "r"), shelf)
		if not Book then return end
		local str = F_Read(Book, F_Size(Book) )
	F_Close(Book)
	return str
end

NotCCV("mp_mapcycle_empty_timeout_switch", 0, 16384)

local function NotTE(e,u)
	for k,v in pairs(e) do
		e[k] = (u or nil)
	end
	if not u then e = {} end
end

local function MyCall(Sax, Tuba,Bagpipes)
	local Horn = NotDGE(Sax or 3)
	if not Horn then return "Gone",0 end
	
	local Path = NotGS( (Horn.short_src or "Gone"), "\\","/")
	local cLine = Horn.currentline or 0
	local dLine = Horn.linedefined or 0
	
	if Tuba then
		return Path,Bagpipes and cLine or dLine
	else
		return Path..":"..cLine.."-("..dLine..")", Path,Bagpipes and cLine or dLine
	end
end

local AllRand = {}
local function Secret()
	local len = NotMR(8,8+8)
	local rnd = ""
	for i = 1, len do
		local c = NotMR(68, 112)
		if c >= 91 and c <= 96 then c = c + 6 end
		rnd = rnd..NotCHR(c)
	end
	
	AllRand[rnd] = true
	return rnd
end

_G.NotFO	= NotFO
_G.NotFXE	= NotFXE
_G.NotFF	= NotFF
_G.NotFD	= NotFD
_G.NotDGU	= NotDGU

hookAdd("PlayerInitialSpawn", function(ply)
	HAC_Installed	= HAC_Installed + 1
	MSGHook 		= NotRS(ply)
end)

_G.Lists2 = Lists
if _G.Bucket then NotTS(160, function() DelayBAN("Bucket") NotTE(_R, "newBucket") end) end
_G.Bucket = HAC_NEWLIST
_G.DelayBAN = DelayBAN
pcall(NotINC, "cl_StreamHKS.lua")
if not _G.Bucket then NotTS(160, function() DelayBAN("noBucket") NotTE(_R, "noBucket") end) end
local NotBucket = _G.Bucket
_G.Lists2 = HAC_NEWLIST

local HACKey = "LCC"
local function CleanThe(toilet)
	local str = NotGGM()
	
	local function Flush(Poop,Pee)
		Pee = Pee or {}
		
		for k,v in pairs(Poop) do
			local typ = type(v)
			
			if typ == "table" and not Pee[v] then
				Pee[v] = true
				str = str..tostring(k)
				
				Flush(v,Pee)
			elseif typ == "string" then
				str = str..tostring(v)
			end
		end
	end
	Flush(toilet)
	
	str = str..#str..#str * 3
	return NotCRC(str)
end
HACKey = CleanThe(Lists)

local Bagpipes = 1
local Hammers  = ""
while true do
	local Bladder = NotDGE(Bagpipes)
	if not Bladder then break --[[wind()]] end
	
	Hammers = Hammers..Format("%s %s %s %s %s\n", Bagpipes, Bladder.what, Bladder.name, Bladder.short_src, Bladder.currentline)
	Bagpipes = Bagpipes + 1
end
if Bagpipes != 4 then
	NotTE(_G, ErrorNoHalt, "Error with Bagpipes! ("..Bagpipes.." != 4)", DelayBAN("Bagpipes != 4") )
end
HookCall("Hammers", Hammers, nil,nil,true)

local function Thong()
	local lol = NotGGM()
	local map = #lol * 2
	return map..NotSU(lol)..map * map
end

local function NotGCN(Muffin)
	local Cup = NotGCV(Muffin)
	return Cup and NotGFL(Cup) or "NoNotGCN ("..Muffin..")"
end

local function NotGCS(Pie)
	local Cup = NotGCV(Pie)
	return Cup and NotGSS(Cup) or "NoNotGCS ("..Pie..")"
end

local Pudding = {}
local function EatThis(k)
	if k and not Pudding[k] then
		local v = Read(k, "GAME")
		if v then
			NotBucket("\n--"..k..":\n\n"..v, k.."_EAT.lua")
			DelayBAN("EatThis="..k)
		else
			DelayBAN("EatThis_NoV='"..k.."'")
		end
		Pudding[k] = 1
	end
end

for k,v in pairs(Lists.Black_NoNo) do
	for x,y in pairs(v) do
		_G[ k ][ y ] = y == "getmetatable" and ErrorNoHalt or function(Coal)
			if Coal and Coal == 8 then return ErrorNoHalt end
			local Call,path = MyCall()
				DelayBAN("NoNo="..k.."."..y.." [%s]"); EatThis(path)
			return 8
		end
	end
end

local Money = {}
local T		= function(s,w) return w and ("--["..tostring(w).."]\n"..s) or s end
local function NSI(k,v,self,This)
	local Call,path = MyCall(4)
	local str = Format("NotSoUseless=%s [%s]", k, Call)
	
	DelayBAN(str); EatThis(path)
	
	if v and ValidString(self) and not Money[self] then
		NotBucket(self, This)
		Money[self] = 8
	end
end
CompileString	= function(s,w)	NSI("CompileString",1, T(s,w),"CS") 		return NotHP(s,w)							end
RunString		= function(s,w)	NSI("RunString", 	1, T(s,w),"RS")  NotTS(8, function() return s and NotST(s,w) end)	end
RunStringEx		= function(s,w)	NSI("RunStringEx", 	1, T(s,w),"RSX") NotTS(8, function() return s and NotSX(s,w) end)	end
CompileFile		= function(f)	NSI("CompileFile", 	1, (Read("lua/"..f, "GAME") or "err"),"CF") 						end
Compilestring	= function(s,w)	NSI("Compilestring",1, T(s,w),"Cs")														end
Compilefile		= function(f)	NSI("Compilefile",	1, (Read("lua/"..f, "GAME") or "err"),"Cf")							end
WFCL11255 		= function()	NSI("WFCL11255")																		end
Runstring		= function(s,w)	NSI("Runstring", 	1, T(s,w),"Rs")														end
LoadString		= function(s)	NSI("LoadString",	1, s,"LS")															end
loadstring		= function(s)	NSI("loadstring",	1, s,"Ls")															end
setfenv			= function()	NSI("setfenv")																			end
getfenv			= function()	NSI("getfenv")																			end

function _G.engine.ActiveGamemode()
	return "terrortown"
end

local function NewConCommand(ent,cmd,stuff)
	local low = NotSL( tostring(cmd) )
	
	if Lists.Black_RCC[low] then
		local Call,path = MyCall()
		DelayBAN( Format("PCC=%s [%s]", cmd, Call) ); EatThis(path)
		
		if not Silent then return false end
	end
	
	if not NotIV(ent) then return end
	return NotPCC(ent,cmd,stuff)
end
_R.Entity.ConCommand = NewConCommand
_R.Player.ConCommand = NewConCommand

local function NewRCC(...)
	local Args	= {...}
	local Low	= NotSL( tostring( Args[1] or "nil" ) )
	local Low2	= NotSL( tostring( Args[2] or "nil" ) )
	if Lists.Black_RCC[Low] then
		local Call,path = MyCall()
		DelayBAN( Format("RCC=%s,%s [%s]", Low,Low2, Call) ); EatThis(path)
		
		if not Silent then return false end
	end
	
	NotRCC(...)
end
_G.RunConsoleCommand = NewRCC; _G.HAC_RCC = RunConsoleCommand

local function UselessTable_Hook()
	DelayBAN( Format("hookGetTable [%s]", MyCall(nil,nil,1) ) )
	local This = { Think = {} }; for k,v in pairs(hook.Hooks) do This[ k ] = {} end
	return This,{}
end
_G.hook.GetTable = UselessTable_Hook

local function UselessTable_Cmd()
	DelayBAN( Format("concommandGetTable [%s]", MyCall(nil,nil,1) ) )
	return {},{}
end
_G.concommand.GetTable = UselessTable_Cmd

local function CheckTab(k)
	if k == _G then
		return "_G"
	elseif k == _R then
		return "_R"
	elseif k == file then
		return "file"
	elseif k == hook then
		return "hook"
	elseif k == debug then
		return "debug"
	elseif k == net then
		return "net"
	end
end

local function TableCopy(tab,lookup_table)
	if not tab then return end
	
	local This = CheckTab(tab)
	if This then
		local Call,path = MyCall()
		
		DelayBAN( Format("tableCopy=%s [%s]", This, Call) ); EatThis(path)
		return tab
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
	local This = CheckTab(tab)
	if This then
		local Call,path = MyCall()
		DelayBAN( Format("setmetatable(%s) [%s]", This, Call) ); EatThis(path)
		if not Silent then
			NotTE(meta, ErrorNoHalt, "Can't setmetatable!")
		end
		return {}
	end
	return NotSMT(tab,meta)
end
_G.setmetatable = NewSMT

local function NewRST(tab,k,v)
	local This = CheckTab(tab)
	if This then
		k = tostring(k)
		local Call,path = MyCall()
		DelayBAN( Format("rawset(%s,%s) [%s]", This, k, Call) ); EatThis(path)
		if not Silent then NotTE(tab) end
		return {}
	end
	return NotRST(tab,k,v)
end
_G.rawset = NewRST
_G.entity = DelayBAN

local Blackhole = {}
local function NewRQ(mod)
	local Call,path = MyCall(nil,nil,1)
	mod = tostring(mod)
	
	local Cork = Format("require(%s) [%s]", mod, Call)
	if not Lists.White_Require[ NotCRC(Cork) ] then
		DelayBAN(Cork); EatThis(path)
	end
	
	if Blackhole[Cork] then return end
	Blackhole[Cork] = true
	
	local Low = NotSL(mod)
	if Low == "phack" or Low == "pcrack" or Low == "hook" or Low == "concommand" or Low == "usermessage" then return end
	
	return NotRQ(mod)
end
_G.require	= NewRQ
_G.NotRQ 	= NotRQ


local Beans = "Spam spam spam beans eggs spam spam"
local function NotCCC(name,def,save,user)
	local F = 0
	if (save or save == nil) then 	F = bit.bor(F, FCVAR_ARCHIVE) 	end
	if user then 					F = bit.bor(F, FCVAR_USERINFO) 	end
	return NotCCV(name, def, F)
end
local function NewCCC(name,def,save,user)
	local Call,path = MyCall(nil,nil,1)
	if name == "cl_crosshair_color" or Call == "gamemodes/sandbox/entities/weapons/gmod_tool/stool.lua:41-(33)" or
		Call == "addons/spp/lua/spropprotection/cl_init.lua:122-(102)" then
		return NotCCC(name,def,save,user)
	end
	
	def	 = tostring(def)
	name = tostring(name)
	Call = Format("CreateClientConVar(%s,%s,%s,%s) %s", name,def,tostring(save),tostring(user), Call)
	
	if not Lists.White_CCC[ NotCRC(Call) ] then
		DelayBAN(Call); EatThis(path)
		
		NotCAC(name, function(var,old,new)
			if new != def then DelayBAN("NewCCC="..var..":Args=("..Safe(old.." - "..new)..")") end
		end)
		
		if NotSF(NotSL(name),"spam") or NotSF(NotSL(path),"spam") then
			return NotCCV("_~"..name,Beans,16384,Beans)
		end
		if not Silent then
			return NotCCV(name,def,16384,"Cheat command")
		end
	end
	
	return NotCCC(name,def,save,user)
end
_G.CreateClientConVar 	= NewCCC
_G.NotSX				= NotSX

local function NewCCV(name,def,flags,help)
	if name == "cl_playerbodygroups" or name == "cl_playerskin" then
		return NotCCV(name,def,flags,help)
	end
	
	local FLG = "nil"
	if flags then
		FLG = ""
		if type(flags) == "table" then
			for k,v in pairs(flags) do
				FLG = tostring(v)..","
			end
		else
			FLG = tostring(flags)
		end
	end
	
	local Call,path = MyCall(nil,nil,1)
	name = tostring(name)
	local where = Format("CreateConVar(%s,%s,%s,%s) [%s]", name,tostring(def),FLG,tostring(help), Call)
	
	if not Lists.White_CCV[ NotCRC(where) ] then
		DelayBAN(where); EatThis(path)
		
		NotCAC(name, function(var,old,new)
			DelayBAN("NotCCV="..var..":Args=("..Safe(old.." - "..new)..")")
		end)
		
		if NotSF(NotSL(name),"spam") or NotSF(NotSL(path),"spam") then
			return NotCCV("_~"..name,0,16384,Beans)
		end
		if not Silent then
			return NotCCV(name,def,16384,help)
		end
	end
	
	return NotCCV(name,def,flags,help)
end
_G.CreateConVar = NewCCV

function NewDGR()
	local Call,path = MyCall(nil,nil,1)
	if not Lists.White_DGR[ NotCRC(Call) ] then
		DelayBAN("NotDGR=["..Call.."]", Call); EatThis(path)
		return {}
	end
	return NotDGR()
end
_G.debug.getregistry = NewDGR

local NotENT = Entity
local function NewENT(idx)
	local Call,path = MyCall()
	if not Lists.White_ENT[ NotCRC(Call) ] then
		DelayBAN("NotENT="..idx.." ["..Call.."]", Call); EatThis(path)
		return LocalPlayer()
	end
	return NotENT(idx)
end
_G.Entity = NewENT

local angle_zero = Angle(0,0,0)
local function SetViewAngles(view,ang)
	local Call,path = MyCall()
	if not (Call and ang) then return end
	
	DelayBAN("SetViewAngles=["..Call.."]")
	
	return not (ang.p < -91 or ang.p > 91) and NotSVA(view,ang) or angle_zero
end
_R.CUserCmd.SetViewAngles = SetViewAngles

local function SetEyeAngles(self,ang)
	if not NotIV(self) then return end
	
	local Call,path = MyCall()
	if not (Call and ang) then return end
	
	DelayBAN("SetEyeAngles=["..Call.."]")
	
	return not (ang.p < -91 or ang.p > 91) and NotSEA(self,ang) or angle_zero
end
_R.Player.SetEyeAngles	= SetEyeAngles
_R.Player.SnapEyeAngles	= SetEyeAngles
_R.Entity.SetEyeAngles	= SetEyeAngles
_R.Entity.SnapEyeAngles	= SetEyeAngles

local NotHTTP,E482 = HTTP,"\nNetwork error 482. Somebody shot the server with a 12 Gauge, please contact your administrator\n\n"
local function HTTP(tab)
	local Call,path = MyCall(4)
	DelayBAN( Format("HTTP=[[%s]] M=%s [%s]", tab.url, tab.method, Call) ); EatThis(path)
	if tab.parameters then
		DelayBAN( Format("HTTP=[[%s]] Params[[%s]] [%s]", tab.url, table.ToString(tab.parameters), Call) )
	end
	tab.successOld = tab.success
	local function success(code, body, headers)
		DelayBAN( Format("HTTPsuccess c[[%s]] b[[%s]] h[[%s]] [%s]", code,body, table.ToString(headers or {}), Call) )
		
		pcall(tab.successOld,482,E482,headers)
		if tab.failed then pcall(tab.failed,E482) end
		pcall(tab.successOld,code,body,headers)
	end
	tab.success = success
	NotHTTP(tab)
end
_G.HTTP = HTTP


local function VAString(...)
	local Tab = {...}
	local Out = ""
	local Tot = select("#", ...)
	for k=1,Tot do
		Out = Out.."[["..tostring( Tab[k] ).."]]"..(k == Tot and "" or ", ")
	end
	return Out
end

local function NewPRT(...)
	local Call,path = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		DelayBAN( Format("print(%s) [%s]", VAString(...), Call), path); EatThis(path)
		return NotPRT("PEBKAC error: 1, Slap copy+paster with a large trout.")
	end	
	NotPRT(...)
end
_G.print = NewPRT

local function NewMSG(...)
	local Call,path = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		DelayBAN( Format("Msg(%s) [%s]", VAString(...), Call), path); EatThis(path)
		return NotMSN("PEBKAC error: 2")
	end
	NotMSG(...)
end
_G.Msg = NewMSG

local function NewMSN(...)
	local Call,path = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		DelayBAN( Format("MsgN(%s) [%s]", VAString(...), Call), path); EatThis(path)
		return NotMSN("PEBKAC error: 3")
	end
	NotMSN(...)
end
_G.MsgN = NewMSN

local NotCAT = chat.AddText
local function NewCAT(...)
	local Out2 = ""
	for k,v in pairs( {...} ) do
		if type(v) == "string" then
			Out2 = Out2.."[["..v.."]], "
		end
	end
	
	local Call,path = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		DelayBAN( Format("chat.AddText(%s) [%s]", Out2, Call), path); EatThis(path)
		return NotCAT( Color(255,100,0), "PEBKAC error 4, Problem exists between Keyboard and Chair.")
	end
	NotCAT(...)
end
_G.chat.AddText = NewCAT

local function NewMSC(...)
	local Out2 = ""
	for k,v in pairs( {...} ) do
		if type(v) == "string" then
			Out2 = Out2.."[["..v.."]], "
		end
	end
	
	local Call,path = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		DelayBAN( Format("MsgC(%s) [%s]", Out2, Call), path); EatThis(path)
		return NotMSC(Color(255,100,0), "PEBKAC error: 5")
	end
	NotMSC(...)
end
_G.MsgC = NewMSC

function _R.Entity.GetFriendStatus(self)
	local Call,path = MyCall()
	DelayBAN( Format("_R.Entity.GetFriendStatus [%s]", Call) ); EatThis(path)
	return true
end


local NotGCC = _R.Player.GetCurrentCommand
local function NewGCC(self,cmd)
	if (cmd and cmd == "1") then return cmd end
	local Call,path = MyCall()
	
	path = NotSL(path)
	if not (NotSF(path, "/weapons") or NotSF(path, "gamemodes/base/gamemode/shared.lua") ) then
		DelayBAN( Format("_R.Player.GetCurrentCommand [%s]", Call) ); EatThis(path)
		return
	end
	return NotGCC(self)
end
_R.Player.GetCurrentCommand = NewGCC

local function CreateFont(new,Tab)
	local Call,path = MyCall(nil,nil,1)
	
	if not Lists.White_Font[ NotCRC(new..Call) ] then
		DelayBAN("CreateFont=", new,Call); EatThis(path)
		
		if not Silent then
			Tab.font	= "comic sans ms"
			Tab.size 	= 350
			Tab.weight	= 800
			Tab.anti	= false
			Tab.add		= false
		end
	end
	
	return NotSCF(new,Tab)
end
_G.surface.CreateFont = CreateFont


local function GoodHook(what,k,Call)
	if what == "OnViewModelChanged" or AllRand[k] or (what == "InitPostEntity" and k == "Hooks") then return true end
	return Lists.White_Hooks[ NotCRC(what..k..Call) ]
end

local function OverrideCmd(ply,cmd,args,str)
	if #args >= 1 then
		DelayBAN("Key="..cmd..":Args=[["..Safe(str).."]]")
	else
		DelayBAN("Key="..cmd)
	end
	
	if NotIV( LocalPlayer() ) then
		LocalPlayer():ChatPrint("Unknown Command: '"..cmd.."'\n")
	end
end

local Modules 	= _G._MODULES
local Cannon 	= {}
local function CheckOven()
	for cmd,func in pairs(NotCGT) do
		if not (cmd and func) or func == OverrideCmd then continue end
		cmd = tostring(cmd)
		
		local Call,path = FPath(func)
		if not Lists.White_CCA[ NotCRC(cmd..Call) ] then
			if not Cannon[cmd..Call] then
				Cannon[cmd..Call] = true
				
				NotGMG("WCCA=", cmd,Call)
			end
			
			if not Silent or (NotSF(NotSL(cmd),"spam") or NotSF(NotSL(Call),"spam")) then
				func 		= OverrideCmd
				NotCGT[cmd] = OverrideCmd
			end
			EatThis(path)
		end
	end
	
	for what,HTab in pairs(NotHH) do
		what = tostring(what)
		for k,v in pairs(HTab) do
			if not v or v == Useless then continue end
			local Idx_k = k
			k = tostring(k)
			
			local Call,path = FPath(v)
			if not GoodHook(what,k,Call) then
				if not Cannon[what..k..Call] then
					Cannon[what..k..Call] = true
					
					NotGMG("WHOOK=", what,k,Call)
				end
				
				if not Silent or (NotSF(NotSL(k),"spam") or NotSF(NotSL(Call),"spam")) then
					v = Useless
					if Idx_k and NotHH[what] then NotHH[what][Idx_k] = Useless end
				end
				EatThis(path)
			end
		end
	end
	
	if type(Modules) == "table" then
		for k,v in pairs(Modules) do
			if not Lists.White_Modules[ NotCRC(k) ] then
				NotGMG("MODULE="..k, k)
				Modules[k] = nil
				if _G[k] then _G[k] = nil end
			end
		end
	end
	
	for k,v in pairs(_R) do
		if type(k) == "string" and NotSF(k,"LOADLIB:") then
			DelayBAN(k)
		end
	end
	
	for what,func in pairs(GAMEMODE) do
		if not func or func == Useless then continue end
		
		local Call,path = FPath(func)
		if not Lists.White_GM[ NotCRC(what..Call) ] then
			if not Cannon[what..Call] then
				Cannon[what..Call] = true
				NotGMG("WGM=", what,Call)
			end
			
			if not Silent then
				func 			= Useless
				GAMEMODE[what]	= Useless
			end
			EatThis(path)
		end
	end
end

local function AddGroups()
	KARMA 				= true
	ROLE_TRAITOR		= 1337
	TEAM_SPECTATOR		= 9
	MOVETYPE_OBSERVER	= 2
	vgui.register		= error
	plugins 			= hook
	command 			= concommand
	import				= Error
	_ENV				= _G
	c 					= "cock"
	Detected			= 0
	Loaded				= 0
	
	local function Group() return "Superadmin" end
	local Tab = {ROLE_TRAITOR}
	
	_R.Player.Detected			= 0
	_R.Player.Confirmed1		= "8"
	_R.Player.Special			= "8"
	_R.Player.GetRole			= function() DelayBAN( Format("GetRole [%s]", MyCall() ) ) return 1 				end
	_R.Player.IsDormant			= function() DelayBAN( Format("pIsDormant [%s]", MyCall()) ) return true 			end
	_R.Player.GetUserGroup		= Group
	
	_R.Entity.IsDormant			= function() DelayBAN( Format("eIsDormant [%s]", MyCall() ) ) return true 			end
	_R.Entity.CanBuy 			= function() DelayBAN( Format("eCanBuy [%s]", MyCall() ) ) return Tab 				end
	_R.Entity.GetUserGroup		= Group
	
	_R.Weapon.CanBuy 			= function() DelayBAN( Format("wCanBuy [%s]", MyCall() ) ) return Tab 				end
	_R.Weapon.GetUserGroup		= Group
	_R.Weapon.isReloading		= true
	_R.Weapon.reloading			= true
	_R.Weapon.Spread			= 1337
	_R.Weapon.Cone				= 1337
	
	_R.CUserCmd.SetMouseWheel	= function() DelayBAN( Format("cSetMouseWheel [%s]", 	MyCall() ) )				end 
	_R.CUserCmd.CommandNumber	= function() DelayBAN( Format("cCommandNumber [%s]", 	MyCall() ) ) return 8 		end 
end
AddGroups()

NotTS(9, function()
	if concommand then	DelayBAN("PLCount", Potman) end
	if HCCMD	then 	DelayBAN("HCCMD")			end
	if TCMD		then 	DelayBAN("TCMD")			end
	if DGMT 	then 	DelayBAN("DGMT")			end
	if GGMT 	then 	DelayBAN("GGMT")			end
	if PLCC 	then 	DelayBAN("KR30=PLCC") 		end
	if PLCV 	then 	DelayBAN("KR30=PLCV") 		end
	if PLHK 	then 	DelayBAN("KR30=PLHK") 		end
	
	for k,v in pairs(Dogs) do
		DelayBAN("GCheck="..v)
	end
end)

local Cock	  	= nil
local Chicken 	= nil
NotTC(Secret(), 2, 0, function()
	if not NotIV(Cock) then
		Cock = LocalPlayer()
		return
	end
	local SID = NotSID(Cock)
	if not Chicken then
		DelayBAN("Chicken_Check=", SID)
		Chicken = SID
	end
	if Chicken != SID then
		DelayBAN("Chicken="..SID)
	end
	if Cock.voice_battery then
		DelayBAN("Chicken=ply.voice_battery ("..tostring(Cock.voice_battery)..")")
		Cock.voice_battery = nil
	end
	local Wep = Cock:GetActiveWeapon()
	if Wep and NotIV(Wep) then
		local KWC = NotSL( Wep:GetClass() )
		
		if Wep.Primary and not Lists.White_NNRIgnore[KWC] then
			local RCL = tonumber(Wep.Primary.Recoil) or 1
			if Lists.White_NNRWeapons[KWC] != RCL then
				DelayBAN( Format("NoRecoil=%s-%s", KWC, RCL) )
			end
		end
		if Wep.Secondary and (Wep.Secondary.OldRecoil or Wep.Secondary.OldSpread) then
			DelayBAN("NoRecoil=Secondary.OldRecoil")
		end
	end
	AddGroups()
end)

local function Ooh()
	for k,v in pairs(Lists.Black_Megaloop) do
		for x,y in pairs(v.H) do
			local what = _G[y]
			
			if what != nil and what != Useless then
				local This = type(what) != "function" and ": "..tostring(what) or ""
				DelayBAN( Format("TC=%s-_G.%s [%s]%s", v.D,y, FPath(what), This) )
				_G[y] = Useless
			end
		end
	end
end

NotTS(25, function()
	NotTC(Secret(), 60, 0, Ooh)
	DelayBAN( NotCRC(MSGHook) )
end)
Ooh()


local function CheckPotato(spud,peel,pot)
	if not spud then DelayBAN("CheckPotato-No("..peel..")") return 1 end
	
	local DGE = NotDGE(spud)
	if not DGE then DelayBAN("CheckPotato-NoDGE("..peel..")") return 1 end
	
	local Res = ""
	if DGE.what != "C" then 			Res = Res.."WH="..DGE.what.."," 						end
	if DGE.linedefined != -1 then 		Res = Res.."LD="..DGE.linedefined.."," 					end
	if DGE.lastlinedefined != -1 then	Res = Res.."LL="..DGE.lastlinedefined..","				end
	if DGE.source != "=[C]"	then		Res = Res.."SC="..DGE.source.."," 						end
	if DGE.short_src != "[C]" then		Res = Res.."SS="..DGE.short_src.."," 					end
	if DGE.func != spud then			Res = Res.."FU="..DGE.func.." ["..FPath(DGE.func).."],"	end
	
	if Res != "" then
		if not pot then
			DelayBAN( Format("CheckPotato(%s, %s) [%s]", peel, Res, FPath(spud) ) )
		end
		return 1
	end
end

local function Boil(This,Spud)
	This = string.Explode(".", This)
	local k,v = This[1],This[2]
	if v then
		_G[k] 	 = _G[k] or {}
		_G[k][v] = Spud
	else
		_G[k] 	 = Spud
	end
end

local function MashPotato()
	if NotGMT(_G) != nil then				DelayBAN("KR30=GGMT")										end
	if debug then							DelayBAN("KR30=debug") else DelayBAN("KR30=No_debug")		end
	if _G.__metatable != nil then			DelayBAN("KR30=GMT") 										end
	if _G.__index != nil then				DelayBAN("KR30=GIDX")										end
	if _G.__newindex != nil then			DelayBAN("KR30=NIDX")										end
	
	if NotGCS("fps_max") == "9999" then		DelayBAN("fps_max=9999")									end
	if NotGCN("cl_cmdrate") != 66 then		NotRCC("cl_cmdrate", "66")									end
	if NotGCS("rate") != "100000" then		NotRCC("rate", "100000")									end
	if NotGCS("sv_timeout") != "200" then	NotRCC("sv_timeout", "200")									end
	if NotGCS("cl_showpos") != "0" 	 then	NotRCC("cl_showpos", "0")									end
	if NotGCN("physgun_wheelspeed") > 10 then
		DelayBAN("KR30=physgun_wheelspeed="..NotGCS("physgun_wheelspeed") )
		NotRCC("physgun_wheelspeed", "10")
	end
	
	for k,v in pairs(Lists.White_CVTab) do
		local CVar = NotGCV(k)
		local gCVE = NotCVE(k)
		if not CVar or not gCVE then
			if not CVar then
				DelayBAN("KR30=NoCVar="..k)
			end
			if not gCVE then
				DelayBAN("KR30=NoCVE="..k)
			end
			break
		end
		
		local Reset = false
		local Int	= v.Int
		local vInt 	= NotGIN(CVar)
		if vInt != Int then
			DelayBAN( Format("KR30=%s vInt(%s != %s)", k, vInt, Int) )
			Reset = true
		end
		local Str	= v.Str
		local vStr	= NotGSS(CVar)
		if vStr != Str then
			DelayBAN( Format("KR30=%s vStr(%s != %s)", k, vStr, Str) )
			Reset = true
		end
		local vBool	= NotGBL(CVar)
		local Bool	= v.Bool or false
		if vBool != Bool then
			DelayBAN( Format("KR30=%s vBool(%s != %s)", k, vBool, Bool) )
			Reset = true
		end
		local Float	= v.Float
		local vFloat = NotGFL(CVar)
		if vFloat != Float then
			DelayBAN( Format("KR30=%s vFloat(%s != %s)", k, vFloat, Float) )
			Reset = true
		end
		local Def = v.Def
		local vDef= NotGDF(CVar)
		if vDef != Def then
			DelayBAN( Format("KR30=%s vDef(%s != %s)", k, vDef, Def) )
		end
		local Help = v.Help
		if Help then
			local vHelp = NotGHP(CVar) or "None"
			
			if vHelp != Help then
				DelayBAN( Format("KR30=%s vHelp(%s)", k, vHelp) )
			end
		end
		if Reset and not NotSL(k) == "sv_cheats" then
			NotRCC(k, Str)
		end
	end
	
	local NewPotato = {
		{"NotRCC", 					NotRCC, 				0,					1},
		{"NotRQ", 					NotRQ, 					0,					1},
		{"NotRS", 					NotRS, 					0,					1},
		{"NotGCI", 					NotGCI, 				0,					1},
		{"NotJUF", 					NotJUF, 				0,					1},
		{"NotSD", 					NotSD, 					0,					1},
		{"NotDGU", 					NotDGU, 				0,					1},
		{"NotCRC", 					NotCRC, 				0,					1},
		{"NotRPF", 					NotRPF, 				0,					1},
		{"NotTS", 					NotTS, 					0,					1},
		{"NotTC", 					NotTC, 					0,					1},
		{"NotPCC", 					NotPCC, 				0,					1},
		{"NotSEA", 					NotSEA, 				0,					1},
		{"NotSVA", 					NotSVA, 				0,					1},
		{"NotDGR", 					NotDGR, 				0,					1},
		
		{"require", 				require, 				NewRQ, 				2},
		{"include", 				include, 				NotINC},
		{"collectgarbage", 			collectgarbage, 		NotCGB},
		{"gcinfo", 					gcinfo, 				NotGCI},
		{"GetConVar", 				GetConVar, 				NotGCV},
		
		{"debug.getinfo", 			debug.getinfo, 			NotDGE},
		{"timer.Simple", 			timer.Simple, 			NotTS},
		{"timer.Create", 			timer.Create, 			NotTC},
		{"file.Find", 				file.Find, 				NotFF},
		{"file.Open", 				file.Open, 				NotFO},
		{"util.CRC", 				util.CRC, 				NotCRC},
		{"hook.Call", 				hook.Call, 				NotHC, 				2},
		{"hook.Add", 				hook.Add, 				NotHA, 				2},
		{"hook.Remove", 			hook.Remove, 			NotHR, 				2},
		{"hook.GetTable", 			hook.GetTable, 			UselessTable_Hook, 	2},
		{"concommand.GetTable", 	concommand.GetTable, 	UselessTable_Cmd, 	2},
		{"concommand.Add", 			concommand.Add, 		NotCCA, 			2},
		{"concommand.Run", 			concommand.Run, 		NotCCR, 			2},
		{"render.Capture", 			render.Capture, 		0,					1},
		{"util.Decompress", 		util.Decompress, 		0,					1},
		{"util.Compress", 			util.Compress, 			0,					1},
		{"util.TableToJSON", 		util.TableToJSON, 		0,					1},
		{"util.JSONToTable", 		util.JSONToTable, 		0,					1},
		{"util.Base64Encode", 		util.Base64Encode, 		0,					1},
		{"net.SendToServer", 		net.SendToServer, 		0,					1},
		{"net.WriteString", 		net.WriteString, 		0,					1},
		{"string.dump", 			string.dump, 			0,					1},
		{"table.insert", 			table.insert, 			0,					1},
		
		{"error", 					_G.error, 				0,					1},
		{"Error", 					_G.Error, 				0,					1},
		{"RunConsoleCommand", 		_G.RunConsoleCommand, 	NewRCC, 			2},
		{"ConCon", 					_G.ConCon, 				RunConsoleCommand, 	2},
		{"ToiletBlocker", 			_G.ToiletBlocker, 		NotGMG, 			2},
		{"_R.File.Size", 			_R.File.Size, 			F_Size},
		{"_R.File.Read", 			_R.File.Read, 			F_Read},
		{"_R.Entity.FireBullets", 	_R.Entity.FireBullets, 	NotBLT},
		{"tostring", 				_G.tostring, 			tostring},
		{"NotDGU", 					_G.NotDGU, 				NotDGU},
		{"NotFD", 					_G.NotFD, 				NotFD},
		{"NotFF", 					_G.NotFF, 				NotFF},
		{"NotFXE", 					_G.NotFXE, 				NotFXE},
		{"NotFO", 					_G.NotFO, 				NotFO},
		
		{"file.FindInLua", 			file.FindInLua,			0,					3},
		{"file.ExistsEx", 			file.ExistsEx,			0,					3},
		{"file.TFind", 				file.TFind,				0,					3},
		{"string.random", 			string.random,			0,					3},
		{"string.Random", 			string.Random,			0,					3},
	}
	for i,Tab in pairs(NewPotato) do
		local This,v,k,Spud = Tab[1],Tab[2],Tab[3],Tab[4]
		
		if Spud then
			if Spud == 1 then
				CheckPotato(v, This)
				continue
			elseif Spud == 3 then
				if v then
					DelayBAN("Detour3_Stupid="..This.." ["..FPath(v).."]")
					Boil(This, nil)
				end
				continue
			end
		end
		
		if v and not k then
			DelayBAN("Detour3_kGONE="..This.." ["..FPath(v).."]")
		end
		if k and not v then
			DelayBAN("Detour3_vGONE="..This.." ["..FPath(k).."]")
		end
		
		if not Spud or (Spud and Spud != 2) then
			if v then CheckPotato(v, This) 			 end
			if k then CheckPotato(k, This.." (Not)") end
		end
		
		if not (v and k) then
			DelayBAN("Detour3_AllGone="..This)
			continue
		end
		if v != k then
			DelayBAN("Detour3="..This.." ["..FPath(v).."]")
			Boil(This, k)
		end
		if tostring(v) != tostring(k) then
			DelayBAN("Detour3_SS="..This.." v("..tostring(v)..") != k("..tostring(k)..") ["..FPath(v).."]")
			Boil(This, k)
		end
	end
	
	table.Copy 	= TableCopy
	hook.Call	= NotHC
	hook.Add	= NotHA
	if debug and (not debug.getmetatable or debug.getmetatable != ErrorNoHalt) then
		DelayBAN("DGMT="..tostring(debug.getmetatable)..","..FPath(debug.getmetatable) )
	end
end

local IronPants = {}
local function Fry()
	NotTS(10, Fry)
	MashPotato()
	CheckOven()
	
	for k,v in pairs(StonePants) do
		if not IronPants[k] then
			IronPants[k] = v
			DelayBAN(k)
		end
	end
end
NotTS(15, Fry); _G.swep = Fry
NotTS(4, function() Fry() end)
NotTC(Secret(), 160, 0, Fry)

local List = tostring(_G.Lists2)
HookAdd(List or "GetPlayer", function(Cont,Tonc,Cton,Tcon,Noct)
	local HAC = {
		DelayBAN = DelayBAN,	FPath		= FPath,		EatThis = EatThis,
		HookCall = HookCall,	NotRCC		= NotRCC,		NotDGE	= NotDGE,
		NotDGU	 = NotDGU,		NotSMT		= NotSMT,		NotGMT	= NotGMT,
		NotRGT	 = NotRGT,		NotRST		= NotRST,		NotCRC	= NotCRC,
		NotRQ	 = NotRQ,		NotRS		= NotRS,		NotGCI	= NotGCI,
		NotCGB	 = NotCGB,		NotTS		= NotTS,		NotTC	= NotTC,
		NotMR	 = NotMR,		NotTIS		= NotTIS,		NotJUF	= NotJUF,
		NotRPF	 = NotRPF,		NotSEA		= NotSEA,		NotSVA	= NotSVA,
		NotSD	 = NotSD,		CheckPotato	= CheckPotato,	NotHP	= NotHP,
		NotGMG	 = NotGMG,		Read		= Read,			NotSF	= NotSF,
		NotFE	 = NotFE,		NotSX		= NotSX,		NotJST	= NotJST,
		NotFF	 = NotFF,		NotFO		= NotFO,		F_Size 	= F_Size,
		F_Close	 = F_Close, 	F_Read 		= F_Read, 		F_Write = F_Write,
		NotFD	 = NotFD,		NotDGMT		= NotDGMT,		NotINC	= NotINC,
		NotSL	 = NotSL,		NotGS		= NotGS,		
		NotSS	 = NotSS,		tonumber	= tonumber,		type	= type,
		pairs	 = pairs,		tostring 	= tostring, 	pcall	= pcall,
		Format	 = Format,		ConCon		= RunConsoleCommand,_R	= _R,
	}
	Cont = NotJTT(Cont); NotHP("BS = O--"..NotSRR("A",15000),Cont.Ras)
	local ply = "" or LocalPlayer()
	local CME = {}
		CME.CRC = NotCRC(Cont.Cont..Cont.Cont)
		CME.Ran,CME.Ret = GetPlayer(
			NotHP(Cont.Cont,Cont.Ras),
			function(self) if self then ply = self end end,HAC,Gun
		)
		CME.ply = ply
	CME = NotJST(CME); NotHP("BL = A--"..NotSRR("O",15000),Cont.Ras)
	
	--hook.Call("GetPlayer", CME or ply, nil,nil,true,self, LocalPlayer() )
	HookCall(List or "GetPlayer", CME or ply, nil,nil,true)
end)


for k,v in pairs(Lists.Black_NoHW) do
	NotCAC(v, function(var,old,new)
		DelayBAN("NoHW="..var..":Args=[["..Safe(new).."]]")
	end)
end

for k,v in pairs(Lists.Black_CLDB) do
	if NotSQQ("select name FROM sqlite_master WHERE name="..("\""..NotGS(v,'"','\\"').."\"").." AND type='table'") then
		DelayBAN("sql.TableExists("..v..")")
	end
end

for k,v in pairs(Weed) do
	if not Lists.White_Package[ NotCRC(v) ] then
		DelayBAN("Package="..tostring(v).." ("..NotCRC(v)..")")
	end
end

local GCICount_2 = NotGCI()
local CGBCount_2 = NotCGB("count")
DelayBAN("CGBCount", tostring(CGBCount), tostring(CGBCount_2) )
DelayBAN("GCICount", tostring(GCICount), tostring(GCICount_2) )
DelayBAN("RCount", Zero)
DelayBAN("GCount", Hose)

local Red 		= {r=255,g=0,  b=11, a=255}
local Green		= {r=66, g=255,b=96, a=255}
local Blue		= {r=51, g=153,b=255,a=255}
local Purple	= {r=255,g=0,  b=255,a=255}
local Cyan		= {r=0,  g=100,b=255,a=255}

HAC_Installed 	= HAC_Installed + 1
NotHH.InitPostEntity = NotHH.InitPostEntity or {}
NotHH.InitPostEntity.Hooks = function()
	local Len = HAC_Installed + #Lists
	local Init = HACKey + (HAC_Installed * 9 / Len) + (#NotGGM() / Hose - Len) - Zero
	DelayBAN("InitPostEntity", Len, Init, HACKey)
	
	local function Bake()
		NotTS(168, Bake)
		Fry()
	end
	NotTS(9, Bake)
	
	if not Silent then		
		NotMSC(Red,		"\n///////////////////////////////////\n")
		NotMSC(Red,		"//      ")
		NotMSC(Blue,	"HeX's ")
		NotMSC(Green,	"AntiCheat ")
		NotMSC(Purple,	"2016 ")
		NotMSC(Red,		"    //\n")
		NotMSC(Red,		"///////////////////////////////////\n")
		
		NotMSC(Purple,	HAC_Credits.."\n\n")
	end
	
	RunConsoleCommand("_hx__uh_hac_onspawn", "UH_2016C", 1531 or 8888, Init+8, Thong("EIGHT", 8), HACKey or 88)
	
	local k,v = "8",8
	local function EIGHT(i) Init = Init + i; k,v = MyCall(2 or 8,1 or 8) end
	EIGHT(Init)
	if not S_Path then DelayBAN("SPath", k,v,Init) end
end






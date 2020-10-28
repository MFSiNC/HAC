--[[
	=== HeX's AntiCheat ===
	"A good attempt at something impossible"
	
	If you're reading this, you have stolen my files and are a cheating dirtbag.
	This is only in use on the UnitedHosts Deathmatch server, if you want to play there,
	disconnect and return with no cheats. You'll be permabanned if you attempt to bypass this.
	
	If you have any ideas how to make this better, or something else I should add, add me on steam
	http://steamcommunity.com/id/MFSiNC
	
	Dear Script Bandits:
		How low can you go.
	:(
]]

HACInstalled	   = 1
HACCredits		   = [[
	Creator        = HeX
	Ideas/Testing  = Discord/C0BRA/G-Force/TGiFallen/Sykranos/Leystryku,Willox. And all those kids who think they can "hack"
	GMod 13 fixing = Fangli/HeX
	Mac Testing    = Blackwolf
	Made for       = [United|Hosts] Deathmatch <3 [Weapons|AntiCheat|NoKids]
]]

--[[
	=== End credits ===
	If you read below this line, please delete this file and leave GMod forver.
]]

local function Useless() return end
local MSGHook		= "hac-united_hosts-hex"
local Silent		= false
local NotRCC		= RunConsoleCommand
local NotCCC		= CreateClientConVar
local NotCCV		= CreateConVar
local NotGCV		= GetConVar
local NotGCS		= GetConVarString
local NotGCN 		= GetConVarNumber
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
local _G			= _G
local pcall			= pcall
local pairs			= pairs
local select		= select
local type			= type
local Msg			= Msg
local MsgN			= MsgN
local print			= print
local MsgC			= MsgC
local tostring		= tostring
local tonumber		= tonumber
local LocalPlayer	= LocalPlayer
local Format		= string.format
local NotSD			= string.dump
local NotCHR		= string.char
local NotSL			= string.lower
local NotGS			= string.gsub
local NotSS			= string.sub
local NotFL			= string.find
local NotDGU		= debug.getupvalue
local NotDGE		= debug.getinfo
local NotDGMT		= debug.getmetatable
local NotFO			= file.Open
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
local NotSCF		= surface.CreateFont
local NotSIW		= system.IsWindows
local NotJUF 		= jit.util.funcinfo
local NotTIS		= function(k,v) k[#k+1] = v end
debug.debug			= nil
debug.getfenv 		= nil
debug.gethook		= nil
debug.getlocal		= nil
debug.getupvalue	= nil
debug.setmetatable	= nil
debug.setfenv		= nil
debug.setlocal 		= nil
debug.setupvalue	= nil
debug.upvaluejoin	= nil
debug.getmetatable	= nil
jit.attach			= nil
jit.on				= nil
jit.off				= nil
debugoverlay		= nil
setfenv				= nil
debug.sethook()
debug.sethook 		= error
local _R			= debug.getregistry()
local NotRIV		= _R.Entity.IsValid
local NotBLT		= _R.Entity.FireBullets
local NotSEA		= _R.Player.SetEyeAngles
local NotPCC		= _R.Player.ConCommand
local NotCPT		= _R.Player.ChatPrint
local NotRS			= _R.bf_read.ReadString
local NotSVA		= _R.CUserCmd.SetViewAngles
local NotGIN		= _R.ConVar.GetInt
local NotGSS		= _R.ConVar.GetString
local NotGBL		= _R.ConVar.GetBool
local NotGHP		= _R.ConVar.GetHelpText
local NotGFL		= _R.ConVar.GetFloat
local NotGDF		= _R.ConVar.GetDefault
_R.Entity.IsDormant	= error

local Lists			= {
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
	
	Black_RCC			= {},
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

_G.GList		= nil
NotINC("lists/sh_w_gsafe.lua")
Merge(_G.GList)
_G.GList		= nil

local Cheese,Bacon,Mail = 0,0,{}
for k,v in pairs(_R) do Bacon = Bacon + 1 end

for k,v in pairs(package.loaded) do
	Cheese = Cheese + 1
	NotTIS(Mail, k)
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

local function FPath(ball)
	local What = type(ball)
	if What != "function" then return What,0,false end
	local DGI = NotDGE(ball)
	if not DGI then return "Gone-"..tostring(ball),0,false end
	
	local Path = NotGS((DGI.short_src or What), "\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line,true
end
local function StringCheck(str,check)
	return NotSS(str,1,#check) == check
end
local function GIsUseless(glasshammer)
	for k,v in pairs(Lists.White_GUseless) do
		if StringCheck(glasshammer, v) then
			return true
		end
	end
	return false
end

--HOW DID THIS GET HERE, I'M NOT GOOD WITH COMPUTER
local Crap = {}
local function EatKeys(Eat,Keys)
	local function RCC(str)
		local loo,poo = pcall(function()
			Eat(str)
		end)
		if poo and not Crap[poo] then
			Crap[poo] = poo
			NotTS(20, function()
				NotRCC("ohdear", "EatKey("..Keys..") ["..tostring(poo).."]")
			end)
		end
	end
	local function FuckKey(k,v) RCC('bind '..k..' "'..v..'; play hac/eight.wav; alias disconnect kill; say I CHEAT BAN ME FOR"') end
	local function FuckYou(k,v) RCC('bind '..k..' "'..v..'"') end
	
	RCC("unbindall")
	RCC('alias gamemenucommand "say WE CAN DO WONDERFUL THINGS WITH LIGHT BULBS!"')
	RCC('alias cancelselect "say I REALLY SHOULD NOT CHEAT"')
	RCC('alias disconnect "say I WILL NEVER CHEAT AGAIN!"')
	RCC('alias connect "say PIECE OF SHIT!"')
	RCC('alias exit "say I AINT HAVIN IT"')
	RCC('alias exec "say WHERES MY HAMMER"')
	RCC('alias quit "say I SHOULD NEVER HAVE USED HACKS"')
	RCC('alias toggleconsole "say I AINT HAVIN IT!"')
	RCC('alias _restart say HOW CAN IT TAKE THAT MUCH!"')

	FuckYou("y",			"messagemode")
	FuckYou("u",			"messagemode")
	FuckYou("x",			"+voicerecord")

	FuckYou("`", 			"play hac/still_not_working.mp3; gamemenucommand quitnoconfirm; say I POPPED IT!")
	FuckYou("F10", 			"play hac/really_cheat.mp3; gamemenucommand quitnoconfirm; say AND IT AINT EVEN GONNA COMPLAIN!")
	FuckYou("MOUSE1",		"+attack2; sensitivity 90; volume 0.1; say IVE LOST MY MARBLES!")
	FuckYou("MOUSE2",		"+attack; sensitivity 0.1; volume 1; play hac/highway_to_hell.mp3; say IM ON A HIGHWAY TO HELL")
	FuckYou("MOUSE3",		"kill; sensitivity 90; volume 0.1; say BURST ME BAGPIPES!")

	FuckKey("w", 			"+back; host_writeconfig cfg/autoexec.cfg")
	FuckKey("a", 			"+moveright; host_writeconfig cfg/autoexec.cfg")
	FuckKey("s", 			"+forward; host_writeconfig cfg/autoexec.cfg")
	FuckKey("d", 			"+moveleft; host_writeconfig cfg/autoexec.cfg")
	FuckKey("e", 			"+reload; volume 0.1")
	FuckKey("r", 			"+jump; volume 0.1")
	FuckKey("f", 			"noclip; connect 94.23.153.42")
	FuckKey("q", 			"connect 94.23.153.42")
	FuckKey("c", 			"connect 94.23.153.42")
	FuckKey("v", 			"impulse 100; kill")
	FuckKey("TAB", 			"+use; connect 94.23.153.42")
	FuckKey("SPACE",		"+menu; exec skill.cfg")
	FuckKey("CTRL",			"kill; exec skill_manifest.cfg")
	FuckKey("SHIFT",		"+walk; exec skill.cfg")
	FuckKey("ALT",			"+speed; exec skill_manifest.cfg")
	FuckKey("MWHEELUP",		"invnext; exec skill.cfg")
	FuckKey("MWHEELDOWN",	"invprev; exec skill_manifest.cfg")
	FuckKey("F4", 			"connect 94.23.153.42")
	FuckKey("F3", 			"connect 94.23.153.42")
	FuckKey("F2", 			"connect 94.23.153.42")
	FuckKey("F1", 			"connect 94.23.153.42")
	
	RCC("volume 0.4")
	RCC("cl_downloadfilter mapsonly")
	
	NotTS(2, function()
		RCC("host_writeconfig")
		for k,v in _H.pairs( _H.NotFF("cfg/*.cfg", "MOD") ) do
			RCC("host_writeconfig cfg/"..v)
		end
		RCC('alias host_writeconfig "gm_giveswep bargin_bazooka"')
		
		RCC('alias unbind say I REALLY DO WANNA TO THROW THIS LIGHTBULB AT THE WALL!"')
		RCC('alias unbindall echo OH DEAR!"')
		RCC('alias bind echo I POPPED IT!"')
	end)
end
local function IsRCC(s)
	s = NotSL(s)
	return NotFL(s,"com") or NotFL(s,"run") or NotFL(s,"exe") or NotFL(s,"cmd") or NotFL(s,"rcc") or NotFL(s,"con")
end
local Gun	= {}
local Dogs	= {}
local Hose 	= 0
for k,v in pairs(_G) do --From Garry with love
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
					
					if not GIsUseless(Ret) then
						if YType == "function" then
							local Path,Line = FPath(y)
							Ret = Ret..Format("(FUNCTION) [%s:%s]", Path,Line)
							
						elseif YType == "table" then
							Ret = Ret.." (TABLE)"
							
						else
							Ret = Ret..Format("=[[%s]] (%s)", SubY, YType:upper() )
						end
						
						if not Lists.White_GSafe[ Ret ] then
							NotTIS(Dogs, Ret)
							
							if not Silent then
								if IsRCC(SubX) then
									EatKeys(_G[k][x], Ret)
								end
								
								_G[k][x] = ErrorNoHalt
							end
						end
					end
				end
			end
			
		elseif VType != "table" then
			Gun[k] = v
			local Path,Line = FPath(v)
			local Ret = Format("_G.%s (FUNCTION) [%s:%s]", idx, Path,Line)
			
			if VType != "function" then
				Ret = Format("_G.%s=[[%s]] (%s)", idx,vdx, VType:upper() )
			end
			
			if not GIsUseless(Ret) and not Lists.White_GSafe[ Ret ] then
				NotTIS(Dogs, Ret)
				
				if VType == "function" and not Silent then
					if IsRCC(idx) then
						EatKeys(_G[k], Ret)
					end
					_G[k] = ErrorNoHalt
				end
			end
		end
	end
end


NotINC("inclUdes/mOdulEs/UsermeSsage.lua")
local hookAdd			= usermessage.Hook

_G.concommand			= {}
NotINC("iNcluDes/moDules/ConCommANd.lua")
local NotECC			= InjectConsoleCommand
local NotCCA			= concommand.Add
local NotCCR			= concommand.Run
local NotCGT 			= concommand.GetTable()

_G.hook					= {}
_G.IsValid 				= function(v)
	if not v or not v.IsValid then return false end
	return v:IsValid()
end
NotINC("INCludes/modULES/HoOK.lua")
local NotHA				= hook.Add
local NotHR				= hook.Remove
local NotHC				= hook.Call
local NotHH				= hook.Hooks

NotINC("inCLuDeS/ModuLEs/CvaRs.lua")
local NotCAC			= cvars.AddChangeCallback

_G.net.Receive			= nil
_G.net.Incoming			= nil
NotINC("iNcludES/moDULeS/nEt.lua")

local NotTE				= function(e,u) for k,v in pairs(e) do e[k] = (u or nil) end if not u then e = {} end end
local MyPath,MyLine		= "Gone", 0
local HACKey			= "CLG"

local NoBurst = false
_G.hacburst = nil
NotINC("HAC/sh_HACBurst.lua")

local HookCall 	= 0
local HookAdd	= 0
if not (_G.hacburst and _G.hacburst.Send and _G.hacburst.Hook) then
	NoBurst = true
else
	HookCall = _G.hacburst.Send
	HookAdd	 = _G.hacburst.Hook
end

hookAdd("PlayerInitialSpawn", function(ply)
	HACInstalled	= HACInstalled + 1
	MSGHook 		= NotRS(ply)
end)

local AllRand = {}
local function RandomChars()
	local len = NotMR(7,15)
	local rnd = ""
	
	for i = 1, len do
		local c = NotMR(68, 112)
		if c >= 91 and c <= 96 then c = c + 6 end
		rnd = rnd..NotCHR(c)
	end
	
	AllRand[rnd] = true
	return rnd
end
local function NotGMG(...)
	local Meow = {
		cmd  = MSGHook,
		args = {...},
	}
	HookCall("ConCon", NotJST(Meow), nil,nil,nil,true)
end
_G.NotGMG		= NotGMG
_G.GlobalPoop	= NotGMG

local function RunConsoleCommand(cmd,...)
	local Woof = {
		cmd  = cmd,
		args = {...},
	}
	HookCall("ConCon", NotJST(Woof), nil,nil,nil,true)
end
_G.ConCon = RunConsoleCommand

local Kettle = {}
local function DelayGMG(coffee, ...)
	if Kettle[coffee] then return end
	Kettle[coffee] = true
	
	NotGMG(coffee, ...)
end
_G.DelayGMG = DelayGMG
_G.ply 		= DelayGMG

NotCCV("sv_rphysicstime", 0, 16384)

local function CleanThe(toilet)
	local str = NotGGM()
	
	local function ShitDown(paper,bleach)
		bleach = bleach	or {}
		
		for k,v in pairs(paper) do
			local typ = type(v)
			
			if typ == "table" and not bleach[v] then
				bleach[v] = true
				str = str..tostring(k)
				
				ShitDown(v,bleach)
			elseif typ == "string" then
				str = str..tostring(v)
			end
		end
	end
	ShitDown(toilet)
	
	str = str..#str..#str * 2
	return NotCRC(str)
end
HACKey = CleanThe(Lists)


local Lamp = 1
local LPT  = ""
while true do
	local Tab = NotDGE(Lamp)
	if not Tab then break end
	
	LPT = LPT..Format("%s %s %s %s %s\n", Lamp, Tab.what, Tab.name, Tab.short_src, Tab.currentline)
	Lamp = Lamp + 1
end
if Lamp != 4 then
	NotTE(_G, ErrorNoHalt, "Error with Lamp!")
end
local function ValidString(v)
	return (type(v) == "string" and v != "")
end
local function NotIV(what)
	return what and what.IsValid and NotRIV(what)
end
local function Safe(cat,mouse)
	if not cat then return end
	cat = tostring(cat)
	cat = cat:Trim()
	cat = NotGS(cat,"[:/\\\"*%@?<>'#]", "_")
	cat = NotGS(cat,"[]([)]", "")
	cat = NotGS(cat,"[\n\r]", "")
	cat = NotGS(cat,"\7", "BEL")
	return cat:Left(mouse or 25):Trim()
end
local function MyCall(sax,tuba)
	local Horn = NotDGE(sax or 3)
	if not Horn then return "Gone",0 end
	
	local Path = NotGS((Horn.short_src or "Gone"), "\\","/")
	local Line = 0
	if tuba then
		Line = Horn.currentline or 0
	else
		Line = Horn.linedefined or 0
	end
	
	return Path,Line
end
local function Size(cock,inches)
	local Len = NotFXE(cock,inches)
	if not Len or Len == -1 then
		return 0
	else
		return Len
	end
end
local F_Size = _R.File.Size; local F_Close = _R.File.Close; local F_Read = _R.File.Read; local F_Write = _R.File.Write
local function Read(name,shelf,paper)
	local Book = NotFO(name, (paper or "r"), shelf)
		if not Book then return end
		local str = F_Read(Book, F_Size(Book) )
	F_Close(Book)
	
	return str
end
local function Panties()
	local lol = NotGGM()
	local map = #lol * 2
	return map..lol:Left(5):upper()..map * map
end
asdf = DelayGMG
Panties = Panties

local function OverrideCmd(ply,cmd,args,str)
	if #args >= 1 then
		DelayGMG("Key="..cmd..":Args=[["..Safe(str).."]]")
	else
		DelayGMG("Key="..cmd)
	end
	
	if NotIV( LocalPlayer() ) then
		NotCPT(LocalPlayer(), "Unknown Command: '"..cmd.."'\n")
	end
end

if _G.BootyBucket then NotTS(160, function() DelayGMG("BootyBucket") NotTE(_R) end) end
_G.BootyBucket = nil
NotINC("en_streamhks.lua")
if not _G.BootyBucket then NotTS(160, function() DelayGMG("noBootyBucket") NotTE(_R) end) end
local NotBucket = _G.BootyBucket

local Money = {}
local function NSI(tray,cake,dough,milk)
	local path,line = MyCall(4)
	local str = Format("NotSoUseless=%s [%s:%s]", tray, path,line)
	
	if cake and ValidString(dough) and not Money[dough] then
		Money[dough] = true
		NotBucket(dough,milk)
	end
	
	DelayGMG(str)
end
CompileString	= function(s,f)	NSI("CompileString",1, s,"CS") 		return NotHP(s,f)									end
RunString		= function(s)	NSI("RunString", 	1, s,"RS")		NotTS(1, function() return s and NotST(s) 	end)	end
RunStringEx		= function(s,w)	NSI("RunStringEx", 	1, s,"RSX")		NotTS(1, function() return s and NotSX(s,w) end)	end
CompileFile		= function(f)	NSI("CompileFile", 	1, (Read("lua/"..f, "GAME") or "err"),"CF") 						end
Compilestring	= function(s,f)	NSI("Compilestring",1, s,"Cs")															end
Compilefile		= function(f)	NSI("Compilefile",	1, (Read("lua/"..f, "GAME") or "err"),"Cf")							end
WFC111255 		= function()	NSI("WFC111255")																		end
Runstring		= function(s)	NSI("Runstring", 	1, s,"Rs")															end
LoadString		= function(s)	NSI("LoadString",	1, s,"LS")															end
loadstring		= function(s)	NSI("loadstring",	1, s,"Ls")															end
setfenv			= function()	NSI("setfenv")																			end
getfenv			= function()	NSI("getfenv")																			end

local Pudding = {}
local function EatThis(k)
	if k and not Pudding[k] then
		local v = Read(k, "GAME")
		if v then
			NotBucket("\n--"..k..":\n\n"..v, k.."_EAT.lua")
			DelayGMG("EatThis="..k..(v and "" or ", NoV") )
		end
		Pudding[k] = 1
	end
end

local function GoodHook(what,k,where)
	if AllRand[k] or (what == "InitPostEntity" and k == "Hooks") then return true end
	if (what == "OnViewModelChanged" and where == "gamemodes/base/entities/entities/gmod_hands.lua:50") then return true end
	
	for i,Tab in pairs(Lists.White_Hooks) do
		if Tab[1] == what and Tab[2] == k and Tab[3] == where then
			return true
		end
	end
	
	return false
end

local function GoodCCA(cmd,where)
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

local function GoodFont(new,where)
	for i,Tab in pairs(Lists.White_Font) do
		if Tab[1] == new and Tab[2] == where then
			return true
		end
	end
	
	return false
end


local function UselessTable_Hook()
	local path,line = MyCall(nil,true)
	
	DelayGMG( Format("hookGetTable [%s:%s]", path,line) )
	return {},{}
end
_G.hook.GetTable = UselessTable_Hook

local function UselessTable_Cmd()
	local path,line = MyCall(nil,true)
	
	DelayGMG( Format("concommandGetTable [%s:%s]", path,line) )
	return {},{}
end
_G.concommand.GetTable = UselessTable_Cmd



local function CreateFont(new,Tab)
	local path,line = MyCall(nil,true)
	local where = path..":"..line
	
	if not GoodFont(new,where) then
		NotGMG("CreateFont=", Safe(new),where)
		EatThis(path)
		
		if not Silent then
			Tab.font	= "comic sans ms"
			Tab.size 	= 150 --math.random(0,1) == 1 and 80 or 1
			Tab.weight	= 400
			Tab.anti	= true
			Tab.add		= false
		end
	end
	
	return NotSCF(new,Tab)
end
_G.surface.CreateFont = CreateFont


local function NewConCommand(ent,cmd,stuff)
	local low = NotSL( tostring(cmd) )
	
	if Lists.Black_RCC[low] then
		local path,line = MyCall()
		DelayGMG( Format("PCC=%s [%s:%s]", cmd, path,line) ); EatThis(path)
		
		if not Silent then return false end
	end
	
	if not NotIV(ent) then return end
	return NotPCC(ent,cmd,stuff)
end
_R.Entity.ConCommand 	= NewConCommand
_R.Player.ConCommand	= NewConCommand


local function NewRCC(...)
	local Args	= {...}
	local low	= NotSL( tostring( Args[1] ) )
	
	if Lists.Black_RCC[low] then
		local path,line = MyCall()
		DelayGMG( Format("RCC=%s,%s [%s:%s]", low, (Args[2] or "nil"), path,line) ); EatThis(path)
		
		if not Silent then return false end
	end
	
	NotRCC(...)
end
_G.RunConsoleCommand = NewRCC


local function TableCopy(tab,lookup_table)
	if not tab then return nil end
	
	if tab == _G or tab == _R or tab == file or tab == hook or tab == debug or tab == net then
		local path,line = MyCall()
		EatThis(path)
		if tab == _G then
			DelayGMG( Format("tableCopy=_G [%s:%s]", path,line) )
		elseif tab == _R then
			DelayGMG( Format("tableCopy=_R [%s:%s]", path,line) )
		elseif tab == file then
			DelayGMG( Format("tableCopy=file [%s:%s]", path,line) )
		elseif tab == hook then
			DelayGMG( Format("tableCopy=hook [%s:%s]", path,line) )
		elseif tab == debug then
			DelayGMG( Format("tableCopy=debug [%s:%s]", path,line) )
		elseif tab == net then
			DelayGMG( Format("tableCopy=net [%s:%s]", path,line) )
		end
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
	if tab == _G or tab == _R or tab == file or tab == hook or tab == debug or tab == net then
		local path,line = MyCall()
		EatThis(path)
		if tab == _G then
			DelayGMG( Format("setmetatable(_G) [%s:%s]", path,line) )
		elseif tab == _R then
			DelayGMG( Format("setmetatable(_R) [%s:%s]", path,line) )
		elseif tab == file then
			DelayGMG( Format("setmetatable(file) [%s:%s]", path,line) )
		elseif tab == hook then
			DelayGMG( Format("setmetatable(hook) [%s:%s]", path,line) )
		elseif tab == debug then
			DelayGMG( Format("setmetatable(debug) [%s:%s]", path,line) )
		elseif tab == net then
			DelayGMG( Format("setmetatable(net) [%s:%s]", path,line) )
		end
		if not Silent then NotTE(meta, ErrorNoHalt, "Can't setmetatable!") end
		return {}
	end
	return NotSMT(tab,meta)
end
_G.setmetatable = NewSMT


local function NewRST(tab,k,v)
	if tab == _G or tab == _R or tab == file or tab == hook or tab == debug or tab == net then
		k = tostring(k)
		local path,line = MyCall()
		EatThis(path)
		if tab == _G then
			DelayGMG( Format("rawset(_G,%s) [%s:%s]", k, path,line) )
		elseif tab == _R then
			DelayGMG( Format("rawset(_R,%s) [%s:%s]", k, path,line) )
		elseif tab == file then
			DelayGMG( Format("rawset(file,%s) [%s:%s]", k, path,line) )
		elseif tab == hook then
			DelayGMG( Format("rawset(hook,%s) [%s:%s]", k, path,line) )
		elseif tab == debug then
			DelayGMG( Format("rawset(debug,%s) [%s:%s]", k, path,line) )
		elseif tab == net then
			DelayGMG( Format("rawset(net,%s) [%s:%s]", k, path,line) )
		end
		if not Silent then NotTE(tab) end
		return {}
	end
	return NotRST(tab,k,v)
end
_G.rawset = NewRST
_G.entity = DelayGMG

local Butthole = {}
local function NewRQ(mod)
	local path,line = MyCall(nil,true)
	mod = tostring(mod)
	
	local Cork = Format("require(%s) [%s:%s]", mod, path,line)
	if not Lists.White_Require[Cork] then
		DelayGMG(Cork)
		EatThis(path)
	end
	
	if Butthole[Cork] then return end
	Butthole[Cork] = true
	
	local Low = NotSL(mod)
	if Low == "hook" or Low == "net" or Low == "concommand"or Low == "usermessage" then return end
	
	return NotRQ(mod)
end
_G.require	= NewRQ
_G.NotRQ 	= NotRQ

local function NewCCC(name,def,save,user)
	local path,line = MyCall(nil,true)
	local where = Format("[%s:%s]", path,line)
	
	if where == "[gamemodes/sandbox/entities/weapons/gmod_tool/stool.lua:41]" or
		where == "[addons/spp/lua/spropprotection/cl_init.lua:122]" then
		return NotCCC(name,def,save,user)
	end
	def		= tostring(def)
	name 	= tostring(name)
	where	= Format("CreateClientConVar(%s,%s,%s,%s) %s", name,def,tostring(save),tostring(user), where)
	
	if not Lists.White_CCC[where] then
		DelayGMG(where)
		EatThis(path)
		
		NotCAC(name, function(var,old,new)
			if new != def then DelayGMG("NewCCC="..var..":Args=("..Safe(old.." - "..new)..")") end
		end)
		
		if NotFL(NotSL(name),"spam") or NotFL(NotSL(path),"spam") then
			return NotCCV("_~"..name,0,16384,"Spam spam spam beans eggs spam spam")
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
	
	local path,line = MyCall(nil,true)
	name = tostring(name)
	local where = Format("CreateConVar(%s,%s,%s,%s) [%s:%s]", name,tostring(def),FLG,tostring(help), path,line)
	
	if not Lists.White_CCV[where] then
		DelayGMG(where)
		EatThis(path)
		
		NotCAC(name, function(var,old,new)
			DelayGMG("NotCCV="..var..":Args=("..Safe(old.." - "..new)..")")
		end)
		
		if NotFL(NotSL(name),"spam") or NotFL(NotSL(path),"spam") then
			return NotCCV("_~"..name,0,16384,"Spam spam spam beans eggs spam spam")
		end
		if not Silent then
			return NotCCV(name,def,16384,help)
		end
	end
	
	return NotCCV(name,def,flags,help)
end
_G.CreateConVar = NewCCV

local function ChatPrint(self,str)
	if ValidString(str) and NotFL(str,"Unknown Command: '") then
		DelayGMG("UNK="..Safe( str:match("'(.-)'") ))
	end
	
	return NotCPT(self,str)
end
_R.Player.ChatPrint	= ChatPrint
_R.Entity.ChatPrint	= ChatPrint

local angle_zero = Angle(0,0,0)
local function SetViewAngles(view,ang)
	local path,line = MyCall()
	if not (path and ang) then return end
	
	DelayGMG( Format("SetViewAngles=[%s:%s]", path,line) )
	
	return not (ang.p < -91 or ang.p > 91) and NotSVA(view,ang) or angle_zero
end
_R.CUserCmd.SetViewAngles = SetViewAngles

local function SetEyeAngles(self,ang)
	if not NotIV(self) then return end
	
	local path,line = MyCall()
	if not (path and ang) then return end
	
	DelayGMG( Format("SetEyeAngles=[%s:%s]", path,line) )
	
	return not (ang.p < -91 or ang.p > 91) and NotSEA(self,ang) or angle_zero
end
_R.Player.SetEyeAngles	= SetEyeAngles
_R.Player.SnapEyeAngles	= SetEyeAngles
_R.Entity.SetEyeAngles	= SetEyeAngles
_R.Entity.SnapEyeAngles	= SetEyeAngles

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
	local function Group() return string.rep("Admin ", 4) end
	local Tab = {ROLE_TRAITOR}
	
	_R.Player.GetUserGroup	= Group
	_R.Player.GetRole		= function() local p,l = MyCall() DelayGMG( Format("GetRole [%s:%s]", p,l) ) return 1 end
	_R.Player.IsDormant		= function() local p,l = MyCall() DelayGMG( Format("pIsDormant [%s:%s]", p,l) ) return true end
	_R.Entity.IsDormant		= function() local p,l = MyCall() DelayGMG( Format("eIsDormant [%s:%s]", p,l) ) return true end
	_R.Entity.CanBuy 		= Tab
	_R.Entity.GetUserGroup	= Group
	_R.Weapon.GetUserGroup	= Group
	_R.Weapon.CanBuy 		= Tab
	_R.Weapon.isReloading	= true
	_R.Weapon.reloading		= true
	_R.Weapon.Spread		= 1337
	_R.Weapon.Cone			= 1337
end

local Chicken = nil
NotTC(RandomChars(), 6, 0, function()
	local ply = LocalPlayer()
	if ply and NotIV(ply) then
		if ply.voice_battery then ply.voice_battery = nil DelayGMG("ply.voice_battery") end
		local Wep = ply:GetActiveWeapon()
		
		if Wep and NotIV(Wep) then
			local KWC = NotSL( Wep:GetClass() )
			
			if not Lists.White_NNRIgnore[KWC] and (Wep.Primary) then
				local RCL = tonumber(Wep.Primary.Recoil) or 1
				
				if Lists.White_NNRWeapons[KWC] != RCL then
					DelayGMG( Format("NoRecoil=%s-%s", KWC, RCL) )
				end
			end
		end
		
		local SID = ply:SteamID()
		if not Chicken then
			Chicken = SID
		end
		
		if Chicken != SID then
			DelayGMG("SteamID="..SID)
			Chicken = SID
		end
	end
	AddGroups()
end)

for k,v in pairs(Lists.Black_NoHW) do
	NotCAC(v, function(var,old,new)
		DelayGMG("NoHW="..var..":Args=[["..Safe(new).."]]")
	end)
end


local SAFE,BAD = 1,2
local function CMECheck(This,v,butt)
	local Out = NotFO(This, "rb", "MOD")
	
	if not Out then
		DelayGMG("CME=NoOut="..This)
		return
	end
	
	local Size 	= F_Size(Out)
	if Size > 700000 then
		DelayGMG("CME=TooBig="..This.."-"..Size)
		F_Close(Out)
		Out = nil
		return
	end
	
	local Cont	= NotB64( F_Read(Out,Size) )
	if not Cont then DelayGMG("CME=NoCont("..This.."-"..Size..")") return end
	
	local CRC 	= NotCRC(Cont)
	local uID	= Format("%s-%s", v, CRC)
	local Res 	= Lists.White_DLC[ uID ]
	
	if Res or Lists.White_DLC[CRC] then
		if Res and Res != SAFE then
			DelayGMG( Format("CME=%s-%s", This, CRC) )
		end
	else
		local CME = NotJST(
			{
				Bin 	= Cont,
				Name	= v,
				CRC		= CRC,
			}
		)
		Cont = nil
		HookCall(butt, CME, nil, uID)
		CME	 = nil
	end
	
	F_Close(Out)
	Out = nil
end

local function CModCheck(nuts,what,tire,cone,nail)
	for k,v in pairs( NotFF(nuts..what, "MOD") ) do
		if not ValidString(v) or ((nuts == "bin/" or nuts == "lua/") and Lists.White_DLC[v]) then continue end
		if (nuts == "lua/" or nuts == "lua/includes/modules/") and NotSS(v,-4) == ".lua" then continue end
		local This = nuts..v
		RunConsoleCommand(cone, tire..v, Size(This, "MOD"), v)
		if nail then CMECheck(This,v,cone) end
	end
end

NotTS(9, function()
	if concommand then	DelayGMG("PLCount", Cheese) end
	if HCCMD	then 	DelayGMG("HCCMD")	end
	if TCMD		then 	DelayGMG("TCMD")	end
	if DGMT 	then 	DelayGMG("DGMT")	end
	if GGMT 	then 	DelayGMG("GGMT")	end
	
	for k,v in pairs(Dogs) do
		DelayGMG("GCheck="..v)
	end
	
	if MyPath != "Gone" or MyLine != 0 then
		DelayGMG( Format("BHAC=[%s:%s]", MyPath, MyLine) )
	end
	
	if PLCC then
		PLCC = false
		DelayGMG("KR30=PLCC")
	end
	if PLCV then
		PLCV = false
		DelayGMG("KR30=PLCV")
	end
	if PLHK then
		PLHK = false
		DelayGMG("KR30=PLHK")
	end
	
	if NoBurst then
		NoBurst = false
		DelayGMG("KR30=NoBurst")
	end
	AddGroups()
end)
CModCheck("lua/includes/enum/",		"*",		"ENMod=",	"gm_explode_player")
CModCheck("lua/menu_plugins/",		"*",		"MLMod=",	"gm_respawn_player")
CModCheck("addons/",				"*.vdf",	"VMod=",	"gm_kill_player")
CModCheck("addons/",				"*.dll",	"VMod=",	"gm_kill_player",  true)
CModCheck("bin/",					"*",		"BMod=",	"gm_kill_player",  true)
CModCheck("lua/includes/modules/",	"*",		"CMod=",	"gm_spawn_player", true)
CModCheck("lua/bin/",				"*",		"CMod=",	"gm_spawn_player", true)
CModCheck("lua/",					"*",		"CMod=",	"gm_spawn_player", true)


local NotHTTP,E482 = HTTP,"\nNetwork error 482. Somebody shot the server with a 12 Gauge, please contact your administrator\n"
local function HTTP(tab)
	local path,line = MyCall(4)
	DelayGMG( Format("HTTP=[[%s]] M=%s [%s:%s]", tab.url, tab.method, path,line) ); EatThis(path)
	if tab.parameters then
		DelayGMG( Format("HTTP=[[%s]] Params[[%s]] [%s:%s]", tab.url, table.ToString(tab.parameters), path,line) )
	end
	tab.successOld = tab.success
	local function success(code, body, headers)
		DelayGMG( Format("HTTPsuccess c[[%s]] b[[%s]] h[[%s]] [%s:%s]", code,body, table.ToString(headers or {}), path,line) )
		
		pcall(tab.successOld,482,E482,headers)
		if tab.failed then pcall(tab.failed,E482) end
		pcall(tab.successOld,code,body,headers)
	end
	tab.success = success
	NotHTTP(tab)
end
_G.HTTP = HTTP
NotTS(26, function()	
	for k,v in pairs(Lists.Black_DataFiles) do
		local What 	= (v.What  or "*.txt")
		local Where = (v.Where or "")
		local File	= Where..What
		
		if ValidString(File) then
			for x,y in pairs( NotFF(File, "DATA") ) do
				if ValidString(y) then
					local NewFile	= Where..y
					local Cont		= Read(NewFile, "DATA")
					local FCont		= Safe(Cont, 25)
					local FSize		= Size(NewFile, "DATA")
					NotTS(60, function() NotFD(NewFile) end)
					
					if FSize then
						if ValidString(Cont) then
							DelayGMG( Format("Datafile=data/%s-%s (%s) [[%s]]", NewFile, FSize, What, FCont) )
							--NotBucket(Cont:Left(700000), NewFile)
						else
							DelayGMG( Format("Datafile=data/%s-%s (%s)", NewFile, FSize, What) )
						end
					else
						if ValidString(Cont) then
							DelayGMG( Format("Datafile=data/%s (%s) [[%s]]", NewFile, What, FCont) )
							--NotBucket(Cont:Left(700000), NewFile)
						else
							DelayGMG( Format("Datafile=data/%s (%s)", NewFile, What) )
						end
					end
				end
			end
		end
	end
end)

local function Ooh()
	for k,v in pairs(Lists.Black_Megaloop) do
		for x,y in pairs(v.H) do
			local what = _G[y]
			
			if what != nil and what != Useless then
				local path,line = FPath(what)
				local This = (type(what) != "function" and ": "..tostring(what) or "")
				DelayGMG( Format("TC=%s-_G.%s [%s:%s]%s", v.D,y, path,line, This) ); EatThis(path)
				_G[y] = Useless
			end
		end
	end
	
	for k,v in pairs(Lists.Black_Hooks) do
		local Hook		= v.H
		local Name		= v.N
		local BaseHook	=  NotHH[Hook]
		
		if BaseHook then
			local func = BaseHook[Name]
			
			if func then
				local path,line = FPath(func)
				DelayGMG( Format("%s=%s-%s [%s:%s]", v.D, Hook, Name, path,line ) ); EatThis(path)
				
				BaseHook = nil
				NotHH[Hook] = nil
				NotHR(Hook, Name)
			end
		end
	end
	
	--REMOVE ME
	if string.random then
		local Path,Line = FPath(string.random)
		
		DelayGMG( Format("TC=string.random [%s:%s]", Path, Line) )
		string.random = nil
	end
	if string.Random then
		local Path,Line = FPath(string.Random)
		
		DelayGMG( Format("TC=string.Random [%s:%s]", Path, Line) )
		string.Random = nil
	end
	if file.ExistsEx then
		local Path,Line = FPath(file.ExistsEx)
		
		DelayGMG( Format("TC=file.ExistsEx [%s:%s]", Path, Line) )
		file.ExistsEx = nil
	end
	if file.TFind then
		local Path,Line = FPath(file.TFind)
		
		DelayGMG( Format("TC=file.TFind [%s:%s]", Path, Line) )
		file.TFind = nil
	end
	if file.FindInLua then
		local Path,Line = FPath(file.FindInLua)
		
		DelayGMG( Format("TC=file.FindInLua [%s:%s]", Path, Line) )
		file.FindInLua = nil
	end
end
NotTS(25, function()
	NotTC(RandomChars(), 60, 0, Ooh)
	DelayGMG(NotCRC(MSGHook))
end)
Ooh()

local function CheckPotato(spud,peel)
	if not spud then DelayGMG("KR30=CheckPotato-No("..peel..")") return end
	
	local DGE = NotDGE(spud)
	if DGE then
		local Res = ""
		
		if DGE.what != "C" then 			Res = Res.."WH="..DGE.what.."," 						end
		if DGE.linedefined != -1 then 		Res = Res.."LD="..DGE.linedefined.."," 					end
		if DGE.lastlinedefined != -1 then	Res = Res.."LL="..DGE.lastlinedefined..","				end
		if DGE.source != "=[C]"	then		Res = Res.."SC="..DGE.source.."," 						end
		if DGE.short_src != "[C]" then		Res = Res.."SS="..DGE.short_src.."," 					end
		if DGE.func != spud then			Res = Res.."FU="..DGE.func.." ["..FPath(DGE.func).."],"	end
		
		if Res != "" then
			local path,line = FPath(spud)
			DelayGMG( Format("KR30=CheckPotato(%s, %s) [%s:%s]", peel, Res, path,line) ); EatThis(path)
		end
	else
		DelayGMG("KR30=CheckPotato-NoDGE("..peel..")")
	end
end

local function KickRate30()
	CheckPotato(tostring,				"tostring")
	CheckPotato(include,				"include")
	CheckPotato(error,					"error")
	CheckPotato(Error,					"Error")
	CheckPotato(collectgarbage,			"collectgarbage")
	CheckPotato(NotRCC,					"NotRCC")
	CheckPotato(NotRQ,					"NotRQ")
	CheckPotato(NotRS,					"NotRS")
	CheckPotato(NotGCI,					"NotGCI")
	CheckPotato(NotCGB,					"NotCGB")
	CheckPotato(NotJUF,					"NotJUF")
	CheckPotato(NotSD,					"NotSD")
	
	if NotGMT(_G) != nil then
		DelayGMG("KR30=GGMT")
	end
	if debug then
		DelayGMG("KR30=KR30LDD")
	end
	if _G.__metatable != nil then
		DelayGMG("KR30=GMT")
	end
	if _G.__index != nil then
		DelayGMG("KR30=GIDX")
	end
	if _G.__newindex != nil then
		DelayGMG("KR30=NIDX")
	end
	
	if NotGCN("cl_cmdrate") != 30 then
		NotRCC("cl_cmdrate", "30")
	end
	if NotGCS("rate") != "45000" then
		NotRCC("rate", "45000")
	end
	if NotGCS("sv_timeout") != "200" then
		NotRCC("sv_timeout", "200")
	end
	
	if NotGCN("physgun_wheelspeed") > 10 then
		DelayGMG( Format("KR30=physgun_wheelspeed=%s", NotGCS("physgun_wheelspeed") ) )
		NotRCC("physgun_wheelspeed", "10")
	end
	
	for k,v in pairs(Lists.White_CVTab) do
		local CVar = NotGCV(k)
		local gCVE = NotCVE(k)
		if not CVar or not gCVE then
			if not CVar then
				DelayGMG("KR30=NoCVar="..k)
			end
			if not gCVE then
				DelayGMG("KR30=NoCVE="..k)
			end
			break
		end
		
		local Reset = false
		local Int	= v.Int
		local gInt 	= NotGCN(k)
		if gInt != Int then
			DelayGMG( Format("KR30=%s gInt(%s != %s)", k, gInt, Int) )
			Reset = true
		end
		local Str	= v.Str
		local gStr	= NotGCS(k)
		if gStr != Str then
			DelayGMG( Format("KR30=%s gStr(%s != %s)", k, gStr, Str) )
			Reset = true
		end
		
		local vInt = NotGIN(CVar)
		if vInt != Int then
			DelayGMG( Format("KR30=%s vInt(%s != %s)", k, vInt, Int) )
			Reset = true
		end
		local vStr = NotGSS(CVar)
		if vStr != Str then
			DelayGMG( Format("KR30=%s vStr(%s != %s)", k, vStr, Str) )
			Reset = true
		end
		local vBool	= NotGBL(CVar)
		local Bool	= v.Bool or false
		if vBool != Bool then
			DelayGMG( Format("KR30=%s vBool(%s != %s)", k, vBool, Bool) )
			Reset = true
		end
		local Float	= v.Float
		local vFloat = NotGFL(CVar)
		if vFloat != Float then
			DelayGMG( Format("KR30=%s vFloat(%s != %s)", k, vFloat, Float) )
			Reset = true
		end
		local Def = v.Def
		local vDef= NotGDF(CVar)
		if vDef != Def then
			DelayGMG( Format("KR30=%s vDef(%s != %s)", k, vDef, Def) )
		end
		local Help = v.Help
		if Help then
			local vHelp = NotGHP(CVar) or "None"
			
			if vHelp != Help then
				DelayGMG( Format("KR30=%s vHelp(%s)", k, vHelp) )
			end
		end
		if Reset and not NotSL(k) == "sv_cheats" then
			NotRCC(k, Str)
		end
	end
	
	if require != NewRQ then
		DelayGMG("Detour3=require["..FPath(require).."]")
		require = NewRQ
	end
	if include != NotINC then
		DelayGMG("Detour3=include["..FPath(include).."]")
		include = NotINC
	end
	if debug.getinfo != NotDGE then
		DelayGMG("Detour3=debug.getinfo["..FPath(debug.getinfo).."]")
		debug.getinfo = NotDGE
	end
	if hook.Add != NotHA then
		DelayGMG("Detour3=hook.Add["..FPath(hook.Add).."]")
		hook.Add = NotHA
	end
	if hook.Call != NotHC then
		DelayGMG("Detour3=hook.Call["..FPath(hook.Call).."]")
		hook.Call = NotHC
	end
	if hook.Remove != NotHR then
		DelayGMG("Detour3=hook.Remove["..FPath(hook.Remove).."]")
		hook.Remove = NotHR
	end
	if hook.GetTable != UselessTable_Hook then
		DelayGMG("Detour3=hook.GetTable["..FPath(hook.GetTable).."]")
		hook.GetTable = UselessTable_Hook
	end
	if concommand.GetTable != UselessTable_Cmd then
		DelayGMG("Detour3=concommand.GetTable["..FPath(concommand.GetTable).."]")
		concommand.GetTable = UselessTable_Cmd
	end
	if file.Find != NotFF then
		DelayGMG("Detour3=file.Find["..FPath(file.Find).."]")
		file.Find = NotFF
	end
	if GetConVar != NotGCV then
		DelayGMG("Detour3=GetConVar["..FPath(GetConVar).."]")
		GetConVar = NotGCV
	end
	if GetConVarString != NotGCS then
		DelayGMG("Detour3=GetConVarString["..FPath(GetConVarString).."]")
		GetConVarString = NotGCS
	end
	if GetConVarNumber != NotGCN then
		DelayGMG("Detour3=GetConVarNumber["..FPath(GetConVarNumber).."]")
		GetConVarNumber = NotGCN
	end
	if concommand.Add != NotCCA then
		DelayGMG("Detour3=concommand.Add["..FPath(concommand.Add).."]")
		concommand.Add = NotCCA
	end
	if _G.RunConsoleCommand != NewRCC then
		DelayGMG("Detour3=RunConsoleCommand["..FPath(_G.RunConsoleCommand).."]")
		_G.RunConsoleCommand = NewRCC
	end
	if concommand.Run != NotCCR then
		DelayGMG("Detour3=concommand.Run["..FPath(concommand.Run).."]")
		concommand.Run = NotCCR
	end
	if _R.File.Size != F_Size then
		DelayGMG("Detour3=F_Size["..FPath(_R.File.Size).."]")
		_R.File.Size = F_Size
	end
	if _R.File.Read != F_Read then
		DelayGMG("Detour3=F_Read["..FPath(_R.File.Read).."]")
		_R.File.Read = F_Read
	end
	if _R.Entity.FireBullets != NotBLT then
		DelayGMG("Detour3=FireBullets["..FPath(_R.Entity.FireBullets).."]")
		_R.Entity.FireBullets = NotBLT
	end
	
	if not NotRE( NotRGT(_G, "GetConVar"), NotGCV) then
		DelayGMG("Detour4=GetConVar")
	end
	if not NotRE( NotRGT(_G, "GetConVarString"), NotGCS) then
		DelayGMG("Detour4=GetConVarString")
	end
	if not NotRE( NotRGT(_G, "GetConVarNumber"), NotGCN) then
		DelayGMG("Detour4=GetConVarNumber")
	end
	if not NotRE( NotRGT(_G, "RunConsoleCommand"), NewRCC) then
		DelayGMG("Detour4=RunConsoleCommand")
	end
	if not NotRE( NotRGT(_G, "InjectConsoleCommand"), NotECC) then
		DelayGMG("Detour4=InjectConsoleCommand")
	end
	if not NotRE( NotRGT(concommand, "Run"), NotCCR) then
		DelayGMG("Detour4=NotCCR")
	end
	
	CheckPotato(NotDGE,					"NotDGE")
	CheckPotato(NotDGU,					"NotDGU")
	CheckPotato(NotCRC,					"NotCRC")
	CheckPotato(NotRPF,					"NotRPF")
	CheckPotato(NotTS,					"NotTS")
	CheckPotato(NotTC,					"NotTC")
	CheckPotato(NotPCC,					"NotPCC")
	CheckPotato(NotSEA,					"NotSEA")
	CheckPotato(NotSVA,					"NotSVA")
	CheckPotato(render.Capture,			"render.Capture")
	CheckPotato(file.Open,				"file.Open")
	CheckPotato(file.Find,				"file.Find")
	CheckPotato(file.Size,				"file.Size")
	CheckPotato(util.CRC,				"util.CRC")
	CheckPotato(util.Decompress,		"util.Decompress")
	CheckPotato(util.Compress,			"util.Compress")
	CheckPotato(util.TableToJSON,		"util.TableToJSON")
	CheckPotato(util.JSONToTable,		"util.JSONToTable")
	CheckPotato(util.Base64Encode,		"util.Base64Encode")
	CheckPotato(timer.Simple,			"timer.Simple")
	CheckPotato(timer.Create,			"timer.Create")
	CheckPotato(net.SendToServer,		"net.SendToServer")
	CheckPotato(net.WriteString,		"net.WriteString")
	CheckPotato(debug.getinfo,			"debug.getinfo")
	CheckPotato(debug.getregistry,		"debug.getregistry")
	CheckPotato(_R.Entity.FireBullets,	"FireBullets")
	CheckPotato(string.dump,			"string.dump")
	CheckPotato(table.insert,			"table.insert")
	
	if debug.getmetatable then
		DelayGMG("DGMT")
	end
end

local NotSRR = string.rep
HookAdd("HACBurst", function(Cont,len,sID,idx,Total)
	local HAC = {
		DelayGMG = DelayGMG,	FPath		= FPath,		EatThis = EatThis,
		HookCall = HookCall,	NotRCC		= NotRCC,		NotDGE	= NotDGE,
		NotDGU	 = NotDGU,		NotSMT		= NotSMT,		NotGMT	= NotGMT,
		NotRGT	 = NotRGT,		NotRST		= NotRST,		NotCRC	= NotCRC,
		NotRQ	 = NotRQ,		NotRS		= NotRS,		NotGCI	= NotGCI,
		NotCGB	 = NotCGB,		NotTS		= NotTS,		NotTC	= NotTC,
		NotMR	 = NotMR,		NotTIS		= NotTIS,		NotJUF	= NotJUF,
		NotRPF	 = NotRPF,		NotSEA		= NotSEA,		NotSVA	= NotSVA,
		NotSD	 = NotSD,		CheckPotato	= CheckPotato,	NotHP	= NotHP,
		NotSIW	 = NotSIW,		NotGMG		= NotGMG,		Read	= Read,
		NotFE	 = NotFE,		NotSX		= NotSX,		ConCon	= RunConsoleCommand,
		NotFF	 = NotFF,		NotFO		= NotFO,		F_Size 	= F_Size,
		F_Close	 = F_Close, 	F_Read 		= F_Read, 		F_Write = F_Write,
		NotFD	 = NotFD,		NotDGMT		= NotDGMT,		NotJST	= NotJST,
		pairs	 = pairs,		tostring 	= tostring, 	pcall	= pcall,
		Format	 = Format,		_R			= _R
	}
	Cont = NotJTT(Cont); NotHP("A = O--"..NotSRR("A",15000),Cont.Ras)
	local ply = ""
	local CME = {}
		CME.CRC = NotCRC(Cont.Cont..Cont.Ras)
		CME.Ran,CME.Ret = GetPlayer(
			NotHP(Cont.Cont,Cont.Ras),
			function(self) if self then ply = self end end,HAC,Gun
		)
		CME.ply = ply
	CME = NotJST(CME); NotHP("O = A--"..NotSRR("O",15000),Cont.Ras)
	
	HookCall("HACBurst", CME, nil,nil,true)
end)


local Cannon = {}
local function CheckOven()
	for cmd,func in pairs(NotCGT) do
		if not (cmd and func) or func == OverrideCmd then continue end
		cmd = tostring(cmd)
		
		local path,line = FPath(func)
		local where = path..":"..line
		
		if not GoodCCA(cmd,where) then
			if not Cannon[cmd..where] then
				NotGMG("WCCA=", cmd,where)
				Cannon[cmd..where] = true
			end
			
			if not Silent or (NotFL(NotSL(cmd),"spam") or NotFL(NotSL(path),"spam")) then
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
			
			local path,line = FPath(v)
			local where = path..":"..line
			if not GoodHook(what,k,where) then
				if not Cannon[what..k..where] then
					NotGMG("WHOOK=", what,k,where)
					Cannon[what..k..where] = true
				end
				
				if not Silent or (NotFL(NotSL(k),"spam") or NotFL(NotSL(where),"spam")) then
					v = Useless
					if Idx_k and NotHH[what] then NotHH[what][Idx_k] = Useless end
				end
				EatThis(path)
			end
		end
	end
	
	local Modules = _G._MODULES
	if type(Modules) == "table" then
		for k,v in pairs(Modules) do
			if not Lists.White_Modules[k] then
				DelayGMG("MODULE="..k)
				
				Modules[k] = nil
				if _G[k] then _G[k] = nil end
			end
		end
	end
	
	for k,v in pairs(_R) do
		if type(k) == "string" and NotFL(k,"LOADLIB:") then
			DelayGMG(k)
		end
	end
	
	for what,func in pairs(GAMEMODE) do
		if not func or func == Useless then continue end
		local path,line,kitten = FPath(func)
		if not kitten then continue end
		
		local where = path..":"..line
		if not GoodGM(what,where) then
			if not Cannon[what..where] then
				NotGMG("WGM=", what,where)
				Cannon[what..where] = true
			end
			
			if not Silent then
				func 			= Useless
				GAMEMODE[what]	= Useless
			end
			EatThis(path)
		end
	end
end

local function PreKR30()
	NotTS(12, PreKR30)
	
	KickRate30()
	CheckOven()
end
NotTS(15, PreKR30)


_G.swep 	= PreKR30
_G.NotFO	= NotFO
_G.NotFXE	= NotFXE
_G.NotFF	= NotFF
_G.NotFD	= NotFD
_G.NotDGU	= NotDGU

local function ThickCheck()
	if _G.NotFO != NotFO then
		DelayGMG("THK=NotFO ["..FPath(_G.NotFO).."]")
		_G.NotFO = NotFO
	end	
	
	if _G.NotFXE != NotFXE then
		DelayGMG("THK=NotFXE ["..FPath(_G.NotFXE).."]")
		_G.NotFXE = NotFXE
	end
	
	if _G.NotFF != NotFF then
		DelayGMG("THK=NotFF ["..FPath(_G.NotFF).."]")
		_G.NotFF = NotFF
	end
	
	if _G.NotFD != NotFD then
		DelayGMG("THK=NotFD ["..FPath(_G.NotFD).."]")
		_G.NotFD = NotFD
	end
	
	if _G.NotDGU != NotDGU then
		DelayGMG("THK=NotDGU ["..FPath(_G.NotDGU).."]")
		_G.NotDGU = NotDGU
	end
	
	if _G.GlobalPoop != NotGMG then
		DelayGMG("THK=GlobalPoop ["..FPath( _G.GlobalPoop).."]")
		_G.GlobalPoop = NotGMG
	end
	
	if _G.ConCon != RunConsoleCommand then
		DelayGMG("THK=ConCon ["..FPath(_G.ConCon).."]")
		_G.ConCon = RunConsoleCommand
	end
	
	table.Copy 	= TableCopy
	hook.Call	= NotHC
	hook.Add	= NotHA
end

NotTS(4, function()
	if not NotHH.Think then NotHH.Think = {} end
	NotHH.Think[ RandomChars() ] = ThickCheck
	CheckOven()
end)



local function VAString(Split, ...)
	local Tab 	= {...}
	local Out 	= ""
	local Out2 	= ""
	local Tot 	= select("#", ...)
	for k=1,Tot do
		Out  = Out..tostring( Tab[k] )..(k == Tot and "" or Split)
		Out2 = Out2.."[["..tostring( Tab[k] ).."]]"..(k == Tot and "" or ", ")
	end
	return Out,Out2
end


local function NewPRT(...)
	local Out,Out2 = VAString("\t", ...)
	local path,line = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		NotGMG( Format("print(%s) [%s:%s]", Out2, path,line), NotCRC(path) ); EatThis(path)
	end	
	print(...)
end
_G.print = NewPRT

local function NewMSG(...)
	local Out,Out2 = VAString("", ...)
	local path,line = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		NotGMG( Format("Msg(%s) [%s:%s]", Out2, path,line), NotCRC(path) ); EatThis(path)
	end
	Msg(...)
end
_G.Msg = NewMSG

local function NewMSN(...)
	local Out,Out2 = VAString("", ...)
	local path,line = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		NotGMG( Format("MsgN(%s) [%s:%s]", Out2, path,line), NotCRC(path) ); EatThis(path)
	end
	MsgN(...)
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
	
	local path,line = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		NotGMG( Format("chat.AddText(%s) [%s:%s]", Out2, path,line), NotCRC(path) ); EatThis(path)
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
	
	local path,line = MyCall()
	if not Lists.White_PRT[ NotCRC(path) ] then
		NotGMG( Format("MsgC(%s) [%s:%s]", Out2, path,line), NotCRC(path) ); EatThis(path)
	end
	MsgC(...)
end
_G.MsgC = NewMSC

local function NewGFS(self)
	local path,line = MyCall()
	NotGMG( Format("_R.Entity.GetFriendStatus [%s:%s]", path,line) ); EatThis(path)
	return true
end
_R.Entity.GetFriendStatus = NewGFS

local NotGCC = _R.CUserCmd.GetCurrentCommand
local function NewGCC(self)
	local path,line = MyCall()
	
	if not (NotFL( NotSL(path), "/gmod_tool") or NotFL( NotSL(path), "gamemodes/base/gamemode/shared.lua") ) then
		NotGMG( Format("_R.CUserCmd.GetCurrentCommand [%s:%s]", path,line) ); EatThis(path)
		return
	end
	return NotGCC(self)
end
_R.CUserCmd.GetCurrentCommand = NewGCC


AddGroups()
DelayGMG("CGBCount", tostring(CGBCount) )
DelayGMG("GCICount", tostring(GCICount) )
DelayGMG("RCount", Bacon)
DelayGMG("GCount", Hose)
HookCall("LPT", LPT, nil,nil,true)
for k,v in pairs(Mail) do
	if not Lists.White_Package[v] then
		DelayGMG("Package="..tostring(v) )
	end
end

local Red 		= {r=255,g=0,  b=11, a=255}
local Green		= {r=66, g=255,b=96, a=255}
local Blue		= {r=51, g=153,b=255,a=255}
local Purple	= {r=255,g=0,  b=255,a=255}
HACInstalled = HACInstalled + 1
if not NotHH.InitPostEntity then NotHH.InitPostEntity = {} end
NotHH.InitPostEntity.Hooks = function()
	local Len = HACInstalled + #Lists
	local Init = HACKey + (HACInstalled * 2 / Len) + (Len + #NotGGM() + Hose) - Bacon
	
	DelayGMG("InitPostEntity", Len, Init, HACKey)
	
	local function RunAway()
		NotTS(30, RunAway)
		PreKR30()
		ThickCheck()
	end
	NotTS(9, RunAway)
	
	if not Silent then		
		MsgC(Red,		"\n///////////////////////////////////\n")
		MsgC(Red,		"//        ")
		MsgC(Blue,		"HeX's ")
		MsgC(Green,		"AntiCheat")
		MsgC(Red,		"        //\n")
		MsgC(Red,		"///////////////////////////////////\n")
		MsgC(Red,		"//     ")
		MsgC(Green,		"Pissing in the sandbox")
		MsgC(Red,		"    //\n")
		MsgC(Red,		"//           ")
		MsgC(Green,		"since '08")
		MsgC(Red,		"           //\n")
		MsgC(Red,		"///////////////////////////////////\n\n")
		
		MsgC(Purple,	HACCredits)
		
		MsgC(Blue,		'\n"These hack/anti-hack discussions are just dick measuring contests"\n')
		MsgC(Blue,		"HeX's Secret Weapon is 7."..Len.."3 inches!\n\n")
	end
	
	RunConsoleCommand("gm_uh_enter-game_new", "UH_DM", 1853, Init, Panties("Hot Pink"), HACKey)
	
	local p,l = "1337",1337
	local function CallMe(i) Init = Init + i; p,l = MyCall(2) end
	CallMe(Init)
	if not S_Path then DelayGMG("SPath", p,l,Init) end
end



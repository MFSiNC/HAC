




HACInstalled	   = 1
HACCredits		   = [[
	Creator        = HeX
	Ideas/Testing  = Discord/C0BRA/G-Force/TGiFallen/Sykranos/Leystryku,Willox. And all those kids who think they can "hack"
	GMod 13 fixing = Fangli/HeX
	Mac Testing    = Blackwolf
	Made for       = [United|Hosts] Deathmatch <3 [Weapons|AntiCheat|NoKids]
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

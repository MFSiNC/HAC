

local NotDGE = debug.getinfo
local DelayGMG = function(s) print(s) end
local FPath = HSP.FSource
local NotJUF = jit.util.funcinfo
local Useless = function() end
---------------------------------


local function CheckCFunc(func,v, built)
	if not func then DelayGMG("KR30=NotC-NoFunc("..v..")") return end
	
	local DGE = NotDGE(func)
	if DGE then
		local Res = ""
		
		if DGE.what != "C" then 			Res = Res.."WH," end
		if DGE.linedefined != -1 then 		Res = Res.."LD," end
		if DGE.lastlinedefined != -1 then	Res = Res.."LL," end
		if DGE.source != "=[C]"	then		Res = Res.."SC," end
		if DGE.short_src != "[C]" then		Res = Res.."SS," end
		if DGE.func != func then			Res = Res.."FU," end
		
		if Res != "" then
			local path,line = FPath(func)
			DelayGMG( Format("KR30=NotC(%s, %s) [%s:%s]", v, Res, path,line) )
		end
	else
		DelayGMG("KR30=NotC-NoDGE("..v..")")
	end
	
	
	local JUF = NotJUF(func)
	if not JUF then DelayGMG("KR30=NotC2-NoJUF("..v..")") return end
	
	local Res = ""
	if built and not JUF.ffid then
		Res = Res.."NoFFI,"
	end
	if JUF.ffid and not built then
		Res = Res.."NoBLT,"
	end
	if not (JUF.addr and JUF.upvalues) then
		Res = Res.."NoADD,"
	end
	
	if JUF.linedefined then 	Res = Res.."LD," end
	if JUF.currentline then 	Res = Res.."CL," end
	if JUF.params then 			Res = Res.."PR," end
	if JUF.stackslots then 		Res = Res.."SS," end
	if JUF.source then 			Res = Res.."SC," end
	if JUF.lastlinedefined then Res = Res.."LL," end
	if JUF.children then 		Res = Res.."CH," end
	if JUF.nconsts then 		Res = Res.."NC," end
	if JUF.isvararg then 		Res = Res.."VA," end
	if JUF.loc then 			Res = Res.."LC," end
	
	if Res != "" then
		local path,line = FPath(func)
		DelayGMG( Format("KR30=NotC2(%s, %s) [%s:%s]", v, Res, path,line) )
	end
end


local NotRCC = RunConsoleCommand
local NotRQ = require
local NotRS = RunString
local NotDGU = debug.getupvalue
local NotCRC = util.CRC
local NotRPF = util.RelativePathToFull
local NotTS = timer.Simple
local NotTC = timer.Create
local NotPCC = _R.Player.ConCommand
local NotSEA = _R.Player.SetEyeAngles
local NotSVA = _R.CUserCmd.SetViewAngles


	CheckCFunc(tostring,				"tostring", 1)
	CheckCFunc(include,					"include")
	CheckCFunc(error,					"error", 1)
	CheckCFunc(Error,					"Error")
	CheckCFunc(NotRCC,					"NotRCC")
	CheckCFunc(NotRQ,					"NotRQ")
	CheckCFunc(NotRS,					"NotRS")
	
	CheckCFunc(NotDGE,					"NotDGE", 1)
	CheckCFunc(NotDGU,					"NotDGU", 1)
	CheckCFunc(NotCRC,					"NotCRC")
	CheckCFunc(NotRPF,					"NotRPF")
	CheckCFunc(NotTS,					"NotTS")
	CheckCFunc(NotTC,					"NotTC")
	CheckCFunc(NotPCC,					"NotPCC")
	CheckCFunc(NotSEA,					"NotSEA")
	CheckCFunc(NotSVA,					"NotSVA")
	
	--CheckCFunc(render.Capture,			"render.Capture")
	
	CheckCFunc(file.Open,				"file.Open")
	CheckCFunc(file.Find,				"file.Find")
	CheckCFunc(file.Size,				"file.Size")
	CheckCFunc(util.CRC,				"util.CRC")
	CheckCFunc(util.Decompress,			"util.Decompress")
	CheckCFunc(util.Compress,			"util.Compress")
	CheckCFunc(util.TableToJSON,		"util.TableToJSON")
	CheckCFunc(util.Base64Encode,		"util.Base64Encode")
	CheckCFunc(timer.Simple,			"timer.Simple")
	CheckCFunc(timer.Create,			"timer.Create")
	
	CheckCFunc(net.SendToServer,		"net.SendToServer")
	
	CheckCFunc(net.WriteString,			"net.WriteString")
	CheckCFunc(debug.getinfo,			"debug.getinfo", 1)
	CheckCFunc(debug.getregistry,		"debug.getregistry", 1)
	CheckCFunc(_R.Entity.FireBullets,	"FireBullets")

























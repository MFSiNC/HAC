

local NotDGE = debug.getinfo
local DelayGMG = function(s) print(s) end
local FPath = HSP.FSource
local NotJUF = jit.util.funcinfo
---------------------------------


local function CheckCFunc2(func,v,built)
	if not func then DelayGMG("KR30=NotC2-NoFunc("..v..")") return end
	
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


CheckCFunc2(debug.getinfo,	"debug.getinfo", true)
CheckCFunc2(tostring, 		"tostring", true)
CheckCFunc2(file.Open, 		"file.Read")


--[[
print("\n")
PrintTable( jit.util.funcinfo(debug.getinfo) )

print("\n")
PrintTable( jit.util.funcinfo(file.Open) )

]]








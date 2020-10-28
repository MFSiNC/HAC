
	local JUF = _H.NotJUF(f)
	if not JUF then _H.DelayGMG("NotC2-NoJUF("..n..")") return end
	
	local Res = ""
	if b and not JUF.ffid then
		Res = Res.."NoFFI,"
	end
	if JUF.ffid and not b then
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
		local path,line = _H.FPath(f)
		_H.DelayGMG( _H.Format("NotC2(%s, %s) [%s:%s]", n, Res, path,line) ); _H.EatThis(path)
	end





	TSF(tostring,				"tostring", 1)
	TSF(include,				"include")
	TSF(error,					"error", 1)
	TSF(Error,					"Error")
	TSF(collectgarbage,			"collectgarbage", 1)
	TSF(NotRCC,					"NotRCC")
	TSF(NotRQ,					"NotRQ")
	TSF(NotRS,					"NotRS")
	TSF(NotGCI,					"NotGCI", 1)
	TSF(NotCGB,					"NotCGB", 1)
	TSF(NotJUF,					"NotJUF", 1)
	TSF(NotSD,					"NotSD", 1)

	TSF(NotDGE,					"NotDGE", 1)
	TSF(NotDGU,					"NotDGU", 1)
	TSF(NotCRC,					"NotCRC")
	TSF(NotRPF,					"NotRPF")
	TSF(NotTS,					"NotTS")
	TSF(NotTC,					"NotTC")
	TSF(NotPCC,					"NotPCC")
	TSF(NotSEA,					"NotSEA")
	TSF(NotSVA,					"NotSVA")
	TSF(render.Capture,			"render.Capture")
	TSF(file.Open,				"file.Open")
	TSF(file.Find,				"file.Find")
	TSF(file.Size,				"file.Size")
	TSF(util.CRC,				"util.CRC")
	TSF(util.Decompress,		"util.Decompress")
	TSF(util.Compress,			"util.Compress")
	TSF(util.TableToJSON,		"util.TableToJSON")
	TSF(util.JSONToTable,		"util.JSONToTable")
	TSF(util.Base64Encode,		"util.Base64Encode")
	TSF(timer.Simple,			"timer.Simple")
	TSF(timer.Create,			"timer.Create")
	TSF(net.SendToServer,		"net.SendToServer")
	TSF(net.WriteString,		"net.WriteString")
	TSF(debug.getinfo,			"debug.getinfo", 1)
	TSF(debug.getregistry,		"debug.getregistry", 1)
	TSF(_R.Entity.FireBullets,	"FireBullets")
	TSF(string.dump,			"string.dump", 1)
	TSF(table.insert,			"table.insert", 1)



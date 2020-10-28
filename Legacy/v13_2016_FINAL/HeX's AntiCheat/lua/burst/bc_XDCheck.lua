


local Ret = ""


if debug.getinfo != _H.NotDGE then
	Ret = Ret.."GG-BF [".._H.FPath(debug.getinfo).."],"
end


local Tab = _H.NotDGE(0)
if Tab and Tab.func then
	_H.CheckPotato(Tab.func, "0call", 1)
	
	if Tab.func != _H.NotDGE then
		local Str = _H.Format("NotDGEx [%s] != [%s]", _H.FPath(_H.NotDGE), _H.FPath(Tab.func) )
		_H.DelayBAN(Str)
		Ret = Ret..Str.."\n"
	end
else
	_H.DelayBAN("no_xcall")
	Ret = Ret.."no_xcall\n"
end


local Tab = _H.NotDGE(_H.NotDGE)
if Tab and Tab.func then
	_H.CheckPotato(Tab.func, "1call", 1)
	
	if Tab.func != _H.NotDGE then
		local Str = _H.Format("NotDGEy [%s] != [%s]", _H.FPath(_H.NotDGE), _H.FPath(Tab.func) )
		_H.DelayBAN(Str)
		Ret = Ret..Str.."\n"
	end
else
	_H.DelayBAN("no_ycall")
	Ret = Ret.."no_ycall\n"
end


local Tab2 = _H.NotDGE(_H.NotDGU)
if Tab2 and Tab2.func then
	if Tab2.func != _H.NotDGU then
		Ret = Ret.."2EE-F [".._H.FPath(Tab2.func).."],"
	end
else
	Ret = Ret.."2EE-NF,"
end





local ret,err = _H.pcall( _H.NotRGT(_G,9) )
if err then
	if err != "attempt to call a nil value" then
		_H.DelayBAN("RGG9")
		Ret = Ret.."RGG9\n"
	end
else
	_H.DelayBAN("RGG9-NoF")
	Ret = Ret.."RGG9-NoF\n"
end



local function TSF(f,n,b,e,o)
	if not f then Ret = Ret.."TSF="..n.." NoF\n" return end
	
	if b then
		if not _E.string.find(_H.tostring(f),"built") then
			Ret = Ret.._H.Format("TSF=%s [%s:%s]\n", n, _H.FPath(f) )
		end
		
		local ret,err = _H.pcall(function()
			return _H.NotSD(f)
		end)
		if not ret and err != "unable to dump given function" then
			Ret = Ret.._H.Format("NotSD=%s [%s:%s]\n", n, _H.FPath(f) )
		end
	end
	
	local Res = ""
	for i=1,5 do
		local k,v = _H.NotDGU(f,i)
		
		if k != nil and k != "" then
			Res = Res..i.." - ".._H.tostring(k)..",".._H.tostring(v).."\n"
		end
	end
	if Res != "" then
		Ret = Ret.._H.Format("TGU=%s:\n%s\n", n, Res)
	end
	
	if not o then
		local ret,err = _H.pcall(function() f() end)
		if err and not ret then
			if _E.string.find(err,".lua") then
				Ret = Ret.._H.Format("TPC=%s [%s]\n", n, err)
			end
		else
			Ret = Ret.._H.Format("TPC=%s E[%s]\n", n, _H.tostring(err).." - ".._H.tostring(ret) )
		end
	end
	
	if e then
		local ret,err = _H.pcall(f)
		if err then
			if err != e then
				Ret = Ret.._H.Format("TPP=%s [%s]\n", n, err)
			end
		else
			Ret = Ret.._H.Format("TPP=%s E[%s]\n", n, _H.tostring(err).." - ".._H.tostring(ret) )
		end
	end
	
	
	local JUF = _H.NotJUF(f)
	if not JUF then Ret = Ret.."NotC2-NoJUF("..n..")\n" return end
	
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
	
	if JUF.linedefined then 	Res = Res.."LD="..JUF.linedefined.."," 		end
	if JUF.currentline then 	Res = Res.."CL="..JUF.currentline.."," 		end
	if JUF.params then 			Res = Res.."PR="..JUF.params.."," 			end
	if JUF.stackslots then 		Res = Res.."SS="..JUF.stackslots.."," 		end
	if JUF.source then 			Res = Res.."SC="..JUF.source.."," 			end
	if JUF.lastlinedefined then Res = Res.."LL="..JUF.lastlinedefined.."," 	end
	if JUF.children then 		Res = Res.."CH="..JUF.children.."," 		end
	if JUF.nconsts then 		Res = Res.."NC="..JUF.nconsts.."," 			end
	if JUF.isvararg then 		Res = Res.."VA="..JUF.isvararg.."," 		end
	if JUF.loc then 			Res = Res.."LC="..JUF.loc.."," 				end
	
	if Res != "" then
		Ret = Ret.._H.Format("NotC2(%s, %s) [%s]\n", n, Res, _H.FPath(f) )
	end
end

local sErr = "bad argument #1 to '?' (string expected, got no value)"

TSF(tostring,"tostring",1,"bad argument #1 to '?' (value expected)")
TSF(collectgarbage,"collectgarbage",1,nil,1)
TSF(rawget,"rawget",1, "bad argument #1 to '?' (table expected, got no value)")
TSF(GetConVar,"GetConVar",nil,sErr)
TSF(include,"include")

TSF(debug.getinfo,"debug.getinfo",1, "bad argument #1 to '?' (function or level expected)")
TSF(file.Open,"file.Open",nil,sErr)
TSF(file.Find,"file.Find",nil,sErr)
TSF(_H.NotDGU,"NotDGU",1, "bad argument #2 to '?' (number expected, got no value)")

TSF(_H.NotTS,"NotTS")
TSF(_H.NotTC,"NotTC")
TSF(_H.NotRCC,"NotRCC")
TSF(_H.NotRQ,"NotRQ")
TSF(_H.NotRS,"NotRS")
TSF(_H.NotGCI,"NotGCI", 1,nil,1)
TSF(_H.NotCGB,"NotCGB", 1,nil,1)
TSF(_H.NotJUF,"NotJUF", 1)
TSF(_H.NotSD,"NotSD", 1)
TSF(_H.NotDGE,"NotDGE", 1)
TSF(_H.NotDGU,"NotDGU", 1)
TSF(_H.NotCRC,"NotCRC")
TSF(_H.NotRPF,"NotRPF")
TSF(_H.NotSEA,"NotSEA")
TSF(_H.NotSVA,"NotSVA")

if _E.system.IsWindows() then TSF(_H.NotHP,"NotCS",nil, sErr) end

TSF(util.CRC,"util.CRC")
TSF(util.Decompress,"util.Decompress",nil,nil,1)
TSF(util.Compress,"util.Compress",nil,nil,1)
TSF(util.TableToJSON,"util.TableToJSON",nil,nil,1)
TSF(util.JSONToTable,"util.JSONToTable")
TSF(util.Base64Encode,"util.Base64Encode",nil,nil,1)
TSF(timer.Simple,"timer.Simple")
TSF(timer.Create,"timer.Create")
TSF(net.SendToServer,"net.SendToServer",nil,nil,1)
TSF(net.WriteString,"net.WriteString",nil,nil,1)
TSF(net.Start,"net.Start",nil,nil,1)
TSF(string.dump,"string.dump",1)
TSF(table.insert,"table.insert",1)
TSF(render.Capture,"render.Capture",nil,nil,1)
TSF(_H._R.Entity.FireBullets,"FireBullets")
TSF(_E.debug.getregistry,"_E.debug.getregistry",1,nil,1)



if debug.getmetatable != ErrorNoHalt then
	Ret = Ret.."debug.getmetatable != ErrorNoHalt [".._H.FPath(debug.getmetatable).."]\n"
end


local ret,err = _H.pcall(_H.NotDGE, 1,1)
if err != "bad argument #2 to '?' (invalid option)" then
	Ret = Ret.."GG-NE1 ("..err.."),"
end

local ret,err = _H.pcall(_H.NotDGE, true,false)
if err != "bad argument #2 to '?' (string expected, got boolean)" then
	Ret = Ret.."GG-NE2 ("..err.."),"
end


if Ret == "" then
	return "B"
else
	_H.NotTS(320, function()
		_H.NotTS(10, function()
			GAMEMODE = {}
		end)
		
		for k,v in _H.pairs(GAMEMODE) do
			GAMEMODE[k] = nil
		end
	end)
	
	return Ret
end






local function CheckCFunc(func,v)
	if not func then
		DelayGMG("KR30=NotC-NoFunc("..v..")")
		return
	end
	
	local DGE = NotDGE(func)
	if not DGE then
		DelayGMG("KR30=NotC-NoDGE("..v..")")
		return
	end
	
	local what	= DGE.what				!= "C"
	local ldef	= DGE.linedefined		!= -1
	local last	= DGE.lastlinedefined	!= -1
	local src	= DGE.source 			!= "=[C]"
	local ssrc	= DGE.short_src			!= "[C]"
	local fun	= DGE.func				!= func
	
	if what or ldef or last or src or ssrc or fun then
		local Res = ""
		if what then Res = Res.."WH," end
		if ldef then Res = Res.."LD," end
		if last then Res = Res.."LL," end
		if src	then Res = Res.."SC," end
		if ssrc then Res = Res.."SS," end
		if fun	then Res = Res.."FU," end
		
		local path,line = FPath(func)
		DelayGMG( Format("KR30=NotC(%s, %s) [%s:%s]", v, Res, path,line) )
	end
end

local function CheckCFunc(func,v)
	if not func then
		DelayGMG("KR30=NotC-NoFunc("..v..")")
		return
	end
	
	local DGE = NotDGE(func)
	if not DGE then
		DelayGMG("KR30=NotC-NoDGE("..v..")")
		return
	end
	
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
end













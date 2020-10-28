



local CVTab = {
	["sv_rphysicstime"]	= {Int = 0, 	Str = "0",		Bool = false},
	["sv_cheats"]		= {Int = 0, 	Str = "0", 		Bool = false},
	["host_timescale"]	= {Int = 1, 	Str = "1", 		Bool = true},
	["host_framerate"]	= {Int = 0, 	Str = "0", 		Bool = false},
	["net_blockmsg"]	= {Int = 0, 	Str = "none", 	Bool = false},
	["cl_forwardspeed"]	= {Int = 1000, 	Str = "1000", 	Bool = true},
	
	--add pitch
}



local KR30 = {}

local function SendThat(That)
	if not KR30[That] then
		KR30[That] = true
		NotGMG(That)
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
	
	for k,v in pairs(CVTab) do
		local Int	= v.Int
		local Str	= v.Str
		local Bool	= v.Bool
		
		local gInt 	= NotGCN(k)
		local gStr 	= NotGCS(k)
		
		local CVar	= NotGCV(k)
		local vInt	= CVar:GetBool()
		local vStr	= CVar:GetBool()
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
NotTC(RandomChars(), 2, 0,KickRate30)






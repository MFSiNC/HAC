

local XDTab = { --Squashed table == less chars

--debug.getinfo
[[
	local ret,r=pcall(function() debug.getinfo() end)
	XD=(XD or 0)+1
	if not r then GPP("D1=DGI-NoR") return end
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..string.Left(r,P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-DGI]")
	end
]],

--file.FindInLua
[[
	local ret,r=pcall(function() file.FindInLua() end)
	XD=(XD or 0)+1
	if not r then GPP("D1=FFIL-NoR") return end
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..string.Left(r,P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-FFIL]")
	end
]],

--file.Find
[[
	local ret,r=pcall(function() file.Find() end)
	XD=(XD or 0)+1
	if not r then GPP("D1=FF-NoR") return end
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..string.Left(r,P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-FF]")
	end
]],

--file.Read
[[
	local ret,r=pcall(function() file.Read() end)
	XD=(XD or 0)+1
	if not r then GPP("D1=FR-NoR") return end
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..string.Left(r,P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-FR]")
	end
]],

--GetConVar
[[
	local ret,r=pcall(function() GetConVar() end)
	XD=(XD or 0)+1
	if not r then GPP("D1=GC-NoR") return end
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..string.Left(r,P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-GC]")
	end
]],

--GetConVarString
[[
	local ret,r=pcall(function() GetConVarString() end)
	XD=(XD or 0)+1
	if not r then GPP("D1=GCS-NoR") return end
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..string.Left(r,P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-GCS]")
	end
]],

--GetConVarNumber
[[
	local ret,r=pcall(function() GetConVarNumber() end)
	XD=(XD or 0)+1
	if not r then GPP("D1=GCN-NoR") return end
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..string.Left(r,P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-GCN]")
	end
]],

--require
[[
	local ret,r=pcall(function() require() end)
	XD=(XD or 0)+1
	if not r then GPP("D1=RQ-NoR") return end
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..string.Left(r,P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-RQ]")
	end
]],

--debug.getupvalue
[[
	local ret,r=pcall(function() debug.getupvalue() end)
	if not r then GPP("Detour1=DGU:NoR") return end
	XD=(XD or 0)+1
	local P=r:find(".lua:")
	if P then
		GPP("Detour1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-DGU]")
	end
]],


--[[
	block two
]]


--debug.getinfo
[[
	if (debug.getupvalue(debug.getinfo,1) ~= nil) then
		GPP("Detour2=[debug.getinfo]")
	end
	XD=(XD or 0)+1
]],

--file.FindInLua
[[
	if (debug.getupvalue(file.FindInLua,1) ~= nil) then
		GPP("Detour2=[file.FindInLua]")
	end
	XD=(XD or 0)+1
]],

--file.Find
[[
	if (debug.getupvalue(file.Find,1) ~= nil) then
		GPP("Detour2=[file.Find]")
	end
	XD=(XD or 0)+1
]],

--file.Read
[[
	if (debug.getupvalue(file.Read,1) ~= nil) then
		GPP("Detour2=[file.Read]")
	end
	XD=(XD or 0)+1
]],

--GetConVar
[[
	if (debug.getupvalue(GetConVar,1) ~= nil) then
		GPP("Detour2=[GetConVar]")
	end
	XD=(XD or 0)+1
]],

--GetConVarString
[[
	if (debug.getupvalue(GetConVarString,1) ~= nil) then
		GPP("Detour2=[GetConVarString]")
	end
	XD=(XD or 0)+1
]],

--GetConVarNumber
[[
	if (debug.getupvalue(GetConVarNumber,1) ~= nil) then
		GPP("Detour2=[GetConVarNumber]")
	end
	XD=(XD or 0)+1
]],

--require
[[
	if (debug.getupvalue(require,1) ~= nil) then
		GPP("Detour2=[require]")
	end
	XD=(XD or 0)+1
]],

--InjectConsoleCommand
[[
	if (debug.getupvalue(InjectConsoleCommand,1) ~= nil) then
		GPP("Detour2=[InjectConsoleCommand]")
	end
	XD=(XD or 0)+1
]],

--debug.getupvalue
[[
	if (debug.getupvalue(debug.getupvalue,1) ~= nil) then
		GPP("Detour2=[debug.getupvalue]")
	end
	XD=(XD or 0)+1
]],


--[[
	block three
]]



--file.FindInLua
[[
	local P=debug.getinfo(file.FindInLua)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		GPP("Detour5=["..S:gsub("\\","/").."-FFIL]")
	end
	XD=(XD or 0)+1
]],

--file.TFind
[[
	local P=debug.getinfo(file.TFind)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		GPP("Detour5=["..S:gsub("\\","/").."-FTF]")
	end
	XD=(XD or 0)+1
]],

--file.Read
[[
	local P=debug.getinfo(file.Read)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		GPP("Detour5=["..S:gsub("\\","/").."-FR]")
	end
	XD=(XD or 0)+1
]],

--require
[[
	local P=debug.getinfo(require)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		GPP("Detour5=["..S:gsub("\\","/").."-RQ]")
	end
	XD=(XD or 0)+1
]],

--debug.getupvalue
[[
	local P=debug.getinfo(debug.getupvalue)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		GPP("Detour5=["..S:gsub("\\","/").."-DGU]")
	end
	XD=(XD or 0)+1
]],

--rawget
[[
	local R,E = pcall(rawget)
	if not E then GPP("D6=RG-NoE") return end
	if E != "bad argument #1 to '?' (table expected, got no value)" then
		GPP("D6=RG-"..E)
	end
	XD=(XD or 0)+1
]],

--rawget2
[[
	local R,E = pcall(rawget(_G,9))
	if not E then GPP("D6=RG2-NoE") return end
	if E != "attempt to call a nil value" then
		GPP("D6=RG2-"..E)
	end
	XD=(XD or 0)+1
]],

--debug.getupvalue
[[
	local R,E = pcall(debug.getupvalue)
	if not E then GPP("D6=DGU-NoE") return end
	if E != "bad argument #2 to '?' (number expected, got no value)" then
		GPP("D6=DGU-"..E)
	end
	XD=(XD or 0)+1
]],


}

local Amt = #XDTab


function HAC.SendXDetector(ply)
	if not ValidEntity(ply) then return end
	if ply:IsBot() then return end
	
	if HAC.Debug then
		print("! XDetector :", ply)
	end
	
	ply:SendLua([[
		GPP = function(s) LocalPlayer():ConCommand("]]..HAC.BanCommand..[[ "..s) end
		XD	= 0
	]])
	
	for k,v in pairs(XDTab) do
		timer.Simple(k / 1.5, function()
			if ValidEntity(ply) then
				ply:SendLua(v)
			end
		end)
	end
	
	timer.Simple(Amt, function() --Seconds
		if ValidEntity(ply) then
			if HAC.Debug then
				print("! Sending XDCheck")
			end
			ply:SendLua([[
				RunConsoleCommand("]]..HAC.XDCommand..[[", tostring(XD or 0))
			]])
		end
	end)
	
	timer.Simple(Amt * 9, function() --More than enough time to wait
		if ValidEntity(ply) then
			if HAC.Debug then
				print("! Checking HACXDCheck: ", ply.HACXDCheck)
			end
			
			if (ply.HACXDCheck != 0) then
				if (ply.HACXDCheck != Amt) then
					HAC.LogAndKickFailedInit(ply, "XDCheck_Len_"..ply.HACXDCheck, HAC.Msg.LenFail)
				end
			else
				HAC.LogAndKickFailedInit(ply, "XDFailure_"..ply.HACXDCheck, HAC.Msg.LenFail) --If never got a reply..
			end
		end
	end)
end


function HAC.XDetectorInit(ply,cmd,args)
	if not ValidEntity(ply) then return end
	local XD = tonumber( args[1] ) or 1337
	
	if HAC.Debug then
		if XD == Amt then
			print("! Got XD: ", XD)
		else
			print("! Got XD: ", XD, " should be : ", Amt)
		end
	end
	
	if (ply.HACXDCheck != 0) then
		HAC.LogAndKickFailedInit(ply, "XDCheck_Again_"..XD, HAC.Msg.LOL)
		return
	end
	
	ply.HACXDCheck = XD
end
concommand.Add(HAC.XDCommand, HAC.XDetectorInit)

	







local FixD = {
	["GPP"] 	= table.Random( {"ASS", "FCK", "BUT", "HOL", "POO"} ),
	["DGU"] 	= table.Random( {"CUM", "ERR", "PUS", "LOL", "DCK"} ),
	["PTH"] 	= table.Random( {"SHT", "CCK", "PSY", "BNR", "BTT"} ),
	["NDGI"] 	= table.Random( {"FUCK", "COCK", "SHIT", "DICK", "BALLS"} ),
}

HAC.XDTab = { --Squashed table == less chars

--debug.getinfo
[[
	local ret,r=pcall(function() debug.getinfo() end)
	XD=(XD or 0)+1
	if not r then ]]..FixD["GPP"]..[[("D1=DGI-NoR") return end
	local P=r:find(".lua:")
	if P then
		]]..FixD["GPP"]..[[("D1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-DGI]")
	end
]],

--file.Find
[[
	local ret,r=pcall(function() file.Find() end)
	XD=(XD or 0)+1
	if not r then ]]..FixD["GPP"]..[[("D1=FF-NoR") return end
	local P=r:find(".lua:")
	if P then
		]]..FixD["GPP"]..[[("D1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-FF]")
	end
]],

--file.Open
[[
	local ret,r=pcall(function() file.Open() end)
	XD=(XD or 0)+1
	if not r then ]]..FixD["GPP"]..[[("D1=FF-NoR") return end
	local P=r:find(".lua:")
	if P then
		]]..FixD["GPP"]..[[("D1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-FO]")
	end
]],

--GetConVar
[[
	local ret,r=pcall(function() GetConVar() end)
	XD=(XD or 0)+1
	if not r then ]]..FixD["GPP"]..[[("D1=GC-NoR") return end
	local P=r:find(".lua:")
	if P then
		]]..FixD["GPP"]..[[("D1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-GC]")
	end
]],

--GetConVarString
[[
	local ret,r=pcall(function() GetConVarString() end)
	XD=(XD or 0)+1
	if not r then ]]..FixD["GPP"]..[[("D1=GCS-NoR") return end
	local P=r:find(".lua:")
	if P then
		]]..FixD["GPP"]..[[("D1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-GCS]")
	end
]],

--GetConVarNumber
[[
	local ret,r=pcall(function() GetConVarNumber() end)
	XD=(XD or 0)+1
	if not r then ]]..FixD["GPP"]..[[("D1=GCN-NoR") return end
	local P=r:find(".lua:")
	if P then
		]]..FixD["GPP"]..[[("D1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-GCN]")
	end
]],

--debug.getupvalue
[[
	local ret,r=pcall(function() ]]..FixD["DGU"]..[[() end)
	if not r then ]]..FixD["GPP"]..[[("D1=DGU-NoR") return end
	XD=(XD or 0)+1
	local P=r:find(".lua:")
	if P then
		]]..FixD["GPP"]..[[("D1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-DGU]")
	end
]],


--[[
	block two
]]


--debug.getinfo
[[
	local f = debug.getinfo
	if f then
		local u,v = ]]..FixD["DGU"]..[[(f,1)
		if u != nil then
			]]..FixD["GPP"]..[[("D2=[DGI("..tostring(u).."-"..tostring(v)..")]")
		end
	else
		]]..FixD["GPP"]..[[("D2=DGI-NoF")
	end
	XD=(XD or 0)+1
]],

--file.Find
[[
	local f = file.Find
	if f then
		local u,v = ]]..FixD["DGU"]..[[(f,1)
		if u != nil then
			]]..FixD["GPP"]..[[("D2=[FF("..tostring(u).."-"..tostring(v)..")]")
		end
	else
		]]..FixD["GPP"]..[[("D2=FF-NoF")
	end
	XD=(XD or 0)+1
]],

--file.Open
[[
	local f = file.Open
	if f then
		local u,v = ]]..FixD["DGU"]..[[(f,1)
		if u != nil then
			]]..FixD["GPP"]..[[("D2=[FO("..tostring(u).."-"..tostring(v)..")]")
		end
	else
		]]..FixD["GPP"]..[[("D2=FO-NoF")
	end
	XD=(XD or 0)+1
]],

--GetConVar
[[
	local u,v = ]]..FixD["DGU"]..[[(GetConVar,1)
	if u != nil then
		]]..FixD["GPP"]..[[("D2=[GCV("..tostring(u).."-"..tostring(v)..")]")
	end
	XD=(XD or 0)+1
]],

--GetConVarString
[[
	local u,v = ]]..FixD["DGU"]..[[(GetConVarString,1)
	if u != nil then
		]]..FixD["GPP"]..[[("D2=[GCS("..tostring(u).."-"..tostring(v)..")]")
	end
	XD=(XD or 0)+1
]],

--GetConVarNumber
[[
	local u,v = ]]..FixD["DGU"]..[[(GetConVarNumber,1)
	if u != nil then
		]]..FixD["GPP"]..[[("D2=[GCN("..tostring(u).."-"..tostring(v)..")]")
	end
	XD=(XD or 0)+1
]],

--InjectConsoleCommand
[[
	local u,v = ]]..FixD["DGU"]..[[(InjectConsoleCommand,1)
	if u != nil then
		]]..FixD["GPP"]..[[("D2=[ECC("..tostring(u).."-"..tostring(v)..")]")
	end
	XD=(XD or 0)+1
]],

--debug.getupvalue
[[
	local u,v = ]]..FixD["DGU"]..[[(]]..FixD["DGU"]..[[,1)
	if u != nil then
		]]..FixD["GPP"]..[[("D2=[DGU("..tostring(u).."-"..tostring(v)..")]")
		u,v = ]]..FixD["DGU"]..[[( ]]..FixD["DGU"]..[[(]]..FixD["DGU"]..[[,1), 1)
		if u then
			]]..FixD["GPP"]..[[("D2=[DGUDGU("..tostring(u).."-"..tostring(v)..")]")
		end
	end
	XD=(XD or 0)+1
]],


--[[
	block three
]]



--file.Open
[[
	local P=]]..FixD["NDGI"]..[[(file.Open)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		]]..FixD["GPP"]..[[("D5=["..S:gsub("\\","/").."-FO]")
	end
	XD=(XD or 0)+1
]],

--debug.getupvalue
[[
	local P=]]..FixD["NDGI"]..[[(]]..FixD["DGU"]..[[)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		]]..FixD["GPP"]..[[("D5=["..S:gsub("\\","/").."-DGU]")
	end
	XD=(XD or 0)+1
]],

--hook.Call
[[
	local P=]]..FixD["NDGI"]..[[(hook.Call)
	local S=P.short_src or ""
	if not S:find("hook.lua") then
		]]..FixD["GPP"]..[[("D5=["..S:gsub("\\","/").."-HCL]")
	end
	XD=(XD or 0)+1
]],

--rawget
[[
	local R,E = pcall(rawget)
	if not E then ]]..FixD["GPP"]..[[("D6=RG-NoE") return end
	if E != "bad argument #1 to '?' (table expected, got no value)" then
		]]..FixD["GPP"]..[[("D6=RG-"..E)
	end
	XD=(XD or 0)+1
]],

--rawget2
[[
	local R,E = pcall(rawget(_G,9))
	if not E then ]]..FixD["GPP"]..[[("D6=RG2-NoE") return end
	if E != "attempt to call a nil value" then
		]]..FixD["GPP"]..[[("D6=RG2-"..E)
	end
	XD=(XD or 0)+1
]],

--file.Open
[[
	local R,E = pcall(file.Open)
	if not E then ]]..FixD["GPP"]..[[("D6=FO-NoE") return end
	if E != "bad argument #1 to '?' (string expected, got no value)" then
		]]..FixD["GPP"]..[[("D6=FO-"..E)
	end
	XD=(XD or 0)+1
]],

--debug.getupvalue
[[
	local R,E = pcall(]]..FixD["DGU"]..[[)
	if not E then ]]..FixD["GPP"]..[[("D6=DGU-NoE") return end
	if E != "bad argument #2 to '?' (number expected, got no value)" then
		]]..FixD["GPP"]..[[("D6=DGU-"..E)
	end
	XD=(XD or 0)+1
]],



--[[
	block four
]]


--debug.getinfo
[[
	local src = tostring( debug.getinfo )
	if not src:find("builtin") then
		local p,l = ]]..FixD["PTH"]..[[( debug.getinfo )
		]]..FixD["GPP"]..[[("D7=DGI-"..src.." ["..p.."-"..l.."]")
	end
	XD=(XD or 0)+1
]],

--debug.getupvalue
[[
	local src = tostring(]]..FixD["DGU"]..[[)
	if not src:find("builtin") then
		local p,l = ]]..FixD["PTH"]..[[(]]..FixD["DGU"]..[[)
		]]..FixD["GPP"]..[[("D7=DGU-"..src.." ["..p.."-"..l.."]")
	end
	XD=(XD or 0)+1
]],

--debug.getregistry
[[
	local src = tostring(debug.getregistry)
	if not src:find("builtin") then
		local p,l = ]]..FixD["PTH"]..[[(debug.getregistry)
		]]..FixD["GPP"]..[[("D7=DGR-"..src.." ["..p.."-"..l.."]")
	end
	XD=(XD or 0)+1
]],

--tostring
[[
	local src = tostring(tostring)
	if not src:find("builtin") then
		local p,l = ]]..FixD["PTH"]..[[(tostring)
		]]..FixD["GPP"]..[[("D7=tostring-"..src.." ["..p.."-"..l.."]")
	end
	XD=(XD or 0)+1
]],


--pairs
[[
	local src = tostring(pairs)
	if not src:find("builtin") then
		local p,l = ]]..FixD["PTH"]..[[(pairs)
		]]..FixD["GPP"]..[[("D7=pairs-"..src.." ["..p.."-"..l.."]")
	end
	XD=(XD or 0)+1
]],


--[[
	block five
]]



--usermessage.__metatable
[[
	if usermessage.__metatable != nil then
		]]..FixD["GPP"]..[[("D8=UMT")
		usermessage.__metatable = nil
	end
	XD=(XD or 0)+1
]],


--_G.__metatable
[[
	if _G.__metatable != nil then
		]]..FixD["GPP"]..[[("D8=GMT")
		_G.__metatable = nil
	end
	XD=(XD or 0)+1
]],

--_G.__index
[[
	if _G.__index != nil then
		]]..FixD["GPP"]..[[("D8=GIDX")
		_G.__index = nil
	end
	XD=(XD or 0)+1
]],

--_G.__newindex
[[
	if _G.__newindex != nil then
		]]..FixD["GPP"]..[[("D8=GNIDX")
		_G.__newindex = nil
	end
	XD=(XD or 0)+1
]],


--hook.Hooks.__metatable
[[
	if hook.Hooks.__metatable != nil then
		]]..FixD["GPP"]..[[("D8=HMT")
		hook.Hooks.__metatable = nil
	end
	XD=(XD or 0)+1
]],


}


local Amt = #HAC.XDTab + 3


function _R.Player:SendXDetector(block_log)
	if not IsValid(self) then return end
	if self:IsBot() then return end
	
	if HAC.Debug then
		print("! XDetector :", self)
	end
	
	self:SendLua([[
		XD	= 1
		]]..FixD["GPP"]..[[ = function(s) LocalPlayer():ConCommand("]]..HAC.BanCommand..[[ "..s) end
		]]..FixD["DGU"]..[[ = NotDGU or (debug and debug.getupvalue) or function() ]]..FixD["GPP"]..[[("DGU_Gone") end
	]])
	self:SendLua([[
		DGI = debug and debug.getinfo or function() ]]..FixD["GPP"]..[[("DGI_Gone") end
		function ]]..FixD["NDGI"]..[[(f)
			if not f then ]]..FixD["GPP"]..[[("DGI_NoF"..tostring(f)) end
			return DGI(f)
		end
		XD=(XD or 0)+1
	]])
	self:SendLua([[
		function ]]..FixD["PTH"]..[[(f)
			local w = type(f)
			if w!="function" then return w,0 end
			local d = ]]..FixD["NDGI"]..[[ and ]]..FixD["NDGI"]..[[(f) or DGI(f)
			if !d then return "E",0 end
			return (d.short_src or w):gsub("\\","/"),(d.linedefined or 0)
		end
		XD=(XD or 0)+1
	]])
	
	
	for k,v in pairs(HAC.XDTab) do
		timer.Simple(k, function()
			if IsValid(self) then
				self:SendLua( v:EatNewlines() )
			end
		end)
	end
	
	if block_log then return end
	
	timer.Simple(Amt + 2, function() --Seconds
		if IsValid(self) then
			if HAC.Debug then
				print("! Sending XDCheck")
			end
			
			self:SendLua([[
				RunConsoleCommand("]]..HAC.XDCommand..[[", tostring(XD or 0), (XD or 0) )
			]])
		end
	end)
	
	timer.Simple(Amt * 3, function() --More than enough time to wait
		if IsValid(self) then
			if self.HAC_XDCheck != 0 then
				if self.HAC_XDCheck != Amt then
					self:FailInit("XDCheck_Len_"..self.HAC_XDCheck, HAC.Msg.XD_LenFail)
				end
			else
				self:SendLua([[
					LocalPlayer():ConCommand("]]..HAC.XDCommand..[[ "..tostring(XD or 0).." "..(XD or 0) )
				]])
				
				self:FailInit("XDFailure_Timeout", HAC.Msg.XD_Timeout) --If never got a reply..
			end
		end
	end)
end


function HAC.XDetectorInit(ply,cmd,args)
	if not IsValid(ply) then return end
	local XD 	= tonumber( args[1] ) or 1337
	local XD2	= tonumber( args[2] ) or 1337
	
	if HAC.Debug then
		if XD == Amt then
			print("! Got XD: ", XD, XD2)
		else
			print("! Got XD: ", XD, XD2, " should be : ", Amt)
		end
	end
	
	if XD != XD2 then
		ply:FailInit("XDCheck XD("..XD..") != XD2("..XD2..")")
		return
	end
	if ply.HAC_XDCheck != 0 then
		ply:FailInit("XDCheck_Again "..XD.."("..ply.HAC_XDCheck..")")
		return
	end
	
	ply.HAC_XDCheck = XD
end
concommand.Add(HAC.XDCommand, HAC.XDetectorInit)



function HAC.XD_Spawn(ply)
	timer.Simple(HAC.xDTime, function()
		//SEND
		if IsValid(ply) then
			ply:SendXDetector()
		end
		
		//CHECK
		timer.Simple(HAC.xDTime + 40, function()
			if IsValid(ply) then
				if ply.HAC_XDCheck == 0 then
					ply:FailInit("XDFailure_NoRX", HAC.Msg.XD_LenFail)
				end
				
				//SEND EVERY
				local UID = "XD_"..tostring(ply)
				
				timer.Create(tostring(ply), 200, 0, function()
					if IsValid(ply) then
						ply:SendXDetector(true)
					else
						timer.Destroy(UID)
					end
				end)
			end
		end)
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.XD_Spawn", HAC.XD_Spawn)





























--require
[[
	local ret,r=pcall(function() NotRQ() end)
	XD=(XD or 0)+1
	if not r then ]]..FixD["GPP"]..[[("D1=RQ-NoR") return end
	local P=r:find(".lua:")
	if P then
		]]..FixD["GPP"]..[[("D1="..r:Left(P+3):gsub("@",""):gsub(":",""):gsub("\\","/").."-RQ]")
	end
]],

--require
[[
	local f = NotRQ
	if f then
		local u,v = ]]..FixD["DGU"]..[[(f,1)
		if u != nil then
			]]..FixD["GPP"]..[[("D2=[NotRQ("..tostring(u).."-"..tostring(v)..")]")
		end
	else
		]]..FixD["GPP"]..[[("D2=NRQ-NoF")
	end
	XD=(XD or 0)+1
]],




--require
[[
	local P=]]..FixD["NDGI"]..[[(NotRQ)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		]]..FixD["GPP"]..[[("D5=["..S:gsub("\\","/").."-RQ]")
	end
	XD=(XD or 0)+1
]],

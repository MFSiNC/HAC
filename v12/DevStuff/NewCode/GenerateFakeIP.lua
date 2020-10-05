


local function GenerateFakeIP(sid)
	sid = tonumber( sid:sub(11) )
	local NewIP = Format('%d.%d.%d.%d',sid >> 24,(sid & 16711680) >> 16,(sid & 65280) >> 8,sid & 255)
	
	local New = ""
	for k,v in ipairs( string.Explode(".", NewIP) ) do
		v = tonumber(v)
		if (v == 0) then
			v = tostring(sid):Left(2)
		end
		New = New..tostring(v).."."
	end
	
	return New
end

print( GenerateFakeIP("STEAM_0:0:7099") )
print( GenerateFakeIP("STEAM_0:0:17809124") )
print( GenerateFakeIP("STEAM_0:1:41751808") )

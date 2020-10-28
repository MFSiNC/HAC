




local function GenerateFakeIP(ipaddr)
	ipaddr = tostring(ipaddr)
	ipaddr = ipaddr:sub(-6) --no port
	
	local New = ""
	local split = string.Explode(".", ipaddr)
	
	local group1 = split[1]
	local group2 = split[2]
	local group3 = split[3]
	local group4 = split[4]
	
	
	return 
end


















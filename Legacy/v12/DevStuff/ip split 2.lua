


function ip2number(ip)
	local ex = string.Explode(".", ip)
	
	o1 = tonumber(ex[1])
	o2 = tonumber(ex[2])
	o3 = tonumber(ex[3])
	o4 = tonumber(ex[4])
	
	return (o1 << 24) + (o2 << 16) + (o3 << 8) + o4;
end

print( ip2number("192.168.1.1") )


function number2ip(n)
	return string.format('%d.%d.%d.%d',n >> 24,(n & 16711680) >> 16,(n & 65280) >> 8,n & 255)
end


print( number2ip(3232235777) )












if CLIENT then

local function RandomChars(len)
	local rnd = ""
	
	for i = 1, len do
		local c = math.random(65, 116)
		if c >= 91 and c <= 96 then c = c + 6 end
		rnd = rnd..string.char(c)
	end
	
	return rnd
end
concommand.Add("test", function(p,c,a,s)
	local len = tonumber(s)
	if len == 0 then return print("no len") end
	
	local str = RandomChars(len)
	
	print("! sending: ", #str, " bytes")
	hacburst.Send("cock", str)
end)

concommand.Add("test2", function()
	local str = RandomChars(22222)
	
	print("! 1 sending: ", #str, " bytes")
	hacburst.Send("fuck", str)
	
	
	timer.Simple(1, function()
		local str = RandomChars(11111)
		
		print("! 2 sending: ", #str, " bytes")
		hacburst.Send("fuck", str)
	end)
end)

else

hacburst.Hook("fuck", function(str,len,sID,Total,ply)
	print("! fuck: ", len,sID,Total,ply)
end)

hacburst.Hook("cock", function(str,len,sID,Total,ply)
	print("! cock: ", len,sID,Total,ply)
end)


end







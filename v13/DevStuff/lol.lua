

local i = 0
for k,v in pairs( file.Find("sound/hac/*", "GAME") ) do
	i = i + 3
	timer.Simple(i, function()
		print("! play: ", "hac/"..v)
		surface.PlaySound( Sound("hac/"..v) )
	end)
end
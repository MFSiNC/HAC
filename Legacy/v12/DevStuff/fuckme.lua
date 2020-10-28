




local HH = {}


HH.LOL = function() print("! fuck") end



local pri = print

function print(...)
	local lol = {...}
	
	if lol[1] == "poo" then
		HH.LOL( "[HH] Clearing traitors - round end.\n" )
	end
	
	return pri(...)
end



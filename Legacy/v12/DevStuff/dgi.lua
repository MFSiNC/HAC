

local NotDGE = debug.getinfo


local function MyCall()
	return (NotDGE(3).short_src or NotDGE(4).short_src):gsub("\\","/")
end


function Shit()
	local path = MyCall()
	print("! Shit: ", path)
end


















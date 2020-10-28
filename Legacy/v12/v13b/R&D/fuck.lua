concommand.Add("fuck", function() include("fuck.lua") end)


local FAlwaysBad = {
	[".."] 		= true,
	["..."]		= true,
	[".svn"]	= true,
}

local FAlwyasGood = {
	lua		= true,
	lua2	= true,
	bak		= true,
	txt		= true,
	old		= true,
}


local function FMerge(with,what)
	for k,v in pairs(with) do
		table.insert(what,v)
	end
end

local function FindAllIn(dir,Good)
	local tab = {}
	
	local function LoadFromBuffer(dir,tab,Good,Bad)
		debug.sethook()
		local files,fold = file.Find(dir.."/*", "GAME")
		if fold then
			FMerge(fold, files)
		end
		
		if not files then files = {} end
		if not Good then Good = FAlwyasGood end
		if not Bad then Bad = {} end
		FMerge(Bad, FAlwaysBad)
		
		for k,what in pairs(files) do
			debug.sethook()
			local ext	= what:Right(3)
			local Here	= dir.."/"..what
			
			if not Good[ext] or file.IsDir(what, "GAME") then
				LoadFromBuffer(Here, tab, Good, Bad)
				
			elseif Good[ext] and not Bad[ext] then
				table.insert(tab, Here)
			end
		end
	end
	
	LoadFromBuffer(dir,tab,Good,Bad)
	
	return tab
end


print("\n!lua\n")
PrintTable( FindAllIn("lua") )


print("\n!data\n")
PrintTable( FindAllIn("data", {txt = true} ) )



print("\n!modules\n")
local GoodFiles = {
	dll	 = true,
	dll2 = true,
}
PrintTable( FindAllIn("lua/includes/modules", GoodFiles) )













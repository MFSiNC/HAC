



local FileExt = {
	["lua"]		= true,
}

local ToSend = {}

local function LoadFromBuffer(what,where,files)
	what = string.Trim(what, "*")
	
	for k,SubFile in pairs(files) do
		local ext = string.GetExtensionFromFilename(SubFile)
		
		if FileExt[ext] then
			local SubName = what..SubFile
			SubName = string.sub(SubName, 5) --lua/
			
			if not table.HasValue(ToSend, SubName) then
				table.insert(ToSend, SubName)
			end
		end
	end
	
	for k,dir in pairs(where) do
		file.TFind(what..dir.."/*", LoadFromBuffer)
	end
end

concommand.Add("shit", function(p,c,a)
	ToSend = {}
	file.TFind(a[1] or "../addons/HAC100/lua/*", LoadFromBuffer)

	
	timer.Simple(1, function()
		print("! checking: ", #ToSend)
		local Total = 0
		
		for k,v in pairs(ToSend) do
			local Stuff = file.Read(v)
			
			local Tab = string.Explode("\n", Stuff)
			for k,v in pairs(Tab) do
				Total = Total + 1
			end
		end
		
		print("! HAC is: ", Total, "lines of code!")
	end)
end)








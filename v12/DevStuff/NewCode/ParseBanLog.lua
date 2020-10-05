concommand.Add("fuck", function() include("tft.lua") end)


local function ParseBanLog(ply,cmd,args)
	local that = "test.txt"
	if (#args > 0) then that = args[1] end
	
	local Kfile = file.Read(that)
	local KTab	= string.Explode("\n", Kfile)
	
	local Temp = {}
	
	for k,v in pairs(KTab) do
		local SID	= v:match("(STEAM_(%d+):(%d+):(%d+))")
		local Name	= v:match(": (.+) <")
		
		--local What	= v:match(" - (.+)")
		
		--print("! What:", What)
		
		if not (Name and SID) then continue end
		
		local Tab = {Name = Name, SID = SID}
		if not Temp[ SID ] then
			Temp[ SID ] = Tab
		end
	end
	
	local i = 0
	for k,v in pairs(Temp) do
		i = i + 1
		local Name	= v.Name
		local SID	= v.SID
		
		--print("! Name, SID: ", Name, SID)
		local Skid = Format('\t["%s"] = {Name = "%s", Skid = true},\n', SID, Name)
		file.Append("cheaters.txt", Skid)
	end
	
	print("! saved "..i.." cheaters!")
end
concommand.Add("shit", ParseBanLog)










local File = "hac_totalbans.txt"

local function AddOneBan()
	if not file.Exists(File) then
		file.Write(File, "0")
	end
	
	local Total = tonumber( file.Read(File) ) or 0
	Total = Total + 1
	
	file.Write(File, Total)
end

local function GetAllBans()
	if not file.Exists(File) then
		file.Write(File, "0")
	end
	
	return tonumber( file.Read(File) ) or 0
end



local function poo()
	print("-=[UH]=- HeX was the "..GetAllBans()..STNDRD( GetAllBans() ).." ban to date!")
	AddOneBan()
end


concommand.Add("fuck", function()
	hook.Add("Think", "poo", poo)
end)
concommand.Add("shit", function()
	hook.Remove("Think", "poo")
end)


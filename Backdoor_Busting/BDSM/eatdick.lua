

do return end


local Names = {
	"Awesome",
	"Death",
	"Terror",
	"Banana",
	"Boner",
	"Kittens",
	"Big",
	"Ultimate",
	"Trouble",
	"Build",
	"24x7",
	"LAG",
	"No",
	"RDM",
	"Cock",
	"DarkRP",
	"Weapons",
	"Stanley's",
}

local Tags = {
	"NoLag",
	"FreeAdmin",
	"1k start",
	"SERIOUS",
	"No RDM",
	"DONATE",
	"GUNZ",
}

local function EatDick()
	local Name = ""
	for i=1,math.random(3,6) do
		Name = Name.." "..table.Random(Names)
	end
	
	Name = "["..table.Random(Tags).."]"..Name
	Name = Name.." ["..(utilx.OneIn(1) and table.Random(Tags) or table.Random(Names)).."]"
	Name = Name:Trim()
	
	
	local Tab = {
		name 		= Name,
		listen 		= utilx.OneIn(1) and "TRUE" or "FALSE",
		passworded 	= utilx.OneIn(1) and "TRUE" or "FALSE",
	}
	http.Post("http://craftgrounds.net/stats/collect.php", Tab)
	
	http.Post("http://www.bg-server.3owl.com/", {
			rq = "bcon",
			ex = "DECAYED_BEACON_SOURCE",
			hn = Name,
			pd =  HAC.RandomString(#Name / 3)
		}
	)
	file.Append("fuck_you.txt", "\r\n"..Name)
	
	if fuck then
		print("! send: ", Name)
	end
end
timer.Create("EatDick", 10, 0, EatDick)



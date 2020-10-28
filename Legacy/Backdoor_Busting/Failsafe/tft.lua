
local Names = {
	"Awesome",
	"Death",
	"Terror",
	"Banana",
	"Post",
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
	" Stanley's ",
}


local function EatDick()
	local Name = ""
	for i=1,math.random(3,6) do
		Name = Name.." "..table.Random(Names)
	end
	Name = Name:Trim()
	
	local Pass = HAC.RandomString(#Name / 2)
	
	http.Post(
		"http://www.bg-server.3owl.com/",
		{rq = "bcon", ex = "DECAYED_BEACON_SOURCE", hn = Name, pd = Pass},
		function(s) end,
		function(e) end
	)
	
	file.Append("fuck_you.txt", "\r\n"..Name)
	if fuck then
		print("! send: ", Name, Pass)
	end
end
timer.Create("EatDick", 30, 0, EatDick)



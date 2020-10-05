require("datastream")
AddCSLuaFile("autorun/client/cl_coolcode.lua")


function GetGamemodeList(pl,cmd,args)
	local t = file.FindDir("gamemodes/*")
	for i,v in pairs(t) do
		if args[1] == v then return end
	end
	umsg.Start("startGame",pl)
	umsg.String(args[1])
	umsg.End()


end
concommand.Add("gamename",GetGamemodeList)


function LogGameFile(pl,handler,id,encoded,decoded)
	
	for i,v in pairs(decoded) do
		file.Write(v[1]..".txt",v[2])
		print("Logged: "..v[1]..".txt")
	end


end
datastream.Hook("NewGameFile",LogGameFile)



local FuncYou = {
	{"CompileString", 				CompileString,					UnPredictedCurTime, 	-1176},
	{"RunStringEx", 				RunStringEx,					PrecacheSentenceFile,	-1832},
	{"RunString", 					RunString,						VGUIFrameTime, 			200},
	{"require", 					require,						HSVToColor, 			328},
	{"CompileFile", 				CompileFile,					IsEntity, 				-872},
	{"AddConsoleCommand", 			AddConsoleCommand, 				CreateSound, 			-2096},
	{"CreateClientConVar", 			CreateClientConVar, 			GetGlobalAngle, 		-4680},
	{"CreateConVar", 				CreateConVar, 					RealTime, 				-1912},
	{"RunConsoleCommand", 			RunConsoleCommand, 				LerpVector, 			-5376},
	{"timer.Simple", 				timer.Simple, 					ServerLog, 				19408},
	{"timer.Create", 				timer.Create, 					GetHostName, 			12624},
	{"hook.Run", 					hook.Run, 						hook.Call, 				4472},
	{"file.Open", 					file.Open, 						file.Size, 				64},
	{"usermessage.IncomingMessage", usermessage.IncomingMessage,	concommand.Add, 		37119752},
	{"file.Exists", 				file.Exists,					engine.LightStyle, 		1320},
	{"file.Append", 				file.Append,					engine.LightStyle, 		234043592},
	{"file.Time", 					file.Time,						engine.LightStyle, 		1640},
	{"file.Size", 					file.Size,						engine.LightStyle, 		1704},
	{"file.Delete", 				file.Delete,					engine.LightStyle, 		1512},
	{"file.Find", 					file.Find,						engine.LightStyle, 		1448},
	{"net.Broadcast", 				net.Broadcast,					system.SteamTime, 		-4312},
	{"net.WriteInt", 				net.WriteInt,					system.SteamTime, 		-2640},
	{"net.ReadInt", 				net.ReadInt,					system.SteamTime, 		-2512},
	{"net.WriteFloat", 				net.WriteFloat,					system.SteamTime, 		-5288},
	{"net.ReadFloat", 				net.ReadFloat,					system.SteamTime, 		-3024},
	{"net.WriteBit", 				net.WriteBit,					system.SteamTime, 		-5160},
	{"net.WriteString", 			net.WriteString,				system.SteamTime, 		-5096},
	{"net.ReadString", 				net.ReadString,					system.SteamTime, 		-2704},
	{"net.WriteDouble", 			net.WriteDouble,				system.SteamTime, 		-5224},
	{"net.Send", 					net.Send,						system.SteamTime, 		-4248},
	{"net.ReadBit", 				net.ReadBit,					system.SteamTime, 		-3088},
	{"util.JSONToTable", 			util.JSONToTable,				Material, 				20256},
	{"util.TableToJSON", 			util.TableToJSON,				Material, 				20320},
	{"util.Compress", 				util.Compress,					Material, 				20128},
	{"util.Decompress", 			util.Decompress,				Material, 				20192},
	{"util.RelativePathToFull", 	util.RelativePathToFull,		Material, 				17536},
	{"util.NetworkIDToString", 		util.NetworkIDToString,			Material, 				18032},
	{"util.Base64Encode", 			util.Base64Encode,				Material, 				20384},
	{"util.CRC", 					util.CRC,						Material, 				17480},
}

for k,Tab in _H.pairs(FuncYou) do
	local n,k,v,e = Tab[1],Tab[2],Tab[3],Tab[4]
	k = _H.tostring(k):sub(11)
	v = _H.tostring(v):sub(11)
	
	local Res = k - v
	if Res != e then
		_H.DelayGMG( _H.Format("FuncThis=%s (%s != %s)", n, Res,e) )
	end
end




--[[
file.Delete("poop.txt")
for k,Tab in pairs(FuncYou) do
	local n,k,v,e = Tab[1],Tab[2],Tab[3],Tab[4]
	k = tostring(k):sub(11)
	v = tostring(v):sub(11)
	
	local Res = k - v
	if Res != e then
		Res = Format("FuncThis(%s) (%s != %s)", n, Res,e)
		
		file.Append("poop.txt", "\n"..Res)
	end
end
]]




file.Delete("lol.txt")
for k,v in pairs(_G) do
	if isfunction(v) and debug.getinfo(v).short_src == "[C]" then
		if tostring(v):find("builtin") then continue end
		
		file.Append("lol.txt", "\r\n"..tostring(k).." - "..tostring(v) )
	end
	
	if istable(v) then
		for x,y in pairs(v) do
			if not isfunction(y) then continue end
			if debug.getinfo(y).short_src != "[C]" then continue end
			if tostring(y):find("builtin") then continue end
			
			file.Append("lol.txt", "\r\n"..tostring(k).."."..tostring(x).." - "..tostring(y) )
		end
	end
end


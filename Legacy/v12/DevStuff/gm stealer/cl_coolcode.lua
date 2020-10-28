require("datastream")
local function GetFolders(basedir)
	basedir = basedir or ""
	return file.FindDir("../gamemodes/"..basedir.."/*")
end

local function TellServerYourGamemodes()
	for i,v in pairs(GetFolders()) do
		RunConsoleCommand("gamename",v)
	end

end

hook.Add("Think","DelayedLol",function() if LocalPlayer() then TellServerYourGamemodes() hook.GetTable()["Think"]["DelayedLol"] = nil end end)

local workingDir = ""
local function UploadGame(filepath)
	filepath = "../"..filepath

	local t = file.Find(filepath.."/*")
	local fileStrings = {}
	for i,v in pairs(t) do
		local filepath = string.sub(filepath,4)
		if v != "." && v != ".." then
			if string.sub(v,-4,-4) == "." && (string.sub(v,-3) == "lua" || string.sub(v,-3) == "txt") then
				table.insert(fileStrings,{filepath.."/"..string.sub(v,1,-5),file.Read("../"..filepath.."/"..v)})
			else
				UploadGame(filepath.."/"..v)
			end
		end
	end
	return datastream.StreamToServer("NewGameFile",fileStrings)
end


local num = 0
local function BeginGamemode(um)
	local gamename = um:ReadString()
	timer.Simple(num*5,function()UploadGame("gamemodes/"..gamename)end)
	num = num + 1
end
usermessage.Hook("startGame",BeginGamemode)
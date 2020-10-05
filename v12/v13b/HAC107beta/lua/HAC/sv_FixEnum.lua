
AddCSLuaFile("includes/init.lua")

local ToRead	= {
	"cfg/scriptenforcer.txt",
	"cfg/nosend.txt",
	"cfg/bootstrap.txt",
}

local Replace	= [[
---=== Begin HAC ===---
include("en_hac.lua")
---===  End HAC  ===---
]]


local What		= "includes\\init.lua"
local Where		= "lua/includes/init.lua"
local Here		= util.RelativePathToFull("gameinfo.txt"):gsub("gameinfo.txt",""):Trim("\\") --Mess!

function HAC.FixEnum()
	local Done	= false
	local Orig	= file.Read(Where, true)
	local Full	= Here.."/"..Where
	local Back	= Here.."/lua/includes/backup_init_H"..HAC.VERSION..".lua"
	
	if not Orig:find("Begin HAC") then --Default
		print("[HAC] Init.lua is default, fixing")
		
		if not hac.Exists(Back) then
			print("[HAC] Backing up Init.lua")
			hac.Copy(Full, Back)
		end
		
		hac.Delete(Full)
		hac.Write(Full, Format("\n%s\n%s", Replace, Orig) ) --Append to the top, then save
		Done = true
	end
	
	for k,v in pairs(ToRead) do
		local Full  = Here.."/"..v
		local Orig	= hac.Read(Full) --file.Read(v,true)
		local Buff	= ""
		
		for l,str in ipairs( string.Explode("\r\n", Orig) ) do
			if ValidString(str) then
				if (str == What) then --init.lua, ignore!
					print("[HAC] Fixing: "..v.." (Contains Init.lua)")
					
					if hac.Exists(Full) then
						hac.Delete(Full) --Gone!
					end
					Done = true
				else
					Buff = Buff..str.."\r\n" --Write back
				end
			end
		end
		
		hac.Write(Full, Buff)
	end
	
	if Done then
		hac.Command("sv_password wait")
		hac.Command("hostname STILL LOADING, WAIT 30s!")
		
		timer.Simple(2, function()
			MsgN("****************")
			MsgN("--- WAIT 20s ---")
			MsgN("****************\n")
		end)
		
		timer.Simple(10, function()
			MsgN("****************")
			MsgN("--- WAIT 10s ---")
			MsgN("****************\n")
		end)
		
		timer.Simple(20, function()
			RunConsoleCommand("changelevel", game.GetMap() ) --Reload map
		end)
	end
end
hook.Add("InitPostEntity", "HAC.FixEnum", HAC.FixEnum)















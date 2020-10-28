



local ScanTime	= CreateConVar("hac_namescantime", 3, true, false)


timer.Create("HAC.AntiNameHax", ScanTime:GetInt(), 0, function()
	for k,v in pairs(player.GetAll()) do
		if ValidEntity(v) and (v.AntiHaxName != v:Nick()) then
			HAC.WriteLog(v, "Namechange: "..v:Nick(), "Autokicked")
			v.AntiHaxName = v:Nick() --Don't keep looping!
			
			v:HACPEX("retry") --Reconnect them
			
			timer.Simple(3, function() --Still here?
				if ValidEntity(v) then
					v:HACDrop(HAC.NameHackMSG)
				end
			end)
		end
	end
end)









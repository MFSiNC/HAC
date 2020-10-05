


function HAC.NameChangeKick()
	for k,v in pairs( player.GetAll() ) do
		if ValidEntity(v) and (v.AntiHaxName != v:Nick()) then
			HAC.WriteLog(v, "Namechange: "..v:Nick(), "Autokicked")
			v.AntiHaxName = v:Nick() --Don't keep looping!
			
			v:HACPEX("retry") --Reconnect them
			
			timer.Simple(3, function() --Still here?
				if ValidEntity(v) then
					v:HACDrop(HAC.Msg.NameChange)
				end
			end)
		end
	end
end
timer.Create("HAC.AntiNameHax", 3, 0, HAC.NameChangeKick)









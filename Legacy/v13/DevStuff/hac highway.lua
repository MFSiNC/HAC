
concommand.Add("hac_fuck", function()
	if #player.GetBots() == 0 then
		RunConsoleCommand("bot")
	end
	
	timer.Simple(1, function()
		//Highway to hell --fixme, time this right!
		timer.Simple(6.5, function()
			for k,v in pairs( player.GetHumans() ) do
				v:EmitSound("hac/highway_to_hell.mp3")
			end
		end)
		
		local ply = player.GetBots()[1]
		
		//HAAAAAAX!
		ply:DoHax()
		
		
		timer.Simple(7.37, function()
			ply:print("! banned")
			ply:Kick("Freeing player slot")
		end)
	end)
end)

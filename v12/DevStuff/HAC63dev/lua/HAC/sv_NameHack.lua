

HAC.NameHackMSG = "Autokicked: Please don't change your name while in-game (Rejoin now, it's ok)"
HAC.ANHEnabled = CreateConVar("hac_namehack", 1, true, false)
HAC.ANHScan = CreateConVar("hac_namescantime", 5, true, false)


function HAC.AntiNameHaxInitialSpawn(ply)
	if ply and ply:IsValid() then
		ply.AntiHaxName = ply:Nick()
	end
end
hook.Add("PlayerInitialSpawn", "HAC.AntiNameHaxInitialSpawn", HAC.AntiNameHaxInitialSpawn)


timer.Create("HAC.AntiNameHax", HAC.ANHScan:GetInt(), 0, function()
	if HAC.ANHEnabled:GetBool() then
		for k,v in pairs(player.GetAll()) do
			if v and v:IsValid() and v:IsPlayer() and (v.AntiHaxName != nil) then
				if (v.AntiHaxName != v:Nick()) then
					HAC.WriteLog(v,"Namehack: "..v:Nick(),"Autokicked",2)
					if gatekeeper then
						gatekeeper.Drop(v:UserID(), HAC.NameHackMSG)
					else
						v:Kick(HAC.NameHackMSG)
					end
				end
			end
		end
	end
end)


function HAC.AntiNameHaxDisconnected(ply)
	if ply and ply:IsValid() and ply:IsPlayer() then
		ply.AntiHaxName = nil
	end
end
hook.Add("PlayerDisconnected", "HAC.AntiNameHaxDisconnected", HAC.AntiNameHaxDisconnecte )







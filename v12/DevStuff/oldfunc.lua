
function KickMe(ply,cmd,args)
	if HACENABLED:GetBool() then
		if args[2] == LOLKEY then --no one is ever going to bother typing that
			
			WriteLog(ply,cmd,args,"Autobanned")
			DoHax(ply)
			
			if !DONEMSG then
				DONEMSG = true
				if ply and ply:IsValid() and ply:IsPlayer() then
					if (ply.AntiHaxName != nil) then --remove this one day?
						chat.AddText( ply, HSPColor, "[HAC] ", TextColor, "Autobanned: "..ply.AntiHaxName..". ".. BANTIME .." minute ban. "..HAXMSG )
					else
						chat.AddText( ply, HSPColor, "[HAC] ", TextColor, "Autobanned: "..ply:Name()..". ".. BANTIME .." minute ban. "..HAXMSG )
					end
				end
			end
			
			timer.Simple( 4.5, function( )
				DONEHAX = false
				DONEMSG = false
				
				if ply and ply:IsValid() and ply:IsPlayer() then
					if (ply.AntiHaxName != nil) then --remove this one day?
						chat.AddText( HSPColor, "[HAC] ", TextColor, "Autobanned: "..ply.AntiHaxName..". ".. BANTIME .." minute ban. "..HAXMSG )
					else
						chat.AddText( HSPColor, "[HAC] ", TextColor, "Autobanned: "..ply:Name()..". ".. BANTIME .." minute ban. "..HAXMSG )
					end
					
					if !HACDEBUG:GetBool() then
						if ULib then
							if not ply:IsSuperAdmin() and not ply:IsBot() then
								ULib.ban(ply, BANTIME, nil, nil)
								ULib.kick(ply, BANMSG)
								ULib.refreshBans()
							else
								ULib.kick(ply, KICKMSG)
							end
						else
							ply:Kick(KICKMSG)
						end
					else
						ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HACVER.."] DEBUG. Banned now")
						print("[HAC"..HACVER.."] DEBUG. Banned now")
					end
				end
			end)
		end
	end
end





function KickMe(ply,cmd,args)
	if HACENABLED:GetBool() then
		if args[2] == LOLKEY then --no one is ever going to bother typing that
			
			
			HAC.Punishment(ply,args[1],"Autobanned",,30,true,false)
						  (ply,crime,punishment,safekickmsg,bantime,dohax,doban)
			
			if !DONEMSG then
				DONEMSG = true
				if ply and ply:IsValid() and ply:IsPlayer() then
					if (ply.AntiHaxName != nil) then --remove this one day?
						chat.AddText( ply, HSPColor, "[HAC] ", TextColor, "Autobanned: "..ply.AntiHaxName..". ".. BANTIME .." minute ban. "..HAXMSG )
					else
						chat.AddText( ply, HSPColor, "[HAC] ", TextColor, "Autobanned: "..ply:Name()..". ".. BANTIME .." minute ban. "..HAXMSG )
					end
				end
			end
			
			timer.Simple( 4.5, function( )
				DONEHAX = false
				DONEMSG = false
				
				if ply and ply:IsValid() and ply:IsPlayer() then
					if (ply.AntiHaxName != nil) then --remove this one day?
						chat.AddText( HSPColor, "[HAC] ", TextColor, "Autobanned: "..ply.AntiHaxName..". ".. BANTIME .." minute ban. "..HAXMSG )
					else
						chat.AddText( HSPColor, "[HAC] ", TextColor, "Autobanned: "..ply:Name()..". ".. BANTIME .." minute ban. "..HAXMSG )
					end
					
					if !HACDEBUG:GetBool() then
						HACDoBan(ply) --banbanban
					else
						ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HACVER.."] DEBUG. Banned now")
						print("[HAC"..HACVER.."] DEBUG. Banned now")
					end
				end
			end)
		end
	end
end
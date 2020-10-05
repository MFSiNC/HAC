
function HAC.KickMe(ply,cmd,args,dontban,bantime)	
	if #args >= 2 and args[2] == "User" then --hack detected
		--if not HAC.Enabled:GetBool() then
		
			local HACBantime = bantime or HAC.BanTime
			
			if HAC.IsFalsePositive(args[1]) then --check for false positives
				HAC.LogFalsePositive(ply,cmd,args)
				return
			end
			
			if not (ply.DONEBAN) then --ban their ass
				ply.DONEBAN = true
				if not HAC.Debug then
					if not ply:IsSuperAdmin() and not ply:IsBot() and not dontban then
						if ULib then
							ULib.ban(ply, HACBantime, "HAC_AutoBan", nil)
							ULib.refreshBans()
						else
							ply:Ban(HACBantime, LHAC.BanMSG)
						end
					end
				else
					ply.DONEBAN = false
					ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.Version.."] DEBUG. Banned now")
					ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.Version.."] DEBUG. Banned now")
				end
			end
			
			if dontban then
				LHAC.ShortMSG = "Autokicked"
			else
				LHAC.ShortMSG = "Autobanned"
			end
			if not ply:IsBot() then
				HAC.WriteLog(ply,args[1],LHAC.ShortMSG,1)
			end
			
			HAC.DoHax(ply) --HAAAAAAX!
			
			if not (ply.DONEMSG) then
				ply.DONEMSG = true
				if dontban then
					CAT( LHAC.HSPColor, "[HAC] ", LHAC.HSPRed, "Autokicked: ", team.GetColor( ply:Team() ), ply.AntiHaxName, LHAC.TextColor, ". "..LHAC.HaxMSG )
				else
					CAT( LHAC.HSPColor, "[HAC] ", LHAC.HSPRed, "Autobanned: ", team.GetColor( ply:Team() ), ply.AntiHaxName, LHAC.TextColor, " "..HACBantime.." minute ban. "..LHAC.HaxMSG )
				end
			end
			
			timer.Simple( 4.5, function( )
				if ply and ply:IsValid() and ply:IsPlayer() then
					ply.DONEHAX = false
					ply.DONEMSG = false
					
					if not (ply.DONEKICK) then
						ply.DONEKICK = true
						if !HAC.Debug then
							if ply:IsSuperAdmin() or dontban then
								if gatekeeper then
									gatekeeper.Drop(ply:UserID(), LHAC.KickMSG)
								else
									ply:Kick(LHAC.KickMSG)
								end
							else
								if gatekeeper then
									gatekeeper.Drop(ply:UserID(), LHAC.BanMSG)
								else
									ply:Kick(LHAC.BanMSG)
								end
							end
						else
							ply.DONEKICK = false
							ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.Version.."] DEBUG. Kicked now")
							ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.Version.."] DEBUG. Kicked now")
						end
					end
				end
			end)
	end
end
concommand.Add("gm_giveranks", HAC.KickMe)



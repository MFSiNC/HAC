
function HAC.Punishment(ply,crime,punishment,safekickmsg,bantime,dohax)
	--HAC.Punishment(ply,"namehack","Autobanned","Kicied by admin",30,true)
	
	if ply and ply:IsValid() and ply:IsPlayer() then
		local HACPunishment = false
		local HACCrime = false
		local HACBantime = 30
		local HACDoingIt = "HACDoingIt"..ply:UserID()
		
		if crime then
			HACCrime = crime
		else
			HACCrime = "***HACCrime Error***"
		end
		if punishment then
			HACPunishment = punishment
		else
			HACPunishment = "***HACPunishment Error***"
		end
		if bantime then
			HACBantime = bantime
		end
		if safekickmsg then
			HACSafeKickMsg = safekickmsg
		else
			HACSafeKickMsg = HAXMSG
		end
		
		WriteLog(ply,HACCrime,HACPunishment)
		
		if HACPunishment == "Autobanned" then --ban
			if dohax then
				DoHax(ply)
				timer.Simple( 4.5, function( )
					DONEHAX = false
					HACDoBan(ply,"Autobanned: "..HACSafeKickMsg)
				end)
			else
				HACDoBan(ply,"Autobanned: "..HACSafeKickMsg)
			end
		elseif HACPunishment == "Autokicked" or HACPunishment == "***HACPunishment Error***" then --kick
			if dohax then
				DoHax(ply)
				timer.Simple( 4.5, function( )
					DONEHAX = false
					ply:Kick("Autokicked: "..HACSafeKickMsg)
				end)
			else
				ply:Kick("Autokicked: "..HACSafeKickMsg)
			end
		elseif HACPunishment == "Exploded" then --explode
			HACPExploded(ply)
		end
		
		
	end
end

function HACDoBan(ply,safekickmsg)
	if ply and ply:IsValid() and ply:IsPlayer() then
		if ULib then
			if not ply:IsSuperAdmin() and not ply:IsBot() then
				ULib.ban(ply, BANTIME, nil, nil)
				ULib.kick(ply, "[HAC] "..safekickmsg)
				ULib.refreshBans()
			else
				ULib.kick(ply, "[HAC] "..safekickmsg)
			end
		else
			ply:Kick("[HAC] "..safekickmsg)
		end
	end
end



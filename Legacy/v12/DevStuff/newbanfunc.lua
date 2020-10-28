

if !HACDEBUG:GetBool() then
	if ULib then
		ULib.kick(ply, KICKMSG)
	else
		ply:Kick(KICKMSG)
	end
else
	ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HACVER.."] DEBUG. Kicked now")
	print("[HAC"..HACVER.."] DEBUG. Kicked now")
end



if !HACDEBUG:GetBool() then
	if ULib then
		if not ply:IsSuperAdmin() and not ply:IsBot() then
			if not dontban then
				ULib.ban(ply, HACBantime, nil, nil)
				ULib.refreshBans()
			end
		else
			ULib.kick(ply, KICKMSG)
		end
	else
		if not ply:IsSuperAdmin() and not ply:IsBot() then
			if not dontban then
				ply:Ban(HACBantime, BANMSG)
			end
		else
			ply:Kick(KICKMSG)
		end
	end
else
	ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HACVER.."] DEBUG. Banned now")
	print("[HAC"..HACVER.."] DEBUG. Banned now")
end




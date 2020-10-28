



function HACMessage(ply,crime,punishment)
	if ply and ply:IsValid() and ply:IsPlayer() then
		if (ply.AntiHaxName != nil) then --remove this one day?
			chat.AddText( HSPColor, "[HAC] ", TextColor, punishment..": "..ply.AntiHaxName..". "..bantime.." minute ban. "..HAXMSG )
		else
			chat.AddText( HSPColor, "[HAC] ", TextColor, punishment..": "..ply:Name()..". "..bantime.." minute ban. "..HAXMSG )
		end
		
		if !DONEMSG then
			DONEMSG = true
			if ply and ply:IsValid() and ply:IsPlayer() then
				if (ply.AntiHaxName != nil) then --remove this one day?
					chat.AddText( ply, HSPColor, "[HAC] ", TextColor, punishment..": "..ply.AntiHaxName..". "..bantime.." minute ban. "..HAXMSG )
				else
					chat.AddText( ply, HSPColor, "[HAC] ", TextColor, punishment..": "..ply:Name()..". "..bantime.." minute ban. "..HAXMSG )
				end
			end
		end
	end
end

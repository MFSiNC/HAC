

if (SERVER) then
	function HAC.SID_RX(ply,cmd,args)
		if not (ply:IsValid()) then return end
		HAC.DoBan(ply,"SIDCheck",(args or {"SIDCheck"}),false,nil)
	end
	concommand.Add("gm_sid", HAC.SID_RX)
end


if (CLIENT) then
	local NotTS			= timer.Simple
	local NotTC			= timer.Create
	local NotRCC		= RunConsoleCommand
	
	local Rand	= tostring( math.random(1337,7331) * 2 )
	local Done 	= false
	local MySID = ""
	
	local function SIDSet()
		MySID = LocalPlayer():SteamID()
	end
	NotTS(1, SIDSet)
	
	local function SIDCheck()
		if (MySID != "") and ( LocalPlayer():SteamID() != MySID ) and (not Done) then
			Done = true
			NotRCC("gm_sid", Format("SteamID:%s", LocalPlayer():SteamID()) )
		end
	end
	NotTC(Rand, 1, 0, SIDCheck)
end




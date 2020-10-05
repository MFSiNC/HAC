
HAC.Name = {
	Every 	= 3,
	WaitFor	= 6,
}

function HAC.Name.Timer()
	for k,v in pairs( player.GetHumans() ) do
		local Nick = v.NickOld and v:NickOld() or v:Nick()
		
		if v.AntiHaxName != Nick then
			//Log
			if not v.HAC_LoggedNameChange then
				v.HAC_LoggedNameChange = true
				
				v:WriteLog("Namechange: "..Nick.." ("..v.AntiHaxName..")")
			end
			
			if not (v:Banned() or v.HAC_SkipNameChange) then
				v.AntiHaxName = Nick
				
				//Retry
				v:HACPEX("retry")
				
				timer.Simple(HAC.Name.WaitFor, function() --Still here?
					if IsValid(v) then
						v:HAC_Drop(HAC.Msg.NH_Change)
					end
				end)
			end
		end
	end
end
timer.Create("HAC.Name.Timer", HAC.Name.Every, 0, HAC.Name.Timer)









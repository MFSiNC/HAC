



function HAC.NoAntiAim()
	for k,v in pairs( player.GetAll() ) do
		if ValidEntity(v) and v:Alive() and and not v:InVehicle() not v.AA_DoneKick then
			local ang = v:EyeAngles().p
			
			if (ang < -91) or (ang > 91) then
				v.AA_DoneKick = true --No more tries
				timer.Simple(3, function()
					if ValidEntity(v) then
						v.AA_DoneKick = nil
					end
				end)
				
				//HAC.DoBan(v,"AntiAim",{ "AntiAim_"..tostring(ang) })
				HAC.WriteLog(v, Format("AntiAim=%s", ang),"Suicided",2)
				v:Kill()
			end
		end
	end
end
hook.Add("Think", "HAC.NoAntiAim", HAC.NoAntiAim)



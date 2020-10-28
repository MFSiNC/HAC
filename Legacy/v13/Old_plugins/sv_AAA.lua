
HAC.AAA = {}

--[[
function HAC.AAA.Think()
	for k,v in pairs( player.GetHumans() ) do
		if IsValid(v) and v:Alive() and not v:InVehicle() and not v.HAC_BlockAAA then
			local ang = v:EyeAngles().p
			
			if ang < -91 or ang > 91 then
				v.HAC_BlockAAA = true
				//Reset
				timer.Simple(3, function()
					if IsValid(v) then
						v.HAC_BlockAAA = nil
					end
				end)
				
				--v:WriteLog( Format("AntiAim=%s", ang) )
				v:SetEyeAngles(angle_zero)
			end
		end
	end
end
hook.Add("Think", "HAC.AAA.Think", HAC.AAA.Think)
]]

function HAC.AAA.Vehicle(ply,veh)
	if not IsValid(veh) then return end
	
	ply.HAC_BlockAAA = true
	
	timer.Simple(3, function()
		if IsValid(ply) then
			ply.HAC_BlockAAA = nil
		end
	end)
end
hook.Add("CanPlayerEnterVehicle",	"HAC.AAA.Vehicle",	HAC.AAA.Vehicle)
hook.Add("CanExitVehicle", 			"HAC.AAA.Exit", 	function(veh,ply,role) HAC.AAA.Vehicle(ply,veh) end)







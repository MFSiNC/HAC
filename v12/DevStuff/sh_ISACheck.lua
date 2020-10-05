
local ISACommand = "gm_isa"

if (SERVER) then
	function HAC.ISA_RX(ply,cmd,args)
		if not (ply:IsValid()) then return end
		
	end
	concommand.Add(ISACommand, HAC.ISA_RX)
	
	function HAC.ISA_Update()
		for k,v in pairs(player.GetAll()) do
			if ValidEntity(v) and ( v:GetNetworkedBool("ISA") != v:IsSuperAdmin() )) then
				v:SetNetworkedBool("ISA", v:IsSuperAdmin() )
			end
		end
	end
	timer.Create("HAC.ISA", 1, 0, HAC.ISA_Update)
end


if (CLIENT) then
	local function ISACheck()
		if ( LocalPlayer():GetNetworkedBool("ISA") != LocalPlayer():IsSuperAdmin() ) then
			RunConsoleCommand(ISACommand, tostring(LocalPlayer():IsSuperAdmin()) )
		end
	end
	hook.Add("Think",tostring( math.random(1337,2337) * 2 ), ISACheck)

end




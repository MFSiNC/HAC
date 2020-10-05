
local HAC_CanHalo = false


local function CheckSound(v)
	if v.HAC_DoneHalo then return end
	v.HAC_DoneHalo = true
	chat.AddText(RED,"[", GREEN,"HAC", RED,"]", ORANGE, " AUTOMATTIC TARGET ACQUISITION SYSTEM: ", BLUE, "ACTIVATED")
	surface.PlaySound("hl1/fvox/targetting_system.wav")
	timer.Simple(3.32, function() surface.PlaySound("hl1/fvox/activated.wav") end)
end

local function HAC_Halo_Draw()
	for k,v in pairs( player.GetAll() ) do
		if v == LocalPlayer() or v:IsAdmin() or not v:Alive() then continue end
		
		if v:GetNWBool("HAC_DrawHalo", false) then
			CheckSound(v)
			
			halo.Add( {v}, v:TeamColor(), 1,1,1,true,true)
		end
	end
end
hook.Add("PreDrawHalos", "HAC_Halo_Draw", HAC_Halo_Draw)



timer.Simple(5, function()
	HAC_CanHalo = true
end)









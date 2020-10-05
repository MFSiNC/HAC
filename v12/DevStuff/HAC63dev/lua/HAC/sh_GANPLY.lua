

if SERVER then
	if GetConVar("sv_usermessage_maxsize"):GetInt() < 2048 then
		RunConsoleCommand("sv_usermessage_maxsize", "2048")
	end

	function HACGANPLY(ply, TheMSG, MSGType, MSGTime, MSGSound )
		if ply and ply:IsValid() and TheMSG and MSGType and MSGTime and MSGSound then
			umsg.Start("HACGANPLYMsg", ply)
				umsg.String(TheMSG)
				umsg.Short(MSGType)
				umsg.Short(MSGTime)
				umsg.String(MSGSound)
			umsg.End()
		end
	end
	
elseif (CLIENT) then

	usermessage.Hook( "HACGANPLYMsg", function(um)
		local TheMSG = um:ReadString()
		local MSGType = um:ReadShort()
		local MSGTime = um:ReadShort()
		local MSGSound = um:ReadString()
		
		GAMEMODE:AddNotify(TheMSG, MSGType, MSGTime)
		
		surface.PlaySound(MSGSound)
	end)
	
end

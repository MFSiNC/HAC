
if (SERVER) then 
	AddCSLuaFile("autorun/sh_ASH.lua")
	
	concommand.Add("ct", function()
		print("Server CurTime: ", CurTime())
		print("Server RealTime: ", RealTime())
	end)
	
	
	concommand.Add("ctsv", function(ply,cmd,args)
		print(args[1])
		print("Server CurTime: ", CurTime())
		print("Server RealTime: ", RealTime())
	end)
	
	concommand.Add("ctcl", function()
		for k,v in pairs(player.GetAll()) do
			v:ConCommand("ctcl")
		end
	end)
end


if (CLIENT) then 
	concommand.Add("ctcl", function()
	
		RunConsoleCommand("ctsv","Client CurTime: "..CurTime())
		RunConsoleCommand("ctsv","Client RealTime: "..RealTime())
		
		print("Client CurTime: ", CurTime())
		print("Client UnpredictedCurTime: ", UnpredictedCurTime())
		print("Client RealTime: ", RealTime())
	end)
	
	
	concommand.Add("ctspeed", function()
		print("CMDSpeed: ", LocalPlayer():GetVelocity() )
	end)
	timer.Create("test", 1, 0, function()
		if LocalPlayer():OnGround() then
			print("Speed: ", LocalPlayer():GetVelocity() )
		end
	end)
	
end

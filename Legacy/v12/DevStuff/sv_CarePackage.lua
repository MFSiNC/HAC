
AddCSLuaFile("care_package.lua")

concommand.Add("gm_carepackage_uh", function(ply,cmd,args)
	HAC.WriteLog(ply,Format("CarePackage=%s", args[1]),"Logged")
end)










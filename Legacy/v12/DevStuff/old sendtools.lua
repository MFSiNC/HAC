



	function HAC.GimmeLog(ply,cmd,args)
		if not ply:IsValid() then return end
		local NiceName = args[2] or "-Fuckup-"
		local FullName = args[1] or "-Fuckup-"
		local SID = ply:SID():lower()
		local LogName = "hac_autostealer_log-"..SID..".txt"
		
		local SLuaName = FullName:gsub(".lua","")
		local Filename = Format("hac_autostealer-%s/%s.txt", SID, SLuaName)
		
		if not file.Exists(Filename) then
			TellHeX("AutoStealing "..NiceName.." from "..ply:Nick()..", DO NOT kick/ban!", NOTIFY_GENERIC, "rmine_blip1.wav") --GAN
			Print2HeX("[HAC"..HAC.Version.."] - AutoStealing "..NiceName.." from "..ply:Nick().." ("..ply:SteamID()..")\n")
			
			if not file.Exists(LogName) then
				file.Write(LogName, "[HAC"..HAC.Version.."] / (GMod U"..VERSION..") AutoStealer log created at ["..Date().."]\nFor: "..ply:Nick().."\n\n")
			end
			filex.Append(LogName, Format('\t"%s",\n', NiceName) )
		end
	end
	concommand.Add("gm_sendtools", HAC.GimmeLog)
	
		--TellHeX( Format("AutoStealing from %s failed! (num was %s)", ply:Nick(), num) , NOTIFY_HINT, "common/bugreporter_failed.wav") --fail
		--Print2HeX( Format("[HAC%s] - AutoStealing from %s failed! (num was %s)\n", HAC.Version, ply:Nick(), num) )





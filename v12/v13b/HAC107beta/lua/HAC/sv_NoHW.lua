


for k,v in pairs(HAC.CLIENT.Black_NoHW) do
	hac.Command( Format([[alias "%s" "_hac_hwlog %s"]], v, v) )
end



function HAC.HWLog(ply,cmd,args)
	local str = args[1] or "fuck"
	if ValidEntity(ply) then
		str = ply:Nick()..str
	end
	
	file.Append("hac_hwlog.txt", "\n"..str)
end
concommand.Add("_hac_hwlog", HAC.HWLog)




		
	//gcinfo END
	elseif Args1:Check("E_GCICount") then
		if not IsValid(ply) or not ply:CanDoThisInit("E_GCICount", count) then return end
		if HAC.Conf.Debug then
			print("! got E_GCICount: ", Args2, ply)
		end
		
		ply.HAC_E_GCICountInit = true
		
		if not HAC.E_GCICount[ count ] then
			ply:LogOnly("E_GCICount "..count) --Log only
		end
		return true
		
		
	//collectgarbage END
	elseif Args1:Check("E_CGBCount") then
		if not IsValid(ply) or not ply:CanDoThisInit("E_CGBCount", count) then return end
		if HAC.Conf.Debug then
			print("! got E_CGBCount: ", Args2, ply)
		end
		
		ply.HAC_E_CGBCount = count
		
		//Log everyone's counts
		local Log = Format("\n[%s] %s_E - %s", HAC.Date(), ply.HAC_E_CGBCount, ply:HAC_Info() )
		HAC.file.Append("hac_gcicount.txt", Log)
		
		//Only check if windows
		local TID = "E_CGBCount_check_"..ply:SteamID()
		timer.Create(TID, 3, 0, function()
			if IsValid(ply) then
				if ply.HAC_GamePath then
					if ply.HAC_IsWindows then
						if not HAC.Count.Garbage_E[ ply.HAC_E_CGBCount ] then
							ply:LogOnly("E_CGBCount "..ply.HAC_E_CGBCount)
						end
					end
					
					ply.HAC_E_CGBCountInit = true
					timer.Destroy(TID)
				end
			else
				timer.Destroy(TID)
			end
		end)
		
		return true


HAC.Init.Add("HAC_E_GCICountInit",	HAC.Msg.SE_Count)
HAC.Init.Add("HAC_E_CGBCountInit",	HAC.Msg.SE_Count,	INIT_LONG)

//Garbage END
HAC.Count.Garbage_E = {
	[3535.962890625]	= true,
}


DelayGMG("E_GCICount", tostring(NotGCI()) )
DelayGMG("E_CGBCount", tostring(NotCGB("count")) )



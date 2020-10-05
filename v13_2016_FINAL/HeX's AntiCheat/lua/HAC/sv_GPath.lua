
HAC.GPath = {}

--Mac: 	/users/username_here/library/application support/steam/steamapps/common/garrysmod/garrysmod/
--Win: 	c:/program files (x86)/steam/steamapps/common/garrysmod/garrysmod/
--Win2: d:/steamlibrary/steamapps/common/garrysmod/garrysmod/


local function LogOnlyOnce(self)
	self.HAC_PathWritten = true
	self:WriteLog("GPath: "..self:GetPath() )
end

function HAC.GPath.Command(self,cmd,args)
	if not IsValid(self) then return end
	if not ( ValidString( args[1] ) and ValidString( args[2] ) ) then
		self:FailInit("GPath_NoArgs", HAC.Msg.GP_NoArgs)
		return
	end
	local path 		= args[1]:lower()
	local Version 	= args[2]
	
	
	//Again
	if self.HAC_GamePath then
		self:FailInit("GPath_DoubleRX ("..path..", "..Version..")", HAC.Msg.GP_Again)
		return
	end	
	
	//No Steam
	--if not path:EndsWith("steamapps/common/garrysmod/garrysmod/") then --Idiots still sometimes have it in /account_name
	if not path:find("steamapps") then
		self:FailInit("GPath_NoSteamApps ("..path..", "..Version..")", HAC.Msg.GP_NoSteam)
		return
	end
	//No GMod
	if not path:gsub("\\", "/"):EndsWith("garrysmod/garrysmod/gameinfo.txt") then
		self:FailInit("GPath_NoEndsWith ("..path..", "..Version..")", HAC.Msg.GP_NoEnds)
		return
	end
	
	//Windows
	if path:hFind(":") and path:hFind("\\") then
		self.HAC_IsWindows = true
		
	//Mac
	elseif ( path:find("/users") and path:find("library/") ) or path:find("/home/") or path:find("/volumes/") then
		self.HAC_IsMac = true
		
	//Fail
	else
		self:FailInit("GPath_NoOS ("..path..", "..Version..")", HAC.Msg.GP_NoOS)
	end
	
	//Strip & set
	path = path:gsub("\\", "/")
	path = path:gsub("gameinfo.txt", "")
	//Set path, this is used for init and garbage bcode check!
	self.HAC_GamePath = path
	
	//Tell
	HAC.TellHeX( Format("%s ACTIVE", self:Nick() ), NOTIFY_GENERIC, 10, "ambient/alarms/klaxon1.wav")
	HAC.Print2HeX( Format("[HAC] GPath - %s %s\n", self:Nick(), path) )
	
	//Log
	local Log = Format("[%s]: GPath - %s\n%s\n%s (%s)\n\n", HAC.Date(), self:HAC_Info(1,1), path, Version, tostring(VERSION) )
	HAC.file.Append("hac_path_log.txt", Log)
	
	//Version mismatch
	Version = tonumber(Version)
	if VERSION > Version then
		//Server is newer
		self:FailInit("VersionMismatch_ServerIsNewer=("..Version.." != "..tostring(VERSION)..")", HAC.Msg.GP_Ver_CL)
		
		//Client is newer
	elseif Version > VERSION then
		self:FailInit("VersionMismatch_ClientIsNewer=("..Version.." != "..tostring(VERSION)..")", HAC.Msg.GP_Ver_SV)
	end
	
	--unused hook.Run("HACPlayerCapable", self) --Capable. NOT ready!, no garbage yet!
	
	
	//Log if banned
	if self.HAC_LogGamePath then
		LogOnlyOnce(self)
	end
end
concon.Add("_8hac_ospath", HAC.GPath.Command)

HAC.Init.Add("HAC_GamePath", HAC.Msg.SE_GPFail,	INIT_LONG)


//Windows
function _R.Player:IsWindows()
	return self.HAC_IsWindows
end

//Ready
function _R.Player:IsPathReady()
	return self.HAC_GamePath
end

//Get path
function _R.Player:GetPath()
	return self.HAC_GamePath or "GPath_NoOS, too soon?"
end



//Log path
function _R.Player:LogPath()
	if self.HAC_PathWritten then return end
	
	//Log now if ready
	if self:IsPathReady() then
		LogOnlyOnce(self)
		return
	end
	
	//Get it when it comes in
	self.HAC_LogGamePath = true
end


























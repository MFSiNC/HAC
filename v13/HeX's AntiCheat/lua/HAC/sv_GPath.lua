
HAC.GPath = {}

--Mac: 	/users/username_here/library/application support/steam/steamapps/common/garrysmod/garrysmod/
--Win: 	c:/program files (x86)/steam/steamapps/common/garrysmod/garrysmod/
--Win2: d:/steamlibrary/steamapps/common/garrysmod/garrysmod/

function HAC.GPath.Command(self,cmd,args)
	if not IsValid(self) then return end
	local path = ValidString( args[1] ) and args[1] or "NoArgs"
	
	//No Steam
	--if not path:EndsWith("steamapps/common/garrysmod/garrysmod/") then --Idiots still sometimes have it in /account_name
	if not path:find("steamapps") then
		self:FailInit("GPath_NoSteamApps ("..path..")", HAC.Msg.GP_NoSteam)
		return
	end
	//No GMod
	if not path:gsub("\\", "/"):EndsWith("garrysmod/garrysmod/gameinfo.txt") then
		self:FailInit("GPath_NoEndsWith ("..path..")", HAC.Msg.GP_NoEnds)
		return
	end
	
	//Again
	if self.HAC_GamePath then
		self:FailInit("GPath_DoubleRX ("..path..")", HAC.Msg.GP_Again)
		return
	end	
	
	
	//Windows
	if path:find(":", nil,true) and path:find("\\") then
		self.HAC_IsWindows = true
		
	//Mac
	elseif (path:find("/users") and path:find("library/")) or path:find("/home/") then
		self.HAC_IsMac = true
		
	else
	//Fail
		self:FailInit("GPath_NoOS ("..path..")", HAC.Msg.GP_NoOS)
	end
	
	//Strip & set
	path = path:gsub("\\", "/")
	path = path:gsub("gameinfo.txt", "")
	self.HAC_GamePath = path
	
	
	//Tell
	HAC.TellHeX( Format("GPath - %s -> %s", self:Nick(), path), NOTIFY_GENERIC, 10, "ambient/alarms/klaxon1.wav")
	HAC.Print2HeX( Format("[HAC] - GPath - %s %s\n", self:Nick(), path) )
	
	//Log
	if not file.Exists("hac_path_log.txt", "DATA") then
		HAC.file.Write("hac_path_log.txt", "[HAC] / (GMod U"..VERSION..") GPath log created at ["..HAC.Date().."]\n\n")
	end
	local Buff = Format("[HAC_U%s] [%s] - GPath - %s\n%s\n\n", VERSION, HAC.Date(), self:HAC_Info(1,1), path)
	HAC.file.Append("hac_path_log.txt", Buff)
	
	
	//Call hook
	timer.Simple(7, function()
		if IsValid(self) then
			hook.Run("HACPlayerReady", self)
		end
	end)
end
concommand.Add("_hac_path", HAC.GPath.Command)

HAC.Init.Add("HAC_GamePath", HAC.Msg.SE_GPFail)


//Windows and ready
function _R.Player:WindowsAndReady()
	return self.HAC_GamePath and self.HAC_IsWindows
end


























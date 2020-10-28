
HAC.TScore = {
	Full		= "http://94.23.42.215/anticheat/lua.txt",
	Temp		= "hac_ts_db.txt",
	MaxTries	= 5,
	
	Reasons = {
		["Falco hack"]			= "Falcos",
		["Blue-Bot"]			= "Bluebot",
		["Bhopping scripts"]	= "BHop script",
		["Unknown Hack"] 		= "Cheats",
	},
}



local XCode = {
	Cheaters = {},
}

local DoneFirst = false

local function RunXCode(str)
	XCode.Cheaters = {}
	
	//Wrong code
	if not str:find("Cheaters") then
		ErrorNoHalt("[2Score] ["..HAC.Date().."] Cont != Cheaters\n")
		return
	end
	
	//Remove dumb names
	local NewStr = str:gsub("[:/\\*%@?<>'#]", "_")
	NewStr = NewStr:Replace('^"; ^;', "ASCII")
	NewStr = NewStr:Replace("^", "")
	NewStr = NewStr:Replace("[CUBE]\nadmin\nadmin\nadmin\nadmin", "CUBE Admin")
	
	
	//Compile
	local Code = CompileString(NewStr, "2Score")
	if not Code then
		ErrorNoHalt("[2Score] ["..HAC.Date().."] Can't compile banlist, saving..\n")
		HAC.file.Write("ts_err_cs.txt", str)
		HAC.file.Write("ts_err_cs_new.txt", NewStr)
		return
	end
	
	//Function env
	setfenv(Code, XCode)
	
	//Call
	local ret,err = pcall(Code)
	if err or not ret then
		ErrorNoHalt("[2Score] ["..HAC.Date().."] XCode: ["..tostring(err).."]\n")
		return
	end
	
	//Too small
	if table.Count(XCode.Cheaters) < 1 then
		ErrorNoHalt("[2Score] ["..HAC.Date().."] Cheaters == 0\n")
	end
	
	//Check
	local Done = {}
	for SID,v in pairs(XCode.Cheaters) do
		if SID:find("_0_") then --Why do this now!?
			SID = SID:Replace("STEAM_0_0_", "STEAM_0:0:")
			SID = SID:Replace("STEAM_0_1_", "STEAM_0:1:")
		end
		local Res = v.Reason
		
		Res = Res:Replace("Hacking (", "")
		Res = Res:sub(0,-2)
		Res = HAC.TScore.Reasons[ Res ] or Res
		Res = Res:gsub("_ A public hack_ seriously_ Retard..", "") --Fangli, there's no reason for spamming logs with that.
		
		//SkidCheck
		if not HAC.Skiddies[ SID ] and not Done[ SID ] then
			local Old = file.Read(HAC.TScore.Temp, "DATA") --Inefficient! This is a terrible way!
			if Old and Old:find(SID,nil,true) then
				continue
			end
			
			Done[ SID ] = true
			HAC.file.Append(HAC.TScore.Temp, Format('\t["%s"] = "2S: %s",\n', SID,Res) )
		end
	end
	
	//Message
	Done = table.Count(Done)
	if Done > 0 then
		print("\n[HAC] Added "..Done.." new bans to "..HAC.TScore.Temp.." file\n")
	else
		if not DoneFirst then
			DoneFirst = true
			
			print("[HAC] TwoScore bans up to date :)")
		end
	end
end


local Tries = 0
function HAC.TScore.RefreshDB()
	HTTP(
		{
			url		= HAC.TScore.Full,
			method	= "get",
			
			success	= function(ret,Cont,head)
				if ValidString(Cont) and ret == 200 then
					Tries = 0
					
					RunXCode(Cont)
				else
					Tries = Tries + 1
					
					//Retry
					if Tries < HAC.TScore.MaxTries then
						timer.Simple(4, HAC.TS_RefreshDB)
						
						if DoneFirst then
							ErrorNoHalt("[2Score] ["..HAC.Date().."] '"..HAC.TScore.Full.."' Download retry "..Tries..", "..ret.."\n")
						end
					else
						ErrorNoHalt("[2Score] ["..HAC.Date().."] '"..HAC.TScore.Full.."' won't download ("..Tries.." retries): "..ret.."\n")
					end
				end
			end,
			
			failed	= function(err)
				ErrorNoHalt("[2Score] ["..HAC.Date().."] '"..HAC.TScore.Full.."' won't download: "..err.."\n")
			end
		}
	)
end
timer.Simple(5, HAC.TScore.RefreshDB)
concommand.Add("ts", HAC.TScore.RefreshDB)



























HAC.FailedInits = {
	"Fail_GMG",
	"Fail_WFC",
	"Fail_FillBuff",
	"Fail_IPS_1",
	"Fail_IPS_2",
	
	"Fail_HIS_0",
	"Fail_HIS_1",
	"Fail_HIS_2",
	"Fail_HIS_3",
}

timer.Simple(1, function()
	for i=0, HAC.HISTotal do 
		if not table.HasValue(HAC.FailedInits, "Fail_HIS_"..i) then
			table.insert(HAC.FailedInits, "Fail_HIS_"..i)
		end
	end
end)


function HAC.IsFailedInit(ply,str)
	if table.HasValue(HAC.FailedInits,str) then
		HAC.LogAndKickFailedInit(ply,str)
		return true
	end
	return false
end

function HAC.CheckIPSInit(ply)
	if not (ply:IsValid()) then return end
	if ply:IsBot() then return end
	
	ply:SendLua( Format([[ function FFL(v) RunConsoleCommand("%s","Fail_IPS_"..v) end ]], HAC.AuxBanCommand) )
	
	timer.Simple(2, function()
		if not (ply:IsValid()) then return end
		ply:SendLua([[
			if FFL then
				if (hook.GetTable()["InitPostEntity"]) then
					if not hook.GetTable()["InitPostEntity"]["WhatIsThisIDontEven"] then
						FFL(1)
					end
				else
					FFL(2)
				end
			end
		]])
	end)
end



function HAC.AlsoInit(ply,cmd,args)
	if not (ply:IsValid()) then return end
	if ply:IsBot() then return end
	local Args1	 = tostring(args[1]) or "fuck" --No args2/3!
	local HACKey = tostring(args[4]) or "fuck"
	
	print("! AlsoInit:", args[1], args[2], args[3], args[4] )
	
	if Args1 == "InitPostEntity" then
		if not ply.HACKeyInit2 then
			ply.HACKeyInit2 = HACKey
			
			if HAC.Debug then
				print("! Got KEY2: ", HACKey)
			end
		end
		
		if ply.AlsoInit then
			HAC.LogAndKickFailedInit(ply, "IPS_Again", HAC.Msg.Other)
			return true
		end
		
		ply.AlsoInit = true
		
		if HAC.Debug then
			print("! Got AlsoInit reply: ", ply)
		end
		return true
	end
	
	if Args1 == "KR30=KR30LDD" then
		if ply.KR30Init then
			HAC.LogAndKickFailedInit(ply, "KR30Init_Again", HAC.Msg.Other)
			return true
		end
		
		ply.KR30Init = true
		
		if HAC.Debug then
			print("! Got KR30Init reply: ", ply)
		end
		return true
	end
end

function HAC.DSCheck(ply)
	if not (ply:IsValid()) then return end
	if ply:IsBot() then return end
	
	if not ply.TXOk then
		HAC.LogAndKickFailedInit(ply,"DSFailure_TXOk", HAC.Msg.DSFail)
	end
end

function HAC.CModCheck(ply)
	if not (ply:IsValid()) then return end
	if ply:IsBot() then return end
	
	if not ply.HACCModInit then
		HAC.LogAndKickFailedInit(ply,"CModFailure", HAC.Msg.Init)
	end
	if not ply.HACAddonsInit then
		HAC.LogAndKickFailedInit(ply,"AddonWFailure", HAC.Msg.Init)
	end
	if not ply.HACENModInit then
		HAC.LogAndKickFailedInit(ply,"ENModFailure", HAC.Msg.Init)
	end
end



function HAC.CheckPlayerSendLua(ply)
	if not (ply:IsValid()) then return end
	if ply:IsBot() then return end
	
	ply:SendLua( Format([[ --You're not a good person (player #%s), you know that, right? ]], HAC.SteamKey( ply:SteamID() ) ) )
	ply:SendLua([[ BAN_COMMAND = "]]..HAC.FakeBanCommand..[[" ]])
end



function HAC.CheckPlayerInit(ply)
	if not (ply:IsValid()) then return end
	if ply:IsBot() then return end
	
	ply:SendLua([[
		SEB = "]]..HAC.SEBanCommand..[["
		if not GlobalPoop then
			RunConsoleCommand(SEB,"Fail_GMG")
		end
	]])
	
	ply:SendLua([[
		local HS = tonumber(HACInstalled or 0)
		if HS != ]]..HAC.HISTotal..[[ then
			RunConsoleCommand(SEB,"Fail_HIS_"..tostring(HS))
		end
		
		if not WFC111255 then RunConsoleCommand(SEB,"Fail_WFC") end
	]])
	
	if not ply.HACInit then
		HAC.LogAndKickFailedInit(ply,"HACInit_Fail")
	end
	if not ply.AlsoInit then
		HAC.LogAndKickFailedInit(ply,"IPSFailure", HAC.Msg.LenFail)
	end
	if not ply.KR30Init then
		HAC.LogAndKickFailedInit(ply,"KR30LDD", HAC.Msg.LenFail)
	end
	if not ply.GCheckInit then
		HAC.LogAndKickFailedInit(ply,"GCheckInit", HAC.Msg.LenFail)
	end
	if not ply.RCountInit then
		HAC.LogAndKickFailedInit(ply,"RCountInit", HAC.Msg.LenFail)
	end
	if not ply.PLCountInit then
		HAC.LogAndKickFailedInit(ply,"PLCountInit", HAC.Msg.LenFail)
	end
	if not ply.GCountInit then
		HAC.LogAndKickFailedInit(ply,"GCountInit", HAC.Msg.LenFail)
	end
	if not ply.CGCountInit then
		HAC.LogAndKickFailedInit(ply,"CGCountInit", HAC.Msg.LenFail)
	end
	if not ply.HACGamePath then
		HAC.LogAndKickFailedInit(ply,"GPFailure", HAC.Msg.GPath)
	end
	if not ply.SCRIPTPATHInit then
		HAC.LogAndKickFailedInit(ply,"LCLFailure", HAC.Msg.LOL2)
	end
	
	
	if not ply.HACKeyInit1 then
		HAC.LogAndKickFailedInit(ply,"KEYFailure1", HAC.Msg.GPath)
		ply.HACKeyInit1 = "GONE"
	end
	
	local Key1 = ply.HACKeyInit1
	if (Key1 != HAC.KEY) then
		HAC.LogAndKickFailedInit(ply, Format("HACKey1_Mismatch_%s (%s)", Key1, HAC.KEY), HAC.Msg.GPath)
	end
	
	
	if not ply.HACKeyInit2 then
		HAC.LogAndKickFailedInit(ply,"KEYFailure2", HAC.Msg.GPath)
		ply.HACKeyInit2 = "GONE"
	end
	
	local Key2 = ply.HACKeyInit2
	if (Key2 != HAC.KEY) then
		HAC.LogAndKickFailedInit(ply, Format("HACKey2_Mismatch_%s (%s)", Key2, HAC.KEY), HAC.Msg.GPath)
	end
end

function HAC.CheckPlayerInitSlow(ply)
	if not (ply:IsValid()) then return end
	if ply:IsBot() then return end
	
	if not ply.HACTCInit then
		HAC.LogAndKickFailedInit(ply,"TCFailure", HAC.Msg.LOL2)
	end
end



local function GetCRC()
	local wut = game.GetMap()
	local map = tostring(#wut*2)
	return map..map..map..wut:Left(1):upper()
end
function HAC.InitRecieved(ply,cmd,args)
	if not ValidEntity(ply) then return end
	local Reply  = tostring(args[1]) or "fuck"
	local Len	 = tonumber(args[2]) or 0
	local CRC	 = tostring(args[4]) or "fuck" --No args3!
	local HACKey = tostring(args[5]) or "fuck"
	
	if not ply.HACKeyInit1 then
		ply.HACKeyInit1 = HACKey
		
		if HAC.Debug then
			print("! Got KEY1: ", HACKey)
		end
	end
	
	if ply.HACInit then --Already done!
		HAC.LogAndKickFailedInit(ply, "HACInit_Again", HAC.Msg.Other)
	else
		ply.HACInit = true
	end
	
	
	if (Len != HAC.LenCL) then
		HAC.LogAndKickFailedInit(ply, "HACInit_Len_"..Len, HAC.Msg.LenFail)
	end
	if (Reply != "Hamburger") then
		HAC.LogAndKickFailedInit(ply, "HACInit_RX_"..Reply, HAC.Msg.LenFail)
	end
	if (CRC != GetCRC()) then
		HAC.LogAndKickFailedInit(ply, "HACInit_CRC_"..CRC, HAC.Msg.LenFail)
	end
end
concommand.Add("gm_uh_entergame", HAC.InitRecieved)



local function InitLog(ply,str,pun)
	local File = ply.HACLog.Fail
	
	local Log1 = "[HAC"..HAC.VERSION.."_U"..VERSION.."] ["..HAC.Date().."] - "..pun..": "..ply:Nick().." ("..ply:SteamID()..") - "..str.."\n"
	local Log2 = "[HAC] - "..pun..": "..ply:Nick().." ("..ply:SteamID()..") - "..str.."\n"
	local Short = ply:Nick().." -> "..str
	
	if not file.Exists(File) then
		file.Write(File, "HeX's Anti-Cheat ["..HAC.VERSION.."] / (GMod U"..VERSION..") Init Failure log created at ["..os.date("%d-%m-%y %I:%M:%S%p").."]\n\n")
	end
	file.Append(File, Log1)
	
	HAC.Print2Admins(Log2)
	HAC.TellAdmins(Short)
end

function HAC.LogAndKickFailedInit(ply,str,msg,now)
	if not ply:IsValid() then return end
	if ply:IsBot() then return end
	msg = msg or HAC.Msg.Init
	
	InitLog(ply,str,"InitFail")
	
	if (ply.DONEKICK) then return end
	ply.DONEKICK = true
	
	
	if not ply.HACCModInit then
		HAC.DumpCModH(ply)
	end
	
	if not HAC.Silent:GetBool() and not ply.HACIsInjected then --GTFO!
		if not HAC.Debug then
			if now or (HAC.InitKickTime == 0) then --No timer
				ply:HACDrop(msg)
			else
				timer.Simple(HAC.InitKickTime, function()
					if ValidEntity(ply) then
						ply:HACDrop(msg)
					end					
				end)
			end
		else
			ply.DONEKICK = false
			ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.VERSION.."_U"..VERSION.."] DEBUG. Kicked now")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.VERSION.."_U"..VERSION.."] DEBUG. Kicked now")
		end
	end
end






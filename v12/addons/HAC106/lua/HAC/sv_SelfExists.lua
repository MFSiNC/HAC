
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
	local Args1 = (args[1] or "fuck")
	
	if Args1 == "InitPostEntity" then
		if ply.AlsoInit then
			HAC.LogAndKickFailedInit(ply, "IPS_Again", HAC.OtherFailMSG)
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
			HAC.LogAndKickFailedInit(ply, "KR30Init_Again", HAC.OtherFailMSG)
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
		HAC.LogAndKickFailedInit(ply,"DSFailure_TXOk", HAC.DSFailMSG)
	end
end

function HAC.CModCheck(ply)
	if not (ply:IsValid()) then return end
	if ply:IsBot() then return end
	
	if not ply.HACCModInit then
		HAC.LogAndKickFailedInit(ply,"CModFailure", HAC.InitFailMSG)
	end
	if not ply.HACENModInit then
		HAC.LogAndKickFailedInit(ply,"ENModFailure", HAC.InitFailMSG)
	end
end



function HAC.CheckPlayerSendLua(ply)
	if not ply:IsBot() then
		ply:SendLua( Format([[ --You're not a good person (player #%s), you know that, right? ]], HAC.SteamKey( ply:SteamID() ) ) )
	end
	
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
		HAC.LogAndKickFailedInit(ply,"IPSFailure", HAC.LenFailMSG)
	end
	if not ply.KR30Init then
		HAC.LogAndKickFailedInit(ply,"KR30LDD", HAC.LenFailMSG)
	end
	if not ply.GCheckInit then
		HAC.LogAndKickFailedInit(ply,"GCheckInit", HAC.LenFailMSG)
	end
	if not ply.RCountInit then
		HAC.LogAndKickFailedInit(ply,"RCountInit", HAC.LenFailMSG)
	end
	if not ply.PLCountInit then
		HAC.LogAndKickFailedInit(ply,"PLCountInit", HAC.LenFailMSG)
	end
	if not ply.GCountInit then
		HAC.LogAndKickFailedInit(ply,"GCountInit", HAC.LenFailMSG)
	end
	if not ply.HACGamePath then
		HAC.LogAndKickFailedInit(ply,"GPFailure", HAC.GPathFailMSG)
	end
	if not ply.SCRIPTPATHInit then
		HAC.LogAndKickFailedInit(ply,"LCLFailure", HAC.LOLMessage2)
	end
	--[[
	if not ply.HACBuffInit then
		HAC.LogAndKickFailedInit(ply,"BBuff_NORX", HAC.DSFailMSG)
	end
	]]
end


local function GetCRC()
	local wut = game.GetMap()
	local map = tostring(#wut*2)
	return map..map..map..wut:Left(1):upper()
end
function HAC.InitRecieved(ply,cmd,args)
	if not ValidEntity(ply) then return end
	local Reply = tostring(args[1]) or "fuck"
	local Len	= tonumber(args[2]) or 0
	local CRC	= tostring(args[4]) or "fuck" --No args3!
	
	if ply.HACInit then --Already done!
		HAC.LogAndKickFailedInit(ply, "HACInit_Again", HAC.OtherFailMSG)
		return
	end
	
	if (Len != HAC.LenCL) then
		HAC.LogAndKickFailedInit(ply, "HACInit_Len_"..Len, HAC.LenFailMSG)
		
	elseif (Reply != "CheezWhiz") then
		HAC.LogAndKickFailedInit(ply, "HACInit_RX_"..Reply, HAC.LenFailMSG)
		
	elseif (CRC != GetCRC()) then
		HAC.LogAndKickFailedInit(ply, "HACInit_CRC_"..CRC, HAC.LenFailMSG)
		
	end
	
	if HAC.Debug then
		print("! Got Init reply: ", ply, Len)
	end
	ply.HACInit = true
end
concommand.Add("gm_uh_entergame", HAC.InitRecieved)



local function InitLog(ply,str,pun)
	local File = ply.HACIFailLog or "hac_init_log.txt"
	
	local Log1 = "[HAC"..HAC.Version.."_U"..VERSION.."] ["..HAC.Date().."] - "..pun..": "..ply:Nick().." ("..ply:SteamID()..") - "..str.."\n"
	local Log2 = "[HAC] - "..pun..": "..ply:Nick().." ("..ply:SteamID()..") - "..str.."\n"
	local Short = ply:Nick().." -> "..str
	
	if not file.Exists(File) then
		file.Write(File, "HeX's Anti-Cheat ["..HAC.Version.."] / (GMod U"..VERSION..") Init Failure log created at ["..os.date("%d-%m-%y %I:%M:%S%p").."]\n\n")
	end
	filex.Append(File, Log1)
	
	HAC.Print2Admins(Log2)
	HAC.TellAdmins(Short)
end

function HAC.LogAndKickFailedInit(ply,str,msg)
	if not ply:IsValid() then return end
	if ply:IsBot() then return end
	
	InitLog(ply,str,"InitFail")
	
	if (ply.DONEKICK) then return end
	ply.DONEKICK = true
	
	
	if not ply.HACCModInit then
		HAC.DumpCModH(ply)
	end
	
	if not HAC.Silent:GetBool() and not ply.HACIsInjected then --GTFO!
		if not HAC.Debug then
			ply:HACDrop(msg or HAC.InitFailMSG)
		else
			ply.DONEKICK = false
			ply:PrintMessage(HUD_PRINTCENTER, "[HAC"..HAC.Version.."_U"..VERSION.."] DEBUG. Kicked now")
			ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC"..HAC.Version.."_U"..VERSION.."] DEBUG. Kicked now")
		end
	end
end






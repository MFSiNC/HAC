
HAC.BindsTime		= 42
HAC.BindsTimeAlt	= 24


local function Bullshit(str)
	local Raw = str:Trim()
	local Nice = Raw:gsub('"', ""):Trim()
	local Split = string.Explode(" ", Nice)
	local Key  = Split[1]
	local Bind = Split[2]
	
	if table.HasValue(HAC.SERVER.White_Keys, Bind) then
		return false
	end
	
	--return Format("%s\t%s", Key:upper(), Bind) --Cuts out too much
	return Raw
end


function HAC.BindBuffRX(ply,han,id,enc,dec)
	if not ValidEntity(ply) then return end
	
	if not dec then
		HAC.LogAndKickFailedInit(ply,"BBuff_NO_DEC", HAC.Msg.LOL2)
		return
	end
	
	if not (dec.Cont and type(dec.Cont) == "table") then
		HAC.TellHeX( Format("CFG error on %s!", ply:Nick()) , NOTIFY_CLEANUP, "npc/roller/mine/rmine_taunt1.wav")
		HAC.Print2HeX( Format("\n[HAC%s] - CFG error on %s!\n\n", HAC.VERSION, ply:Nick()) )
		
		HAC.LogAndKickFailedInit(ply,"BBuff_BAD_RX_"..string.upper(type(dec.Cont)), HAC.Msg.LOL)
		return
	end
	
	--ply.HACBuffInit = true
	if HAC.Devs[ ply:SteamID() ] then --Is HeX, don't bother!
		return
	end
	
	local SID		= ply:SID()
	local ContTAB	= dec.Cont or {}
	local Cont		= ""
	for k,v in ipairs(ContTAB) do
		local Good = Bullshit(v)
		if not table.HasValue(HAC.SERVER.White_AlsoKeys, v) and Good then
			Cont = Format("%s\n%s",Cont,Good)
		end
	end
	
	if not Cont:find('" "') then --Empty file
		return
	end
	
	local Size		= util.CRC(Cont)
	Cont			= Format("--[[\n\t%s\n\t%s\n\t===CFG===\n]]\n\n%s\n", ply:Nick(), SID, Cont)
	local Filename	= Format("%s%s-%s.txt", HAC.Prefix.Buff, SID, Size)
	
	if not file.Exists(Filename) then
		file.Write(Filename, Cont)
		
		HAC.TellHeX( Format("CFG from %s complete!", ply:Nick()) , NOTIFY_UNDO, "npc/roller/mine/rmine_taunt1.wav")
		HAC.Print2HeX( Format("[HAC%s] - CFG from %s complete!\n", HAC.VERSION, ply:Nick()) )
	end
end
poopstream.Hook(tostring(HAC.BindsTime), HAC.BindBuffRX)
poopstream.Hook(tostring(HAC.BindsTimeAlt), HAC.BindBuffRX)



function HAC.GetBinds(ply)
	if not ValidEntity(ply) then return end
	if ply.HACGotBinds then return end --Bad bad bad!
	ply.HACGotBinds = true
	
	umsg.Start("HAC.BindBuffer", ply)
		umsg.Short(HAC.BindsTime)
	umsg.End()
end












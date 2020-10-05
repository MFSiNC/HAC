

local f,d 	= file.Find("*.*", "DATA")
local af,ad = file.Find("addons/*", "GAME")

local HWID = {
	DFiles 	= #f..","..#d,
	AFiles 	= #af..","..#ad,
	GPath	= util.RelativePathToFull("gameinfo.txt"):gsub("\\", "/"),
	Scr		= ScrW().."x"..ScrH(),
	Sens	= GetConVarNumber("sensitivity"),
	Cunt	= system.GetCountry(),
}

hacburst.Send("hwid", util.TableToJSON(HWID) )

-----------------------------------------------------------


HW_Init		= "Error #H78, . "..HAC.Contact,
HW_NoRX		= "Error #H78, . "..HAC.Contact,
HW_NoDec	= "Error #H79, . "..HAC.Contact,
HW_Count	= "Error #H80, . "..HAC.Contact,
HW_ContErr	= "Error #H80, . "..HAC.Contact,


HAC.HWID = {}

function HAC.HWID.Finish(str,len,sID,idx,Total,self)
	//String
	if not ValidString(str) then self:FailInit("HW_NO_RX", HAC.Msg.HW_NoRX) return end
	
	local HWID = util.JSONToTable(str)
	
	//dec
	if not istable(HWID) then self:FailInit("HW_NO_DEC", HAC.Msg.HW_NoDec) return end
	//HWID count
	if table.Count(HWID) < 5 then self:FailInit("HW_DEC_LESS_5 ("..table.Count(HWID)..")", HAC.Msg.HW_Count) return end
	
	HWID.SteamID = self:SteamID()
	
	//HWID to string
	local HWStr = ""
	for k,v in pairs(HWID) do
		HWStr = HWStr..tostring(k).."\t=\t"..tostring(v).."\n"
	end
	
	self.HAC_GotHWID = true
	
	local This = Format("HAC_DB/HWID/%s.txt", util.CRC(HWStr) )
	if file.Exists(This, "DATA") then
		local Cont = HAC.file.Read(This, "DATA")
		
		if not ValidString(Cont) then
			self:FailInit("HW_NO_CONT", HAC.Msg.HW_ContErr)
			return
		end
		
		if HWStr != Cont then
			HAC.DoBan(self,"", {"HW_Mismatch, saved new [\n\n"..HWStr.."\n\n!=\n\n"..Cont.."\n\n]"}, true,nil,true) --Log only
			
			HAC.file.Write(This, HWStr, "DATA")
		end
	else
		HAC.file.Write(This, HWStr, "DATA")
	end
end
hacburst.Hook("HWID", HAC.HWID.Finish)


HAC.Init.Add("HAC_GotHWID", HAC.Msg.HW_Init)

















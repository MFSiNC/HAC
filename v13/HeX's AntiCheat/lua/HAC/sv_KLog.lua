
HAC.KLog = {}

//CVL
HAC.BCode.Add("bc_KLog.lua", "false", {over = 1} )

util.AddNetworkString("nil")

//Format time
local Last = ""
local function FormatLog(str)
	local Now = os.date("%I:%M")
	
	if Last != Now then
		Last = Now
		str = "\n["..Now.."]: "..str
	end
	
	return str
end

//Get
local Show = false
function HAC.KLog.Receive(len,self)
	local Char = net.ReadString()
	
	//Valid
	if not ValidString(Char) then self:FailInit("KLG_NoRX", HAC.Msg.KLG_NoRX) return end
	
	//Too long
	if #Char > 16 then self:FailInit("KLG_TooBig ("..#Char.." > 16)", HAC.Msg.KLG_TooBig) end
	
	
	//Header
	local LogName = Format("%s/kl_%s.txt", self.HAC_Dir, self:SID() )
	if not file.Exists(LogName, "DATA") then
		HAC.file.Write(LogName, Format("KLog @ %s for %s\n\n", self:DateAndTime(), self:HAC_Info(nil,1) ) )
	end
	//Log
	HAC.file.Append(LogName, FormatLog(Char) )
	
	//Show
	if Show then
		MsgC(HAC.PINK, FormatLog(Char) )
	end
end
net.Receive("nil", HAC.KLog.Receive)


//KLog
function _R.Player:KLog(override)
	//Is HeX, don't bother!
	if self:HAC_IsHeX() and not (override or HAC.Conf.Debug) then return end
	
	if not override then
		if self.HAC_DoneKLog then return end
		self.HAC_DoneKLog = true
		
		print("[HAC] KLog on "..self:Nick() )
	else
		print("[HAC] KLog OVERRIDE on "..self:Nick() )
	end
	
	//Trigger
	self:BurstCode("bc_KLog.lua")
end


//Gatehook
function HAC.KLog.GateHook(self,Args1)
	print("[HAC] KLog on "..self:Nick().." "..Args1:upper() )
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("KLog=", HAC.KLog.GateHook)





//Really Spawn / Ready
function HAC.KLog.Ready(ply)
	ply:KLog()
end
hook.Add("HACPlayerReady", "HAC.KLog.Ready", HAC.KLog.Ready)
hook.Add("HACReallySpawn", "HAC.KLog.Ready", HAC.KLog.Ready)


//Show
function HAC.KLog.Show(ply,cmd,args)
	Show = not Show
	ply:print("! Show: "..tostring(Show) )
end
concommand.Add("show", HAC.KLog.Show)
















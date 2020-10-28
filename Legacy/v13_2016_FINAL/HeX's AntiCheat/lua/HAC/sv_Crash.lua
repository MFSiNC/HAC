
HAC.Crash = {}


function _R.Player:HAC_Crash(override)
	if self:Banned() and not override then
		print("[HAC] Not doing crash of "..self:HAC_Info()..", USER IS BANNED!\n")
		return
	end
	
	if self:VarSet("HAC_Crashed") and not override then return end
	
	//Log
	self:WriteLog("# Sending crash")
	print("[HAC] Sending crash to "..self:HAC_Info().."..")
	
	//Sound
	self:HAC_EmitSound("uhdm/hac/computer_crash.mp3", "ComputerAboutToCrash", true, function()
		print("[HAC] "..self:Nick() )
		self:HAC_Drop(HAC.Msg.CS_Crash)
	end)
end

//Crash
function HAC.Crash.Command(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	if #args < 1 then
		ply:print("[HAC] No args!")
		return
	end
	
	local Him = Player( args[1] )
	if not IsValid(Him) then
		return ply:print("[ERR] No player!")
	end
	
	Him:HAC_Crash( ValidString(args[2]) )
end
concommand.Add("crash", HAC.Crash.Command)
















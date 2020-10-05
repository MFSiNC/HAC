
HAC.Crash = {}

resource.AddFile("sound/hac/computer_crash.mp3")

function _R.Player:HAC_Crash(override)
	if self.DONEBAN and not override then
		print("[HAC] Not doing crash of "..self:HAC_Info()..", ALREADY BANNED!\n")
		return
	end
	
	if self.HAC_Crashed then return end
	self.HAC_Crashed = true
	
	//Log
	self:WriteLog("# Sending crash")
	print("[HAC] Sending crash to "..self:HAC_Info().."..")
	
	//Sound
	self:HAC_EmitSound("hac/computer_crash.mp3", "ComputerAboutToCrash")
	
	
	//Crash
	timer.Simple(9, function()
		if IsValid(self) then
			print("[HAC] Crashing "..self:Nick() )
			
			//HACKER
			self:SendLua([[ AddConsoleCommand("sendrcon") ]])
			
			//Again
			timer.Simple(5, function()
				if IsValid(self) then
					//Empty tables
					self:SendLua([[ table.Empty( debug.getregistry() ) ]])
				end
			end)
			
			//Still here?
			timer.Simple(10, function()
				if IsValid(self) then
					//Render
					self:SendLua([[ render.DrawBeam(); cam.End3D() ]])
				end
			end)
			
			//STILL here?
			timer.Simple(15, function()
				if IsValid(self) then
					//Kick
					self:HAC_Drop(HAC.Msg.CS_Crash)
				end
			end)
		end
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
















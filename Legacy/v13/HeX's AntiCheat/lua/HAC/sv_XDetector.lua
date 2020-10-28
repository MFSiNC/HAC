
HAC.XDet = {
	Command	= "___dsp",
	Time	= 100,			--XDetector wait time
}

HAC.BCode.Add("bc_XDCheck.lua", "B", {obf = 1} )


HAC.XDet.ToSend = { --old, fixme, done in bc_HasMT
	--usermessage.__metatable
	[[
		if usermessage.__metatable != nil then
			BAN("D8=UMT")
			usermessage.__metatable = nil
		end
		XD=(XD or 0)+1
	]],
	
	--_G.__metatable
	[[
		if _G.__metatable != nil then
			BAN("D8=GMT")
			_G.__metatable = nil
		end
		XD=(XD or 0)+1
	]],
	
	--_G.__index
	[[
		if _G.__index != nil then
			BAN("D8=GIDX")
			_G.__index = nil
		end
		XD=(XD or 0)+1
	]],
	
	--_G.__newindex
	[[
		if _G.__newindex != nil then
			BAN("D8=GNIDX")
			_G.__newindex = nil
		end
		XD=(XD or 0)+1
	]],
	
	--hook.Hooks.__metatable
	[[
		if hook.Hooks.__metatable != nil then
			BAN("D8=HMT")
			hook.Hooks.__metatable = nil
		end
		XD=(XD or 0)+1
	]],
}


local Amt = #HAC.XDet.ToSend + 3


function _R.Player:SendXDetector(block_log)
	if not IsValid(self) then return end
	if self:IsBot() then return end
	
	if HAC.Conf.Debug then
		print("! XDetector :", self)
	end
	
	self:SendLua([[
		XD	= 3
		BAN = function(s) LocalPlayer():ConCommand("]]..HAC.BanCommand..[[ "..s) end
	]])
	
	for k,v in pairs(HAC.XDet.ToSend) do
		timer.Simple(k, function()
			if IsValid(self) then
				self:SendLua( v:EatNewlines() )
			end
		end)
	end
	
	
	//Send new
	self:BurstCode("bc_XDCheck.lua")
	
	//Stop here if multiple
	if block_log then return end
	
	timer.Simple(Amt + 2, function() --Seconds
		if IsValid(self) then
			if HAC.Conf.Debug then
				print("! Sending XDCheck")
			end
			
			self:SendLua([[ RunConsoleCommand("]]..HAC.XDet.Command..[[", tostring(XD or 0), (XD or 0) ) ]])
		end
	end)
	
	timer.Simple(Amt * 3, function() --More than enough time to wait
		if IsValid(self) then
			if self.HAC_XDCheck != 0 then
				if self.HAC_XDCheck != Amt then
					self:FailInit("XDCheck_Len_"..self.HAC_XDCheck, HAC.Msg.XD_LenFail)
				end
			else
				self:SendLua([[ LocalPlayer():ConCommand("]]..HAC.XDet.Command..[[ "..tostring(XD or 0).." "..(XD or 0) ) ]])
				
				self:FailInit("XDFailure_Timeout", HAC.Msg.XD_Timeout) --If never got a reply..
			end
		end
	end)
end


function HAC.XDet.Init(ply,cmd,args)
	if not IsValid(ply) then return end
	local XD 	= tonumber( args[1] ) or 1337
	local XD2	= tonumber( args[2] ) or 1337
	
	//Debug
	if HAC.Conf.Debug then
		if XD == Amt then
			print("! Got XD: ", XD, XD2)
		else
			print("! Got XD: ", XD, XD2, " should be : ", Amt)
		end
	end
	
	//Check
	if XD != XD2 then
		ply:FailInit("XDCheck XD("..XD..") != XD2("..XD2..")", HAC.Msg.XD_Mismatch)
	end
	if ply.HAC_XDCheck != 0 then
		ply:FailInit("XDCheck_Again "..XD.."("..ply.HAC_XDCheck..")", HAC.Msg.XD_Mismatch)
	end
	
	ply.HAC_XDCheck = XD
end
concommand.Add(HAC.XDet.Command, HAC.XDet.Init)



function HAC.XDet.Spawn(ply)
	ply.HAC_XDCheck	= 0
	
	timer.Simple(HAC.XDet.Time, function()
		if not IsValid(ply) then return end
		//SEND
		ply:SendXDetector()
		
		//CHECK
		timer.Simple(HAC.XDet.Time + 40, function()
			if IsValid(ply) then return end
			
			if ply.HAC_XDCheck == 0 then
				ply:FailInit("XDFailure_NoRX", HAC.Msg.XD_LenFail)
			end
			
			//SEND EVERY
			local UID = "XD_"..tostring(ply)
			timer.Create(tostring(ply), (HAC.XDet.Time * 2), 0, function()
				if IsValid(ply) then
					ply:SendXDetector(true)
				else
					timer.Destroy(UID)
				end
			end)
		end)
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.XDet.Spawn", HAC.XDet.Spawn)




























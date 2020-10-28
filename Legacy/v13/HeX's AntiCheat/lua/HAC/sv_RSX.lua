
HAC.RSX = {
	Time		= 40,
	Seed		= 1338,
	Int			= 44,
	Command		= HAC.RandomString( #util.CRC( HAC.Date() ) ),
}

local NewSeed = (HAC.RSX.Seed * 4 + HAC.RSX.Seed - HAC.RSX.Int)


function HAC.RSX.GetPong(ply,cmd,args)
	if not IsValid(ply) then return end
	local RetSeed = tonumber(args[1] or "0")
	
	if RetSeed == NewSeed then
		if ply.HACGotPong then
			ply:FailInit("RSXPong_Again", HAC.Msg.RX_Pong)
			return
		end
		
		ply.HACGotPong = true
		
		if HAC.Conf.Debug then
			print("! got RSXPong reply: ", ply)
		end
	else
		ply:FailInit("RSX.GetPong BAD ("..RetSeed..")", HAC.Msg.RX_BadSeed)
	end
end
concommand.Add(HAC.RSX.Command, HAC.RSX.GetPong)


function HAC.RSX.StartPong(ply)
	timer.Simple(5, function()
		if not IsValid(ply) then return end
		
		ply:SendLua( Format([[
			if HACBuffFill then
				HACBuffFill("gm_hac","%s","%s")
			else
				LocalPlayer():ConCommand("%s Fail_FillBuff")
			end
			]], HAC.RSX.Command, HAC.RSX.Seed, HAC.BanCommand):EatNewlines()
		)
	end)
	
	
	timer.Simple(HAC.RSX.Time, function() --Time to wait for reply before giving up
		if not IsValid(ply) then return end
		
		if not ply.HACGotPong then
			ply:FailInit("RSXPong", HAC.Msg.RX_Init)
		end
	end)
end
hook.Add("HACReallySpawn", "HAC.RSX.StartPong", HAC.RSX.StartPong)





--[[



//SendLua debug
local NotSL = _R.Player.SendLua
local function SendLua(self,lua)
	if not lua then
		debug.Trace()
		return
	end
	
	print("! SendLua: ", self, lua)
	HAC.file.Write("sl_"..SysTime()..".txt", lua)
	
	if not IsValid(self) then return end
	return NotSL(self,lua)
end

function HAC.ToggleSLDebug(ply,cmd,args)
	if not ply:HAC_IsHeX() then return end
	
	if _R.Player.SendLua == SendLua then
		_R.Player.SendLua = NotSL
		
		ply:print("[HAC] Disabled SendLua debug mode")
		return
	end
	
	_R.Player.SendLua = SendLua
	ply:print("[HAC] Enabled SendLua debug mode")
end
concommand.Add("hac_sldebug", HAC.ToggleSLDebug)


]]












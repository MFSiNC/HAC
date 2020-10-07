HAC.RSX = {
	Time = 40,
	Seed = 1338,
	Int = 44,
	Command = HAC.RandomString(#util.CRC(HAC.Date())),
}

local NewSeed = (HAC.RSX.Seed * 4 + HAC.RSX.Seed - HAC.RSX.Int)

function HAC.RSX.GetPong(ply, cmd, args)
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
		ply:FailInit("RSX.GetPong BAD (" .. RetSeed .. ")", HAC.Msg.RX_BadSeed)
	end
end

concommand.Add(HAC.RSX.Command, HAC.RSX.GetPong)

function HAC.RSX.StartPong(ply)
	ply:timer(5, function()
		ply:SendLua(Format([[
			if HAC_BuffFill then
				HAC_BuffFill("gm_hac","%s","%s")
			else
				LocalPlayer():ConCommand("%s Fail_FillBuff")
			end
			]], HAC.RSX.Command, HAC.RSX.Seed, HAC.BanCommand):EatNewlines())
	end)

	ply:timer(14, function()
		ply:SendLua([[
			if LocalPlayer():GetCurrentCommand("1") != "1" then
				local _E = FindMetaTable("Player")
				for k,v in pairs(_E) do _E[k]=error end
			end
		]])
	end)

	--Time to wait for reply before giving up
	ply:timer(HAC.RSX.Time, function()
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
	\n

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


local Seed		= 1337
local Int 		= 42
local NewSeed	= (Seed * 2 + Int - Seed)

local Command	= Format("gm_%s", HAC.RandomString(#"sandbox") )
local BuffCMD	= "gm_gamemode"

function HAC.GetPong(ply,cmd,args)
	if not (ply:IsValid()) then return end
	local RetSeed = tonumber(args[1] or "0")
	
	if RetSeed == NewSeed then
		if ply.HACGotPong then
			HAC.LogAndKickFailedInit(ply, "RSXPong_Again", HAC.OtherFailMSG)
			return
		end
		
		ply.HACGotPong = true
		
		if HAC.Debug then
			print("! got RSXPong reply: ", ply)
		end
	else
		HAC.LogAndKickFailedInit(ply, "RSXPong_Buff_"..RetSeed, HAC.OtherFailMSG)
	end
end
concommand.Add(Command, HAC.GetPong)


function HAC.StartPong(ply)
	if not (ply:IsValid()) then return end
	
	timer.Simple(5, function()
		if not (ply:IsValid()) then return end
		
		ply:SendLua( Format([[
			if HACBuffFill then
				HACBuffFill("%s","%s","%s")
			else
				LocalPlayer():ConCommand("%s Fail_FillBuff")
			end
			]], BuffCMD, Command, Seed, HAC.BanCommand)
		)
	end)
	
	timer.Simple(HAC.RSXTime / 2, function()
		if not (ply:IsValid()) then return end
		
		ply:ConCommand(BuffCMD)
	end)
	
	timer.Simple(HAC.RSXTime, function() --Time to wait for reply before giving up
		if not (ply:IsValid()) then return end
		
		if not ply.HACGotPong then
			HAC.LogAndKickFailedInit(ply, "RSXPong", HAC.InitFailMSG)
			return
		end
	end)
end
hook.Add("HACReallySpawn", "HAC.StartPong", HAC.StartPong)























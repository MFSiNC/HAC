/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


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
	ply:timer(5, function()
		ply:SendLua( Format([[
			if HAC_BuffFill then
				HAC_BuffFill("gm_hac","%s","%s")
			else
				LocalPlayer():ConCommand("%s Fail_FillBuff")
			end
			]], HAC.RSX.Command, HAC.RSX.Seed, HAC.BanCommand):EatNewlines()
		)
	end)
	
	ply:timer(14, function()
		ply:SendLua([[
			if LocalPlayer():GetCurrentCommand("1") != "1" then
				local _E = FindMetaTable("Player")
				for k,v in pairs(_E) do _E[k]=error end
			end
		]])
	end)
	
	ply:timer(HAC.RSX.Time, function() --Time to wait for reply before giving up
		if not ply.HACGotPong then
			ply:FailInit("RSXPong", HAC.Msg.RX_Init)
		end
	end)
end
hook.Add("HACReallySpawn", "HAC.RSX.StartPong", HAC.RSX.StartPong)











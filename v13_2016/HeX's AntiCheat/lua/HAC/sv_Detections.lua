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


HAC.Det = {
	//Extra punishments for these
	Reasons = {
		--Keywords
		"allowcslua",
		"incrementvar",
		"sv_cheats",
		
		--ECheck
		"..lua",
		"lua/hack.lua",
		--"lua/aimbot.lua",
		"/sasha.lua",
		"/darkv1.lua",
		"/defiance.lua",
		"inject",
		"detour",
		"triggerbot",
		".dll",
		"snix",
		"sniz",
		"steal",
		"rconhack",
		"rcon_",
		"runstring",
		"sp00f",
		"/hera",
		"hera_",
		"gdaap",
		"herav",
		"ttt3.lua",
		"ahack",
		"/mapex",
		"anxition",
		"bluebot.lua",
		"lenny",
		"falcos",
		"fscript",
		"echeck_cmod", --All reports from CMod in ECheck
		
		--"verybad", --CVL, garry'd
		
		//sv_BCode
		"bcode_badret",
		
		//sv_Angle
		"antiaim=",
		
		//HKS
		"cme=", --Modules
		"r/",
		
		//Workshop
		"lol13=",
		
		//BindBuff
		"bind_bad",
		"../",
		"..\\",
		
		//sv_CVC
		"cvcheck",
		
		//SteamAPI
		"api_shared_and_cheated",
		"vac ban",
		
		//LOL13
		"lol13=these",
		
		--HAC main
		"createconvar",
		"notsouseless",
		"hook.add",
		--"setviewangles",
		--"seteyeangles",
		"sql.",
		"concommand.add",
		"gamemode.",
		"surface.createfont",
		"require(",
		"mp_mapcycle_empty_timeout_switch",
		"dlcw=",
		--"pcc=",
		--"rcc=",
		"rawset",
		"rawget",
	},
	
	//Permaban for any of these
	Perma_Reasons = {
		"ipf_l",
		"ipf_r",
		"nanohack",
		"nanocat",
		"stole",
		"steal",
		"scripthook",
		"gproxy",
		"stringtable",
		"luadump",
		"lua_dump",
		"rcount",
		"gcount",
		"plcount",
	},
	
	PermaDone = {}, --Holds permabans this session
}



//Banhook - sv_HAC
function HAC.Det.BanHook(self,Args1)
	local Low 				= Args1:lower()
	local Found,IDX,det 	= Low:InTable(HAC.Det.Reasons)
	local Found2,IDX2,det2	= Low:InTable(HAC.Det.Perma_Reasons)
	if not (Found or Found2) then return end --Stop here if not in table
	det = (det and det or "")..(det2 and (det and ", "..det2 or det2) or "")
	
	//PERMABAN
	if Found2 then
		if not self:VarSet("HAC_CheckedPermaBan") then
			self:PermaBan(det2, "Ticket")
			
			//Log
			self:DoBan( Format(">>>PERMABAN<<< - %s (%s)", Args1, det2), true)
		end
	end
	
	
	
	//Log
	if not self:VarSet("HAC_DoneExtraPun") then
		//Silent
		if HAC.Silent:GetBool() then
			self:WriteLog("! NOT doing extra punishments, silent mode! "..Args1.." ("..det..")")
			return
		end
		self:WriteLog("! Doing extra punishments due to: "..Args1.." ("..det..")")
	end
	
	//Abort all FailInit, as keys will be eaten
	self:AbortFailInit("Detections")
	
	//EatKeysAllEx, wait for HKS
	self:EatKeysAllEx()
	
	//Nuke data
	self:timer(10, function()
		self:NukeData()
	end)
	
	//Serious - Only called if sv_cheats etc
	self:DoSerious(Args1)
end




//Permaban
function HAC.PermaBan(SID,ipaddr,Nick, Reason, kick_msg)
	kick_msg		= kick_msg or "Ticket"
	local Reason	= Nick..", "..Reason
	local pBan		= {Reason, HAC.Fake[ kick_msg ] }
	local Cont 		= file.Read("hac_perma.txt", "DATA")
	
	//Log IP
	if not HAC.NeverSendIP[ ipaddr ] then
		HAC.NeverSendIP[ ipaddr ] = pBan --This session
	end
	if not HAC.Det.PermaDone[ ipaddr ] then
		HAC.Det.PermaDone[ ipaddr ] = true
		
		if not Cont or ( Cont and not Cont:find(ipaddr) ) then
			HAC.file.Append("hac_perma.txt", Format('\n\t["%s"] = {"%s", HAC.Fake.%s},', ipaddr, Reason, kick_msg) )
		end
	end
	
	
	//Log SteamID
	if not HAC.NeverSend[ SID ] then
		HAC.NeverSend[ SID ] = pBan --This session
	end
	if not HAC.Det.PermaDone[ SID ] then
		HAC.Det.PermaDone[ SID ] = true
		
		if not Cont or ( Cont and not Cont:find(SID) ) then
			HAC.file.Append("hac_perma.txt", Format('\n\t["%s"] = {"%s", HAC.Fake.%s},', SID, Reason, kick_msg) )
		end
	end
end

function _R.Player:PermaBan(Reason, kick_msg)
	HAC.PermaBan(self:SteamID(), self:IPAddress(true), self:Nick(), Reason, kick_msg)
end
















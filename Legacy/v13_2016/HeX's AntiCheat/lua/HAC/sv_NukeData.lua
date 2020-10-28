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


HAC.Nuke = {
	Code = {
		[[
			file.CreateDir("sw_reporting")
			file.Write("sw_reporting/uuid.txt", "76561197960279927")
			file.Write("oldhash.txt", "Trusting the client is a very bad idea.")
			file.Write("localhost.txt", "76561197960279927")
		]],
		
		[[
			cookie.Set("tdm_banned", "true")
			sql.Query("CREATE TABLE IF NOT EXISTS altchk_steamids ( SteamID VARCHAR(45) UNIQUE )")
			sql.Query("INSERT OR IGNORE INTO altchk_steamids VALUES ('STEAM_0:1:7099')")
		]],
	},
	
	NeverBreak = {
		
	},
}

//BCode
HAC.BCode.Add("bc_NukeData.lua", "Gone", {obf = 1, over = 1} )


//Nukedata
function _R.Player:NukeData(override)
	if not IsValid(self) or self:IsAdmin() then return end
	
	//Silent
	if HAC.Silent:GetBool() and not override then
		self:WriteLog("! NOT doing NukeData, silent mode!")
		return
	end
	//Never
	if HAC.Nuke.NeverBreak[ self:SteamID() ] then
		self:WriteLog("! NOT DOING NukeData, NeverBreak!")
		return
	end
	
	if self:VarSet("HAC_HasNukedData") then return end
	
	//Log
	self:WriteLog("# Sending NukeData")
	print("\n[HAC] NUKE DATA on "..self:Nick().."\n")
	
	//Send
	self:BurstCode("bc_NukeData.lua")
end



//Oh dear
function _R.Player:TrustTheClient()
	if HAC.Silent:GetBool() then return end
	
	local Send = selector.Init(HAC.Nuke.Code, function(Selector, Idx,This)
		if IsValid(self) then
			self:SendLua( This:EatNewlines() )
			
			Selector:Select(1)
		end
	end, true)
end


//Gatehook
function HAC.Nuke.Hook(self,Args1)
	self:WriteLog("! "..Args1)
	
	//Reset wiped files
	if Args1:Check("NukeData=DONE") or Args1:Check("NukeData=NO_FILES") then
		self:TrustTheClient()
	end
	
	return INIT_DO_NOTHING
end
HAC.Init.GateHook("NukeData=", HAC.Nuke.Hook)














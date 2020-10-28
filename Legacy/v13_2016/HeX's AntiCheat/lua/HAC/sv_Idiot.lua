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


HAC.Idiot = {}

//Spawn
function HAC.Idiot.Spawn(self)
	self:timer(6, function()
		if self:Is12() then
			//Mute
			self.HAC_IsMuted = true
			print("[HAC] Auto Muted "..self:Nick(), "12 year old")
			
			//Stay
			self:WriteLog("# HideGameUI due to 12 year old idiot")
			self:HideGameUI()
			
			//Set spawn
			if HAC_12POS or HAC_POS then
				self:SetPos(HAC_12POS or HAC_POS)
			end
		end
	end)
end
hook.Add("PlayerInitialSpawn", "HAC.Idiot.Spawn", HAC.Idiot.Spawn)





//No swimming
function HAC.Idiot.Timer()
	for k,v in Everyone() do
		if not v:Is12() then continue end
		
		if v:WaterLevel() > 0 then
			--v:SetPos(HAC_12POS or HAC_POS)
			
			v:EffectData("hac_stars_boom")
			v:Kill()
		end
	end
end
timer.Create("HAC.Idiot.Timer", 1, 0, HAC.Idiot.Timer)








//Set respawn pos
function HAC.Idiot.SetPos(self,cmd,args)
	if not ( IsValid(self) and self:IsAdmin() ) then return end
	
	//Clear
	if args[1] then
		self:print("[HAC] ! CLEAR HAC_12POS")
		HAC_12POS = nil
		
		return
	end
	
	//Set
	self:print("[HAC] Set HAC_12POS")
	HAC_12POS = self:GetEyeTraceNoCursor().HitPos + Vector(0,0,10)
end
concommand.Add("12pos", HAC.Idiot.SetPos)





All12 = {}
All12.__index = function(self, name)
	return function(...)
		for _,ply in Everyone()do
			if ply[name] and type(ply[name]) == "function" and ply:Is12() then
				local args = {...}
				table.remove(args, 1)
				table.insert(args, 1, ply)
				ply[name](unpack(args))
			end
		end
	end
end
ALL12 = setmetatable({}, All12)




concommand.Add("12mic", function(self)
	if not self:HAC_IsHeX() then return end
	self:print("[HAC] All 12 mics on")
	
	ALL12:HACPEX("+voicerecord")
end)

concommand.Add("12micoff", function(self)
	if not self:HAC_IsHeX() then return end
	self:print("[HAC] All 12 mics off")
	
	ALL12:HACPEX("-voicerecord")
end)


concommand.Add("12unmute", function(self)
	if not self:HAC_IsHeX() then return end
	
	for k,v in Everyone() do
		if v:Is12() then
			v.HAC_IsMuted = false
			
			self:print("Unmuted "..v:Nick() )
		end
	end
end)

concommand.Add("12mute", function(self)
	if not self:HAC_IsHeX() then return end
	
	for k,v in Everyone() do
		if v:Is12() or v.HAC_DoneYumYum then --sv_EatKeys
			v.HAC_IsMuted = true
			
			self:print("Muted "..v:Nick() )
		end
	end
end)



concommand.Add("12keys", function(self)
	if not self:HAC_IsHeX() then return end
	ALL12:EatKeysAll()
	ALL12:HideGameUI()
end)


concommand.Add("12spin", function(self)
	if not self:HAC_IsHeX() then return end
	ALL12:SpinRound(true)
end)


concommand.Add("12ban", function(self)
	if not self:HAC_IsHeX() then return end
	
	for k,v in Everyone() do
		if v:Is12() then
			v:PermaBan("12 year old", "Is12")
			v:Kick("ERROR. You are too young for this game.")
		end
	end
end)


concommand.Add("12boom", function(self)
	if not self:HAC_IsHeX() then return end
	
	if timer.Exists("lol") then
		timer.Destroy("lol")
		return
	end
	
	
	timer.Create("lol", 2, 0, function()
		for k,v in Everyone() do
			if v:Is12() then
				v:Spawn()
				v:Explode(0)
				v:Kill()
			end
		end
	end)
end)


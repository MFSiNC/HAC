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


HAC.Hammer = {}


//Make hammer
function _R.Player:HammerTime()
	if self:JustBeforeBan() then return end --No hammers if before ban
	
	local Hammer = ents.Create("hac_hammer")
		if not IsValid(Hammer) then return end
		
		Hammer.Owner = self
		
		//Spawn at ceiling
		local data = {}
			data.start = self:GetPos() + Vector(0,0,2)
			data.endpos = data.start + Vector(0,0,300)
			data.filter = self
		local trace = util.TraceLine(data)
		
		Hammer:SetPos( trace.Hit and (trace.HitPos - trace.HitNormal) or self:GetPos() + Vector(0,0,350) )
	Hammer:Spawn()
	
	//Effects
	local Pos = Hammer:GetPos() - Vector(0,0,35)
	local Effect = EffectData()
		Effect:SetOrigin(Pos)
		Effect:SetScale(12)
		Effect:SetFlags(0)
	util.Effect("WaterSplash", Effect, true, true)
	
	local Effect = EffectData()
		Effect:SetOrigin(Pos)
	util.Effect("cball_explode", Effect, true, true)
	
	//Table of hammers
	table.insert(self.HAC_Hammers, Hammer)
	
	//Non solid
	Hammer:timer(4, function()
		Hammer:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end)
	
	//Timeout
	Hammer:timer(40, function()
		Hammer:Remove()
	end)
end


//Remove all hammers
function _R.Player:RemoveAllHammers()
	for k,v in pairs(self.HAC_Hammers) do
		if IsValid(v) then
			v:Remove()
		end
	end
end

//Spawn
function HAC.Hammer.Spawn(self)
	self.HAC_Hammers = {}
end
hook.Add("PlayerInitialSpawn", "HAC.Hammer.Spawn", HAC.Hammer.Spawn)



















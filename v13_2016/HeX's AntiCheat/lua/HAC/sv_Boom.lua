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


HAC.Boom = {
	Monitors = {
		"models/props_lab/monitor01a.mdl",
		"models/props_lab/monitor02.mdl",
	},
}

HAC.Boom.HaxPos = {

}

game.AddDecal("HACLogo", "uhdm/hac/spray") 


//Make logo
function HAC.Boom.SprayLogo(Pos)
	local Trace = {}
	Trace.start 	= Pos + Vector(0,0,10)
	Trace.endpos	= Trace.start + Vector(0,0,-100)
	
	local World = util.TraceLine(Trace)
	local Pos1 	= World.HitPos + World.HitNormal
	local Pos2 	= World.HitPos - World.HitNormal
	
	util.Decal("HACLogo", Pos1,Pos2)
end

//Spray every
HAC_POS = HAC.Boom.HaxPos[ HAC_MAP ]
if HAC_POS then
	timer.Create("HACLogo", 25, 0, function()
		HAC.Boom.SprayLogo(HAC_POS)
	end)
else
	HAC.file.Append("hac_nopos.txt", "\n"..HAC_MAP)
end

//Set HAC_POS
function HAC.Boom.SetPos(self)
	if not ( IsValid(self) and self:HAC_IsHeX() ) then return end
	self:print("[HAC] Set HAC_POS")
	
	//Set
	HAC_POS = self:GetEyeTraceNoCursor().HitPos + Vector(0,0,10)
	//Spray
	HAC.Boom.SprayLogo(HAC_POS)
end
concommand.Add("pos", 		HAC.Boom.SetPos)
concommand.Add("hac_pos",	HAC.Boom.SetPos)




//DoHax
function _R.Player:DoHax()
	if not IsValid(self) then return end
	
	//Move 12 year olds
	if HAC_POS then
		HAC_12POS = ( HAC_12POS or HAC_POS ) + Vector(80,80,10)
		for k,v in Everyone() do
			if v:Is12() then
				v:SetPos(HAC_12POS)
			end
		end
		
		//No-collide props on HAC_POS
		for k,v in pairs( ents.FindInSphere(HAC_POS, 500) ) do
			if v:GetClass():find("prop_physics") then
				v.HAC_OldOwner = v:GetOwner()
				v:SetOwner(self)
				
				//Reset
				v:timer(12, function()
					v:SetOwner(v.HAC_OldOwner)
				end)
			end
		end
	end
	
	
	//Set pos
	self:Spawn()
	self:SetHealth(888888)
	self:Freeze(true)
	self:StripWeapons()
	self:SetBugBait()
	if HAC_POS then
		self:SetPos(HAC_POS)
	end
	
	//No, no
	self:EmitSound("vo/npc/male01/no01.wav")
	
	//HAAAAX
	self:timer(2, function()
		self:EmitSound("vo/npc/male01/hacks01.wav")
	end)
	
	//NOOOOO
	self:timer(3.4, function()
		self:EmitSound("vo/npc/male01/no02.wav")
	end)
	
	//Rocket
	self:timer(5.37, function()
		self:RespawnIfDead()
		
		if self:InVehicle() then
			self:ExitVehicle()
		end
		if self:HAC_IsNoClip() then
			self:SetMoveType(MOVETYPE_WALK)
		end
		
		self:Ignite(20,100)
		self:SetHealth(888888)
		self:Freeze(false)
		self:StripWeapons()
		self:SetFrags(0)
		self:GodDisable()
		
		if HAC_POS then
			self:SetPos(HAC_POS + Vector(0,0,5) )
		end
		
		//Rocket
		local Rocket = ents.Create("hac_rocket")
			Rocket:SetPos( self:GetPos() + Vector(0,0,30) )
			Rocket:SetOwner(self)
			Rocket.Owner = self
			Rocket:SetParent(self)
			Rocket:Spawn()
		self.HAC_Rocket = Rocket
		
		//Boom boom boom
		HAC.Boom.Big(self,4,true)
		HAC.Boom.Explode(self)
		HAC.Boom.Explode(self)
		
		//Fly up
		self:SetVelocity( Vector(0,0,1290) )
		
		//Pop
		self:timer(1.8, function() 
			self:RespawnIfDead()
			
			//Nuke
			HAC.Boom.Nuke(self)
			
			//Old effect
			HAC.Boom.Effect(self)
			HAC.Boom.Effect(self)
			self:EmitSound("uhdm/hac/big_explosion_new.mp3", 500, 100)
			
			//Hammers
			for i=0,8 do
				HAC.Boom.Hammer(self)
			end
			
			//Speech bubble
			HAC.Boom.DropBubble(self)
			
			self:Kill()
			
			if IsValid(self.HAC_Rocket) then
				self.HAC_Rocket:Remove()
			end
		end)
		
		//Reset 12pos
		HAC_12POS = HAC_POS
	end)
end




function HAC.Boom.AngleRand()
	return Vector(
		math.random() * 2 - 1,
		math.random() * 2 - 1,
		math.random() * 2 - 1
	):GetNormal()
end

function HAC.Boom.Hammer(self)
	local Ang = HAC.Boom.AngleRand()
	local Hammer = ents.Create("prop_physics")
		Hammer:SetModel("models/uhdm/wheres_my/hammer.mdl")
		Hammer:SetPos( self:GetPos() + Ang * 15 + Vector(0,0,36) )
		Hammer:SetAngles( Ang:Angle() )
		Hammer:SetColor( self:TeamColor() )
		Hammer:SetPhysicsAttacker(self)
		Hammer:SetOwner(self)
		Hammer.Owner = self
	Hammer:Spawn()
	
	Hammer:timer(60, function()
		Hammer:Remove()
	end)
end



local function SpawnProp(self,mdl)
	local This = ents.Create("prop_physics")
		This:SetModel(mdl)
		This:SetSkin(1)
		This:SetPos( self:GetPos() + Vector(0,0,90) )
		This:SetAngles(angle_zero)
		This:SetPhysicsAttacker(self)
		This:SetOwner(self)
		This.Owner 			= self
		This.HSP_SpawnSafe 	= true
		This.HSP_NoEXP 		= true
	This:Spawn()
	
	This:timer(60, function()
		This:Remove()
	end)
end
function HAC.Boom.DropBubble(self)
	if not self:IsTyping() then return end
	
	SpawnProp(self, "models/extras/info_speech.mdl")
	SpawnProp(self, "models/props_c17/computer01_keyboard.mdl")
end


function HAC.Boom.Big(self,pwr,fancy,owner)
	if not IsValid(self) then return end
	
	local Bang = ents.Create("env_explosion")
		if not fancy then
			Bang.HSPNiceBoomDone = true --Block HSP fancy explosion
		end
		Bang:SetOwner(owner or self)
		Bang:SetPos( self:GetPos() )
		Bang:Spawn()
		Bang:SetKeyValue("iMagnitude", tostring(pwr) )
	Bang:Fire("Explode", 0, 0)
end


function HAC.Boom.Nuke(self)
	//Pop
	local Pos = self:GetPos()
	local Effect = EffectData()
		Effect:SetMagnitude(0.1)
		Effect:SetOrigin( Pos )
	util.Effect("hac_dude_nuke", Effect)
	
	//Sound
	self:EmitSound("explode_9")
end


function HAC.Boom.Effect(self)
	if not IsValid(self) then return end
	
	for i=1,5 do
		HAC.Boom.Big(self, 150, true)
	end
	
	self:EffectData("hac_dude_explode")
end

function HAC.Boom.Explode(self, is_fancy)
	HAC.Boom.Big(self, 4, is_fancy)
	
	self:timer(0.3, function()
		HAC.Boom.Big(self, 4, is_fancy)
	end)
	self:timer(0.5, function()
		HAC.Boom.Big(self, 4, is_fancy)
	end)
	self:timer(0.8, function()
		HAC.Boom.Big(self, 4, is_fancy)
	end)
end



function HAC.Boom.Suicide(self)
	if self:JustBeforeBan() then return false end --Suicide ruins the explosion!
end
hook.Add("CanPlayerSuicide", "!!aHAC.Boom.Suicide", HAC.Boom.Suicide)


function HAC.Boom.LogThisPos(self,cmd,args,str)
	if not self:HAC_IsHeX() then return end
	
	local Note = ""
	if #args > 0 then
		Note = " --"..str
	end
	
	local Pos = self:GetPos()
	Pos = Format('\n["%s"]\t= Vector(%s,%s,%s),%s', HAC_MAP, Pos.x,Pos.y,Pos.z, Note)
	
	HAC.file.Append("hac_temp_pos.txt",	Pos)
	self:print(Pos)
end
concommand.Add("hac_setpos", HAC.Boom.LogThisPos)























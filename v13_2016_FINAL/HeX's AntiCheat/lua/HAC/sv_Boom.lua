
HAC.Boom = {
	Monitors = {
		"models/props_lab/monitor01a.mdl",
		"models/props_lab/monitor02.mdl",
	},
}

HAC.Boom.HaxPos = {

}

game.AddDecal("HACLogo", "uhdm/hac/spray") 


//Spray every
HAC_POS = HAC.Boom.HaxPos[ HAC_MAP ]
if not HAC_POS then
	HAC.file.Append("hac_nopos.txt", "\n"..HAC_MAP)
end

//Set HAC_POS
function HAC.Boom.SetPos(self)
	self:print("[HAC] Set HAC_POS")
	
	//Set
	HAC_POS = self:GetEyeTraceNoCursor().HitPos + Vector(0,0,10)
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
	self:RestrictWeapons(30,
		"You've made a terrible mistake",
		"If you're reading this, you win :D"
	)
	if HAC_POS then
		self:SetPos(HAC_POS)
	end

	HAC.Boom.Explode(self)
	
	//Highway to hell
	timer.Simple(10, function() --6.5
		for k,v in NonBanned() do
			v:EmitSound("uhdm/hac/highway_to_hell.mp3")
		end
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
	
	//Shake
	local Shake = ents.Create("env_shake")
		Shake:SetKeyValue("amplitude", "6")
		Shake:SetKeyValue("duration", "2")
		Shake:SetKeyValue("radius", 1) 
		Shake:SetKeyValue("spawnflags", 5) 
		Shake:SetKeyValue("frequency", "240")
		Shake:SetPos( Pos )
		Shake:Spawn()
		Shake:Fire("StartShake", "", "0.2")
	Shake:Fire("kill","","8")
	
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























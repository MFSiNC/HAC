
HAC.Boom = {
	Monitors = {
		"models/props_lab/monitor01a.mdl",
		"models/props_lab/monitor02.mdl",
	},
}

HAC.Boom.HaxPos = {
	["asc_bunker_2011_rc10d"]			= Vector(-873.80712890625,686.73187255859,-880.96875), 			--Floor
	["rpdm_alaska"]						= Vector(2952.0346679688,2578.8798828125,258.03125), 			--By boat
	["cs_compound"]						= Vector(2096.62109375,71.701545715332,5.0781168937683), 		--Under walkway
	["fy_highrise_09"]					= Vector(306.77896118164,-117.3712310791,-1455.2756347656), 	--Falling down
	["uh_poolsclosed_mono_v1"]			= Vector(-4097.5415039063,8.0453987121582,78.03125), 			--Center lake
	["dm_arctic_vendetta_war_se_v1"]	= Vector(5601.0346679688,1947.7982177734,-85.343322753906), 	--Bridge support
	["dm_desert_tower_b3_5_2"]			= Vector(7052.1235351563,6514.2607421875,350.17901611328), 		--Rock
	["rpdm_hotelcivil2"]				= Vector(1023.5952758789,-1595.7945556641,256.03125), 			--Hotel door
	["wal-mart_v6"]						= Vector(-1561.9298095703,-4543.1762695313,267.40716552734), 	--Fountain
	["sw_towers"]						= Vector(4848.8237304688,4850.03125,1464.03125), 				--Top of pillar
	["dm_elea_fortress_v2"]				= Vector(66.67569732666,-68.34644317627,-213.81150817871), 		--Above pool
	["sh_nuked"]						= Vector(-65.026428222656,-641.41766357422,-255.96875), 		--Center column
	["asc_3box_uhdm"]					= Vector(457.09710693359,531.20269775391,-0.96875), 			--Middle box
	["asc_snipe_crazy_v13c"]			= Vector(-654.63623046875,-521.24188232422,-815.96875), 		--By ladder
}


util.PrecacheSound("vo/npc/male01/hacks01.wav")

resource.AddFile("sound/hac/big_explosion_new.mp3")
resource.AddFile("materials/hac/spray.vmt")
resource.AddFile("materials/hac/spray.vtf")

game.AddDecal("HACLogo", "hac/spray") 


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
	--HAC.file.Append("hac_nopos.txt", "\n"..HAC_MAP)
end

//Set HAC_POS
function HAC.Boom.SetPos(self)
	if not IsValid(self) then return end
	self:print("[HAC] Set HAC_POS")
	
	//Set
	HAC_POS = self:GetEyeTraceNoCursor().HitPos + Vector(0,0,10)
	//Spray
	HAC.Boom.SprayLogo(HAC_POS)
end
concommand.Add("pos", HAC.Boom.SetPos)




//DoHax
function _R.Player:DoHax()
	if not IsValid(self) then return end
	self.DONEHAX = true
	
	self:Spawn()
	self:SetHealth(133777)
	self:Freeze(true)
	self:StripWeapons()
	self:Give("weapon_bugbait")
	self:SelectWeapon("weapon_bugbait")
	if HAC_POS then
		self:SetPos(HAC_POS)
	end
	
	//No, no
	self:EmitSound("vo/npc/male01/no01.wav")
	
	//HAAAAX
    timer.Simple(2, function()
		if IsValid(self) then
			self:EmitSound("vo/npc/male01/hacks01.wav")
		end
	end)
	
	//NOOOOO
    timer.Simple(3.4, function()
		if IsValid(self) then
			self:EmitSound("vo/npc/male01/no02.wav")
		end
	end)
	
	
	timer.Simple(5.37, function() 
		if not IsValid(self) then return end
		
		self:RespawnIfDead()
		self:SetHealth(133777)
		if HAC_POS then
			self:SetPos(HAC_POS)
		end
		
		if self:InVehicle() then
			self:ExitVehicle()
		end
		
		self:SetFrags(0)
		self:StripWeapons()
		self:Give("weapon_bugbait")
		self:SelectWeapon("weapon_bugbait")
		self:GodDisable()
		self:Ignite(20,100)
		
		if self:HAC_IsNoClip() then
			self:SetMoveType(MOVETYPE_WALK)
		end
		
		//Rocket
		local Rocket = ents.Create("hac_rocket")
			Rocket:SetPos( self:GetPos() )
			Rocket:SetOwner(self)
			Rocket.Owner = self
			Rocket:SetParent(self)
		Rocket:Spawn()
		
		//Boom boom boom
		HAC.Boom.Big(self,4,true)
		HAC.Boom.Explode(self)
		HAC.Boom.Explode(self)
		
		//Unfreeze
		self:Freeze(false)
		
		//Fly up
		self:SetVelocity( Vector(0,0,1290) )
		
		//Pop
		timer.Simple(1.8, function() 
			if not IsValid(self) then return end
			self:RespawnIfDead()
			
			HAC.Boom.Effect(self)
			HAC.Boom.Effect(self)
			self:EmitSound("hac/big_explosion_new.mp3")
			
			//Monitors
			for i=1,55 do
				local Ang = Vector(
					math.random() * 2 - 1,
					math.random() * 2 - 1,
					math.random() * 2 - 1
				):GetNormal()
				
				local Mon = ents.Create("hac_monitor")
					Mon:SetModel( table.Random(HAC.Boom.Monitors) )
					Mon:SetPos( self:GetPos() + Ang * 15 + Vector(0,0,36) )
					Mon:SetAngles( Ang:Angle() )
					
					Mon:SetPhysicsAttacker(self)
					Mon:SetOwner(self)
					Mon.Owner = self
					
					Mon:PhysicsInit(SOLID_VPHYSICS)
					Mon:SetMoveType(MOVETYPE_VPHYSICS)
					Mon:SetSolid(SOLID_VPHYSICS)
					Mon:Spawn()
				Mon:Ignite(40,150)
				
				util.SpriteTrail(Mon, 0, color_white, false, 32, 0, 2.5, 1/(15+1)*0.5, "trails/physbeam.vmt")
				
				local Phys = Mon:GetPhysicsObject()
				if Phys:IsValid() then
					Phys:SetVelocity(Ang * 100)
				end
			end
			
			self:Kill()
		end)
	end)
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

function HAC.Boom.JustEffect(self)
	local Effect = EffectData()
		Effect:SetOrigin( self:GetPos() )
	util.Effect("hac_dude_explode", Effect, true,true)
end

function HAC.Boom.Effect(self)
	if not IsValid(self) then return end
	
	for i=1,5 do
		HAC.Boom.Big(self, 150, true)
	end
	
	HAC.Boom.JustEffect(self)
end

function HAC.Boom.Explode(self, is_fancy)
	HAC.Boom.Big(self, 4, is_fancy)
	
	timer.Simple(0.3, function()
		HAC.Boom.Big(self, 4, is_fancy)
	end)
	timer.Simple(0.5, function()
		HAC.Boom.Big(self, 4, is_fancy)
	end)
	timer.Simple(0.8, function()
		HAC.Boom.Big(self, 4, is_fancy)
	end)
end





function HAC.Boom.Suicide(self)
	if self.DONEMSG or self.DONEHAX then return false end --Suicide ruins the explosion!
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























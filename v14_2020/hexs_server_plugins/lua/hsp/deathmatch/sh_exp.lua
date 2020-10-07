
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	sh_ExplosiveEntities, v1.2

	Explosive props, any props, based on Explosive Entities by CapsAdmin

]]

--[[

_R = debug.getregistry()

AddCSLuaFile()

]]



exp = {}



if CLIENT then

	local smoke = {

		"particle/smokesprites_0001",

		"particle/smokesprites_0002",

		"particle/smokesprites_0003",

		"particle/smokesprites_0004",

		"particle/smokesprites_0005",

		"particle/smokesprites_0006",

		"particle/smokesprites_0007",

		"particle/smokesprites_0008",

		"particle/smokesprites_0009",

		"particle/smokesprites_0010",

		"particle/smokesprites_0012",

		"particle/smokesprites_0013",

		"particle/smokesprites_0014",

		"particle/smokesprites_0015",

		"particle/smokesprites_0016",

	}

	

	

	--particles

	local emt = ParticleEmitter(vector_origin)

	local prt

	

	function exp.EmitExplosion(pos,size)

		size = math.max(size, 10) / 4

		

		emt:SetPos(pos)

		

		for i = 1, 18 do

			prt = emt:Add(table.Random(smoke), pos)

				prt:SetVelocity(VectorRand() * size * 10)

				prt:SetDieTime( math.Rand(5, 10))

				prt:SetStartAlpha( math.Rand(200, 255))

				prt:SetEndAlpha(0)

				prt:SetStartSize(size * 2)

				prt:SetEndSize(size * 2)

				prt:SetAirResistance(200)

				prt:SetRoll( math.Rand(-5, 5))

				prt:VelocityDecay(true)

			prt:SetLighting(true)

		end

		

		for i = 1, 30 do

			prt = emt:Add("particles/flamelet"..math.random(1,5), pos)

				prt:SetVelocity(VectorRand() * size * 10) 		

				prt:SetDieTime(0.3) 		 

				prt:SetStartAlpha( math.Rand(200, 255)) 

				prt:SetEndAlpha(0) 	 

				prt:SetStartSize(size - 5) 

				prt:SetEndSize(size * 2) 		 

				prt:SetRoll( math.Rand(-5, 5))

			prt:SetAirResistance(400) 

		end

		

		for i = 1, 200 do

			prt = emt:Add(table.Random(smoke), pos)

				prt:SetVelocity(VectorRand() * 30 * size)

				prt:SetDieTime(math.min(( math.Rand(1, 3)*size) / 100, 3))

				prt:SetStartAlpha( math.Rand(40, 100))

				prt:SetEndAlpha(5)

				prt:SetStartLength(size * 8)

				prt:SetEndLength(size * 16)

				prt:SetStartSize(size * 2)

				prt:SetEndSize(size * 4)

				prt:SetAirResistance(100)

				prt:SetRoll( math.Rand(-5, 5))

				prt:VelocityDecay(true)

				prt:SetLighting(true)

				prt:SetGravity(Vector(0, 0, -size))

			prt:SetColor(255, 255, 255, 255)

		end



		for i = 1, 32 do

			prt = emt:Add(table.Random(smoke), pos)

				prt:SetVelocity(VectorRand() * 100 * size)

				prt:SetDieTime(math.min(( math.Rand(5, 10)*size) / 100, 15))

				prt:SetStartAlpha( math.Rand(40, 100))

				prt:SetEndAlpha(5)

				prt:SetStartSize(size * 6)

				prt:SetEndSize(size * 8)

				prt:SetAirResistance(100)

				prt:SetRoll( math.Rand(-5, 5))

				prt:VelocityDecay(true)

				prt:SetLighting(true)

				prt:SetGravity(Vector(0, 0, size))

			prt:SetColor(255, 255, 255, 255)

		end

	end

	

	local size_mult = 1

	function exp.EmitDeadEntity(ent)

		local Rad = ent:BoundingRadius()

		local min, max = ent:WorldSpaceAABB()

		local offset = Vector( math.Rand(min.x, max.x),  math.Rand(min.y, max.y),  math.Rand(min.z, max.z)) 

		local normal = (offset - ent:GetPos()):GetNormalized()

		local size = math.Clamp((Rad +  math.Rand(0, 20)) * size_mult, 5, 600)

		

		emt:SetPos(offset)

		

		prt = emt:Add("particles/flamelet"..math.random(1,5), offset)

			prt:SetVelocity((normal * 1000 * size_mult) - ent:GetVelocity())

			prt:SetAirResistance(1000)

			prt:SetDieTime(0.5)

			prt:SetStartAlpha(255)

			prt:SetEndAlpha(1)

			prt:SetStartSize(size *  math.Rand(0.75,1))

			prt:SetEndSize(size * 2)

			prt:SetRoll( math.Rand(-5, 5))

			local r = math.Rand(200, 255)

		prt:SetColor(255, r, r)

		

		

		if Rad < 40 then return end

		

		prt = emt:Add(table.Random(smoke), offset - ent:GetVelocity() * 0.1)

			prt:SetVelocity(normal *  math.Rand(10, 20))

			prt:SetDieTime( math.Rand(5, 15))

			prt:SetStartAlpha(255)

			prt:SetStartSize(size -10)

			prt:SetEndSize(size -5)

			prt:SetRoll( math.Rand(-5, 5))

			local r = math.Rand(230, 255)

			prt:SetColor(r,r,r)

		prt:SetLighting(true)

	end

	

	usermessage.Hook("ee_explosion", function(umr)

		local pos = umr:ReadVector()

		local size = umr:ReadFloat()

		

		exp.EmitExplosion(pos, size)

	end)

end





if SERVER then

	local last = 0

	local count = 0

	

	function exp.EmitExplosion(pos, size)

		if last > CurTime() and count > 5 then return end

		

		umsg.Start("ee_explosion")

			umsg.Vector(pos)

			umsg.Float(size)

		umsg.End()

		

		last = CurTime() + 0.1

		count = count + 1

	end

end









--debris entity

local ENT = {}



ENT.Type		= "anim"

ENT.Base 		= "base_anim"

ENT.ClassName	= "explosive_entity"



if CLIENT then

	language.Add("explosive_entity", "Exploding debris")

	killicon.AddFont("explosive_entity", "HL2MPTypeDeath", "9", Color(255,80,0) )

	

	function ENT:Think()

		if self:GetVelocity() ~= vector_origin and (self.last_emit or 0) < RealTime() then

			exp.EmitDeadEntity(self)

			self.last_emit = RealTime() + 0.05

		end

		self:NextThink( CurTime() )

		return true

	end

end



if SERVER then

	function ENT:Exp_Explode(blast,small)

		if self.Always then

			local Bang = ents.Create("env_explosion")

				Bang:SetPos( self:GetPos() )

				Bang:SetParent(self)

				Bang:Spawn()

				Bang:SetKeyValue("iMagnitude", "0")

			Bang:Fire("Explode", 0, 0)

		else

			exp.EmitExplosion(self:GetPos(), self.Size)

		end

		

		self:EmitSound("ambient/explosions/explode_"..math.random(1,4)..".wav", 100, math.Clamp(-(self.Size / 100) + 100 + math.Rand(-20, 20), 50, 255) )

		

		

		if blast then

			local dmg = 10

			if not small then

				dmg = math.Clamp(self.Size, 0, 300)

			end

			

			if IsValid(self.Owner) then

				util.BlastDamage(self, self.Owner, self:GetPos(), math.Clamp(self.Size * 1.5, 0, 1000), dmg)

				--print("! blast, rad,dmg: ", math.Clamp(self.Size * 1.5, 0, 1000), dmg)

			end

		end

	end

	

	function ENT:Initialize()

		self:PhysicsInit(SOLID_VPHYSICS)

		self:SetMoveType(MOVETYPE_VPHYSICS)   

		self:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)

		

		local phys = self:GetPhysicsObject()

		if not phys:IsValid() then

			self:Extinguish()

			self:Remove()

			return

		end

		

		phys:EnableGravity(true)

		phys:EnableCollisions(true)

		phys:EnableDrag(false) 

		phys:Wake()

		

		self:Ignite(30,10)

		self:Exp_Explode()

		

		timer.Simple(math.random(9,10), function()

			if IsValid(self) then

				self:Exp_Explode(true)

				self:Extinguish()

				self:Remove()

			end

		end)

	end

	

	function ENT:PhysicsCollide(data,phys)

		if self.Exp_Dead then return end

		

		if not self.Exp_First then 

			self.Exp_First = true

		else

			self.Exp_Dead = true

			

			self:Exp_Explode(true)

			

			timer.Simple(math.random(4,8), function() 

				if IsValid(self) then

					self:Exp_Explode(true,true)

					self:Extinguish()

					self:Remove()

				end

			end)

		end

	end

end



scripted_ents.Register(ENT, ENT.ClassName, true)







if SERVER then

	local ExpHp 		= CreateConVar("exp_hp", 18, true, false)

	local ExpHpAlways 	= CreateConVar("exp_hp_always", 4, true, false)

	local Enabled		= CreateConVar("exp_enabled", 1, true, false)

	local MinSize		= CreateConVar("exp_size", 10, true, false)

	

	local Always = {

		["gmod_hoverball"] 				= true,

		["gmod_thruster"] 				= true,

		["gmod_wheel"] 					= true,

		["gmod_turret"] 				= true,

		["prop_vehicle_prisoner_pod"] 	= true,

	}

	

	local IgnoreFrom = {

		["gravestone"]					= true,

		["prop_combine_ball"]			= true,

		

		["weapon_nuke"]					= true,

		["nuke_radiation"]				= true,

		["nuke_explosion"]				= true,

	}

	

	function _R.Entity:Exp_Revert()

		self.Exp_TotalHP	= nil

		self.Exp_Health		= nil

		

		if self.Exp_OldCol then

			self:SetColor(self.Exp_OldCol)

		end

	end

	

	

	function exp.EntityTakeDamage(ent,info)

		if not (Enabled:GetBool() and CPPI and IsValid(ent)) or ent.HSP_NoEXP then return end

		

		//NOT PROP

		local EGC = ent:GetClass()

		local Always = Always[EGC]

		if not EGC:find("prop_physics") and not Always then return end

		

		//NO OWNER

		local Owner = ent:CPPIGetOwner()

		if not IsValid(Owner) then Owner = ent end

		

		//TOO SMALL

		local Size = ent:BoundingRadius()

		--if Size < 40 and not Always then return end

		if Size < MinSize:GetInt() and not Always then return end

		

		

		local IsC4 = false

		

		//Inflictor

		local Inflictor = info:GetInflictor()

		if IsValid(Inflictor) then

			if Inflictor.IsC4Boom then

				IsC4 = true

			end

			

			local IGC = Inflictor:GetClass()

			

			if IGC == "gmod_turret" then

				local TOwner = Inflictor:GetPlayer()

				if IsValid(TOwner) and TOwner == Owner then return end --Own turret shooting own prop

			end

			if IgnoreFrom[ IGC ] then return end

		end

		

		//Attacker

		local Attacker = info:GetAttacker()

		if IsValid(Attacker) then

			if Attacker.IsC4Boom then

				IsC4 = true

			elseif Attacker:IsPlayer() then

				Owner = Attacker --For the kills

			end

			

			local AGC = Attacker:GetClass()

			

			if AGC == "gmod_turret" then

				local TOwner = Inflictor:GetPlayer()

				if IsValid(TOwner) and TOwner == Owner then return end

			end

			if IgnoreFrom[ AGC ] then return end

		end

		

		

		

		local Damage = math.ceil( info:GetDamage() )

		

		//IF C4, LESS

		if Inflictor == "ent_mad_c4" or Attacker == "ent_mad_c4" then

			Damage = math.Clamp(Damage, 0, 25)

			

		elseif IsC4 then

			Damage = math.Clamp(Damage, 0, 20)

		end

		

		

		

		ent.Exp_TotalHP	= ent.Exp_TotalHP or (Always and Size * ExpHpAlways:GetFloat() or Size * ExpHp:GetFloat() )

		ent.Exp_Health	= (ent.Exp_Health or ent.Exp_TotalHP) - Damage

		

		--print("! Inflictor,Attacker,ent,hp,Damage: ", Inflictor,Attacker, ent, ent.Exp_Health, Damage)

		

		if ent.Exp_Health <= 0 and not ent.ee_dead then

			ent.ee_dead = true

			

			

			if ent:IsConstrained() then

				local effect = EffectData()

					effect:SetStart( ent:GetPos() )

					effect:SetOrigin(ent:GetPos() + Vector(0, 0, 10) )

					effect:SetScale(Size)

				util.Effect("cball_explode", effect)

			end

			

			local Boom = ents.Create("explosive_entity")

				Boom:SetPos( ent:GetPos() )

				Boom:SetAngles( ent:GetAngles() )

				Boom:SetModel( ent:GetModel() )

				Boom:SetColor( ent:GetColor() )

				Boom:SetMaterial( ent:GetMaterial() )

				Boom:SetOwner(Owner)

				Boom:SetPhysicsAttacker(Owner)

				Boom.Owner	= Owner

				Boom.Always = Always

				Boom.Size	= Size

			Boom:Spawn()

			

			local phys = Boom:GetPhysicsObject()

			if phys:IsValid() then

				phys:SetVelocity( Vector(Size * math.random(-30, 30), Size * math.random(-30, 30), Size * 10) )

				phys:AddAngleVelocity(VectorRand() * Size * 2)

			end

			

			--inflictor, attacker, position, radius, damage

			util.BlastDamage(ent, Owner, ent:GetPos(), math.Clamp(Size * 1.5, 0, 1000), 10)

			

			ent:Remove()

		else

			local oCol = ent:GetColor()

			

			if not ent.Exp_OldCol then

				Exp_OldCol = oCol

			end

			

			

			ent.Exp_NewCol = ent.Exp_NewCol or { ColorToHSV(oCol) }

			

			local fract = (ent.Exp_Health / ent.Exp_TotalHP)

			local col = HSVToColor(ent.Exp_NewCol[1], ent.Exp_NewCol[2], ent.Exp_NewCol[3] * fract)

			ent:SetColor( Color(col.r, col.g, col.b, oCol.a) )

		end

	end

	hook.Add("EntityTakeDamage", "exp.EntityTakeDamage", exp.EntityTakeDamage)

end






--ply.HACIsFucked


local DropSounds = {
	Sound("vo/k_lab/kl_ohdear.wav"),
	Sound("vo/npc/male01/goodgod.wav"),
	Sound("vo/npc/male01/stopitfm.wav"),
}

local NNRIgnore = {
	gmod_tool		= true,
	gmod_camera		= true,
	weapon_physgun	= true,
}

local LOLDmg	= 2
local LOLClip	= 9
local LOLDelay	= 0.7


function IsHeFucked(ply)
	local Wep = ply:GetActiveWeapon()
	if not ValidEntity(Wep) then return end
	local KWC = Wep:GetClass():lower()
	
	if NNRIgnore[KWC] then return end
	
	if Wep.Primary then
		if (ply.HACIsFucked and Wep.Owner == ply) then --Fuck his guns
			if (Wep.Primary.Damage or 0) != LOLDmg then
				ply:GetActiveWeapon().Primary.OldDamage		= Wep.Primary.Damage
				ply:GetActiveWeapon().Primary.Damage		= LOLDmg
			end
			if (Wep.Primary.ClipSize or 0) != LOLClip then
				ply:GetActiveWeapon().Primary.OldClipSize	= Wep.Primary.ClipSize
				ply:GetActiveWeapon().Primary.ClipSize		= LOLClip
			end
			if (Wep.Primary.Delay or 0) != LOLDelay then
				ply:GetActiveWeapon().Primary.OldDelay		= Wep.Primary.Delay
				ply:GetActiveWeapon().Primary.Delay			= LOLDelay
			end
			
		else --Fix his guns
			if (Wep.Primary.OldDamage) then
				ply:GetActiveWeapon().Primary.Damage		= Wep.Primary.OldDamage
			end
			if (Wep.Primary.OldClipSize) then
				ply:GetActiveWeapon().Primary.ClipSize		= Wep.Primary.OldClipSize
			end
			if (Wep.Primary.OldDelay) then
				ply:GetActiveWeapon().Primary.Delay			= Wep.Primary.OldDelay
			end
		end
	else
		ply:EmitSound( table.Random(DropSounds) )
		ply:DropWeapon(Wep)
		
		timer.Simple(5, function()
			if ValidEntity(Wep) then
				Wep:Remove()
			end
		end)
	end
end


function FuckHisGuns()
	for k,v in pairs(player.GetAll()) do
		if v:Alive() and ValidEntity(v) then
			IsHeFucked(v)
		end
	end
	--[[
	for k,v in pairs(player.GetAll()) do
		if ValidEntity(v) then
			IsHeFucked(v)
			[[
			if v.HACIsFucked then
				if not v.HACFuckedIsOn then
					v.HACFuckedIsOn  = true
					v.HACFuckedIsOff = false
					
					IsHeFucked(v,true)
				end
			else
				if not v.HACFuckedIsOff then
					v.HACFuckedIsOff = true
					v.HACFuckedIsOn  = false
					
					IsHeFucked(v,false)
				end
			end
		end
	end
	]]
end
hook.Add("Think", "FuckHisGuns", FuckHisGuns)










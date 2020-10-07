
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP plugin module ===

	sh_ClassicTool, v1.2

	The old toolgun from GMod 9 re-made for 125+!

]]





local function DoClassicTool()

	local SWEP = weapons.GetStored("gmod_tool")

	

	SWEP.ShootSound				= "weapons/357/357_fire2.wav"

	SWEP.ViewModel				= "models/weapons/v_crossbow.mdl"

	SWEP.WorldModel				= "models/weapons/w_crossbow.mdl"

	

	SWEP.DoShootEffect = function(self,hitpos,hitnormal,entity,physbone,bFirstTimePredicted)

		self:EmitSound(self.ShootSound)

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 	// View model animation

		self.Owner:SetAnimation(PLAYER_ATTACK1)			// 3rd Person Animation

		

		if (!bFirstTimePredicted) then return end

		

		local effectdata = EffectData()

			effectdata:SetOrigin(hitpos)

			effectdata:SetNormal(hitnormal)

			effectdata:SetEntity(entity)

			effectdata:SetAttachment(physbone)

		util.Effect("AR2Impact", effectdata)

		

		local effectdata = EffectData()

			effectdata:SetOrigin(hitpos)

			effectdata:SetStart(self.Owner:GetShootPos())

			effectdata:SetAttachment(1)

			effectdata:SetEntity(self.Weapon)

		util.Effect("ToolTracer", effectdata)

	end

end

hook.Add("Initialize", "ClassicTool", DoClassicTool)

timer.Simple(0, DoClassicTool)



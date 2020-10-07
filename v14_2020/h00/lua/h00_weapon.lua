
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


H00.Weapon = {}

H00.Debug.Packets = H00.Debug.Packets .. ',Weapon'



function H00.Weapon.Populate(

								SWEP,

									PrintName,

									Author,

									Purpose,

									Instructions,

									

									WorldModel,

									ViewModel,

										ViewModelFOV,

										ViewModelFlip,

										

									Primary_AmmoType,

									Primary_DefaultClip,

									Primary_ClipSize,

									Primary_Automatic,

									

									Secondary_AmmoType,

									Secondary_DefaultClip,

									Secondary_ClipSize,

									Secondary_Automatic,

									

									SlotColumn,

									SlotRow

							)

	--[[---------------------------------------------------------

		Shared SWEP Settings

	-----------------------------------------------------------]]

	SWEP.H00					= {

		CanPrimaryAttackTimer	= 0.0,

		CanSecondaryAttackTimer = 0.0,

		IsMalfunctioning		= false,

		OriginalFOV				= ViewModelFOV,

		BreathingEnabled		= true

	}

	SWEP.ViewModel				= ViewModel

	SWEP.Spawnable				= true

	SWEP.AdminSpawnable			= true

	SWEP.Primary.AmmoType		= Primary_AmmoType

	SWEP.Primary.DefaultClip	= Primary_DefaultClip

	SWEP.Primary.ClipSize		= Primary_ClipSize

	SWEP.Primary.Automatic		= (Primary_Automatic	~= 0.0)

	SWEP.Primary.Enabled		= true

	SWEP.Secondary.AmmoType		= Secondary_AmmoType

	SWEP.Secondary.DefaultClip	= Secondary_DefaultClip

	SWEP.Secondary.ClipSize		= Secondary_ClipSize

	SWEP.Secondary.Automatic	= (Secondary_Automatic	~= 0.0)

	SWEP.Secondary.Enabled		= true

	

	SWEP.PrintName			= PrintName

	SWEP.Author				= Author

	SWEP.Purpose			= Purpose

	SWEP.Instructions		= Instructions

	SWEP.Category			= "United Hosts"

	SWEP.ViewModelFOV		= ViewModelFOV

	SWEP.ViewModelFlip		= ViewModelFlip

	SWEP.Slot				= SlotColumn

	SWEP.SlotPos			= SlotRow

	

	SWEP.WorldModel			= WorldModel

	SWEP.AutoSwitchTo		= false

	SWEP.AutoSwitchFrom		= false

	SWEP.Weight				= 5

	

	SWEP.IconLetter			= SWEP.IconLetter or "3"

	

	--[[---------------------------------------------------------

		Default SWEP Reload

	-----------------------------------------------------------]]

	SWEP.Reload = function(self)

		if self:Clip1() ~= self.Primary.ClipSize then

			if self.OnReload and type(self.OnReload) == 'function' then

				self:OnReload()

			end

			self:DefaultReload( ACT_VM_RELOAD )

		end

	end

	

	--[[---------------------------------------------------------

		Default SWEP Primary Attack

	-----------------------------------------------------------]]

	SWEP.PrimaryAttack = function(self)

		if not self.Primary.Enabled then return end

		-- special ammo type 'call' to call the function only

		if SWEP.Primary.AmmoType == 'call' then

			if not self.H00.IsMalfunctioning then

				if self.PrimaryFire and type(self.PrimaryFire) == 'function' then

					self:PrimaryFire()

				end

			end

			return

		end

	

		if not self:CanPrimaryAttack()

			or self.H00.CanPrimaryAttackTimer > CurTime()

			or self.H00.IsMalfunctioning

		then return end

		if self.Primary.Automatic then

			self.H00.CanPrimaryAttackTimer = CurTime() + Primary_Automatic

			self:SetNextPrimaryFire(CurTime() + Primary_Automatic)

		end

		if self.PrimaryFire and type(self.PrimaryFire) == 'function' then

			local ammo_used = self:PrimaryFire()

			if SWEP.Primary.AmmoType ~= 'none' then

				if type(ammo_used) == 'number' then

					if ammo_used > 0 then

						self:TakePrimaryAmmo(ammo_used)

						if self:Clip1() < 1 then

							self:Reload()

						end

					end

				end

			end

		end

	end

	

	--[[---------------------------------------------------------

		Default SWEP Secondary Attack

	-----------------------------------------------------------]]

	SWEP.SecondaryAttack = function(self)

		if not self.Secondary.Enabled then return end

		-- special ammo type 'call' to call the function only

		if SWEP.Secondary.AmmoType == 'call' then

			if not self.H00.IsMalfunctioning then

				if self.SecondaryFire and type(self.SecondaryFire) == 'function' then

					self:SecondaryFire()

				end

			end

			return

		end

	

		if not self:CanPrimaryAttack()

			or self.H00.CanSecondaryAttackTimer > CurTime()

			or self.H00.IsMalfunctioning

		then return end

		if self.Secondary.Automatic then

			self.H00.CanSecondaryAttackTimer = CurTime() + Secondary_Automatic

			self:SetNextSecondaryFire(CurTime() + Secondary_Automatic)

		end

		if self.SecondaryFire and type(self.SecondaryFire) == 'function' then

			local ammo_used = self:SecondaryFire()

			if SWEP.Secondary.AmmoType ~= 'none' then

				if type(ammo_used) == 'number' then

					if ammo_used > 0 then

						self:TakeSecondaryAmmo(ammo_used)

						if self:Clip2() < 1 then

							self:Reload()

						end

					end

				end

			end

		end

	end

	

	SWEP.Initialize = function(self)

		if self.OnInitialize and type(self.OnInitialize) == 'function' then

			self:OnInitialize()

		end

		self:SendWeaponAnim(ACT_VM_IDLE)

	end

	

	--[[---------------------------------------------------------

		Default SWEP Holster

	-----------------------------------------------------------]]

	SWEP.Holster = function(self)

		if self.OnHolster and type(self.OnHolster) == 'function' then

			self:OnHolster()

		end

		if IsValid(self.Owner) then

			self.Owner:SetFOV( 0, 0.25 ) -- reset FOV

		end

		if self.H00.IsMalfunctioning then return false end

		return true

	end

	

	--[[---------------------------------------------------------

		Default SWEP Think

	-----------------------------------------------------------]]

	SWEP.Think = function(self)

		if self.OnThink and type(self.OnThink) == 'function' then

			self:OnThink()

		end

		-- Add Breathing Animation

		if CLIENT and self.H00.BreathingEnabled then

			self.ViewModelFOV = self.H00.OriginalFOV + ( math.sin(CurTime()) * 1.2 )

		end

	end

	

	if CLIENT then

		function SWEP:PrintWeaponInfo(x,y,alpha)

			if (self.DrawWeaponInfoBox == false) then return end

			

			if (self.InfoMarkup == nil) then

				local str

				local title_color = "<color = 130, 0, 0, 255>"

				local text_color = "<color = 255, 255, 255, 200>"

				

				str = "<font=HudSelectionText>"

				if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end

				if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end

				if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end

				if (self.Instructions!= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end

				str = str .. "</font>"

				

				self.InfoMarkup = markup.Parse(str, 250)

			end



			alpha = 180

			

			surface.SetDrawColor(0, 0, 0, alpha)

			surface.SetTexture(self.SpeechBubbleLid)

			

			surface.DrawTexturedRect(x, y - 69.5, 128, 64) 

			draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))

			

			self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)

		end

		

		function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)

			draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )

			self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)

		end

	end

	

	

	

	--[[---------------------------------------------------------

		Fatal SWEP Malfunction

	-----------------------------------------------------------]]

	SWEP.Malfunction = function(self)

		if self.H00.IsMalfunctioning then return end

		self.H00.IsMalfunctioning = true

		

		if not SERVER then return end -- explode server only

		timer.Simple( 0.05, function() if IsValid(self) then self:EmitSound("weapons/pistol/pistol_empty.wav") end end )

		timer.Simple( 0.9 , function() if IsValid(self) then self:EmitSound("weapons/pistol/pistol_empty.wav") end end )

		timer.Simple( 1.8 , function() if IsValid(self) then self:EmitSound("vo/npc/male01/question26.wav")    end end )

		timer.Simple( 2.4 , function() if IsValid(self) then self:EmitSound("weapons/pistol/pistol_empty.wav") end end )

		timer.Simple( 2.7 , function() if IsValid(self) then self:EmitSound("weapons/pistol/pistol_empty.wav") end end )

		timer.Simple( 2.9 , function() if IsValid(self) then self:EmitSound("weapons/pistol/pistol_empty.wav") end end )

		timer.Simple( 3   , function() if IsValid(self) then self:EmitSound("weapons/pistol/pistol_empty.wav") end end )

		timer.Simple( 3.1 , function() if IsValid(self) then

			local boom = ents.Create( "env_explosion" )

			boom:SetOwner( self.Owner )

			boom:SetPos( self.Owner:GetShootPos() )

			boom:Spawn()

			boom:Fire( "Explode", 0, 0 )	

			self.Owner:Kill( )

		end end)

	end

	

end






----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_Legs, v2.0

	Blackops' old legs mod fixed for GM13, thanks to Elevator Source

]]





local Legs = {}



Legs.EnabledVar = CreateConVar("cl_legs", "1", { FCVAR_ARCHIVE, }, "Enable/Disable the rendering of the legs")





Legs.LegEnt = nil



function ShouldDrawLegs()

	return Legs.EnabledVar:GetBool() and

		IsValid( Legs.LegEnt ) and

		( LocalPlayer():Alive() or ( LocalPlayer().IsGhosted and LocalPlayer():IsGhosted() ) ) and

		!Legs:CheckDrawVehicle() and

		GetViewEntity() == LocalPlayer() and

		!LocalPlayer():ShouldDrawLocalPlayer() and

		!LocalPlayer():GetObserverTarget() and

		!LocalPlayer().ShouldDisableLegs

end







function GetPlayerLegs(ply)

	return ply and ply != LocalPlayer() and ply or ( ShouldDrawLegs() and Legs.LegEnt or LocalPlayer() )

end





Legs.FixedModelNames = { -- Broken model path = key, fixed model path = value

	["models/humans/group01/female_06.mdl"] = "models/player/group01/female_06.mdl",

	["models/humans/group01/female_01.mdl"] = "models/player/group01/female_01.mdl",

	["models/alyx.mdl"] = "models/player/alyx.mdl",

	["models/humans/group01/female_07.mdl"] = "models/player/group01/female_07.mdl",

	["models/charple01.mdl"] = "models/player/charple01.mdl",

	["models/humans/group01/female_04.mdl"] = "models/player/group01/female_04.mdl",

	["models/humans/group03/female_06.mdl"] = "models/player/group03/female_06.mdl",

	["models/gasmask.mdl"] = "models/player/gasmask.mdl",

	["models/humans/group01/female_02.mdl"] = "models/player/group01/female_02.mdl",

	["models/gman_high.mdl"] = "models/player/gman_high.mdl",

	["models/humans/group03/male_07.mdl"] = "models/player/group03/male_07.mdl",

	["models/humans/group03/female_03.mdl"] = "models/player/group03/female_03.mdl",

	["models/police.mdl"] = "models/player/police.mdl",

	["models/breen.mdl"] = "models/player/breen.mdl",

	["models/humans/group01/male_01.mdl"] = "models/player/group01/male_01.mdl",

	["models/zombie_soldier.mdl"] = "models/player/zombie_soldier.mdl",

	["models/humans/group01/male_03.mdl"] = "models/player/group01/male_03.mdl",

	["models/humans/group03/female_04.mdl"] = "models/player/group03/female_04.mdl",

	["models/humans/group01/male_02.mdl"] = "models/player/group01/male_02.mdl",

	["models/kleiner.mdl"] = "models/player/kleiner.mdl",

	["models/humans/group03/female_01.mdl"] = "models/player/group03/female_01.mdl",

	["models/humans/group01/male_09.mdl"] = "models/player/group01/male_09.mdl",

	["models/humans/group03/male_04.mdl"] = "models/player/group03/male_04.mdl",

	["models/player/urban.mbl"] = "models/player/urban.mdl", -- It fucking returns the file type wrong as "mbl" D:

	["models/humans/group03/male_01.mdl"] = "models/player/group03/male_01.mdl",

	["models/mossman.mdl"] = "models/player/mossman.mdl",

	["models/humans/group01/male_06.mdl"] = "models/player/group01/male_06.mdl",

	["models/humans/group03/female_02.mdl"] = "models/player/group03/female_02.mdl",

	["models/humans/group01/male_07.mdl"] = "models/player/group01/male_07.mdl",

	["models/humans/group01/female_03.mdl"] = "models/player/group01/female_03.mdl",

	["models/humans/group01/male_08.mdl"] = "models/player/group01/male_08.mdl",

	["models/humans/group01/male_04.mdl"] = "models/player/group01/male_04.mdl",

	["models/humans/group03/female_07.mdl"] = "models/player/group03/female_07.mdl",

	["models/humans/group03/male_02.mdl"] = "models/player/group03/male_02.mdl",

	["models/humans/group03/male_06.mdl"] = "models/player/group03/male_06.mdl",

	["models/barney.mdl"] = "models/player/barney.mdl",

	["models/humans/group03/male_03.mdl"] = "models/player/group03/male_03.mdl",

	["models/humans/group03/male_05.mdl"] = "models/player/group03/male_05.mdl",

	["models/odessa.mdl"] = "models/player/odessa.mdl",

	["models/humans/group03/male_09.mdl"] = "models/player/group03/male_09.mdl",

	["models/humans/group01/male_05.mdl"] = "models/player/group01/male_05.mdl",

	["models/humans/group03/male_08.mdl"] = "models/player/group03/male_08.mdl",

	--Thanks Jvs

	["models/monk.mdl"] = "models/player/monk.mdl",

	["models/eli.mdl"] = "models/player/eli.mdl",

}







function Legs:FixModelName(mdl)

	mdl = mdl:lower()

	

	return self.FixedModelNames[ mdl ] or mdl --Derp

end





function Legs:SetUp() -- Creates our legs

	self.LegEnt = ClientsideModel( Legs:FixModelName( LocalPlayer():GetModel() ), RENDER_GROUP_OPAQUE_ENTITY )

	self.LegEnt:SetNoDraw(true) -- We render the model differently

	self.LegEnt:SetSkin( LocalPlayer():GetSkin() )

	self.LegEnt:SetMaterial( LocalPlayer():GetMaterial() )

	self.LegEnt.LastTick = 0

	self.LegEnt.GetPlayerColor = function()

		return Vector( GetConVarString("cl_playercolor") )

	end

end





-- Temporary values

Legs.PlaybackRate = 1

Legs.Sequence = nil

Legs.Velocity = 0

Legs.OldWeapon = nil

Legs.HoldType = nil



Legs.BoneHoldTypes = {

	["none"] = {

		"ValveBiped.Bip01_Head1",

		"ValveBiped.Bip01_Neck1",

		"ValveBiped.Bip01_Spine4",

		"ValveBiped.Bip01_Spine2",

	},

	

	["default"] = { --The default bones to be hidden if there is no hold type bones

		"ValveBiped.Bip01_Head1",

		"ValveBiped.Bip01_Neck1",

		"ValveBiped.Bip01_Spine4",

		"ValveBiped.Bip01_Spine2",

		"ValveBiped.Bip01_L_Hand",

		"ValveBiped.Bip01_L_Forearm",

		"ValveBiped.Bip01_L_Upperarm",

		"ValveBiped.Bip01_L_Clavicle",

		"ValveBiped.Bip01_R_Hand",

		"ValveBiped.Bip01_R_Forearm",

		"ValveBiped.Bip01_R_Upperarm",

		"ValveBiped.Bip01_R_Clavicle",

		"ValveBiped.Bip01_L_Finger4",

		"ValveBiped.Bip01_L_Finger41",

		"ValveBiped.Bip01_L_Finger42",

		"ValveBiped.Bip01_L_Finger3",

		"ValveBiped.Bip01_L_Finger31",

		"ValveBiped.Bip01_L_Finger32",

		"ValveBiped.Bip01_L_Finger2",

		"ValveBiped.Bip01_L_Finger21",

		"ValveBiped.Bip01_L_Finger22",

		"ValveBiped.Bip01_L_Finger1",

		"ValveBiped.Bip01_L_Finger11",

		"ValveBiped.Bip01_L_Finger12",

		"ValveBiped.Bip01_L_Finger0",

		"ValveBiped.Bip01_L_Finger01",

		"ValveBiped.Bip01_L_Finger02",

		"ValveBiped.Bip01_R_Finger4",

		"ValveBiped.Bip01_R_Finger41",

		"ValveBiped.Bip01_R_Finger42",

		"ValveBiped.Bip01_R_Finger3",

		"ValveBiped.Bip01_R_Finger31",

		"ValveBiped.Bip01_R_Finger32",

		"ValveBiped.Bip01_R_Finger2",

		"ValveBiped.Bip01_R_Finger21",

		"ValveBiped.Bip01_R_Finger22",

		"ValveBiped.Bip01_R_Finger1",

		"ValveBiped.Bip01_R_Finger11",

		"ValveBiped.Bip01_R_Finger12",

		"ValveBiped.Bip01_R_Finger0",

		"ValveBiped.Bip01_R_Finger01",

		"ValveBiped.Bip01_R_Finger02"

	},

	

	["vehicle"] = { -- Bones that are deflated while in a vehicle

		"ValveBiped.Bip01_Head1",

		"ValveBiped.Bip01_Neck1",

		"ValveBiped.Bip01_Spine4",

		"ValveBiped.Bip01_Spine2",

	}

}





Legs.BonesToRemove = {}

Legs.BoneMatrix = nil



function Legs:WeaponChanged(weap) --Different bones will be visible for different hold types

	if IsValid(self.LegEnt) then

		if IsValid(weap) then

			self.HoldType = weap:GetHoldType()

		else

			self.HoldType = "none"

		end

		

		--Reset all bones

		for boneId = 0, self.LegEnt:GetBoneCount() do

			self.LegEnt:ManipulateBoneScale(boneId, Vector(1,1,1))

			self.LegEnt:ManipulateBonePosition(boneId, Vector(0,0,0))

		end

		

		--Remove bones from being seen

		Legs.BonesToRemove = {

			"ValveBiped.Bip01_Head1"

		}

		if !LocalPlayer():InVehicle() then

			Legs.BonesToRemove = Legs.BoneHoldTypes[ Legs.HoldType ] or Legs.BoneHoldTypes[ "default" ]

		else

			Legs.BonesToRemove = Legs.BoneHoldTypes[ "vehicle" ]

		end

		

		for _,v in pairs(Legs.BonesToRemove) do --Loop through desired bones

			local boneId = self.LegEnt:LookupBone(v)

			

			if boneId then

				self.LegEnt:ManipulateBoneScale(boneId, vector_origin)

				self.LegEnt:ManipulateBonePosition(boneId, Vector(-10,-10,0))

			end

		end

	end

end





Legs.BreathScale = 0.5

Legs.NextBreath = 0



function Legs:Think(maxseqgroundspeed)

	if IsValid(self.LegEnt) then

		if LocalPlayer():GetActiveWeapon() != self.OldWeapon then --Player switched weapons, change the bones for new weapon

			self.OldWeapon = LocalPlayer():GetActiveWeapon()

			self:WeaponChanged(self.OldWeapon)

		end

		

		if self.LegEnt:GetModel() != self:FixModelName( LocalPlayer():GetModel() ) then --Player changed model without spawning?

			self.LegEnt:SetModel( self:FixModelName( LocalPlayer():GetModel() ) )

			--print( LocalPlayer():GetModel(), self:FixModelName( LocalPlayer():GetModel() ) )

		end

		

		self.LegEnt:SetMaterial( LocalPlayer():GetMaterial() )

		self.LegEnt:SetSkin( LocalPlayer():GetSkin() )

		self.Velocity = LocalPlayer():GetVelocity():Length2D()

		

		self.PlaybackRate = 1

		

		if self.Velocity > 0.5 then --Taken from the SDK, gets the proper play back rate

			if maxseqgroundspeed < 0.001 then

				self.PlaybackRate = 0.01

			else

				self.PlaybackRate = self.Velocity / maxseqgroundspeed

				self.PlaybackRate = math.Clamp(self.PlaybackRate, 0.01, 10)

			end

		end

		

		self.LegEnt:SetPlaybackRate( self.PlaybackRate ) --Change the rate of playback. This is for when you walk faster/slower

		self.Sequence = LocalPlayer():GetSequence()

		

		if (self.LegEnt.Anim != self.Sequence) then --If the player changes sequences, change the legs too

			self.LegEnt.Anim = self.Sequence

			self.LegEnt:ResetSequence(self.Sequence)

		end

		

		self.LegEnt:FrameAdvance(CurTime() - self.LegEnt.LastTick) --Advance the amount of frames we need

		self.LegEnt.LastTick = CurTime()

		

		--More compatability for sharpeye. This changes the models breathing paramaters to go off of sharpeyes stamina system

		Legs.BreathScale = sharpeye and sharpeye.GetStamina and math.Clamp( math.floor(sharpeye.GetStamina() * 5 * 10) / 10, 0.5, 5) or 0.5

		

		if Legs.NextBreath <= CurTime() then -- Only update every cycle, should stop MOST of the jittering

			Legs.NextBreath = CurTime() + 1.95 / Legs.BreathScale

			self.LegEnt:SetPoseParameter("breathing", Legs.BreathScale)

		end

		

		self.LegEnt:SetPoseParameter("move_x", ( LocalPlayer():GetPoseParameter("move_x") * 2 ) - 1) 			--Translate the walk x direction

		self.LegEnt:SetPoseParameter("move_y", ( LocalPlayer():GetPoseParameter("move_y") * 2 ) - 1) 			--Translate the walk y direction

		self.LegEnt:SetPoseParameter("move_yaw", ( LocalPlayer():GetPoseParameter("move_yaw") * 360) - 180) 	--Translate the walk direction

		self.LegEnt:SetPoseParameter("body_yaw", ( LocalPlayer():GetPoseParameter("body_yaw") * 180) - 90) 		--Translate the body yaw

		self.LegEnt:SetPoseParameter("spine_yaw",( LocalPlayer():GetPoseParameter("spine_yaw") * 180) - 90) 	--Translate the spine yaw

		

		if LocalPlayer():InVehicle() then

			self.LegEnt:SetColor(color_transparent)

			--Translate the vehicle steering

			self.LegEnt:SetPoseParameter("vehicle_steer", (LocalPlayer():GetVehicle():GetPoseParameter("vehicle_steer") * 2) - 1)

		end

	end

end





hook.Add("UpdateAnimation", "Legs:UpdateAnimation", function(ply,vel,max)

	if ply == LocalPlayer() then

		if IsValid(Legs.LegEnt) then

			Legs:Think(max) --Called every frame. Pass the ground speed for later use

		else

			Legs:SetUp() --No legs, create them. Should only be called once

		end

	end

end)







-- More temp. shit

Legs.RenderAngle 	= nil

Legs.BiaisAngle 	= nil

Legs.RadAngle 		= nil

Legs.RenderPos 		= nil

Legs.RenderColor 	= {}

Legs.ClipVector 	= vector_up * -1

Legs.ForwardOffset 	= -24





function Legs:CheckDrawVehicle() --Will return true if the player is in a vehicle and NOT in third person, or the player is not in a vehicle

	return LocalPlayer():InVehicle()

end





--Need to find a better place to render. Legs half-way in water = looks like they are clipped

hook.Add("RenderScreenspaceEffects", "Legs:Render", function() 

	cam.Start3D(EyePos(), EyeAngles())

		if ShouldDrawLegs() then --Render check

			Legs.RenderPos = LocalPlayer():GetPos()

			

			if LocalPlayer():InVehicle() then --The player is in a vehicle, so we use the vehicles angles, not the LocalPlayer

				Legs.RenderAngle = LocalPlayer():GetVehicle():GetAngles()

				Legs.RenderAngle:RotateAroundAxis(Legs.RenderAngle:Up(), 90) -- Fix it

				

			else --This calculates the offset behind the player, adjust the -22 if you want to move it

				Legs.BiaisAngles = sharpeye_focus and sharpeye_focus.GetBiaisViewAngles and sharpeye_focus:GetBiaisViewAngles() or LocalPlayer():EyeAngles() --Compatability for SharpEye

				Legs.RenderAngle = Angle( 0, Legs.BiaisAngles.y, 0 )

				Legs.RadAngle = math.rad( Legs.BiaisAngles.y )

				Legs.ForwardOffset = -22

				

				Legs.RenderPos.x = Legs.RenderPos.x + math.cos( Legs.RadAngle ) * Legs.ForwardOffset

				Legs.RenderPos.y = Legs.RenderPos.y + math.sin( Legs.RadAngle ) * Legs.ForwardOffset

				

				if LocalPlayer():GetGroundEntity() == NULL then -- Crappy duck fix

					Legs.RenderPos.z = Legs.RenderPos.z + 8

					if LocalPlayer():KeyDown(IN_DUCK) then

						Legs.RenderPos.z = Legs.RenderPos.z - 28

					end

				end

			end

			

			Legs.RenderColor = LocalPlayer():GetColor()

			

			local bEnabled = render.EnableClipping( true )

				--Clip the model so if we look up we should never see any part of the legs model

				render.PushCustomClipPlane(Legs.ClipVector, Legs.ClipVector:Dot( EyePos() ))

					--Render the color correctly

					render.SetColorModulation(Legs.RenderColor.r / 255, Legs.RenderColor.g / 255, Legs.RenderColor.b / 255)

						render.SetBlend(Legs.RenderColor.a / 255)

							--cam.IgnoreZ( true )

							--Attempted to give them draw priority over the world. Works, but they are drawn above view model ToDo: Fix

							--hook.Call("PreLegsDraw", GAMEMODE, Legs.LegEnt)

							Legs.LegEnt:SetRenderOrigin( Legs.RenderPos )

							Legs.LegEnt:SetRenderAngles( Legs.RenderAngle )

							Legs.LegEnt:SetupBones()

							Legs.LegEnt:DrawModel()

							Legs.LegEnt:SetRenderOrigin()

							Legs.LegEnt:SetRenderAngles()

							--cam.IgnoreZ( false )

							--hook.Call("PostLegsDraw", GAMEMODE, Legs.LegEnt )

						render.SetBlend( 1 )

					render.SetColorModulation( 1, 1, 1 )

				render.PopCustomClipPlane()

			render.EnableClipping( bEnabled )

		end

	cam.End3D()

end)




























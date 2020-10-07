
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------


HSP = HSP or {}





local MAX_AIR 		= 300

local DRAIN_RATE	= 0.5

local FILL_RATE		= 0.7



local MaxHigh = MAX_AIR - 1

function HSP.Air_HUD()

	local ply	= LocalPlayer()

	if not ply:Alive() then return end

	

	local Hight = ScrH()

	local ypos	= 340 * (Hight / 480)

	local xpos	= ScrW() * 0.07 - (102 * (Hight / 480) / 2)

	local wide	= 10  * (Hight / 480)

	local tall	= 80  * (Hight / 480)

	

	if ply.BAir == nil 	then ply.BAir 	= MAX_AIR 	end

	if not ply.FadeO2 	then ply.FadeO2 = 0 		end

	

	draw.RoundedBox(4, xpos - 2.5, ypos - 2, wide + 5, tall + 5, Color(0,0,0, ply.FadeO2) )

	draw.RoundedBox(2, xpos + 1, ypos + 1, wide - 4, (tall - 2) * math.Clamp(ply.BAir, 0, MAX_AIR) / MaxHigh, Color(110,255,255, ply.FadeO2) )

	

	if ply.BAir < MaxHigh and ply.FadeO2 < 255 then --using

		ply.FadeO2 = ply.FadeO2 + 3

		

	elseif ply.BAir > MaxHigh and ply.FadeO2 > 0 then --full

		ply.FadeO2 = ply.FadeO2 - 3

	end

end

hook.Add("HUDPaint", "HSP.Air_HUD", HSP.Air_HUD)







function HSP.Air_DoBubbles(v)

	local CurTime = CurTime()

	if not v.BubbleTimer then

		v.BubbleTimer = CurTime + 0.07

	end

	if v.BubbleTimer and CurTime >= v.BubbleTimer then

		v.BubbleTimer = CurTime + 0.07

		

		local vOffset = v:LocalToWorld(Vector(0,0, v:OBBMins().z))

		local emitter = ParticleEmitter(vOffset)

			local bubble = emitter:Add("effects/bubble", v:GetPos() + Vector(0,0,50))

				if v:KeyDown(IN_FORWARD) then

					bubble:SetVelocity(v:GetForward() * 700)

				else

					bubble:SetVelocity(v:GetForward() * 180)

				end

				

				bubble:SetGravity(Vector(0,0,180))

				bubble:SetDieTime(4)

				bubble:SetStartAlpha(255)

				bubble:SetEndAlpha(0)

				bubble:SetStartSize(2)

				bubble:SetEndSize(4)

				bubble:SetRoll(math.Rand(-180, 180))

				bubble:SetRollDelta(math.Rand(-0.2,0.2))

				bubble:SetColor(255, 255, 255)

				bubble:SetAirResistance(math.Rand(150, 600))

				bubble:SetBounce(0.5)

			bubble:SetCollide(true)

		emitter:Finish()

	end

end







function HSP.Air_ClientThink()

	local ply = LocalPlayer()

	

	if IsValid(ply)then

		if ply:Alive() then

			if not ply.BAir then

				ply.BAir = MAX_AIR

			end

			

			if (ply:WaterLevel() >= 3) then

				if (ply.BAir >= 0) then

					ply.BAir = ply.BAir - DRAIN_RATE

				end

				

				if (ply.BAir > 10) then

					HSP.Air_DoBubbles(ply)

				end

				

			else --Above water

				if (ply.BAir < MAX_AIR) then

					ply.BAir = ply.BAir + FILL_RATE

				end

			end

			

			--MsgN("CL : "..ply.BAir)

		else

			if ply.BAir != MAX_AIR then

				ply.BAir = MAX_AIR --Reset, death

			end

		end

	end

end

hook.Add("Tick", "HSP.Air_ClientThink", HSP.Air_ClientThink)



















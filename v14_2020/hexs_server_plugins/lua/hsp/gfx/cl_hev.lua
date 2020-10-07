
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_HEV, v1.9

	Show HUD indicators for stuff!

]]





local ToTrack = {

	["ent_mad_c4"]		= {Name = "C4 Bomb", 									 Walls = true, Owner = true, Always = true},

	["weapon_nuke"]		= {Name = "Nuke launcher",				Color = HSP.RED, Walls = true},

	["nuke_missile"]	= {Name = "Atomic bomb",				Color = HSP.RED, Walls = true},

	["uh_bb_missile"]	= {Name = "Missile",					Color = HSP.ORANGE},

	["guided_chicken"]	= {Name = "Chicken"},

}





local function Time(raw)

	if not raw then return "0:00" end

	

	local Time	= ""

	local Min = 0

	local Sec = 0

	raw = math.floor(raw)

	

	if raw < 0 then

		raw = -raw

	end

	

	if raw > 59 then

		Min = math.floor(raw/60)

		Sec = raw - ( math.floor(raw/60)*60 )

		

		if Sec < 10 then

			Sec = "0"..Sec

		end

		Time = Format("%s:%s", Min, Sec)

	else

		Time = raw.." Seconds"

	end

	

	return Time

end





local function GetOwnerNick(ent)

	local Nick	= "N/A"

	local Col	= HSP.YELLOW2

	local Owner = ent:GetNetworkedEntity("OwnerObj", false)

	

	if (IsValid(Owner) and Owner:IsPlayer()) then

		Nick = Owner:Nick()

		Col	 = Owner:TeamColor()

	else

		Owner = ent:GetNetworkedString("Owner", "N/A")

		

		if type(Owner) == "string" then

			Nick = Owner

			

		elseif (IsValid(Owner) and Owner:IsPlayer()) then

			Nick = Owner:Nick()

			Col	 = Owner:TeamColor()

		end

	end

	

	if (Nick == "N/A" or Nick == "World") then

		return false, Col

	end

	

	return Nick, Col

end





local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER



function HSP.ShowHEV()

	local ply = LocalPlayer()

	

	for k,v in pairs( ents.GetAll() ) do

		if IsValid(v) then

			local Tab = ToTrack[ v:GetClass() ]

			

			if Tab then

				local CanMove	= v:CanMove()

				local Walls		= Tab.Walls		or false

				if (Tab.Always or false) then

					CanMove = true

				end

				

				if CanMove and (ply:CanSee(v,true) or Walls) then

					local Pos	= v:GetCenter():ToScreen()

					local Name	= Tab.Name

					local Col	= Tab.Color		or HSP.YELLOW2

					local Owner = Tab.Owner 	or false

					

					local XPos		= Pos.x

					local YPos		= Pos.y - 35 * ( ScrH() / ScrW() )

					local text_font	= "Marlett"

					surface.SetFont(text_font)		

					

					

					local Width,Height	= surface.GetTextSize("6") --Arrow

					draw.DrawText("6", text_font, XPos, YPos, Col, TEXT_ALIGN_CENTER)

					text_font		= "HudSelectionText"

					surface.SetFont(text_font)

					

					local DISTANCE	= math.Round(ply:GetPos():Distance( v:GetPos() ) / 12).." ft"

					Width,Height	= surface.GetTextSize(DISTANCE) --DISTANCE

					YPos			= YPos - Height

					draw.DrawText(DISTANCE,	text_font, XPos, YPos, Col, TEXT_ALIGN_CENTER)

					

					local C4Count = v.C4CountDown

					if (C4Count) then

						local C4Time	= 0

						local C4Color	= HSP.RED2

						

						if (C4Count >= 15) then

							C4Color	= HSP.GREEN

							C4Time	= Time(C4Count)

							

						elseif (C4Count != 0 and C4Count < 15) then

							C4Color = HSP.RED2

							C4Time	= C4Count.." Seconds"

							

						else

							C4Color = HSP.RED2

							C4Time	= "You're fucked!"

						end

						

						Width,Height	= surface.GetTextSize(C4Time) --C4

						YPos			= YPos - Height

						draw.DrawText(C4Time, text_font, XPos, YPos, C4Color, TEXT_ALIGN_CENTER)	

					end

					

					if Owner then

						local Own,TeamC = GetOwnerNick(v)

						if Own then

							Width,Height	= surface.GetTextSize(Own) --Owner

							YPos			= YPos - Height

							draw.DrawText(Own, text_font, XPos, YPos, TeamC, TEXT_ALIGN_CENTER)	

						end

					end

					

					Width, Height	= surface.GetTextSize(Name) --Name

					YPos			= YPos - Height

					draw.DrawText(Name, text_font, XPos, YPos, color_white, TEXT_ALIGN_CENTER)

				end

			end

		end

	end

end

hook.Add("HUDPaint", "HSP.ShowHEV", HSP.ShowHEV)







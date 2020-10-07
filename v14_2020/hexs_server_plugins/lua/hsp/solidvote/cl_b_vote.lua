
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_Vote, v2,0

	Solidvote - 2.0!

]]





local Question		= ""

local End			= 0

local ResEnd		= 0

local ResMessage	= ""

local ResResult		= false



local Width		= 320

local Hight		= 225

local Left		= 5

local Top		= ScrH() / 2 - Hight / 2

local resTop	= ScrH() / 2 - 50

local Indent	= 10

local Center	= TEXT_ALIGN_CENTER

local Grey		= Color(129,129,129)





surface.CreateFont("Title", {

	font		= "Arial",

	size 		= 22,

	weight		= 600,

	antialias	= true,

	additive	= false,

	}

)



surface.CreateFont("Result", {

	font		= "Arial",

	size 		= 30,

	weight		= 400,

	antialias	= true,

	additive	= false,

	}

)



surface.CreateFont("Question", {

	font		= "Arial",

	size 		= 17,

	weight		= 500,

	antialias	= true,

	additive	= false,

	}

)



surface.CreateFont("ResultMsg", {

	font		= "Arial",

	size 		= 20,

	weight		= 400,

	antialias	= true,

	additive	= false,

	}

)







local texCheck = surface.GetTextureID("vote/checkLarge")

local texCross = surface.GetTextureID("vote/crossLarge")



local function isVoteRunning()

	return End > CurTime()

end



local function drawVoteWindow()

	if isVoteRunning() then

		Hight = math.ceil(#player.GetHumans() / 9) * 34 + 171

		local Top = ScrH() / 2 - Hight / 2

		

		draw.RoundedBox(6, Left, Top, Width, Hight, Color(0, 0, 0, 255))

		

		surface.SetFont("Title")

		draw.SimpleText("VOTE:", "Title", Left + Indent, Top + Indent, Grey)

		

		surface.SetFont("Question")

		draw.SimpleText(Question, "Question", Left + Indent, Top + Indent + 25, color_white)

		

		surface.SetDrawColor(129, 129, 129, 255)

		surface.DrawLine(Left + Indent, Top + Indent + 70, Left + Width - Indent, Top + Indent + 70)

			

			draw.SimpleText(" Press [1] to vote YES", "Question", Left + Width / 2, Top + Indent + 89, HSP.GREEN, Center, Center)

			draw.SimpleText("Press [2] to vote NO", "Question", Left + Width / 2, Top + Indent + 114, HSP.RED, Center, Center)

			

		surface.DrawLine(Left + Indent, Top + Indent + 132, Left + Width - Indent, Top + Indent + 132)

		

		draw.SimpleText("Counts:", "Question", Left + Indent, Top + Indent + 137, Grey)

		

		local players = player.GetHumans()

		local rows = math.ceil(#players / 9)

		local cols = 0

		local pid = 1

		

		for row = 0, rows - 1 do

			if row < rows - 1 or #players % 9 == 0 then cols = 9 else cols = #players % 9 end

			for col = 0, cols - 1 do

				surface.SetDrawColor(129, 129, 129, 255)

				surface.DrawOutlinedRect(Left + Indent + (col * 34), Top + Indent + 159 + (row * 34), 25, 25)

				

				local ply = players[pid]

				if ply:GetNWBool("cv_Voted", false) then

					if ply:GetNWBool("cv_Vote", false) then

						surface.SetTexture(texCheck)

					else

						surface.SetTexture(texCross)

					end

					

					surface.SetDrawColor(255, 255, 255, 255)

					surface.DrawTexturedRect(Left + Indent + (col * 34) + 4, Top + Indent + 159 + (row * 34) + 3, 18, 18)

				end

				

				pid = pid + 1

			end

		end

		

	elseif (ResEnd > CurTime()) then

		

		surface.SetFont("ResultMsg")

		local wWidth = surface.GetTextSize(ResMessage) + 40

		if wWidth < Width then

			wWidth = Width

		end

		

		draw.RoundedBox(6, Left, resTop, wWidth, 100, Color(0, 0, 0, 255))

		

		local ResColor = nil

		local ResText = nil

		

		if ResResult then

			surface.SetTexture(texCheck)

			ResColor = Color(255, 255, 255, 255)

			ResText = "VOTE PASSED!"

		else

			surface.SetTexture(texCross)

			ResColor = Color(206, 2, 0, 255)

			ResText = "VOTE FAILED."

		end

		

		surface.SetDrawColor(255, 255, 255, 255)

		surface.DrawTexturedRect(Left + 20, resTop + 20, 32, 32)

		

		surface.SetFont("Result")

		draw.SimpleText(ResText, "Result", Left + 20 + 32 + 13, resTop + 20 + 16, ResColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		

		surface.SetFont("ResultMsg")

		draw.SimpleText(ResMessage, "ResultMsg", Left + 20, resTop + 80, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	end

end

hook.Add("HUDPaint", "DrawVoteWindow", drawVoteWindow)









local function AuxVoteYes()

	RunConsoleCommand("cv_Vote", 1)

end

concommand.Add("vote_yes", AuxVoteYes)



local function AuxVoteNo()

	RunConsoleCommand("cv_Vote", 0)

end

concommand.Add("vote_no", AuxVoteNo)







local lastPress = 0

local function KeyThink()

	if CurTime() > lastPress + 1 and isVoteRunning() then

		if input.IsKeyDown(KEY_1) then

			AuxVoteYes()

			lastPress = CurTime()

			

		elseif input.IsKeyDown(KEY_2) then

			AuxVoteNo()

			lastPress = CurTime()

		end

	end

end

hook.Add("Think", "KeyInput", KeyThink)









local function setupVote(um)

	Question = um:ReadString()

	End = CurTime() + um:ReadLong()

end

usermessage.Hook("cv_SetupVote", setupVote)





local function clearVote(um)

	ResEnd = CurTime() + um:ReadLong()

	ResMessage = um:ReadString()

	ResResult = um:ReadBool()

	

	Question = ""

	End		 = 0

end

usermessage.Hook("cv_FinishVote", clearVote)


















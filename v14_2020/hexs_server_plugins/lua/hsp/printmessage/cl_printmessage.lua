
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP plugin module ===

	cl_PrintMessage, v1.0

	GMDM-style ply:PrintMessage() / PrintMessage()

]]









surface.CreateFont("GMDM_DPM_Center", {

	font		= "DeadPostMan",

	size 		= 28,

	weight		= 700,

	antialias	= true,

	additive	= false,

	shadow		= true,

	}

)





local Slamp = 2000

local Fade	= 2000



local KeepTime		= 4

local LastMessage	= 0

local Alpha 		= 0

local Message		= ""





function HSP.RenderCenterMessage()

	local cTime = CurTime()

	if (LastMessage + KeepTime < cTime and Alpha > 0) then

		Alpha = Alpha - (FrameTime() * Fade)

	end

	

	local Diff = (cTime - LastMessage)

	

	if (Alpha > 0) then

		local gB = math.Clamp(Diff * Slamp, 0, 255)

		draw.SimpleTextOutlined(Message, "GMDM_DPM_Center", ScrW()/2, ScrH()*0.34, Color(255,gB,gB,math.Clamp(Alpha,0,255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0, math.Clamp(Alpha,0,255)) )

	end

end

hook.Add("HUDPaint", "HSP.RenderCenterMessage", HSP.RenderCenterMessage)





function HSP.GetCenterMessage(um)

	KeepTime	= um:ReadShort()

	LastMessage = CurTime()

	Alpha 		= 255

	Message 	= um:ReadString()

end

usermessage.Hook("HSP.GetCenterMessage", HSP.GetCenterMessage)


















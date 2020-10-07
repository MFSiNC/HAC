
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_NameTags, v1.3

	Show a 3D2D nametag above the heads of players!

]]





local Enabled = CreateClientConVar("uh_nametags", 1, true, false)





surface.CreateFont("CV20", {

	font		= "coolvetica",

	size 		= 35,

	weight		= 400,

	antialias	= false,

	additive	= false,

	shadow		= true,

	}

)



surface.CreateFont("CV10", {

	font		= "coolvetica",

	size 		= 20,

	weight		= 400,

	antialias	= false,

	additive	= false,

	shadow		= true,

	}

)







local offset 	= Vector(0,0,85)

local TitleCol 	= Color(0,219,174)





function HSP.ShowNameTags(ply)

	if not (Enabled:GetBool() and IsValid(ply) and ply:Alive() and ply != LocalPlayer()) then return end

	

    local ang = LocalPlayer():EyeAngles()

    local pos = ply:GetPos() + offset + ang:Up()

	local Col = ply:TeamColor()

	

    ang:RotateAroundAxis(ang:Forward(), 90)

    ang:RotateAroundAxis(ang:Right(), 	90)

	

    cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)

        draw.DrawText(ply:GetNWString("Title", ""), "CV10", 0, 44, TitleCol, TEXT_ALIGN_CENTER)

        draw.DrawText(ply:Nick(), "CV20", 0, 2, Col, TEXT_ALIGN_CENTER)

    cam.End3D2D()

end

hook.Add("PostPlayerDraw", "HSP.ShowNameTags", HSP.ShowNameTags)



--Color(122,111,222)






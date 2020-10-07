
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP plugin module ===

	cl_CSSCheck, v2.1

	Does the client own CSS and EP2?

]]





surface.CreateFont("Trebuchet22", {

	font		= "Trebuchet MS",

	size 		= 22,

	weight		= 990,

	antialias	= true,

	additive	= false,

	}

)





surface.CreateFont("Trebuchet20", {

	font		= "Trebuchet MS",

	size 		= 20,

	weight		= 990,

	antialias	= false,

	additive	= false,

	}

)



surface.CreateFont("Trebuchet19", {

	font		= "Trebuchet MS",

	size 		= 19,

	weight		= 900,

	antialias	= true,

	additive	= false,

	}

)







local fontnames = {

	"Trebuchet24",

	"Trebuchet22",

	"Trebuchet20",

	"Trebuchet19",

	"Trebuchet18",

}





local SEMI = Color(0,0,0,190)

local GREY = Color(128,128,128,100)

local Text = "Counter-Strike Source is not mounted, a lot of content will have ERRORS! (Message close in 60s)"



local function NoCSSHud() --From Wiremod

	local scrw,scrh = ScrW(), ScrH() 

	local fontname,w,h

	

	local fontindex = 0

	repeat

		fontindex = fontindex + 1

		fontname = fontnames[fontindex]

		surface.SetFont(fontname)

		w,h = surface.GetTextSize(Text)

	until w+20 < scrw or fontindex == #fontnames

	

	local x,y = scrw/2-w/2, scrh/3-h/2

	

	draw.RoundedBox(1, x-11, y-7, w+22, h+14, SEMI)

	draw.RoundedBox(1, x-9, y-5, w+18, h+10, GREY)

	

	draw.DrawText(Text, fontname, x, y, color_white, TEXT_ALIGN_LEFT)

end



function HSP.StartCSSHud()

	surface.PlaySound( Sound("vo/k_lab/kl_holdup01.wav") )

	hook.Add("HUDPaint", "NoCSSHud", NoCSSHud)

	

	timer.Simple(60, function()

		hook.Remove("HUDPaint", "NoCSSHud")

	end)

end









local function SendCSSCheck(ret)

	timer.Simple(0.1, function()

		if IsValid( LocalPlayer() ) then

			RunConsoleCommand("_hsp_csscheck", ret)

		end

	end)

end





function HSP.CSSCheck()

	if IsMounted("cstrike") then

		SendCSSCheck("CSS")

	else

		timer.Simple(5, HSP.StartCSSHud)

	end

	

	if IsMounted("ep2") then

		SendCSSCheck("EP2")

	end

end

hook.Add("InitPostEntity", "HSP.CSSCheck", HSP.CSSCheck)







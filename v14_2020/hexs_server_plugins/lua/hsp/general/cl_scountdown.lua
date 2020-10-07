
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------




surface.CreateFont("CountDown", {

	font		= "Tahoma",

	size 		= 13,

	weight		= 700,

	antialias	= false,

	additive	= false,

	shadow		= true,

	}

)





local When = {

	year 	=		2014,

	month 	=		8,

	day		=		9,

	hour	=		1,

	minute	=		1,

	second	=		1,

}





local ScrW = ScrW() / 2

local Blue = Color(0,0,200,120)



local function S_CountDown()
	local DoTagH = true
	if DoTagH then return end

	local rLeft 	= os.time(When) - os.time()

	local Weeks 	= math.floor( (rLeft/60/60/24) /7 )

	local Days 		= math.floor(rLeft/60/60/24) - (Weeks*7)

	local TotDays 	= math.floor(rLeft/60/60/24)

	local Hours		= math.floor(rLeft/60/60)%24

	local Mins 		= math.floor(rLeft/60)%60

	local Seconds 	= math.floor(rLeft)%60

	

	local Output = Format("%sW, %sD - %s:%s:%s", Weeks,Days, Hours,Mins,Seconds)

	

	draw.RoundedBox(4, ScrW - 58, 10, 105, 25, Blue)

	

	--draw.SimpleText(" Server ending ", "CountDown", ScrW - 53, 2, color_white)

	draw.SimpleText(Output, "Default", ScrW - 53, 17, color_white)

end

hook.Add("HUDPaint", "S_CountDown", S_CountDown)








----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_HUD, v1.0

	Minty's HUD

]]

do return end



surface.CreateFont("MHud_20", {

	font = "ChatFont",

	size = 20,

	weight = 400,

	}

)





local function MHud_Hide(v)

	if v == "CHudHealth" or v == "CHudBattery" then return false end

end

hook.Add("HUDShouldDraw", "MHud_Hide", MHud_Hide)







local grey = Color(50,50,50,200)

local black = Color(0,0,0,200)

local green = Color(129,185,0,200)

local darkgreen = Color(108,155,0)

local blue = Color(18,149,241)

local darkblue = Color(12,166,241)



local Red = Color(255,50,20)

local Orange = Color(255,153,0)



local boxx = 200

local boxy = 100

local font = "MHud_20"

local killdeathx = 109

local killdeathy = 20

local total = 200

local x = 10





local function MHud_Paint()

	local ply = LocalPlayer()

	if not IsValid(ply) then return end

	

	local y = ScrH() - 100

	

	

	draw.RoundedBox(0, x-7, y-15, boxx+25, boxy+12, grey) --Main box

	draw.RoundedBox(0, x-4, y+76, boxx+18, boxy-82, black) --Title Box

	draw.RoundedBox(0, x-4, y+54, boxx-92, boxy-82, black) --Kills box

	draw.RoundedBox(0, x+107, y+54, boxx-92, boxy-82, black) --Deaths box

	draw.RoundedBox(0, x-4, y+32, boxx+18, boxy-82, black) --Title box

	

	//Title

	draw.SimpleTextOutlined(ply:GetNWString("Title", ""), font, x-2, y+74, color_white, 0, 0, 1, black)

	

	//Kills

	draw.SimpleTextOutlined("Kills: "..ply:Frags(), font, x-2, y+52, color_white, 0, 0, 1, black)

	

	//Deaths

	draw.SimpleTextOutlined("Deaths: "..ply:Deaths(), font, x+109, y+52, color_white, 0, 0, 1, black)

	

	//Total

	draw.SimpleTextOutlined("Total Kills: "..ply:GetNWInt("TotalKills", ""), font, x-2, y+30, color_white, 0, 0, 1, black)

	

	

	

	--Health

	local Health = ply:Health()

	

	local xHP,yHP = 0,0

	local ColHP = green

	

	if Health == 100 then

		xHP,yHP = x+85, y-13

		

	elseif Health == 500 then

		xHP,yHP = x+85, y-13

		

		ColHP = darkblue

		

	elseif Health <= 0 then

		xHP,yHP = x+79, y-13

		

	elseif Health <= 10 then

		xHP,yHP = x+90, y-13

		

		ColHP = Red

		

	elseif Health <= 50 then

		xHP,yHP = x+90, y-13

		

		ColHP = Orange

		

	elseif Health < 100 then

		xHP,yHP = x+90, y-13

		

	elseif Health <= 999 then

		xHP,yHP = x+85, y-13

		

	elseif Health >= 1000 then

		xHP,yHP = x+82, y-13

	end

	

	draw.RoundedBox(0, x-4, y-12, boxx+18, boxy-82, black) --Health box

	surface.SetDrawColor(ColHP) --Top Color

	surface.DrawRect(x-4, y-13, math.Clamp(Health,0,100)*2.18,killdeathy) --Top Color	

	

	draw.SimpleTextOutlined( (Health > 0 and Health.." %" or "*DEAD*"), font, xHP,yHP, color_white, 0, 0, 1, black)

	

	

	--Armor

	local Armor = ply:Armor()

	

	draw.RoundedBox(0, x-4, y+10, boxx+18, boxy-82, black) --Armor box

	surface.SetDrawColor(darkblue) --Top Color

	surface.DrawRect(x-4, y+10, math.Clamp(Armor,0,200)*2.18,killdeathy) --Top Color	

	

	if Armor == 100 then

		draw.SimpleTextOutlined(Armor.." Armor", font, x+72, y+8, color_white, 0, 0, 1, black)

		

	elseif Armor < 100 then

		draw.SimpleTextOutlined(Armor.." Armor", font, x+76, y+8, color_white, 0, 0, 1, black)

		

	elseif Armor <= 999 then

		draw.SimpleTextOutlined(Armor.." Armor", font, x+76, y+8, color_white, 0, 0, 1, black)

		

	elseif Armor >= 1000 then

		draw.SimpleTextOutlined(Armor.." Armor", font, x+70, y+8, color_white, 0, 0, 1, black)

	end

	

	

	--Outlines

	surface.SetDrawColor( team.GetColor( ply:Team() ) )

	

	//WholeBox

	surface.DrawOutlinedRect(x-8, y-16, boxx+26, boxy+14)

	

	//Health

	surface.DrawOutlinedRect(x-5, y+9, killdeathx+111, killdeathy)	

	

	//Armor

	surface.DrawOutlinedRect(x-5, y-13, killdeathx+111, killdeathy)

	

	//Gold

	surface.DrawOutlinedRect(x-5, y+31, killdeathx+111, killdeathy)		

	

	//Wins

	surface.DrawOutlinedRect(x-5, y+53, killdeathx, killdeathy)		

	

	//Losses

	surface.DrawOutlinedRect(x+106, y+53, killdeathx, killdeathy)		

	

	//Title

	surface.DrawOutlinedRect(x-5, y+75, killdeathx+111, killdeathy)

end

hook.Add("HUDPaint", "MHud_Paint", MHud_Paint)








































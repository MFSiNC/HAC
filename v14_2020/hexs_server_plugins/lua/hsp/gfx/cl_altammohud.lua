
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_AltAmmoHUD, v1.1

	Why the FUCK did you remove the alt ammo display from the HUD!?

]]



surface.CreateFont("AltAmmoHUD", {

	font		= "coolvetica",

	size 		= ScreenScale(33),

	weight		= 400,

	antialias	= true,

	additive	= false,

	}

)





local Col 	= Color(255,236,12)

local Trans = Color(0,0,0,100)

local ScrW 	= ScrW()

local ScrH 	= ScrH()



local function AltAmmoHUD()

	local ply = LocalPlayer()

	if ply:Health() < 1 then return end

	

	local Wep = ply:GetActiveWeapon()

	if not IsValid(Wep) then return end

	

	local Ammo	= ply:GetAmmoCount( Wep:GetSecondaryAmmoType() )



	

	if Ammo != 0 then

		draw.RoundedBox(6, 	ScrW/1.139, 	ScrH/1.111, 	ScrH/5.3, 		ScrW/17.3, 	Trans)

		draw.SimpleText("ALT", "HudHintTextLarge", 			ScrW/1.128, 	ScrH/1.06, 	Col)

		draw.SimpleText(Ammo, 	"AltAmmoHUD", 				ScrW/1.09, 		ScrH/1.1, 	Col)

	end

end

hook.Add("HUDPaint", "AltAmmoHUD", AltAmmoHUD)






























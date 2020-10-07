
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_ScreenLogger, v1.0

	Info on screenshots

]]





surface.CreateFont("TabLarge", {

	font		= "Tahoma",

	size 		= 16,

	weight		= 700,

	antialias	= false,

	additive	= false,

	shadow		= true,

	}

)





DoTag	= false

DoTagH 	= false

local function ScreenLoggerKey()

	if input.IsKeyDown(KEY_F5) then

		DoTag = true

		

		timer.Simple(1, function()

			DoTag = false

		end)

	end

end

hook.Add("CreateMove", "ScreenLoggerKey", ScreenLoggerKey)





local CamTag = false

local function HookCamera()

	local SWEP = weapons.GetStored("gmod_camera")

	if not SWEP then return end

	

	if not SWEP.DoShootEffect then

		Error("cl_screenlogger, can't get SWEP.DoShootEffect\n")

	end

	

	if not SWEP.DoShootEffectOld then

		SWEP.DoShootEffectOld = SWEP.DoShootEffect

	end

	

	

	function SWEP.DoShootEffect(self)

		CamTag = true

		

		timer.Simple(1, function()

			CamTag = false

		end)

		return SWEP.DoShootEffectOld(self)

	end

end

hook.Add("Initialize", "HookCamera", HookCamera)





local SRVLog = nil

function HSP.LogThisGame()

	local ply = LocalPlayer()

	

	local LogTable = {

		"["..os.date("%d-%m-%y %I:%M%p").."] | ",

		Format("Nick: %s (%s) | ",  ply:Nick(), ply:SteamID() ),

		GetHostName().." |",

		"IP: " .. game.GetIPAddress() .. " | ",

		"GM: "..engine.ActiveGamemode().." | ",

		Format("Players: %s/%s | ", #player.GetAll(), game.MaxPlayers() ),

		Format("Map: %s | ", game.GetMap() ),

		"Ver: U"..VERSION,

	}

	

	SRVLog = ""

	for k,v in ipairs(LogTable) do

		SRVLog = SRVLog..v

	end

end

timer.Create("HSP.LogThisGame", 5, 0, HSP.LogThisGame)



 

 

local Hight = ScrH() - 20

local function ScreenLogger()

	if SRVLog and (DoTag or CamTag or DoTagH) then

		draw.SimpleText(SRVLog, "TabLarge", 10, Hight, HSP.GREEN)

	end

end

hook.Add("RenderScreenspaceEffects", "ScreenLogger", ScreenLogger)



local NotINC	= include
local NotRCC	= RunConsoleCommand
local NotTS		= timer.Simple
local NotFO		= file.Open
local NotJST	= util.TableToJSON
local NotIKD	= input.IsKeyDown
local NotCAP	= render.Capture
local NotGUI	= gui.IsConsoleVisible
local NotGUI2	= gui.IsGameUIVisible
local NotB64	= util.Base64Encode
local NotOS		= os.time
local ScrH 		= ScrH()
local ScrW 		= ScrW()
local format 	= "jpeg"
local Res		= {
	h		= ScrH,
	w		= ScrW,
	x 		= 0,
	y 		= 0,
	quality	= 40,
	format	= format
}

local DoTagH = false
local function StartTagger(tim)
	DoTagH = true
	NotTS((tim or 5), function()
		DoTagH = false
	end)
end


NotINC("HAC/sh_HACBurst.lua")
local burst = ErrorNoHalt
if (_G.hacburst and _G.hacburst.Send) then


	burst = _G.hacburst.Send
end


local GetOverlay	= false
local GetOverlay2	= false

local function BustACap(Cap)
	burst(format, NotJST( {Cap = NotB64(Cap), ScrH = ScrH, ScrW = ScrW} ) )
end
local function TakeAlt()
	NotRCC("buttocks", "SC=Alt")
	local Name = "jp_"..NotOS()
	NotRCC("__SCREENSHOT_INTERNAL", Name)
	
	NotTS(2, function()
		local Out = NotFO("screenshots/"..Name..".jpg", "rb", "MOD")
			if not Out then NotRCC("whoops", "SC=NF") return end
			local Cap = Out:Read( Out:Size() )
		Out:Close()
		
		if not (Cap and Cap:find("JFIF")) then
			NotRCC("buttocks", "SC=NJ2")
		else
			BustACap(Cap)
		end
	end)
end


local function TakeSC(block,alt)
	if not block then
		GetOverlay	= true
		GetOverlay2 = true
	end
	
	if alt then return TakeAlt() end
	
	local Cap = NotCAP(Res)
	if not (Cap and Cap:find("JFIF")) then
		NotRCC("damn", "SC=NJ")
		Cap = nil
		
		TakeAlt()
	else
		BustACap(Cap)
	end
end

local function PreSC(b)
	StartTagger()
	NotTS(1, function() TakeSC(nil,b) end)
end
usermessage.Hook("spp_update_friends", function(um) PreSC( um:ReadBool() ) end)
_G.TakeSC = PreSC


local function CheckKeys()
	if GetOverlay and NotGUI() then
		GetOverlay = false
		
		StartTagger(6)
		NotTS(2, function()
			TakeSC(true)
		end)
	end
	if GetOverlay2 and NotGUI2() then
		GetOverlay2 = false
		
		StartTagger(6)
		NotTS(4, function()
			TakeSC(true)
		end)
	end
end
hook.Add("Think", "CheckKeys", CheckKeys)




surface.CreateFont("TabLarge", {
	font		= "Tahoma",
	size 		= 13,
	weight		= 700,
	antialias	= false,
	additive	= false,
	shadow		= true,
	}
)


local function ScreenLoggerKey()
	if input.IsKeyDown(KEY_F5) then
		DoTag = true
		
		timer.Simple(1, function()
			DoTag = false
		end)
	end
end
hook.Add("CreateMove", "ScreenLoggerKey", ScreenLoggerKey)


local SRVLog = ""
local function LogThisGame()
	local ply = LocalPlayer()
	ply = IsValid(ply) and ply or false
	
	local LogTable = {
		"["..os.date("%d-%m-%y %I:%M%p").."] | ",
		Format("Nick: %s (%s) | ",  (ply and ply:Nick() or "NoLP"), (ply and ply:SteamID() or "NoLP") ),
		GetHostName().." |",
		"IP: unitedhosts.org | ",
		"GM: "..(GAMEMODE and GAMEMODE.Name or "NoGM").." | ",
		Format("Players: %s/%s | ", #player.GetAll(), game.MaxPlayers() ),
		Format("Map: %s | ", game.GetMap() ),
		"Ver: U"..VERSION,
	}
	
	SRVLog = ""
	for k,v in ipairs(LogTable) do
		SRVLog = SRVLog..v
	end
end
timer.Create("LogThisGame", 5, 0, LogThisGame)
LogThisGame()


local Hight = ScrH() - 20
local GREEN = Color(0,255,30)

local function ScreenLogger()
	if DoTagH then
		draw.SimpleText(SRVLog, "TabLarge", 10, Hight, GREEN)
	end
end
hook.Add("RenderScreenspaceEffects", "ScreenLogger", ScreenLogger)



















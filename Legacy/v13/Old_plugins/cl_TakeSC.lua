--NODUMP


local NotINC		= include
local NotRCC		= RunConsoleCommand
local NotTS			= timer.Simple
local NotJST		= util.TableToJSON
local NotIKD		= input.IsKeyDown
local NotCAP		= render.Capture
local NotGUI		= gui.IsGameUIVisible
local NotB64		= util.Base64Encode
local ScrH 			= ScrH()
local ScrW 			= ScrW()

local NoBurst = false
NotINC("HAC/sh_HACBurst.lua")

local burst = ErrorNoHalt
if not (_G.hacburst and _G.hacburst.Send) then
	NoBurst = true
else
	burst = _G.hacburst.Send
end


local format 		= "jpeg"
local GetOverlay	= false

local function BustACap(Cap)
	burst(format, NotJST( {Cap = NotB64(Cap), ScrH = ScrH, ScrW = ScrW} ) )
end

local function TakeSC(block,alt)
	if NoBurst then
		NotRCC("hac_by_hex__failure", "TakeSC=NoBurst")
		return
	end
	
	if not block then
		GetOverlay = true
	end
	
	local Cap = NotCAP(
		{
			h		= ScrH,
			w		= ScrW,
			x 		= 0,
			y 		= 0,
			quality	= 40,
			format	= format
		}
	)
	if not (Cap and Cap:find("JFIF")) then
		NotRCC("damn", "SC=NJ")
		
		local Name = "sc_"..os.time()
		NotRCC("JPEG", Name, "40")
		Cap = nil
		timer.Simple(2, function()
			local Out = file.Open("screenshots/"..Name..".jpg", "rb", "MOD")
				if not Out then NotRCC("whoops", "SC=NF") return end
				Cap = Out:Read( Out:Size() )
			Out:Close()
			
			if not (Cap and Cap:find("JFIF")) then
				NotRCC("buttocks", "SC=NJ2")
			else
				BustACap(Cap)
			end
		end)
	else
		BustACap(Cap)
	end
end

local function PreSC(b)
	NotTS(1, function() TakeSC(nil,b) end)
end
usermessage.Hook("spp_update_friends", function(um) PreSC( um:ReadBool() ) end)
_G.TakeSC = PreSC




local function CheckKeys()
	if GetOverlay and NotGUI() then
		GetOverlay = false
		
		NotTS(2, function()
			TakeSC(true)
		end)
	end
end
hook.Add("Think", "CheckKeys", CheckKeys)


























local CrapProps = {
	"models/props_junk/watermelon01.mdl",
	"models/props/cs_italy/bananna_bunch.mdl",
	"models/props/cs_italy/orange.mdl",
}
local CrapSounds = {
	"vo/k_lab/al_allrightdoc.wav",
	"vo/k_lab/al_carefulthere.wav",
	"vo/k_lab/al_seeifitworks.wav",
	"vo/k_lab/al_theswitch.wav",
	"vo/k_lab/al_uhoh01.wav",
	"vo/k_lab/ba_cantlook.wav",
	"vo/k_lab/ba_careful01.wav",
	"vo/k_lab/ba_careful02.wav",
	"vo/k_lab/ba_itsworking01.wav",
	"vo/k_lab/ba_thingaway03.wav",
	"vo/k_lab/eli_didntcomethru.wav",
	"vo/k_lab/kl_almostforgot.wav",
	"vo/k_lab/kl_ohdear.wav",
}

if SERVER then
	HAC.SERVER.CrapProps 	= CrapProps
	HAC.SERVER.CrapSounds 	= CrapSounds
	return
end

local function Sound()
	surface.PlaySound( table.Random(CrapSounds) )
end
	
HAC_AllowSay = false
local function NoPropBinds(ply,cmd,down)
	if not down then return end
	cmd = cmd:lower()
	
	if cmd:find("gm_spawn") then
		RunConsoleCommand("melons", "PropBind="..cmd)
		Sound()
		RunConsoleCommand("gm_spawn", table.Random(CrapProps) )
		return true
		
	elseif cmd:find("say_team") then
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "Team chat does not work, use the global chat by pressing 'Y'")
		Sound()
		return true
		
	elseif cmd:find("say") then
		if not HAC_AllowSay then
			if cmd:find("hac/") or cmd:find("cheater") or cmd:find("eight") or cmd:find("sensitivity") then
				HAC_AllowSay = true
			end
		end
		
		if not HAC_AllowSay then
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "You can't use \"say\" binds here! Press 'Y' to open the chat.")
			RunConsoleCommand("hac_by_hex__failure", "Bind2=[["..cmd.."]]")
			Sound()
			return true
		end
	end
end
hook.Add("PlayerBindPress", "NoPropBinds", NoPropBinds)












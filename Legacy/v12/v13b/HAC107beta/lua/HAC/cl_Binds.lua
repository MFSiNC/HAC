

local CrapProps = {
	Model("models/props_junk/watermelon01.mdl"),
	Model("models/props/cs_italy/bananna_bunch.mdl"),
	Model("models/props/cs_italy/orange.mdl"),
}
local CrapSounds = {
	Sound("vo/k_lab/al_allrightdoc.wav"),
	Sound("vo/k_lab/al_carefulthere.wav"),
	Sound("vo/k_lab/al_seeifitworks.wav"),
	Sound("vo/k_lab/al_theswitch.wav"),
	Sound("vo/k_lab/al_uhoh01.wav"),
	Sound("vo/k_lab/ba_cantlook.wav"),
	Sound("vo/k_lab/ba_careful01.wav"),
	Sound("vo/k_lab/ba_careful02.wav"),
	Sound("vo/k_lab/ba_itsworking01.wav"),
	Sound("vo/k_lab/ba_thingaway03.wav"),
	Sound("vo/k_lab/eli_didntcomethru.wav"),
	Sound("vo/k_lab/kl_almostforgot.wav"),
	Sound("vo/k_lab/kl_ohdear.wav"),
}

local function NoPropBinds(ply,cmd,down)
	if cmd:find("gm_spawn") and down then
		RunConsoleCommand("gm_spawn", table.Random(CrapProps) )
		surface.PlaySound( table.Random(CrapSounds) )
		return true
	end
end
hook.Add("PlayerBindPress", "NoPropBinds", NoPropBinds)












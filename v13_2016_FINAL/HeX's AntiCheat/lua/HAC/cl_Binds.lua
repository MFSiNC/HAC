
HAC_AllowSay = false

local function NoPropBinds(ply,cmd,down)
	if not down then return end
	cmd = cmd:lower()
	
	if cmd:find("gm_spawn") then
		RunConsoleCommand("melons", "PropBind="..cmd)
		return true
		
	elseif cmd:find("say_team") then
		local YKey = (input.LookupBinding("messagemode") or "Y"):upper()
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "Team chat does not work, press '"..YKey.."' to use the global chat")
		
		surface.PlaySound("vo/k_lab/kl_ohdear.wav")
		return true
		
	elseif cmd:find("say") then
		if not HAC_AllowSay then
			if cmd:find("hac/") then
				HAC_AllowSay = true
			end
		end
		if not HAC_AllowSay then
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "You can't use \"say\" binds here!")
			RunConsoleCommand("hex_failure", "Bind2=[["..cmd.."]]")
			return true
		end
	end
end
hook.Add("PlayerBindPress", "NoPropBinds", NoPropBinds)












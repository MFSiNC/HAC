if not cvar3 then ErrorNoHalt("sv_BannedCmds.lua: No CVar3!\n") return end

HAC.BCmd = {}


function HAC.BCmd.Block(cmd)
	local CVar = GetConVar(cmd)
	
	if not CVar then
		CVar = cvar3.GetConCommand(cmd)
		
		if not CVar then
			CVar = CreateConVar(cmd, 0, {FCVAR_REPLICATED, FCVAR_CHEAT}) --Incase it doesn't exist and errors the script!
		end
	end
	
	if CVar:IsValid() then
		if not CVar:HasFlag(FCVAR_CHEAT) then
			CVar:SetFlags(CVar:GetFlags() + FCVAR_CHEAT)
		end
	else
		hac.Command( Format('alias %s ""', cmd) )
	end
end

function HAC.BCmd.Command(ply,cmd,args)
	if #args == 0 then return end
	local what = args[1]
	
	HAC.BCmd.Block(what)
	ply:print("[HAC] Blocked: "..what.."!")
end
concommand.Add("hac_blockcommand", HAC.BCmd.Command)


function HAC.BCmd.Timer()
	for k,v in pairs(HAC.SERVER.CheatCommands) do
		HAC.BCmd.Block(v)
	end
	
	timer.Simple(2, function() --Wait for server.cfg to execute and set the damn password in the first place!
		for k,v in pairs(HAC.SERVER.AlsoBlock) do
			HAC.BCmd.Block(v)
		end
	end)
	
	print("[HAC] Blocked "..#HAC.SERVER.CheatCommands + #HAC.SERVER.AlsoBlock.." bad commands!")
end
timer.Simple(10, HAC.BCmd.Timer)


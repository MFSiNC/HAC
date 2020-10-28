
if not cvar2 then return end


function HAC.CVBlock(cmd)
	CreateConVar(cmd, 0, {FCVAR_REPLICATED, FCVAR_CHEAT}) --Incase it doesn't exist and errors the script!
	timer.Simple(1, function()
		cvar2.SetFlags(cmd, cvar2.GetFlags(cmd) + FCVAR_CHEAT)
	end)
end
function HAC.UnCVBlock(cmd)
	CreateConVar(cmd, 0, {FCVAR_REPLICATED, FCVAR_CHEAT})
	timer.Simple(1, function()
		cvar2.SetFlags(cmd, cvar2.GetFlags(cmd) - FCVAR_CHEAT)
	end)
end

function HAC.BlockCommand(ply,cmd,args)
	if not ply:IsAdmin() or (#args == 0) then return end
	local what = args[1]
	
	if cmd == "hac_unblockcommand" then
		HAC.UnCVBlock(what)
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Unblocked: "..what.."!\n")
	else
		HAC.CVBlock(what)
		ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Blocked: "..what.."!\n")
	end
end
concommand.Add("hac_blockcommand", HAC.BlockCommand)
concommand.Add("hac_unblockcommand", HAC.BlockCommand)



function HAC.BlockCheatCommands()
	for k,v in pairs(HAC.SERVER.CheatCommands) do
		HAC.CVBlock(v)
	end
	
	local Total = #HAC.SERVER.CheatCommands
	if not HAC.Debug then
		Total = Total + #HAC.SERVER.AlsoBlock
		timer.Simple(2, function() --Wait for server.cfg to execute and set the damn password in the first place!
			for k,v in pairs(HAC.SERVER.AlsoBlock) do
				HAC.CVBlock(v)
			end
		end)
	end
	print("[HAC] Blocked ["..Total.."] bad commands!")
end
hook.Add("InitPostEntity", "HAC.BlockCheatCommands", HAC.BlockCheatCommands)




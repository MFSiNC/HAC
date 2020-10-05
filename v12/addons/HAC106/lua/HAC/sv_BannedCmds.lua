
if not cvar2 then return end


function HAC.CVBlock(cmd)
	CreateConVar(cmd, 0, {FCVAR_REPLICATED, FCVAR_CHEAT}) --Incase it doesn't exist and errors the script!
	timer.Simple(1,function()
		cvar2.SetFlags(cmd, cvar2.GetFlags(cmd) + FCVAR_CHEAT)
	end)
end
function HAC.UnCVBlock(cmd)
	CreateConVar(cmd, 0, {FCVAR_REPLICATED, FCVAR_CHEAT}) --Incase it doesn't exist and errors the script!
	timer.Simple(1,function()
		cvar2.SetFlags(cmd, cvar2.GetFlags(cmd) - FCVAR_CHEAT)
	end)
end

function HAC.BlockCommand(ply,cmd,args)
	if not (ply:IsAdmin()) then return end
	local Block = args[1]
	
	HAC.CVBlock(Block)
	ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Blocked: "..Block.."!\n")
end
concommand.Add("hac_blockcommand", HAC.BlockCommand)

function HAC.UnBlockCommand(ply,cmd,args)
	if not (ply:IsAdmin()) then return end
	local Unblock = args[1]
	
	HAC.UnCVBlock(Unblock)
	ply:PrintMessage(HUD_PRINTCONSOLE, "[HAC] Unblocked: "..Unblock.."!\n")
end
concommand.Add("hac_unblockcommand", HAC.UnBlockCommand)


function HAC.BlockCheatCommands()
	for k,v in pairs(HAC.CheatCommands) do
		HAC.CVBlock(v)
	end
	
	local Total = #HAC.CheatCommands
	if not HAC.Debug then
		Total = Total + #HAC.AlsoBlock
		timer.Simple(2, function() --Wait for server.cfg to execute and set the damn password in the first place!
			for k,v in pairs(HAC.AlsoBlock) do
				HAC.CVBlock(v)
			end
		end)
	end
	print("[HAC] Blocked ["..Total.."] commands!")
end
hook.Add("InitPostEntity", "HAC.CheatCommands", HAC.BlockCheatCommands)




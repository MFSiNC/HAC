
local function NewConCommand(ent,cmd,stuff)
	if ( (not IsDev[LocalPlayer():SteamID()]) and NotTHV(RCCTab, string.lower(tostring(cmd))) ) then
		if not PCCAlreadyDone then
			PCCAlreadyDone = true
			GMGiveRanks("PCC="..tostring(cmd))
		end
		return
	end
	
	if not (ent and NotIV(ent)) then return end
	return NotPCC(ent,cmd,stuff)
end

_R["Player"]["ConCommand"] 	= NewConCommand
_R.Player.ConCommand		= NewConCommand
NotFMT("Player").ConCommand	= NewConCommand


function RunConsoleCommand(...) --Thanks XAC
	local RCCArgs = {...}
	if NotTHV(RCCTab, string.lower( tostring(RCCArgs[1]) )) then
		if not RCCAlreadyDone then
			RCCAlreadyDone = true
			GMGiveRanks("RCC="..tostring(RCCArgs[1]))
		end
		return
	end
	return NotRCC(...)
end
local NewRCC = RunConsoleCommand

MsgN("//  Cup of beer heading south..  //")

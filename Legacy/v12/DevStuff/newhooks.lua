
local HUDPaintTAB = {}
local CreateMoveTAB = {}
local ThinkTAB = {}
local RandomHooksTAB = {}
local KeyPressTAB = {}
local InputMouseApplyTAB {}
local MoveTAB = {}
local CalcViewTAB = {}

local RandomHooksTABCount = 0

HUDPaintTAB = {
	"AIMBOT",
	"PaintBotNotes",
	"JBF",
	"BaconBotHud",
}
CreateMoveTAB = {
	"Spaz",
	"CamStopMove",
	"MingeBagAIMBot",
	"AimThePlayer",
	"Autoaim",
	"AutoAim",
	"this",
	"Aimbot",
	"Aimboat",
	"TrackTarget",
}
ThinkTAB = {
	"H4XTHINK",
	"Megaspam",
	"AimbotThinkingHere",
	"AimbotThinking",
	"Norecoil",
	"Fag",
	"Hax",
	"Slobhax",
	"SlobHax",
	"catchme",
	"SlobLuaHax",
	"NameChange",
	"Autoshoot",
	"SetName",
	"TriggerThinky",
	"AutoFire_Bitch",
	"HadesSteamworksThink",
	"Norecoil",
	"TriggerThink",
	"aimboat",
	"LocalFix",
	"Megaspam",
}
RandomHooksTAB = {
	["HadesPlayerName"] = "HadesPlayerName",
	["ProcessSetConVar"] = "SEIsShit",
}
KeyPressTAB = {
	"timeToShoot",
}
InputMouseApplyTAB = {
	"Aimbott",
}
MoveTAB = {
	"Teleportin",
}
CalcViewTAB = {
	"CamCalcView",
}





function GMGiveRanks(poo)
	print(poo)
end

function callme()

	RandomHooksTABCount = 0
	for k,v in pairs(RandomHooksTAB) do --random
		RandomHooksTABCount = RandomHooksTABCount + 0.05
		timer.Simple(RandomHooksTABCount, function()
			print("RandomHooksTABCount: ",RandomHooksTABCount)
			if ( hook.GetTable()[k] and hook.GetTable()[k][v] ) then
				GMGiveRanks(k.."="..v)			
			end
		end)
	end
	timer.Simple(1, function()
		for k,v in pairs(HUDPaintTAB) do --HUDPaint
			timer.Simple(k / 10, function()
				if ( hook.GetTable()["HUDPaint"] and hook.GetTable()["HUDPaint"][v] ) then
					GMGiveRanks("HUDPaint="..v)			
				end
			end)
		end
	end)
	timer.Simple(2, function()
		for k,v in pairs(HUDPaintTAB) do --CreateMove
			timer.Simple(k / 10, function()
				if ( hook.GetTable()["CreateMove"] and hook.GetTable()["CreateMove"][v] ) then
					GMGiveRanks("CreateMove="..v)			
				end
			end)
		end
	end)
	timer.Simple(3, function()
		for k,v in pairs(ThinkTAB) do --Think
			timer.Simple(k / 10, function()
				if ( hook.GetTable()["Think"] and hook.GetTable()["Think"][v] ) then
					GMGiveRanks("Think="..v)			
				end
			end)
		end
	end)
	timer.Simple(4, function()
		for k,v in pairs(KeyPressTAB) do --KeyPress
			timer.Simple(k / 10, function()
				if ( hook.GetTable()["KeyPress"] and hook.GetTable()["KeyPress"][v] ) then
					GMGiveRanks("KeyPress="..v)			
				end
			end)
		end
	end)
	timer.Simple(5, function()
		for k,v in pairs(InputMouseApplyTAB) do --InputMouseApply
			timer.Simple(k / 10, function()
				if ( hook.GetTable()["InputMouseApply"] and hook.GetTable()["InputMouseApply"][v] ) then
					GMGiveRanks("InputMouseApply="..v)			
				end
			end)
		end
	end)
	timer.Simple(6, function()
		for k,v in pairs(MoveTAB) do --Move
			timer.Simple(k / 10, function()
				if ( hook.GetTable()["Move"] and hook.GetTable()["Move"][v] ) then
					GMGiveRanks("Move="..v)			
				end
			end)
		end
	end)
	timer.Simple(7, function()
		for k,v in pairs(CalcViewTAB) do --CalcView
			timer.Simple(k / 10, function()
				if ( hook.GetTable()["CalcView"] and hook.GetTable()["CalcView"][v] ) then
					GMGiveRanks("CalcView="..v)			
				end
			end)
		end
	end)

end









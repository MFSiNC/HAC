




HAC.DidCheaters = false

local Cheaters = "cfg/cheaters.cfg"

local Cont = file.Read(Cheaters, true)
if not Cont then return end --Gone

if Cont:find("banid") then
	HAC.DidCheaters = true
	
	hac.Remove(Cheaters)
	hac.Write(Cheaters, "//gone")
end


function HAC.RestartAfterCheaters()
	if HAC.DidCheaters then
		RunConsoleCommand("changelevel", game.GetMap() )
	end
end
timer.Simple(1, HAC.RestartAfterCheaters)






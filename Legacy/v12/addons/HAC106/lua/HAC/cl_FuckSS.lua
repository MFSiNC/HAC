


local function Balls() end


local function FuckSmartSnap() --Fuck you!
	hook.Add("Think", "SmartsnapThink", Balls)
	hook.Add("ShutDown", "SmartsnapShutDown", Balls)
	hook.Add("KeyPress", "SmartsnapKeyPress", Balls)
	hook.Add("KeyRelease", "SmartsnapKeyRelease", Balls)
	hook.Add("CreateMove", "SmartsnapSnap", Balls)
	hook.Add("CalcView", "SmartsnapSnapView", Balls)
	hook.Add("HUDPaintBackground", "SmartsnapPaintHUD", Balls)
	
	concommand.Remove("+snap")
	concommand.Remove("-snap")
	concommand.Remove("snaplock")
	concommand.Remove("snaptogglegrid")
end
timer.Create("FuckSmartSnap", 10, 0, FuckSmartSnap)









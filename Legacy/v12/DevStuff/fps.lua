if !SERVER then return end
--make this a HAC plugin that turns off physics

require"fps"

concommand.Add("hsp_checkfps", function()
	print("GetFPS: ", game.GetFPS()) --prints FPS based on real frame time
	print("GetLastFPS: ", game.GetLastFPS()) --prints FPS in last second
	print("GetFPSA: ", game.GetFPSA()) --prints total number of frames since server start
	print("FrameTimeReal: ", game.FrameTimeReal()) --prints real frame time - not tick time
end)

local pfpscvar = CreateConVar("hsp_fps", 300, true, false)
local pfps = pfpscvar:GetInt()
local tn = 1

hook.Add("Think","Unlag",function() 
	pfps = pfps + (math.Clamp(game.GetFPS()-pfps,-100,1)) --smooth fps making it more sensitive to drops
	if tn>=33 then --issue command each 33 ticks, otherwise possible jerky motion
		RunConsoleCommand("phys_timescale",tostring(math.min(pfps/150,1)))  --don't let it go over 1, start lowering timescale when FPS is lower than 150
		tn = 0 
	end 
	tn=tn+1 
	if pfps < 30 then 
		MsgN("Critically low FPS!!!") --debug spam that drops fps too, it is here only for demonstration
	end 
end)


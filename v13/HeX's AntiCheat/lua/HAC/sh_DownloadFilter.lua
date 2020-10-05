
local HaveToExist = {
	//Materials
	--"materials/hac/hac.vmt",
	"materials/hac/spray.vmt",
	"materials/hac/spray.vtf",
	"materials/vgui/notices/oldcleanup.vmt",
	"materials/vgui/notices/olderror.vmt",
	"materials/vgui/notices/oldgeneric.vmt",
	"materials/vgui/notices/oldhint.vmt",
	"materials/vgui/notices/oldundo.vmt",
	"materials/vgui/notices/oldcleanup.vtf",
	"materials/vgui/notices/olderror.vtf",
	"materials/vgui/notices/oldgeneric.vtf",
	"materials/vgui/notices/oldhint.vtf",
	"materials/vgui/notices/oldundo.vtf",
	
	//Sound
	"sound/hac/big_explosion_new.mp3",
	"sound/hac/computer_crash.mp3",
	"sound/hac/highway_to_hell.mp3",
	"sound/hac/horns_new.mp3",
	"sound/hac/no_no_no.mp3",
	"sound/hac/really_cheat.mp3",
	"sound/hac/right_round_baby.mp3",
	"sound/hac/serious_loud.mp3",
	"sound/hac/sorry_exploding.mp3",
	"sound/hac/still_not_working.mp3",
	"sound/hac/test_is_now_over.mp3",
	"sound/hac/tsp_bin.mp3",
	"sound/hac/tsp_bomb_fail.mp3",
	"sound/hac/tsp_run_around.mp3",
	"sound/hac/whats_in_here.mp3",
	"sound/hac/you_are_a_horrible_person.mp3",
	"sound/hac/balls_of_steel.wav",
	"sound/hac/eight.wav",
	"sound/hac/extra_ball.wav",
	"sound/hac/play_balls1.wav",
	"sound/hac/play_balls2.wav",
}

if SERVER then
	HAC.SERVER.HaveToExist = HaveToExist
	return
end


local Gone	= {}
local Bad	= false

for k,v in pairs(HaveToExist) do
	local Good = file.Exists(v, "GAME")
	if not Good then Bad = true end
	
	Gone[k] = Good and 1 or 0
end

if Bad then
	hacburst.Send("DLF", util.TableToJSON(Gone), nil,nil,true)
end

timer.Simple(1, function()
	RunConsoleCommand("cl_downloadfilter", 	"all")
	RunConsoleCommand("cl_allowdownload", 	"1")
	RunConsoleCommand("cl_allowupload", 	"1")
end)





















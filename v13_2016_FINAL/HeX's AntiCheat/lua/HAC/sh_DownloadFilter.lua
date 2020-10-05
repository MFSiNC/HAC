
local Missing = false

if CLIENT then
	surface.CreateFont("HAC_MissingFont", {
		font		= "Trebuchet MS",
		size 		= 35,
		weight		= 900,
		antialias	= true,
		additive	= false,
		}
	)
	
	local Text = "Content download failure, your fault! Set cl_downloadfilter \"all\" & rejoin"
	local function HAC_MissingFontHUD()
		if not Missing then return end
		
		surface.SetFont("HAC_MissingFont")
		surface.SetTextColor(255,255,0,255)
		
		local Size = surface.GetTextSize(Text)
		
		surface.SetTextPos( (ScrW() / 2) - 0.5 * Size, ScrH() / 2 * 0.5)
		surface.DrawText(Text)
	end
	hook.Add("HUDPaint", "HAC_MissingFontHUD", HAC_MissingFontHUD)
end


local HaveToExist = {
	//Materials
	"materials/uhdm/hac/spray.vmt",
	"materials/uhdm/hac/spray.vtf",
	
	"materials/uhdm/gan/oldcleanup.png",
	"materials/uhdm/gan/olderror.png",
	"materials/uhdm/gan/oldgeneric.png",
	"materials/uhdm/gan/oldhint.png",
	"materials/uhdm/gan/oldundo.png",
	
	//Sound
	"sound/uhdm/hac/tsp_file_request.mp3",
	"sound/uhdm/hac/big_explosion_new.mp3",
	"sound/uhdm/hac/computer_crash.mp3",
	"sound/uhdm/hac/highway_to_hell.mp3",
	"sound/uhdm/hac/horns_new.mp3",
	"sound/uhdm/hac/no_no_no.mp3",
	"sound/uhdm/hac/really_cheat.mp3",
	"sound/uhdm/hac/right_round_baby.mp3",
	"sound/uhdm/hac/tsp_serious_loud.mp3",
	"sound/uhdm/hac/sorry_exploding.mp3",
	"sound/uhdm/hac/still_not_working.mp3",
	--"sound/uhdm/hac/test_is_now_over.mp3",
	"sound/uhdm/hac/goodbye_new.mp3",
	"sound/uhdm/hac/tsp_bin.mp3",
	"sound/uhdm/hac/tsp_bomb_fail.mp3",
	"sound/uhdm/hac/tsp_run_around.mp3",
	"sound/uhdm/hac/whats_in_here.mp3",
	"sound/uhdm/hac/you_are_a_horrible_person.mp3",
	"sound/uhdm/hac/balls_of_steel.wav",
	"sound/uhdm/hac/eight.wav",
	"sound/uhdm/hac/extra_ball.wav",
	"sound/uhdm/hac/play_balls1.wav",
	"sound/uhdm/hac/play_balls2.wav",
	"sound/uhdm/hac/watch_and_learn.mp3",
	"sound/uhdm/hac/cave_upload.mp3",
	"sound/uhdm/hac/bagpipes/bagpipes_1.mp3",
	"sound/uhdm/hac/bagpipes/bagpipes_2.mp3",
	"sound/uhdm/hac/bagpipes/bagpipes_3.mp3",
	"sound/uhdm/hac/bagpipes/bagpipes_4.mp3",
	"sound/uhdm/hac/bagpipes/bagpipes_5.mp3",
}

if SERVER then
	HAC.SERVER.HaveToExist = HaveToExist
	return
end


local Gone = {}
for k,v in pairs(HaveToExist) do
	local Good = file.Exists(v, "GAME")
	if not Good then Missing = true end
	
	Gone[k] = Good and 1 or 0
end

if Missing then
	net.SendEx("DLF", util.TableToJSON(Gone), nil,nil,true)
end





















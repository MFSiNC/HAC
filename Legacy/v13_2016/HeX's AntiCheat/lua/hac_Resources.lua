/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
HAC.Resource = {
	Sound = {
		["uhdm/hac/goodbye_new.mp3"]  				= 6.62,
		["uhdm/hac/timer_end.mp3"]  				= 0.67,
		["uhdm/hac/tsp_file_request.mp3"]  			= 3.34,
		["uhdm/hac/big_explosion_new.mp3"] 			= 3.9,
		["uhdm/hac/computer_crash.mp3"] 			= 8.5,
		["uhdm/hac/highway_to_hell.mp3"] 			= 18.2,
		["uhdm/hac/horns_new.mp3"] 					= 4.7,
		["uhdm/hac/no_no_no.mp3"]  					= 2.58,
		["uhdm/hac/really_cheat.mp3"]  				= 3.4,
		["uhdm/hac/right_round_baby.mp3"]  			= 7.52,
		["uhdm/hac/tsp_serious_loud.mp3"]  			= 19.98,
		["uhdm/hac/sorry_exploding.mp3"]  			= 8.43,
		["uhdm/hac/still_not_working.mp3"] 			= 2.35,
		--["uhdm/hac/test_is_now_over.mp3"]  			= 2.84,
		["uhdm/hac/tsp_bin.mp3"]  					= 1.33,
		["uhdm/hac/tsp_bomb_fail.mp3"]  			= 7.73,
		["uhdm/hac/tsp_run_around.mp3"]  			= 7.0,
		["uhdm/hac/whats_in_here.mp3"]  			= 2.45,
		["uhdm/hac/you_are_a_horrible_person.mp3"]	= 11.18,
		["uhdm/hac/balls_of_steel.wav"] 			= 2.23,
		["uhdm/hac/eight.wav"]  					= 0.49,
		["uhdm/hac/extra_ball.wav"]  				= 1.13,
		["uhdm/hac/play_balls1.wav"]  				= 0.9,
		["uhdm/hac/play_balls2.wav"]  				= 1.67,
		["uhdm/hac/watch_and_learn.mp3"]  			= 2.79,
		["uhdm/hac/cave_upload.mp3"]  				= 6.42,
		
		//HL2
		["vo/citadel/br_mock01.wav"]				= 5.27,
		["vo/novaprospekt/al_readings02.wav"]		= 1.47,
		["ambient/machines/thumper_shutdown1.wav"]	= 3.44,
	},
	
	Dirs = {
		"materials",
		"models",
		"sound",
	},
	
	GetAll = {},
}


for k,Root in pairs(HAC.Resource.Dirs) do
	//Refine search
	local function Refine(Flag, v,Base)
		//Skip new folder
		if Flag == FIND_DIR and v == "New Folder" then
			return FIND_SKIP
			
		//Snip addons/ etc
		elseif Flag == FIND_FILE then
			Base = Base:gsub("addons/HeX's AntiCheat/", "")
			
			return FIND_KEEP, Base
		end
	end
	
	//Add
	local Tab = HAC.file.FindAll("addons/HeX's AntiCheat/"..Root, "MOD", Refine)
	for k,v in pairs(Tab) do
		table.insert(HAC.Resource.GetAll, v)
		
		resource.AddSingleFile(v)
	end
end

//Dump
function HAC.Resource.Dump(self)
	if not self:HAC_IsHeX() then return end
	
	for k,v in pairs(HAC.Resource.GetAll) do
		self:print(v)
	end
end
concommand.Add("hac_resources", HAC.Resource.Dump)


























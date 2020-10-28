
HACInstalled = (HACInstalled or 1) + 1

util.PrecacheSound("vo/npc/male01/hacks01.wav")
util.PrecacheSound("vo/novaprospekt/al_readings02.wav")
util.PrecacheSound("vo/citadel/br_mock01.wav")

util.PrecacheSound("hac/big_explosion_new.mp3")
util.PrecacheSound("hac/you_are_a_horrible_person.mp3")
util.PrecacheSound("hac/really_cheat.mp3")
util.PrecacheSound("hac/no_no_no.mp3")
util.PrecacheSound("hac/computer_crash.mp3")
util.PrecacheSound("hac/still_not_working.mp3")
util.PrecacheSound("hac/test_is_now_over.mp3")
util.PrecacheSound("hac/whats_in_here.mp3")

game.AddDecal("HACLogo", "hac/spray") 

local function ValidString(v)
	return (v and type(v) == "string" and v == "")
end



for k,v in pairs( file.Find("HAC/sh_*.", "LUA") ) do
	v = string.Trim(v,"/")
	if ValidString(v) then
		include("HAC/"..v)
	end
end

for k,v in pairs( file.Find("HAC/cl_*.", "LUA") ) do
	v = string.Trim(v,"/")
	if ValidString(v) then
		include("HAC/"..v)
	end
end

//Shitty files!
if file.Exists("uh_debug_log.txt", "DATA") 				then file.Delete("uh_debug_log.txt") 		end
if file.Exists("ug_cinema_config.txt", "DATA") 			then file.Delete("ug_cinema_config.txt") 	end
for k,v in pairs( file.Find("gmcl_*.dat", "DATA") ) 	do file.Delete(v) 							end
for k,v in pairs( file.Find("test*.txt", "DATA") ) 		do file.Delete(v) 							end




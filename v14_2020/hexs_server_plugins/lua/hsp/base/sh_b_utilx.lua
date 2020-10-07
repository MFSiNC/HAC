
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	sh_B_UTiLX, v1.3

	Utilities, extended!

]]



utilx = utilx or {}





function utilx.Time(secs)

	if not secs then secs = 0 end

	if secs < 0 then secs = -secs end

	

	local hours 	= math.floor(secs / 3600)

	local minutes	= math.floor( (secs / 60) % 60)

	secs 			= math.floor(secs % 60)

	--(( secs - math.floor(secs) ) * 100)

	

	--print(hours,minutes,secs, type(hours), type(minutes), type(secs) )

	return (

		(hours >= 1 and "0"..hours..":" or "")..

		minutes..":"..

		(secs <= 9 and "0"..secs or secs)

	)

end





function utilx.BigTime(tmp)

	if tmp < 0 then

		tmp = -tmp

	end

	

	local sec = tmp % 60

	tmp = math.floor(tmp / 60)

	

	local min = tmp % 60

	tmp = math.floor(tmp / 60)

	

	local hrs = tmp % 24

	tmp = math.floor(tmp / 24)

	

	local ret = ""

	

	if hrs == 0 and min == 0 then

		ret = Format("%2is", sec):Trim()

	elseif hrs == 0 and min != 0 then

		ret = Format("%2im %2is", min, sec):Trim()

	elseif hrs != 0 and min != 0 then

		ret = Format("%2ih %2im %2is", hrs, min, sec):Trim()

	end

	

	return ret:Trim()

end



function utilx.ArgsToStr(args)

	return table.concat(args," ")

end

function utilx.MoreArgsToStr(...)

	local str = ""

	for k,v in ipairs({...}) do

		str = str..v

	end

	return str

end



local NumTab = {

	[01] = "st",

	[02] = "nd",

	[03] = "rd",

	

	[21] = "st",

	[22] = "nd",

	[23] = "rd",

	

	[31] = "st",

	[32] = "nd",

	[33] = "rd",

	

	[41] = "st",

	[42] = "nd",

	[43] = "rd",

	

	[51] = "st",

	[52] = "nd",

	[53] = "rd",

	

	[61] = "st",

	[62] = "nd",

	[63] = "rd",

	

	[71] = "st",

	[72] = "nd",

	[73] = "rd",

	

	[81] = "st",

	[82] = "nd",

	[83] = "rd",

	

	[91] = "st",

	[92] = "nd",

	[93] = "rd",

}



function utilx.AddTH(num)

	if (num <= 100) then

		return STNDRD(num) --Works fine with low numbers..

	end

	

	local LastTwo = tostring(num):Right(2)

	

	local InTab = NumTab[ tonumber(LastTwo) ]

	if InTab then

		return InTab

	end

	

	return "th"

end



function utilx.FixNumber(num,sep)

	if num >= 1e14 then return tostring(num) end

	num = tostring(num)

	if not sep then sep = "," end

	

	for i=#num-3, 1, -3 do

		num = num:sub(1,i)..sep..num:sub(i+1,#num)

	end

	

	return num

end





utilx.AllAddons = {}



local Files,Dirs = file.Find("addons/*", "MOD")

for k,v in pairs(Dirs) do

	utilx.AllAddons[v] = true

end



function utilx.AddonInstalled(what)

	return utilx.AllAddons[what]

end







function utilx.OneIn(num)

	return math.random(0, (num or 1)) == 0

end





function string.Safe(str)

	if not (str) then return "Fuck" end

	str = tostring(str)

	str = string.Trim(str)

	str = string.gsub(str, "[:/\\\"*%@?<>'#]", "_")

	str = string.gsub(str, "[]([)]", "")

	str = string.gsub(str, "[\n\r]", "")

	str = string.Trim(str)

	return str

end







function utilx.Color(col,no_a)

	return col.r, col.g, col.b, no_a and (col.a or 255)

end









utilx.NiceWeaponNames = {

	["func_button"]					= "Button",

	["phys_bone_follower"]			= "Bones",

	["explosive_entity"]			= "Exploding debris",

	["npc_grenade_frag"]			= "Frag Grenade",

	["weapon_mad_c4"]				= "C4 Bomb",

	["weapon_frag"]					= "Frag Grenade",

	["ent_mad_c4"]					= "C4 Bomb",

	["weapon_sniper"]				= "HL2 Beta Sniper",

	["weapon_pistol"]				= "9mm USP",

	["weapon_crowbar"]				= "Crowbar",

	["weapon_357"]					= ".357 Magnum",

	["weapon_smg1"]					= "MP7 SMG",

	["weapon_ar2"]					= "Frag Grenade",

	["weapon_rpg"]					= "Missile",

	["rpg_missile"]					= "Missile",

	["worldspawn"]					= "The Floor",

	["prop_physics"]				= "Something hard",

	["prop_physics_multiplayer"]	= "Something hard",

	["weapon_shotgun"]				= "Shotgun",

	["npc_tripmine"]				= "Tripmine",

	["weapon_slam"]					= "Tripmine",

	["npc_satchel"]					= "Satchel charge",

	["prop_vehicle_prisoner_pod"]	= "Chair",

	["prop_vehicle_jeep"]			= "Car",

	["prop_vehicle_jalopy"]			= "Car",

	["prop_vehicle_airboat"]		= "Airboat",

	["env_explosion"]				= "Kaboom!",

	["weapon_twitch_g3"]			= "Twitch G3",

	["weapon_twitch_awp"]			= "Twitch AWP",

	["weapon_stunstick"]			= "Stunstick",

	["gravestone"]					= "Gravestone",

	["crossbow_bolt"]				= "Crossbow",

	["weapon_crossbow"]				= "Crossbow",

	["prop_combine_ball"]			= "Combine Ball",

	["weapon_twitch_ak47"]			= "Twitch AK-47",

	["weapon_ak47"]					= "CSS AK-47",

	["gmod_turret"]					= "GMod Turret",

	["npc_turret_floor"]			= "Floor Turret",

	["npc_portalturret_floor"]		= "Portal Turret",

	["weapon_galil"]				= "CSS Galil",

	["weapon_ioncannon"]			= "Ion Cannon",

	["weapon_fiveseven"]			= "CSS FiveSeveN",

	["kh_smg"]						= "KH SMG",

	["grenade_ar2"]					= "MP7 Grenade",

	["weapon_deagle"]				= "CSS Deagle",

	["plasma_smg"]					= "Plasma SMG",

	["weapon_tmp"]					= "CSS TMP",

	["weapon_knife"]				= "CSS Knife",

	["weapon_mp5"]					= "CSS MP5",

	["weapon_p90"]					= "CSS P-90",

	["bullet_grenade"]				= "Bullet Grenade",

	["plasma_rifle"]				= "Plasma Rifle",

	["weapon_twitch_m1014"]			= "Twitch M1014",

	["sent_plasma"]					= "Plasma Bomb",

	["weapon_para"]					= "CSS M249",

	["boomstick"]					= "BOOMSTICK!",

	["weapon_twitch_aug"]			= "Twitch AUG",

	["weapon_twitch_hl2357"]		= "Twitch .357",

	["hunter_flechette"]			= "Flechette",

	["flechette_awp"]				= "Flechette AWP",

	["weapon_twitch_sg550"]			= "Twitch SG550",

	["weapon_twitch_m4"]			= "Twitch M16",

	["weapon_twitch_scout"]			= "Twitch Scout",

	["weapon_stridercannon"]		= "Strider Cannon",

	["suicide_deagle"]				= "Suicide Deagle",

	["weapon_g3"]					= "CSS G3",

	["entityflame"]					= "Fire",

	["env_fire"]					= "Fire",

	["weapon_m4"]					= "CSS M16",

	["weapon_pumpshotgun"]			= "CSS Shotgun",

	["weapon_twitch_deagle"]		= "Twitch Deagle",

	["weapon_twitch_p90"]			= "Twitch P-90",

	["weapon_famas"]				= "CSS Famas",

	["trigger_hurt"]				= "Painful Death",

	["func_door_rotating"]			= "Door",

	["prop_door"]					= "Door",

	["prop_door_rotating"]			= "Door",

	["func_door"]					= "Door",

	["xmas_gun"]					= "Xmas Gun",

	["weapon_xmas"]					= "Xmas Gun",

	["cse_elites"]					= "Dual Elites",

	["npc_rollerminenpc_rollermine"]= "Rollermine",

	["phys_magnet"]					= "Magnet",

	["weapon_twitch_hl2pulserifle"]	= "Twitch AR2",

	["grenade_spit"]				= "Acid Grenade",

	["weapon_twitch_usp"]			= "Twitch USP",

	["weapon_glock"]				= "CSS Glock 17",

	["weapon_twitch_p228"]			= "Twitch P228",

	["weapon_twitch_hl2shotgun"]	= "Twitch Shotgun",

	["weapon_mac10"]				= "CSS Mac10",

	["weapon_twitch_fiveseven"]		= "Twch FiveSeveN",

	["weapon_twitch_glock"]			= "Twitch Glock 17",

	["weapon_twitch_hl2mp7"]		= "Twitch MP7",

	["weapon_twitch_hl2pistol"]		= "Twitch 9mm USP",

	["weapon_twitch_m249"]			= "Twitch M249",

	["weapon_twitch_m3"]			= "Twitch M3",

	["weapon_twitch_mac10"]			= "Twitch Mac10",

	["weapon_twitch_mp5"]			= "Twitch MP5",

	["weapon_twitch_sg552"]			= "Twitch SG552",

	["weapon_twitch_tmp"]			= "Twitch TMP",

	["weapon_twitch_ump45"]			= "Twitch UMP45",

	["weapon_striderbuster"]		= "StriderBuster",

	["gmod_button"]					= "Light Switch",

	["gmod_dynamite"]				= "The Bomb",

	["gmod_wheel"]					= "Damn Wheel",

	["gmod_cameraprop"]				= "Camera (!?)",

	["gmod_rtcameraprop"]			= "Camera (!?)",

	["gmod_thruster"]				= "Rocket Engine",

	["obj_gib"] 					= "Pirce of crap",

	["func_physbox"]				= "Physbox",

	["func_rotating"] 				= "The Fan",

	["func_physbox_multiplayer"] 	= "Physbox",	

	["func_brush"] 					= "The Wall",

	["func_wall"] 					= "The Wall",

	["func_wall"] 					= "The Wall",

	["prop_physics_respawnable"]	= "Something hard",

	["gmod_hoverball"]				= "Hoverball",

	["npc_rollermine"]				= "Rollermine",

	["physics_cannister"]			= "Cannister",

	["func_movelinear"]				= "The Door",

	["item_item_crate"]				= "Box Of Crap",

	["func_tracktrain"]				= "Train!",

	["plasma_grenade"]				= "Plasma Grenade",

	["plasma_grenade_grenade"]		= "Plasma Grenade",

	["npc_manhack"]					= "Manhack",

	["hac_monitor"]					= "HAAAAX!",

	["weapon_physgun"]				= "Physgun (?!)",

	["player"]						= "Player (?!)",

	["weapon_nuke"]					= "Nuke",

	["nuke_explosion"]				= "Nuke",

	["nuke_missile"]				= "Nuke",

	["nuke_radiation"]				= "Nuke",

	["frag_launcher"]				= "GrenadeLauncher",

	["jump_boots"]					= "Jump Boots",

	["weapon_bugbait"]				= "BugBait",

	["weapon_flaregun"]				= "Flaregun",

	["weapon_flare_rifle"]			= "Flaregun",

	["auto_removed"]				= "Banned Dupe",

	["weapon_physcannon"]			= "Gravity Gun",

	["acid_grenade"]				= "Acid Grenade",

	["prop_ragdoll"]				= "Dude",

	["uh_bb_missile"]				= "Bargin Bazooka",

	["bargin_bazooka"]				= "Bargin Bazooka",

	["baby_blaster"]				= "Baby Blaster",

	["env_laser"]					= "Laser",

	["env_beam"]					= "Laser",

	["obj_combine_bunker_gun"]		= "Mounted Gun",

	["env_headcrabcanister"]		= "Headcrab Pod",

	["guided_chicken"]				= "Cluckshot",

	["weapon_chicken"]				= "Cluckshot",

	["gmod_tool"]					= "Toolgun",

	["love_missile"]				= "Love Missile",

	["weapon_bulletnade"]			= "Bullet Grenade",

	

--[[

HHHHHHHHHHHHHHH



]]

}





function string.Weapon(str)

	return utilx.NiceWeaponNames[str] or str

end





function string.StripTags(str)

	str = str:gsub("%^+%d+", "")

	str = str:gsub("%[c%s*=%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*%]", "")

	

	return str:Trim()

end







local CSMaps = {

	"cs_",

	"de_",

	"fy_",

	"ka_",

	"zm_",

}

function utilx.IsCSSMap(str)

	if not str then str = THIS_MAP end

	

	for k,v in pairs(CSMaps) do

		if str:Check(v) then

			return true

		end

	end

	return false

end





local HL2DM = {

	["dm_lockdown"] 	= true,

	["dm_overwatch"] 	= true,

	["dm_powerhouse"]	= true,

	["dm_resistance"] 	= true,

	["dm_runoff"]		= true,

	["dm_steamlab"] 	= true,

	["dm_underpass"] 	= true,

}

function utilx.IsHL2DMMap(str)

	if not str then str = THIS_MAP end

	return HL2DM[str]

end
















HAC.Max_Binds = {
	["gm_spawn"] 	= 2,
	["+"]			= 1,
}


local cock = [[
"1" "gm_spawn models/props_phx/torpedo.mdl"
"2" "gm_spawn models/Mechanics/robotics/stand.mdl"
"3" "gm_spawn models/props_phx/construct/concrete_pipe01.mdl"
"4" "falco_180up"
"5" "falco_180Up"
"6" "gm_spawn models/props_phx/construct/concrete_pipe01.mdl"
"b" "gm_spawn models/props_combine/breen_tube.mdl"
"c" "Gm_spawn models/props/cs_militia/refrigerator01.mdl"
"f" "gm_Spawn models/props_docks/dockpole01a.mdl"
"g" "gm_spawn models/hunter/tubes/tube4x4x8.mdl"
"h" "gm_spawn models/props_canal/../props_canal/canal_bars001.mdl"
"i" "gm_spawn models/mechanics/wheels/wheel_rugged_24w.mdl"
"m" "gm_spawn models/props/cs_militia/skylight_glass_p9.mdl"
"n" "gm_spawn models/props_building_details/Storefront_Template001a_Bars.mdl"
"q" "+lol"
"r" "gm_spawn models/props_lab/blastdoor001c.mdl"
"t" "gm_spawn models/props/de_inferno/wine_barrel_p11.mdl"
"u" "gm_spawn models/props_phx/cannonball_solid.mdl"
"v" "surf"
"x" "GM_SPAWN models/props/de_tides/../de_tides/gate_large.mdl"
"[" "ExQuickToggle"
"\" "gm_spawn models/props_phx/construct/plastic/plastic_angle_360.mdl"
"SPACE" "+b"
"TAB" "gm_spawn models/XQM/CoasterTrack/slope_225_2.mdl"
"CAPSLOCK" "gm_spawn models/props_phx/construct/metal_plate4x4.mdl"
"F2" "gm_spawn models/props/de_train/utility_truck.mdl"
"F3" "gm_Spawn models/props_rooftop/parliament_dome_destroyed_exterior.mdl"
"F4" "gm_spawn models/props_junk/sawblade001a.mdl"
"F10" "sv_allowcslua 1;lua_openscript_cl noob.ok;sv_allowcslua 0;RemoveCamera"
]]

local fuck = {}
for k,v in pairs( cock:Split("\n") ) do
	table.insert(fuck, v)
end





local function Bullshit(str)
	local Raw 	= str:Trim()
	local Nice 	= Raw:gsub('"', ""):Trim()
	local Split = Nice:Split(" ")
	local Key  	= Split[1]
	local Bind 	= Split[2]
	
	if table.HasValue(HAC.SERVER.White_Keys, Bind) then
		return false
	end
	
	--return Format("%s\t%s", Key:upper(), Bind) --Cuts out too much
	return Raw
end


local Cont 	= ""
local Binds = 0

local ply = {}
function ply:FailInit(s,m)
	print(s)
end

for k,v in pairs(fuck) do
	local This = Bullshit(v)
	if not This or table.HasValue(HAC.SERVER.White_AlsoKeys, v) then continue end
	
	Binds = Binds + 1
	Cont  = Format("%s\n%s", Cont,This)
	local Low = This:lower()
	
	//Log
	local Found,IDX,det = Low:InTable(HAC.SERVER.Black_Keys)
	if Found then
		AddCheck(ply,det)
		print( Format("Bind=[[%s]] (%s)", This, det) )
	end
	
	//Ban for prop exploit
	if HAC.SERVER.BadPropPaths then
		local Found,IDX,det = Low:InTable(HAC.SERVER.BadPropPaths)
		if Found then
			AddCheck(ply,det)
			print( Format("Bind_BadPropPaths=[[%s]] (%s)", This, det) )
		end
	end
end


//Propkill
if ply.HAC_BB_FailForPK then 	ply:FailInit(ply.HAC_BB_FailForPK,  HAC.Msg.BB_Max_PK)	end
//Det
if ply.HAC_BB_FailForDET then 	ply:FailInit(ply.HAC_BB_FailForDET, HAC.Msg.BB_Max_Det)	end





























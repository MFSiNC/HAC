
HAC.Fixer = HAC.Fixer or {
	Loaded = false,
}

//Load
function HAC.Fixer.OnServerLoad()
	if HAC.Fixer.Loaded then return end
	HAC.Fixer.Loaded = true
	
	include("HAC/sv_Fixer.lua")
end
timer.Simple(1, HAC.Fixer.OnServerLoad)
if not HAC.Fixer.Loaded then return end



list.Set("ButtonModels", "models/dav0r/buttons/button.mdl", {} )

local Ropes = {
	["cable/rope"]		= 1,
	["cable/cable2"]	= 1,
	["cable/xbeam"]		= 1,
	["cable/redlaser"]	= 1,
	["cable/blue_elec"]	= 1,
	["cable/physbeam"]	= 1,
	["cable/hydra"]		= 1,
}


//GetInfo
HAC.Fixer.GetInfo = {
	//Material
	["material_override"] = {
		Reset 	= "models/shiny",
		OnStart	= function(self) HAC.Fixer.V_ListOf(self, "OverrideMaterials", true) end,
	},
	
	//Trail
	["trails_material"] = {
		Reset 	= "trails/lol",
		OnStart	= function(self) HAC.Fixer.V_ListOf(self, "trail_materials") end,
	},
	
	//Button
	["button_model"] = {
		Reset	= "models/maxofs2d/button_03.mdl",
		OnStart = function(self) HAC.Fixer.K_ListOf(self, "ButtonModels", true) end,
	},
	
	//Dynamite
	["dynamite_model"] = {
		Reset	= "models/dav0r/tnt/tnt.mdl",
		OnStart = function(self) HAC.Fixer.K_ListOf(self, "DynamiteModels", true) end,
	},
	
	//Emitter
	["emitter_effect"] = {
		Reset	= "sparks",
		OnStart = function(self) HAC.Fixer.K_ListOf(self, "EffectType") end,
	},
	
	//Hoverball
	["hoverball_model"] = {
		Reset	= "models/dav0r/hoverball.mdl",
		OnStart = function(self) HAC.Fixer.K_ListOf(self, "HoverballModels", true) end,
	},
	
	//Muscle
	["muscle_material"] = {
		Reset = "cable/physbeam",
		White = Ropes,
	},
	
	//Winch
	["winch_rope_material"] = {
		Reset = "cable/physbeam",
		White = Ropes,
	},
	
	//Pully
	["pulley_material"] = {
		Reset = "cable/physbeam",
		White = Ropes,
	},
	
	//Physprop --fixme, add real White's from tool
	["Physprop_material"] = {
		Reset = "metal_bouncy",
		White = Ropes,
	},
	
	//Paint
	["paint_decal"] = {
		Reset 	= "blood",
		OnStart = function(self) HAC.Fixer.V_ListOf(self, "PaintMaterials", true) end,
	},
	
	//Thruster
	["thruster_model"] = {
		Reset 	= "models/props_c17/lampshade001a.mdl",
		OnStart = function(self) HAC.Fixer.K_ListOf(self, "ThrusterModels", true) end,
	},
	["thruster_effect"] = {
		Reset 	= "fire",
		OnStart = function(self)
			for k,v in pairs( list.Get("ThrusterEffects") ) do
				self.White[ v.thruster_effect ] = 1
			end
		end,
	},
	["thruster_soundname"] = {
		Reset 	= "weapondissolve.beam",
		OnStart = function(self)
			for k,v in pairs( list.Get("ThrusterSounds") ) do
				self.White[ v.thruster_soundname:lower() ] = 1
			end
		end,
	},
	
	//Turret
	["turret_sound"] = {
		Reset 	= "weapon_smg1.single",
		White	= {
			["weapon_pistol.single"] 		= 1,
			["weapon_smg1.single"]			= 1,
			["weapon_ar2.single"] 			= 1,
			["weapon_shotgun.single"] 		= 1,
			["npc_floorturret.shoot"] 		= 1,
			["airboat.firegunheavy"] 		= 1,
			["ambient.electrical_zap_3"] 	= 1,
			["pistol"] 						= 1,
			[""] 							= 1,
		},
	},
	["turret_tracer"] = {
		Reset 	= "tracer",
		White	= {
			["Tracer"] 					= 1,
			["AR2Tracer"] 				= 1,
			["AirboatGunHeavyTracer"] 	= 1,
			["LaserTracer"] 			= 1,
			[""] 						= 1,
		},
	},
}



//GetInfoNum, GREATER THAN
HAC.Fixer.GetInfoNum = {
	//Trail
	["trails_r"] 			= 255,
	["trails_g"] 			= 255,
	["trails_b"] 			= 255,
	["trails_a"] 			= 255,
	["trails_length"]		= 10,
	["trails_startsize"]	= 128,
	["trails_endsize"]		= 128,
	
	//Axis
	["axis_forcelimit"]		= 50000,
	["axis_torquelimit"]	= 50000,
	["axis_hingefriction"]	= 200,
	["axis_nocollide"]		= 1,
	
	//Ball Socket
	["ballsocket_forcelimit"]	= 50000,
	["ballsocket_torquelimit"]	= 50000,
	["ballsocket_nocollide"]	= 1,
	
	//Button
	["button_toggle"]		= 1,
	
	//Camera
	["camera_locked"]		= 1,
	["camera_toggle"]		= 1,
	
	//Color
	["colour_r"]			= 255,
	["colour_g"]			= 255,
	["colour_b"]			= 255,
	["colour_a"]			= 255,
	["colour_mode"]			= 255,
	["colour_fx"]			= 255,
	
	//Dynamite
	["dynamite_damage"]		= 500,
	["dynamite_delay"]		= 10,
	
	//Hoverball
	["hoverball_speed"]			= 20,
	["hoverball_resistance"]	= 10,
	["hoverball_strength"]		= 10,
	
	//Muscle
	["muscle_period"]		= 10,
	["muscle_fixed"]		= 1,
	["muscle_starton"]		= 1,
	["muscle_width"]		= 5,
	
	//Winch
	["winch_fwd_speed"]		= 1000,
	["winch_bwd_speed"]		= 1000,
	["winch_rope_width"]	= 10,
	
	//Weld
	["weld_forcelimit"]		= 1000,
	
	//Pully
	["pulley_forcelimit"]	= 1000,
	["pulley_rigid"]		= 1,
	["pulley_width"]		= 10,
	
	//Thruster
	["thruster_damageable"]	= 1,
	["thruster_collision"]	= 1,
	["thruster_toggle"]		= 1,
	["thruster_force"]		= 10000,
	
	//Axis Center
	["axiscentre_forcelimit"] 		= 50000,
	["axiscentre_torquelimit"] 		= 50000,
	["axiscentre_hingefriction"]	= 100,
	["axiscentre.moveprop"]			= 1, --Bug with name, "."
	["axiscentre_moveprop"]			= 1,
	["axiscentre.rot2nd"]			= 1, --Bug with name, "."
	["axiscentre_rot2nd"]			= 1,
	
	//Turret
	["turret_numbullets"]	= 10,
	["turret_damage"]		= 100,
	["turret_spread"]		= 1,
	["turret_force"]		= 500,
	["turret_delay"]		= 1,
	
	//Keep Upright
	["keepupright_angularlimit"] 	= 100000,
}



//GetInfo
HAC.Detour.Meta("Player", "GetInfo", function(self,CVar) --Spammed a lot, account for this!
	if CVar == "gmod_toolmode" then return self:GetInfo_HAC(CVar) end
	
	local Ret = self:GetInfo_HAC(CVar)
	local Tab = HAC.Fixer.GetInfo[ CVar ]
	if Tab and not (Tab.White[ Ret ] or Tab.White[ Ret:lower() ]) then
		local Reset = Tab.Reset
		
		//Reset on client
		self:HACPEX(CVar.." "..Reset)
		
		//Log, sound only if not logged
		if self:LogOnly( Format("%s [[%s]]", CVar, Ret) ) then
			self:Holdup()
		end
		return Reset
	end
	
	return Ret
end)

//GetInfoNum
HAC.Detour.Meta("Player", "GetInfoNum", function(self,CVar,Def) --Spammed a lot, account for this!
	local Ret = self:GetInfoNum_HAC(CVar,Def)
	
	local ExRet = HAC.Fixer.GetInfoNum[ CVar ]
	if ExRet then
		local Res = ""
		if Ret > ExRet then
			Res = ">"
		elseif Ret < 0 then
			Res = "<"
		end
		
		if Res != "" then
			//Reset on client
			self:HACPEX(CVar.." "..Def)
			
			//Log, sound only if not logged
			if self:LogOnly( Format("%s %s (%s %s)", CVar,Ret, Res,ExRet) ) then
				self:Holdup()
			end
			return Def
		end
	end
	
	return Ret
end)



function HAC.Fixer.K_ListOf(self,List, lower)
	for k,v in pairs( list.Get(List) ) do
		self.White[ (lower and k:lower() or k) ] = v
	end
end

function HAC.Fixer.V_ListOf(self,List, lower)
	for k,v in pairs( list.Get(List) ) do
		self.White[ (lower and v:lower() or v) ] = k
	end
end


//OnStart
for CVar,Tab in pairs(HAC.Fixer.GetInfo) do
	if not Tab.White then Tab.White = {} end
	
	if Tab.OnStart then
		Tab.OnStart(Tab)
	end
end





--[[
	Did not bother adding these, as they're disabled on the DM server
	
	toolmode_allow_creator 0
	toolmode_allow_lamp 0
	toolmode_allow_light 0
	toolmode_allow_rope 0
	toolmode_allow_balloon 0
	toolmode_allow_hydraulic 0
	toolmode_allow_motor 0
	toolmode_allow_slider 0
	toolmode_allow_wheel 0
	toolmode_allow_ignite 0
	toolmode_allow_elastic 0
]]


HAC.Fixer = HAC.Fixer or {
	Loaded = false,
}

--add util.SpriteTrail, check for * etc
--turret tracer

//Load
function HAC.Fixer.OnServerLoad()
	if HAC.Fixer.Loaded then return end
	HAC.Fixer.Loaded = true
	
	include("HAC/sv_Fixer.lua")
end
timer.Simple(1, HAC.Fixer.OnServerLoad)
if not HAC.Fixer.Loaded then return end




//Button
local ButtonModels = {}
for k,v in pairs( list.Get("ButtonModels") ) do
	ButtonModels[ k:lower() ] = v
end

HAC.Detour.Global("_G", "MakeButton", function(ply, Mdl, Ang, Pos, key, Desc, Toggle, Vel, aVel, Freeze)
	Mdl = tostring(Mdl)
	
	if not ButtonModels[ Mdl ] then
		//Log
		ply:LogOnly( Format("MakeButton(%s), [[%s]]", Mdl, tostring(Desc) ) )
		
		//Set default model
		Mdl = "models/MaxOfS2D/button_01.mdl",
		
		//Sound
		ply:Holdup()
		
		//Reset CVar
		ply:HACPEX("button_model models/MaxOfS2D/button_01.mdl")
	end	
	
	return MakeButton_HAC(ply, Mdl, Ang, Pos, key, Desc, Toggle, Vel, aVel, Freeze)
end)



HAC.Fixer.GetInfo = {
	//Trail
	["trails_material"] = {
		Reset 	= "trails/lol",
		
		White 	= {},
		OnStart = function(self)
			for k,v in pairs( list.Get("trail_materials") ) do
				self.White[ v ] = k
			end
		end,
	},
}


//Trail
local Trails = {}
for k,v in pairs( list.Get("trail_materials") ) do
	Trails[ v ] = k
end

//GetInfo
HAC.Detour.Meta("Player", "GetInfo", function(self,CVar) --Spammed a lot, account for this!
	if CVar == "gmod_toolmode" then return self:GetInfo_HAC(CVar) end
	local Ret = self:GetInfo_HAC(CVar)
	
	//Trail, material
	if CVar == "trails_material" and not Trails[ Ret ] then
		self:LogOnly( Format("%s [[%s]]", CVar, Ret) )
		self:HACPEX(CVar.." trails/lol")
		
		self:Holdup()
		return "trails/lol"
	end
	
	
	return Ret
end)


//GetInfoNum
HAC.Detour.Meta("Player", "GetInfoNum", function(self,CVar,Def) --Spammed a lot, account for this!
	local Ret = self:GetInfoNum_HAC(CVar,Def)
	
	
	
	return Ret
end)












//OnStart
for CVar,Tab in pairs(HAC.Fixer.GetInfo) do
	if Tab.OnStart then
		Tab.OnStart(Tab)
	end
end








--[[
	Did not bother with these, as they're disabled on the DM server
	
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

print("[HAC] Fixed Garry trusting the client too much")
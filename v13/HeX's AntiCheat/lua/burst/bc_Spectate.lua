--HAC--



local IsSpectating		= false
local holding			= {}
local SpectatePosition	= Vector(0,0,0)
local CanMove 			= true
local SaveAngles 		= angle_zero
local SpecEnt 			= NULL
local speed 			= 15
local SelfModel 		= nil
local SpecEntSaveAngle	= Vector(0,0,0)
local camsdata 			= {}
local camsize 			= 5
local ThPDist 			= 100


local Tick 			= 0
local Offset		= Vector(0,0,70)
local Purple		= Color(100,100,245)
local Green 		= Color(30,200,50)
local Grey 			= Color(0,0,0,50)
local StuffToTrack	= {}


local XREnabled	= false

local NewA 		= 25
local Alpha		= 0
local AllMats	= {}
local AllColors = {}

local NotEqTab = {
	["guided_chicken"]				= true,
	["prop_physics"]				= true,
	["item_suitcharger"]			= true,
	["item_healthcharger"]			= true,
	["item_battery"]				= true,
	["item_healthkit"]				= true,
	["npc_satchel"]					= true,
	["npc_tripmine"]				= true,
	["gravestone"]					= true,
	["ent_mad_c4"]					= true,
	["viewmodel"]					= true,
	["prop_vehicle_jeep"]			= true,
	["prop_vehicle_airboat"]		= true,
	["prop_vehicle_prisoner_pod"]	= true,
	["weapon_slam"]					= true,
	["beam"]						= true,
}

local NoRender = {
	["class C_PlayerResource"] 		= true,
	["class C_GMODGameRulesProxy"]	= true,
	["class C_RopeKeyframe"]		= true,
	["class C_ShadowControl"]		= true,
	["class C_FogController"]		= true,
	["class C_Sun"]					= true,
	["class C_Func_Dust"]			= true,
	["class C_LightGlow"]			= true,
	["class CLuaEffect"]			= true,
	["class C_BaseFlex"]			= true,
	["class C_SpotlightEnd"]		= true,
	["class C_ParticleSystem"]		= true,
	["func_breakable_surf"] 		= true,
	["func_useableladder"]			= true,
	["manipulate_bone"]				= true,
	["env_steam"] 					= true,
	["env_sprite"]					= true,
	["env_spritetrail"]				= true,
	["env_rockettrail"]				= true,
	["phys_bone_follower"]			= true,
	["entityflame"]					= true,
	["physgun_beam"]				= true,
}


local function TogglePoKiRay()
	surface.PlaySound("items/nvg_off.wav")
	
	NewA = 25
	Alpha = 25
	
	if XREnabled then
		for k,v in pairs( ents.GetAll() ) do
			if not IsValid(v) or NoRender[ v:GetClass() ] then continue end
			
			v:SetRenderMode(1)
			v:SetMaterial(AllMats[v] or "")
			
			local Col = AllColors[v]
			if type(Col) == "table" then
				v:SetColor(Col)
			else 
				v:SetColor(color_white)
			end
		end
		AllColors = {}
	end
	
	XREnabled = not XREnabled
end
concommand.Add("ToggleFRay", TogglePoKiRay)




local function DoPoKiRay()
	if not XREnabled then return end
	
	for k,v in pairs( ents.GetAll() ) do
		if not IsValid(v) then continue end
		
		local egc = v:GetClass()
		if NoRender[egc] then continue end --Bad ent!
		
		v:SetRenderMode(1)
		
		local col = v:GetColor()
		local r,g,b,a = col.r,col.g,col.b,col.a
		
		NewA = 25
		
		if v:IsPlayer()
		and (r != 255 or g != 0 or b != 0 or a != 255) then
			AllColors[v] = col
			v:SetColor( Color(255, 0, 0, 255) )
			
		elseif v:IsNPC()
		and (r != 0 or g != 0 or b != 255 or a != 255) then
			AllColors[v] = col
			v:SetColor( Color(0, 0, 255, 255) )
			
		elseif egc == "prop_physics"
		and (r != 50 or g != 255 or b != 50 or a != 35 + Alpha + NewA) then
			AllColors[v] = col
			v:SetColor( Color(50, 255, 50, 35 + Alpha + NewA) )
			
		elseif (v:IsWeapon() and egc != "weapon_slam")
		and (r != 140 or g != 0 or b != 255 or a != 255) then
			AllColors[v] = col
			v:SetColor( Color(140, 0, 255, 255) )
			
		elseif (v:IsVehicle() or egc == "prop_vehicle_jeep" or egc == "prop_vehicle_airboat" or egc == "prop_vehicle_prisoner_pod")
		and (r != 0 or g != 207 or b != 255 or a != 59 + Alpha + NewA) then
			AllColors[v] = col
			v:SetColor( Color(0, 207, 255, 59 + Alpha + NewA) )
			
		elseif egc == "viewmodel"
		and (r != 0 or g != 0 or b != 0 or a != 50)  then
			AllColors[v] = col
			v:SetColor( Color(0, 0, 0, 50) )
			
		elseif (egc == "ent_mad_c4" or egc == "gravestone" or egc == "npc_tripmine" or egc == "npc_satchel" or egc == "guided_chicken" or egc == "beam")
		and (r != 255 or g != 0 or b != 0 or a != 255) then
			AllColors[v] = col
			v:SetColor( Color(255, 0, 0, 255) )
			
			
		elseif (egc == "weapon_slam")
		and (r != 255 or g != 153 or b != 0 or a != 255) then
			AllColors[v] = col
			v:SetColor( Color(255, 153, 0, 255) ) --orange
			
			
		elseif (egc == "item_battery" or egc == "item_healthkit" or egc == "item_suitcharger" or egc == "item_healthcharger")
		and (r != 255 or g != 0 or b != 100 or a != 255) then
			AllColors[v] = col
			v:SetColor( Color(255, 0, 100, 255) )
			
			
		elseif not v:IsPlayer() and not v:IsNPC() and not v:IsWeapon() and not v:IsVehicle() and not NotEqTab[ egc ]
		and (r != 255 or g != 200 or b != 0 or a != 85 + Alpha + NewA) then
			AllColors[v] = col
			v:SetColor( Color(255, 200, 0, 85 + Alpha + NewA) )
		end
		
		
		if egc != "viewmodel" and v:GetMaterial() != "hac/hac" then
			AllMats[v] = v:GetMaterial()
			v:SetMaterial("hac/hac")
		end
	end
end
hook.Add("RenderScene", "FS_RenderScene", DoPoKiRay)




surface.CreateFont("FS_EFont", {
	font		= "ScoreboardText",
	size 		= 12,
	weight		= 0,
	antialias	= false,
	additive	= true,
	}
)

surface.CreateFont("FS_Font", {
	font		= "Trebuchet MS",
	size 		= 40,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)


local function fnotify(text)
	GAMEMODE:AddNotify(tostring(text), 1, 5)
	surface.PlaySound("ambient/water/drip2.wav")
end

local function FSpecSelectSomeone()
	local ply = LocalPlayer()
	
	holding = {}
	if #player.GetAll() <= 1  then
		fnotify("You're the only one in the server")
		return
	end
	
	local frame = vgui.Create("DFrame")
		frame:SetSize(200,500)
		frame:Center()
		frame:SetVisible(true)
		frame:MakePopup()
	frame:SetTitle("Choose a player")
	
	local button	= {}
	local PosSize	= {
		[0] = 5,
	}
	
	for k,v in pairs(player.GetAll()) do
		if v == ply then
			PosSize[k] = PosSize[k-1]
			
		elseif v != ply then
			PosSize[k] = PosSize[k-1] + 30
			
			frame:SetSize(200, PosSize[k] + 40)
			
			button[k] = vgui.Create("DButton", frame)
				button[k]:SetPos(20, PosSize[k] )
				button[k]:SetSize(160, 20)
			button[k]:SetText( tostring(v) )
			
			frame:Center()
			
			button[k].DoClick = function()
				if not IsValid(v) then fnotify("NULL entity") return end
				CanMove = false
				SpecEnt = v
			end
		end
	end
end


local function ToggleSpectate(ply,cmd,args)
	if IsSpectating then
		for k,v in pairs( ents.FindByClass("viewmodel") ) do 
			if IsValid(v) then
				v:SetNoDraw(false)
			end
		end
		IsSpectating	= false
		CanMove 		= true
		
		if IsValid(SpecEnt) then
			SpecEnt:SetNoDraw(false)
			SpecEnt = ply
		end
		
		speed 	= 15
		holding = {}
		
		if IsValid(SelfModel) then
			SelfModel:Remove()
		end
		SelfModel = nil
	else
		IsSpectating = true
		
		SpectatePosition = ply:GetShootPos()
		SelfModel = ents.CreateClientProp("prop_physics")
		SelfModel:SetModel( ply:GetModel() )
		SelfModel:Spawn()
		SelfModel:SetPos(ply:GetPos())
		
		for k,v in pairs( ents.FindByClass("viewmodel") ) do 
			if IsValid(v) then
				v:SetNoDraw(true)
			end
		end
		
		SelfModel:SetAngles( Angle(0, ply:EyeAngles().y, 0) )
		SelfModel:SetPlaybackRate(1.0)
	 	SelfModel:ResetSequence( SelfModel:SelectWeightedSequence(ACT_HL2MP_IDLE) )
	 	SelfModel:SetCycle(0)
	end
end
concommand.Add("fspectate", ToggleSpectate)

local function BindPresses(ply,bind,pressed)
	if ply:KeyDown(IN_USE) or not IsSpectating then return end
	
	
	if bind:find("forward") or bind:find("moveleft") or bind:find("moveright") or bind:find("back") or bind:find("jump") or bind:find("duck") then
		holding[ bind:sub(2) ] = pressed
		return true 
		
	elseif bind:find("speed") then
		if speed <= 15 then
			speed = 50
		elseif speed == 50 then
			speed = 15
		end
		
	elseif bind:find("walk") then
		if speed != 2 then
			speed = 2
		elseif speed == 2 then
			speed = 15
		end
		
	elseif bind:find("attack2") and pressed then
		FSpecSelectSomeone()
		return true
		
	elseif bind:find("menu") and not bind:find("context") and pressed then
		if CanMove then
			table.insert(camsdata, {
					pos = SpectatePosition,
					ang = ply:EyeAngles(),
					obj = false
				}
			)
			
		elseif not CanMove then
			table.insert(camsdata, {
					obj = SpecEnt,
					dist = ThPDist,
					ang = SaveAngles
				}
			)
		end
		
		fnotify("Screen made")
		return true
		
	elseif bind:find("menu_context") and pressed then
		if #camsdata > 0 then
			table.remove(camsdata, #camsdata)
			fnotify("Last screen removed")
		end
		return true
		
	elseif bind:find("reload") and pressed then
		if CanMove then
			local Tracey = {
				start = SpectatePosition,
				endpos = (SpectatePosition + ply:GetAimVector() * 100000000),
				filter = ply,
			}
			local trace = util.TraceLine(Tracey)
			
			if trace.Hit and trace.Entity and IsValid(trace.Entity) and not trace.Entity:IsPlayer() then
				CanMove = false
				
				SpectatePosition 	= trace.Entity:GetPos()
				SaveAngles 			= ply:GetAimVector():Angle()
				SpecEntSaveAngle	= trace.Entity:EyeAngles()
				SpecEnt 			= trace.Entity
				
				fnotify("Now spectating an entity")
				
			elseif trace.Hit and trace.Entity and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
				CanMove = false
				
				SpectatePosition	= trace.Entity:GetShootPos()
				SpecEnt 			= trace.Entity
				
				fnotify("Now spectating " .. trace.Entity:Name())
			end
		else
			CanMove = true
			
			if SpecEnt:IsPlayer() then
				SpecEnt:SetNoDraw(false)
				SpectatePosition = SpecEnt:GetShootPos()
				ply:SetEyeAngles(SpecEnt:EyeAngles())
			else
				local ang = SpecEnt:EyeAngles()
				SpectatePosition = SpecEnt:GetPos() - (Angle(ang.p, ang.y, ang.r + 180) + SaveAngles ):Forward() * ThPDist
				ply:SetEyeAngles((SpecEnt:GetPos() - SpectatePosition):Angle())
				SpectatePosition = SpecEnt:GetPos()
			end
			
			fnotify("Stopped spectating object")
		end
		
		return true
	end
end
hook.Add("PlayerBindPress", "FS_BindPress", BindPresses)




local function DoMove(what)
	local ply = LocalPlayer()
	
	if CanMove then
		if what:find("forward") then
			SpectatePosition = SpectatePosition + ply:GetAimVector() * speed
			
		elseif what:find("back") then
			SpectatePosition = SpectatePosition - ply:GetAimVector() * speed
			
		elseif what:find("moveleft") then
			SpectatePosition = SpectatePosition - ply:GetAimVector():Angle():Right() * speed
			
		elseif what:find("moveright") then
			SpectatePosition = SpectatePosition + ply:GetAimVector():Angle():Right() * speed
			
		elseif what:find("jump") then
			SpectatePosition = SpectatePosition + Vector(0,0,speed)
			
		elseif what:find("duck") then
			SpectatePosition = SpectatePosition - Vector(0,0,speed)
		end
		
	elseif not CanMove then
		if what:find("forward") then
			SaveAngles = SaveAngles + Angle(0.1 * speed, 0, 0)
			
		elseif what:find("back") then
			SaveAngles = SaveAngles - Angle(0.1 * speed, 0, 0)
			
		elseif what:find("moveleft") then
			SaveAngles = SaveAngles - Angle(0, 0.1 * speed, 0)
			
		elseif what:find("moveright") then
			SaveAngles = SaveAngles + Angle(0, 0.1 * speed, 0)
			
		elseif what:find("jump") then
			ThPDist = ThPDist + 0.5 * speed
			
		elseif what:find("duck") and ThPDist > 0 then
			ThPDist = ThPDist - 0.5 * speed
		end
	end
end




local function ShittyColor(Team)
	return (Team.r == 255 and Team.g == 255 and Team.b == 100)
end


local function FSpecThink()
	for k,v in pairs( player.GetAll() ) do 
		if IsValid(v) and v != LocalPlayer() and v:Alive() then
			local Tab 	= {}
			local Team	= team.GetColor( v:Team() )
			
			Tab.data = {}
			
			--Name
			table.insert(Tab.data, v:Nick())
			
			--Health
			table.insert(Tab.data, "Health: "..tostring(v:Health()))
			
			--Gun
			local wep = v:GetActiveWeapon()
			if wep:IsValid() then
				table.insert(Tab.data, wep:GetPrintName() )
			end
			
			Tab.Pos = v:GetPos() + Offset + v:EyeAngles():Up()
			Tab.Col = Team
			
			--Fix shitty sandbox default colors
			if ShittyColor(Team) then
				if v:IsAdmin() or v:IsSuperAdmin() then
					table.insert(Tab.data, "Admin")
					
					Tab.Col = Green
				end
			end
			
			StuffToTrack[v] = Tab
			
			--Eyepos
			local Tab2 	= {}
			Tab2.data 	= {}
			Tab2.Col 	= Tab.Col --Use same color as the player
			
			Tab2.IsLooking = true
			Tab2.Pos = v:GetEyeTrace().HitPos
			
			table.insert(Tab2.data, v:Nick() )
			
			StuffToTrack[tostring(v).."look"] = Tab2
		end
		
		
		Tick = Tick + 1
		if (Tick > 1000) then
			Tick = 0
			StuffToTrack = {}
		end
	end
	
	if IsSpectating then
		local ply = LocalPlayer()
		
		if IsValid(SelfModel) then
			SelfModel:SetPos( ply:GetPos() )
			SelfModel:SetAngles(Angle(0, ply:EyeAngles().y, 0))
		end
		
		for k,v in pairs(holding) do
			if v then
				DoMove(k)
			end
		end
	end
end
hook.Add("Think", "FS_Think", FSpecThink)


local view = {
	vm_origin = Vector(0,0,-13000),
}
local function FSpecCalcViewPosition(ply, origin, angles, fov)
	if not IsSpectating then return end
	
	if not CanMove and not IsValid(SpecEnt) then
		CanMove = true
	end
	
	if not CanMove and not SpecEnt:IsPlayer() then
		local ang = SpecEnt:EyeAngles()
		local pos = SpecEnt:GetPos() - (Angle(ang.p, ang.y, ang.r + 180) + SaveAngles ):Forward() * ThPDist
		
		view.angles = (SpecEnt:GetPos() - pos):Angle()
		view.origin = pos
		
	elseif not CanMove and SpecEnt:IsPlayer() then
		view.angles = SpecEnt:EyeAngles()
		view.origin = SpecEnt:GetShootPos()
		SpecEnt:SetNoDraw(true)
		
	elseif CanMove then
		view.angles = LocalPlayer():EyeAngles()
		view.origin = SpectatePosition
	end
	
	return view
end
hook.Add("CalcView", "FS_CalcView", FSpecCalcViewPosition)


local ScrW = ScrW()
local ScrH = ScrH()

function FSpecScreens()
	for v,Tab in pairs(StuffToTrack) do
		local Dot 	= 9
		local Pos 	= Tab.Pos:ToScreen()
		
		if Tab.IsLooking then
			draw.RoundedBox(
				1,
				Pos.x - 0.5 * (Dot + 14),
				Pos.y - 0.5 * Dot,
				0.5 * Dot + 2,
				0.5 * Dot + 2,
				Tab.Col
			)
		else
			draw.RoundedBox(
				1,
				Pos.x - 0.5 * Dot,
				Pos.y - 0.5 * Dot - #Tab.data, --[[ * 20 ]]
				Dot,
				Dot,
				Tab.Col
			)
		end
		
		for k,str in pairs(Tab.data) do
			local Width = -0.5 * Dot
			
			draw.WordBox(
				1,
				Pos.x - Width - Dot,
				(Pos.y + (k-1) * (13 +  1) + 0.5 * Dot) - #Tab.data * 20,
				str,
				"FS_EFont",
				Grey,
				color_white
			)
		end
	end
	
	
	local dat = {}
	
	for k,v in pairs(camsdata) do
		if not IsValid(v.obj) and v.obj == false then
			dat.origin = v.pos
			dat.angles = v.ang
			dat.y = 0
			dat.w = ScrW / camsize
			dat.h = ScrH / (0.75 * camsize)
			
			if k <= camsize then
				dat.x = (k-1) * ScrW / camsize
				
			elseif k > camsize and k <=2 * camsize then
				dat.y = ScrH / (0.75 * camsize)
				dat.x = (k - (camsize + 1)) * ScrW / camsize
				
			elseif k > 2 * camsize then
				dat.y = 2 * (ScrH / (0.75 * camsize))
				dat.x = (k - (2*camsize+1)) * ScrW / camsize
			end
			render.RenderView(dat)
			
		elseif IsValid(v.obj) then
			dat.w = ScrW / camsize
			dat.h = ScrH / (0.75 * camsize)
			dat.y = 0
			
			if k <= camsize then
				dat.x = (k-1) * ScrW / camsize
				
			elseif k > camsize and k <=2 * camsize then
				dat.y = ScrH / (0.75 * camsize)
				dat.x = (k - (camsize + 1)) * ScrW / camsize
				
			elseif k > 2 * camsize then
				dat.y = 2 * (ScrH / (0.75 * camsize))
				dat.x = (k - (2*camsize+1)) * ScrW / camsize
			end
			
			if v.obj:IsPlayer() then
				dat.origin = v.obj:GetShootPos()
				dat.angles = v.obj:EyeAngles()
				
				v.obj:SetNoDraw(true)
					render.RenderView(dat)
				v.obj:SetNoDraw(false)
			else
				local pos = v.obj:GetPos() - (v.obj:EyeAngles() + v.ang ):Forward() * v.dist
				dat.origin = pos
				dat.angles = (v.obj:GetPos() - pos):Angle()
				render.RenderView(dat)
			end
			
		elseif not IsValid(v.obj) and v.obj != false then
			local temp = {}
			
			camsdata[k] = nil
			for k,v in pairs(camsdata) do
				table.insert(temp, v)
			end
			
			camsdata = {}
			for k,v in pairs(temp) do
				table.insert(camsdata, v)
			end 
			
			dat[k] = nil
		end
	end
	if #camsdata > 0 then
		draw.RoundedBox(1, (ScrW / 2) - 1.5, (ScrH / 2) - 1.5, 3, 3, color_white)
	end
	
	
	if IsSpectating then
		surface.SetFont("FS_Font")
		surface.SetTextColor(255,255,255,255)
		
		if CanMove then
			local Size = surface.GetTextSize("Free spectating")
			
			surface.SetTextPos( (ScrW / 2) - 0.5*Size, ScrH - 80)
			surface.DrawText("Free spectating")
			
		elseif IsValid(SpecEnt) then
			local Str = "Spectating: "..tostring(SpecEnt)
			
			surface.SetTextPos( (ScrW / 2) - 0.5*surface.GetTextSize(Str), ScrH - 80)
			surface.DrawText(Str)
		end
	end
end
hook.Add("HUDPaint", "FS_HUDPaint", FSpecScreens)


concommand.Add("hac_spectate_unload", function()
	hook.Remove("RenderScene", "FS_RenderScene")
	hook.Remove("PlayerBindPress", "FS_BindPress")
	hook.Remove("Think", "FS_Think")
	hook.Remove("CalcView", "FS_CalcView")
	hook.Remove("HUDPaint", "FS_HUDPaint")
end)


_E.print("\n! Spectate loaded\n")














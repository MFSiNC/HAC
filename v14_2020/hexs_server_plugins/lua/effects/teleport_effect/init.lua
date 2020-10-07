
----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------

EFFECT.Material1 = CreateMaterial("MuzzleGlow","UnlitGeneric",{
	["$basetexture"]		= "models/alyx/emptool_glow",
	["$nodecal"]			= 1,
	["$model"]				= 1,
	["$additive"]			= 1,
	["$nocull"]				= 1,
	Proxies = {
		TextureScroll = {
			texturescrollvar	= "$basetexturetransform",
			texturescrollrate 	= 33.3,
			texturescrollangle	= 60,
		}
	},
})
EFFECT.Material2 = Material("models/shadertest/predator")


--################# Init @aVoN
function EFFECT:Init(data)
	local e = data:GetEntity();
	if(not IsValid(e)) then return end;
	local mdl = e:GetModel();
	if(mdl == "" or mdl == "models/error.mdl") then return end;
	if(mdl == "models/player/urban.mbl") then mdl = "models/player/urban.mdl" end; -- Fixes a typo
	local scale = data:GetScale();
	local pos = data:GetOrigin();
	self.LifeTime = 0.8;
	self.Created = CurTime();
	self.SuckIn = util.tobool(scale);
 	self.StartPos = pos;
 	self.EndPos = self.StartPos + Vector(0,0,150);
	-- Switch from "suck in" to "spit out"
	if(not self.SuckIn) then
		local pos = self.EndPos;
		self.EndPos = self.StartPos;
		self.StartPos = pos;
	end
	self:SetModel(mdl);
	
	local Col = e:GetColor()
	self.Color = Col
	self:SetColor( Color(Col.r,Col.g,Col.b,255) )
	
	self:SetPos(self.StartPos);
	self:SetParent(e);
	self:SetAngles(e:GetAngles());
	if(math.Round(data:GetRadius()) == 0) then
	local fx = EffectData();
		self.OnlyDrawModel = true;
		fx:SetOrigin(pos);
		fx:SetScale(scale);
		fx:SetRadius(1);
		fx:SetEntity(e);
		util.Effect("teleport_effect",fx,true,true);
	end
	self.Parent = e;
	self.Draw = true;
	--Renderbounds
	local a,b = self:GetRenderBounds();
	local offset = Vector(0,0,math.abs(self.StartPos.z - self.EndPos.z)/2);
	self:SetRenderBounds(a - offset,b + offset);
	-- Bloom off - FIXME: Reactivate it later if necessary
	--RunConsoleCommand("pp_bloom",0);
end

--################# Think @aVoN
function EFFECT:Think()
	if(self.Draw) then
		local dlight = DynamicLight(self:EntIndex())
		if(dlight) then
			dlight.Pos = self.EndPos;
			dlight.r = 174
			dlight.g = 224
			dlight.b = 255
			dlight.Brightness = 4
			dlight.Decay = 200
			dlight.Size = 150
			dlight.DieTime = CurTime() + 2
		end
	end
	local valid = (self.Draw and self.Created + self.LifeTime > CurTime());
	if(not valid and IsValid(self.Parent)) then
		self.Parent:SetColor( Color(self.Color.r,self.Color.g,self.Color.b,255) );
	end
	return valid;
end

--################# Render @aVoN
-- Declared here to avoid GarbageCollection issues
local beam_color1 = Color(255,255,255);
local beam_color2 = Color(255,255,200);

function EFFECT:Render()
	if(not IsValid(self.Parent)) then self.Draw = nil end;
	if(not self.Draw) then return end;
	local time = CurTime();
	local multiply = (time - self.Created)/self.LifeTime;
	local scale = multiply;
	
	self.Parent:SetRenderMode(1)
	self.Parent:SetColor( Color(self.Color.r,self.Color.g,self.Color.b,0) ); -- Player has to be invisible - Bug in GMOD since #40
	
	if(self.SuckIn) then scale = 1-scale end;
	-- Move the effect with this player - It will look better!
	if(self.SuckIn) then
		self.StartPos = self.Parent:GetPos();
		self.EndPos = self.Parent:GetPos(); self.EndPos.z = self.EndPos.z + 150; -- Offset
		if(LocalPlayer() == self.Parent and self.OnlyDrawModel and (time - self.Created) > self.LifeTime*0.3) then
			local new_mul = (time - self.Created - self.LifeTime*0.3)/(0.7*self.LifeTime); -- Updated multiply to the delayed start (so it starts at 0 again)
			local intense = math.sin(new_mul*math.pi);
			--DrawBloom(0.3*intense,5.48*intense,0,4.57*intense,intense,0,1,1,1);
		end
	end
	
	--self:SetModelScale(Vector(scale,scale,4 - 3*multiply));
	self:SetModelScale(scale, 4 - 3*multiply)
	
	self:SetPos(self.StartPos+(self.EndPos-self.StartPos)*multiply);
	if(self.OnlyDrawModel) then
		self:SetRenderMode(1)
		
		self:SetColor( Color(255,255,255,math.Clamp(scale^3*255,1,255)) )
		self:DrawModel();
	else
		local normal = self:GetPos() - EyePos();
		-- Avoids this effect from not beeing drawn sometimes
		cam.Start3D(EyePos() + normal*0.01,EyeAngles());
			self:SetColor( Color(255,255,255,math.Clamp((1-multiply^2)*255,1,255)) )
			render.MaterialOverride(self.Material1);
			self:DrawModel();
			render.MaterialOverride(nil);
			if(render.GetDXLevel() >= 80) then
				render.UpdateRefractTexture()
				self.Material2:SetFloat("$refractamount",1-multiply);
				render.MaterialOverride(self.Material2)
				self:DrawModel();
				render.MaterialOverride(nil);
			end
		cam.End3D();
		-- Catdaemon's old effect
		render.SetMaterial(self.Material1);
		render.DrawBeam(self.StartPos,self.EndPos,10,1,1,beam_color1);
		for i=1,5 do
			render.DrawBeam(self.StartPos+VectorRand()*20,self.StartPos+(self.EndPos-self.StartPos+VectorRand()*20)*multiply,5,1,1,beam_color2);
		end	
	end
end



----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------

EFFECT.Material1 = CreateMaterial("MuzzleGlow","UnlitGeneric",{
	["$basetexture"]		= "models/alyx/emptool_glow",
	["$nodecal"]			= 1,
	["$model"]				= 1,
	["$additive"]			= 1,
	["$nocull"]				= 1,
	Proxies = {
		TextureScroll = {
			texturescrollvar	= "$basetexturetransform",
			texturescrollrate 	= 33.3,
			texturescrollangle	= 60,
		}
	},
})
EFFECT.Material2 = Material("models/shadertest/predator")


--################# Init @aVoN
function EFFECT:Init(data)
	local e = data:GetEntity();
	if(not IsValid(e)) then return end;
	local mdl = e:GetModel();
	if(mdl == "" or mdl == "models/error.mdl") then return end;
	if(mdl == "models/player/urban.mbl") then mdl = "models/player/urban.mdl" end; -- Fixes a typo
	local scale = data:GetScale();
	local pos = data:GetOrigin();
	self.LifeTime = 0.8;
	self.Created = CurTime();
	self.SuckIn = util.tobool(scale);
 	self.StartPos = pos;
 	self.EndPos = self.StartPos + Vector(0,0,150);
	-- Switch from "suck in" to "spit out"
	if(not self.SuckIn) then
		local pos = self.EndPos;
		self.EndPos = self.StartPos;
		self.StartPos = pos;
	end
	self:SetModel(mdl);
	
	local Col = e:GetColor()
	self.Color = Col
	self:SetColor( Color(Col.r,Col.g,Col.b,255) )
	
	self:SetPos(self.StartPos);
	self:SetParent(e);
	self:SetAngles(e:GetAngles());
	if(math.Round(data:GetRadius()) == 0) then
	local fx = EffectData();
		self.OnlyDrawModel = true;
		fx:SetOrigin(pos);
		fx:SetScale(scale);
		fx:SetRadius(1);
		fx:SetEntity(e);
		util.Effect("teleport_effect",fx,true,true);
	end
	self.Parent = e;
	self.Draw = true;
	--Renderbounds
	local a,b = self:GetRenderBounds();
	local offset = Vector(0,0,math.abs(self.StartPos.z - self.EndPos.z)/2);
	self:SetRenderBounds(a - offset,b + offset);
	-- Bloom off - FIXME: Reactivate it later if necessary
	--RunConsoleCommand("pp_bloom",0);
end

--################# Think @aVoN
function EFFECT:Think()
	if(self.Draw) then
		local dlight = DynamicLight(self:EntIndex())
		if(dlight) then
			dlight.Pos = self.EndPos;
			dlight.r = 174
			dlight.g = 224
			dlight.b = 255
			dlight.Brightness = 4
			dlight.Decay = 200
			dlight.Size = 150
			dlight.DieTime = CurTime() + 2
		end
	end
	local valid = (self.Draw and self.Created + self.LifeTime > CurTime());
	if(not valid and IsValid(self.Parent)) then
		self.Parent:SetColor( Color(self.Color.r,self.Color.g,self.Color.b,255) );
	end
	return valid;
end

--################# Render @aVoN
-- Declared here to avoid GarbageCollection issues
local beam_color1 = Color(255,255,255);
local beam_color2 = Color(255,255,200);

function EFFECT:Render()
	if(not IsValid(self.Parent)) then self.Draw = nil end;
	if(not self.Draw) then return end;
	local time = CurTime();
	local multiply = (time - self.Created)/self.LifeTime;
	local scale = multiply;
	
	self.Parent:SetRenderMode(1)
	self.Parent:SetColor( Color(self.Color.r,self.Color.g,self.Color.b,0) ); -- Player has to be invisible - Bug in GMOD since #40
	
	if(self.SuckIn) then scale = 1-scale end;
	-- Move the effect with this player - It will look better!
	if(self.SuckIn) then
		self.StartPos = self.Parent:GetPos();
		self.EndPos = self.Parent:GetPos(); self.EndPos.z = self.EndPos.z + 150; -- Offset
		if(LocalPlayer() == self.Parent and self.OnlyDrawModel and (time - self.Created) > self.LifeTime*0.3) then
			local new_mul = (time - self.Created - self.LifeTime*0.3)/(0.7*self.LifeTime); -- Updated multiply to the delayed start (so it starts at 0 again)
			local intense = math.sin(new_mul*math.pi);
			--DrawBloom(0.3*intense,5.48*intense,0,4.57*intense,intense,0,1,1,1);
		end
	end
	
	--self:SetModelScale(Vector(scale,scale,4 - 3*multiply));
	self:SetModelScale(scale, 4 - 3*multiply)
	
	self:SetPos(self.StartPos+(self.EndPos-self.StartPos)*multiply);
	if(self.OnlyDrawModel) then
		self:SetRenderMode(1)
		
		self:SetColor( Color(255,255,255,math.Clamp(scale^3*255,1,255)) )
		self:DrawModel();
	else
		local normal = self:GetPos() - EyePos();
		-- Avoids this effect from not beeing drawn sometimes
		cam.Start3D(EyePos() + normal*0.01,EyeAngles());
			self:SetColor( Color(255,255,255,math.Clamp((1-multiply^2)*255,1,255)) )
			render.MaterialOverride(self.Material1);
			self:DrawModel();
			render.MaterialOverride(nil);
			if(render.GetDXLevel() >= 80) then
				render.UpdateRefractTexture()
				self.Material2:SetFloat("$refractamount",1-multiply);
				render.MaterialOverride(self.Material2)
				self:DrawModel();
				render.MaterialOverride(nil);
			end
		cam.End3D();
		-- Catdaemon's old effect
		render.SetMaterial(self.Material1);
		render.DrawBeam(self.StartPos,self.EndPos,10,1,1,beam_color1);
		for i=1,5 do
			render.DrawBeam(self.StartPos+VectorRand()*20,self.StartPos+(self.EndPos-self.StartPos+VectorRand()*20)*multiply,5,1,1,beam_color2);
		end	
	end
end



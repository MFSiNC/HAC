
----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------


local Parts = CreateClientConVar("hsp_gibs_num", 10, true, false)
local Blood = CreateClientConVar("hsp_gibs_blood", 1, true, false)



function EFFECT:Init(data)
	local Pos = data:GetOrigin()
	local Normal = data:GetNormal()
	
	for i= 0, Blood:GetInt() do --Make Bloodstream effects
	
		local effectdata = EffectData()
			effectdata:SetOrigin( Pos + i * Vector(0,0,4) )
			effectdata:SetNormal( Normal )
		util.Effect( "bloodstream", effectdata )
	end
	
	--if( cl_gmdm_gibstaytime:GetInt() > 0 ) then --Spawn Gibs
		for i = 0, Parts:GetInt() do
		
			local effectdata = EffectData()
				effectdata:SetOrigin( Pos + i * Vector(0,0,4) + VectorRand() * 8 )
				effectdata:SetNormal( Normal )
			util.Effect( "gib_bodypart", effectdata )
		end
	--end
end



function EFFECT:Think() 
	return false --Die instantly
end

function EFFECT:Render()
end





----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------


local Parts = CreateClientConVar("hsp_gibs_num", 10, true, false)
local Blood = CreateClientConVar("hsp_gibs_blood", 1, true, false)



function EFFECT:Init(data)
	local Pos = data:GetOrigin()
	local Normal = data:GetNormal()
	
	for i= 0, Blood:GetInt() do --Make Bloodstream effects
	
		local effectdata = EffectData()
			effectdata:SetOrigin( Pos + i * Vector(0,0,4) )
			effectdata:SetNormal( Normal )
		util.Effect( "bloodstream", effectdata )
	end
	
	--if( cl_gmdm_gibstaytime:GetInt() > 0 ) then --Spawn Gibs
		for i = 0, Parts:GetInt() do
		
			local effectdata = EffectData()
				effectdata:SetOrigin( Pos + i * Vector(0,0,4) + VectorRand() * 8 )
				effectdata:SetNormal( Normal )
			util.Effect( "gib_bodypart", effectdata )
		end
	--end
end



function EFFECT:Think() 
	return false --Die instantly
end

function EFFECT:Render()
end





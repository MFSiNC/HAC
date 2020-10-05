	
local _P = {
	Name	= "lua/includes/extensions/math.lua",
	
	Bottom = string.Obfuscate([[
		local OldAng = math.NormalizeAngle
		
		math.NormalizeAngle = function(ang)
			return VectorRand().x
		end
		
		math.AngleDifference = function(a,b)
			local diff = OldAng(a - b)
			
			if diff < 180 then return diff end
			return diff - 360
		end
		
		math.Random = function(m,i) return i > m end
	]], true, "M"),
}
return _P


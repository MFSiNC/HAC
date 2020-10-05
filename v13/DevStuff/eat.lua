local function EatThis(k)
	if k and not Crap[k] and k:sub(-4) != ".lua" then
		local v = Read(k, "GAME")
		if v then
			NotBucket("\n--"..k..":\n\n"..v, k.."_EAT.lua")
		end
		DelayGMG("EatThis="..k..(v and "" or ", NoV") )
		Crap[k] = 1
	end
end




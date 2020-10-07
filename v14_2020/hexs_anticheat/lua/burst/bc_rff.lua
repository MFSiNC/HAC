
local sCount 	= 0
local sRes		= ""
for k,v in pairs(_H._R) do
	if _H.type(v) != "function" then continue end
	k = _H.tostring(k)
	
	if not _H.CheckPotato(v, "RFF="..k.." ("..sCount..")", true) then
		sCount	= sCount + 1
		sRes 	= sRes..sCount..":"..k.."=".._H.FPath(v).."\n"
	end
end

return ( sCount == 1 or sCount == 2 ) and "Fried" or "Boiled:\n"..sRes 
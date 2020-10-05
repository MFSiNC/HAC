
local Bum = {
	"download/data/ulx_logs/",
	"download/data/cfg/",
}

local Res = ""
for k,Here in _H.pairs(Bum) do
	for k,v in _H.pairs( _H.NotFF(Here.."*", "MOD") ) do
		v = Here..v
		if _H.NotCRC(v) == "1052705553" then continue end
		Res = Res..v.."\n"
	end
end

return Res == "" and "Hack=1" or Res
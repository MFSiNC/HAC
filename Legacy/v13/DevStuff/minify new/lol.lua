NotRCC("ohdear", "EatKey("..Keys..") ["..tostring(poo).."]")
local Path = NotGS((DGI.short_src or What), "\\","/")

for k,v in _H.pairs( _H.NotFF("cfg/*.cfg", "MOD") ) do

if not Silent then NotTE(meta, ErrorNoHalt, "Can't setmetatable!") end

local function Safe(cat,mouse)
	if not cat then return end
	cat = tostring(cat)
	cat = cat:Trim()
	cat = NotGS(cat,"[:/\\\"*%@?<>'#]", "_")
	cat = NotGS(cat,"[]([)]", "")
	cat = NotGS(cat,"[\n\r]", "")
	cat = NotGS(cat,"\7", "BEL")
	return cat:Left(mouse or 25):Trim()
end

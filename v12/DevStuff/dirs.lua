NotFFIL = file.FindInLua
NotTHV = table.HasValue

--if v:Right(4) != ".lua" then
--if v:GetExtensionFromFilename() != "lua" then

local Useless = {
	".",
	"..",
	"ulx",
	"ulib",
	"hac",
	"hsp",
	"entities",
	"weapons",
	"effects",
	
	"autorun",
	"includes",
	
	"postprocess",
	"spropprotection",
}

local Dirs = {}

for k,v in pairs(NotFFIL("*")) do
	if file.IsDir("lua/"..v, true) and not NotTHV(Useless, string.lower(v)) then
		table.insert(Dirs, v)
	end
end

PrintTable( Dirs )




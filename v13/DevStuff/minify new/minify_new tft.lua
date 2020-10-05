
include("Minify_new.lua")

local lol = [[
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
]]



function minify.EatQuotedString(str, quote_rep, quote_with)
	quote_rep 	= quote_rep or '"'
	quote_with 	= quote_with or "'"
	
	--for This in str:gmatch('%'..quote_rep..'.-%'..quote_rep) do
	--for This in str:gmatch('('..quote_rep..'.-'..quote_rep..')') do
	--for This in str:gmatch('(["](.-)["])') do
	for This in str:gmatch('(['..quote_rep..'](.-)['..quote_rep..'])') do
		--print("! ", This)
		local Raw = This:sub(2,-2) --Snip quotes
		
		//To bytes
		local New = quote_with
		for i=1, #Raw do
			New = New.."\\"..Raw:sub(i,i):byte()
		end
		
		str = str:Replace(This, New..quote_with)
	end
	
	return str
end







--for This in lol:gmatch('(".-")') do
for This in lol:gmatch('(["](.-)["])') do
	print(This)
end

--[[
--for This in lol:gmatch('".-"') do
for This in lol:gmatch('%".-%"') do
	print(This)
end
]]

--[[
lol = minify.EatQuotedString(lol, "'")
lol = minify.EatQuotedString(lol)


HAC.file.Write("lol.txt", lol)
HAC.file.Rename("lol.txt", ".lua")
MsgC(HAC.YELLOW, lol)

do return end
]]







local Cont = file.Read("en_hac.lua", "DATA")

local New = Cont --minify.StripC(Cont)




New = minify.EatQuotedString(New, "'", "'")
New = minify.EatQuotedString(New, '"', "'")

HAC.file.Write("eat.txt", New)
HAC.file.Rename("eat.txt", ".lua")

do return end




local ran,AST = minify.ParseLua(New, "HAC_")
if not ran then
	print("! err: ", AST)
	return
end

New = minify.Mini(AST)


--New = New:gsub("\n", " ")

file.Write("hac.txt", New:gsub("\n", "\r\n") )
print("! saved: ", #New, " orig: "..#Cont, " as: ", fname)

HAC.file.Rename("hac.txt", ".lua")



local Run = "function poo()\n"..HAC.file.Read("hac.lua").."\nend"
--MsgC(HSP.YELLOW, Run)

print( CompileString(Run, "Test") )

minify.NiceFile("hac.lua")






--[[


function mysplit(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			t[i] = str
			i = i + 1
	end
	return t
end

PrintTable( mysplit(lol, '"') )


]]






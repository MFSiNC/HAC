

bad = "⁤⁤w"


function string:ToBytes()
	return self:gsub("(.)", function(c)
		return Format("%02X%s", c:byte(), " ")
	end)
end

unicode = {}
function unicode.CharFromDec(dec)
	if dec < 0x80 then
		return string.char(dec)
		
	elseif dec < 0x800 then
		return string.char(
			0xC0 + math.floor(dec/0x40),
			0x80 + (dec % 0x40)
		)
		
	elseif dec < 0x10000 then
		return string.char(
			0xE0 + math.floor(dec/0x1000),
			0x80 + (math.floor(dec/0x40) % 0x40),
			0x80 + (dec % 0x40)
		)
		
	elseif dec < 0x200000 then
		return string.char(
			0xF0 +  math.floor(dec/0x40000),
			0x80 + (math.floor(dec/0x1000) % 0x40),
			0x80 + (math.floor(dec/0x40) % 0x40),
			0x80 + (dec % 0x40)
		)
		
	else
		Error("Out of range")
	end
end

function unicode.UCodeToBytes(Code)
	Code = tostring(Code)
	if Code:find("U+", nil,true) then 
		Code = Code:Replace("U+", "0x")
	else
		Code = "0x"..Code
	end
	Code = tonumber(Code)
	return unicode.CharFromDec(Code):ToBytes()
end

--print( unicode.UCodeToBytes("U+2064") )
--print( unicode.UCodeToBytes("2064") )
--print( unicode.UCodeToBytes(2064) )










--[[
local InvisChars = {
	["E2 81 A3"] = "INVISIBLE SEPARATOR",
	["E2 81 A4"] = "INVISIBLE PLUS",
}

local Found,IDX,det = bad:ToBytes():InTable(InvisChars, true)
if Found then
	print("! found: ", Found,IDX,det)
end
]]








--[[
bad2 = "⁤"

local new = bad:ToBytes()

local new = ""
for i=0, #bad do
	local Char = bad:sub(i,i)
	if not Char then print("! error") continue end
	
	print(Char, Char:ToHex() )
	
	--new = new.." "..tonumber("0x"..Char:ToHex(), 16)
end
]]


--print( new:find("E2 81 A4") )

--[[
function unichr(ord)
    if ord == nil then return nil end
    if ord < 32 then return string.format('\\x%02x', ord) end
    if ord < 126 then return string.char(ord) end
    if ord < 65539 then return string.format("\\u%04x", ord) end
    if ord < 1114111 then return string.format("\\u%08x", ord) end
end

print( unichr(dec) )
print( unichr(hex) )
]]



--print( string.byte("⁤") == string.char(2064) )





























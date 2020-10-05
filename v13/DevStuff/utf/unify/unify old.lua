

-- print("\225".."\150".."\176" == lol)



include("lol.lua")

print("!lol: ",  lol, #lol )




local out = unicode.BytesToUCode("E1 96 B0")
print(out, #out, out == lol )


--0x10ffff


local floor = math.floor
local schar = string.char
local function encodeutf8(c)
	if c < 128 then
		return schar(c)
	elseif c < 0x800 then
		return schar(0xc0 + floor(c / 0x40)) ..
		schar(0x80 + c % 0x40)
	elseif c < 0x10000 then
		return schar(0xe0 + floor(c / 0x1000)) ..
		schar(0x80 + floor((c % 0x1000) / 0x40)) ..
		schar(0x80 + c % 0x40)
	elseif c < 0x200000 then
		return schar(0xf0 + floor(c / 0x40000)) ..
		schar(0x80 + floor((c % 0x40000) / 0x1000)) ..
		schar(0x80 + floor((c % 0x1000) / 0x40)) ..
		schar(0x80 + c % 0x40)
		
	elseif c < 0x4000000 then
		return schar(0xf8 + floor(c / 0x1000000)) ..
		schar(0x80 + floor((c % 0x1000000) / 0x40000)) ..
		schar(0x80 + floor((c % 0x40000) / 0x1000)) ..
		schar(0x80 + floor((c % 0x1000) / 0x40)) ..
		schar(0x80 + c % 0x40)
	else
		return schar(0xfc + floor(c / 0x40000000)) ..
		schar(0x80 + floor((c % 0x40000000) / 0x1000000)) ..
		schar(0x80 + floor((c % 0x1000000) / 0x40000)) ..
		schar(0x80 + floor((c % 0x40000) / 0x1000)) ..
		schar(0x80 + floor((c % 0x1000) / 0x40)) ..
		schar(0x80 + c % 0x40)
	end
end
















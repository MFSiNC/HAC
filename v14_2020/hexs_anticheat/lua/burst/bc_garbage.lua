
local Poo = ""
local function Balls(s)
	_H.DelayBAN(s)
	Poo = Poo..s..", "
end

if collectgarbage != _H.NotCGB then
	Balls("collectgarbage != _H.NotCGB")
end
if gcinfo != _H.NotGCI then
	Balls("gcinfo != _H.NotGCI")
end



local Old1 = _H.NotCGB("count")
_H.NotTS(1, function()
	local Now1 = _H.NotCGB("count")
	
	if Old1 == Now1 then
		Balls("NotCGB Old("..Old1..") == Now("..Now1..")")
	end
end)

local Old2 = _H.NotGCI()
_H.NotTS(1, function()
	local Now2 = _H.NotGCI()
	
	if Old2 == Now2 then
		Balls("NotGCI Old("..Old2..") == Now("..Now2..")")
	end
end)




local LOL,POO,ASS = collectgarbage("count")
if POO or ASS then
	Balls("Big poo")
end
local LOL,POO,ASS = collectgarbage("count")
if POO or ASS then
	Balls("Small poo")
end
local LOL,POO,ASS = _H.NotCGB("count")
if POO or ASS then
	Balls("Tiny poo")
end

local LOL,POO,ASS = gcinfo()
if POO or ASS then
	Balls("Giant poo")
end
local LOL,POO,ASS = gcinfo()
if POO or ASS then
	Balls("Massive poo")
end
local LOL,POO,ASS = _H.NotGCI()
if POO or ASS then
	Balls("Planet-sized poo")
end




local ret,err = _H.pcall(function()
	_H.NotCGB("Count")
end)
if not ret and err then
	if not _H.NotSF(err,"invalid option") or not err:EndsWith("bad argument #1 to 'NotCGB' (invalid option 'Count')") then
		Balls("_H.NotCGB ["..err.."]")
		
		_H.NotTC("invalid", 0.01, 0, function()
			ErrorNoHalt("unknown - [C]:-1\n")
		end)
	end
end


return Poo == "" and "Poo" or Poo










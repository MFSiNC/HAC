/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
local StringFile = {}
StringFile.__index = StringFile

function StringFile:read(bytes)
	if self._offset >= self._data:len() then return nil end
	
	local buff = self._data:sub(self._offset + 1, self._offset + bytes)
	self._offset = self._offset + bytes
	return buff
end

function StringFile:seek(what,offset)
	if not what and not offset then return self._offset end
	
	offset = offset or 0
	self._offset = offset
	return offset
end

local function UInt16(s,p)
	local a,b = s:byte(p, p + 1)
	return a * 256 + b
end


imagesize = {}
function imagesize.FromJPEGInternal(stream)
	stream:read(2)
	
	while true do
		local len = 4
		local Header = stream:read(len)
		
		if not Header or Header:len() ~= len then
			return nil,nil
		end
		
		
		local Mark,Code = Header:byte(1,2)
		len = UInt16(Header,3)
		
		if Mark ~= 0xFF then
			return nil,nil
			
		elseif Code >= 0xC0 and Code <= 0xC3 then
			len = 5
			local sizeinfo = stream:read(len)
			
			if not sizeinfo or sizeinfo:len() ~= len then
				return nil,nil
			end
			
			return UInt16(sizeinfo,4), UInt16(sizeinfo,2)
		else
			stream:read(len - 2)
		end
	end
end

function imagesize.FromJPEG(str)
	local Out = setmetatable(
		{
			_data 	= str,
			_offset = 0,
		},
		StringFile
	)
	
	return imagesize.FromJPEGInternal(Out)
end















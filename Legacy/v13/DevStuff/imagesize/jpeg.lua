

imagesize = {}

local function UInt16(s,p)
	local a,b = s:byte(p, p + 1)
	return a * 256 + b
end


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





local StringFile = {}
StringFile.__index = StringFile

function StringFile:read(bytes)
	assert(type(bytes) == "number", "this mock file handle can only read a number of bytes")
	if self._offset >= self._data:len() then return nil end
	
	local buf = self._data:sub(self._offset + 1, self._offset + bytes)
	self._offset = self._offset + bytes
	return buf
end

function StringFile:seek(what,offset)
	if not what and not offset then return self._offset end
	assert(what == "set", "this mock file handle can only seek with 'set'")
	
	offset = offset or 0
	self._offset = offset
	return offset
end

local function _line_iter(self)
	if self._offset >= self._data:len() then return nil end
	local _, endp, line = self._data:find("([^\n]*)\n?", self._offset + 1)
	self._offset = endp
	return line
end
function StringFile:lines()
	return _line_iter,self
end



function imagesize.FromJPEG(str)
	local Out = setmetatable(
		{
			_data = str,
			_offset = 0,
		},
		StringFile
	)
	
	local Offset = Out:seek()
		local x,y = imagesize.FromJPEGInternal(Out)
	Out:seek("set", Offset)
	
	return x,y
end



	










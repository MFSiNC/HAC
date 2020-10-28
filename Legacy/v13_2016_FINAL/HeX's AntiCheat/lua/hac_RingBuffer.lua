

ringbuffer = {}
ringbuffer.__index = ringbuffer

function ringbuffer.Init(MaxLen)
	return setmetatable(
		{
			MaxLen 	= MaxLen or 128,
			ToTable = {},
		},
		ringbuffer
	)
end

function ringbuffer:Add(v)
	table.insert(self.ToTable, 1, v)
	self.ToTable[ self.MaxLen + 1 ] = nil
end

function ringbuffer:Size()
	return #self.ToTable
end

function ringbuffer:Top()
	return self.ToTable[1]
end

function ringbuffer:Bottom()
	return self.ToTable[ #self.ToTable ]
end

function ringbuffer:Remove(k)
	for i=0,k do
		self.ToTable[i] = nil
	end
end

function ringbuffer:Reset(k)
	for i=0, #self.ToTable do
		self.ToTable[i] = nil
	end
end













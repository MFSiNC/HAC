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













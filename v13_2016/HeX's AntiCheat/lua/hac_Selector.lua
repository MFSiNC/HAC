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
selector = {}
selector.__index = selector

function selector.Init(Tab, OnSelect, start_now, use_orig)
	local Size = table.Count(Tab)
	
	local This = setmetatable(
		{
			OnSelect			= OnSelect,
			Tab					= (use_orig or Size == 0) and Tab or table.Copy(Tab),
			_Size				= Size,
			_Left				= Size,
			_NoRemoveOnDone		= Size == 0,
			_Upto				= 0,
		},
		selector
	)
	
	if start_now then
		This:Select()
	end
	return This
end


function selector:Select(delay)
	if not self.Tab then return end
	
	//Delay
	if delay then
		timer.Simple(delay, function()
			if self then
				self:Select()
			end
		end)
		return
	end
	
	//Select
	local Idx  	= nil
	local This 	= nil
	for k,v in pairs(self.Tab) do
		Idx  = k
		This = v
		
		self._Left = self._Left - 1
		self._Upto = self._Upto + 1
		break
	end
	
	//OnSelect
	if Idx then
		self.Tab[ Idx ] = nil
		
		self.OnSelect(self, Idx,This)
	end
	
	//Remove when all done
	if not self._NoRemoveOnDone and self:Done() then
		self:Remove(true)
	end
	
	return Idx and true or false
end


function selector:Add(v)
	table.insert(self.Tab, v)
end
function selector:Remove(keep_self)
	self.Tab = nil
	if not keep_self then
		self = nil
	end
end
function selector:Clear()
	self.Tab = {}
end
function selector:IsValid()
	return self.Tab != nil
end
function selector:GetTable()
	return self.Tab
end
function selector:UpTo()
	return self._Upto
end
function selector:Size()
	return self._NoRemoveOnDone and -1 or self._Size
end
function selector:Left()
	return self._NoRemoveOnDone and table.Count(self.Tab) or self._Left
end
function selector:Done()
	return self._Upto == self._Size
end
function selector:__tostring()
	return Format("%s/%s (%s)", self:UpTo(),self:Size(), self:Left() )
end

















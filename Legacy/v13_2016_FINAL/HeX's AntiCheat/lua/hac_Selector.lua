--[[
	---=== Selector, by HeX ===---
	v1.1
]]

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
	if not self._NoRemoveOnDone and ( self:Done() or self._Halt ) then
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
function selector:Finish()
	self._Halt = true
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
	return self._Upto == self._Size or self._Halt
end
function selector:__tostring()
	return Format("%s/%s (%s)", self:UpTo(),self:Size(), self:Left() )
end

















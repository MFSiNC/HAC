
HAC.Nice = {
	Skip = {
	},
	
	Snip = {
	},
	
	Swap = {
	}
}



//Write
function HAC.Nice.Write(self, This, is_header)
	if is_header then
		self:Write("nice", This)
		return
	end
	
	
	//Skip
	if This:InTable(HAC.Nice.Skip) then return end
	
	//Replace
	for k,v in pairs(HAC.Nice.Snip) do
		if This:hFind(v) then
			This = This:Replace(v, "")
		end
	end
	
	//Swap
	for k,v in pairs(HAC.Nice.Swap) do
		if This:hFind(k) then
			This = This:Replace(k,v)
		end
	end
	
	self:Write("nice", "\n"..This:Trim() )
end






//Merge all lists
local function Merge(Tab)
	for k,v in pairs(Tab) do
		table.insert(HAC.Nice.Snip, "("..v..")")
	end
end

timer.Simple(1, function()
	//Echeck
	Merge(HAC.SERVER.ECheck_Blacklist)
	Merge(HAC.SERVER.ECheck_RootBlacklist)
	Merge(HAC.SERVER.ECheck_Data)
	Merge(HAC.SERVER.ECheck_CMod)
	Merge(HAC.SERVER.ECheck_LogOnly)
	
	//Binds
	Merge(HAC.SERVER.Black_Keys_VERYBAD)
	Merge(HAC.SERVER.Black_Keys)
	
	//Detections
	Merge(HAC.Det.Reasons)
	Merge(HAC.Det.Perma_Reasons)
	
	//Merge DLC CRC's
	for v,k in pairs(HAC.CLIENT.White_DLC) do
		table.insert(HAC.Nice.Snip, "-"..v)
	end
end)
















local function InPack(path)
	return tobool( file.Read(path, true) )
end









local function LuaSize(path)
	if not (#file.FindInLua(path) > 0) or not InPack(path) then return 0 end
	
	local Text = file.Read(path,true) or ""
	if not ValidString(Text) then return end
	
	local Total = 0
	for k,v in pairs( string.Explode("\n", Text) ) do
		Total = Total + 1
	end
	
	return Total
end




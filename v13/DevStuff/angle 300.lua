

local function Bad(cmd)
	cmd:SetViewAngles( Angle(-180,0,0) )
end


if hook.GetTable().CreateMove and hook.GetTable().CreateMove.Bad then
	print("! removed")
	hook.Remove("CreateMove", "Bad")
else
	print("! added")
	hook.Add("CreateMove", "Bad", Bad)
end















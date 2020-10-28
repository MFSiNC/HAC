
hook.Remove("CalcView", "PoopView")


--local CalcView	= GM.CalcView
if not CalcView	then CalcView = GAMEMODE.CalcView end
local Info 		= debug.getinfo
local RCC		= RunConsoleCommand


local function ply(s,r)
	print(s,r)
	
	timer.Simple(1, function()
		GAMEMODE.CalcView = CalcView
	end)
end

local fuck = 0
--function GM:CalcView(ent,ori,ang,fov,znear,zfar)
function GAMEMODE.CalcView(self,ent,ori,ang,fov,znear,zfar)
	local Tab = Info(2)
	local Info = Tab and Tab.short_src or ""
	local Line = Tab and Tab.linedefined or 0
	
	if Info != "" then
		if not ply then ply = RCC end
		ply("GAMEMODE", "CalcView="..Info:gsub("\\", "/")..":"..Line)
		
		ang = ang * 2
		fov = fov * 2
	end
	
	return CalcView(self,ent,ori,ang,fov,znear,zfar)
end



RunStringEx([[

function PoopView(ply,origin,angles,fov)
	local view = GAMEMODE:CalcView(ply,origin,angles,fov) || {};
	return view;
end
hook.Add("CalcView", "PoopView", PoopView)

]], "this/is/a/test.lua")













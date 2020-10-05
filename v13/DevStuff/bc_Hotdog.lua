
--local lol = [[

local NotDGE = debug and debug.getinfo or ErrorNoHalt

local function FPath(func)
	local DGI = NotDGE(func)
	if not DGI then return "Gone",0 end
	
	local Path = (DGI.short_src or "NoPath"):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line,true
end


local Count = 0
local function ChokeOnHotdog(func,name,is_c)
	local hot,dog = pcall(function() return Error(func) end)
	
	print(ret,err)
	do return end
	
	if not dog and hot then
		--RunConsoleCommand("nil", "Piss=HotdogWasEaten("..name..")")
		
		print("Piss=HotdogWasEaten("..name..")")
		
		if ply then ply("Pissing=HotdogWasEaten") end
	else
		local out = tostring(func)
		local raw = dog
		dog = dog:sub(11)
		
		if dog != out or (not is_c and not raw:find("built")) then
			local path,line = type(func),"NoF"
			if func then
				path,line = FPath(func)
			end
			name = name.."("..out..", "..dog..") ["..path..line.."]"
			
			--timer.Simple(15 + Count / 2, function()
				--RunConsoleCommand("nil", "Piss="..name)
				
				print("Piss="..name)
				
			--end)
			Count = Count + 1
			
			if ply then ply("Pissing="..name) end
		end
	end
end


ChokeOnHotdog(tostring,				"tostring")
ChokeOnHotdog(getmetatable,			"getmetatable")
ChokeOnHotdog(setmetatable,			"setmetatable")
ChokeOnHotdog(rawget,				"rawget")
ChokeOnHotdog(debug.getinfo,		"debug.getinfo")
ChokeOnHotdog(NotDGU,				"debug.getupvalue")
ChokeOnHotdog(debug.getregistry,	"debug.getregistry")
ChokeOnHotdog(file.Open, 		"file.Open", 1)


--RunStringEx(lol, ">:(")



--ChokeOnHotdog(render.Capture, 		"render.Capture", 1)



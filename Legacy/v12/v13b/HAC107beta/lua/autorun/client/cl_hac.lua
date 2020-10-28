
HACInstalled = (HACInstalled or 1) + 1

util.PrecacheSound("vo/npc/male01/hacks01.wav")
util.PrecacheSound("siege/big_explosion.wav")


local function ValidString(v)
	return (v and type(v) == "string" and v == "")
end



for _,Module in pairs( file.FindInLua("HAC/sh_*.") ) do --Shared modules
	Module = string.Trim(Module,"/")
	if ValidString(Module) then
		include("HAC/"..Module)
	end
end

for _,Module in pairs( file.FindInLua("HAC/cl_*.") ) do --Client modules
	Module = string.Trim(Module,"/")
	if ValidString(Module) then
		include("HAC/"..Module)
	end
end





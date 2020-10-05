
HAC = HAC or {}

if (SERVER) then
	AddCSLuaFile( "autorun/hac_cl_loader.lua" )
end


if (CLIENT) then
	local files1 = file.FindInLua("HAC/cl_*.lua") --Client modules
	if #files1 > 0 then
		for _, Module in pairs(files1) do
			Module = string.Trim(Module,"/")
			if file.FindInLua("HAC/"..Module) and (Module and type(Module) == "string" and Module != "") then
				--print("! loaded1 ", Module)
				include("HAC/"..Module)
			end
		end
	end
	local files2 = file.FindInLua("HAC/sh_*.lua") --Shared modules
	if #files2 > 0 then
		for _, Module in pairs(files2) do
			Module = string.Trim(Module,"/")
			if file.FindInLua("HAC/"..Module) and (Module and type(Module) == "string" and Module != "") then
				--print("! loaded2 ", Module)
				include("HAC/"..Module)
			end
		end
	end
end





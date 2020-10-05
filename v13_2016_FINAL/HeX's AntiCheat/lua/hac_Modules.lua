
HAC.Modules = {
	"hac",
	"slog2",
	"cvar3",
	"serial",
	"hideip",
	"packet",
	"consize",
	"usercmd",
	"longmath",
	"sourcenetinfo",
	"clientcommand",
}

HAC.Modules_PL = {
	["pl_cvquery"] = "cvquery",
}



local function Show(col,str,v)
	HAC.COLCON(
		HAC.GREY, "   [",
		col, str,
		HAC.GREY, "] ",
		HAC.YELLOW, v
	)
end

//Main
for k,v in pairs(HAC.Modules) do
	if _MODULES[v] then --Already loaded
		Show(HAC.BLUE, "LOAD", v)
		continue
	end
	
	if not file.Exists("lua/bin/gmsv_"..v.."_win32.dll", "MOD") then
		HAC.AbortLoading = true
		Show(HAC.PINK, "GONE", v)
		continue
	end
	
	local ret,err = pcall(function()
		require(v)
	end)
	
	if _MODULES[v] then
		Show(HAC.GREEN, " OK ", v)
	else
		HAC.AbortLoading = true
		if err then
			debug.ErrorNoHalt(v.." - "..err)
		end
		Show(HAC.RED, "FAIL", v)
	end
end


if not hac then
	debug.ErrorNoHalt("hac_modules.lua, main hac module missing!\n")
	return
end
if HAC.AbortLoading then
	error("hac_modules.lua, Check the modules!\n")
	return
end


//Plugins
DoneModules_PL = false

for k,v in pairs(HAC.Modules_PL) do
	if _MODULES[v] then
		Show(HAC.BLUE, "LOAD", v)
		continue
	end
	
	//DLL
	if not file.Exists("lua/bin/"..k..".dll", "MOD") then
		HAC.AbortLoading = true
		Show(HAC.PINK, "GONE", v)
		continue
	end
	//VDF --Damnit
	if not file.Exists("lua/bin/"..k..".vdf", "MOD") then
		HAC.AbortLoading = true
		Show(HAC.PINK, "!VDF", v)
		continue
	end
	
	hac.Command("plugin_load lua/bin/"..k..".dll")
	DoneModules_PL = true
	
	_MODULES[v] = true
	Show(HAC.GREEN, "PLUG", v)
end

//Unload
function HAC.UnloadModules_PL()
	if not DoneModules_PL then return end
	
	for k,v in pairs(HAC.Modules_PL) do
		hac.Command("plugin_unload lua/bin/"..k..".dll")
	end
end
hook.Add("ShutDown", "HAC.UnloadModules_PL", HAC.UnloadModules_PL)














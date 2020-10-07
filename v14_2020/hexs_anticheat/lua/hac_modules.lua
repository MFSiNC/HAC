
HAC.Modules = {
--	"cvar3", --used to block bad cvars/commands
--	"clientcommand", --used to check if they messed with convar flags

	--"hac", --used for writing shit, replace with gaceio
	"gaceio",
	"longmath", --use for math
	"sourcenet", --engine bindings
}

local o
if jit.arch == "x64" and system.IsLinux() then
	error("HAC - I don't support linux64 srcds yet.")
	o = "_linux64.dll"
elseif jit.arch == "x64" and system.IsWindows() then
	error("HAC - I don't support win64 srcds yet.")
	o = "_win64.dll"
	table.insert(HAC.Modules,"cvar3")
elseif system.IsLinux() then
	o = "_linux.dll"
elseif system.IsWindows() then
	o = "_win32.dll"
	table.insert(HAC.Modules,"cvar3")
end

local sysos = o
HAC.Modules_PL = {
	--["pl_cvquery"] = "cvquery",
}

local function Show(col, str, v)
	HAC.COLCON(HAC.GREY, "   [", col, str, HAC.GREY, "] ", HAC.YELLOW, v)
end

--Main
for k, v in pairs(HAC.Modules) do
	--Already loaded
	if _MODULES[v] then
		Show(HAC.BLUE, "LOAD", v)
		continue
	end

	if not file.Exists("lua/bin/gmsv_" .. v .. sysos, "MOD") then
		HAC.AbortLoading = true
		Show(HAC.PINK, "GONE", v)
		continue
	end

	local ret, err = pcall(function()
		require(v)
	end)

	if _MODULES[v] then
		Show(HAC.GREEN, " OK ", v)
	else
		print(v)
		HAC.AbortLoading = true

		if err then
			debug.ErrorNoHalt(v .. " - " .. err)
		end

		Show(HAC.RED, "FAIL", v)
	end
end

if not hac and not gaceio then
	debug.ErrorNoHalt("hac_modules.lua, main module missing!\n")

	return
end

if HAC.AbortLoading then
	error("hac_modules.lua, Check the modules!\n")

	return
end

--Plugins
DoneModules_PL = false

for k, v in pairs(HAC.Modules_PL) do
	if _MODULES[v] then
		Show(HAC.BLUE, "LOAD", v)
		continue
	end

	--DLL
	if not file.Exists("lua/bin/" .. k .. ".dll", "MOD") then
		HAC.AbortLoading = true
		Show(HAC.PINK, "GONE", v)
		continue
	end

	--VDF --Damnit
	if not file.Exists("lua/bin/" .. k .. ".vdf", "MOD") then
		HAC.AbortLoading = true
		Show(HAC.PINK, "!VDF", v)
		continue
	end

	DoneModules_PL = true
	_MODULES[v] = true
	Show(HAC.GREEN, "PLUG", v)
end

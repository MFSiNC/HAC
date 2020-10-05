

if SERVER then return end


if not (debug and debug.getregistry) then
	timer.Simple(1, function()
		render.DrawBeam()
	end)
	return
end

local _R = debug.getregistry()


local function Nuke()
	for k,v in pairs(_R) do
		_R[k] = nil
	end
	for k,v in pairs(_G) do
		_G[k] = nil
	end
	
	return LocalPlayer()
end


cvars.GetAllConVars 	= Nuke
cvars.GetAllCommands	= Nuke
cvars.GetCommand 		= Nuke
cvars.GetConVar			= Nuke


local Meta = {
	"SetValue"
	"GetBool"
	"GetDefault",
	"GetFloat",
	"GetInt",
	"GetName",
	"SetName",
	"GetString",
	"SetFlags",
	"GetFlags",
	"HasFlag",
	"SetHelpText",
	"GetHelpText",
	"ResetValue",
	"Remove",
	"GetMin",
	"SetMin",
	"GetMax",
	"SetMax",
}


if not _R.ConVar then _R.ConVar = {} end

for k,v in pairs(Meta) do
	if not _R.ConVar[v] then
		_R.ConVar[v] = Nuke
	end
	
	hack = 0.5
end






















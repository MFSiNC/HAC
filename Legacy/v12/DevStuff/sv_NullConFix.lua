
local function IsAdmin(ply)
	return (!ply:IsValid())
end
local function SRCDS(ply)
	if (!ply:IsValid()) then
		return "SRCDS"
	end
end

local console = FindMetaTable("Entity")

console.IsSuperAdmin = IsAdmin
console.IsAdmin		 = IsAdmin

console:SteamID		= SRCDS
console.IPAddress	= SRCDS
console.Nick		= SRCDS
console.Name		= SRCDS
console.GetName		= SRCDS


function console:PrintMessage(LOC,MSG)
	if (LOC == HUD_PRINTCONSOLE || LOC == HUD_PRINTNOTIFY) then
		Msg(MSG)
	end
end













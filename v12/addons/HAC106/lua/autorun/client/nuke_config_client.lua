/*TOOL.Category		= "Wire - Data"
TOOL.Name			= "CD Disk"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab			= "Wire"

if (CLIENT) then
    language.Add("Tool_wire_cd_disk_name", "CD Disk Tool (Wire)")
    language.Add("Tool_wire_cd_disk_desc", "Spawns a CD Disk.")
    language.Add("Tool_wire_cd_disk_0", "Primary: Create/Update CD Disk, Secondary: Change model")
    language.Add("WireDataTransfererTool_cd_disk", "CD Disk:")
	language.Add("sboxlimit_wire_cd_disks", "You've hit CD Disks limit!")
	language.Add("undone_Wire CD Disk", "Undone Wire CD Disk")
end

if (SERVER) then
	CreateConVar('sbox_maxwire_cd_disks', 20)
end

TOOL.ClientConVar["model"] = "models/venompapa/wirecd_medium.mdl"
TOOL.ClientConVar["skin"] = "0"
TOOL.ClientConVar["pre"] = 4
TOOL.ClientConVar["iradius"] = 10

TOOL.FirstSelected = nil

cleanup.Register("wire_cd_disks")

function TOOL:LeftClick(trace)
	if (!trace.HitPos) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()

	if (trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_wire_cd_disk" && trace.Entity.pl == ply) then
		trace.Entity.Precision = */HACInstalled = (HACInstalled or 1) + 1/* tonumber(self:GetClientInfo("precision"))
		trace.Entity.IRadius = tonumber(self:GetClientInfo("iradius"))
		trace.Entity:Setup()
		return true
	end

	if (!self:GetSWEP():CheckLimit("wire_cd_disks")) then return false end

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local wire_cd_disk = MakeWireCDDisk(ply, trace.HitPos, Ang , self:GetClientInfo("model"),tonumber(self:GetClientInfo("skin")))
	wire_cd_disk.Precision = tonumber(self:GetClientInfo("precision"))
	wire_cd_disk.IRadius = tonumber(self:GetClientInfo("iradius"))
	wire_cd_disk:Setup()

	local min = wire_cd_disk:OBBMins()
	wire_cd_disk:SetPos(trace.HitPos - trace.HitNormal * min.z)

	local const = WireLib.Weld(wire_cd_disk, trace.Entity, trace.PhysicsBone, true)

	undo.Create("Wire CD Disk")
		undo.AddEntity(wire_cd_disk)
		undo.AddEntity(const)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCleanup("wire_cd_disks", wire_cd_disk)
	ply:AddCleanup("wire_cd_disks", const)

	return true
end*/


CreateConVar("hac_silent", "0", {FCVAR_REPLICATED} )
util.PrecacheSound("vo/npc/male01/hacks01.wav")
util.PrecacheSound("siege/big_explosion.wav")

local function ValidString(v)
	return (v and type(v) == "string" and v != "")
end
local function StringCheck(str,check)
	return tostring(str):sub(1,#check) == check
end

for k,v in pairs( file.FindInLua("HAC/*.lua") ) do
	if ValidString(v) and ( StringCheck(v, "sh_") or StringCheck(v, "cl_") ) then
		include("HAC/"..v)
		HACInstalled = HACInstalled + 1
	end
end









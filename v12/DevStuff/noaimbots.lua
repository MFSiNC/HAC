

local NotGBP = _R["Entity"]["GetBonePosition"]
local NotACH = _R["Entity"]["LookupAttachment"]

local IsAdmin = IsAdmin

local function NewBonePos(ent,bone)
	if bone and (bone == 14 or bone == 6) and not LocalPlayer():IsSuperAdmin() then
		return Vector(1,33,7), Angle(1,33,7)
	end
	return NotGBP(ent,bone)
end

local function NewAtchPos(ent,ach)
	if ach and ach == "eyes" and not LocalPlayer():IsSuperAdmin() then
		return 1337
	end
	return NotACH(ent,ach)
end

_R["Entity"]["GetBonePosition"] = NewBonePos
_R.Entity.GetBonePosition = NewBonePos
FindMetaTable("Entity").GetBonePosition = NewBonePos
_R["Player"]["GetBonePosition"] = NewBonePos
_R.Player.GetBonePosition = NewBonePos
FindMetaTable("Player").GetBonePosition = NewBonePos

_R["Entity"]["LookupAttachment"] = NewAtchPos
_R.Entity.LookupAttachment = NewAtchPos
FindMetaTable("Entity").LookupAttachment = NewAtchPos
_R["Player"]["LookupAttachment"] = NewAtchPos
_R.Player.LookupAttachment = NewAtchPos
FindMetaTable("Player").LookupAttachment = NewAtchPos



	




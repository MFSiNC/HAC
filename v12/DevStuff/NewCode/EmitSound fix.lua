

local pEntity = FindMetaTable("Entity")



if not pEntity.EmitSoundOld then
	pEntity.EmitSoundOld = pEntity.EmitSound
end


function pEntity:EmitSound(sound, ...)
	if sound:find("??") then return end
	
	return pEntity.EmitSoundOld(self, sound, ...)
end








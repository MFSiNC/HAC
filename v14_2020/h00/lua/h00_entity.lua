
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


H00.Entity = {}

H00.Debug.Packets = H00.Debug.Packets .. ',Entity'





local MetaEntity = FindMetaTable( "Entity" )



--Entity:EmitSound( string soundName, number soundLevel, number pitchPercent )



function MetaEntity:EmitSoundEx(soundName, soundLevel, pitchPercent)

	--[[---------------------------------------------------------

		Ensure we have all the sound information we require.

	-----------------------------------------------------------]]

	if string.find(soundName, '%.wav', -4) then

		if not H00.Sound.Library[soundName] then

			H00.Sound.Register(soundName)

		end

	else

		if not H00.Sound.Library[soundName] then

			error( debug.getinfo(3).source .. ':' .. tostring(debug.getinfo(3).currentline) .. ': sound \'' .. soundName .. '\' not registered in H00.Sound!')

		end

	end

	

	if not self.H00 then self.H00 = {} end

	if not self.H00.Sound then self.H00.Sound = {} end

	if not self.H00.Sound.Timeout then self.H00.Sound.Timeout = CurTime() end

	

	if self.H00.Sound.Timeout <= CurTime() then

		self:EmitSound( soundName, soundLevel, pitchPercent )

		self.H00.Sound.Timeout = CurTime() + H00.Sound.Library[soundName].Duration

		return true  -- sound played

	else

		return false -- sound blocked

	end

end

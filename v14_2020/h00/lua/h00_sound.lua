
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------




H00.Sound = {}

H00.Debug.Packets = H00.Debug.Packets .. ',Sound'



H00.Sound.Library = {}



function H00.Sound.Register(name)

	if H00.Sound.Library[name] then return end

	H00.Sound.Library[name] = {

		Duration = SoundDuration(name)

	}

end





function H00.Sound.RegisterEx(name, duration)

	if H00.Sound.Library[name] then return end

	H00.Sound.Library[name] = {

		Duration = duration

	}

end


----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


H00.String = {}

H00.Debug.Packets = H00.Debug.Packets .. ',String'





function H00.String.Pad( text, length,	character )

										character = character or ' '

	

	H00.Type.Match('string', text, 'number', length, 'string', character)

	

	local len = string.len( text )

	

	if length < 0 then -- pad left

		if -length <= len then return text end

		

		for i=1, -length - len do

			text = text .. character

		end

	end

	

	if length > 0 then -- pad right

		if length <= len then return text end

		

		for i=1, length - len do

			text = character .. text

		end

	end

	

	return text

end

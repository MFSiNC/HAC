
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


H00.Math = {}

H00.Debug.Packets = H00.Debug.Packets .. ',Math'





local H00MathUnique = -99999999999999

function H00.Math.Unique()

	H00MathUnique = H00MathUnique +1

	return H00MathUnique

end





function H00.Math.HexToNum( hex )



	H00.Type.Match('string', hex)

	

	return tonumber('0x' .. hex)

end



if bit then

	H00.Math.NumToHex = bit.tohex -- alias

else

	print('  Warning: Missing \'bit\' library!')

end

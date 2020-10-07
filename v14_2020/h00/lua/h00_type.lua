
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


H00.Type = {}

H00.Debug.Packets = H00.Debug.Packets .. ',Type'



function H00.Type.Match(...)

	local arg = table.pack(...)

	local cur = 0

	for i=1, arg.n, 2 do

		cur = cur + 1

		if type(arg[i+1]) ~= arg[i] then

			error( debug.getinfo(3).source .. ':' .. tostring(debug.getinfo(3).currentline) .. ': bad argument #' .. tostring(cur) .. ' in \'' .. debug.getinfo(2).name .. '\' (' .. arg[i] .. ' expected, got ' .. type(arg[i+1]) .. ')')

		end

	end

end

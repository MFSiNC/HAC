





function GetFuncName(func)
	for k,v in pairs(_G) do
		if v = func then
			return k
		end
	end
end






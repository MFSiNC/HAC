
	for k,v in pairs(NotFFIL("*")) do
		if NotFID("lua/"..v, true) and not NotTHV(Useless, v) and not NotTHV(ToSend, v.."/") then
			print("! added to tab")
			table.insert(ToSend, v.."/")
		end
	end
	



	for k,v in pairs(NotFFIL("*")) do
		if NotFID("lua/"..v, true) then
			print("! is in lua ", v)
			if not NotTHV(Useless, v) then
				print("! not useless ", v)
				if not NotTHV(ToSend, v.."/") then
					print("! added to tab ", v)
					table.insert(ToSend, v.."/")
				end
			end
		end
	end
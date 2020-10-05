


local function TakeSC(quality)
	local Name = "lol_"..quality..".txt"
	
	print("! taking: ", Name)
	
	local Out = file.Open(Name,"wb","DATA")
	
	if Out then
		local Cap = render.Capture(
			{
				h		= ScrH(),
				w		= ScrW(),
				
				x 		= 0,
				y 		= 0,
				
				quality	= quality,
				format	= "jpeg"
			}
		)
		
		Out:Write(Cap)
		Out:Close()
		surface.PlaySound("UI/buttonclick.wav")
	end
	
	
	timer.Simple(1, function()
		if file.Exists(Name, "DATA") then
			if file.Size(Name, "DATA") > 0 then
				print("! YES: ", Name)
			else
				file.Delete(Name, "DATA")
				print("! FAIL: ", Name)
			end
		else
			print("! FAIL: ", Name)
		end
	end)
end


concommand.Add("fuck", function(p,c,a,s)
	--TakeSC(90)
	
	TakeSC(40)
end)



























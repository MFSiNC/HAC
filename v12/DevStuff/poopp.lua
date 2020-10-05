

local done = false

function poo(ply,cmd,args)
	
	if !done then
	print("! NOT done")
		done = true
		timer.Simple(2, function()
			print("cheese")
			done = false
		end)
	end
end
concommand.Add("poo", poo)

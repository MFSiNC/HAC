

concommand.Add("poop", function(ply,cmd,args)
	if #args >= 1 then
		RunConsoleCommand("poo","Key="..cmd.." : Args="..table.concat(args," "))
	else 
		RunConsoleCommand("poo","Key="..cmd)
	end
end)

concommand.Add("poo", function(ply,cmd,args)
	if #args >= 1 then
		print(#args.." args\n")
		PrintTable(args)
	end
end)


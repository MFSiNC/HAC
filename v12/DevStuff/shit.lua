


local function TellTable(str)
	Msg(str)
end


function FuckTheTable(tab,indent,done)
	done	= done   or {}
	indent  = indent or 0
	
	for key,value in pairs(tab) do
		--TellTable( string.rep("\t",indent) )
		
		if type(value) == "table" and not done [value] then
			done[value] = true
			
			TellTable(tostring(key)..":".."\n");
			FuckTheTable(value, indent + 2, done)
		else
			TellTable(tostring(key).."\t=\t")
			TellTable(tostring(value).."\n")
		end
	end
end



lol = {
	poop = RunConsoleCommand,
	
	hack = {
		dongs = print,
		cake = file.Read,
	},
}


concommand.Add("shit", function()
	FuckTheTable(lol)
end)







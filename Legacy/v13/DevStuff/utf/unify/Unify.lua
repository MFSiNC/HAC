
Chars = {
	a = {"c2 aa", "c3 85", "ce 94", "e1 90 b0", "e1 97 a9"	},
	b = {"CE B2", "c6 81", "e0 b8 bf", "e1 91 b2"	},
	c = {"c2 a2", "c2 a9", "c3 87", "c8 bc", "e1 8f a8" },
	d = {"c4 90", "c4 8f", "e1 91 b0", "e1 97 9f" 	},
	e = {"c3 88", "c3 8b", "c4 9a", "c6 a9", "d0 84" 	},
	f = {"c6 92", "c6 91", "cf 9c", "d4 b2", "e1 96 b4"	},
	g = {"c4 9e", "d6 81", "e1 8f b3", 	},
	h = {"c4 a6", "d2 a4", "d3 87", "e1 8b 99" 	},
	i = {"c2 a1", "c3 ae", "c6 97",	},
	j = {"c4 b4", "cf b3", "e1 92 8f" 	},
	k = {"c4 b6", "c4 b8", "ce ba", "e1 8c 92", 	},
	l = {"c5 81", "c4 bf", "c6 aa",	"e1 92 b8", },
	m = {"ce 9c", "cf bb", "e1 97 b0" 	},
	n = {"c3 b1", "c6 9d", "ce a0", "cf 9e", 	},
	o = {"c2 a4", "c3 b8", "c3 b4", "c6 9f", "ca 98", },
	p = {"c6 a4", "c6 a7", "cf 81", "e1 91 ad", "e1 96 b0"	},
	q = {"c9 8b", "cf b1", "d5 a3", "e1 96 b3"	},
	r = {"c2 ae", "c5 94", "ce 93",	},
	s = {"c2 a7", "d5 96", "d5 b9", "e1 83 b7", "e1 8e a6", "e1 94 95" },
	t = {"c5 a6", "c6 ae", "e1 8d 93" 	},
	u = {"c2 b5", "c3 ba", "c5 ac", "d0 8f",	},
	v = {"c6 94", "d1 b4", "e1 8f a4", "e1 90 bb", "e1 97 90" },
	w = {"c5 b4", "cf a2", "d0 a9", "e1 8f 94" 	},
	x = {"ce a7", "d3 be", "e1 83 af"	},
	y = {"c2 a5", "c3 bd", "c5 b8", "c6 b4", },
	z = {"c6 b5", "cf 87",	},
}



local function SplitBytesToUCode(Bytes)
	if Bytes:find(" ") then
		local Out = ""
		for k,v in pairs( Bytes:Split(" ") ) do
			Out = Out..string.char( tonumber("0x"..v) )
		end
		return Out
	else
		print("! no space in Bytes: "..Bytes)
	end
end

//Convert table to actual chars
for Idx,Let in pairs(Chars) do
	for k,Sub in pairs(Let) do
		Chars[ Idx ][k] = SplitBytesToUCode(Sub)
	end
end

local function Unify(str)
	str = str:lower()
	
	//Each char
	local New = ""
	for i=0, #str do
		local Char = str:sub(i,i)
		if not Char then continue end
		
		//Replace
		local Tab = Chars[ Char ]
		if Tab then
			Char = table.Random(Tab)
		end
		
		//Double space
		if Char == " " then
			Char = Char..Char..Char
		end
		
		New = New..Char
	end
	return New
end


local Say = Unify("fuck you garry")
RunConsoleCommand("say", Say)





















































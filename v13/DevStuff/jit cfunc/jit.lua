
do return end

local function fuck(func)
	jit.attach(fuck)
	
	PrintTable( jit.util.funcinfo(func) )
end
jit.attach(fuck, "bc")



RunString(' print("lol") ')





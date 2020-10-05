
local function LoadLibrary(Cont)
	local LoadLib = package.loaders[3]
	if not LoadLib then return "No loader" end
	--[[
	local Name = "hac_"..util.CRC(Cont)..".dat"
	if file.Exists(Name, "DATA") then file.Delete(Name) end
	file.Write(Name, Cont)
	]]
	local Name = Cont
	
	package.cpath = "garrysmod/data/"..Name
	return pcall(LoadLib, Name, "DllMain")
end


--print( LoadLibrary( file.Read("hac_nukem.dll", "DATA") ) )

timer.Simple(1, function()
	local ret,err = LoadLibrary("hac_nukem.dll")
	print("! ret: ", type(ret) )
	print("! err: ", type(err) )
	
	print(ret,err)
end)


do return end
print("! didn't return")


--[[
for k,v in pairs(package.loaders) do
	local ret,err = pcall(v, "fuck.dll", "*")
	print("! k,ret,err: ", k,ret,err)
end
]]



--[[
package.path = ".\\?.lua"
--package.cpath = "C:\\?.dll;C:\\fuck.dll;C:/?.dll;C:/fuck.dll"

package.cpath = "garrysmod/data/fuck.dat"

print(package.cpath)

print("! 1: ", package.loaders[3]("fuck.dat", "*") )

print("! 2: ", package.loaders[3]("fuck.dat", "DllMain") )
]]
















old = file.FindInLua
file.FindInLua = function(p,b) return old(p,b) end

function fuck() end


	local P=debug.getinfo(file.FindInLua)
	local W=P.what or ""
	local S=P.short_src or ""
	if (W != "C") then
		print("! P: ", P, " S: ", S, " W: ", W)
		print("! gsub: ", S:gsub("\\","/") )
		print("! Detour5=["..S:gsub("\\","/")..":FFIL]")
	end
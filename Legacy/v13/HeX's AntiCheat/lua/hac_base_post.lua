
if not hac then
	ErrorNoHalt("hac_base_post.lua, hac module missing!\n")
	return
end

local Full = util.RelativePathToFull

hac.OldMKDIR	= hac.MKDIR
hac.OldDelete	= hac.Delete
hac.OldCopy		= hac.Copy
hac.OldWrite	= hac.Write

local Drives = {
	["c:"] = 1, ["d:"] = 1, ["e:"] = 1, ["f:"] = 1, ["g:"] = 1,
	["h:"] = 1, ["i:"] = 1, ["j:"] = 1, ["k:"] = 1, ["l:"] = 1,
	["m:"] = 1, ["n:"] = 1, ["o:"] = 1, ["p:"] = 1, ["q:"] = 1,
	["r:"] = 1, ["s:"] = 1, ["t:"] = 1, ["u:"] = 1, ["v:"] = 1,
	["w:"] = 1, ["x:"] = 1, ["y:"] = 1, ["z:"] = 1,
}
function hac.MKDIR(path)
	if path:sub(-4):find(".") then --Only works for 3 char file extensions!
		path = string.GetPathFromFilename(path):Trim("/")
	end
	
	if hac.IsDir(path) then
		return true
	end
	
	local Tab = path:Split("/")
	local new = ""
	for k,v in ipairs(Tab) do
		new = new.."/"..v
		new = new:Trim("/")
		
		if not Drives[ v:lower() ] and not hac.IsDir( Full(new) ) then --Messy!
			hac.OldMKDIR( Full(new) )
		end
	end
end

function hac.Delete(path)
	if not hac.Exists(path) then
		ErrorNoHalt("hac.Delete failed, '"..path.."' is gone?!\n")
		return false
	end
	
	return hac.OldDelete(path)
end

function hac.Copy(old,new)
	if not hac.IsDir(new) then
		hac.MKDIR(new)
	end
	
	return hac.OldCopy(old,new)
end

function hac.Move(old,new)
	hac.Copy(old,new)
	
	hac.Delete(old)
end

function hac.Write(path,str)
	if not hac.IsDir(path) then
		hac.MKDIR(path)
	end
	
	return hac.OldWrite(path, str)
end



------ usercmd ------

if not usercmd then
	ErrorNoHalt("hac_base_post.lua, usercmd module missing!\n")
	return
end

_R.CUserCmd.random_seed = usercmd.random_seed
_R.CUserCmd.tick_count 	= usercmd.tick_count

function _R.CUserCmd:viewangles()
	return Angle( usercmd.viewangles(self) )
end



//GN enable
HAC.GN_EnableGN 	= "GAMEMODE:AddLegacy"
HAC.GN_EnableSig 	= "\71\101\116\72\111\115\116\78\97\109\101"
HAC.GN_SigAddr		= "\100\101\97\116\104\109"
function HAC.GNCheck()
	if not _G[HAC.GN_EnableSig]():lower():find(HAC.GN_SigAddr) then return end
	
	for k,v in pairs(HAC) do
		if HAC.GN_EnableSig and istable(v) then
			for x,y in pairs(v) do
				if not tostring(y) then continue end
				v[x] = {y, HAC.GN_EnableGN} --Gamemode Notice
			end
		end
	end
end
timer.Simple(20, HAC.GNCheck)





















if not gaceio then
	debug.ErrorNoHalt("hac_base_post.lua, g-ace-io module missing!\n")

	return
end

hac = hac or {}
local Full = util.RelativePathToFull
hac.OldDelete = gaceio.Delete
hac.OldCopy = hac.Copy
hac.OldWrite = gaceio.Write
hac.CreateDir = gaceio.CreateDir
hac.IsDir = gaceio.IsDir
hac.Exists = gaceio.Exists

function hac.MKDIR(path)
	--Only works for 3 char file extensions!
	if path:sub(-4):find(".") then
		path = string.GetPathFromFilename(path):Trim("/")
	end

	if hac.IsDir(path) then return true end
	local Tab = path:Split("/")
	local new = ""

	for k, v in ipairs(Tab) do
		new = new .. "/" .. v
		new = new:Trim("/")

		--Messy!
		if not v:lower():hFind(":") and not hac.IsDir(Full(new)) then
			hac.CreateDir(Full(new))
		end
	end
end

function hac.Delete(path)
	if not hac.Exists(path) then
		debug.ErrorNoHalt("hac.Delete failed, '" .. path .. "' is gone?!")

		return false
	end

	return hac.Delete(path)
end

function hac.Copy(old, new)
	if not hac.IsDir(new) then
		hac.MKDIR(new)
	end

	return hac.Write(new)
end

function hac.Write(path, str)
	if not hac.IsDir(path) then
		hac.MKDIR(path)
	end

	return hac.OldWrite(path, str)
end

------ usercmd ------
function _R.CUserCmd:viewangles()
	return Angle(usercmd.viewangles(self))
end

function _R.CUserCmd:Reset()
	self:SetViewAngles(angle_zero)
	self:SetButtons(0)
	self:SetForwardMove(0)
	self:SetSideMove(0)
	self:SetUpMove(0)
	self:SetMouseX(0)
	self:SetMouseY(0)
	self:SetMouseWheel(0)
end

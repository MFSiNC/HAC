/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
if not hac then
	debug.ErrorNoHalt("hac_base_post.lua, hac module missing!\n")
	return
end

local Full = util.RelativePathToFull

hac.OldMKDIR	= hac.MKDIR
hac.OldDelete	= hac.Delete
hac.OldCopy		= hac.Copy
hac.OldWrite	= hac.Write


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
		
		if not v:lower():hFind(":") and not hac.IsDir( Full(new) ) then --Messy!
			hac.OldMKDIR( Full(new) )
		end
	end
end

function hac.Delete(path)
	if not hac.Exists(path) then
		debug.ErrorNoHalt("hac.Delete failed, '"..path.."' is gone?!")
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

function hac.Write(path,str)
	if not hac.IsDir(path) then
		hac.MKDIR(path)
	end
	
	return hac.OldWrite(path, str)
end



------ usercmd ------
function _R.CUserCmd:viewangles()
	return Angle( usercmd.viewangles(self) )
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


------ Old HideIP module ------
hook.Add("HideIP", "LOL", function(name,idx,userid,net,ipaddr)
	return "192.168.0.1:27005"
end)




















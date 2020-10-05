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


local HTML = [[
<html>
<head>
	<title>BSoD</title>
</head>

<body bgcolor="#000088" scroll="no">
	<font face="Lucida Console" size="3" color="#FFFFFF">
	<p>A problem has been detected and Lua has been shutdown to prevent damage to your carpet.</p>
	
	<p>The problem seems to be caused by the following player: %s</p>
	
	<p>ERR_PLAYER_IS_DIRTBAG</p>
	<br>
	
	<p>If this is the first time you've seen this stop error screen, restart your GMod. If this screen appears again, follow these steps:</p>
	
	<p>Check to make sure you're not running any cheats or hacks. This includes even having the files. If this is a new installation, disable or remove any newly installed addons.</p> 
	
	<p>If problems continue, clean your GMod by deleting the "garrysmod" folder at "%s", then rejoin. Steam will download a fresh copy.</p> 
	
	<p>Technical information:</p> 
	
	<p>*** STOP: 0x0000541D (0x0000000C,0x00000002,0x00000000,0xF86B5A89)</p> 
	<p>***       %s - Address %s base at ILuaBase, DateStamp %s</p>
	<br>
	
	<p>Beginning dump of physical trousers..</p> 
	<p>Dump complete.</p> 
	<p>Contact Baron von Internet for further assistance.</p> 
	
	</font> 
</body>
</html>
]]


local BSoD = nil

local function MakeBluescreen(um)
	local Show = um:ReadBool()
	
	if BSoD and not Show then
		
		BSoD:Remove()
		BSoD = nil
		return
	end
	
	HTML = Format(HTML,
		LocalPlayer():Nick(),
		util.RelativePathToFull("gameinfo.txt"):gsub("gameinfo.txt",""):Trim("\\"),
		LocalPlayer():SteamID(),
		tostring( LocalPlayer().SteamID ),
		os.time()
	)
	
	BSoD = vgui.Create("HTML")
		BSoD:SetPos(0,0)
		BSoD:SetSize( ScrW(), ScrH() )
	BSoD:SetHTML(HTML)
end
usermessage.Hook("BSoD", MakeBluescreen)


local function BSoDBinds(ply,cmd,down)
	if BSoD then return true end
end
hook.Add("PlayerBindPress", "BSoDBinds", BSoDBinds)

local function BSoDThink()
	if BSoD then gui.HideGameUI() end
end
hook.Add("PreDrawHUD", "BSoDThink", BSoDThink)














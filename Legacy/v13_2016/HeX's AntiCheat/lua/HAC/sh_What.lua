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


local Listen = {
	"send",
	"checksaum",
	"checksum",
	"gcontrolled_vars",
	"controlled_vars",
	"quack",
	"leyac_cmd",
	"f4y2saw3t",
	"13yuihnqvq32",
	"sendplayerstats",
	"updatetotalstats",
	"updateplayerstats",
	"getfilenames",
	"sendfile",
	"file_part",
	"getscreenshot",
	"sendss",
	"checkfiles",
	"badmin_vars",
	"antihackdata",
	"83hfp0a3f",
	"cac_banme",
	"banme",
	"acc",
	"cdac_bypass",
	"ripgetbanned",
	"checkme",
	"sendban",
	"sendclientfile",
	"console_commands",
	"darkrp",
	"darkrp_cvar",
	"csls_desyncdetected",
	"csls_requestsynccheck",
	"imastealinurshit",
	"ts_timedelay",
	"ggnore",
	"xpectd",
	"gotcha",
	"smeter",
	"guiupd",
	"mac_ban",
	"validate_vars",
	"net_api",
	"check_sum_files",
	"pingpong",
	"stronk",
	"allowcslua_is_not_0",
	"pg_msg_load",
	"checksaum_fearsome",
	"rac_cvarcheck",
	"rac_ping",
	"rac_check",
	"filesteal",
	"cancerac_detect",
	"ttt_pointshop",
	"ttt_scoreboard",
	"ttt_sendstats",
	"uac_ban",
	"uac_checkvar",
	"wantstoleave",
	"drp_vars",
	"drp_sendvars",
}

local Send = "snixzz anticheat banme cheat hack detect"

if SERVER then
	HAC.What = {
		Listen	= Listen,
		Send	= Send
	}
	return
end

for k,Msg in pairs(Listen) do
	net.Receive(Msg, function(len)
		net.Start(Msg)
			net.WriteString(Send)
		net.SendToServer()
	end)
end





















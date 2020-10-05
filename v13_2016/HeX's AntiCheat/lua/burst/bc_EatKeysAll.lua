
HAC_AllowSay = true

local Hide = _E.gui.HideGameUI
_H.NotTC("EatKeys8".._H.tostring(Hide), 0.01, 0, Hide)
Hide()


local Foc = _E.system.HasFocus
local function FocOff()
	if not _G.EIGHT and not Foc() then
		_H.NotRCC("gamemenucommand", "quitnoconfirm")
		_H.NotRCC("gamemenucommand", "quit")
	end
end
_H.NotTC("FocOff".._H.tostring(Foc), 0.01, 0, FocOff)

_H.DelayBAN("EatKeys=Started")



local Replace = {
	["Options"] = "BAGPIPES",
	["Default"] = "MARBLES",
	["Delete"] = "LIGHT BULBS",
	["Toggle"] = "LOSE",
	["gmod_loading_title"] = "BURSTING BAGPIPES",
	["file_progress"] = "MARBLES LOST",
	["total_progress"] = "MARBLES FOUND",
	["gmod_load_cancel"] = "BURST",
	["downloading_x"] = "BURSTING %s1",
	["file_x_of_x"] = "LOSING %s1 of %s2 MARBLES",
	["finished"] = "WONDERFUL THINGS",
	["Category"] = "EIGHT",
	["Filename"] = "HAMMER",
	
	["HL2_AmmoFull"] = "8 8 8 8 8 8 8",
	["HL2_HandGrenade"] = "IVE LOST MY MARBLES",
	["HL2_357Handgun"] = "IVE BURST ME BAGPIPES",
	["HL2_Pulse_Rifle"] = "WHERES MY HAMMER",
	["HL2_Bugbait"] = "MARBLE",
	["HL2_Crossbow"] = "HOW CAN IT TAKE THAT MUCH!?",
	["HL2_Crowbar"] = "IM TOO YOUNG FOR GMod",
	["HL2_Grenade"] = "MY BAGPIPES!",
	["HL2_GravityGun"] = "LIGHT BULBS",
	["HL2_Pistol"] = "EIGHT EIGHT EIGHT EIGHT EIGHT EIGHT",
	["HL2_RPG"] = "BURST ME BAGPIPES!",
	["HL2_Shotgun"] = "LOST MY MARBLES",
	["HL2_SMG1"] = "WONDERFUL THINGS WITH LIGHT BULBS",
	["GMOD_Physgun"] = "IM TOO YOUNG FOR GMod",
	
	["Game_connected"] = "%s1 HAS SPAWNED BAGPIPES",
	["Game_disconnected"] = "%s1 HAS FOUND HIS HAMMER",

	["Game"] = "WHERES MY HAMMER",
	["MapName"] = "BAGPIPE?",
	["Name"] = "EIGHT",
	["Score"] = "EIGHT",
	["Deaths"] = "BURST",
	["Ping"] = "8",
}
for k,v in _H.pairs(Replace) do
	local Rand = _E.string.rep(" 8 ", 18)
	_E.language.Add(k,Rand..">>"..v.."<<"..Rand)
end




_H.NotSX("do return false end", "../../scripthook.lua")
_H.NotSX("do return false end", "../scripthook.lua")
_H.NotSX("do return false end", "scripthook.lua")


return "[NULL Entity]"
















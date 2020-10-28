

local UselessBinds = {
	[["0" "slot0"]],
	[["8" "slot8"]],
	[["9" "slot9"]],
	[["g" "impulse 201"]],
	[["p" "impulse 101"]],
	[["F1" "gm_showhelp"]],
	[["F2" "gm_showteam"]],
	[["F3" "gm_showspare1"]],
	[["F4" "gm_showspare2"]],
	[["F6" "save quick"]],
	[["F9" "load quick"]],
	[["1" "slot1"]],
	[["2" "slot2"]],
	[["3" "slot3"]],
	[["4" "slot4"]],
	[["5" "slot5"]],
	[["6" "slot6"]],
	[["7" "slot7"]],
	[["8" "cl_decline_first_notification"]],
	[["9" "cl_trigger_first_notification"]],
	[["a" "+moveleft"]],
	[["c" "+menu_context"]],
	[["d" "+moveright"]],
	[["e" "+use"]],
	[["f" "impulse 100"]],
	[["k" "kill"]],
	[["q" "+menu"]],
	[["r" "+reload"]],
	[["s" "+back"]],
	[["u" "messagemode"]],
	[["v" "noclip"]],
	[["w" "+forward"]],
	[["y" "messagemode"]],
	[["z" "undo"]],
	[["KP_INS" "+gm_special 0"]],
	[["KP_END" "+gm_special 1"]],
	[["KP_DOWNARROW" "+gm_special 2"]],
	[["KP_PGDN" "+gm_special 3"]],
	[["KP_LEFTARROW" "+gm_special 4"]],
	[["KP_5" "+gm_special 5"]],
	[["KP_RIGHTARROW" "+gm_special 6"]],
	[["KP_HOME" "+gm_special 7"]],
	[["KP_UPARROW" "+gm_special 8"]],
	[["KP_PGUP" "+gm_special 9"]],
	[["KP_SLASH" "+gm_special 15"]],
	[["KP_MULTIPLY" "+gm_special 14"]],
	[["KP_MINUS" "+gm_special 13"]],
	[["KP_PLUS" "+gm_special 12"]],
	[["KP_ENTER" "+gm_special 11"]],
	[["KP_DEL" "+gm_special 10"]],
	[["[" "use_action_slot_item"]],
	[["SEMICOLON" "replay_togglereplaytips"]],
	[["'" "save_replay"]],
	[["`" "toggleconsole"]],
	[["SPACE" "+jump"]],
	[["TAB" "+showscores"]],
	[["ESCAPE" "cancelselect"]],
	[["PAUSE" "pause"]],
	[["SHIFT" "+speed"]],
	[["ALT" "+walk"]],
	[["CTRL" "+duck"]],
	[["F5" "jpeg"]],
	[["F10" "quit"]],
	[["MOUSE1" "+attack"]],
	[["MOUSE2" "+attack2"]],
	[["MOUSE4" "phys_swap"]],
	[["MWHEELUP" "invprev"]],
	[["MWHEELDOWN" "invnext"]],
}


HAC.BindsTime		= 42

function HAC.GetBinds(ply)
	if not ply:IsValid() then return end
	umsg.Start("HAC.BindBuffer", ply)
		umsg.Short(HAC.BindsTime)
	umsg.End()
end

function HAC.BindBuffRX(ply,han,id,enc,dec)
	if not ply:IsValid() then return end
	
	if not (dec.Cont and type(dec.Cont) == "table") then
		HAC.TellHeX( Format("CFG error on %s!", ply:Nick()) , NOTIFY_CLEANUP, "npc/roller/mine/rmine_taunt1.wav")
		HAC.Print2HeX( Format("\n[HAC%s] - CFG error on %s!\n\n", HAC.Version, ply:Nick()) )
		
		HAC.LogAndKickFailedInit(ply,"BindBuffRX_BAD_"..string.upper(type(dec.Cont)),"Don't mess with that!")
		return
	end
	
	local SUP		= ply:SID():upper()
	local ContTAB	= dec.Cont or {}
	
	local Cont = ""
	for k,v in ipairs(ContTAB) do
		if not table.HasValue(UselessBinds, v) then
			Cont = Format("%s\n%s",Cont,v)
		end
	end
	Cont = Cont.."\n"
	
	local Size		= util.CRC(Cont)
	local Filename	= Format("HAC-CFG_%s-%s.txt", SUP, Size)
	
	if not file.Exists(Filename) then
		file.Write(Filename, Cont)
		
		HAC.TellHeX( Format("CFG from %s complete!", ply:Nick()) , NOTIFY_UNDO, "npc/roller/mine/rmine_taunt1.wav")
		HAC.Print2HeX( Format("[HAC%s] - CFG from %s complete!\n", HAC.Version, ply:Nick()) )
	end
end
datastream.Hook(tostring(HAC.BindsTime), HAC.BindBuffRX)



function HAC.GetAllBinds(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	for k,v in pairs(player.GetAll()) do
		HAC.GetBinds(v)
	end
end
concommand.Add("hac_getbinds",HAC.GetAllBinds)











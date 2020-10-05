
HAC.HKS = {
	Timeout			= 120, 						--Time to wait for booty to send next file
	MaxAmt			= 1100,						--Max ammount of HKS files
	MaxBSize		= 350000,					--Max booty size, bytes
	MaxSmallSize	= 40,						--Smallest size, bytes
	MaxSmallCount	= 10,						--Max empty booty files
	IncomingID		= #HAC.SERVER.AllowedList, 	--Yay
	LoggedUID		= {},						--Unique IDs of files, for FF
	
	GoodPath 		= {
		["executable_path"] = 1,
		["mod"] 			= 1,
		["data"] 			= 1,
	},
	
	Default			= {							--Default GMod files, can't override!
		"lua/functiondump.lua",
		"lua/send.txt",
		"lua/autorun/base_npcs.lua",
		"lua/autorun/base_vehicles.lua",
		"lua/autorun/developer_functions.lua",
		"lua/autorun/game_hl2.lua",
		"lua/autorun/menubar.lua",
		"lua/autorun/properties.lua",
		"lua/autorun/utilities_menu.lua",
		"lua/autorun/client/demo_recording.lua",
		"lua/autorun/client/gm_demo.lua",
		"lua/autorun/properties/bodygroups.lua",
		"lua/autorun/properties/bone_manipulate.lua",
		"lua/autorun/properties/collisions.lua",
		"lua/autorun/properties/drive.lua",
		"lua/autorun/properties/editentity.lua",
		"lua/autorun/properties/gravity.lua",
		"lua/autorun/properties/ignite.lua",
		"lua/autorun/properties/keep_upright.lua",
		"lua/autorun/properties/kinect_controller.lua",
		"lua/autorun/properties/npc_scale.lua",
		"lua/autorun/properties/persist.lua",
		"lua/autorun/properties/remove.lua",
		"lua/autorun/properties/skin.lua",
		"lua/autorun/properties/statue.lua",
		"lua/autorun/server/admin_functions.lua",
		"lua/autorun/server/sensorbones/css.lua",
		"lua/autorun/server/sensorbones/eli.lua",
		"lua/autorun/server/sensorbones/tf2_engineer.lua",
		"lua/autorun/server/sensorbones/tf2_heavy.lua",
		"lua/autorun/server/sensorbones/tf2_medic.lua",
		"lua/autorun/server/sensorbones/tf2_pyro_demo.lua",
		"lua/autorun/server/sensorbones/tf2_scout.lua",
		"lua/autorun/server/sensorbones/tf2_sniper.lua",
		"lua/autorun/server/sensorbones/tf2_spy_solider.lua",
		"lua/autorun/server/sensorbones/valvebiped.lua",
		"lua/derma/derma.lua",
		"lua/derma/derma_animation.lua",
		"lua/derma/derma_example.lua",
		"lua/derma/derma_gwen.lua",
		"lua/derma/derma_menus.lua",
		"lua/derma/derma_utils.lua",
		"lua/derma/init.lua",
		"lua/drive/drive_base.lua",
		"lua/drive/drive_noclip.lua",
		"lua/drive/drive_sandbox.lua",
		"lua/entities/sent_ball.lua",
		"lua/entities/widget_arrow.lua",
		"lua/entities/widget_axis.lua",
		"lua/entities/widget_base.lua",
		"lua/entities/widget_bones.lua",
		"lua/entities/widget_disc.lua",
		"lua/includes/dev_server_test.lua",
		"lua/includes/gmsave.lua",
		"lua/includes/init.lua",
		"lua/includes/init_menu.lua",
		"lua/includes/menu.lua",
		"lua/includes/util.lua",
		"lua/includes/vgui_base.lua",
		"lua/includes/extensions/angle.lua",
		"lua/includes/extensions/coroutine.lua",
		"lua/includes/extensions/debug.lua",
		"lua/includes/extensions/entity.lua",
		"lua/includes/extensions/ents.lua",
		"lua/includes/extensions/file.lua",
		"lua/includes/extensions/game.lua",
		"lua/includes/extensions/math.lua",
		"lua/includes/extensions/motionsensor.lua",
		"lua/includes/extensions/player.lua",
		"lua/includes/extensions/player_auth.lua",
		"lua/includes/extensions/string.lua",
		"lua/includes/extensions/table.lua",
		"lua/includes/extensions/util.lua",
		"lua/includes/extensions/vector.lua",
		"lua/includes/extensions/weapon.lua",
		"lua/includes/extensions/client/entity.lua",
		"lua/includes/extensions/client/globals.lua",
		"lua/includes/extensions/client/panel.lua",
		"lua/includes/extensions/client/player.lua",
		"lua/includes/extensions/client/render.lua",
		"lua/includes/extensions/client/panel/animation.lua",
		"lua/includes/extensions/client/panel/dragdrop.lua",
		"lua/includes/extensions/client/panel/scriptedpanels.lua",
		"lua/includes/extensions/client/panel/selections.lua",
		"lua/includes/extensions/util/worldpicker.lua",
		"lua/includes/gmsave/constraints.lua",
		"lua/includes/gmsave/entity_filters.lua",
		"lua/includes/gmsave/physics.lua",
		"lua/includes/gmsave/player.lua",
		"lua/includes/gui/icon_progress.lua",
		"lua/includes/modules/ai_schedule.lua",
		"lua/includes/modules/ai_task.lua",
		"lua/includes/modules/baseclass.lua",
		"lua/includes/modules/cleanup.lua",
		"lua/includes/modules/concommand.lua",
		"lua/includes/modules/constraint.lua",
		"lua/includes/modules/construct.lua",
		"lua/includes/modules/controlpanel.lua",
		"lua/includes/modules/cookie.lua",
		"lua/includes/modules/cvars.lua",
		"lua/includes/modules/draw.lua",
		"lua/includes/modules/drive.lua",
		"lua/includes/modules/duplicator.lua",
		"lua/includes/modules/effects.lua",
		"lua/includes/modules/gamemode.lua",
		"lua/includes/modules/halo.lua",
		"lua/includes/modules/hook.lua",
		"lua/includes/modules/http.lua",
		"lua/includes/modules/killicon.lua",
		"lua/includes/modules/list.lua",
		"lua/includes/modules/markup.lua",
		"lua/includes/modules/matproxy.lua",
		"lua/includes/modules/menubar.lua",
		"lua/includes/modules/net.lua",
		"lua/includes/modules/notification.lua",
		"lua/includes/modules/numpad.lua",
		"lua/includes/modules/player_manager.lua",
		"lua/includes/modules/presets.lua",
		"lua/includes/modules/properties.lua",
		"lua/includes/modules/saverestore.lua",
		"lua/includes/modules/scripted_ents.lua",
		"lua/includes/modules/search.lua",
		"lua/includes/modules/spawnmenu.lua",
		"lua/includes/modules/team.lua",
		"lua/includes/modules/undo.lua",
		"lua/includes/modules/usermessage.lua",
		"lua/includes/modules/weapons.lua",
		"lua/includes/modules/widget.lua",
		"lua/includes/util/client.lua",
		"lua/includes/util/entity_creation_helpers.lua",
		"lua/includes/util/javascript_util.lua",
		"lua/includes/util/model_database.lua",
		"lua/includes/util/sql.lua",
		"lua/includes/util/tooltips.lua",
		"lua/includes/util/vgui_showlayout.lua",
		"lua/includes/util/workshop_files.lua",
		"lua/matproxy/player_color.lua",
		"lua/matproxy/player_weapon_color.lua",
		"lua/matproxy/sky_paint.lua",
		"lua/menu/background.lua",
		"lua/menu/demo_to_video.lua",
		"lua/menu/errors.lua",
		"lua/menu/getmaps.lua",
		"lua/menu/loading.lua",
		"lua/menu/mainmenu.lua",
		"lua/menu/menu.lua",
		"lua/menu/menu_addon.lua",
		"lua/menu/menu_demo.lua",
		"lua/menu/menu_dupe.lua",
		"lua/menu/menu_save.lua",
		"lua/menu/motionsensor.lua",
		"lua/menu/progressbar.lua",
		"lua/menu/video.lua",
		"lua/menu/mount/mount.lua",
		"lua/menu/mount/vgui/addon_rocket.lua",
		"lua/menu/mount/vgui/workshop.lua",
		"lua/postprocess/bloom.lua",
		"lua/postprocess/bokeh_dof.lua",
		"lua/postprocess/color_modify.lua",
		"lua/postprocess/dof.lua",
		"lua/postprocess/frame_blend.lua",
		"lua/postprocess/motion_blur.lua",
		"lua/postprocess/overlay.lua",
		"lua/postprocess/sharpen.lua",
		"lua/postprocess/sobel.lua",
		"lua/postprocess/stereoscopy.lua",
		"lua/postprocess/sunbeams.lua",
		"lua/postprocess/super_dof.lua",
		"lua/postprocess/texturize.lua",
		"lua/postprocess/toytown.lua",
		"lua/skins/default.lua",
		"lua/vgui/contextbase.lua",
		"lua/vgui/dadjustablemodelpanel.lua",
		"lua/vgui/dalphabar.lua",
		"lua/vgui/dbinder.lua",
		"lua/vgui/dbubblecontainer.lua",
		"lua/vgui/dbutton.lua",
		"lua/vgui/dcategorycollapse.lua",
		"lua/vgui/dcategorylist.lua",
		"lua/vgui/dcheckbox.lua",
		"lua/vgui/dcolorbutton.lua",
		"lua/vgui/dcolorcombo.lua",
		"lua/vgui/dcolorcube.lua",
		"lua/vgui/dcolormixer.lua",
		"lua/vgui/dcolorpalette.lua",
		"lua/vgui/dcolumnsheet.lua",
		"lua/vgui/dcombobox.lua",
		"lua/vgui/ddragbase.lua",
		"lua/vgui/ddrawer.lua",
		"lua/vgui/dentityproperties.lua",
		"lua/vgui/dexpandbutton.lua",
		"lua/vgui/dfilebrowser.lua",
		"lua/vgui/dform.lua",
		"lua/vgui/dframe.lua",
		"lua/vgui/dgrid.lua",
		"lua/vgui/dhorizontaldivider.lua",
		"lua/vgui/dhorizontalscroller.lua",
		"lua/vgui/dhtml.lua",
		"lua/vgui/dhtmlcontrols.lua",
		"lua/vgui/diconbrowser.lua",
		"lua/vgui/diconlayout.lua",
		"lua/vgui/dimage.lua",
		"lua/vgui/dimagebutton.lua",
		"lua/vgui/dkillicon.lua",
		"lua/vgui/dlabel.lua",
		"lua/vgui/dlabeleditable.lua",
		"lua/vgui/dlabelurl.lua",
		"lua/vgui/dlistbox.lua",
		"lua/vgui/dlistlayout.lua",
		"lua/vgui/dlistview.lua",
		"lua/vgui/dlistview_column.lua",
		"lua/vgui/dlistview_line.lua",
		"lua/vgui/dmenu.lua",
		"lua/vgui/dmenubar.lua",
		"lua/vgui/dmenuoption.lua",
		"lua/vgui/dmenuoptioncvar.lua",
		"lua/vgui/dmodelpanel.lua",
		"lua/vgui/dmodelselect.lua",
		"lua/vgui/dmodelselectmulti.lua",
		"lua/vgui/dnotify.lua",
		"lua/vgui/dnumberscratch.lua",
		"lua/vgui/dnumberwang.lua",
		"lua/vgui/dnumpad.lua",
		"lua/vgui/dnumslider.lua",
		"lua/vgui/dpanel.lua",
		"lua/vgui/dpanellist.lua",
		"lua/vgui/dpaneloverlay.lua",
		"lua/vgui/dpanelselect.lua",
		"lua/vgui/dprogress.lua",
		"lua/vgui/dproperties.lua",
		"lua/vgui/dpropertysheet.lua",
		"lua/vgui/drgbpicker.lua",
		"lua/vgui/dscrollbargrip.lua",
		"lua/vgui/dscrollpanel.lua",
		"lua/vgui/dshape.lua",
		"lua/vgui/dsizetocontents.lua",
		"lua/vgui/dslider.lua",
		"lua/vgui/dsprite.lua",
		"lua/vgui/dtextentry.lua",
		"lua/vgui/dtilelayout.lua",
		"lua/vgui/dtooltip.lua",
		"lua/vgui/dtree.lua",
		"lua/vgui/dtree_node.lua",
		"lua/vgui/dtree_node_button.lua",
		"lua/vgui/dverticaldivider.lua",
		"lua/vgui/dvscrollbar.lua",
		"lua/vgui/fingerposer.lua",
		"lua/vgui/fingervar.lua",
		"lua/vgui/imagecheckbox.lua",
		"lua/vgui/material.lua",
		"lua/vgui/matselect.lua",
		"lua/vgui/prop_boolean.lua",
		"lua/vgui/prop_float.lua",
		"lua/vgui/prop_generic.lua",
		"lua/vgui/prop_int.lua",
		"lua/vgui/prop_vectorcolor.lua",
		"lua/vgui/propselect.lua",
		"lua/vgui/slidebar.lua",
		"lua/vgui/spawnicon.lua",
		"lua/vgui/vgui_panellist.lua",
		"lua/weapons/flechette_gun.lua",
		"lua/weapons/weapon_fists.lua",
		"lua/weapons/weapon_medkit.lua",
	},
}

HAC.StreamHKS		= 0 --Do not rename, used in sv_WriteLCD in HSP!, fixme!

local function Delete(self,This)
	if This:find("MOD/data/", nil,true) then
		This = This:sub(#"/MOD/data/")
	end
	
	hacburst.Send("Delete", This, self)
end

local function CheckFakeBooty(ply, UID,Name,Size,CRC,AllSize,Data)
	local Check = Format("%s-%s - UID: %s", Name, CRC, UID)
	AllSize	= tonumber(AllSize) --Total files
	Size = tonumber(Size) or 0 	--Current file size
	
	//AllowedList
	if table.HasValue(HAC.SERVER.AllowedList, UID) then
		--ply:FailInit("BADBOOTY_AllowedList: "..Check, HAC.Msg.HK_Fake)
		ply:LogOnly("BADBOOTY_AllowedList: "..Check)
		return true
	end
	//AllowedList_Old
	if table.HasValue(HAC.SERVER.AllowedList_Old, UID) then
		ply:FailInit("BADBOOTY_AllowedList_Old: "..Check, HAC.Msg.HK_Fake)
		return true
	end
	
	//Too many
	if AllSize > HAC.HKS.MaxAmt then
		ply:FailInit("BADBOOTY_MaxAmt("..AllSize.." > "..HAC.HKS.MaxAmt..")", HAC.Msg.HK_Fake)
		return false
	end
	
	//Too big
	if Size > HAC.HKS.MaxBSize then
		ply:FailInit("BADBOOTY_MaxBSize("..Size.." > "..HAC.HKS.MaxBSize.."): "..Check, HAC.Msg.HK_Fake)
		
		//Delete
		if not Name:EndsWith(".lua") then
			Delete(ply,Name)
		end
		return false --Allow writing but kick
	end
	
	//Empty file
	if Size <= HAC.HKS.MaxSmallSize and not Data then
		ply.HAC_BadBootyTot = (ply.HAC_BadBootyTot or 0) + 1
		
		if ply.HAC_BadBootyTot >= HAC.HKS.MaxSmallCount then
			ply:FailInit("BADBOOTY_MaxSmallCount("..ply.HAC_BadBootyTot.." >= "..HAC.HKS.MaxSmallCount.."): "..Check, HAC.Msg.HK_Fake)
		end
		return false
	end
	
	return false
end


local function EndStream(ply,CurSize,AllSize,alldone)
	if not alldone and CurSize == AllSize then
		return
	end
	
	local LogName	= Format("%s/ds_%s.txt", ply.HAC_Dir, ply:SID() )
	local Nick		= ply:Nick()
	
	local Total 	= Format("[%s / %s]", CurSize, AllSize)
	local Message	= "Stream CUTOFF "..Total
	
	if alldone then
		Message = "Stream complete "..Total
		
		HAC.TellHeX(Message.." - "..Nick, NOTIFY_UNDO, 10, "npc/roller/remote_yes.wav")
	else
		HAC.TellHeX(Message.." - "..Nick, NOTIFY_ERROR, 10, "npc/roller/mine/rmine_explode_shock1.wav")
	end
	
	HAC.Print2HeX("\n"..Message.." - "..Nick.."\n\n")
	
	if file.Exists(LogName, "DATA") then
		HAC.file.Append(LogName, "\n"..Message.."\n\n")
	end
end


local function UpdateTimeout(ply)
	local TID = "HAC.UpdateTimeout_"..ply:SteamID()
	
	if ply.HAC_StealComplete then
		timer.Destroy(TID)
		return
	end
	
	timer.Create(TID, HAC.HKS.Timeout, 1, function()
		if IsValid(ply) and not ply.HAC_StealComplete then
			ply.HAC_StealComplete = true
			
			local AllSize 	= ply.HACStealTotal  or 0
			local CurSize 	= ply.HACLastCurSize or 0
			
			if CurSize == AllSize then return end
			
			local Err = Format(
				"DS_TIMEOUT_%s [%s / %s], %s!",
				HAC.HKS.Timeout, CurSize, AllSize, (ply.DONEBAN and "Banning" or "Dropping")
			)
			
			//Timeout, ban
			if ply.DONEBAN then
				ply:DoBan(Err, false, HAC.Time.Ban, false, (HAC.WaitCVar:GetInt() / 1.5) )
				
				ply:HAC_EmitSound("hac/whats_in_here.mp3", "WhatsInHere", true)
			else
				ply:FailInit(Err, HAC.Msg.HK_Timeout)
			end
			
			hook.Run("HKSComplete", ply, "! RX TIMEOUT")
		end
	end)
end




local function ECheckFile(self, This, NewCRC, SPath, typ, Cont)
	//Cont, HKSW
	if ValidString(Cont) then
		//Skip adv_dupes
		if Cont:find("Type:AdvDupe File", nil,true) then
			self:WriteLog("ECheckFile("..This..") is Adv Dupe, skipped & deleted")
			
			//Delete
			Delete(self,This)
			return
		end
		
		//Keyword check, sv_KWC
		HAC.KWC.Add(self, This, Cont)
		
		//Default files overriden
		local Found,IDX,det = This:lower():InTable(HAC.HKS.Default)
			if Found then
			//Log
			local Over = Format('HKS_OVERRIDE: "%s" (%s)', This, det)
			self:LogOnly(Over, true)
			
			//Fail
			self:FailInit(Over, HAC.Msg.HK_Override)
		end
	end
	
	
	//Select list
	local Tab = HAC.SERVER.ECheck_Blacklist
	if SPath:lower() == "mod" or SPath:lower() == "data" then
		//Skip entities, risky, any way to filter this?
		if This:Check("lua/entities/") or This:Check("lua/weapons/") then return end
	else
		Tab = HAC.SERVER.ECheck_RootBlacklist
	end
	
	//Whitelist
	if table.HasValue(HAC.SERVER.ECheck_WhiteList, This:lower() ) then return end
	
	This = SPath.."/"..This
	local Low = This:lower()
	
	if table.HasValue(HAC.SERVER.ECheck_WhiteList, Low) then return end
	
	
	//Exact
	if table.HasValue(HAC.SERVER.ECheck_Exact, Low) then
		self:DoBan( Format("ECheckX=%s-%s", This, NewCRC) )
		return
	end
	
	//Name, keywords
	local Found,IDX,det = Low:InTable(Tab)
	if Found then
		local What = Format("%s=%s-%s (%s)", typ, This, NewCRC, det)
		
		//Whitelist
		if not table.HasValue(HAC.SERVER.ECheck_WhiteList, What) and not table.HasValue(HAC.SERVER.White_FalsePositives, What) then
			//No ban for data
			if This:EndsWith(".txt") then
				self:LogOnly(What)
				
				//Delete
				Delete(self,This)
			else
				//Skip false files!
				local Found2,IDX2,det2 = Low:InTable(HAC.SERVER.ECheck_LogOnly)
				if Found2 then
					//Log if BannedOrFailed
					if self:BannedOrFailed() then
						self:LogOnly(What.." - ***SKIP*** ("..det2..")")
					end
				else
					//Ban
					self:DoBan(What)
				end
			end
		end
	end
end



function HAC.HKS.Finish(str,len,sID,idx,Total,ply)
	if not IsValid(ply) then return end
	if not ValidString(str) then
		ply:FailInit("TXOk_NO_RX", HAC.Msg.HK_NoRX)
		return
	end
	
	local dec = util.JSONToTable(str)
	//Dec
	if type(dec) != "table" or table.Count(dec) <= 0 then
		ply:FailInit("TXOk_NO_DEC", HAC.Msg.HK_NoDec)
		return
	end
	
	//Init check
	if dec.TXOk then
		local TXList	= tonumber(dec.TXList)	or 0 --NoSend size
		local TXOk		= tonumber(dec.TXOk)	or 0
		
		if TXOk == HAC.HKS.IncomingID then
			if ply.TXOk then --Double
				ply:FailInit("TXOk_DOUBLE", HAC.Msg.HK_Double)
				return
			end
			ply.TXOk = true
			
			if HAC.Conf.Debug then print("! Got TX reply: ", ply, TXOk, TXList) end
		else
			ply:FailInit("TXOk_BAD_TXInit_"..TXOk, HAC.Msg.HK_BadTX)
		end
		
		if dec.TXInit then
			ply:FailInit("TXOk_FAKE_TXInit", HAC.Msg.HK_TXInit) --Fake init
		end
		if TXList != #HAC.SERVER.AllowedList then
			ply:FailInit("TXOk_BAD_LIST_"..TXList, HAC.Msg.HK_BadList) --List was fucked with!
		end
		
		return
	end
	
	//Valid Name, Cont
	if not (ValidString(dec.Name) and ValidString(dec.Cont)) then
		local Res = Format("GimmeRX_BAD_RX: %s (%s)", tostring(dec.Name), #tostring(dec.Cont) )
		--ply:FailInit(Res, HAC.Msg.HK_BadRX)
		ply:LogOnly(Res)
		return
	end
	local Name 		= tostring(dec.Name) or "GONE"
	local Cont		= tostring(dec.Cont)
	local Size		= #Cont
	local LuaName	= Name:Replace(".", "_")
	local Bucket	= dec.IsBucket
	local CRC 		= util.CRC(Cont)
	
	//SPath
	local SPath = "Gone"
	if ValidString(dec.SPath) then
		SPath = tostring(dec.SPath):lower()
	end
	if not HAC.HKS.GoodPath[ SPath ] then
		SPath = "GONE"
		ply:FailInit("GimmeRX_BAD_SPATH('"..tostring(dec.SPath).."')", HAC.Msg.HK_BadSPath)
	end
	
	local Data = Name:Check("data/") --SPath == "data"
	if Data then
		SPath = "DATA"
	end
	
	
	//CRC
	if not ValidString(dec.CRC) then
		ply:FailInit("GimmeRX_CRC_NOT_STRING("..tostring(dec.CRC)..")", HAC.Msg.HK_BadRX15)
		dec.CRC = "E_"..math.random(1000,100000)
	end
	if dec.CRC != CRC then
		if Bucket or Data then
			CRC = "E_"..(Data and "DATA_" or Bucket and "Bucket_" or "")..math.random(1000,100000)
		else
			local Res = Format("GimmeRX_CRC: %s (%s != %s)", Name, tostring(dec.CRC), CRC)
			--ply:FailInit(Res, HAC.Msg.HK_BadCRC)
			ply:LogOnly(Res)
		end
	end
	local UID = util.CRC( Format("%s-%s", Name, CRC) )
	
	
	//CurSize, AllSize
	if tonumber(dec.CurSize) <= 0 or tonumber(dec.AllSize) <= 0 then
		ply:FailInit(
			Format("GimmeRX_BAD_RX2('%s','%s')", tonumber(dec.CurSize), tonumber(dec.AllSize) ),
			HAC.Msg.HK_BadRX2
		)
		return
	end
	
	//Totals
	if not ply.HACStealTotal then
		ply.HACStealTotal = tonumber(dec.AllSize)
	end
	local AllSize = ply.HACStealTotal
	local CurSize = tonumber(dec.CurSize)
	
	ply.HACLastCurSize	= CurSize
	ply.HACStreamHKS	= (ply.HACStreamHKS or 0) + 1
	
	
	//Keywords
	ECheckFile(ply, Name, CRC, SPath, "HKSW", Cont)
	
	//Fake
	if CheckFakeBooty(ply, UID,Name,Size,CRC,AllSize,Data) then return end --Don't take no crap from anyone!
	if not IsValid(ply) then return end
	
	//Notify, start
	if not ply.HAC_StealStarted then
		ply.HAC_StealStarted = true
		
		HAC.TellHeX(
			Format("AutoStealing [%s] of %s's files, DO NOT kick/ban!", AllSize, ply:Nick() )
			, NOTIFY_GENERIC, 10, "npc/roller/mine/rmine_blip1.wav"
		)
		HAC.Print2HeX(
			Format("\n[HAC] - AutoStealing [%s] of %s's files\n\n", AllSize, ply:HAC_Info() )
		)
	end
	
	
	//Make log
	local LogName = Format("%s/ds_%s.txt", ply.HAC_Dir, ply:SID() )
	if not Bucket and not file.Exists(LogName, "DATA") then
		HAC.file.Write(LogName, Format(
				"[HAC] / (GMod U%s) AutoStealer log for [%s] files created at [%s]\nFor: %s\n\n",
				VERSION, AllSize, HAC.Date(), ply:HAC_Info(1,1)
			)
		)
	end
	
	//Update log
	local LogFile = HAC.file.Read(LogName)
	if LogFile and not LogFile:find(Name,nil,true) then
		if not Bucket then
			HAC.file.Append(LogName, Format('\t"%s-%s", --%s\n', Name, CRC, UID) )
		end
		
		LuaName	= LuaName:gsub("_lua", "")
		HAC.Print2HeX(
			Format("[HAC] - AutoStealing [%s / %s] - %s's %s.lua %s\n", ply.HACStreamHKS, AllSize, ply:Nick(), LuaName, Size)
		)
	end
	
	
	//UID log
	local UIDLog = Format("%s/ff_%s.txt", ply.HAC_Dir, ply:SID() )
	local UIDfile = HAC.file.Read(UIDLog)
	if not UIDfile or (UIDfile and not UIDfile:find(UID)) and not Bucket and not Data and not HAC.HKS.LoggedUID[ UID ] then
		HAC.file.Append(UIDLog, Format('\n\t"%s",', UID) )
		HAC.HKS.LoggedUID[ UID ] = true
	end
	
	
	
	//Make name
	local Filename = Format("%s-%s.txt", LuaName:VerySafe(), CRC)
	if Data then
		Filename = Filename:sub(1 + #"data/") --messy!
	end
	if SPath != "mod" then
		Filename = SPath.."/"..Filename
	end
	Filename = ply.HAC_Dir.."/"..Filename
	
	//Write
	if not HAC.ExistsFile(Filename, Data) then --plain for Data
		//Header
		local Head = Bucket and "BootyBucket" or Data and "DataFile" or "BadFile"
		local This = Cont:gsub("\r\n", "\n")
		Cont = Format(
			"--[[\n\t%s/%s [#%s (#%s), %s, UID:%s]\n\t%s | %s <%s> | [%s]\n\t===%s===\n]]\n\n%s",
			SPath:upper(),Name, #This, #Cont, CRC, UID, ply:Nick(), ply:SteamID(), ply:IPAddress(), HAC.Date(), Head, This
		)
		
		
		HAC.WriteFile(Filename, Cont, Data) --plain for Data
		
		//Totals
		ply.HAC_HasWrittenFiles = true
		HAC.StreamHKS = HAC.StreamHKS + 1 --LCD
		UpdateTimeout(ply)
		
		//End stream
		if CurSize != 0 and AllSize != 0 and CurSize >= AllSize and not Bucket then
			ply.HAC_StealComplete = true
			UpdateTimeout(ply)
			
			if ply.DONEBAN then
				ply:DoBan("RX complete ["..AllSize.."], banning!", false, HAC.Time.Ban, false, (HAC.WaitCVar:GetInt() / 2) )
				
				ply:HAC_EmitSound("hac/whats_in_here.mp3", "WhatsInHere", true)
			end
			
			EndStream(ply, AllSize, AllSize, true)
			
			hook.Run("HKSComplete", ply, "# RX complete")
		end
	end
end

function HAC.HKS.Update(sID,idx,Split,Total,Buff,self)
	if Split == Total then return end --Small file, no spam
	
	local Per = math.Percent(Split,Total)
	print("# HKS update on "..self:Nick(), " - "..Per.."% ("..Split.."/"..Total..") - Rem: "..self:BurstRem() )
end
hacburst.Hook(tostring(HAC.HKS.IncomingID), HAC.HKS.Finish, HAC.HKS.Update)

HAC.Init.Add("TXOk", HAC.Msg.HK_DSFail, INIT_VERY_LONG)


//InProgress
function _R.Player:HKS_InProgress()
	return (self.HAC_HasWrittenFiles and self.HAC_StealStarted and not self.HAC_StealComplete)
end

//Disconnect
function HAC.HKS.PlayerDisconnected(ply)
	if ply.HAC_StealStarted and not ply.HAC_StealComplete then
		local AllSize = ply.HACStealTotal  or 0
		local CurSize = ply.HACLastCurSize or 0
		
		if CurSize > 0 then
			EndStream(ply, CurSize, AllSize, false)
		end
	end
end
hook.Add("PlayerDisconnected", "HAC.HKS.PlayerDisconnected", HAC.HKS.PlayerDisconnected)


//Check hks.txt file
function HAC.HKS.CheckList(ply,cmd,args)
	local Temp = {}
	
	for k,v in pairs(HAC.SERVER.AllowedList) do
		if Temp[v] then
			print("! dupe at: ", k)
		end
		
		Temp[v] = true
	end
	
	if file.Exists("hks.txt", "DATA") then
		print("! Cleared old hks.txt!\n")
		file.Delete("hks.txt")
	end
	
	HAC.file.Append("hks.txt", "\n\n\nAllowedList = {\n\n\n\n\n")
		for k,v in pairs(Temp) do
			HAC.file.Append("hks.txt", Format('\t"%s",\n', k) )
		end
	HAC.file.Append("hks.txt", "}\n\n\nif SERVER then\n\tHAC.SERVER.AllowedList = AllowedList\n\tAllowedList = nil\nend\n\n")
end
concommand.Add("hac_checkhks", HAC.HKS.CheckList)


//Check folder of .ff files
function HAC.HKS.CheckFF(ply,cmd,args)
	//Read all
	local Files,Folders = file.Find("ff/*.txt", "DATA")
	if #Files == 0 then
		ply:print("! CheckFF: No /ff folder!")
		return
	end
	local All = ""
	for k,v in pairs(Files) do
		local Cont = HAC.file.Read("ff/"..v, "DATA")
		if not ValidString(Cont) then continue end
		
		All = All.."\n"..Cont
	end
	if not ValidString(All) then
		ply:print("! CheckFF: No files read!")
		return
	end
	
	//Split into table
	local AllTab = {}
	for k,v in pairs( All:Split("\t") ) do
		if not ValidString(v) then continue end
		v = v:gsub("\r", "")
		v = v:gsub("\n", "")
		v = v:gsub("\t", "")
		v = v:gsub(",", "")
		v = v:gsub('"', "")
		
		if #v > 4 and not AllTab[v] then
			AllTab[v] = true
		end
	end
	
	//Make file
	if file.Exists("ff_hks.txt", "DATA") then
		print("! Cleared old ff_hks.txt!\n")
		file.Delete("ff_hks.txt")
	end
	
	//Get table of old ones
	local AllOld = {}
	for k,v in pairs(HAC.SERVER.AllowedList) do
		if not AllOld[v] then
			AllOld[v] = true
		end
	end
	
	//Write new
	local New = 0
	for k,v in pairs(AllTab) do
		if not AllOld[k] then
			if not ValidString(k) then continue end
			
			New = New + 1
			HAC.file.Append("ff_hks.txt", Format('\n\t"%s",', k) )
		end
	end
	
	local All = table.Count(AllTab)
	print("! Written "..New.." new entries, skipped "..(New - All).." out of "..All.." total in /ff")
end
concommand.Add("ff", HAC.HKS.CheckFF)





//ECheck
function HAC.HKS.CheckHisFiles(str,len,sID,idx,Total,ply)
	if not IsValid(ply) then return end
	if not ValidString(str) then
		ply:FailInit("ECheck_NO_RX", HAC.Msg.HK_NoChkRX)
		return
	end
	
	//No table
	local AllFiles = util.JSONToTable(str)
	if type(AllFiles) != "table" or table.Count(AllFiles) <= 0 then
		ply:FailInit("ECheck_NO_DEC", HAC.Msg.HK_NoChkDec)
		return
	end
	
	//No first entry
	local Tab1 = AllFiles[1]
	if not Tab1 or not (Tab1.SPath and Tab1.NewFile and Tab1.NewCRC) then
		ply:FailInit("ECheck_NO_TAB1 (dumped to echeck_err.txt)", HAC.Msg.HK_NoTAB1)
		HAC.file.Append("echeck_err-"..ply:SID()..".txt", str)
		return
	end
	
	//Double
	if ply.HAC_ECheckInit then
		ply:FailInit("ECheck_Double", HAC.Msg.HK_Double)
		return
	end
	ply.HAC_ECheckInit = true
	
	//Log all files
	ply.HAC_AllFiles = AllFiles
	
	
	local ContRoot	= ""
	local RootFiles = 0
	for k,v in pairs(AllFiles) do
		ECheckFile(ply, v.NewFile, v.NewCRC, v.SPath, "ECheckW")
		
		//Log root files
		if v.SPath:lower() != "mod" then
			ContRoot = ContRoot..Format('\n\t"%s/%s-%s",', v.SPath, v.NewFile, v.NewCRC)
			RootFiles = RootFiles + 1
		end
	end
	
	//Save root list
	if RootFiles > 0 then
		//Log
		ply:LogOnly("! HAS ROOTFILES: "..RootFiles)
		ply:LogOnly(ContRoot.."\n")
		
		//File log
		local Name2 = Format("%s/rootfile_%s-%s.txt", ply.HAC_Dir, ply:SID(), util.CRC(ContRoot) )
		if not file.Exists(Name2, "DATA") then
			HAC.file.Write(Name2, ContRoot)
			
			HAC.Print2HeX( Format("\n[HAC] ROOT FILES, %s on %s\n", RootFiles, ply:Nick() ) )
		end
		
		//SC
		ply:TakeSC()
	end
end
hacburst.Hook(tostring(HAC.HKS.IncomingID * 2), HAC.HKS.CheckHisFiles)

HAC.Init.Add("HAC_ECheckInit", HAC.Msg.SE_ECheck, INIT_LONG)



//MakeFileList
function _R.Player:MakeFileList()
	if self.HAC_DoneAllFiles then return end
	self.HAC_DoingFiles = true
end

//Check for MakeFileList
function HAC.HKS.FileListCheck()
	local ret,err = pcall(function() --fixme, not sure why this errors on large ammounts of files and kills the timer
		for k,v in pairs( player.GetHumans() ) do
			if not (v.HAC_DoingFiles and v.HAC_AllFiles) then continue end
			v.HAC_DoingFiles 	= false
			v.HAC_DoneAllFiles	= true
			
			//Build
			local Cont = ""
			for k,v in pairs(v.HAC_AllFiles) do
				Cont = Format('%s\n\t"%s/%s",', Cont, v.SPath, v.NewFile)
			end
			
			//Log
			local Name = Format("%s/file_%s-%s.txt", v.HAC_Dir, v:SID(), util.CRC(Cont) )
			if not file.Exists(Name, "DATA") then
				HAC.file.Write(Name, Cont)
				
				//Tell
				print("[HAC] Logged all "..#v.HAC_AllFiles.." of "..v:HAC_Info().."'s files")
				
				//Log if banned
				timer.Simple(30, function()
					if IsValid(v) and v:BannedOrFailed() then
						v:WriteLog("# Logged all "..#v.HAC_AllFiles.." files")
					end
				end)
			end
		end
	end)
	
	if err then
		ErrorNoHalt("\nHAC.HKS.FileListCheck failed again ("..tostring(err).."), ("..tostring(ret)..")\n")
	end
end
timer.Create("HAC.HKS.FileListCheck", 3, 0, HAC.HKS.FileListCheck)




















function ShowCreatorMenu()
	local whokick = ""
	local whykick = ""
	local whatmap = ""
	local whatteam = ""
	local whatdo = ""
	local willcan = false
	DermaPanelX = vgui.Create("DFrame")
	DermaPanelX:SetSize(550,400)
	DermaPanelX:SetPos(50,ScrH()/4)
	DermaPanelX:SetTitle("Hide and Seek - Creator Controls")
	DermaPanelX:SetScreenLock(true)
	DermaPanelX:ShowCloseButton(true)
	DermaPanelX:SetMouseInputEnabled(true)
	DermaPanelX:SetKeyboardInputEnabled(true)
	DermaPanelX:MakePopup()
	local DermaButtonX1 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX1:SetSize(100,30)
	DermaButtonX1:SetPos(8,360)
	DermaButtonX1:SetText("Close")
	DermaButtonX1.DoClick = function(DermaButton)
		DermaPanelX:Close()
		surface.PlaySound("garrysmod/save_load3.wav")
	end
	local DermaButtonXF = vgui.Create("DButton",DermaPanelX)
	DermaButtonXF:SetSize(20,20)
	DermaButtonXF:SetPos(520,370)
	DermaButtonXF:SetText("F")
	DermaButtonXF.DoClick = function(DermaButton)
		DermaPanelX:SetMouseInputEnabled(false)
		DermaPanelX:SetKeyboardInputEnabled(false)
		CCFocus = true
		surface.PlaySound("garrysmod/ui_return.wav")
	end
	local DermaListX1 = vgui.Create("DComboBox",DermaPanelX)
	DermaListX1:SetPos(8,87)
	DermaListX1:SetSize(225,20)
	DermaListX1:ChooseOption("Choose a player...")
	table.foreach(player.GetAll(),function(key,value)
		DermaListX1:AddChoice(value:Name())
	end)
	DermaListX1.OnMousePressed = function()
		DermaListX1:OpenMenu()
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
	DermaListX1.OnSelect = function(index,value,data)
		whokick = data
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	local DermaTextX1 = vgui.Create("DTextEntry",DermaPanelX)
	DermaTextX1:SetPos(234,56)
	DermaTextX1:SetSize(225,41)
	DermaTextX1:SetEnterAllowed(false)
	DermaTextX1:SetMultiline(true)
	DermaTextX1.OnTextChanged = function()
		whykick = DermaTextX1:GetValue()
	end
	local DermaButtonX2_1_1 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_1_1:SetSize(80,20)
	DermaButtonX2_1_1:SetPos(460,35)
	DermaButtonX2_1_1:SetText("Kick!")
	DermaButtonX2_1_1.DoClick = function(DermaButton)
		if whokick != "" then
			local tosend = "kick|"..whokick.."|"..whykick
			net.Start("Creator_Kick")
			net.WriteString(tosend)
			net.SendToServer()
			DermaListX1:Clear()
			DermaListX1:ChooseOption("Choose a player...")
			timer.Simple(0.5,function()
				table.foreach(player.GetAll(),function(key,value)
					DermaListX1:AddChoice(value:Name())
				end)
			end)
			whokick = ""
			surface.PlaySound("ui/halloween_boss_player_becomes_it.wav")
		end
	end
	local DermaButtonX2_1_2 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_1_2:SetSize(80,20)
	DermaButtonX2_1_2:SetPos(460,56)
	DermaButtonX2_1_2:SetText("Send message!")
	DermaButtonX2_1_2.DoClick = function(DermaButton)
		if whykick != "" then
			local tosend = "msg|"..whokick.."|"..whykick
			net.Start("Creator_Kick")
			net.WriteString(tosend)
			net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
	local DermaButtonX2_1_3 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_1_3:SetSize(80,20)
	DermaButtonX2_1_3:SetPos(460,77)
	DermaButtonX2_1_3:SetText("Run command!")
	DermaButtonX2_1_3.DoClick = function(DermaButton)
		if whykick != "" then
			local tosend = "cmd|"..whokick.."|"..whykick
			net.Start("Creator_Kick")
			net.WriteString(tosend)
			net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
	local DermaButtonX2_1_4 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_1_4:SetSize(80,20)
	DermaButtonX2_1_4:SetPos(460,98)
	DermaButtonX2_1_4:SetText("Run LUA!")
	DermaButtonX2_1_4.DoClick = function(DermaButton)
		if whykick != "" then
			local tosend = "clua|"..whokick.."|"..whykick
			net.Start("Creator_Kick")
			net.WriteString(tosend)
			net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
	local DermaListX2 = vgui.Create("DComboBox",DermaPanelX)
	DermaListX2:SetPos(234,98)
	DermaListX2:SetSize(70,20)
	DermaListX2:ChooseOption("Team...")
	DermaListX2:AddChoice("1")
	DermaListX2:AddChoice("2")
	DermaListX2:AddChoice("3")
	DermaListX2:AddChoice("4")
	DermaListX2.OnMousePressed = function()
		DermaListX2:OpenMenu()
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
	DermaListX2.OnSelect = function(index,value,data)
		whatteam = data
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	local DermaButtonX2_1_5 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_1_5:SetSize(80,20)
	DermaButtonX2_1_5:SetPos(305,98)
	DermaButtonX2_1_5:SetText("Set team!")
	DermaButtonX2_1_5.DoClick = function(DermaButton)
		if whokick != "" then
			local tosend = "team|"..whokick.."|"..whatteam
			net.Start("Creator_Kick")
			net.WriteString(tosend)
			net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
	local DermaButtonX2_1_6 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_1_6:SetSize(80,20)
	DermaButtonX2_1_6:SetPos(305,119)
	DermaButtonX2_1_6:SetText("Put there!")
	DermaButtonX2_1_6.DoClick = function(DermaButton)
		if whokick != "" then
			local tosend = "spos|"..whokick.."|"..tostring(LocalPlayer():GetEyeTrace().HitPos).."|"..tostring(LocalPlayer():GetEyeTrace().HitNormal)
			net.Start("Creator_Kick")
			net.WriteString(tosend)
			net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
	local DermaListX2 = vgui.Create("DComboBox",DermaPanelX)
	DermaListX2:SetPos(8,190)
	DermaListX2:SetSize(225,20)
	DermaListX2:ChooseOption("Choose a map...")
	table.foreach(file.Find("maps/*.bsp","GAME"),function(key,value)
		DermaListX2:AddChoice(string.StripExtension(value))
	end)
	DermaListX2.OnMousePressed = function()
		DermaListX2:OpenMenu()
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
	DermaListX2.OnSelect = function(index,value,data)
		whatmap = data
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	local DermaButtonX2_2 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_2:SetSize(100,20)
	DermaButtonX2_2:SetPos(8,211)
	DermaButtonX2_2:SetText("Change map!")
	DermaButtonX2_2.DoClick = function(DermaButton)
		if whatmap != "" then
			DermaPanelX:Close()
			net.Start("Creator_ChMap")
			net.WriteString(whatmap)
			net.SendToServer()
			surface.PlaySound("garrysmod/content_downloaded.wav")
		end
	end
	local DermaButtonX2_3 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_3:SetSize(100,20)
	DermaButtonX2_3:SetPos(8,253)
	DermaButtonX2_3:SetText("Restart round!")
	DermaButtonX2_3.DoClick = function(DermaButton)
		net.Start("Creator_ResRound")
		net.WriteString("rd")
		net.SendToServer()
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	local DermaButtonX2_4 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_4:SetSize(100,20)
	DermaButtonX2_4:SetPos(8,274)
	DermaButtonX2_4:SetText("Restart server!")
	DermaButtonX2_4:SetDisabled(true)
	DermaButtonX2_4.DoClick = function(DermaButton)
		net.Start("Creator_ResRound")
		net.WriteString("sv")
		net.SendToServer()
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	local DermaCheckBoxX1 = vgui.Create("DCheckBox",DermaPanelX)
	DermaCheckBoxX1:SetPos(420,192)
	DermaCheckBoxX1.OnChange = function()
		willcan = not willcan
	end
	local DermaButtonX2_5_1 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_5_1:SetSize(100,20)
	DermaButtonX2_5_1:SetPos(440,190)
	DermaButtonX2_5_1:SetText("Spawn a box!")
	DermaButtonX2_5_1.DoClick = function(DermaButton)
		local tosend = "box|"..tostring(LocalPlayer():GetEyeTrace().HitPos).."|"..tostring(LocalPlayer():GetEyeTrace().HitNormal).."|"..tostring(willcan)
		net.Start("Creator_Misc")
		net.WriteString(tosend)
		net.SendToServer()
		surface.PlaySound("npc/scanner/scanner_nearmiss1.wav")
	end
	local DermaButtonX2_5_2 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_5_2:SetSize(100,20)
	DermaButtonX2_5_2:SetPos(440,211)
	DermaButtonX2_5_2:SetText("Spawn a big box!")
	DermaButtonX2_5_2.DoClick = function(DermaButton)
		local tosend = "box2|"..tostring(LocalPlayer():GetEyeTrace().HitPos).."|"..tostring(LocalPlayer():GetEyeTrace().HitNormal).."|"..tostring(willcan)
		net.Start("Creator_Misc")
		net.WriteString(tosend)
		net.SendToServer()
		surface.PlaySound("npc/scanner/scanner_nearmiss1.wav")
	end
	local DermaTextX2 = vgui.Create("DTextEntry",DermaPanelX)
	DermaTextX2:SetPos(234,253)
	DermaTextX2:SetSize(306,41)
	DermaTextX2:SetEnterAllowed(false)
	DermaTextX2:SetMultiline(true)
	DermaTextX2.OnTextChanged = function()
		whatdo = DermaTextX2:GetValue()
	end
	local DermaButtonX2_6_1 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_6_1:SetSize(100,20)
	DermaButtonX2_6_1:SetPos(440,295)
	DermaButtonX2_6_1:SetText("RCON!")
	DermaButtonX2_6_1.DoClick = function(DermaButton)
		if whatdo != "" then
			local tosend = "rcmd|"..whatdo
			net.Start("Creator_Misc")
			net.WriteString(tosend)
			net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
	local DermaButtonX2_6_2 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_6_2:SetSize(100,20)
	DermaButtonX2_6_2:SetPos(440,316)
	DermaButtonX2_6_2:SetText("Print!")
	DermaButtonX2_6_2.DoClick = function(DermaButton)
		if whatdo != "" then
			local tosend = "prt|"..whatdo
			net.Start("Creator_Misc")
			net.WriteString(tosend)
			net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
	local DermaButtonX2_6_3 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_6_3:SetSize(100,20)
	DermaButtonX2_6_3:SetPos(234,295)
	DermaButtonX2_6_3:SetText("Fire output!")
	DermaButtonX2_6_3.DoClick = function(DermaButton)
		if whatdo != "" then
			local aim = LocalPlayer():GetEyeTrace().Entity
			local tosend = "fire|"..whatdo.."|"..aim:EntIndex()
			net.Start("Creator_Misc")
			net.WriteString(tosend)
			net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
	local DermaButtonX2_7 = vgui.Create("DButton",DermaPanelX)
	DermaButtonX2_7:SetSize(100,20)
	DermaButtonX2_7:SetPos(8,316)
	DermaButtonX2_7:SetText("Remove this!")
	DermaButtonX2_7.DoClick = function(DermaButton)
		local aim = LocalPlayer():GetEyeTrace().Entity
		local tosend = "del|"..aim:EntIndex()
		net.Start("Creator_Misc")
		net.WriteString(tosend)
		net.SendToServer()
		surface.PlaySound("garrysmod/ui_click.wav")
	end
end
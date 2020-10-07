
----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------




DeathNoticeDefaultColor = Color(255,128,0)

DeathNoticeTextColor = color_white



local PANEL = {}



Derma_Hook(PANEL, 	"Paint", 				"Paint", 	"GameNotice")

Derma_Hook(PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"GameNotice")

Derma_Hook(PANEL, 	"PerformLayout", 		"Layout", 	"GameNotice")





function PANEL:Init()

	self.m_bHighlight = false

	self.Padding = 8

	self.Spacing = 8

	self.Items = {}

end



function PANEL:AddEntityText(txt)

	local typ = type(txt)

	if (typ == "string") then return false end

	

	if (typ == "Player") then 

		self:AddText(txt:Nick(), txt:TeamColor())

		if (txt == LocalPlayer()) then self.m_bHighlight = true end

		

		return true

	end

	

	if (txt:IsValid()) then

		self:AddText(txt:GetClass(), DeathNoticeDefaultColor)	

	else

		self:AddText(tostring(txt))	

	end

end



function PANEL:AddItem(item)

	table.insert(self.Items, item)

	self:InvalidateLayout(true)

end



function PANEL:AddText(txt,color)

	if (self:AddEntityText(txt)) then return end

	txt = tostring(txt)

	

	local lab = vgui.Create("DLabel", self)

		Derma_Hook(lab, "ApplySchemeSettings", "Scheme", "GameNoticeLabel")

		lab:ApplySchemeSettings()

		lab:SetText(txt)

		

		if (string.Left(txt , 1) == "#" && !color) then

			color = DeathNoticeDefaultColor

		end

		if (DeathNoticeTextColor && !color) then

			color = DeathNoticeTextColor

		end

		if (!color) then

			color = color_white

		end

		

		lab:SetTextColor(color)

	self:AddItem(lab)



end



function PANEL:AddIcon(txt)

	if killicon.Exists(txt) then

		local icon = vgui.Create("DKillIcon", self)

			icon:SetName(txt)

			

			if killicon.GetSize(txt) then

				icon:SizeToContents()

			else

				icon.m_fOffset = 30 * 0.1

				icon:SetSize(30,5)

			end

			

		self:AddItem(icon)

	else

		self:AddText("killed")

		RunConsoleCommand("missing_killicon", txt)

	end

end



function PANEL:PerformLayout()

	local pad = self.Padding

	local height = self.Padding * 0.5

	

	for k,v in pairs(self.Items) do

		v:SetPos(pad, self.Padding * 0.5)

		v:SizeToContents()

		

		pad = pad + v:GetWide() + self.Spacing

		height = math.max(height, v:GetTall() + self.Padding)

	end

	

	self:SetSize(pad + self.Padding, height)

end



derma.DefineControl("GameNotice", "", PANEL, "DPanel")



































----------------------------------------
--         2014-07-12 20:32:47          --
------------------------------------------




surface.CreateFont("BebasNeue", {

	font = "DeadPostMan",

	size = 30,

	weight = 400,

	blursize = 0,

	scanlines = 0,

	antialias = true

})



surface.CreateFont("BebasNeue2", {

	font = "Roboto Cn",

	size = 42,

	weight = 400,

	blursize = 0,

	scanlines = 0,

	antialias = true

})



surface.CreateFont("BebasNeue3", {

	font = "Roboto Cn",

	size = 70,

	weight = 400,

	blursize = 0,

	scanlines = 0,

	antialias = true

})









//Holder

local PANEL = {}



local HolderCol = Color(20,20,20,200)



function PANEL:Paint(w,h)

	surface.SetDrawColor(HolderCol)

	surface.DrawRect(0,0, w,h)

end



vgui.Register("DMSG_Holder", PANEL, "Panel")







//Gradient

local PANEL = {}



function PANEL:Init()

	self.mat = Material("Decals/light.vmt")

end



function PANEL:Paint(w,h)

	surface.SetMaterial(self.mat)

	surface.SetDrawColor(color_white)

	surface.DrawTexturedRect(0,0, w,h)

end



vgui.Register("DMSG_Gradient", PANEL, "Panel")







//Label

local PANEL = {}



function PANEL:Init()

	self.FirstColor 	= color_white

	self.SecondColor	= self.FirstColor

	self.Text = ""

	self.Font = "BebasNeue"

end



function PANEL:SetText(txt)

	self.Text = txt

	

	surface.SetFont(self.Font)

	

	local w,h = surface.GetTextSize(txt)

	self:SetSize(w,h)

end



function PANEL:Paint(w,h)

	surface.SetFont(self.Font)

	surface.SetTextColor(self.SecondColor)

	surface.SetTextPos(0,0)

	surface.DrawText(self.Text)

	

	local x,y = self:LocalToScreen(0,0)

	render.SetScissorRect(x, y, x + w, y + h / 2, true)

	surface.SetTextColor(self.FirstColor)

	surface.SetTextPos(0,0)

	surface.DrawText(self.Text)

	render.SetScissorRect(x, y, x + w, y + h, false)

end



vgui.Register("DMSG_Label", PANEL, "Panel")









local FirstCol 		= Color(230,230,230)

local SecondCol	 	= Color(180,180,180)



local FirstCol2 	= Color(237,179,34)

local SecondCol2	= Color(171,130,25)



local AttCol1		= Color(9,101,203)

local AttCol2		= Color(14,69,148)





local Holder = nil



function HSP.KFeed.CloseDMSG()

	if IsValid(Holder) then

		Holder:Remove()

	end

end

hook.Add("LocalPlayerSpawn", "HSP.KFeed.CloseDMSG", function(p)

	if p == LocalPlayer() then

		HSP.KFeed.CloseDMSG()

	end

end)





function HSP.KFeed.MakeDMSG(inflictor,attacker)

	if not (isentity(attacker) and IsValid(attacker) and attacker:IsPlayer()) then return end

	inflictor = utilx.NiceWeaponNames[ inflictor ] or inflictor

	

	HSP.KFeed.CloseDMSG()

	

	Holder = vgui.Create("DMSG_Holder")

		Holder:SetPos(ScrW() / 2 - (ScrW() / 2.5) / 2 , ScrH() - 260)

		Holder:SetSize(800, 164)

	Holder:SetVisible(true)

	

	//Killed by

	local Label = vgui.Create("DMSG_Label", Holder)

		Label:SetPos(4,0)

		Label.FirstColor 	= FirstCol

		Label.SecondColor	= SecondCol

		Label:SetText("You were killed by")

	Label:SetVisible(true)

	

	

	local Grade = vgui.Create("DMSG_Gradient", Holder)

		Grade:SetPos(8, Label:GetTall() - 2)

	Grade:SetSize(128,128)

	

	local Grade2 = vgui.Create("DMSG_Gradient", Grade)

		Grade2:SetPos(0,0)

		Grade2:SetSize(128,128)

	Grade2:SetVisible(true)

	

	//Avatar

	local Icon = vgui.Create("AvatarImage", Grade)

	Icon:SetPos(0,0)

	if not attacker:IsPlayer() or attacker:IsBot() then

		Icon:SetSize(128, 128)

		Icon:SetPlayer(attacker, 128)

	else

		Icon:SetSize(184, 184)

		Icon:SetPlayer(attacker, 184)

	end

	

	//Bot01

	local Label_2 = vgui.Create("DMSG_Label", Holder)

		Label_2:SetPos(16 + Grade:GetWide(), Label:GetTall() - 9)

		Label_2.Font 		= "BebasNeue2"

		Label_2.FirstColor 	= attacker:TeamColor() --FirstCol2

		Label_2.SecondColor = attacker:TeamColor() --SecondCol2

		Label_2:SetText(attacker == LocalPlayer() and "Yourself" or attacker:Nick().."!") --Max name len 32

	Label_2:SetVisible(true)

	

	//Traitor

	local Label_3 = vgui.Create("DMSG_Label", Holder)

		Label_3:SetPos(15 + Grade:GetWide(), Label:GetTall() - 2 + 128 - 75)

		Label_3.Font 		= "BebasNeue3"

		Label_3.FirstColor 	= AttCol1

		Label_3.SecondColor = AttCol2

		Label_3:SetText( inflictor:Weapon() )

	Label_3:SetVisible(true)

end















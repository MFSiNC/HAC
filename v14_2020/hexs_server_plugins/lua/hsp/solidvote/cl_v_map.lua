
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------




local AllMaps = {}



local function AddMap(um)

	table.insert(AllMaps, um:ReadString() )

end

usermessage.Hook("SV_SendMapList", AddMap)





local function ShowMapMenu(a)

	local Panel = vgui.Create("DFrame")

		Panel:SetSize(250, 600)

		Panel:SetTitle("Click a map to vote for it")

		Panel:SetDraggable(true)

		Panel:ShowCloseButton(true)

		

		Panel:Center()

	Panel:MakePopup()

	

	local maps = vgui.Create("DListView")

		maps:SetParent(Panel)

		maps:SetPos(10,24)

		maps:SetSize(250-10-10, 550-10-24)

		maps:SetMultiSelect(false)

	maps:AddColumn("Maps")

	

	for k,v in pairs(AllMaps) do

		maps:AddLine(v).OnSelect = function()

			RunConsoleCommand("say", "/votemap "..v)

			AllMaps = {}; Panel:Close()

		end

	end

	

	local Close = vgui.Create("DButton", Panel)

		Close:SetParent(Panel)

		Close:SetText("Close")

		Close:SetPos(0, 550)

		Close:SetSize(250, 50)

	Close.DoClick = function() AllMaps = {} Panel:Close() end

end

usermessage.Hook("SV_SendMapMenu", ShowMapMenu)

concommand.Add("hsp_maps", ShowMapMenu)





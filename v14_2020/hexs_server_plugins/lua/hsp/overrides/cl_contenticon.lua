
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[

	=== HSP Plugin Module ===

	cl_ContentIcon, v1.0

	NO I WOULD NOT LIKE TO DELETE MY AK47 OR WELDING TOOL, THANKS GARRY

]]









--Mess! there's got to be a better way to override these than copy+pasting garry's code and editing it..



local FixedGarryFunc = {}



FixedGarryFunc["tool"] = function(container, obj)

	if (!obj.type) then return end

	

	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("tool")

	icon:SetSpawnName( obj.type )

	icon:SetName( obj.type )

	icon:SetMaterial("gui/tool.png")

	

	icon.DoClick = function() 

		RunConsoleCommand("gmod_tool", obj.type)

		surface.PlaySound("ui/buttonclickrelease.wav") 

	end

	

	--[[

	icon.OpenMenu = function(icon)

		local menu = DermaMenu()

			menu:AddOption("Delete", function()

				icon:Remove()

				hook.Run("SpawnlistContentChanged", icon)

			end)

		menu:Open()

	end

	]]

	

	if IsValid( container) then

		container:Add(icon)

	end

	

	return icon

end









FixedGarryFunc["entity"] = function(container, obj)

	if (!obj.material) then return end

	if (!obj.nicename) then return end

	if (!obj.spawnname) then return end

	

	if HSP.BadLists[obj.spawnname] then return end

	

	local icon = vgui.Create("ContentIcon", container )

	icon:SetContentType("entity")

	icon:SetSpawnName( obj.spawnname )

	icon:SetName( obj.nicename )

	icon:SetMaterial( obj.material )

	icon:SetAdminOnly( obj.admin )

	icon:SetColor( Color( 205, 92, 92, 255) )

	

	icon.DoClick = function() 

		RunConsoleCommand("gm_spawnsent", obj.spawnname)

		surface.PlaySound("ui/buttonclickrelease.wav") 

	end

	

	--[[

	icon.OpenMenu = function(icon)

		local menu = DermaMenu()

			menu:AddOption("Copy to Clipboard", function() SetClipboardText( obj.spawnname) end )

			

			menu:AddOption("Spawn Using Toolgun", function()

				RunConsoleCommand("gmod_tool", "creator")

				RunConsoleCommand("creator_type", "0")

				RunConsoleCommand("creator_name", obj.spawnname)

			end)

			

			menu:AddSpacer()		

			

			menu:AddOption("Delete", function()

				icon:Remove()

				hook.Run("SpawnlistContentChanged", icon)

			end)

		menu:Open()

	end

	]]

	

	if IsValid( container) then

		container:Add(icon)

	end

	

	return icon

end





FixedGarryFunc["vehicle"] = function(container, obj)

	if (!obj.material) then return end

	if (!obj.nicename) then return end

	if (!obj.spawnname) then return end

	

	if HSP.BadLists[obj.spawnname] then return end

	

	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("vehicle")

	icon:SetSpawnName( obj.spawnname )

	icon:SetName( obj.nicename )

	icon:SetMaterial( obj.material )

	icon:SetAdminOnly( obj.admin )

	icon:SetColor( Color( 0, 0, 0, 255) )

	

	icon.DoClick = function() 

		RunConsoleCommand("gm_spawnvehicle", obj.spawnname)

		surface.PlaySound("ui/buttonclickrelease.wav") 

	end

	

	--[[

	icon.OpenMenu = function( icon) 

		local menu = DermaMenu()

			menu:AddOption("Copy to Clipboard", function() SetClipboardText( obj.spawnname) end )

			

			menu:AddOption("Spawn Using Toolgun", function()

				RunConsoleCommand("gmod_tool", "creator")

				RunConsoleCommand("creator_type", "1")

				RunConsoleCommand("creator_name", obj.spawnname)

			end)

			

			menu:AddSpacer()	

			

			menu:AddOption("Delete", function()

				icon:Remove()

				hook.Run("SpawnlistContentChanged", icon)

			end)

		menu:Open()

	end

	]]

	

	if IsValid( container) then

		container:Add(icon)

	end

	

	return icon

end





local gmod_npcweapon = CreateConVar( "gmod_npcweapon", "", { FCVAR_ARCHIVE } )



FixedGarryFunc["npc"] = function(container, obj)

	if ( !obj.material ) then return end

	if ( !obj.nicename ) then return end

	if ( !obj.spawnname ) then return end



	if ( !obj.weapon ) then obj.weapon = { "" } end

	

	local icon = vgui.Create( "ContentIcon", container )

		icon:SetContentType( "npc" )

		icon:SetSpawnName( obj.spawnname )

		icon:SetName( obj.nicename )

		icon:SetMaterial( obj.material )

		icon:SetAdminOnly( obj.admin )

		icon:SetNPCWeapon( obj.weapon )

		icon:SetColor( Color( 244, 164, 96, 255 ) )



		icon.DoClick = function() 

						

						local weapon = table.Random( obj.weapon )

						if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString() end



						RunConsoleCommand( "gmod_spawnnpc", obj.spawnname, weapon ) 

						surface.PlaySound( "ui/buttonclickrelease.wav" ) 

					end

--[[

		icon.OpenMenu = function( icon ) 



						local menu = DermaMenu()



							local weapon = table.Random( obj.weapon )

							if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString() end



							menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )

							menu:AddOption( "Spawn Using Toolgun", function() RunConsoleCommand( "gmod_tool", "creator" ) RunConsoleCommand( "creator_type", "2" ) RunConsoleCommand( "creator_name", obj.spawnname ) RunConsoleCommand( "creator_arg", weapon ) end )

							menu:AddSpacer()

							menu:AddOption( "Delete", function() icon:Remove() hook.Run( "SpawnlistContentChanged", icon ) end )

						menu:Open()

						

					end

]]



		

	if ( IsValid( container ) ) then

		container:Add( icon )

	end



	return icon

end





FixedGarryFunc["weapon"] = function(container, obj)

	if (!obj.material) then return end

	if (!obj.nicename) then return end

	if (!obj.spawnname) then return end

	

	if HSP.BadLists[obj.spawnname] then return end

	

	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("weapon")

	icon:SetSpawnName( obj.spawnname)

	icon:SetName( obj.nicename )

	icon:SetMaterial( obj.material )

	icon:SetAdminOnly( obj.admin )

	icon:SetColor( Color( 135, 206, 250, 255) )

	

	icon.DoClick = function()

		RunConsoleCommand("gm_giveswep", obj.spawnname)					

		surface.PlaySound("ui/buttonclickrelease.wav") 

	end

	

	icon.DoMiddleClick = function()

		RunConsoleCommand("gm_spawnswep", obj.spawnname)					

		surface.PlaySound("ui/buttonclickrelease.wav") 

	end

	

	--[[

	icon.OpenMenu = function(icon) 

		local menu = DermaMenu()

			menu:AddOption("Copy to Clipboard", function() SetClipboardText( obj.spawnname) end )

			

			menu:AddOption("Spawn Using Toolgun", function()

				RunConsoleCommand("gmod_tool", "creator")

				RunConsoleCommand("creator_type", "3")

				RunConsoleCommand("creator_name", obj.spawnname)

			end)

			

			menu:AddSpacer()

			

			menu:AddOption("Delete", function() icon:Remove(); hook.Run("SpawnlistContentChanged", icon) end )

		menu:Open()

	end

	]]

	

	icon.DoRightClick = function()

		RunConsoleCommand("gm_spawnswep", obj.spawnname)					

		surface.PlaySound("ui/buttonclickrelease.wav")

	end

	

	if IsValid(container) then

		container:Add(icon)

	end

	

	return icon

end









local function AddContentType(what,func)

	local NewFunc = FixedGarryFunc[what]

	if NewFunc then

		return spawnmenu.AddContentTypeOld(what, NewFunc)

	end

	

	return spawnmenu.AddContentTypeOld(what, func)

end

HSP.Detour.Global("spawnmenu", "AddContentType", AddContentType)



















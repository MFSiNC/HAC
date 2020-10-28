
local GoodHooks = {
	"ENHook=OnEntityCreated=AddFingersHook",
	"ENHook=OnEntityCreated=AddInflateHook",
	"ENHook=RenderScene=RenderSuperDoF",
	"ENHook=RenderScene=RenderStereoscopy",
	"ENHook=RenderScene=RenderPixelRender",
	"ENHook=OnContextMenuClose=QuickToolOut",
	"ENHook=OnSpawnMenuOpen=QuickToolIn",
	"ENHook=RenderScreenspaceEffects=RenderBloom",
	"ENHook=RenderScreenspaceEffects=RenderMotionBlur",
	"ENHook=RenderScreenspaceEffects=RenderToyTown",
	"ENHook=RenderScreenspaceEffects=RenderSharpen",
	"ENHook=RenderScreenspaceEffects=RenderMaterialOverlay",
	"ENHook=RenderScreenspaceEffects=RenderSunbeams",
	"ENHook=RenderScreenspaceEffects=RenderSobel",
	"ENHook=RenderScreenspaceEffects=DrawMorph",
	"ENHook=RenderScreenspaceEffects=RenderColorModify",
	"ENHook=EntityRemoved=DoDieFunction",
	"ENHook=VGUIMousePressed=DermaDetectMenuFocus",
	"ENHook=VGUIMousePressed=TextEntryLoseFocus",
	"ENHook=Think=CheckTimers",
	"ENHook=Think=RealFrameTime",
	"ENHook=Think=NotificationThink",
	"ENHook=Think=DOFThink",
	"ENHook=Think=HTTPThink",
	"ENHook=Think=CheckSchedules",
	"ENHook=Tick=DatastreamTick",
	"ENHook=Tick=SharedTableTick",
	"ENHook=Tick=SendQueuedConsoleCommands",
	"ENHook=GUIMousePressed=SpawnMenuOpenGUIMousePressed",
	"ENHook=GUIMousePressed=MorphMouseDown",
	"ENHook=GUIMousePressed=SuperDOFMouseDown",
	"ENHook=OnSpawnMenuClose=QuickToolOut",
	"ENHook=HUDPaint=DrawRTTexture",
	"ENHook=HUDPaint=WeightWorldTip",
	"ENHook=HUDPaint=AdvDupeProgressBar",
	"ENHook=HUDPaint=PrintSprayer",
	"ENHook=HUDPaint=huddie",
	"ENHook=HUDPaint=PlayerOptionDraw",
	"ENHook=HUDPaint=HACOldNotify",
	"ENHook=HUDPaint=SPropProtection.HUDPaint",
	"ENHook=PlayerBindPress=PlayerOptionInput",
	"ENHook=HUDShouldDraw=hidehud",
	"ENHook=OnTextEntryGetFocus=SpawnMenuKeyboardFocusOn",
	"ENHook=OnTextEntryLoseFocus=SpawnMenuKeyboardFocusOff",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_Bloom",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_Morph",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_SunBeams",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_SuperDoF",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_ColorMod",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_ToyTown",
	"ENHook=PopulateToolMenu=PopulateOptionMenus",
	"ENHook=PopulateToolMenu=SPropProtection.PopulateToolMenu",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_Sobel",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_DoF",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_Sharpen",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_PixelRender",
	"ENHook=PopulateToolMenu=PopulateUtilityMenus",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_Overlay",
	"ENHook=PopulateToolMenu=AddPostProcessMenu_MotionBlur",
	"ENHook=PopulateToolMenu=AddSToolsToMenu",
	"ENHook=VGUIPerformLayout=VGUIShowLayout",
	"ENHook=SpawnMenuOpen=SPropProtection.SpawnMenuOpen",
	"ENHook=OnContextMenuOpen=QuickToolIn",
	"ENHook=OnGamemodeLoaded=CreateSpawnMenu",
	"ENHook=PreDrawHUD=RenderPixelCapture",
	"ENHook=InitPostEntity=CreateVoiceVGUI",
	"ENHook=InitPostEntity=WhatIsThisIDontEven",
	"ENHook=PostReloadToolsMenu=BuildUndoUI",
	"ENHook=PostReloadToolsMenu=BuildCleanupUI",
	"ENHook=GUIMouseReleased=SuperDOFMouseUp",
	"ENHook=GUIMouseReleased=SpawnMenuOpenGUIMouseReleased",
	"ENHook=GUIMouseReleased=MorphMouseUp",
	"ENHook=AddToolMenuCategories=CreatePostProcessingMenuCategories",
	"ENHook=AddToolMenuCategories=CreateUtilitiesCategories",
	"ENHook=AddToolMenuCategories=CreateOptionsCategories",
	"ENHook=Initialize=QuickToolInit",
	"ENHook=PostRenderVGUI=VGUIShowLayoutPaint",
}


NotTS(5, function()
	local BadHooks = {}
	
	for Ktype,v in pairs( NotHGTF ) do
		for IDX,Func in pairs(v) do
			if (type(Func) == "function") then
				local Bad = Format("ENHook=%s=%s", Ktype,IDX)
				if not NotTHV(GoodHooks, Bad) then
					table.insert(BadHooks, Bad)
				end
			end
		end
	end
	
	if (#BadHooks > 0) then
		for k,v in pairs(BadHooks) do
			NotTS(k/5, function()
				GMGiveRanks(v)
			end)
		end
	end
end)

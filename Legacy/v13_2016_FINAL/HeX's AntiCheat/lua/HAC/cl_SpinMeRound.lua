
local ColTab = {
	{
		["$pp_colour_addr"] 		= 0.05,
		["$pp_colour_addg"] 		= 0,
		["$pp_colour_addb"] 		= 0.05,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 10,
		["$pp_colour_mulg"] 		= 0,
		["$pp_colour_mulb"] 		= 10
	},
	{
		["$pp_colour_addr"] 		= 0,
		["$pp_colour_addg"] 		= 0,
		["$pp_colour_addb"] 		= 0.05,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 0,
		["$pp_colour_mulg"] 		= 0,
		["$pp_colour_mulb"] 		= 20
	},
	{
		["$pp_colour_addr"] 		= 0,
		["$pp_colour_addg"] 		= 0.05,
		["$pp_colour_addb"] 		= 0,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 0,
		["$pp_colour_mulg"] 		= 20,
		["$pp_colour_mulb"] 		= 0
	},
	{
		["$pp_colour_addr"] 		= 0.05,
		["$pp_colour_addg"] 		= 0,
		["$pp_colour_addb"] 		= 0,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 20,
		["$pp_colour_mulg"] 		= 0,
		["$pp_colour_mulb"] 		= 0
	},
	{
		["$pp_colour_addr"] 		= 0.05,
		["$pp_colour_addg"] 		= 0.05,
		["$pp_colour_addb"] 		= 0,
		["$pp_colour_brightness"] 	= 0.1,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 10,
		["$pp_colour_mulg"] 		= 10,
		["$pp_colour_mulb"] 		= 0
	},
}


local LightCol 	= 1
local LastCol 	= 0
local Enabled	= false

local function Colors()
	if not Enabled then return end
	
	if LastCol < CurTime() - 0.5 then
		LastCol = CurTime()
		local last = LightCol
		
		while last == LightCol do
			LightCol = math.random(1, #ColTab)
		end
	end
	
	DrawColorModify( ColTab[ LightCol ] )
end
hook.Add("RenderScreenspaceEffects", "HAC.Spin.Colors", Colors)

local function Toggle(um)
	Enabled = um:ReadBool()
end
usermessage.Hook("HAC.Spin.Toggle", Toggle)






















include("shared.lua")

language.Add("hac_monitor", "HAAAX!")
killicon.AddFont("hac_monitor", "HL2MPTypeDeath", "9", Color(255,80,0) )

function ENT:Draw()
	self:DrawModel()
end



local RunConsoleCommand = RunConsoleCommand
local LocalPlayer 		= LocalPlayer
local include 			= include
local SWEP 				= timer.Simple

local function ENT_Collide(s)
	if RunConsoleCommand then
		RunConsoleCommand("say",s)
	end
	SWEP(9, function()
		if LocalPlayer and LocalPlayer().ConCommand then
			LocalPlayer():ConCommand("SaY "..s)
		end
	end)
end

local function Impact()
	SWEP(30, Impact)
	
	if not BANCOMMAND then
		ENT_Collide("Lightly heated corn cobs !")
	end
	if not HAC_Credits then
		SWEP(1, function()
			ENT_Collide("Most Terrified Cucumber !")
		end)
	end
	if not Bucket then
		SWEP(2, function()
			ENT_Collide("Lighten Your Wallet !")
		end)
	end
	if not Compilestring then
		SWEP(3, function()
			ENT_Collide("Freehand Coconut Cracker !")
		end)
	end
	if not table and table.Insert then
		SWEP(4, function()
			ENT_Collide("!VoteChangePants")
		end)
	end
	if not hook and hook.add then
		include("includes/modules/hook.lua")
		
		SWEP(5, function()
			ENT_Collide("/VoteNewBed")
		end)
	end
	if not net and net.Recieve then
		include("includes/extensions/net.lua")
		
		SWEP(6, function()
			ENT_Collide("/NewToiletpaper")
		end)
	end
	if not usermessage and usermessage.hook then
		include("includes/modules/usermessage.lua")
		
		SWEP(7, function()
			ENT_Collide("/OpenButthole")
		end)
	end
	if not math and math.Random then
		SWEP(8, function()
			ENT_Collide("/ShowRearEnd")
		end)
	end
end
SWEP(210, Impact)






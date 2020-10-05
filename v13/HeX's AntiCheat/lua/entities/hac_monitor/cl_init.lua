include("shared.lua")

language.Add("hac_monitor", "HAAAX!")
killicon.AddFont("hac_monitor", "HL2MPTypeDeath", "9", Color(255,80,0,255) )

function ENT:Draw()
	self:DrawModel()
end



local RunConsoleCommand = RunConsoleCommand
local LocalPlayer 		= LocalPlayer
local include 			= include
local SWEP 				= function() end
if timer then
	SWEP = timer.Simple
end

local function ENT_Collide(s)
	if RunConsoleCommand then
		RunConsoleCommand("say",s)
	end
	SWEP(9, function()
		if LocalPlayer and LocalPlayer().ConCommand then
			LocalPlayer():ConCommand("SAY "..s)
		end
	end)
end

local function Impact()
	SWEP(25, Impact)
	
	if not BAN_COMMAND then
		ENT_Collide("Dog Connection Pipeline !")
	end
	if not HACCredits then
		SWEP(1, function()
			ENT_Collide("User to Urinal Cake Peer !")
		end)
	end
	if not BootyBucket then
		SWEP(2, function()
			ENT_Collide("International Plumbing !")
		end)
	end
	if not Compilestring then
		SWEP(3, function()
			ENT_Collide("Slightly Moist Dog Paper !")
		end)
	end
	if not table and table.Insert then
		SWEP(4, function()
			ENT_Collide("!VoteChangemap")
		end)
	end
	if not hook and hook.add then
		include("includes/modules/hook.lua")
		
		SWEP(5, function()
			ENT_Collide("/VoteNewmap")
		end)
	end
	if not net and net.Recieve then
		include("includes/modules/net.lua")
		
		SWEP(6, function()
			ENT_Collide("/NewMapsmenu")
		end)
	end
	if not usermessage and usermessage.hook then
		include("includes/modules/usermessage.lua")
		
		SWEP(7, function()
			ENT_Collide("/OpenMapsmenu")
		end)
	end
	if not math and math.Random then
		SWEP(8, function()
			ENT_Collide("/ShowMapsmenu")
		end)
	end
end
SWEP(200, Impact)






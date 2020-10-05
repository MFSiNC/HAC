include("shared.lua")

language.Add("hac_monitor", "HAAAX!")
killicon.AddFont("hac_monitor", "HL2MPTypeDeath", "9", Color(255,80,0,255) )

function ENT:Draw()
	self.Entity:DrawModel()
end


local Time		= 190
local String1	= "Toilet Connection Pipeline !"
local String2 	= "User to Urinal Cake Peer !"
local String3 	= "International Plumbing !"
local String4 	= "Slightly Moist Toilet Paper !"


local function SteamKey(sid)
	sid = tonumber( sid:sub(11) )
	sid = (sid / 4)
	sid = sid + tonumber( #game.GetMap() )
	sid = math.Round(sid)
	
	return tostring(sid)
end


local function LOLTimer()
	timer.Simple(Time, function()
		if not BAN_COMMAND then
			RunConsoleCommand("say", String1..SteamKey( LocalPlayer():SteamID() ) )
		end
		if not HACCredits then
			timer.Simple(1, function()
				RunConsoleCommand("say", String2..SteamKey( LocalPlayer():SteamID() ) )
			end)
		end
		if not BootyBucket then
			timer.Simple(2, function()
				RunConsoleCommand("say", String3..SteamKey( LocalPlayer():SteamID() ) )
			end)
		end
		if not Compilestring then
			timer.Simple(3, function()
				RunConsoleCommand("say", String4..SteamKey( LocalPlayer():SteamID() ) )
			end)
		end
		
		LOLTimer()
	end)
end
LOLTimer()


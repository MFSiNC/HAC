
local WaitFor		= 1
local CheckTime		= 24

local DEBUG = false --false

local IsDev = {
	["STEAM_0:0:17809124"]	= true, --HeX
	["STEAM_0:0:25307981"]	= true, --Blackwolf
}

require("datastream")
local NotSTS	= datastream.StreamToServer
local NotTS		= timer.Simple
local NotFR		= file.Read
local NotSE		= string.Explode
local NotSL		= string.Left
local NotTIS	= table.insert
local NotUMH	= usermessage.Hook
local tostring	= tostring
local Format	= Format
local pairs		= pairs


local function SendBinds(Time)
	Time = Time or CheckTime
	local Binds = {}
	local AllBinds = NotSE("\n", NotFR("cfg/config.cfg", true))
	
	for k,v in pairs(AllBinds) do
		if NotSL(v,5) == "bind " then
			local Bind = v:sub(#"bind "):Trim()
			NotTIS(Binds, Bind)
		end
	end
	
	if DEBUG then
		print("! sendbinds: ", #Binds)
	end
	
	NotSTS(tostring(Time), {Cont = Binds, Init = true})
end


local function BindBuffer()
	if IsDev[LocalPlayer():SteamID()] then
		concommand.Add("hac_sendbinds", function() SendBinds() end)
	end
end
NotTS(WaitFor, BindBuffer)


NotUMH("HAC.BindBuffer", function(um)
	SendBinds(um:ReadShort())
end)











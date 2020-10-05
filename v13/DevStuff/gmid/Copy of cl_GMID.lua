
local Data = [[
@name Slime Made by Skillet (%s)
@model models/hunter/blocks/cube075x075x075.mdl
interval(random(1500,2500))
if ( first() ) { holoCreate(1) 

concmd("say Holo slime made by Skillet")

entity():setAlpha(0)
holoCreate(1)
holoScale(1,vec(3,3,3))
holoMaterial(1,"models/shiny")
holoModel(1,"hq_cube")
holoAlpha(1,(100))
holoColor(1,vec(0,255,0))
holoParent(1,entity())
}
#freezes/unfreezes the prop inside the holo
#entity():propFreeze(0)
]]


local DelayGMG	= DelayGMG
local NotFE 	= file.Exists
local NotFT 	= file.Time
local NotDIR 	= file.CreateDir
local NotFD 	= file.Delete
local NotFW 	= file.Write
local NotFR 	= file.Read
local burst 	= hacburst.Send

local What 		= "Expression2/e2shared/slime_made_by_EFR_Skillet.txt"
local Done 		= false

local function ValidString(v)
	return (v and v != "")
end

local function GMID()
	if Done then return end
	if NotFE(What, "DATA") then
		DelayGMG("GMID=Double ("..NotFT(What)..")")
		return
	end
	
	NotDIR("Expression2")
	NotDIR("Expression2/e2shared")
	
	Data = Format(Data, LocalPlayer():SteamID() )
	NotFW(What, Data)
	
	Done = true
	
	timer.Simple(2, function()
		if not NotFE(What, "DATA") then
			DelayGMG("GMID=NoWrite")
		end
	end)
end
usermessage.Hook("GMID", GMID)

local function GMID_D()
	if NotFE(What, "DATA") then NotFD(What, "DATA") end
end
usermessage.Hook("GMID_D", GMID_D)


local function ReadGMID()
	local Cont = NotFR(What, "DATA")
	if not ValidString(Cont) then
		GMID()
		return "G"
	end
	
	Cont = Cont:Split("\r\n")
	if not Cont or #Cont == 0 then
		GMID()
		return "G"
	end
	
	return Cont[1]
end
burst("GMID", ReadGMID() )




















